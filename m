Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2I43u0w011980 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 23:04:01 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A47635F4F0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 21:06:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wZsjFldK11iTyUGH for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2011 21:06:52 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:06:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110318040648.GG30195@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-6-git-send-email-david@fromorbit.com>
	<20110310174818.GE19609@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310174818.GE19609@infradead.org>
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

On Thu, Mar 10, 2011 at 12:48:18PM -0500, Christoph Hellwig wrote:
> >  STATIC int __init
> > +xfs_init_workqueues(void)
> 
> > +STATIC void __exit
> > +xfs_destroy_workqueues(void)
> 
> I don't think these helpers are overly useful.

I'm thinking of adding a few more workqueues, so I though I'd split
them out like zone initialisation at the outset....

> 
> > +	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
> 
> > +}
> 
> 
> > +static void
> > +xfs_ail_push_queue(
> > +	struct xfs_ail		*ailp,
> > +	xfs_lsn_t		threshold_lsn,
> > +	int			tout)
> > +{
> > +	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
> > +		ailp->xa_target = threshold_lsn;
> > +		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, tout);
> 
> tout is always one in the only caller and thus doesn't need to be
> passed.  But I think you really want a timeout of 0 here to queue it up
> ASAP (it translates to a direct queue_work() call internally).
> 
> Also this function could simply be merged into it's only and relatively
> simple caller.

It gets used by a second caller in the next patch that uses a
timeout of zero. The idea of adding a delay to a normal push is to
rate limit the number of times we do work so we always work on
batches rather a few items at a time in multiple executions of the
work.

I'll see if it's simpler to just do this work directly in teh
callers, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
