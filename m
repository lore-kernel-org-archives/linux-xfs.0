Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752388AbeGDAre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:47:34 -0400
Date: Tue, 3 Jul 2018 17:47:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/25] xfs: use ->t_firstblock for all xfs_bunmapi()
 callers
Message-ID: <20180704004719.GH32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:02PM -0400, Brian Foster wrote:
> Convert all xfs_bunmapi() callers to ->t_firstblock.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 12 ++----------
>  fs/xfs/xfs_bmap_util.c   |  7 +++----
>  fs/xfs/xfs_inode.c       |  5 ++---
>  fs/xfs/xfs_reflink.c     | 11 +++++------
>  fs/xfs/xfs_symlink.c     |  6 +++---
>  5 files changed, 15 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 86097be47ae9..4ace1267fc35 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6134,17 +6134,9 @@ xfs_bmap_finish_one(
>  	xfs_filblks_t			*blockcount,
>  	xfs_exntst_t			state)
>  {
> -	xfs_fsblock_t			firstfsb;
>  	int				error = 0;
>  
> -	/*
> -	 * firstfsb is tied to the transaction lifetime and is used to
> -	 * ensure correct AG locking order and schedule work item
> -	 * continuations.  XFS_BUI_MAX_FAST_EXTENTS (== 1) restricts us
> -	 * to only making one bmap call per transaction, so it should
> -	 * be safe to have it as a local variable here.
> -	 */
> -	firstfsb = NULLFSBLOCK;
> +	ASSERT(tp->t_firstblock == NULLFSBLOCK);
>  
>  	trace_xfs_bmap_deferred(tp->t_mountp,
>  			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
> @@ -6167,7 +6159,7 @@ xfs_bmap_finish_one(
>  		break;
>  	case XFS_BMAP_UNMAP:
>  		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
> -				XFS_BMAPI_REMAP, 1, &firstfsb);
> +				XFS_BMAPI_REMAP, 1, &tp->t_firstblock);
>  		break;
>  	default:
>  		ASSERT(0);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f9a0957343ea..b49364779966 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1023,7 +1023,6 @@ xfs_unmap_extent(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	struct xfs_defer_ops	dfops;
> -	xfs_fsblock_t		firstfsb;
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  	int			error;
>  
> @@ -1041,9 +1040,9 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(tp, &dfops, &firstfsb);
> -	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
> -			    done);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
> +	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2,
> +			    &tp->t_firstblock, done);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ab1fd696500c..3cdfd795a50c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1543,7 +1543,6 @@ xfs_itruncate_extents_flags(
>  	struct xfs_trans	*tp = *tpp;
>  	struct xfs_defer_ops	*odfops = tp->t_dfops;
>  	struct xfs_defer_ops	dfops;
> -	xfs_fsblock_t		first_block;
>  	xfs_fileoff_t		first_unmap_block;
>  	xfs_fileoff_t		last_block;
>  	xfs_filblks_t		unmap_len;
> @@ -1580,9 +1579,9 @@ xfs_itruncate_extents_flags(
>  	ASSERT(first_unmap_block < last_block);
>  	unmap_len = last_block - first_unmap_block + 1;
>  	while (!done) {
> -		xfs_defer_init(tp, &dfops, &first_block);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
> -				    XFS_ITRUNC_MAX_EXTENTS, &first_block,
> +				    XFS_ITRUNC_MAX_EXTENTS, &tp->t_firstblock,
>  				    &done);
>  		if (error)
>  			goto out_bmap_cancel;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f0486b748376..eed6b9df7944 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -690,7 +690,6 @@ xfs_reflink_end_cow(
>  	struct xfs_trans		*tp;
>  	xfs_fileoff_t			offset_fsb;
>  	xfs_fileoff_t			end_fsb;
> -	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
>  	int				error;
>  	unsigned int			resblks;
> @@ -758,10 +757,10 @@ xfs_reflink_end_cow(
>  			goto prev_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
> -		xfs_defer_init(tp, &dfops, &firstfsb);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		rlen = del.br_blockcount;
>  		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
> -				&firstfsb);
> +				&tp->t_firstblock);
>  		if (error)
>  			goto out_defer;
>  
> @@ -1065,7 +1064,6 @@ xfs_reflink_remap_extent(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	bool			real_extent = xfs_bmap_is_real_extent(irec);
>  	struct xfs_trans	*tp;
> -	xfs_fsblock_t		firstfsb;
>  	unsigned int		resblks;
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_bmbt_irec	uirec;
> @@ -1108,8 +1106,9 @@ xfs_reflink_remap_extent(
>  	/* Unmap the old blocks in the data fork. */
>  	rlen = unmap_len;
>  	while (rlen) {
> -		xfs_defer_init(tp, &dfops, &firstfsb);
> -		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1, &firstfsb);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
> +		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
> +				      &tp->t_firstblock);
>  		if (error)
>  			goto out_defer;
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 583ca83353f7..18d9b4d301e5 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -400,7 +400,6 @@ xfs_inactive_symlink_rmt(
>  	xfs_buf_t	*bp;
>  	int		done;
>  	int		error;
> -	xfs_fsblock_t	first_block;
>  	struct xfs_defer_ops	dfops;
>  	int		i;
>  	xfs_mount_t	*mp;
> @@ -440,7 +439,7 @@ xfs_inactive_symlink_rmt(
>  	 * Find the block(s) so we can inval and unmap them.
>  	 */
>  	done = 0;
> -	xfs_defer_init(tp, &dfops, &first_block);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  	nmaps = ARRAY_SIZE(mval);
>  	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
>  				mval, &nmaps, 0);
> @@ -462,7 +461,8 @@ xfs_inactive_symlink_rmt(
>  	/*
>  	 * Unmap the dead block(s) to the dfops.
>  	 */
> -	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &first_block, &done);
> +	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &tp->t_firstblock,
> +			    &done);
>  	if (error)
>  		goto error_bmap_cancel;
>  	ASSERT(done);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
