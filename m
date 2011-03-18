Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2I3al3R010819 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 22:36:53 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6480710AFF76
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 20:39:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZhJD9pyMbMJksBLk for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2011 20:39:43 -0700 (PDT)
Date: Fri, 18 Mar 2011 14:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: convert ENOSPC inode flushing to use new
	syncd workqueue
Message-ID: <20110318033936.GE30195@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-4-git-send-email-david@fromorbit.com>
	<20110310173549.GC19609@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310173549.GC19609@infradead.org>
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

On Thu, Mar 10, 2011 at 12:35:49PM -0500, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +STATIC void
> > +xfs_flush_worker(
> > +	struct work_struct *work)
> > +{
> > +	struct xfs_mount *mp = container_of(work,
> > +					struct xfs_mount, m_flush_work);
> > +
> > +	xfs_sync_data(mp, SYNC_TRYLOCK);
> > +	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
> > +	xfs_log_force(mp, XFS_LOG_SYNC);
> 
> No actually new in this patch: but what's the point of the log force
> here?  xfs_sync_data just did one before returning.

Historical, I think. Removed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
