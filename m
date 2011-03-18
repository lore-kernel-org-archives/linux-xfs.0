Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2I3vDl0011696 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 22:57:18 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC9CB35F41E
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 21:00:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fISve0W2euvQuBkO for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2011 21:00:09 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:00:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: introduce background inode reclaim work
Message-ID: <20110318040006.GF30195@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-5-git-send-email-david@fromorbit.com>
	<20110310174054.GD19609@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310174054.GD19609@infradead.org>
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

On Thu, Mar 10, 2011 at 12:40:54PM -0500, Christoph Hellwig wrote:
> Why do we still keep the inode reclaim in the syncer work?  If we
> already have this one doing it I don't think we need it there as well.

Ok. Removed.

> >  /*
> > + * Queue a new inode reclaim pass if there isn't one already in progress.
> > + * Wait for completion of the flush if necessary.
> 
> No, it doesn't wait ever.

Removed.

> > + */
> > +static void
> > +xfs_syncd_queue_reclaim(
> > +	struct xfs_mount        *mp)
> > +{
> > +	queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> > +			xfs_syncd_centisecs / 5 * msecs_to_jiffies(10));
> 
> What explanation is there for the magic 5?  E.g. why do we neeed to run
> it exactly 5 times as often as the normal sync work?

It doesn't have to be exactly 5x more frequent, just that it needs
to run quite a bit more often than the normal sync work. tens times
more often seems like overkill and a lot of overhead given the scan
reclaim does, while two times more often isn't sufficient to avoid
significant build up of dirty reclaimable inodes that need to be
written before they can be reclaimed..

> Should it have it's
> own tunable?

Perhaps. I'm not convinced it is necessary, though.

> And isn't ever 6 seconds by default a little often on
> systems trying to saver power, especiall if there aren't any inodes to
> reclaim?  Should we trigger starting this work off having reclaimable
> inodes tagged in the radix tree?

Yes, probably should. I'll see if I can do that easily.


> > +	/* first unpin all the dirty and stale inodes. */
> > +	xfs_log_force(mp, XFS_LOG_SYNC);
> 
> So we force out the log every 6 seconds.  That's a lot more often than
> most other filesystem and might have adverse performance impact.

I'll remove that and leave it for the sync inode reclaim to force
out the log...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
