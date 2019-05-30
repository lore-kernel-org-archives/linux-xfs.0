Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41061 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbfE3BSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 21:18:43 -0400
Date: Thu, 30 May 2019 11:18:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: separate inode geometry
Message-ID: <20190530011833.GE29573@dread.disaster.area>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916878065.757870.5464843093825782642.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916878065.757870.5464843093825782642.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:26:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Separate the inode geometry information into a distinct structure.

I like the idea, but have lots of comments on the patch....

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h       |   33 +++++++++++-
>  fs/xfs/libxfs/xfs_ialloc.c       |  109 ++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_ialloc.h       |    6 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   15 +++--
>  fs/xfs/libxfs/xfs_inode_buf.c    |    2 -
>  fs/xfs/libxfs/xfs_sb.c           |   24 +++++---
>  fs/xfs/libxfs/xfs_trans_resv.c   |   17 +++---
>  fs/xfs/libxfs/xfs_trans_space.h  |    7 +-
>  fs/xfs/libxfs/xfs_types.c        |    4 +
>  fs/xfs/scrub/ialloc.c            |   22 ++++----
>  fs/xfs/scrub/quota.c             |    2 -
>  fs/xfs/xfs_fsops.c               |    4 +
>  fs/xfs/xfs_inode.c               |   17 +++---
>  fs/xfs/xfs_itable.c              |   11 ++--
>  fs/xfs/xfs_log_recover.c         |   23 ++++----
>  fs/xfs/xfs_mount.c               |   49 +++++++++--------
>  fs/xfs/xfs_mount.h               |   17 ------
>  fs/xfs/xfs_super.c               |    6 +-
>  18 files changed, 205 insertions(+), 163 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9bb3c48843ec..66f527b1c461 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1071,7 +1071,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define	XFS_INO_MASK(k)			(uint32_t)((1ULL << (k)) - 1)
>  #define	XFS_INO_OFFSET_BITS(mp)		(mp)->m_sb.sb_inopblog
>  #define	XFS_INO_AGBNO_BITS(mp)		(mp)->m_sb.sb_agblklog
> -#define	XFS_INO_AGINO_BITS(mp)		(mp)->m_agino_log
> +#define	XFS_INO_AGINO_BITS(mp)		((mp)->m_ino_geo.ig_agino_log)
>  #define	XFS_INO_AGNO_BITS(mp)		(mp)->m_agno_log
>  #define	XFS_INO_BITS(mp)		\
>  	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
> @@ -1694,4 +1694,35 @@ struct xfs_acl {
>  #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
>  #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
>  
> +struct xfs_ino_geometry {
> +	/* Maximum inode count in this filesystem. */
> +	uint64_t	ig_maxicount;

Naming is hard. What's the point of adding "ig_" prefix when the
variables mostly already have an "i" somewhere in them that means
"inode"?  And when they are referenced as igeo->ig_i...., then we've
got so much redudant namespace in the code.....

This is one of the reasons when the struct xfs_da_geometry is not
namespaced - it's clear from the code context it's
directory/attribute geometry info, so it doesn't need lots of extra
namespace gunk.

> +
> +	/* Minimum inode buffer size, in bytes. */
> +	unsigned int	ig_min_cluster_size;

What does the "minimum" in this variable mean? cluster size is fixed
for a filesystem, there's no minimum or maximum size....

> +
> +	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
> +	unsigned int	ig_inodes_per_cluster;
> +	unsigned int	ig_blocks_per_cluster;
> +
> +	/* Inode cluster alignment. */
> +	unsigned int	ig_cluster_align;
> +	unsigned int	ig_cluster_align_inodes;
> +
> +	unsigned int	ig_inobt_mxr[2]; /* max inobt btree records */
> +	unsigned int	ig_inobt_mnr[2]; /* min inobt btree records */
> +	unsigned int	ig_in_maxlevels; /* max inobt btree levels. */

inobt_maxlevels?

> +
> +	/* Minimum inode allocation size */
> +	unsigned int	ig_ialloc_inos;
> +	unsigned int	ig_ialloc_blks;

What's "minimum" about these values?

> +	/* Minimum inode blocks for a sparse allocation. */
> +	unsigned int	ig_ialloc_min_blks;
> +
> +	unsigned int	ig_inoalign_mask;/* mask sb_inoalignmt if used */

This goes with the cluster alignment variables, it's always set by
mkfs and used to convert inode numbers to cluster agbnos...

> +	unsigned int	ig_agino_log;	/* #bits for agino in inum */
> +	unsigned int	ig_sinoalign;	/* stripe unit inode alignment */

And this one should be renamed ialloc_align and moved up with the
the other ialloc variables....


> +};
> +
>  #endif /* __XFS_FORMAT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index fe9898875097..c881e0521331 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -299,7 +299,7 @@ xfs_ialloc_inode_init(
>  	 * sizes, manipulate the inodes in buffers  which are multiples of the
>  	 * blocks size.
>  	 */
> -	nbufs = length / mp->m_blocks_per_cluster;
> +	nbufs = length / mp->m_ino_geo.ig_blocks_per_cluster;
>  
>  	/*
>  	 * Figure out what version number to use in the inodes we create.  If
> @@ -343,9 +343,10 @@ xfs_ialloc_inode_init(
>  		 * Get the block.
>  		 */
>  		d = XFS_AGB_TO_DADDR(mp, agno, agbno +
> -				(j * mp->m_blocks_per_cluster));
> +				(j * mp->m_ino_geo.ig_blocks_per_cluster));
>  		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
> -					 mp->m_bsize * mp->m_blocks_per_cluster,
> +					 mp->m_bsize *
> +					 mp->m_ino_geo.ig_blocks_per_cluster,
>  					 XBF_UNMAPPED);

