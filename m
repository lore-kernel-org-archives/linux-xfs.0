Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbeGDAvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:51:31 -0400
Date: Tue, 3 Jul 2018 17:51:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/25] xfs: remove bmap insert/collapse firstblock param
Message-ID: <20180704005116.GM32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:07PM -0400, Brian Foster wrote:
> The only callers pass ->t_firstblock.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 10 ++++------
>  fs/xfs/libxfs/xfs_bmap.h |  4 ++--
>  fs/xfs/xfs_bmap_util.c   |  4 ++--
>  3 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 967d12f9e415..c9023c08a78d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5654,8 +5654,7 @@ xfs_bmap_collapse_extents(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		*next_fsb,
>  	xfs_fileoff_t		offset_shift_fsb,
> -	bool			*done,
> -	xfs_fsblock_t		*firstblock)
> +	bool			*done)
>  {
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5688,7 +5687,7 @@ xfs_bmap_collapse_extents(
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_private.b.firstblock = *firstblock;
> +		cur->bc_private.b.firstblock = tp->t_firstblock;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -5775,8 +5774,7 @@ xfs_bmap_insert_extents(
>  	xfs_fileoff_t		*next_fsb,
>  	xfs_fileoff_t		offset_shift_fsb,
>  	bool			*done,
> -	xfs_fileoff_t		stop_fsb,
> -	xfs_fsblock_t		*firstblock)
> +	xfs_fileoff_t		stop_fsb)
>  {
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -5809,7 +5807,7 @@ xfs_bmap_insert_extents(
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_private.b.firstblock = *firstblock;
> +		cur->bc_private.b.firstblock = tp->t_firstblock;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 14e21dcc3044..fa839679ecb6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -220,12 +220,12 @@ void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>  int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> -		bool *done, xfs_fsblock_t *firstblock);
> +		bool *done);
>  int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
>  		xfs_fileoff_t shift);
>  int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> -		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock);
> +		bool *done, xfs_fileoff_t stop_fsb);
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 3675babb5202..6d2baf51fec9 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1342,7 +1342,7 @@ xfs_collapse_file_space(
>  
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, &tp->t_firstblock);
> +				&done);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1420,7 +1420,7 @@ xfs_insert_file_space(
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, stop_fsb, &tp->t_firstblock);
> +				&done, stop_fsb);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
