Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50382 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbeG3WDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 18:03:51 -0400
Date: Mon, 30 Jul 2018 13:27:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/15] xfs: cancel dfops on xfs_defer_finish() error
Message-ID: <20180730202704.GL30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-12-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:16PM -0400, Brian Foster wrote:
> The current semantics of xfs_defer_finish() require the caller to
> call xfs_defer_cancel() on error. This is slightly inconsistent with
> transaction commit error handling where a failed commit cleans up
> the transaction before returning.
> 
> More significantly, the only requirement for exposure of
> ->dop_pending outside of xfs_defer_finish() is so that
> xfs_defer_cancel() can drain it on error. Since the only recourse of
> xfs_defer_finish() errors is cancellation, mirror the transaction
> logic and cancel remaining dfops before returning from
> xfs_defer_finish() with an error.
> 
> Beside simplifying xfs_defer_finish() semantics, this ensures that
> xfs_defer_finish() always returns with an empty ->dop_pending and
> thus facilitates removal of the list from xfs_defer_ops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_attr_remote.c |  4 ++--
>  fs/xfs/libxfs/xfs_defer.c       | 11 ++++++-----
>  fs/xfs/xfs_bmap_util.c          |  2 +-
>  fs/xfs/xfs_dquot.c              |  2 +-
>  fs/xfs/xfs_inode.c              |  2 +-
>  fs/xfs/xfs_reflink.c            |  4 +---
>  fs/xfs/xfs_trans.c              |  4 +---
>  8 files changed, 21 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3190dfc21b60..1e671d4eb6fa 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -590,7 +590,7 @@ xfs_attr_leaf_addname(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			return error;
>  
>  		/*
>  		 * Commit the current trans (including the inode) and start
> @@ -678,7 +678,7 @@ xfs_attr_leaf_addname(
>  				goto out_defer_cancel;
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
> -				goto out_defer_cancel;
> +				return error;
>  		}
>  
>  		/*
> @@ -741,7 +741,7 @@ xfs_attr_leaf_removename(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			return error;
>  	}
>  	return 0;
>  out_defer_cancel:
> @@ -867,7 +867,7 @@ xfs_attr_node_addname(
>  				goto out_defer_cancel;
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
> -				goto out_defer_cancel;
> +				goto out;
>  
>  			/*
>  			 * Commit the node conversion and start the next
> @@ -891,7 +891,7 @@ xfs_attr_node_addname(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			goto out;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -987,7 +987,7 @@ xfs_attr_node_addname(
>  				goto out_defer_cancel;
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
> -				goto out_defer_cancel;
> +				goto out;
>  		}
>  
>  		/*
> @@ -1110,7 +1110,7 @@ xfs_attr_node_removename(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			goto out;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
> @@ -1141,7 +1141,7 @@ xfs_attr_node_removename(
>  				goto out_defer_cancel;
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
> -				goto out_defer_cancel;
> +				goto out;
>  		} else
>  			xfs_trans_brelse(args->trans, bp);
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index f52552313773..af094063e402 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -488,7 +488,7 @@ xfs_attr_rmtval_set(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			return error;
>  
>  		ASSERT(nmap == 1);
>  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> @@ -628,7 +628,7 @@ xfs_attr_rmtval_remove(
>  			goto out_defer_cancel;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out_defer_cancel;
> +			return error;
>  
>  		/*
>  		 * Close out trans and start the next one in the chain.
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 7b84e3a4b7f3..66848ede62c0 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -410,14 +410,15 @@ xfs_defer_finish_noroll(
>  	}
>  
>  out:
> -	if (error)
> +	if (error) {
>  		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
>  					     error);
> -	 else
> -		trace_xfs_defer_finish_done((*tp)->t_mountp, (*tp)->t_dfops,
> -					    _RET_IP_);
> +		xfs_defer_cancel(*tp);
> +		return error;
> +	}
>  
> -	return error;
> +	trace_xfs_defer_finish_done((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
> +	return 0;
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 30ac1300dc49..d9dad399440a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1624,7 +1624,7 @@ xfs_swap_extent_rmap(
>  			error = xfs_defer_finish(tpp);
>  			tp = *tpp;
>  			if (error)
> -				goto out_defer;
> +				goto out;
>  
>  			tirec.br_startoff += rlen;
>  			if (tirec.br_startblock != HOLESTARTBLOCK &&
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e1196854dbcd..70a76ac41f01 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -371,7 +371,7 @@ xfs_dquot_disk_alloc(
>  	tp = *tpp;
>  	if (error) {
>  		xfs_buf_relse(bp);
> -		goto error1;
> +		goto error0;
>  	}
>  	*bpp = bp;
>  	return 0;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7bb46a0eecfc..d957a46dc1cb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1571,7 +1571,7 @@ xfs_itruncate_extents_flags(
>  		 */
>  		error = xfs_defer_finish(&tp);
>  		if (error)
> -			goto out_bmap_cancel;
> +			goto out;
>  
>  		error = xfs_trans_roll_inode(&tp, ip);
>  		if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index dce8ba8ab681..2ec562d75494 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -518,10 +518,8 @@ xfs_reflink_cancel_cow_blocks(
>  
>  			/* Roll the transaction */
>  			error = xfs_defer_finish(tpp);
> -			if (error) {
> -				xfs_defer_cancel(*tpp);
> +			if (error)
>  				break;
> -			}
>  
>  			/* Remove the mapping from the CoW fork. */
>  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8c088568b05d..20750cd9c9e7 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -928,10 +928,8 @@ __xfs_trans_commit(
>  	/* finish deferred items on final commit */
>  	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
>  		error = xfs_defer_finish_noroll(&tp);
> -		if (error) {
> -			xfs_defer_cancel(tp);
> +		if (error)
>  			goto out_unreserve;
> -		}
>  	}
>  
>  	/*
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
