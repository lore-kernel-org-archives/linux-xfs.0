Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A56E7D0A4
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 18:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjIUSLa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjIUSLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 14:11:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071178680B
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:38:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFCFC4E774;
        Thu, 21 Sep 2023 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695311563;
        bh=xHCUyjhmv2yYOwtWEfYMrXRa3/dpIZBHJwYsq0vZJ3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GSrr3Oj860qYnVhd1OqfSU+jPVw9gj1eea4AOj1TLHOyjqR4KM6MiKEwG8udXN4l9
         RKG6FIdzVmgsazUlMnzk1DPDEEq7ZxLs82PmSYO5onpB6eouBEvP9VFaezG1ge22KK
         w6E7X8cM01o9a9mXzWlbv8mXFgbs4Mv2L6Zctr+ZNposa0y6w23iF9D2OLjVqLiT0J
         S7Gr3m0ujWX1uSXS3AlXN1yECeGY2XS7BLR7S2mGw7iZ4pXzwxGoRlHm1QzGXALbtA
         OOy+uxL58Fn1eMcmLR31fxYvWZPI9T+9GR3ESqa2bYQRDjCn2ktCu5NMQnC3L0mTTT
         AROjNlc2PdSwQ==
Date:   Thu, 21 Sep 2023 08:52:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move log discard work to xfs_discard.c
Message-ID: <20230921155243.GC11391@frogsfrogsfrogs>
References: <20230921013945.559634-1-david@fromorbit.com>
 <20230921013945.559634-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921013945.559634-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 11:39:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we are going to use the same list-based discard submission
