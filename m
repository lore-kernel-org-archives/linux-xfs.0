Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388728AbeGXWBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 18:01:34 -0400
Date: Tue, 24 Jul 2018 13:53:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 10/15] xfs: use internal dfops in attr code
Message-ID: <20180724205306.GI4813@magnolia>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:09AM -0400, Brian Foster wrote:
> Remove the unnecessary on-stack dfops structure and use the internal
> transaction dfops instead. The lower level xattr code already
> appropriately accesses ->t_dfops throughout.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 927d4c968f9a..66a22c80a0db 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -202,7 +202,6 @@ xfs_attr_set(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_buf		*leaf_bp = NULL;
>  	struct xfs_da_args	args;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
>  	int			error, err2, local;
> @@ -251,7 +250,6 @@ xfs_attr_set(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(args.trans, &dfops);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> @@ -315,18 +313,18 @@ xfs_attr_set(
>  		 */
>  		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>  		if (error)
> -			goto out_defer_cancel;
> +			goto out;
>  		/*
>  		 * Prevent the leaf buffer from being unlocked so that a
>  		 * concurrent AIL push cannot grab the half-baked leaf
>  		 * buffer and run into problems with the write verifier.
>  		 */
>  		xfs_trans_bhold(args.trans, leaf_bp);
> -		xfs_defer_bjoin(&dfops, leaf_bp);
> -		xfs_defer_ijoin(&dfops, dp);
> -		error = xfs_defer_finish(&args.trans, &dfops);
> +		xfs_defer_bjoin(args.trans->t_dfops, leaf_bp);
> +		xfs_defer_ijoin(args.trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args.trans, args.trans->t_dfops);
>  		if (error)
> -			goto out_defer_cancel;
> +			goto out;
>  
>  		/*
>  		 * Commit the leaf transformation.  We'll need another (linked)
> @@ -366,8 +364,6 @@ xfs_attr_set(
>  
>  	return error;
>  
> -out_defer_cancel:
> -	xfs_defer_cancel(&dfops);
>  out:
>  	if (leaf_bp)
>  		xfs_trans_brelse(args.trans, leaf_bp);
> @@ -389,7 +385,6 @@ xfs_attr_remove(
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
> -	struct xfs_defer_ops	dfops;
>  	int			error;
>  
>  	XFS_STATS_INC(mp, xs_attr_remove);
> @@ -422,7 +417,6 @@ xfs_attr_remove(
>  			&args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(args.trans, &dfops);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	/*
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
