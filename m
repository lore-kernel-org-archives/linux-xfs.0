Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p330Zccn070920 for <xfs@oss.sgi.com>; Sat, 2 Apr 2011 19:35:39 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 638951DFED3B
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2011 17:38:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BKQqobHPtdN0ASYE for <xfs@oss.sgi.com>;
	Sat, 02 Apr 2011 17:38:51 -0700 (PDT)
Date: Sun, 3 Apr 2011 10:38:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110403003847.GI6957@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
	<20110310174818.GE19609@infradead.org>
	<20110318040648.GG30195@dastard>
	<20110319134500.GB10056@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110319134500.GB10056@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Mar 19, 2011 at 09:45:00AM -0400, Christoph Hellwig wrote:
> On Fri, Mar 18, 2011 at 03:06:48PM +1100, Dave Chinner wrote:
> > It gets used by a second caller in the next patch that uses a
> > timeout of zero. The idea of adding a delay to a normal push is to
> > rate limit the number of times we do work so we always work on
> > batches rather a few items at a time in multiple executions of the
> > work.
> >
> > I'll see if it's simpler to just do this work directly in teh
> > callers, though.
> 
> I don't think hiding this delay (uncommented) in the workqueue use is
> a good idea.

FWIW, we already have an implicit delay for frequent callers when
the AIL is busy - the uninterruptible sleep for  sleeps of <= 20ms.
That was implemented specifically to rate-limit wakeups while the
xfsaild was busy pushing. This is essentially a different
implementation of the same mechanism.

> xlog_grant_push_ail has all the logics about when to push
> the AIL, so any batching should be grouped with that logic, and
> documented there.  It in fact already has some comments static that
> a min/max watermark scheme would be useful.

Yes, it does, but that's a much bigger change that has some
potentially nasty problems like ensuring the watermarks are always a
sane distance apart which is difficult to do on small logs were a
single transaction reservation can easily be larger than 10% of the
log. Hence watermarks are a much harder change to validate and tune
compared to a simple push wakeup rate-limit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
