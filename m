Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23Mf0tO118051 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 16:41:00 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A827C310E4D
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 14:43:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8PkFaerEeqbBjWvL for <xfs@oss.sgi.com>;
	Thu, 03 Mar 2011 14:43:50 -0800 (PST)
Date: Fri, 4 Mar 2011 09:43:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: introduce background inode reclaim work
Message-ID: <20110303224338.GQ15097@dastard>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-5-git-send-email-david@fromorbit.com>
	<20110303153634.GB27205@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303153634.GB27205@infradead.org>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

On Thu, Mar 03, 2011 at 10:36:34AM -0500, Christoph Hellwig wrote:
> > +void
> > +xfs_syncd_queue_reclaim(
> > +	struct xfs_mount        *mp,
> > +	int			flags)
> > +{
> > +	mutex_lock(&xfs_syncd_lock);
> > +	if (!delayed_work_pending(&mp->m_reclaim_work))
> > +		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
> > +			xfs_syncd_centisecs / 5 * msecs_to_jiffies(10));
> > +	mutex_unlock(&xfs_syncd_lock);
> > +
> > +	if (flags & SYNC_WAIT)
> > +		flush_delayed_work_sync(&mp->m_reclaim_work);
> > +}
> 
> queue_work/queue_delayed_work have a test_set_bit on
> WORK_STRUCT_PENDING_BIT, so can just call queue_work/queue_delayed_work
> and it will do the right thing if it is in use.  So you can remove the
> mutex and delayed_work_pending check here.
> 

Yup, it's already gone. :)

> At least currently SYNC_WAIT is never set by any caller, and I wonder if
> we should just leave the waiting to the caller if we ever grow one.

I can remove it - it is a left over from testing different methods
of throttling the shrinker.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
