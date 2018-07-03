Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbeGCVDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:03:47 -0400
Date: Tue, 3 Jul 2018 14:03:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/24] xfs: use ->t_dfops for collapse/insert range
 operations
Message-ID: <20180703210327.GM32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-18-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-18-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:29PM -0400, Brian Foster wrote:
> Use ->t_dfops for the collapse and insert range transactions. These
> are the only callers of the respective bmap helpers, so replace the
> unnecessary dfops parameters with direct accesses to ->t_dfops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 16 +++++++---------
>  fs/xfs/libxfs/xfs_bmap.h |  6 ++----
>  fs/xfs/xfs_bmap_util.c   | 14 ++++++++------
>  3 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 17b0b22a1edf..1ce1d10a4140 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5685,8 +5685,7 @@ xfs_bmap_collapse_extents(
>  	xfs_fileoff_t		*next_fsb,
>  	xfs_fileoff_t		offset_shift_fsb,
>  	bool			*done,
> -	xfs_fsblock_t		*firstblock,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_fsblock_t		*firstblock)
>  {
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5720,7 +5719,7 @@ xfs_bmap_collapse_extents(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstblock;
> -		cur->bc_private.b.dfops = dfops;
> +		cur->bc_private.b.dfops = tp->t_dfops;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -5741,7 +5740,7 @@ xfs_bmap_collapse_extents(
>  		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
>  			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
>  					&icur, &got, &prev, cur, &logflags,
> -					dfops);
> +					tp->t_dfops);
>  			if (error)
>  				goto del_cursor;
>  			goto done;
> @@ -5754,7 +5753,7 @@ xfs_bmap_collapse_extents(
>  	}
>  
>  	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> -			&logflags, dfops, new_startoff);
> +			&logflags, tp->t_dfops, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
> @@ -5808,8 +5807,7 @@ xfs_bmap_insert_extents(
>  	xfs_fileoff_t		offset_shift_fsb,
>  	bool			*done,
>  	xfs_fileoff_t		stop_fsb,
> -	xfs_fsblock_t		*firstblock,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_fsblock_t		*firstblock)
>  {
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5843,7 +5841,7 @@ xfs_bmap_insert_extents(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstblock;
> -		cur->bc_private.b.dfops = dfops;
> +		cur->bc_private.b.dfops = tp->t_dfops;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -5886,7 +5884,7 @@ xfs_bmap_insert_extents(
>  	}
>  
>  	error = xfs_bmap_shift_update_extent(ip, whichfork, &icur, &got, cur,
> -			&logflags, dfops, new_startoff);
> +			&logflags, tp->t_dfops, new_startoff);
>  	if (error)
>  		goto del_cursor;
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 02811cd31153..2da6c6daada8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -222,14 +222,12 @@ void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>  int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> -		bool *done, xfs_fsblock_t *firstblock,
> -		struct xfs_defer_ops *dfops);
> +		bool *done, xfs_fsblock_t *firstblock);
>  int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
>  		xfs_fileoff_t shift);
>  int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> -		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
> -		struct xfs_defer_ops *dfops);
> +		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock);
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 58b51648240d..2c0c9534941c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1347,12 +1347,13 @@ xfs_collapse_file_space(
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
>  		xfs_defer_init(&dfops, &first_block);
> +		tp->t_dfops = &dfops;
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, &first_block, &dfops);
> +				&done, &first_block);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -		error = xfs_defer_finish(&tp, &dfops);
> +		error = xfs_defer_finish(&tp, tp->t_dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
> @@ -1361,7 +1362,7 @@ xfs_collapse_file_space(
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&dfops);
> +	xfs_defer_cancel(tp->t_dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> @@ -1426,12 +1427,13 @@ xfs_insert_file_space(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  		xfs_defer_init(&dfops, &first_block);
> +		tp->t_dfops = &dfops;
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, stop_fsb, &first_block, &dfops);
> +				&done, stop_fsb, &first_block);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -		error = xfs_defer_finish(&tp, &dfops);
> +		error = xfs_defer_finish(&tp, tp->t_dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
> @@ -1440,7 +1442,7 @@ xfs_insert_file_space(
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&dfops);
> +	xfs_defer_cancel(tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
