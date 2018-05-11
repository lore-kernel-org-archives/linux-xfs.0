Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKPUV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 11:20:21 -0400
Date: Fri, 11 May 2018 11:20:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: make xfs_bmapi_remapi work with attribute forks
Message-ID: <20180511152019.GH105683@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597992982.25215.1084122529570117868.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597992982.25215.1084122529570117868.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 12:18:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new flags argument to xfs_bmapi_remapi so that we can pass BMAPI
> flags into the function.  This enables us to pass in BMAPI_ATTRFORK so
> that we can remap things into the attribute fork.  Eventually the
> online repair code will use this to rebuild attribute forks, so make it
> non-static.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |   28 ++++++++++++++++------------
>  fs/xfs/libxfs/xfs_bmap.h |    4 ++++
>  2 files changed, 20 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0fd051064ff0..b63e15a114f3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4520,30 +4520,34 @@ xfs_bmapi_write(
>  	return error;
>  }
>  
> -static int
> +int
>  xfs_bmapi_remap(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
>  	xfs_fsblock_t		startblock,
> -	struct xfs_defer_ops	*dfops)
> +	struct xfs_defer_ops	*dfops,
> +	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_ifork	*ifp;
>  	struct xfs_btree_cur	*cur = NULL;
>  	xfs_fsblock_t		firstblock = NULLFSBLOCK;
>  	struct xfs_bmbt_irec	got;
>  	struct xfs_iext_cursor	icur;
> +	int			whichfork = xfs_bmapi_whichfork(flags);
>  	int			logflags = 0, error;
>  
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(len > 0);
>  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
>  
>  	if (unlikely(XFS_TEST_ERROR(
> -	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
> -	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
> +	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
>  	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
> @@ -4553,7 +4557,7 @@ xfs_bmapi_remap(
>  		return -EIO;
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		error = xfs_iread_extents(tp, ip, whichfork);
>  		if (error)
>  			return error;
>  	}
> @@ -4568,7 +4572,7 @@ xfs_bmapi_remap(
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
> -		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> +		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = firstblock;
>  		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.flags = 0;
> @@ -4579,16 +4583,16 @@ xfs_bmapi_remap(
>  	got.br_blockcount = len;
>  	got.br_state = XFS_EXT_NORM;
>  
> -	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
> -			&cur, &got, &firstblock, dfops, &logflags, 0);
> +	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
> +			&cur, &got, &firstblock, dfops, &logflags, flags);
>  	if (error)
>  		goto error0;
>  
> -	if (xfs_bmap_wants_extents(ip, XFS_DATA_FORK)) {
> +	if (xfs_bmap_wants_extents(ip, whichfork)) {
>  		int		tmp_logflags = 0;
>  
>  		error = xfs_bmap_btree_to_extents(tp, ip, cur,
> -			&tmp_logflags, XFS_DATA_FORK);
> +			&tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  	}
>  
> @@ -6162,7 +6166,7 @@ xfs_bmap_finish_one(
>  	switch (type) {
>  	case XFS_BMAP_MAP:
>  		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
> -				startblock, dfops);
> +				startblock, dfops, 0);
>  		*blockcount = 0;
>  		break;
>  	case XFS_BMAP_UNMAP:
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6046012674c8..2c233f9f1a26 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -297,4 +297,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
>  xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
>  		struct xfs_bmbt_irec *irec);
>  
> +int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
> +		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
> +		struct xfs_defer_ops *dfops, int flags);
> +
>  #endif	/* __XFS_BMAP_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
