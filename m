Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AHc3H8114361 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:38:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 036C0149E9A6
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:40:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id T9ixwyNzgTzORpUE for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:40:54 -0800 (PST)
Date: Thu, 10 Mar 2011 12:40:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: introduce background inode reclaim work
Message-ID: <20110310174054.GD19609@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299715529-11026-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Why do we still keep the inode reclaim in the syncer work?  If we
already have this one doing it I don't think we need it there as well.

>  /*
> + * Queue a new inode reclaim pass if there isn't one already in progress.
> + * Wait for completion of the flush if necessary.

No, it doesn't wait ever.

> + */
> +static void
> +xfs_syncd_queue_reclaim(
> +	struct xfs_mount        *mp)
> +{
> +	queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> +			xfs_syncd_centisecs / 5 * msecs_to_jiffies(10));

What explanation is there for the magic 5?  E.g. why do we neeed to run
it exactly 5 times as often as the normal sync work? Should it have it's
own tunable?  And isn't ever 6 seconds by default a little often on
systems trying to saver power, especiall if there aren't any inodes to
reclaim?  Should we trigger starting this work off having reclaimable
inodes tagged in the radix tree?

> +	/* first unpin all the dirty and stale inodes. */
> +	xfs_log_force(mp, XFS_LOG_SYNC);

So we force out the log every 6 seconds.  That's a lot more often than
most other filesystem and might have adverse performance impact.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