This doesn't improve readability of the code. Please use a local
igeom variable rather than repeatedly using mp->m_ino_geo.ig_....
in the function.


> @@ -690,10 +693,10 @@ xfs_ialloc_ag_alloc(
>  		 * but not to use them in the actual exact allocation.
>  		 */
>  		args.alignment = 1;
> -		args.minalignslop = args.mp->m_cluster_align - 1;
> +		args.minalignslop = args.mp->m_ino_geo.ig_cluster_align - 1;

Ummm, why not igeo->... , like:

>  
>  		/* Allow space for the inode btree to split. */
> -		args.minleft = args.mp->m_in_maxlevels - 1;
> +		args.minleft = igeo->ig_in_maxlevels - 1;

3 lines down?

>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  
> @@ -720,12 +723,12 @@ xfs_ialloc_ag_alloc(
>  		 * pieces, so don't need alignment anyway.
>  		 */
>  		isaligned = 0;
> -		if (args.mp->m_sinoalign) {
> +		if (igeo->ig_sinoalign) {
>  			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
>  			args.alignment = args.mp->m_dalign;
>  			isaligned = 1;
>  		} else
> -			args.alignment = args.mp->m_cluster_align;
> +			args.alignment = args.mp->m_ino_geo.ig_cluster_align;

Ditto (and others).

>  	int			noroom = 0;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
>  	int			okalloc = 1;
>  
>  	if (*IO_agbp) {
> @@ -1733,9 +1737,9 @@ xfs_dialloc(
>  	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
>  	 * which will sacrifice the preciseness but improve the performance.
>  	 */
> -	if (mp->m_maxicount &&
> -	    percpu_counter_read_positive(&mp->m_icount) + mp->m_ialloc_inos
> -							> mp->m_maxicount) {
> +	if (mp->m_ino_geo.ig_maxicount &&

igeo?

> +	    percpu_counter_read_positive(&mp->m_icount) + igeo->ig_ialloc_inos
> +							> igeo->ig_maxicount) {
>  		noroom = 1;
>  		okalloc = 0;
>  	}
> @@ -1852,7 +1856,8 @@ xfs_difree_inode_chunk(
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
>  		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
> -				  mp->m_ialloc_blks, &XFS_RMAP_OINFO_INODES);
> +				  mp->m_ino_geo.ig_ialloc_blks,
> +				  &XFS_RMAP_OINFO_INODES);
>  		return;
>  	}
>  
> @@ -2261,7 +2266,7 @@ xfs_imap_lookup(
>  
>  	/* check that the returned record contains the required inode */
>  	if (rec.ir_startino > agino ||
> -	    rec.ir_startino + mp->m_ialloc_inos <= agino)
> +	    rec.ir_startino + mp->m_ino_geo.ig_ialloc_inos <= agino)
>  		return -EINVAL;
>  
>  	/* for untrusted inodes check it is allocated first */
> @@ -2352,7 +2357,7 @@ xfs_imap(
>  	 * If the inode cluster size is the same as the blocksize or
>  	 * smaller we get to the buffer by simple arithmetics.
>  	 */
> -	if (mp->m_blocks_per_cluster == 1) {
> +	if (mp->m_ino_geo.ig_blocks_per_cluster == 1) {

igeo...

>  		offset = XFS_INO_TO_OFFSET(mp, ino);
>  		ASSERT(offset < mp->m_sb.sb_inopblock);
>  
> @@ -2368,8 +2373,8 @@ xfs_imap(
>  	 * find the location. Otherwise we have to do a btree
>  	 * lookup to find the location.
>  	 */
> -	if (mp->m_inoalign_mask) {
> -		offset_agbno = agbno & mp->m_inoalign_mask;
> +	if (mp->m_ino_geo.ig_inoalign_mask) {
> +		offset_agbno = agbno & mp->m_ino_geo.ig_inoalign_mask;

and here too.

>  		chunk_agbno = agbno - offset_agbno;
>  	} else {
>  		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
> @@ -2381,13 +2386,13 @@ xfs_imap(
>  out_map:
>  	ASSERT(agbno >= chunk_agbno);
>  	cluster_agbno = chunk_agbno +
> -		((offset_agbno / mp->m_blocks_per_cluster) *
> -		 mp->m_blocks_per_cluster);
> +		((offset_agbno / mp->m_ino_geo.ig_blocks_per_cluster) *
> +		 mp->m_ino_geo.ig_blocks_per_cluster);

And here.

>  	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
>  		XFS_INO_TO_OFFSET(mp, ino);
>  
>  	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
> -	imap->im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> +	imap->im_len = XFS_FSB_TO_BB(mp, mp->m_ino_geo.ig_blocks_per_cluster);

and here...

>  	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
>  
>  	/*
> @@ -2409,7 +2414,7 @@ xfs_imap(
>  }
>  
>  /*
> - * Compute and fill in value of m_in_maxlevels.
> + * Compute and fill in value of m_ino_geo.ig_in_maxlevels.
>   */
>  void
>  xfs_ialloc_compute_maxlevels(
> @@ -2418,8 +2423,8 @@ xfs_ialloc_compute_maxlevels(
>  	uint		inodes;
>  
>  	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> -	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp->m_inobt_mnr,
> -							 inodes);
> +	mp->m_ino_geo.ig_in_maxlevels = xfs_btree_compute_maxlevels(
> +			mp->m_ino_geo.ig_inobt_mnr, inodes);


Once we take away the macro:

	inode = (1LL << igeo->agino_log) >> XFS_INODES_PER_CHUNK_LOG
	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
							inodes);

So, shouldn't we just pass igeo into this function now?

>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index e936b7cc9389..b74fa2addd51 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -28,9 +28,9 @@ static inline int
>  xfs_icluster_size_fsb(
>  	struct xfs_mount	*mp)
>  {
> -	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size)
> +	if (mp->m_sb.sb_blocksize >= mp->m_ino_geo.ig_min_cluster_size)
>  		return 1;
> -	return mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
> +	return mp->m_ino_geo.ig_min_cluster_size >> mp->m_sb.sb_blocklog;
>  }

The return value of this is placed in the mp->m_ino_geo structure.
This should pass in the igeo structure the result is written into.
It's other caller should be using the value in the igeo structure,
not calling this function.

>  
> index bc2dfacd2f4a..79cc5cf21e1b 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -28,7 +28,7 @@ xfs_inobt_get_minrecs(
>  	struct xfs_btree_cur	*cur,
>  	int			level)
>  {
> -	return cur->bc_mp->m_inobt_mnr[level != 0];
> +	return cur->bc_mp->m_ino_geo.ig_inobt_mnr[level != 0];
>  }

Put a igeo pointer in the inobt union of the btree cursor?

	return cur->bc_private.a.igeo->inobt_mnr[level != 0];

>  
>  STATIC struct xfs_btree_cur *
> @@ -164,7 +164,7 @@ xfs_inobt_get_maxrecs(
>  	struct xfs_btree_cur	*cur,
>  	int			level)
>  {
> -	return cur->bc_mp->m_inobt_mxr[level != 0];
> +	return cur->bc_mp->m_ino_geo.ig_inobt_mxr[level != 0];
>  }
>  
>  STATIC void
> @@ -281,10 +281,11 @@ xfs_inobt_verify(
>  
>  	/* level verification */
>  	level = be16_to_cpu(block->bb_level);
> -	if (level >= mp->m_in_maxlevels)
> +	if (level >= mp->m_ino_geo.ig_in_maxlevels)
>  		return __this_address;
>  
> -	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
> +	return xfs_btree_sblock_verify(bp,
> +			mp->m_ino_geo.ig_inobt_mxr[level != 0]);
>  }
>  
>  static void
> @@ -546,7 +547,7 @@ xfs_inobt_max_size(
>  	xfs_agblock_t		agblocks = xfs_ag_block_count(mp, agno);
>  
>  	/* Bail out if we're uninitialized, which can happen in mkfs. */
> -	if (mp->m_inobt_mxr[0] == 0)
> +	if (mp->m_ino_geo.ig_inobt_mxr[0] == 0)
>  		return 0;
>  
>  	/*
> @@ -558,7 +559,7 @@ xfs_inobt_max_size(
>  	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
>  		agblocks -= mp->m_sb.sb_logblocks;
>  
> -	return xfs_btree_calc_size(mp->m_inobt_mnr,
> +	return xfs_btree_calc_size(mp->m_ino_geo.ig_inobt_mnr,
>  				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
>  					XFS_INODES_PER_CHUNK);
>  }
> @@ -619,5 +620,5 @@ xfs_iallocbt_calc_size(
>  	struct xfs_mount	*mp,
>  	unsigned long long	len)
>  {
> -	return xfs_btree_calc_size(mp->m_inobt_mnr, len);
> +	return xfs_btree_calc_size(mp->m_ino_geo.ig_inobt_mnr, len);

Should pass igeo into this function now, not xfs_mount.

>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index e021d5133ccb..641aa1c2f1ae 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -36,7 +36,7 @@ xfs_inobp_check(
>  	int		j;
>  	xfs_dinode_t	*dip;
>  
> -	j = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
> +	j = mp->m_ino_geo.ig_min_cluster_size >> mp->m_sb.sb_inodelog;

isn't that "inodes per cluster"?

>  
>  	for (i = 0; i < j; i++) {
>  		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index e76a3e5d28d7..9416fc741788 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -804,16 +804,18 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
>   */
>  void
>  xfs_sb_mount_common(
> -	struct xfs_mount *mp,
> -	struct xfs_sb	*sbp)
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
>  {
> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
> +
>  	mp->m_agfrotor = mp->m_agirotor = 0;
>  	mp->m_maxagi = mp->m_sb.sb_agcount;
>  	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
>  	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
>  	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
>  	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
> -	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
> +	mp->m_ino_geo.ig_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;

igeo.

>  
> @@ -307,7 +308,8 @@ xfs_calc_iunlink_remove_reservation(
>  	struct xfs_mount        *mp)
>  {
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -	       2 * max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size);
> +	       2 * max_t(uint, XFS_FSB_TO_B(mp, 1),
> +			 mp->m_ino_geo.ig_min_cluster_size);
>  }

I'm starting to think a M_IGEO(mp)-like macro is in order here....

>  
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 9b47117180cb..fa7386bf76e9 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -230,7 +230,7 @@ xchk_iallocbt_check_cluster(
>  	int				error = 0;
>  
>  	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
> -			mp->m_inodes_per_cluster);
> +			mp->m_ino_geo.ig_inodes_per_cluster);

igeo.... (many uses in this function)

> @@ -355,6 +356,7 @@ xchk_iallocbt_rec_alignment(
>  {
>  	struct xfs_mount		*mp = bs->sc->mp;
>  	struct xchk_iallocbt		*iabt = bs->private;
> +	struct xfs_ino_geometry		*ig = &mp->m_ino_geo;

igeo, for consistency with the rest of the code.

> @@ -2567,7 +2568,8 @@ xfs_ifree_cluster(
>  		 * to mark all the active inodes on the buffer stale.
>  		 */
>  		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
> -					mp->m_bsize * mp->m_blocks_per_cluster,
> +					mp->m_bsize *
> +						igeo->ig_blocks_per_cluster,
>  					XBF_UNMAPPED);

Back off the indent, don't use another line :)

> @@ -3476,19 +3478,20 @@ xfs_iflush_cluster(
>  	int			cilist_size;
>  	struct xfs_inode	**cilist;
>  	struct xfs_inode	*cip;
> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
>  	int			nr_found;
>  	int			clcount = 0;
>  	int			i;
>  
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  
> -	inodes_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
> +	inodes_per_cluster = igeo->ig_min_cluster_size >> mp->m_sb.sb_inodelog;

that's igeo->inodes_per_cluster again, right?

>  	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
>  	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
>  	if (!cilist)
>  		goto out_put;
>  
> -	mask = ~(((mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
> +	mask = ~(((igeo->ig_min_cluster_size >> mp->m_sb.sb_inodelog)) - 1);

Isn't that:

	mask = ~(inodes_per_cluster - 1);

>  	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
>  	rcu_read_lock();
>  	/* really need a gang lookup range call here */
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 1e1a0af1dd34..cff28ee73deb 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -167,6 +167,7 @@ xfs_bulkstat_ichunk_ra(
>  	xfs_agnumber_t			agno,
>  	struct xfs_inobt_rec_incore	*irec)
>  {
> +	struct xfs_ino_geometry		*igeo = &mp->m_ino_geo;
>  	xfs_agblock_t			agbno;
>  	struct blk_plug			plug;
>  	int				i;	/* inode chunk index */
> @@ -174,12 +175,14 @@ xfs_bulkstat_ichunk_ra(
>  	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
>  
>  	blk_start_plug(&plug);
> -	for (i = 0; i < XFS_INODES_PER_CHUNK;
> -	     i += mp->m_inodes_per_cluster, agbno += mp->m_blocks_per_cluster) {
> -		if (xfs_inobt_maskn(i, mp->m_inodes_per_cluster) &
> +	for (i = 0;
> +	     i < XFS_INODES_PER_CHUNK;
> +	     i += igeo->ig_inodes_per_cluster,
> +			agbno += igeo->ig_blocks_per_cluster) {
> +		if (xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster) &
>  		    ~irec->ir_free) {
>  			xfs_btree_reada_bufs(mp, agno, agbno,
> -					mp->m_blocks_per_cluster,
> +					igeo->ig_blocks_per_cluster,
>  					&xfs_inode_buf_ops);
>  		}

That's a mess :(

	for (i = 0; i < XFS_INODES_PER_CHUNK; i += igeo->inodes_per_cluster) {
		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
							~irec->ir_free) {
			xfs_btree_reada_bufs(mp, agno, agbno,
					igeo->ig_blocks_per_cluster,
					&xfs_inode_buf_ops);
		}
		agbno += igeo->blocks_per_cluster;
	}

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9329f5adbfbe..15118e531184 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2882,19 +2882,19 @@ xlog_recover_buffer_pass2(
>  	 *
>  	 * Also make sure that only inode buffers with good sizes stay in
>  	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
> -	 * or mp->m_inode_cluster_size bytes, whichever is bigger.  The inode
> +	 * or ig_min_cluster_size bytes, whichever is bigger.  The inode
>  	 * buffers in the log can be a different size if the log was generated
>  	 * by an older kernel using unclustered inode buffers or a newer kernel
>  	 * running with a different inode cluster size.  Regardless, if the
> -	 * the inode buffer size isn't max(blocksize, mp->m_inode_cluster_size)
> -	 * for *our* value of mp->m_inode_cluster_size, then we need to keep
> +	 * the inode buffer size isn't max(blocksize, ig_min_cluster_size)
> +	 * for *our* value of ig_min_cluster_size, then we need to keep
>  	 * the buffer out of the buffer cache so that the buffer won't
>  	 * overlap with future reads of those inodes.
>  	 */
>  	if (XFS_DINODE_MAGIC ==
>  	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
>  	    (BBTOB(bp->b_io_length) != max(log->l_mp->m_sb.sb_blocksize,
> -			(uint32_t)log->l_mp->m_inode_cluster_size))) {
> +			(uint32_t)log->l_mp->m_ino_geo.ig_min_cluster_size))) {

cluster size is already an unsigned int so the cast ca go.

>  		xfs_buf_stale(bp);
>  		error = xfs_bwrite(bp);
>  	} else {
> @@ -3849,6 +3849,7 @@ xlog_recover_do_icreate_pass2(
>  {
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_icreate_log	*icl;
> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
>  	unsigned int		count;
> @@ -3898,10 +3899,10 @@ xlog_recover_do_icreate_pass2(
>  
>  	/*
>  	 * The inode chunk is either full or sparse and we only support
> -	 * m_ialloc_min_blks sized sparse allocations at this time.
> +	 * m_ino_geo.ig_ialloc_min_blks sized sparse allocations at this time.
>  	 */
> -	if (length != mp->m_ialloc_blks &&
> -	    length != mp->m_ialloc_min_blks) {
> +	if (length != igeo->ig_ialloc_blks &&
> +	    length != igeo->ig_ialloc_min_blks) {
>  		xfs_warn(log->l_mp,
>  			 "%s: unsupported chunk length", __FUNCTION__);
>  		return -EINVAL;
> @@ -3921,13 +3922,13 @@ xlog_recover_do_icreate_pass2(
>  	 * buffers for cancellation so we don't overwrite anything written after
>  	 * a cancellation.
>  	 */
> -	bb_per_cluster = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> -	nbufs = length / mp->m_blocks_per_cluster;
> +	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->ig_blocks_per_cluster);
> +	nbufs = length / igeo->ig_blocks_per_cluster;
>  	for (i = 0, cancel_count = 0; i < nbufs; i++) {
>  		xfs_daddr_t	daddr;
>  
> -		daddr = XFS_AGB_TO_DADDR(mp, agno,
> -					 agbno + i * mp->m_blocks_per_cluster);
> +		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno +
> +				i * igeo->ig_blocks_per_cluster);

makes no sense to change the line break location.

		daddr = XFS_AGB_TO_DADDR(mp, agno,
				agbno + i * igeo->ig_blocks_per_cluster);


>   */
>  STATIC void
> -xfs_set_maxicount(xfs_mount_t *mp)
> +xfs_set_maxicount(
> +	struct xfs_mount	*mp)
>  {
> -	xfs_sb_t	*sbp = &(mp->m_sb);
> -	uint64_t	icount;
> +	struct xfs_sb		*sbp = &(mp->m_sb);

kill the ().

> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
> +	uint64_t		icount;
>  
>  	if (sbp->sb_imax_pct) {
>  		/*
> @@ -445,11 +447,11 @@ xfs_set_maxicount(xfs_mount_t *mp)
>  		 */
>  		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
>  		do_div(icount, 100);
> -		do_div(icount, mp->m_ialloc_blks);
> -		mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
> -				   sbp->sb_inopblog;
> +		do_div(icount, igeo->ig_ialloc_blks);
> +		igeo->ig_maxicount = XFS_FSB_TO_INO(mp,
> +				icount * igeo->ig_ialloc_blks);
>  	} else {
> -		mp->m_maxicount = 0;
> +		igeo->ig_maxicount = 0;
>  	}
>  }
>  
> @@ -518,18 +520,18 @@ xfs_set_inoalignment(xfs_mount_t *mp)
>  {
>  	if (xfs_sb_version_hasalign(&mp->m_sb) &&
>  		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
> -		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
> +		mp->m_ino_geo.ig_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
>  	else
> -		mp->m_inoalign_mask = 0;
> +		mp->m_ino_geo.ig_inoalign_mask = 0;
>  	/*
>  	 * If we are using stripe alignment, check whether
>  	 * the stripe unit is a multiple of the inode alignment
>  	 */
> -	if (mp->m_dalign && mp->m_inoalign_mask &&
> -	    !(mp->m_dalign & mp->m_inoalign_mask))
> -		mp->m_sinoalign = mp->m_dalign;
> +	if (mp->m_dalign && mp->m_ino_geo.ig_inoalign_mask &&
> +	    !(mp->m_dalign & mp->m_ino_geo.ig_inoalign_mask))
> +		mp->m_ino_geo.ig_sinoalign = mp->m_dalign;
>  	else
> -		mp->m_sinoalign = 0;
> +		mp->m_ino_geo.ig_sinoalign = 0;

should pass in igeo to this function....

>  }
>  
>  /*
> @@ -683,6 +685,7 @@ xfs_mountfs(
>  {
>  	struct xfs_sb		*sbp = &(mp->m_sb);
>  	struct xfs_inode	*rip;
> +	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
>  	uint64_t		resblks;
>  	uint			quotamount = 0;
>  	uint			quotaflags = 0;
> @@ -797,18 +800,20 @@ xfs_mountfs(
>  	 * has set the inode alignment value appropriately for larger cluster
>  	 * sizes.
>  	 */
> -	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +	igeo->ig_min_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		int	new_size = mp->m_inode_cluster_size;
> +		int	new_size = igeo->ig_min_cluster_size;
>  
>  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
>  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> -			mp->m_inode_cluster_size = new_size;
> +			igeo->ig_min_cluster_size = new_size;
>  	}
> -	mp->m_blocks_per_cluster = xfs_icluster_size_fsb(mp);
> -	mp->m_inodes_per_cluster = XFS_FSB_TO_INO(mp, mp->m_blocks_per_cluster);
> -	mp->m_cluster_align = xfs_ialloc_cluster_alignment(mp);
> -	mp->m_cluster_align_inodes = XFS_FSB_TO_INO(mp, mp->m_cluster_align);
> +	igeo->ig_blocks_per_cluster = xfs_icluster_size_fsb(mp);
> +	igeo->ig_inodes_per_cluster = XFS_FSB_TO_INO(mp,
> +			igeo->ig_blocks_per_cluster);
> +	igeo->ig_cluster_align = xfs_ialloc_cluster_alignment(mp);
> +	igeo->ig_cluster_align_inodes = XFS_FSB_TO_INO(mp,
> +			igeo->ig_cluster_align);

Can we separate out all the igeo initialsation into a single init
function rather than being spread out over several functions?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
