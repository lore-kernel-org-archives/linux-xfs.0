Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbdFFQ3X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 12:29:23 -0400
Date: Tue, 6 Jun 2017 12:29:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/13] xfs: refactor the ifork block counting function
Message-ID: <20170606162920.GE55166@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870157.23065.16428953914864164786.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643870157.23065.16428953914864164786.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:25:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the inode fork block counting function to count extents for us
> at the same time.  This will be used by the bmbt scrubber function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  105 +++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_bmap_util.h |    4 ++
>  2 files changed, 67 insertions(+), 42 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fe83bbc..fc15305 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
...
> @@ -336,44 +339,61 @@ xfs_bmap_count_tree(
>  /*
>   * Count fsblocks of the given fork.
>   */
> -static int					/* error */
> +int
>  xfs_bmap_count_blocks(
> -	xfs_trans_t		*tp,		/* transaction pointer */
> -	xfs_inode_t		*ip,		/* incore inode */
> -	int			whichfork,	/* data or attr fork */
> -	int			*count)		/* out: count of blocks */
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	unsigned int		*nextents,
> +	unsigned long long	*count)
>  {
>  	struct xfs_btree_block	*block;	/* current btree block */
>  	xfs_fsblock_t		bno;	/* block # of "block" */
> -	xfs_ifork_t		*ifp;	/* fork structure */
> +	struct xfs_ifork	*ifp;	/* fork structure */
>  	int			level;	/* btree level, for checking */
> -	xfs_mount_t		*mp;	/* file system mount structure */
> +	struct xfs_mount	*mp;	/* file system mount structure */
>  	__be64			*pp;	/* pointer to block address */
> +	int			error;
>  
>  	bno = NULLFSBLOCK;
>  	mp = ip->i_mount;
> +	*nextents = 0;

I think we should be consistent between how we initialize nextents and
count, whether we initialize both here or expect the caller to do it.
That aside, the rest looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
> -		xfs_bmap_count_leaves(ifp, 0, xfs_iext_count(ifp), count);
> +	if (!ifp)
>  		return 0;
> -	}
>  
> -	/*
> -	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
> -	 */
> -	block = ifp->if_broot;
> -	level = be16_to_cpu(block->bb_level);
> -	ASSERT(level > 0);
> -	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
> -	bno = be64_to_cpu(*pp);
> -	ASSERT(bno != NULLFSBLOCK);
> -	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
> -	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
> -
> -	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
> -		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
> -				 mp);
> -		return -EFSCORRUPTED;
> +	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> +	case XFS_DINODE_FMT_EXTENTS:
> +		*nextents = xfs_iext_count(ifp);
> +		xfs_bmap_count_leaves(ifp, 0, (*nextents), count);
> +		return 0;
> +	case XFS_DINODE_FMT_BTREE:
> +		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +			error = xfs_iread_extents(tp, ip, whichfork);
> +			if (error)
> +				return error;
> +		}
> +
> +		/*
> +		 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
> +		 */
> +		block = ifp->if_broot;
> +		level = be16_to_cpu(block->bb_level);
> +		ASSERT(level > 0);
> +		pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
> +		bno = be64_to_cpu(*pp);
> +		ASSERT(bno != NULLFSBLOCK);
> +		ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
> +		ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
> +
> +		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level,
> +				nextents, count);
> +		if (error) {
> +			XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)",
> +					XFS_ERRLEVEL_LOW, mp);
> +			return -EFSCORRUPTED;
> +		}
> +		return 0;
>  	}
>  
>  	return 0;
> @@ -1789,8 +1809,9 @@ xfs_swap_extent_forks(
>  	int			*target_log_flags)
>  {
>  	struct xfs_ifork	tempifp, *ifp, *tifp;
> -	int			aforkblks = 0;
> -	int			taforkblks = 0;
> +	unsigned long long	aforkblks = 0;
> +	unsigned long long	taforkblks = 0;
> +	unsigned int		junk;
>  	xfs_extnum_t		nextents;
>  	uint64_t		tmp;
>  	int			error;
> @@ -1800,14 +1821,14 @@ xfs_swap_extent_forks(
>  	 */
>  	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
>  	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
> -		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK,
> +		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
>  				&aforkblks);
>  		if (error)
>  			return error;
>  	}
>  	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
>  	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
> -		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
> +		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
>  				&taforkblks);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 135d826..993973c 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -70,4 +70,8 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
>  
>  xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
>  
> +int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
> +			  int whichfork, unsigned int *nextents,
> +			  unsigned long long *count);
> +
>  #endif	/* __XFS_BMAP_UTIL_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
