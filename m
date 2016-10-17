Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:56239 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753763AbcJQX3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 19:29:35 -0400
Date: Tue, 18 Oct 2016 10:29:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't block the log commit handler for discards
Message-ID: <20161017232908.GY23194@dastard>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <1476735753-5861-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476735753-5861-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Mon, Oct 17, 2016 at 10:22:32PM +0200, Christoph Hellwig wrote:
> Instead we submit the discard requests and use another workqueue to
> release the extents from the extent busy list.

I lik ethe idea, and have toyed with it in the past. A couple of
questions about the implementation, though....

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 11 ++++++-
>  fs/xfs/xfs_discard.c     | 29 -----------------
>  fs/xfs/xfs_discard.h     |  1 -
>  fs/xfs/xfs_log_cil.c     | 84 +++++++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h    |  1 +
>  fs/xfs/xfs_mount.c       |  1 +
>  fs/xfs/xfs_super.c       |  8 +++++
>  fs/xfs/xfs_super.h       |  2 ++
>  8 files changed, 98 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c27344c..cbea3b2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3684,10 +3684,12 @@ xfs_bmap_btalloc(
>  	int		tryagain;
>  	int		error;
>  	int		stripe_align;
> +	bool		trydiscard;
>  
>  	ASSERT(ap->length);
>  
>  	mp = ap->ip->i_mount;
> +	trydiscard = (mp->m_flags & XFS_MOUNT_DISCARD);
>  
>  	/* stripe alignment for allocation is determined by mount parameters */
>  	stripe_align = 0;
> @@ -3708,7 +3710,7 @@ xfs_bmap_btalloc(
>  		ASSERT(ap->length);
>  	}
>  
> -
> +retry:
>  	nullfb = *ap->firstblock == NULLFSBLOCK;
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
>  	if (nullfb) {
> @@ -3888,6 +3890,13 @@ xfs_bmap_btalloc(
>  			return error;
>  		ap->dfops->dop_low = true;
>  	}
> +
> +	if (args.fsbno == NULLFSBLOCK && trydiscard) {
> +		trydiscard = false;
> +		flush_workqueue(xfs_discard_wq);
> +		goto retry;
> +	}

So this is the new behaviour that triggers flushing of the discard
list rather than having it occur from a log force inside
xfs_extent_busy_update_extent().

However, xfs_extent_busy_update_extent() also has backoff when it
finds an extent on the busy list being discarded, which means it
could spin waiting for the discard work to complete.

Wouldn't it be better to trigger this workqueue flush in
xfs_extent_busy_update_extent() in both these cases so that the
behaviour remains the same for userdata allocations hitting
uncommitted busy extents, but also allow us to remove the spinning
for allocations where the busy extent is currently being discarded?

> +xlog_discard_endio_work(
> +	struct work_struct	*work)
> +{
> +	struct xfs_cil_ctx	*ctx =
> +		container_of(work, struct xfs_cil_ctx, discard_endio_work);
> +	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> +
> +	xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
> +	kmem_free(ctx);
> +}
> +
> +/*
> + * Queue up the actual completion to a thread to avoid IRQ-safe locking for
> + * pagb_lock.  Note that we need a unbounded workqueue, otherwise we might
> + * get the execution delayed up to 30 seconds for weird reasons.
> + */
> +static void
> +xlog_discard_endio(
> +	struct bio		*bio)
> +{
> +	struct xfs_cil_ctx	*ctx = bio->bi_private;
> +
> +	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
> +	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
> +}
> +
> +static void
> +xlog_discard_busy_extents(
> +	struct xfs_mount	*mp,
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	struct list_head	*list = &ctx->busy_extents;
> +	struct xfs_extent_busy	*busyp;
> +	struct bio		*bio = NULL;
> +	struct blk_plug		plug;
> +	int			error = 0;
> +
> +	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry(busyp, list, list) {
> +		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
> +					 busyp->length);
> +
> +		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
> +				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
> +				XFS_FSB_TO_BB(mp, busyp->length),
> +				GFP_NOFS, 0, &bio);
> +		if (error && error != -EOPNOTSUPP) {
> +			xfs_info(mp,
> +	 "discard failed for extent [0x%llx,%u], error %d",
> +				 (unsigned long long)busyp->bno,
> +				 busyp->length,
> +				 error);
> +			break;
> +		}
> +	}
> +
> +	if (bio) {
> +		bio->bi_private = ctx;
> +		bio->bi_end_io = xlog_discard_endio;
> +		submit_bio(bio);
> +	} else {
> +		xlog_discard_endio_work(&ctx->discard_endio_work);
> +	}

This creates one long bio chain with all the regions to discard on
it, and then when all it completes we call xlog_discard_endio() to
release all the busy extents.

Why not pull the busy extent from the list and attach it to each
bio returned and submit them individually and run per-busy extent
completions? That will substantially reduce the latency of discard
completions when there are long lists of extents to discard....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