> interface for fstrim-based discards, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c     | 77 ++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_discard.h     |  6 ++-
>  fs/xfs/xfs_extent_busy.h | 20 +++++++--
>  fs/xfs/xfs_log_cil.c     | 93 ++++++----------------------------------
>  fs/xfs/xfs_log_priv.h    |  5 ++-
>  5 files changed, 113 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index afc4c78b9eed..3f45c7bb94f2 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (C) 2010 Red Hat, Inc.
> + * Copyright (C) 2010, 2023 Red Hat, Inc.
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> @@ -19,6 +19,81 @@
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  
> +struct workqueue_struct *xfs_discard_wq;
> +
> +static void
> +xfs_discard_endio_work(
> +	struct work_struct	*work)
> +{
> +	struct xfs_busy_extents	*extents =
> +		container_of(work, struct xfs_busy_extents, endio_work);
> +
> +	xfs_extent_busy_clear(extents->mount, &extents->extent_list, false);
> +	kmem_free(extents->owner);
> +}
> +
> +/*
> + * Queue up the actual completion to a thread to avoid IRQ-safe locking for
> + * pagb_lock.
> + */
> +static void
> +xfs_discard_endio(
> +	struct bio		*bio)
> +{
> +	struct xfs_busy_extents	*extents = bio->bi_private;
> +
> +	INIT_WORK(&extents->endio_work, xfs_discard_endio_work);
> +	queue_work(xfs_discard_wq, &extents->endio_work);
> +	bio_put(bio);
> +}
> +
> +/*
> + * Walk the discard list and issue discards on all the busy extents in the
> + * list. We plug and chain the bios so that we only need a single completion
> + * call to clear all the busy extents once the discards are complete.
> + */
> +int
> +xfs_discard_extents(
> +	struct xfs_mount	*mp,
> +	struct xfs_busy_extents	*extents)
> +{
> +	struct xfs_extent_busy	*busyp;
> +	struct bio		*bio = NULL;
> +	struct blk_plug		plug;
> +	int			error = 0;
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry(busyp, &extents->extent_list, list) {
> +		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
> +					 busyp->length);
> +
> +		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
> +				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
> +				XFS_FSB_TO_BB(mp, busyp->length),
> +				GFP_NOFS, &bio);
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
> +		bio->bi_private = extents;
> +		bio->bi_end_io = xfs_discard_endio;
> +		submit_bio(bio);
> +	} else {
> +		xfs_discard_endio_work(&extents->endio_work);
> +	}
> +	blk_finish_plug(&plug);
> +
> +	return error;
> +}
> +
> +
>  STATIC int
>  xfs_trim_extents(
>  	struct xfs_perag	*pag,
> diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
> index de92d9cc958f..2b1a85223a56 100644
> --- a/fs/xfs/xfs_discard.h
> +++ b/fs/xfs/xfs_discard.h
> @@ -3,8 +3,10 @@
>  #define XFS_DISCARD_H 1
>  
>  struct fstrim_range;
> -struct list_head;
> +struct xfs_mount;
> +struct xfs_busy_extents;
>  
> -extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
> +int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
> +int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
>  
>  #endif /* XFS_DISCARD_H */
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index c37bf87e6781..71c28d031e3b 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -16,9 +16,6 @@ struct xfs_alloc_arg;
>  /*
>   * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
>   * have been freed but whose transactions aren't committed to disk yet.
> - *
> - * Note that we use the transaction ID to record the transaction, not the
> - * transaction structure itself. See xfs_extent_busy_insert() for details.
>   */
>  struct xfs_extent_busy {
>  	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
> @@ -31,6 +28,23 @@ struct xfs_extent_busy {
>  #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
>  };
>  
> +/*
> + * List used to track groups of related busy extents all the way through
> + * to discard completion.
> + */
> +struct xfs_busy_extents {
> +	struct xfs_mount	*mount;
> +	struct list_head	extent_list;
> +	struct work_struct	endio_work;
> +
> +	/*
> +	 * Owner is the object containing the struct xfs_busy_extents to free
> +	 * once the busy extents have been processed. If only the
> +	 * xfs_busy_extents object needs freeing, then point this at itself.
> +	 */
> +	void			*owner;
> +};
> +
>  void
>  xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
>  	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3aec5589d717..c340987880c8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -16,8 +16,7 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_trace.h"
> -
> -struct workqueue_struct *xfs_discard_wq;
> +#include "xfs_discard.h"
>  
>  /*
>   * Allocate a new ticket. Failing to get a new ticket makes it really hard to
> @@ -103,7 +102,7 @@ xlog_cil_ctx_alloc(void)
>  
>  	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
>  	INIT_LIST_HEAD(&ctx->committing);
> -	INIT_LIST_HEAD(&ctx->busy_extents);
> +	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);

I wonder if xfs_busy_extents should have an initializer function to
INIT_LIST_HEAD and set mount/owner?  This patch and the next one both
have similar initialization sequences.

(Not sure if you want to INIT_WORK at the same time?)

>  	INIT_LIST_HEAD(&ctx->log_items);
>  	INIT_LIST_HEAD(&ctx->lv_chain);
>  	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
> @@ -132,7 +131,7 @@ xlog_cil_push_pcp_aggregate(
>  
>  		if (!list_empty(&cilpcp->busy_extents)) {
>  			list_splice_init(&cilpcp->busy_extents,
> -					&ctx->busy_extents);
> +					&ctx->busy_extents.extent_list);

Hmm.  Should xfs_trans.t_busy and xlog_cil_pcp.busy_extents also get
converted into xfs_busy_extents objects and a helper written to splice
two busy_extents lists together?

(This might be architecture astronauting, feel free to ignore this...)

>  		}
>  		if (!list_empty(&cilpcp->log_items))
>  			list_splice_init(&cilpcp->log_items, &ctx->log_items);
> @@ -882,76 +881,6 @@ xlog_cil_free_logvec(
>  	}
>  }
>  
> -static void
> -xlog_discard_endio_work(
> -	struct work_struct	*work)
> -{
> -	struct xfs_cil_ctx	*ctx =
> -		container_of(work, struct xfs_cil_ctx, discard_endio_work);
> -	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> -
> -	xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
> -	kmem_free(ctx);
> -}
> -
> -/*
> - * Queue up the actual completion to a thread to avoid IRQ-safe locking for
> - * pagb_lock.  Note that we need a unbounded workqueue, otherwise we might
> - * get the execution delayed up to 30 seconds for weird reasons.
> - */
> -static void
> -xlog_discard_endio(
> -	struct bio		*bio)
> -{
> -	struct xfs_cil_ctx	*ctx = bio->bi_private;
> -
> -	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
> -	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
> -	bio_put(bio);
> -}
> -
> -static void
> -xlog_discard_busy_extents(
> -	struct xfs_mount	*mp,
> -	struct xfs_cil_ctx	*ctx)
> -{
> -	struct list_head	*list = &ctx->busy_extents;
> -	struct xfs_extent_busy	*busyp;
> -	struct bio		*bio = NULL;
> -	struct blk_plug		plug;
> -	int			error = 0;
> -
> -	ASSERT(xfs_has_discard(mp));
> -
> -	blk_start_plug(&plug);
> -	list_for_each_entry(busyp, list, list) {
> -		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
> -					 busyp->length);
> -
> -		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
> -				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
> -				XFS_FSB_TO_BB(mp, busyp->length),
> -				GFP_NOFS, &bio);
> -		if (error && error != -EOPNOTSUPP) {
> -			xfs_info(mp,
> -	 "discard failed for extent [0x%llx,%u], error %d",
> -				 (unsigned long long)busyp->bno,
> -				 busyp->length,
> -				 error);
> -			break;
> -		}
> -	}
> -
> -	if (bio) {
> -		bio->bi_private = ctx;
> -		bio->bi_end_io = xlog_discard_endio;
> -		submit_bio(bio);
> -	} else {
> -		xlog_discard_endio_work(&ctx->discard_endio_work);
> -	}
> -	blk_finish_plug(&plug);
> -}
> -
>  /*
>   * Mark all items committed and clear busy extents. We free the log vector
>   * chains in a separate pass so that we unpin the log items as quickly as
> @@ -980,8 +909,8 @@ xlog_cil_committed(
>  
>  	xlog_cil_ail_insert(ctx, abort);
>  
> -	xfs_extent_busy_sort(&ctx->busy_extents);
> -	xfs_extent_busy_clear(mp, &ctx->busy_extents,
> +	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
> +	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
>  			      xfs_has_discard(mp) && !abort);

Should these two xfs_extent_busy objects take the xfs_busy_extent object
as an arg instead of the mount and list_head?  It seems strange (both
here and the next patch) to build up this struct and then pass around
its individual parts.

The straight conversion aspect of this patch looks correct, so (aside
from the question above) any larger API cleanups can be their own patch.

--D

>  	spin_lock(&ctx->cil->xc_push_lock);
> @@ -990,10 +919,14 @@ xlog_cil_committed(
>  
>  	xlog_cil_free_logvec(&ctx->lv_chain);
>  
> -	if (!list_empty(&ctx->busy_extents))
> -		xlog_discard_busy_extents(mp, ctx);
> -	else
> -		kmem_free(ctx);
> +	if (!list_empty(&ctx->busy_extents.extent_list)) {
> +		ctx->busy_extents.mount = mp;
> +		ctx->busy_extents.owner = ctx;
> +		xfs_discard_extents(mp, &ctx->busy_extents);
> +		return;
> +	}
> +
> +	kmem_free(ctx);
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 9e276514cfb5..c3dfc0de87de 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -6,6 +6,8 @@
>  #ifndef	__XFS_LOG_PRIV_H__
>  #define __XFS_LOG_PRIV_H__
>  
> +#include "xfs_extent_busy.h"	/* for struct xfs_busy_extents */
> +
>  struct xfs_buf;
>  struct xlog;
>  struct xlog_ticket;
> @@ -223,12 +225,11 @@ struct xfs_cil_ctx {
>  	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
>  	atomic_t		space_used;	/* aggregate size of regions */
> -	struct list_head	busy_extents;	/* busy extents in chkpt */
> +	struct xfs_busy_extents	busy_extents;
>  	struct list_head	log_items;	/* log items in chkpt */
>  	struct list_head	lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
>  	struct list_head	committing;	/* ctx committing list */
> -	struct work_struct	discard_endio_work;
>  	struct work_struct	push_work;
>  	atomic_t		order_id;
>  
> -- 
> 2.40.1
> 
