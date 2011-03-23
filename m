Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N0eRCn058108 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 19:40:32 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1403C1DF2983
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 17:43:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	m1F4Wz2W40DDJcvi for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 17:43:25 -0700 (PDT)
Date: Wed, 23 Mar 2011 11:43:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: make discard operations asynchronous
Message-ID: <20110323004323.GH15270@dastard>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.216042448@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322200138.216042448@bombadil.infradead.org>
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

On Tue, Mar 22, 2011 at 03:55:56PM -0400, Christoph Hellwig wrote:
> Instead of waiting for each discard request keep the CIL context alive
> until all of them are done, at which point we can tear it down completly
> and remove the busy extents from the rbtree.
> 
> At this point I'm doing the I/O completion from IRQ context for simplicity,
> but I'll benchmark it against a version that uses a workqueue.

A workqueue is probably a good idea, because then the processing has
some level of concurrency built into it. It also means we don't need
to convert the locking to irq-safe variants and all the overhead
that this introduces.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-03-22 15:58:10.301855813 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-03-22 18:39:09.000000000 +0100
> @@ -30,6 +30,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_discard.h"
>  #include "xfs_trace.h"
>  
> @@ -192,37 +193,119 @@ xfs_ioc_trim(
>  	return 0;
>  }
>  
> +void
> +xfs_cil_discard_done(
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	if (atomic_dec_and_test(&ctx->discards)) {
> +		struct xfs_busy_extent	*busyp, *n;
> +
> +		list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
> +			xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
> +		kmem_free(ctx);
> +	}
> +}
> +
> +STATIC void
> +xfs_discard_end_io(
> +	struct bio		*bio,
> +	int			err)
> +{
> +	struct xfs_cil_ctx	*ctx = bio->bi_private;
> +
> +	if (err && err != -EOPNOTSUPP) {
> +		xfs_info(ctx->cil->xc_log->l_mp,
> +			 "I/O error during discard\n");
> +	}

Same comment about the bno/len in the error message as the previous
patch.

> +
> +	bio_put(bio);
> +	xfs_cil_discard_done(ctx);
> +}
> +
> +static int
> +xfs_issue_discard(
> +	struct block_device	*bdev,
> +	sector_t		sector,
> +	sector_t		nr_sects,
> +	gfp_t			gfp_mask,
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	struct request_queue	*q = bdev_get_queue(bdev);
> +	unsigned int		max_discard_sectors;
> +	struct bio		*bio;
> +	int			ret = 0;
> +
> +	if (!q)
> +		return -ENXIO;
> +
> +	if (!blk_queue_discard(q))
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Ensure that max_discard_sectors is of the proper
> +	 * granularity
> +	 */
> +	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> +	if (q->limits.discard_granularity) {
> +		unsigned int disc_sects = q->limits.discard_granularity >> 9;
> +
> +		max_discard_sectors &= ~(disc_sects - 1);
> +	}

This is asking for a helper function....

> +
> +
> +	while (nr_sects && !ret) {

no need to check ret here.

> +		bio = bio_alloc(gfp_mask, 1);
> +		if (!bio) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		bio->bi_sector = sector;
> +		bio->bi_end_io = xfs_discard_end_io;
> +		bio->bi_bdev = bdev;
> +		bio->bi_private = ctx;
> +
> +		if (nr_sects > max_discard_sectors) {
> +			bio->bi_size = max_discard_sectors << 9;
> +			nr_sects -= max_discard_sectors;
> +			sector += max_discard_sectors;
> +		} else {
> +			bio->bi_size = nr_sects << 9;
> +			nr_sects = 0;
> +		}
> +
> +		atomic_inc(&ctx->discards);
> +		submit_bio(REQ_WRITE | REQ_DISCARD, bio);
> +	}
> +
> +	return ret;
> +}
> +
>  int
>  xfs_discard_extent(
>  	struct xfs_mount	*mp,
> -	struct xfs_busy_extent	*busyp)
> +	struct xfs_busy_extent	*busyp,
> +	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xfs_perag	*pag;
> -	int			error = 0;
>  	xfs_daddr_t		bno;
>  	int64_t			len;
>  	bool			done  = false;
>  
> -	if ((mp->m_flags & XFS_MOUNT_DISCARD) == 0)
> -		return 0;
> -
>  	bno = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
>  	len = XFS_FSB_TO_BB(mp, busyp->length);
>  
>  	pag = xfs_perag_get(mp, busyp->agno);
> -	spin_lock(&pag->pagb_lock);
> +	spin_lock_irq(&pag->pagb_lock);
>  	if (!busyp->length)
>  		done = true;
>  	busyp->flags = XFS_ALLOC_BUSY_DISCARDED;
> -	spin_unlock(&pag->pagb_lock);
> +	spin_unlock_irq(&pag->pagb_lock);

