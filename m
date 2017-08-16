Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29151 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbdHPRXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 13:23:15 -0400
Date: Wed, 16 Aug 2017 10:23:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: remove the ip argument to xfs_defer_finish
Message-ID: <20170816172310.GB4796@magnolia>
References: <20170813144216.11192-1-hch@lst.de>
 <20170813144216.11192-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813144216.11192-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Aug 13, 2017 at 04:42:16PM +0200, Christoph Hellwig wrote:
> And instead require callers to explicitly join the inode using
> xfs_defer_join_inode.  Also consolidate the defer error handling in
> a few places using a goto label.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 140 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |  35 +++++-----
>  fs/xfs/libxfs/xfs_bmap.c        |   4 +-
>  fs/xfs/libxfs/xfs_defer.c       |   8 +--
>  fs/xfs/libxfs/xfs_defer.h       |   3 +-
>  fs/xfs/libxfs/xfs_refcount.c    |   2 +-
>  fs/xfs/xfs_bmap_item.c          |   2 +-
>  fs/xfs/xfs_bmap_util.c          |  10 +--
>  fs/xfs/xfs_dquot.c              |   2 +-
>  fs/xfs/xfs_inode.c              |  13 ++--
>  fs/xfs/xfs_iomap.c              |   6 +-
>  fs/xfs/xfs_refcount_item.c      |   2 +-
>  fs/xfs/xfs_reflink.c            |  11 ++--
>  fs/xfs/xfs_rtalloc.c            |   2 +-
>  fs/xfs/xfs_symlink.c            |   5 +-
>  15 files changed, 129 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index bafa0f6bfafa..117bdfb0e864 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -328,13 +328,12 @@ xfs_attr_set(
>  		 */
>  		xfs_defer_init(args.dfops, args.firstblock);
>  		error = xfs_attr_shortform_to_leaf(&args);
> -		if (!error)
> -			error = xfs_defer_finish(&args.trans, args.dfops, dp);
> -		if (error) {
> -			args.trans = NULL;
> -			xfs_defer_cancel(&dfops);
> -			goto out;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args.dfops, dp);
> +		error = xfs_defer_finish(&args.trans, args.dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  
>  		/*
>  		 * Commit the leaf transformation.  We'll need another (linked)
> @@ -373,6 +372,9 @@ xfs_attr_set(
>  
>  	return error;
>  
> +out_defer_cancel:
> +	xfs_defer_cancel(&dfops);
> +	args.trans = NULL;
>  out:
>  	if (args.trans)
>  		xfs_trans_cancel(args.trans);
> @@ -593,13 +595,12 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 */
>  		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_node(args);
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops, dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			return error;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  
>  		/*
>  		 * Commit the current trans (including the inode) and start
> @@ -684,14 +685,12 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
> -			if (!error)
> -				error = xfs_defer_finish(&args->trans,
> -							args->dfops, dp);
> -			if (error) {
> -				args->trans = NULL;
> -				xfs_defer_cancel(args->dfops);
> -				return error;
> -			}
> +			if (error)
> +				goto out_defer_cancel;
> +			xfs_defer_join_inode(args->dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
>  		}
>  
>  		/*
> @@ -706,6 +705,10 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		error = xfs_attr3_leaf_clearflag(args);
>  	}
>  	return error;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	return error;
>  }
>  
>  /*
> @@ -747,15 +750,18 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops, dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			return error;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  	}
>  	return 0;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	return error;
>  }
>  
>  /*
> @@ -872,14 +878,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  			state = NULL;
>  			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_node(args);
> -			if (!error)
> -				error = xfs_defer_finish(&args->trans,
> -							args->dfops, dp);
> -			if (error) {
> -				args->trans = NULL;
> -				xfs_defer_cancel(args->dfops);
> -				goto out;
> -			}
> +			if (error)
> +				goto out_defer_cancel;
> +			xfs_defer_join_inode(args->dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
>  
>  			/*
>  			 * Commit the node conversion and start the next
> @@ -900,13 +904,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		 */
>  		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_da3_split(state);
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops, dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			goto out;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -999,14 +1002,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		if (retval && (state->path.active > 1)) {
>  			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_da3_join(state);
> -			if (!error)
> -				error = xfs_defer_finish(&args->trans,
> -							args->dfops, dp);
> -			if (error) {
> -				args->trans = NULL;
> -				xfs_defer_cancel(args->dfops);
> -				goto out;
> -			}
> +			if (error)
> +				goto out_defer_cancel;
> +			xfs_defer_join_inode(args->dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
>  		}
>  
>  		/*
> @@ -1032,6 +1033,10 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  	if (error)
>  		return error;
>  	return retval;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	goto out;
>  }
>  
>  /*
> @@ -1122,13 +1127,12 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	if (retval && (state->path.active > 1)) {
>  		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_da3_join(state);
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops, dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			goto out;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
> @@ -1156,14 +1160,12 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
> -			if (!error)
> -				error = xfs_defer_finish(&args->trans,
> -							args->dfops, dp);
> -			if (error) {
> -				args->trans = NULL;
> -				xfs_defer_cancel(args->dfops);
> -				goto out;
> -			}
> +			if (error)
> +				goto out_defer_cancel;
> +			xfs_defer_join_inode(args->dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
>  		} else
>  			xfs_trans_brelse(args->trans, bp);
>  	}
> @@ -1172,6 +1174,10 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  out:
>  	xfs_da_state_free(state);
>  	return error;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	goto out;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 433c36714e40..4490c988e4e0 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -467,13 +467,12 @@ xfs_attr_rmtval_set(
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>  				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
>  				  args->total, &map, &nmap, args->dfops);
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops, dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			return error;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  
>  		ASSERT(nmap == 1);
>  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> @@ -539,6 +538,10 @@ xfs_attr_rmtval_set(
>  	}
>  	ASSERT(valuelen == 0);
>  	return 0;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	return error;
>  }
>  
>  /*
> @@ -609,14 +612,12 @@ xfs_attr_rmtval_remove(
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
>  				    args->dfops, &done);
> -		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->dfops,
> -						args->dp);
> -		if (error) {
> -			args->trans = NULL;
> -			xfs_defer_cancel(args->dfops);
> -			return error;
> -		}
> +		if (error)
> +			goto out_defer_cancel;
> +		xfs_defer_join_inode(args->dfops, args->dp);
> +		error = xfs_defer_finish(&args->trans, args->dfops);
> +		if (error)
> +			goto out_defer_cancel;
>  
>  		/*
>  		 * Close out trans and start the next one in the chain.
> @@ -626,4 +627,8 @@ xfs_attr_rmtval_remove(
>  			return error;
>  	}
>  	return 0;
> +out_defer_cancel:
> +	xfs_defer_cancel(args->dfops);
> +	args->trans = NULL;
> +	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 24eba36ef818..c569816c4264 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1196,7 +1196,7 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto bmap_cancel;
>  	error = xfs_trans_commit(tp);
> @@ -6402,7 +6402,7 @@ xfs_bmap_split_extent(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 043844f00f6e..f706d1229363 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -277,8 +277,7 @@ xfs_defer_has_unfinished_work(
>  
>  /*
>   * Add this inode to the deferred op.  Each joined inode is relogged
> - * each time we roll the transaction, in addition to any inode passed
> - * to xfs_defer_finish().
> + * each time we roll the transaction.
>   */
>  int
>  xfs_defer_join_inode(
> @@ -310,8 +309,7 @@ xfs_defer_join_inode(
>  int
>  xfs_defer_finish(
>  	struct xfs_trans		**tp,
> -	struct xfs_defer_ops		*dop,
> -	struct xfs_inode		*ip)
> +	struct xfs_defer_ops		*dop)
>  {
>  	struct xfs_defer_pending	*dfp;
>  	struct list_head		*li;
> @@ -324,8 +322,6 @@ xfs_defer_finish(
>  
>  	trace_xfs_defer_finish((*tp)->t_mountp, dop);
>  
> -	xfs_defer_join_inode(dop, ip);
> -
>  	/* Until we run out of pending work to finish... */
>  	while (xfs_defer_has_unfinished_work(dop)) {
>  		/* Log intents for work items sitting in the intake. */
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 4632c798ea2b..f57915e57494 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -72,8 +72,7 @@ struct xfs_defer_ops {
>  
>  void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
>  		struct list_head *h);
> -int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop,
> -		struct xfs_inode *ip);
> +int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
>  void xfs_defer_cancel(struct xfs_defer_ops *dop);
>  void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 45b1c3b4e047..9d5406b4f663 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1679,7 +1679,7 @@ xfs_refcount_recover_cow_leftovers(
>  		xfs_bmap_add_free(mp, &dfops, fsb,
>  				rr->rr_rrec.rc_blockcount, NULL);
>  
> -		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_defer;
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 88073910fa5d..dd136f7275e4 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -502,7 +502,7 @@ xfs_bui_recover(
>  	}
>  
>  	/* Finish transaction, free inodes. */
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto err_dfops;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 93e955262d07..2915e13021a4 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1136,7 +1136,7 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> -		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto error0;
>  
> @@ -1202,7 +1202,8 @@ xfs_unmap_extent(
>  	if (error)
>  		goto out_bmap_cancel;
>  
> -	error = xfs_defer_finish(&tp, &dfops, ip);
> +	xfs_defer_join_inode(&dfops, ip);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -1496,7 +1497,7 @@ xfs_shift_file_space(
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1777,7 +1778,8 @@ xfs_swap_extent_rmap(
>  			if (error)
>  				goto out_defer;
>  
> -			error = xfs_defer_finish(tpp, &dfops, ip);
> +			xfs_defer_join_inode(&dfops, ip);
> +			error = xfs_defer_finish(tpp, &dfops);
>  			if (error)
>  				goto out_defer;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index fd2ef8c2c9a7..cd82429d8df7 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -383,7 +383,7 @@ xfs_qm_dqalloc(
>  
>  	xfs_trans_bhold(tp, bp);
>  
> -	error = xfs_defer_finish(tpp, &dfops, NULL);
> +	error = xfs_defer_finish(tpp, &dfops);
>  	if (error)
>  		goto error1;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6b9d56637a52..6b1f3ca52591 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1283,7 +1283,7 @@ xfs_create(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -1511,7 +1511,7 @@ xfs_link(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error) {
>  		xfs_defer_cancel(&dfops);
>  		goto error_return;
> @@ -1605,7 +1605,8 @@ xfs_itruncate_extents(
>  		 * Duplicate the transaction that has the permanent
>  		 * reservation and commit the old transaction.
>  		 */
> -		error = xfs_defer_finish(&tp, &dfops, ip);
> +		xfs_defer_join_inode(&dfops, ip);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1853,7 +1854,7 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error) {
>  		xfs_notice(mp, "%s: xfs_defer_finish returned error %d",
>  			__func__, error);
> @@ -2635,7 +2636,7 @@ xfs_remove(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -2721,7 +2722,7 @@ xfs_finish_rename(
>  	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, dfops, NULL);
> +	error = xfs_defer_finish(&tp, dfops);
>  	if (error) {
>  		xfs_defer_cancel(dfops);
>  		xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 813394c62849..1b625d050441 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -274,7 +274,7 @@ xfs_iomap_write_direct(
>  	/*
>  	 * Complete the transaction
>  	 */
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -784,7 +784,7 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto trans_cancel;
>  
> -			error = xfs_defer_finish(&tp, &dfops, NULL);
> +			error = xfs_defer_finish(&tp, &dfops);
>  			if (error)
>  				goto trans_cancel;
>  
> @@ -906,7 +906,7 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> -		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 96fe209b5eb6..8f2e2fac4255 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -525,7 +525,7 @@ xfs_cui_recover(
>  	}
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto abort_defer;
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f45fbf0db9bb..4ac1c6922b6d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -464,7 +464,7 @@ xfs_reflink_allocate_cow(
>  		goto out_bmap_cancel;
>  
>  	/* Finish up. */
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -602,7 +602,8 @@ xfs_reflink_cancel_cow_blocks(
>  					-(long)del.br_blockcount);
>  
>  			/* Roll the transaction */
> -			error = xfs_defer_finish(tpp, &dfops, ip);
> +			xfs_defer_join_inode(&dfops, ip);
> +			error = xfs_defer_finish(tpp, &dfops);
>  			if (error) {
>  				xfs_defer_cancel(&dfops);
>  				break;
> @@ -791,7 +792,8 @@ xfs_reflink_end_cow(
>  		/* Remove the mapping from the CoW fork. */
>  		xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
>  
> -		error = xfs_defer_finish(&tp, &dfops, ip);
> +		xfs_defer_join_inode(&dfops, ip);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_defer;
>  next_extent:
> @@ -1152,7 +1154,8 @@ xfs_reflink_remap_extent(
>  
>  next_extent:
>  		/* Process all the deferred stuff. */
> -		error = xfs_defer_finish(&tp, &dfops, ip);
> +		xfs_defer_join_inode(&dfops, ip);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_defer;
>  	}
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 91472193643b..488719d43ca8 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -810,7 +810,7 @@ xfs_growfs_rt_alloc(
>  		/*
>  		 * Free any blocks freed up in the transaction, then commit.
>  		 */
> -		error = xfs_defer_finish(&tp, &dfops, NULL);
> +		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 23a50d7aa46a..4c05c34cc820 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -378,7 +378,7 @@ xfs_symlink(
>  		xfs_trans_set_sync(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, &dfops, NULL);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -497,7 +497,8 @@ xfs_inactive_symlink_rmt(
>  	/*
>  	 * Commit the first transaction.  This logs the EFI and the inode.
>  	 */
> -	error = xfs_defer_finish(&tp, &dfops, ip);
> +	xfs_defer_join_inode(&dfops, ip);
> +	error = xfs_defer_finish(&tp, &dfops);
>  	if (error)
>  		goto error_bmap_cancel;
>  	/*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
