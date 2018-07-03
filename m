Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbeGCVCb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:02:31 -0400
Date: Tue, 3 Jul 2018 14:02:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/24] xfs: remove xfs_bmapi_remap() dfops param
Message-ID: <20180703210217.GK32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:27PM -0400, Brian Foster wrote:
> All xfs_bmapi_remap() callers already use ->t_dfops. Note that
> deferred completion context unconditionally sets ->t_dfops if it
> hasn't already been set by the caller. Remove the unnecessary
> parameter and access ->t_dfops directly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 8 ++++----
>  fs/xfs/libxfs/xfs_bmap.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 25769e4f424c..2bbeccad1e90 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4513,7 +4513,6 @@ xfs_bmapi_remap(
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
>  	xfs_fsblock_t		startblock,
> -	struct xfs_defer_ops	*dfops,
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -4563,7 +4562,7 @@ xfs_bmapi_remap(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = firstblock;
> -		cur->bc_private.b.dfops = dfops;
> +		cur->bc_private.b.dfops = tp->t_dfops;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -4576,7 +4575,7 @@ xfs_bmapi_remap(
>  		got.br_state = XFS_EXT_NORM;
>  
>  	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
> -			&cur, &got, &firstblock, dfops, &logflags, flags);
> +			&cur, &got, &firstblock, tp->t_dfops, &logflags, flags);
>  	if (error)
>  		goto error0;
>  
> @@ -6187,8 +6186,9 @@ xfs_bmap_finish_one(
>  
>  	switch (type) {
>  	case XFS_BMAP_MAP:
> +		ASSERT(dfops == tp->t_dfops);
>  		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
> -				startblock, dfops, 0);
> +				startblock, 0);
>  		*blockcount = 0;
>  		break;
>  	case XFS_BMAP_UNMAP:
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 4ff56f55f2bb..1e2694adb9c7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -287,6 +287,6 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
>  
>  int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
> -		struct xfs_defer_ops *dfops, int flags);
> +		int flags);
>  
>  #endif	/* __XFS_BMAP_H__ */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