Disabling/enabling interrupts on these locks could hurt quite a bit.
They are travelled quite frequently, and irq operations add quite a
bit of overhead....

>  	xfs_perag_put(pag);
>  
>  	if (done)
>  		return 0;
>  
> -	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, bno, len,
> -				      GFP_NOFS, 0);
> -	if (error && error != EOPNOTSUPP)
> -		xfs_info(mp, "discard failed, error %d", error);
> -	return error;
> +	return -xfs_issue_discard(mp->m_ddev_targp->bt_bdev,
> +				  bno, len, GFP_NOFS, ctx);
>  }
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_discard.h	2011-03-22 15:58:10.313857879 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-03-22 18:39:09.000000000 +0100
> @@ -3,10 +3,13 @@
>  
>  struct fstrim_range;
>  struct xfs_busy_extent;
> +struct xfs_cil_ctx;
>  
>  extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
>  
>  extern int	xfs_discard_extent(struct xfs_mount *,
> -				   struct xfs_busy_extent *);
> +				   struct xfs_busy_extent *,
> +				   struct xfs_cil_ctx *);
> +extern void	xfs_cil_discard_done(struct xfs_cil_ctx	*ctx);
>  
>  #endif /* XFS_DISCARD_H */
> Index: xfs/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_cil.c	2011-03-22 15:58:10.329855977 +0100
> +++ xfs/fs/xfs/xfs_log_cil.c	2011-03-22 18:39:09.000000000 +0100
> @@ -68,6 +68,7 @@ xlog_cil_init(
>  	INIT_LIST_HEAD(&ctx->busy_extents);
>  	ctx->sequence = 1;
>  	ctx->cil = cil;
> +	atomic_set(&ctx->discards, 1);
>  	cil->xc_ctx = ctx;
>  	cil->xc_current_sequence = ctx->sequence;
>  
> @@ -364,14 +365,18 @@ xlog_cil_committed(
>  	struct xfs_cil_ctx	*ctx = args;
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
>  	struct xfs_busy_extent	*busyp, *n;
> +	bool			keep_alive = false;
>  
>  	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
>  					ctx->start_lsn, abort);
>  
> -	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list) {
> -		if (!abort)
> -			xfs_discard_extent(mp, busyp);
> -		xfs_alloc_busy_clear(mp, busyp);
> +	if (!(mp->m_flags & XFS_MOUNT_DISCARD) || abort) {
> +		list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
> +			xfs_alloc_busy_clear(mp, busyp);
> +	} else if (!list_empty(&ctx->busy_extents)) {
> +		list_for_each_entry(busyp, &ctx->busy_extents, list)
> +			xfs_discard_extent(mp, busyp, ctx);
> +		keep_alive = true;
>  	}

Oh, I see you've moved the XFS_MOUNT_DISCARD into the loop here...

>  
>  	spin_lock(&ctx->cil->xc_cil_lock);
> @@ -379,7 +384,10 @@ xlog_cil_committed(
>  	spin_unlock(&ctx->cil->xc_cil_lock);
>  
>  	xlog_cil_free_logvec(ctx->lv_chain);
> -	kmem_free(ctx);
> +	if (keep_alive)
> +		xfs_cil_discard_done(ctx);
> +	else
> +		kmem_free(ctx);

You could probably just call xfs_cil_discard_done(ctx) here as the
busy extent list will be empty in the !keep_alive case and so it
will simply do the kmem_free(ctx) call there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
