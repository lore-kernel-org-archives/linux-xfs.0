Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DA4DBg022200 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:04:13 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KaAKNdt5zquDgwKi for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 03:04:11 -0700 (PDT)
Date: Fri, 13 Apr 2012 20:04:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
Message-ID: <20120413100409.GH6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164644.830680325@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:04PM -0400, Christoph Hellwig wrote:
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

Probably don't need this bit in the commit message - the previous
commits kind of explain the reason....

> Also treat unmount the same way as freeze now, except that we still keep a
> synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.

Actaully, I think we need an inode reclaim pass when freezing, too,
otherwise the shrinker or background reclaim will get stuck trying
to reclaim them.

.....

> -STATIC void
> -xfs_quiesce_fs(
> -	struct xfs_mount	*mp)
> -{
> -	int	count = 0, pincount;
> -
> -	xfs_reclaim_inodes(mp, 0);
> -	xfs_flush_buftarg(mp->m_ddev_targp, 0);

here's where we used to do inode reclaim during a freeze...

....
> @@ -421,8 +342,8 @@ xfs_quiesce_attr(
>  	while (atomic_read(&mp->m_active_trans) > 0)
>  		delay(100);
>  
> -	/* flush inodes and push all remaining buffers out to disk */
> -	xfs_quiesce_fs(mp);
> +	/* flush all pending changes from the AIL */
> +	xfs_ail_push_all_sync(mp->m_ail);

and now that doesn't happen. I think we still need the reclaim pass
here...

> @@ -397,6 +396,15 @@ xfsaild_push(
>  	XFS_STATS_INC(xs_push_ail);
>  
>  	/*
> +	 * If we are draining the AIL push all items, not just the current
> +	 * threshold.
> +	 */
> +	if (atomic_read(&ailp->xa_wait_empty))
> +		target = xfs_ail_max(ailp)->li_lsn;
> +	else
> +		target = ailp->xa_target;
> +

I'm not sure this is the best way to do this. Effectively you've
implemented xfs_ail_push_all() differently, and added a new counter
to do it.

....
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

if we just set the target here appropriately, we don't need the
atomic counter, just:

	do {
		prepare_to_wait()
		ailp->xa_target = xfs_ail_max(ailp)->li_lsn;
		wake_up_process(ailp->xa_task);
		if (!xfs_ail_min_lsn(ailp))
			break;
		schedule();
	} while (xfs_ail_min_lsn(ailp));


All the other changes look OK.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
