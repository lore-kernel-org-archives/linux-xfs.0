Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdFGPLf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 11:11:35 -0400
Date: Wed, 7 Jun 2017 11:11:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 10/13] xfs: refactor the ifork block counting function
Message-ID: <20170607151132.GF64146@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870157.23065.16428953914864164786.stgit@birch.djwong.org>
 <20170607012916.GE4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607012916.GE4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 06:29:16PM -0700, Darrick J. Wong wrote:
> Refactor the inode fork block counting function to count extents for us
> at the same time.  This will be used by the bmbt scrubber function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c |  109 +++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_bmap_util.h |    4 ++
>  2 files changed, 70 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index a34c3ce..4baaff1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -224,7 +224,8 @@ xfs_bmap_eof(
>  STATIC void
>  xfs_bmap_count_leaves(
>  	struct xfs_ifork	*ifp,
> -	int			*count)
> +	xfs_extnum_t		*numrecs,
> +	xfs_filblks_t		*count)
>  {
>  	xfs_extnum_t		i;
>  	xfs_extnum_t		nr_exts = xfs_iext_count(ifp);
> @@ -232,6 +233,7 @@ xfs_bmap_count_leaves(
>  	for (i = 0; i < nr_exts; i++) {
>  		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, i);
>  		if (!isnullstartblock(xfs_bmbt_get_startblock(frp))) {
> +			(*numrecs)++;
>  			*count += xfs_bmbt_get_blockcount(frp);
>  		}
>  	}
> @@ -246,7 +248,7 @@ xfs_bmap_disk_count_leaves(
>  	struct xfs_mount	*mp,
>  	struct xfs_btree_block	*block,
>  	int			numrecs,
> -	int			*count)
> +	xfs_filblks_t		*count)
>  {
>  	int		b;
>  	xfs_bmbt_rec_t	*frp;
> @@ -261,17 +263,18 @@ xfs_bmap_disk_count_leaves(
>   * Recursively walks each level of a btree
>   * to count total fsblocks in use.
>   */
> -STATIC int                                     /* error */
> +STATIC int
>  xfs_bmap_count_tree(
> -	xfs_mount_t     *mp,            /* file system mount point */
> -	xfs_trans_t     *tp,            /* transaction pointer */
> -	xfs_ifork_t	*ifp,		/* inode fork pointer */
> -	xfs_fsblock_t   blockno,	/* file system block number */
> -	int             levelin,	/* level in btree */
> -	int		*count)		/* Count of blocks */
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_ifork	*ifp,
> +	xfs_fsblock_t		blockno,
> +	int			levelin,
> +	xfs_extnum_t		*nextents,
> +	xfs_filblks_t		*count)
>  {
>  	int			error;
> -	xfs_buf_t		*bp, *nbp;
> +	struct xfs_buf		*bp, *nbp;
>  	int			level = levelin;
>  	__be64			*pp;
>  	xfs_fsblock_t           bno = blockno;
> @@ -304,8 +307,9 @@ xfs_bmap_count_tree(
>  		/* Dive to the next level */
>  		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
>  		bno = be64_to_cpu(*pp);
> -		if (unlikely((error =
> -		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
> +		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level, nextents,
> +				count);
> +		if (error) {
>  			xfs_trans_brelse(tp, bp);
>  			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
>  					 XFS_ERRLEVEL_LOW, mp);
> @@ -317,6 +321,7 @@ xfs_bmap_count_tree(
>  		for (;;) {
>  			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
>  			numrecs = be16_to_cpu(block->bb_numrecs);
> +			(*nextents) += numrecs;
>  			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
>  			xfs_trans_brelse(tp, bp);
>  			if (nextbno == NULLFSBLOCK)
> @@ -337,44 +342,61 @@ xfs_bmap_count_tree(
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
> +	xfs_extnum_t		*nextents,
> +	xfs_filblks_t		*count)
>  {
> +	struct xfs_mount	*mp;	/* file system mount structure */
> +	__be64			*pp;	/* pointer to block address */
>  	struct xfs_btree_block	*block;	/* current btree block */
> +	struct xfs_ifork	*ifp;	/* fork structure */
>  	xfs_fsblock_t		bno;	/* block # of "block" */
> -	xfs_ifork_t		*ifp;	/* fork structure */
>  	int			level;	/* btree level, for checking */
> -	xfs_mount_t		*mp;	/* file system mount structure */
> -	__be64			*pp;	/* pointer to block address */
> +	int			error;
>  
>  	bno = NULLFSBLOCK;
>  	mp = ip->i_mount;
> +	*nextents = 0;
> +	*count = 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
> -		xfs_bmap_count_leaves(ifp, count);
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
> +		xfs_bmap_count_leaves(ifp, nextents, count);
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
> @@ -1790,8 +1812,9 @@ xfs_swap_extent_forks(
>  	int			*target_log_flags)
>  {
>  	struct xfs_ifork	tempifp, *ifp, *tifp;
> -	int			aforkblks = 0;
> -	int			taforkblks = 0;
> +	xfs_filblks_t		aforkblks;
> +	xfs_filblks_t		taforkblks;
> +	xfs_extnum_t		junk;
>  	xfs_extnum_t		nextents;
>  	uint64_t		tmp;
>  	int			error;
> @@ -1801,14 +1824,14 @@ xfs_swap_extent_forks(
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
> index 135d826..0cede10 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -70,4 +70,8 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
>  
>  xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
>  
> +int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
> +			  int whichfork, xfs_extnum_t *nextents,
> +			  xfs_filblks_t *count);
> +
>  #endif	/* __XFS_BMAP_UTIL_H__ */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
