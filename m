Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LNw1qc146453 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 18:58:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UzGoGBEDzPGGEPvT for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 16:57:59 -0700 (PDT)
Date: Thu, 22 Mar 2012 10:57:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: implement freezing by emptying the AIL
Message-ID: <20120321235738.GB5091@dastard>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.554421689@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120316175636.554421689@bombadil.infradead.org>
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

On Fri, Mar 16, 2012 at 01:55:45PM -0400, Christoph Hellwig wrote:
> Now that we write back all metadata either synchronously or through the AIL
> we can simply implement metadata freezing in terms of emptying the AIL.
> 
> The implementation for this is fairly simply and straight-forward:  A new
> routine is added that increments a counter that tells xfsaild to not stop
> until the AIL is empty and then waits on a wakeup from
> xfs_trans_ail_delete_bulk to signal that the AIL is empty.
> 
> As usual the devil is in the details, in this case the filesystem shutdown
> code.  Currently we are a bit sloppy there and do not continue ail pushing
> in that case, and thus never reach the code in the log item implementations
> that can unwind in case of a shutdown filesystem.  Also the code to 
> abort inode and dquot flushes was rather sloppy before and did not remove
> the log items from the AIL, which had to be fixed as well.
> 
> Also treat unmount the same way as freeze now, except that we still keep a
> synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.
> 
> As an upside we can now remove the radix tree based inode writeback and
> xfs_unmountfs_writesb.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> @@ -397,6 +396,15 @@ xfsaild_push(
>  	XFS_STATS_INC(xs_push_ail);
>  
>  	/*
> +	 * If we are draining the AIL push all items, not just the current
> +	 * threshold.
> +	 */
> +	if (atomic_read(&ailp->xa_wait_empty))
> +		target = xfs_ail_max(ailp)->li_lsn;

I don't think this is safe - we may have finished pushing the AIL to
empty, but the waiter that decrements xa_wait_empty may not have run
yet and we can race with that. In that case, xfs_ail_max() will
return NULL as the AIL is empty.

.....

> @@ -611,6 +614,34 @@ xfs_ail_push_all(
>  }
>  
>  /*
> + * Push out all items in the AIL immediately and wait until the AIL is empty.
> + */
> +void
> +xfs_ail_push_all_sync(
> +	struct xfs_ail  *ailp)
> +{
> +	DEFINE_WAIT(wait);
> +
> +	/*
> +	 * We use a counter instead of a flag here to support multiple
> +	 * processes calling into sync at the same time.
> +	 */
> +	atomic_inc(&ailp->xa_wait_empty);
> +	do {
> +		prepare_to_wait(&ailp->xa_empty, &wait, TASK_KILLABLE);

Why a killable wait? We need to wait until the push is complete
before returning because we can't return an error and we don't want
ctrl-c to break out of this loop while writeback it still taking
place on a non-shutdown based unmount (e.g. got thousands of inodes
to write on a slow RAID5 device doing RMW cycles for every inode).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
