Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42114 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfE2W02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:26:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM466E022827
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:25 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2spw4tmta0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMPqoS141863
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2srbdxndwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMQMv0003306
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:23 GMT
Subject: [PATCH 01/11] xfs: separate inode geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 May 2019 15:26:20 -0700
Message-ID: <155916878065.757870.5464843093825782642.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Separate the inode geometry information into a distinct structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |   33 +++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c       |  109 ++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_ialloc.h       |    6 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   15 +++--
 fs/xfs/libxfs/xfs_inode_buf.c    |    2 -
 fs/xfs/libxfs/xfs_sb.c           |   24 +++++---
 fs/xfs/libxfs/xfs_trans_resv.c   |   17 +++---
 fs/xfs/libxfs/xfs_trans_space.h  |    7 +-
 fs/xfs/libxfs/xfs_types.c        |    4 +
 fs/xfs/scrub/ialloc.c            |   22 ++++----
 fs/xfs/scrub/quota.c             |    2 -
 fs/xfs/xfs_fsops.c               |    4 +
 fs/xfs/xfs_inode.c               |   17 +++---
 fs/xfs/xfs_itable.c              |   11 ++--
 fs/xfs/xfs_log_recover.c         |   23 ++++----
 fs/xfs/xfs_mount.c               |   49 +++++++++--------
 fs/xfs/xfs_mount.h               |   17 ------
 fs/xfs/xfs_super.c               |    6 +-
 18 files changed, 205 insertions(+), 163 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9bb3c48843ec..66f527b1c461 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1071,7 +1071,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define	XFS_INO_MASK(k)			(uint32_t)((1ULL << (k)) - 1)
 #define	XFS_INO_OFFSET_BITS(mp)		(mp)->m_sb.sb_inopblog
 #define	XFS_INO_AGBNO_BITS(mp)		(mp)->m_sb.sb_agblklog
-#define	XFS_INO_AGINO_BITS(mp)		(mp)->m_agino_log
+#define	XFS_INO_AGINO_BITS(mp)		((mp)->m_ino_geo.ig_agino_log)
 #define	XFS_INO_AGNO_BITS(mp)		(mp)->m_agno_log
 #define	XFS_INO_BITS(mp)		\
 	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
@@ -1694,4 +1694,35 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+struct xfs_ino_geometry {
+	/* Maximum inode count in this filesystem. */
+	uint64_t	ig_maxicount;
+
+	/* Minimum inode buffer size, in bytes. */
+	unsigned int	ig_min_cluster_size;
+
+	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
+	unsigned int	ig_inodes_per_cluster;
+	unsigned int	ig_blocks_per_cluster;
+
+	/* Inode cluster alignment. */
+	unsigned int	ig_cluster_align;
+	unsigned int	ig_cluster_align_inodes;
+
+	unsigned int	ig_inobt_mxr[2]; /* max inobt btree records */
+	unsigned int	ig_inobt_mnr[2]; /* min inobt btree records */
+	unsigned int	ig_in_maxlevels; /* max inobt btree levels. */
+
+	/* Minimum inode allocation size */
+	unsigned int	ig_ialloc_inos;
+	unsigned int	ig_ialloc_blks;
+
+	/* Minimum inode blocks for a sparse allocation. */
+	unsigned int	ig_ialloc_min_blks;
+
+	unsigned int	ig_inoalign_mask;/* mask sb_inoalignmt if used */
+	unsigned int	ig_agino_log;	/* #bits for agino in inum */
+	unsigned int	ig_sinoalign;	/* stripe unit inode alignment */
+};
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fe9898875097..c881e0521331 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -299,7 +299,7 @@ xfs_ialloc_inode_init(
 	 * sizes, manipulate the inodes in buffers  which are multiples of the
 	 * blocks size.
 	 */
-	nbufs = length / mp->m_blocks_per_cluster;
+	nbufs = length / mp->m_ino_geo.ig_blocks_per_cluster;
 
 	/*
 	 * Figure out what version number to use in the inodes we create.  If
@@ -343,9 +343,10 @@ xfs_ialloc_inode_init(
 		 * Get the block.
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno +
-				(j * mp->m_blocks_per_cluster));
+				(j * mp->m_ino_geo.ig_blocks_per_cluster));
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize * mp->m_blocks_per_cluster,
+					 mp->m_bsize *
+					 mp->m_ino_geo.ig_blocks_per_cluster,
 					 XBF_UNMAPPED);
 		if (!fbuf)
 			return -ENOMEM;
@@ -353,7 +354,7 @@ xfs_ialloc_inode_init(
 		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
-		for (i = 0; i < mp->m_inodes_per_cluster; i++) {
+		for (i = 0; i < mp->m_ino_geo.ig_inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
 			uint	isize = xfs_dinode_size(version);
 
@@ -616,24 +617,26 @@ xfs_inobt_insert_sprec(
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
-STATIC int				/* error code or 0 */
+STATIC int
 xfs_ialloc_ag_alloc(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*agbp,		/* alloc group buffer */
-	int		*alloc)
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	int			*alloc)
 {
-	xfs_agi_t	*agi;		/* allocation group header */
-	xfs_alloc_arg_t	args;		/* allocation argument structure */
-	xfs_agnumber_t	agno;
-	int		error;
-	xfs_agino_t	newino;		/* new first inode's number */
-	xfs_agino_t	newlen;		/* new number of inodes */
-	int		isaligned = 0;	/* inode allocation at stripe unit */
-					/* boundary */
-	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
+	struct xfs_agi		*agi;
+	struct xfs_alloc_arg	args;
+	xfs_agnumber_t		agno;
+	int			error;
+	xfs_agino_t		newino;		/* new first inode's number */
+	xfs_agino_t		newlen;		/* new number of inodes */
+	int			isaligned = 0;	/* inode allocation at stripe */
+						/* unit boundary */
+	/* init. to full chunk */
+	uint16_t		allocmask = (uint16_t) -1;
 	struct xfs_inobt_rec_incore rec;
-	struct xfs_perag *pag;
-	int		do_sparse = 0;
+	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = &tp->t_mountp->m_ino_geo;
+	int			do_sparse = 0;
 
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
@@ -644,7 +647,7 @@ xfs_ialloc_ag_alloc(
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
 	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb) &&
-	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks)
+	    igeo->ig_ialloc_min_blks < igeo->ig_ialloc_blks)
 		do_sparse = prandom_u32() & 1;
 #endif
 
