Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389548AbeHAQWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 12:22:14 -0400
Date: Wed, 1 Aug 2018 07:36:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 08/15] xfs: automatic dfops inode relogging
Message-ID: <20180801143605.GF30972@magnolia>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801131952.60250-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 09:19:45AM -0400, Brian Foster wrote:
> Inodes that are held across deferred operations are explicitly
> joined to the dfops structure to ensure appropriate relogging.
> While inodes are currently joined explicitly, we can detect the
> conditions that require relogging at dfops finish time by inspecting
> the transaction item list for inodes with ili_lock_flags == 0.
> 
> Replace the xfs_defer_ijoin() infrastructure with such detection and
> automatic relogging of held inodes. This eliminates the need for the
> per-dfops inode list, replaced by an on-stack variant in
> xfs_defer_trans_roll().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        |  9 -----
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 --
>  fs/xfs/libxfs/xfs_bmap.c        |  8 -----
>  fs/xfs/libxfs/xfs_defer.c       | 59 ++++++++++++---------------------
>  fs/xfs/libxfs/xfs_defer.h       |  1 -
>  fs/xfs/xfs_bmap_util.c          |  4 ---
>  fs/xfs/xfs_inode.c              |  2 --
>  fs/xfs/xfs_iomap.c              |  3 --
>  fs/xfs/xfs_reflink.c            |  4 ---
>  fs/xfs/xfs_symlink.c            |  1 -
>  fs/xfs/xfs_trans.h              |  3 --
>  11 files changed, 21 insertions(+), 75 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 227887bee00d..3190dfc21b60 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -320,7 +320,6 @@ xfs_attr_set(
>  		 * buffer and run into problems with the write verifier.
>  		 */
>  		xfs_trans_bhold(args.trans, leaf_bp);
> -		xfs_defer_ijoin(args.trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args.trans);
>  		if (error)
>  			goto out;
> @@ -589,7 +588,6 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -678,7 +676,6 @@ xfs_attr_leaf_addname(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->trans->t_dfops, dp);
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -742,7 +739,6 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -869,7 +865,6 @@ xfs_attr_node_addname(
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->trans->t_dfops, dp);
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -894,7 +889,6 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -991,7 +985,6 @@ xfs_attr_node_addname(
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->trans->t_dfops, dp);
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -1115,7 +1108,6 @@ xfs_attr_node_removename(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1147,7 +1139,6 @@ xfs_attr_node_removename(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->trans->t_dfops, dp);
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
>  				goto out_defer_cancel;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 77ca38586913..f52552313773 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -486,7 +486,6 @@ xfs_attr_rmtval_set(
>  				  &nmap);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -627,7 +626,6 @@ xfs_attr_rmtval_remove(
>  				    XFS_BMAPI_ATTRFORK, 1, &done);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out_defer_cancel;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 71687d805f79..5cd490dc891a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1119,7 +1119,6 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> -	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> @@ -5987,7 +5986,6 @@ __xfs_bmap_add(
>  	int				whichfork,
>  	struct xfs_bmbt_irec		*bmap)
>  {
> -	int				error;
>  	struct xfs_bmap_intent		*bi;
>  
>  	trace_xfs_bmap_defer(mp,
> @@ -6006,12 +6004,6 @@ __xfs_bmap_add(
>  	bi->bi_whichfork = whichfork;
>  	bi->bi_bmap = *bmap;
>  
> -	error = xfs_defer_ijoin(dfops, bi->bi_owner);
> -	if (error) {
> -		kmem_free(bi);
> -		return error;
> -	}
> -
>  	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e9b7671d289a..1e7073252a5e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -15,6 +15,8 @@
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_inode.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  
>  /*
> @@ -230,16 +232,14 @@ xfs_defer_trans_roll(
>  {
>  	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
>  	struct xfs_buf_log_item		*bli;
> +	struct xfs_inode_log_item	*ili;
>  	struct xfs_log_item		*lip;
>  	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
> -	int				bpcount = 0;
> +	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
> +	int				bpcount = 0, ipcount = 0;
>  	int				i;
>  	int				error;
>  
> -	/* Log all the joined inodes. */
> -	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
> -		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
> -
>  	list_for_each_entry(lip, &(*tp)->t_items, li_trans) {
>  		switch (lip->li_type) {
>  		case XFS_LI_BUF:
> @@ -254,6 +254,19 @@ xfs_defer_trans_roll(
>  				bplist[bpcount++] = bli->bli_buf;
>  			}
>  			break;
> +		case XFS_LI_INODE:
> +			ili = container_of(lip, struct xfs_inode_log_item,
> +					   ili_item);
> +			if (ili->ili_lock_flags == 0) {
> +				if (ipcount >= XFS_DEFER_OPS_NR_INODES) {
> +					ASSERT(0);
> +					return -EFSCORRUPTED;
> +				}
> +				xfs_trans_log_inode(*tp, ili->ili_inode,
> +						    XFS_ILOG_CORE);
> +				iplist[ipcount++] = ili->ili_inode;
> +			}
> +			break;
>  		default:
>  			break;
>  		}
> @@ -271,8 +284,8 @@ xfs_defer_trans_roll(
>  	}
>  
>  	/* Rejoin the joined inodes. */
> -	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
> -		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
> +	for (i = 0; i < ipcount; i++)
> +		xfs_trans_ijoin(*tp, iplist[i], 0);
>  
>  	/* Rejoin the buffers and dirty them so the log moves forward. */
>  	for (i = 0; i < bpcount; i++) {
> @@ -291,30 +304,6 @@ xfs_defer_has_unfinished_work(
>  	return !list_empty(&dop->dop_pending) || !list_empty(&dop->dop_intake);
>  }
>  
> -/*
> - * Add this inode to the deferred op.  Each joined inode is relogged
> - * each time we roll the transaction.
> - */
> -int
> -xfs_defer_ijoin(
> -	struct xfs_defer_ops		*dop,
> -	struct xfs_inode		*ip)
> -{
> -	int				i;
> -
> -	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> -		if (dop->dop_inodes[i] == ip)
> -			return 0;
> -		else if (dop->dop_inodes[i] == NULL) {
> -			dop->dop_inodes[i] = ip;
> -			return 0;
> -		}
> -	}
> -
> -	ASSERT(0);
> -	return -EFSCORRUPTED;
> -}
> -
>  /*
>   * Reset an already used dfops after finish.
>   */
> @@ -322,11 +311,7 @@ static void
>  xfs_defer_reset(
>  	struct xfs_trans	*tp)
>  {
> -	struct xfs_defer_ops	*dop = tp->t_dfops;
> -
> -	ASSERT(!xfs_defer_has_unfinished_work(dop));
> -
> -	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
> +	ASSERT(!xfs_defer_has_unfinished_work(tp->t_dfops));
>  
>  	/*
>  	 * Low mode state transfers across transaction rolls to mirror dfops
> @@ -588,8 +573,6 @@ xfs_defer_move(
>  	list_splice_init(&src->dop_intake, &dst->dop_intake);
>  	list_splice_init(&src->dop_pending, &dst->dop_pending);
>  
> -	memcpy(dst->dop_inodes, src->dop_inodes, sizeof(dst->dop_inodes));
> -
>  	/*
>  	 * Low free space mode was historically controlled by a dfops field.
>  	 * This meant that low mode state potentially carried across multiple
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 4a8bb838adf2..bf1e9f78561e 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -42,7 +42,6 @@ int xfs_defer_finish(struct xfs_trans **tp);
>  void xfs_defer_cancel(struct xfs_trans *);
>  void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> -int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
>  void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
>  
>  /* Description of a deferred type. */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0c58a66b39e5..30ac1300dc49 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -979,7 +979,6 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> -		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> @@ -1037,8 +1036,6 @@ xfs_unmap_extent(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_defer_ijoin(tp->t_dfops, ip);
> -
>  	error = xfs_trans_commit(tp);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -1624,7 +1621,6 @@ xfs_swap_extent_rmap(
>  			if (error)
>  				goto out_defer;
>  
> -			xfs_defer_ijoin(tp->t_dfops, ip);
>  			error = xfs_defer_finish(tpp);
>  			tp = *tpp;
>  			if (error)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 441c8593cfd7..7bb46a0eecfc 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1569,7 +1569,6 @@ xfs_itruncate_extents_flags(
>  		 * Duplicate the transaction that has the permanent
>  		 * reservation and commit the old transaction.
>  		 */
> -		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out_bmap_cancel;
> @@ -1810,7 +1809,6 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 8093a01fcf9e..3282575e2df4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -261,7 +261,6 @@ xfs_iomap_write_direct(
>  	/*
>  	 * Complete the transaction
>  	 */
> -	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_unlock;
> @@ -764,7 +763,6 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto trans_cancel;
>  
> -			xfs_defer_ijoin(tp->t_dfops, ip);
>  			error = xfs_trans_commit(tp);
>  			if (error)
>  				goto error0;
> @@ -884,7 +882,6 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> -		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e986fcf928e5..dce8ba8ab681 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -435,7 +435,6 @@ xfs_reflink_allocate_cow(
>  	xfs_inode_set_cowblocks_tag(ip);
>  
>  	/* Finish up. */
> -	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
> @@ -518,7 +517,6 @@ xfs_reflink_cancel_cow_blocks(
>  					NULL);
>  
>  			/* Roll the transaction */
> -			xfs_defer_ijoin((*tpp)->t_dfops, ip);
>  			error = xfs_defer_finish(tpp);
>  			if (error) {
>  				xfs_defer_cancel(*tpp);
> @@ -716,7 +714,6 @@ xfs_reflink_end_cow(
>  		/* Remove the mapping from the CoW fork. */
>  		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
> -		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out_cancel;
> @@ -1077,7 +1074,6 @@ xfs_reflink_remap_extent(
>  
>  next_extent:
>  		/* Process all the deferred stuff. */
> -		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out_cancel;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 2bfe7fbbedb2..a3e98c64b6e3 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -454,7 +454,6 @@ xfs_inactive_symlink_rmt(
>  	 * Commit the transaction. This first logs the EFI and the inode, then
>  	 * rolls and commits the transaction that frees the extents.
>  	 */
> -	xfs_defer_ijoin(tp->t_dfops, ip);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 581456c79197..8665d45b82c6 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -97,9 +97,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  struct xfs_defer_ops {
>  	struct list_head	dop_intake;	/* unlogged pending work */
>  	struct list_head	dop_pending;	/* logged pending work */
> -
> -	/* relog these with each roll */
> -	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
>  };
>  
>  /*
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
