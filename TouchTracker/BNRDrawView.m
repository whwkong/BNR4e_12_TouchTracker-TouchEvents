//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by William Kong on 2014-05-28.
//  Copyright (c) 2014 William Kong. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()
@property (nonatomic, strong) BNRLine *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end

@implementation BNRDrawView

#pragma mark - View life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.multipleTouchEnabled = YES; 
    }
    
    return self;
}

#pragma mark - Drawing methods
- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{
    // Draw finished lines in black
    [[UIColor blackColor] set];
    
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    if (self.currentLine) {
        [[UIColor redColor] set];
        [self strokeLine:self.currentLine];
    }
}

#pragma mark - Responder Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    
    // Get location of touch in view's coordinate system
    CGPoint location = [t locationInView:self];
    
    self.currentLine = [[BNRLine alloc] init];
    self.currentLine.begin = location;
    self.currentLine.end = location;
    
    // marks the receiver’s entire bounds rectangle as needing to be redrawn.
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint location = [t locationInView:self];
    
    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.finishedLines addObject:self.currentLine];
    
    self.currentLine = nil;
    
    [self setNeedsDisplay];
}

@end
