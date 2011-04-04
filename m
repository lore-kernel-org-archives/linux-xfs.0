Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3428S14140233 for <xfs@oss.sgi.com>; Sun, 3 Apr 2011 21:08:28 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83F7539C7FA
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2011 19:11:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ejAYEW2zFHT0cBfp for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2011 19:11:41 -0700 (PDT)
Date: Mon, 4 Apr 2011 12:11:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110404021138.GN6957@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
	<20110310174818.GE19609@infradead.org>
	<20110318040648.GG30195@dastard>
	<20110319134500.GB10056@infradead.org>
	<20110403003847.GI6957@dastard>
	<20110403105957.GB3872@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110403105957.GB3872@infradead.org>
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

On Sun, Apr 03, 2011 at 06:59:57AM -0400, Christoph Hellwig wrote:
> On Sun, Apr 03, 2011 at 10:38:47AM +1000, Dave Chinner wrote:
> > FWIW, we already have an implicit delay for frequent callers when
> > the AIL is busy - the uninterruptible sleep for  sleeps of <= 20ms.
> > That was implemented specifically to rate-limit wakeups while the
> > xfsaild was busy pushing. This is essentially a different
> > implementation of the same mechanism.
> 
> In that cases maybe the minum delay of the delayed work should stay
> at 20ms?

I've been looking at this a little more - I don't think the
work_pending() check is sufficient. The pending bit is cleared
before the work function is called, so while the work is executing
we can queue up another work. That means when the work completes and
decides it needs to back off for a short while, it won't back off
because new work has been been queued and the pending bit has been
set.

Hence I thinkthis needs an external "work running" bit to be set so
that the backoff works as expected. That is, when pushing the tail
we need to do:

	ailp->xa_target = threshold_lsn;
	if (test_and_set_bit(ailp->pushing))
		queue_delayed_work(work, 0);

When the AIL work function needs to back off for a certain timeout,
it just does:

	queue_delayed_work(work, tout);

and when it completes the push, it does:

	clear_bit(ailp->pushing);

So the next tail push requeues the work again. That gets around the
need for implicit wakeup rate limiting, allows tail pushing to keep
moving the target forwards while the work is running, and doesn't
allow tail pushing to impact on a running push.

I'll modify it to do this - it should also simplify the code as
well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
