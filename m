Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbeGCU1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 16:27:00 -0400
Date: Tue, 3 Jul 2018 13:26:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/24] xfs: use ->t_dfops for attr set/remove operations
Message-ID: <20180703202645.GC32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:18PM -0400, Brian Foster wrote:
> Attach the local dfops to the transaction allocated for xattr add
> and remove operations. Add an earlier initialization in
> xfs_attr_remove() to ensure the structure is valid if it remains
> unused at transaction commit time.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 11 +++++++----
>  fs/xfs/libxfs/xfs_bmap.c |  3 ++-
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 99590f61d624..cc23c269f2bf 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -254,6 +254,8 @@ xfs_attr_set(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>  	if (error)
>  		return error;
> +	xfs_defer_init(&dfops, &firstblock);
> +	args.trans->t_dfops = &dfops;
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> @@ -315,7 +317,6 @@ xfs_attr_set(
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
>  		 */
> -		xfs_defer_init(args.dfops, args.firstblock);
>  		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -325,9 +326,9 @@ xfs_attr_set(
>  		 * buffer and run into problems with the write verifier.
>  		 */
>  		xfs_trans_bhold(args.trans, leaf_bp);
> -		xfs_defer_bjoin(args.dfops, leaf_bp);
> -		xfs_defer_ijoin(args.dfops, dp);
> -		error = xfs_defer_finish(&args.trans, args.dfops);
> +		xfs_defer_bjoin(&dfops, leaf_bp);
> +		xfs_defer_ijoin(&dfops, dp);
> +		error = xfs_defer_finish(&args.trans, &dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  
> @@ -429,6 +430,8 @@ xfs_attr_remove(
>  			&args.trans);
>  	if (error)
>  		return error;
> +	xfs_defer_init(&dfops, &firstblock);
> +	args.trans->t_dfops = &dfops;
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7205268b30bc..16bbc8114d62 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1057,6 +1057,8 @@ xfs_bmap_add_attrfork(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
>  	if (error)
>  		return error;
> +	xfs_defer_init(&dfops, &firstblock);
> +	tp->t_dfops = &dfops;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> @@ -1104,7 +1106,6 @@ xfs_bmap_add_attrfork(
>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>  	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
> -	xfs_defer_init(&dfops, &firstblock);
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &dfops,
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
