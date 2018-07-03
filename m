Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753114AbeGCUbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 16:31:12 -0400
Date: Tue, 3 Jul 2018 13:30:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/24] xfs: use ->t_dfops in extent split tx and remove
 param
Message-ID: <20180703203057.GE32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:20PM -0400, Brian Foster wrote:
> Attach the local dfops to ->t_dfops of the extent split transaction.
> Since this is the only caller of xfs_bmap_split_extent_at(), remove
> the dfops parameter as well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c4b81fee2dee..dbd07b0adfa3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5921,8 +5921,7 @@ xfs_bmap_split_extent_at(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		split_fsb,
> -	xfs_fsblock_t		*firstfsb,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_fsblock_t		*firstfsb)
>  {
>  	int				whichfork = XFS_DATA_FORK;
>  	struct xfs_btree_cur		*cur = NULL;
> @@ -5972,7 +5971,7 @@ xfs_bmap_split_extent_at(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstfsb;
> -		cur->bc_private.b.dfops = dfops;
> +		cur->bc_private.b.dfops = tp->t_dfops;
>  		cur->bc_private.b.flags = 0;
>  		error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  		if (error)
> @@ -6016,7 +6015,7 @@ xfs_bmap_split_extent_at(
>  		int tmp_logflags; /* partial log flag return val */
>  
>  		ASSERT(cur == NULL);
> -		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, dfops,
> +		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, tp->t_dfops,
>  				&cur, 0, &tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  	}
> @@ -6048,14 +6047,14 @@ xfs_bmap_split_extent(
>  			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
>  	if (error)
>  		return error;
> +	xfs_defer_init(&dfops, &firstfsb);
> +	tp->t_dfops = &dfops;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -	xfs_defer_init(&dfops, &firstfsb);
> -
>  	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
> -			&firstfsb, &dfops);
> +					 &firstfsb);
>  	if (error)
>  		goto out;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