@@ -652,12 +655,12 @@ xfs_ialloc_ag_alloc(
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
 	 */
-	newlen = args.mp->m_ialloc_inos;
-	if (args.mp->m_maxicount &&
+	newlen = igeo->ig_ialloc_inos;
+	if (igeo->ig_maxicount &&
 	    percpu_counter_read_positive(&args.mp->m_icount) + newlen >
-							args.mp->m_maxicount)
+							igeo->ig_maxicount)
 		return -ENOSPC;
-	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
+	args.minlen = args.maxlen = igeo->ig_ialloc_blks;
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -667,7 +670,7 @@ xfs_ialloc_ag_alloc(
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-		     args.mp->m_ialloc_blks;
+		     igeo->ig_ialloc_blks;
 	if (do_sparse)
 		goto sparse_alloc;
 	if (likely(newino != NULLAGINO &&
@@ -690,10 +693,10 @@ xfs_ialloc_ag_alloc(
 		 * but not to use them in the actual exact allocation.
 		 */
 		args.alignment = 1;
-		args.minalignslop = args.mp->m_cluster_align - 1;
+		args.minalignslop = args.mp->m_ino_geo.ig_cluster_align - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = args.mp->m_in_maxlevels - 1;
+		args.minleft = igeo->ig_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 
@@ -720,12 +723,12 @@ xfs_ialloc_ag_alloc(
 		 * pieces, so don't need alignment anyway.
 		 */
 		isaligned = 0;
-		if (args.mp->m_sinoalign) {
+		if (igeo->ig_sinoalign) {
 			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
-			args.alignment = args.mp->m_cluster_align;
+			args.alignment = args.mp->m_ino_geo.ig_cluster_align;
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
@@ -741,7 +744,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = args.mp->m_in_maxlevels - 1;
+		args.minleft = igeo->ig_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -754,7 +757,7 @@ xfs_ialloc_ag_alloc(
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
-		args.alignment = args.mp->m_cluster_align;
+		args.alignment = args.mp->m_ino_geo.ig_cluster_align;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -764,7 +767,7 @@ xfs_ialloc_ag_alloc(
 	 * the sparse allocation length is smaller than a full chunk.
 	 */
 	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
-	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
+	    igeo->ig_ialloc_min_blks < igeo->ig_ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -773,7 +776,7 @@ xfs_ialloc_ag_alloc(
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
-		args.minlen = args.mp->m_ialloc_min_blks;
+		args.minlen = igeo->ig_ialloc_min_blks;
 		args.maxlen = args.minlen;
 
 		/*
@@ -789,7 +792,7 @@ xfs_ialloc_ag_alloc(
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
 		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
 					    args.mp->m_sb.sb_inoalignmt) -
-				 args.mp->m_ialloc_blks;
+				 igeo->ig_ialloc_blks;
 
 		error = xfs_alloc_vextent(&args);
 		if (error)
@@ -1006,8 +1009,8 @@ xfs_ialloc_ag_select(
 		 * space needed for alignment of inode chunks when checking the
 		 * longest contiguous free space in the AG - this prevents us
 		 * from getting ENOSPC because we have free space larger than
-		 * m_ialloc_blks but alignment constraints prevent us from using
-		 * it.
+		 * ig_ialloc_blks but alignment constraints prevent us from
+		 * using it.
 		 *
 		 * If we can't find an AG with space for full alignment slack to
 		 * be taken into account, we must be near ENOSPC in all AGs.
@@ -1015,9 +1018,9 @@ xfs_ialloc_ag_select(
 		 * if we fail allocation due to alignment issues then it is most
 		 * likely a real ENOSPC condition.
 		 */
-		ineed = mp->m_ialloc_min_blks;
+		ineed = mp->m_ino_geo.ig_ialloc_min_blks;
 		if (flags && ineed > 1)
-			ineed += mp->m_cluster_align;
+			ineed += mp->m_ino_geo.ig_cluster_align;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
@@ -1703,6 +1706,7 @@ xfs_dialloc(
 	int			noroom = 0;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
 	int			okalloc = 1;
 
 	if (*IO_agbp) {
@@ -1733,9 +1737,9 @@ xfs_dialloc(
 	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
 	 * which will sacrifice the preciseness but improve the performance.
 	 */
-	if (mp->m_maxicount &&
-	    percpu_counter_read_positive(&mp->m_icount) + mp->m_ialloc_inos
-							> mp->m_maxicount) {
+	if (mp->m_ino_geo.ig_maxicount &&
+	    percpu_counter_read_positive(&mp->m_icount) + igeo->ig_ialloc_inos
+							> igeo->ig_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
@@ -1852,7 +1856,8 @@ xfs_difree_inode_chunk(
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  mp->m_ialloc_blks, &XFS_RMAP_OINFO_INODES);
+				  mp->m_ino_geo.ig_ialloc_blks,
+				  &XFS_RMAP_OINFO_INODES);
 		return;
 	}
 
@@ -2261,7 +2266,7 @@ xfs_imap_lookup(
 
 	/* check that the returned record contains the required inode */
 	if (rec.ir_startino > agino ||
-	    rec.ir_startino + mp->m_ialloc_inos <= agino)
+	    rec.ir_startino + mp->m_ino_geo.ig_ialloc_inos <= agino)
 		return -EINVAL;
 
 	/* for untrusted inodes check it is allocated first */
@@ -2352,7 +2357,7 @@ xfs_imap(
 	 * If the inode cluster size is the same as the blocksize or
 	 * smaller we get to the buffer by simple arithmetics.
 	 */
-	if (mp->m_blocks_per_cluster == 1) {
+	if (mp->m_ino_geo.ig_blocks_per_cluster == 1) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
@@ -2368,8 +2373,8 @@ xfs_imap(
 	 * find the location. Otherwise we have to do a btree
 	 * lookup to find the location.
 	 */
-	if (mp->m_inoalign_mask) {
-		offset_agbno = agbno & mp->m_inoalign_mask;
+	if (mp->m_ino_geo.ig_inoalign_mask) {
+		offset_agbno = agbno & mp->m_ino_geo.ig_inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
 		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
@@ -2381,13 +2386,13 @@ xfs_imap(
 out_map:
 	ASSERT(agbno >= chunk_agbno);
 	cluster_agbno = chunk_agbno +
-		((offset_agbno / mp->m_blocks_per_cluster) *
-		 mp->m_blocks_per_cluster);
+		((offset_agbno / mp->m_ino_geo.ig_blocks_per_cluster) *
+		 mp->m_ino_geo.ig_blocks_per_cluster);
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
 
 	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
-	imap->im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
+	imap->im_len = XFS_FSB_TO_BB(mp, mp->m_ino_geo.ig_blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
 	/*
@@ -2409,7 +2414,7 @@ xfs_imap(
 }
 
 /*
- * Compute and fill in value of m_in_maxlevels.
+ * Compute and fill in value of m_ino_geo.ig_in_maxlevels.
  */
 void
 xfs_ialloc_compute_maxlevels(
@@ -2418,8 +2423,8 @@ xfs_ialloc_compute_maxlevels(
 	uint		inodes;
 
 	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
-	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp->m_inobt_mnr,
-							 inodes);
+	mp->m_ino_geo.ig_in_maxlevels = xfs_btree_compute_maxlevels(
+			mp->m_ino_geo.ig_inobt_mnr, inodes);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index e936b7cc9389..b74fa2addd51 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -28,9 +28,9 @@ static inline int
 xfs_icluster_size_fsb(
 	struct xfs_mount	*mp)
 {
-	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size)
+	if (mp->m_sb.sb_blocksize >= mp->m_ino_geo.ig_min_cluster_size)
 		return 1;
-	return mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
+	return mp->m_ino_geo.ig_min_cluster_size >> mp->m_sb.sb_blocklog;
 }
 
 /*
@@ -96,7 +96,7 @@ xfs_imap(
 	uint		flags);		/* flags for inode btree lookup */
 
 /*
- * Compute and fill in value of m_in_maxlevels.
+ * Compute and fill in value of m_ino_geo.ig_in_maxlevels.
  */
 void
 xfs_ialloc_compute_maxlevels(
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index bc2dfacd2f4a..79cc5cf21e1b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -28,7 +28,7 @@ xfs_inobt_get_minrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	return cur->bc_mp->m_inobt_mnr[level != 0];
+	return cur->bc_mp->m_ino_geo.ig_inobt_mnr[level != 0];
 }
 
 STATIC struct xfs_btree_cur *
@@ -164,7 +164,7 @@ xfs_inobt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	return cur->bc_mp->m_inobt_mxr[level != 0];
+	return cur->bc_mp->m_ino_geo.ig_inobt_mxr[level != 0];
 }
 
 STATIC void
@@ -281,10 +281,11 @@ xfs_inobt_verify(
 
 	/* level verification */
 	level = be16_to_cpu(block->bb_level);
-	if (level >= mp->m_in_maxlevels)
+	if (level >= mp->m_ino_geo.ig_in_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
+	return xfs_btree_sblock_verify(bp,
+			mp->m_ino_geo.ig_inobt_mxr[level != 0]);
 }
 
 static void
@@ -546,7 +547,7 @@ xfs_inobt_max_size(
 	xfs_agblock_t		agblocks = xfs_ag_block_count(mp, agno);
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
-	if (mp->m_inobt_mxr[0] == 0)
+	if (mp->m_ino_geo.ig_inobt_mxr[0] == 0)
 		return 0;
 
 	/*
@@ -558,7 +559,7 @@ xfs_inobt_max_size(
 	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
-	return xfs_btree_calc_size(mp->m_inobt_mnr,
+	return xfs_btree_calc_size(mp->m_ino_geo.ig_inobt_mnr,
 				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
 					XFS_INODES_PER_CHUNK);
 }
@@ -619,5 +620,5 @@ xfs_iallocbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
 {
-	return xfs_btree_calc_size(mp->m_inobt_mnr, len);
+	return xfs_btree_calc_size(mp->m_ino_geo.ig_inobt_mnr, len);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e021d5133ccb..641aa1c2f1ae 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -36,7 +36,7 @@ xfs_inobp_check(
 	int		j;
 	xfs_dinode_t	*dip;
 
-	j = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
+	j = mp->m_ino_geo.ig_min_cluster_size >> mp->m_sb.sb_inodelog;
 
 	for (i = 0; i < j; i++) {
 		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e76a3e5d28d7..9416fc741788 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -804,16 +804,18 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
  */
 void
 xfs_sb_mount_common(
-	struct xfs_mount *mp,
-	struct xfs_sb	*sbp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
 {
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
+
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
-	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
+	mp->m_ino_geo.ig_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
@@ -823,10 +825,10 @@ xfs_sb_mount_common(
 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
 	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
 
-	mp->m_inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
-	mp->m_inobt_mnr[0] = mp->m_inobt_mxr[0] / 2;
-	mp->m_inobt_mnr[1] = mp->m_inobt_mxr[1] / 2;
+	igeo->ig_inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
+	igeo->ig_inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->ig_inobt_mnr[0] = igeo->ig_inobt_mxr[0] / 2;
+	igeo->ig_inobt_mnr[1] = igeo->ig_inobt_mxr[1] / 2;
 
 	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
@@ -844,14 +846,14 @@ xfs_sb_mount_common(
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
-	mp->m_ialloc_inos = max_t(uint16_t, XFS_INODES_PER_CHUNK,
+	igeo->ig_ialloc_inos = max_t(uint16_t, XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
-	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
+	igeo->ig_ialloc_blks = igeo->ig_ialloc_inos >> sbp->sb_inopblog;
 
 	if (sbp->sb_spino_align)
-		mp->m_ialloc_min_blks = sbp->sb_spino_align;
+		igeo->ig_ialloc_min_blks = sbp->sb_spino_align;
 	else
-		mp->m_ialloc_min_blks = mp->m_ialloc_blks;
+		igeo->ig_ialloc_min_blks = igeo->ig_ialloc_blks;
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 83f4ee2afc49..0d0d24729606 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -136,9 +136,10 @@ STATIC uint
 xfs_calc_inobt_res(
 	struct xfs_mount	*mp)
 {
-	return xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+	return xfs_calc_buf_res(mp->m_ino_geo.ig_in_maxlevels,
+			XFS_FSB_TO_B(mp, 1)) +
+				xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+			XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -167,7 +168,7 @@ xfs_calc_finobt_res(
  * includes:
  *
  * the allocation btrees: 2 trees * (max depth - 1) * block size
- * the inode chunk: m_ialloc_blks * N
+ * the inode chunk: m_ino_geo.ig_ialloc_blks * N
  *
  * The size N of the inode chunk reservation depends on whether it is for
  * allocation or free and which type of create transaction is in use. An inode
@@ -193,7 +194,7 @@ xfs_calc_inode_chunk_res(
 		size = XFS_FSB_TO_B(mp, 1);
 	}
 
-	res += xfs_calc_buf_res(mp->m_ialloc_blks, size);
+	res += xfs_calc_buf_res(mp->m_ino_geo.ig_ialloc_blks, size);
 	return res;
 }
 
@@ -307,7 +308,8 @@ xfs_calc_iunlink_remove_reservation(
 	struct xfs_mount        *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-	       2 * max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size);
+	       2 * max_t(uint, XFS_FSB_TO_B(mp, 1),
+			 mp->m_ino_geo.ig_min_cluster_size);
 }
 
 /*
@@ -345,7 +347,8 @@ STATIC uint
 xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size);
+			max_t(uint, XFS_FSB_TO_B(mp, 1),
+			      mp->m_ino_geo.ig_min_cluster_size);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index a62fb950bef1..65ecc600ef44 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -56,9 +56,9 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	((mp)->m_ialloc_blks + \
+	((mp)->m_ino_geo.ig_ialloc_blks + \
 	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
-	  ((mp)->m_in_maxlevels - 1)))
+	  ((mp)->m_ino_geo.ig_in_maxlevels - 1)))
 
 /*
  * Space reservation values for various transactions.
@@ -94,7 +94,8 @@
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
-	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
+	(xfs_sb_version_hasfinobt(&mp->m_sb) ? \
+			(mp)->m_ino_geo.ig_in_maxlevels : 0)
 
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index d51acc95bc00..cfa3f407eacd 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -87,14 +87,14 @@ xfs_agino_range(
 	 * Calculate the first inode, which will be in the first
 	 * cluster-aligned block after the AGFL.
 	 */
-	bno = round_up(XFS_AGFL_BLOCK(mp) + 1, mp->m_cluster_align);
+	bno = round_up(XFS_AGFL_BLOCK(mp) + 1, mp->m_ino_geo.ig_cluster_align);
 	*first = XFS_AGB_TO_AGINO(mp, bno);
 
 	/*
 	 * Calculate the last inode, which will be at the end of the
 	 * last (aligned) cluster that can be allocated in the AG.
 	 */
-	bno = round_down(eoag, mp->m_cluster_align);
+	bno = round_down(eoag, mp->m_ino_geo.ig_cluster_align);
 	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
 }
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 9b47117180cb..fa7386bf76e9 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -230,7 +230,7 @@ xchk_iallocbt_check_cluster(
 	int				error = 0;
 
 	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
-			mp->m_inodes_per_cluster);
+			mp->m_ino_geo.ig_inodes_per_cluster);
 
 	/* Map this inode cluster */
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino + cluster_base);
@@ -251,7 +251,7 @@ xchk_iallocbt_check_cluster(
 	 */
 	ir_holemask = (irec->ir_holemask & cluster_mask);
 	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
+	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_ino_geo.ig_blocks_per_cluster);
 	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
 			mp->m_sb.sb_inodelog;
 
@@ -276,12 +276,13 @@ xchk_iallocbt_check_cluster(
 	/* If any part of this is a hole, skip it. */
 	if (ir_holemask) {
 		xchk_xref_is_not_owned_by(bs->sc, agbno,
-				mp->m_blocks_per_cluster,
+				mp->m_ino_geo.ig_blocks_per_cluster,
 				&XFS_RMAP_OINFO_INODES);
 		return 0;
 	}
 
-	xchk_xref_is_owned_by(bs->sc, agbno, mp->m_blocks_per_cluster,
+	xchk_xref_is_owned_by(bs->sc, agbno,
+			mp->m_ino_geo.ig_blocks_per_cluster,
 			&XFS_RMAP_OINFO_INODES);
 
 	/* Grab the inode cluster buffer. */
@@ -333,7 +334,7 @@ xchk_iallocbt_check_clusters(
 	 */
 	for (cluster_base = 0;
 	     cluster_base < XFS_INODES_PER_CHUNK;
-	     cluster_base += bs->sc->mp->m_inodes_per_cluster) {
+	     cluster_base += bs->sc->mp->m_ino_geo.ig_inodes_per_cluster) {
 		error = xchk_iallocbt_check_cluster(bs, irec, cluster_base);
 		if (error)
 			break;
@@ -355,6 +356,7 @@ xchk_iallocbt_rec_alignment(
 {
 	struct xfs_mount		*mp = bs->sc->mp;
 	struct xchk_iallocbt		*iabt = bs->private;
+	struct xfs_ino_geometry		*ig = &mp->m_ino_geo;
 
 	/*
 	 * finobt records have different positioning requirements than inobt
@@ -372,7 +374,7 @@ xchk_iallocbt_rec_alignment(
 		unsigned int	imask;
 
 		imask = min_t(unsigned int, XFS_INODES_PER_CHUNK,
-				mp->m_cluster_align_inodes) - 1;
+				ig->ig_cluster_align_inodes) - 1;
 		if (irec->ir_startino & imask)
 			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
@@ -400,17 +402,17 @@ xchk_iallocbt_rec_alignment(
 	}
 
 	/* inobt records must be aligned to cluster and inoalignmnt size. */
-	if (irec->ir_startino & (mp->m_cluster_align_inodes - 1)) {
+	if (irec->ir_startino & (ig->ig_cluster_align_inodes - 1)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
 	}
 
-	if (irec->ir_startino & (mp->m_inodes_per_cluster - 1)) {
+	if (irec->ir_startino & (ig->ig_inodes_per_cluster - 1)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
 	}
 
-	if (mp->m_inodes_per_cluster <= XFS_INODES_PER_CHUNK)
+	if (ig->ig_inodes_per_cluster <= XFS_INODES_PER_CHUNK)
 		return;
 
 	/*
@@ -419,7 +421,7 @@ xchk_iallocbt_rec_alignment(
 	 * after this one.
 	 */
 	iabt->next_startino = irec->ir_startino + XFS_INODES_PER_CHUNK;
-	iabt->next_cluster_ino = irec->ir_startino + mp->m_inodes_per_cluster;
+	iabt->next_cluster_ino = irec->ir_startino + ig->ig_inodes_per_cluster;
 }
 
 /* Scrub an inobt/finobt record. */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5dfe2b5924db..bf4c4630e1df 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -144,7 +144,7 @@ xchk_quota_item(
 	if (bsoft > bhard)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
-	if (ihard > mp->m_maxicount)
+	if (ihard > mp->m_ino_geo.ig_maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 	if (isoft > ihard)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3d0e0570e3aa..564bb64d51d3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -251,9 +251,9 @@ xfs_growfs_data(
 	if (mp->m_sb.sb_imax_pct) {
 		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
 		do_div(icount, 100);
-		mp->m_maxicount = XFS_FSB_TO_INO(mp, icount);
+		mp->m_ino_geo.ig_maxicount = XFS_FSB_TO_INO(mp, icount);
 	} else
-		mp->m_maxicount = 0;
+		mp->m_ino_geo.ig_maxicount = 0;
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71d216cf6f87..28ad467607cf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2537,13 +2537,14 @@ xfs_ifree_cluster(
 	xfs_inode_log_item_t	*iip;
 	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
 	xfs_ino_t		inum;
 
 	inum = xic->first_ino;
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
-	nbufs = mp->m_ialloc_blks / mp->m_blocks_per_cluster;
+	nbufs = igeo->ig_ialloc_blks / igeo->ig_blocks_per_cluster;
 
-	for (j = 0; j < nbufs; j++, inum += mp->m_inodes_per_cluster) {
+	for (j = 0; j < nbufs; j++, inum += igeo->ig_inodes_per_cluster) {
 		/*
 		 * The allocation bitmap tells us which inodes of the chunk were
 		 * physically allocated. Skip the cluster if an inode falls into
@@ -2551,7 +2552,7 @@ xfs_ifree_cluster(
 		 */
 		ioffset = inum - xic->first_ino;
 		if ((xic->alloc & XFS_INOBT_MASK(ioffset)) == 0) {
-			ASSERT(ioffset % mp->m_inodes_per_cluster == 0);
+			ASSERT(ioffset % igeo->ig_inodes_per_cluster == 0);
 			continue;
 		}
 
@@ -2567,7 +2568,8 @@ xfs_ifree_cluster(
 		 * to mark all the active inodes on the buffer stale.
 		 */
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-					mp->m_bsize * mp->m_blocks_per_cluster,
+					mp->m_bsize *
+						igeo->ig_blocks_per_cluster,
 					XBF_UNMAPPED);
 
 		if (!bp)
@@ -2614,7 +2616,7 @@ xfs_ifree_cluster(
 		 * transaction stale above, which means there is no point in
 		 * even trying to lock them.
 		 */
-		for (i = 0; i < mp->m_inodes_per_cluster; i++) {
+		for (i = 0; i < igeo->ig_inodes_per_cluster; i++) {
 retry:
 			rcu_read_lock();
 			ip = radix_tree_lookup(&pag->pag_ici_root,
@@ -3476,19 +3478,20 @@ xfs_iflush_cluster(
 	int			cilist_size;
 	struct xfs_inode	**cilist;
 	struct xfs_inode	*cip;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
 	int			nr_found;
 	int			clcount = 0;
 	int			i;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	inodes_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
+	inodes_per_cluster = igeo->ig_min_cluster_size >> mp->m_sb.sb_inodelog;
 	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!cilist)
 		goto out_put;
 
-	mask = ~(((mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
+	mask = ~(((igeo->ig_min_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	rcu_read_lock();
 	/* really need a gang lookup range call here */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1e1a0af1dd34..cff28ee73deb 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -167,6 +167,7 @@ xfs_bulkstat_ichunk_ra(
 	xfs_agnumber_t			agno,
 	struct xfs_inobt_rec_incore	*irec)
 {
+	struct xfs_ino_geometry		*igeo = &mp->m_ino_geo;
 	xfs_agblock_t			agbno;
 	struct blk_plug			plug;
 	int				i;	/* inode chunk index */
@@ -174,12 +175,14 @@ xfs_bulkstat_ichunk_ra(
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
 
 	blk_start_plug(&plug);
-	for (i = 0; i < XFS_INODES_PER_CHUNK;
-	     i += mp->m_inodes_per_cluster, agbno += mp->m_blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, mp->m_inodes_per_cluster) &
+	for (i = 0;
+	     i < XFS_INODES_PER_CHUNK;
+	     i += igeo->ig_inodes_per_cluster,
+			agbno += igeo->ig_blocks_per_cluster) {
+		if (xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster) &
 		    ~irec->ir_free) {
 			xfs_btree_reada_bufs(mp, agno, agbno,
-					mp->m_blocks_per_cluster,
+					igeo->ig_blocks_per_cluster,
 					&xfs_inode_buf_ops);
 		}
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9329f5adbfbe..15118e531184 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2882,19 +2882,19 @@ xlog_recover_buffer_pass2(
 	 *
 	 * Also make sure that only inode buffers with good sizes stay in
 	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
-	 * or mp->m_inode_cluster_size bytes, whichever is bigger.  The inode
+	 * or ig_min_cluster_size bytes, whichever is bigger.  The inode
 	 * buffers in the log can be a different size if the log was generated
 	 * by an older kernel using unclustered inode buffers or a newer kernel
 	 * running with a different inode cluster size.  Regardless, if the
-	 * the inode buffer size isn't max(blocksize, mp->m_inode_cluster_size)
-	 * for *our* value of mp->m_inode_cluster_size, then we need to keep
+	 * the inode buffer size isn't max(blocksize, ig_min_cluster_size)
+	 * for *our* value of ig_min_cluster_size, then we need to keep
 	 * the buffer out of the buffer cache so that the buffer won't
 	 * overlap with future reads of those inodes.
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
 	    (BBTOB(bp->b_io_length) != max(log->l_mp->m_sb.sb_blocksize,
-			(uint32_t)log->l_mp->m_inode_cluster_size))) {
+			(uint32_t)log->l_mp->m_ino_geo.ig_min_cluster_size))) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
 	} else {
@@ -3849,6 +3849,7 @@ xlog_recover_do_icreate_pass2(
 {
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_icreate_log	*icl;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	unsigned int		count;
@@ -3898,10 +3899,10 @@ xlog_recover_do_icreate_pass2(
 
 	/*
 	 * The inode chunk is either full or sparse and we only support
-	 * m_ialloc_min_blks sized sparse allocations at this time.
+	 * m_ino_geo.ig_ialloc_min_blks sized sparse allocations at this time.
 	 */
-	if (length != mp->m_ialloc_blks &&
-	    length != mp->m_ialloc_min_blks) {
+	if (length != igeo->ig_ialloc_blks &&
+	    length != igeo->ig_ialloc_min_blks) {
 		xfs_warn(log->l_mp,
 			 "%s: unsupported chunk length", __FUNCTION__);
 		return -EINVAL;
@@ -3921,13 +3922,13 @@ xlog_recover_do_icreate_pass2(
 	 * buffers for cancellation so we don't overwrite anything written after
 	 * a cancellation.
 	 */
-	bb_per_cluster = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
-	nbufs = length / mp->m_blocks_per_cluster;
+	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->ig_blocks_per_cluster);
+	nbufs = length / igeo->ig_blocks_per_cluster;
 	for (i = 0, cancel_count = 0; i < nbufs; i++) {
 		xfs_daddr_t	daddr;
 
-		daddr = XFS_AGB_TO_DADDR(mp, agno,
-					 agbno + i * mp->m_blocks_per_cluster);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno +
+				i * igeo->ig_blocks_per_cluster);
 		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
 			cancel_count++;
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6b2bfe81dc51..17c47682609b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -433,10 +433,12 @@ xfs_update_alignment(xfs_mount_t *mp)
  * Set the maximum inode count for this filesystem
  */
 STATIC void
-xfs_set_maxicount(xfs_mount_t *mp)
+xfs_set_maxicount(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
-	uint64_t	icount;
+	struct xfs_sb		*sbp = &(mp->m_sb);
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
+	uint64_t		icount;
 
 	if (sbp->sb_imax_pct) {
 		/*
@@ -445,11 +447,11 @@ xfs_set_maxicount(xfs_mount_t *mp)
 		 */
 		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
 		do_div(icount, 100);
-		do_div(icount, mp->m_ialloc_blks);
-		mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
-				   sbp->sb_inopblog;
+		do_div(icount, igeo->ig_ialloc_blks);
+		igeo->ig_maxicount = XFS_FSB_TO_INO(mp,
+				icount * igeo->ig_ialloc_blks);
 	} else {
-		mp->m_maxicount = 0;
+		igeo->ig_maxicount = 0;
 	}
 }
 
@@ -518,18 +520,18 @@ xfs_set_inoalignment(xfs_mount_t *mp)
 {
 	if (xfs_sb_version_hasalign(&mp->m_sb) &&
 		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
-		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
+		mp->m_ino_geo.ig_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
 	else
-		mp->m_inoalign_mask = 0;
+		mp->m_ino_geo.ig_inoalign_mask = 0;
 	/*
 	 * If we are using stripe alignment, check whether
 	 * the stripe unit is a multiple of the inode alignment
 	 */
-	if (mp->m_dalign && mp->m_inoalign_mask &&
-	    !(mp->m_dalign & mp->m_inoalign_mask))
-		mp->m_sinoalign = mp->m_dalign;
+	if (mp->m_dalign && mp->m_ino_geo.ig_inoalign_mask &&
+	    !(mp->m_dalign & mp->m_ino_geo.ig_inoalign_mask))
+		mp->m_ino_geo.ig_sinoalign = mp->m_dalign;
 	else
-		mp->m_sinoalign = 0;
+		mp->m_ino_geo.ig_sinoalign = 0;
 }
 
 /*
@@ -683,6 +685,7 @@ xfs_mountfs(
 {
 	struct xfs_sb		*sbp = &(mp->m_sb);
 	struct xfs_inode	*rip;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
 	uint64_t		resblks;
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
@@ -797,18 +800,20 @@ xfs_mountfs(
 	 * has set the inode alignment value appropriately for larger cluster
 	 * sizes.
 	 */
-	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+	igeo->ig_min_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		int	new_size = mp->m_inode_cluster_size;
+		int	new_size = igeo->ig_min_cluster_size;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
 		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
-			mp->m_inode_cluster_size = new_size;
+			igeo->ig_min_cluster_size = new_size;
 	}
-	mp->m_blocks_per_cluster = xfs_icluster_size_fsb(mp);
-	mp->m_inodes_per_cluster = XFS_FSB_TO_INO(mp, mp->m_blocks_per_cluster);
-	mp->m_cluster_align = xfs_ialloc_cluster_alignment(mp);
-	mp->m_cluster_align_inodes = XFS_FSB_TO_INO(mp, mp->m_cluster_align);
+	igeo->ig_blocks_per_cluster = xfs_icluster_size_fsb(mp);
+	igeo->ig_inodes_per_cluster = XFS_FSB_TO_INO(mp,
+			igeo->ig_blocks_per_cluster);
+	igeo->ig_cluster_align = xfs_ialloc_cluster_alignment(mp);
+	igeo->ig_cluster_align_inodes = XFS_FSB_TO_INO(mp,
+			igeo->ig_cluster_align);
 
 	/*
 	 * If enabled, sparse inode chunk alignment is expected to match the
@@ -817,11 +822,11 @@ xfs_mountfs(
 	 */
 	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
 	    mp->m_sb.sb_spino_align !=
-			XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {
+			XFS_B_TO_FSBT(mp, igeo->ig_min_cluster_size)) {
 		xfs_warn(mp,
 	"Sparse inode block alignment (%u) must match cluster size (%llu).",
 			 mp->m_sb.sb_spino_align,
-			 XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size));
+			 XFS_B_TO_FSBT(mp, igeo->ig_min_cluster_size));
 		error = -EINVAL;
 		goto out_remove_uuid;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c81a5cd7c228..89cbb1268b63 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -105,6 +105,7 @@ typedef struct xfs_mount {
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
 	struct xlog		*m_log;		/* log specific stuff */
+	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	int			m_logbufs;	/* number of log buffers */
 	int			m_logbsize;	/* size of each log buffer */
 	uint			m_rsumlevels;	/* rt summary levels */
@@ -126,12 +127,6 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
-	uint8_t			m_agino_log;	/* #bits for agino in inum */
-	uint			m_inode_cluster_size;/* min inode buf size */
-	unsigned int		m_inodes_per_cluster;
-	unsigned int		m_blocks_per_cluster;
-	unsigned int		m_cluster_align;
-	unsigned int		m_cluster_align_inodes;
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -139,15 +134,12 @@ typedef struct xfs_mount {
 	uint			m_alloc_mnr[2];	/* min alloc btree records */
 	uint			m_bmap_dmxr[2];	/* max bmap btree records */
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
-	uint			m_inobt_mxr[2];	/* max inobt btree records */
-	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
-	uint			m_in_maxlevels;	/* max inobt btree levels. */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
@@ -159,20 +151,13 @@ typedef struct xfs_mount {
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint64_t		m_flags;	/* global mount flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
-	int			m_ialloc_inos;	/* inodes in inode allocation */
-	int			m_ialloc_blks;	/* blocks in inode allocation */
-	int			m_ialloc_min_blks;/* min blocks in sparse inode
-						   * allocation */
-	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	uint			m_qflags;	/* quota status flags */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
-	uint64_t		m_maxicount;	/* maximum inode count */
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
-	int			m_sinoalign;	/* stripe unit inode alignment */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a14d11d78bd8..4b44c55e3022 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -582,7 +582,7 @@ xfs_set_inode_alloc(
 	 * Calculate how much should be reserved for inodes to meet
 	 * the max inode percentage.  Used only for inode32.
 	 */
-	if (mp->m_maxicount) {
+	if (mp->m_ino_geo.ig_maxicount) {
 		uint64_t	icount;
 
 		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
@@ -1131,10 +1131,10 @@ xfs_fs_statfs(
 
 	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
 	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
-	if (mp->m_maxicount)
+	if (mp->m_ino_geo.ig_maxicount)
 		statp->f_files = min_t(typeof(statp->f_files),
 					statp->f_files,
-					mp->m_maxicount);
+					mp->m_ino_geo.ig_maxicount);
 
 	/* If sb_icount overshot maxicount, report actual allocation */
 	statp->f_files = max_t(typeof(statp->f_files),
