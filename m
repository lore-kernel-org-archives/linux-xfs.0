Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43442 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbeGDAoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:44:05 -0400
Date: Tue, 3 Jul 2018 17:43:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/25] xfs: use ->t_firstblock in attrfork add
Message-ID: <20180704004350.GE32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:22:59PM -0400, Brian Foster wrote:
> Note that this codepath is a user of struct xfs_da_args. Switch it
> over to ->t_firstblock in preparation to remove
> xfs_da_args.firstblock.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c6a5a957674d..fcd10b47044a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -915,7 +915,6 @@ STATIC int					/* error */
>  xfs_bmap_add_attrfork_btree(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
> -	xfs_fsblock_t		*firstblock,	/* first block allocated */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* btree cursor */
> @@ -928,7 +927,7 @@ xfs_bmap_add_attrfork_btree(
>  		*flags |= XFS_ILOG_DBROOT;
>  	else {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> -		cur->bc_private.b.firstblock = *firstblock;
> +		cur->bc_private.b.firstblock = tp->t_firstblock;
>  		error = xfs_bmbt_lookup_first(cur, &stat);
>  		if (error)
>  			goto error0;
> @@ -940,7 +939,7 @@ xfs_bmap_add_attrfork_btree(
>  			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  			return -ENOSPC;
>  		}
> -		*firstblock = cur->bc_private.b.firstblock;
> +		tp->t_firstblock = cur->bc_private.b.firstblock;
>  		cur->bc_private.b.allocated = 0;
>  		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	}
> @@ -957,7 +956,6 @@ STATIC int					/* error */
>  xfs_bmap_add_attrfork_extents(
>  	struct xfs_trans	*tp,		/* transaction pointer */
>  	struct xfs_inode	*ip,		/* incore inode pointer */
> -	xfs_fsblock_t		*firstblock,	/* first block allocated */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> @@ -966,8 +964,8 @@ xfs_bmap_add_attrfork_extents(
>  	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
>  		return 0;
>  	cur = NULL;
> -	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, &cur, 0, flags,
> -					  XFS_DATA_FORK);
> +	error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock, &cur, 0,
> +					  flags, XFS_DATA_FORK);
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
>  		xfs_btree_del_cursor(cur,
> @@ -989,12 +987,11 @@ xfs_bmap_add_attrfork_extents(
>   */
>  STATIC int					/* error */
>  xfs_bmap_add_attrfork_local(
> -	xfs_trans_t		*tp,		/* transaction pointer */
> -	xfs_inode_t		*ip,		/* incore inode pointer */
> -	xfs_fsblock_t		*firstblock,	/* first block allocated */
> +	struct xfs_trans	*tp,		/* transaction pointer */
> +	struct xfs_inode	*ip,		/* incore inode pointer */
>  	int			*flags)		/* inode logging flags */
>  {
> -	xfs_da_args_t		dargs;		/* args for dir/attr code */
> +	struct xfs_da_args	dargs;		/* args for dir/attr code */
>  
>  	if (ip->i_df.if_bytes <= XFS_IFORK_DSIZE(ip))
>  		return 0;
> @@ -1003,7 +1000,7 @@ xfs_bmap_add_attrfork_local(
>  		memset(&dargs, 0, sizeof(dargs));
>  		dargs.geo = ip->i_mount->m_dir_geo;
>  		dargs.dp = ip;
> -		dargs.firstblock = firstblock;
> +		dargs.firstblock = &tp->t_firstblock;
>  		dargs.total = dargs.geo->fsbcount;
>  		dargs.whichfork = XFS_DATA_FORK;
>  		dargs.trans = tp;
> @@ -1011,7 +1008,7 @@ xfs_bmap_add_attrfork_local(
>  	}
>  
>  	if (S_ISLNK(VFS_I(ip)->i_mode))
> -		return xfs_bmap_local_to_extents(tp, ip, firstblock, 1,
> +		return xfs_bmap_local_to_extents(tp, ip, &tp->t_firstblock, 1,
>  						 flags, XFS_DATA_FORK,
>  						 xfs_symlink_local_to_remote);
>  
> @@ -1030,7 +1027,6 @@ xfs_bmap_add_attrfork(
>  	int			size,		/* space new attribute needs */
>  	int			rsvd)		/* xact may use reserved blks */
>  {
> -	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
>  	struct xfs_defer_ops	dfops;		/* freed extent records */
>  	xfs_mount_t		*mp;		/* mount structure */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> @@ -1050,7 +1046,7 @@ xfs_bmap_add_attrfork(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
>  	if (error)
>  		return error;
> -	xfs_defer_init(tp, &dfops, &firstblock);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> @@ -1100,16 +1096,13 @@ xfs_bmap_add_attrfork(
>  	logflags = 0;
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock,
> -						    &logflags);
> +		error = xfs_bmap_add_attrfork_local(tp, ip, &logflags);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> -		error = xfs_bmap_add_attrfork_extents(tp, ip, &firstblock,
> -						      &logflags);
> +		error = xfs_bmap_add_attrfork_extents(tp, ip, &logflags);
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock,
> -						    &logflags);
> +		error = xfs_bmap_add_attrfork_btree(tp, ip, &logflags);
>  		break;
>  	default:
>  		error = 0;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
