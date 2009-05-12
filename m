Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIvIp098760 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BFD2F9E141
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H7jU2Cu94HJTFEnH for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:23:39 -0700 (PDT)
Message-Id: <20090512211902.288290000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: factor out inode initialisation
References: <20090512211607.197071000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-icreate-factor-inode-stamping
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <david@fromorbit.com>

Factor out code to initialize new inode clusters into a function of it's own.
This keeps xfs_ialloc_ag_alloc smaller and better structured and enables a
future inode cluster initialization transaction.  Also initialize the agno
variable earlier in xfs_ialloc_ag_alloc to avoid repeated byte swaps.

[hch:  The original patch is from Dave from his unpublished inode create
 transaction patch series, with some modifcation by to apply stand-alone]


Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-05-12 17:11:12.107658861 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2009-05-12 17:14:55.411784530 +0200
@@ -153,6 +153,87 @@ xfs_inobt_get_rec(
 }
 
 /*
+ * Initialise a new set of inodes.
+ */
+STATIC void
+xfs_ialloc_inode_init(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		length,
+	unsigned int		gen)
+{
+	struct xfs_buf		*fbuf;
+	struct xfs_dinode	*free;
+	int			blks_per_cluster, nbufs, ninodes;
+	int			version;
+	int			i, j;
+	xfs_daddr_t		d;
+
+	/*
+	 * Loop over the new block(s), filling in the inodes.
+	 * For small block sizes, manipulate the inodes in buffers
+	 * which are multiples of the blocks size.
+	 */
+	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
+		blks_per_cluster = 1;
+		nbufs = length;
+		ninodes = mp->m_sb.sb_inopblock;
+	} else {
+		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
+				   mp->m_sb.sb_blocksize;
+		nbufs = length / blks_per_cluster;
+		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
+	}
+
+	/*
+	 * Figure out what version number to use in the inodes we create.
+	 * If the superblock version has caught up to the one that supports
+	 * the new inode format, then use the new inode version.  Otherwise
+	 * use the old version so that old kernels will continue to be
+	 * able to use the file system.
+	 */
+	if (xfs_sb_version_hasnlink(&mp->m_sb))
+		version = 2;
+	else
+		version = 1;
+
+	for (j = 0; j < nbufs; j++) {
+		/*
+		 * Get the block.
+		 */
+		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
+		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					 mp->m_bsize * blks_per_cluster,
+					 XFS_BUF_LOCK);
+		ASSERT(fbuf);
+		ASSERT(!XFS_BUF_GETERROR(fbuf));
+
+		/*
+		 * Initialize all inodes in this buffer and then log them.
+		 *
+		 * XXX: It would be much better if we had just one transaction
+		 *	to log a whole cluster of inodes instead of all the
+		 *	individual transactions causing a lot of log traffic.
+		 */
+		xfs_biozero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
+		for (i = 0; i < ninodes; i++) {
+			int	ioffset = i << mp->m_sb.sb_inodelog;
+			uint	isize = sizeof(struct xfs_dinode);
+
+			free = xfs_make_iptr(mp, fbuf, i);
+			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			free->di_version = version;
+			free->di_gen = cpu_to_be32(gen);
+			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
+		}
+		xfs_trans_inode_alloc_buf(tp, fbuf);
+	}
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
@@ -164,24 +245,15 @@ xfs_ialloc_ag_alloc(
 {
 	xfs_agi_t	*agi;		/* allocation group header */
 	xfs_alloc_arg_t	args;		/* allocation argument structure */
-	int		blks_per_cluster;  /* fs blocks per inode cluster */
 	xfs_btree_cur_t	*cur;		/* inode btree cursor */
-	xfs_daddr_t	d;		/* disk addr of buffer */
 	xfs_agnumber_t	agno;
 	int		error;
-	xfs_buf_t	*fbuf;		/* new free inodes' buffer */
-	xfs_dinode_t	*free;		/* new free inode structure */
-	int		i;		/* inode counter */
-	int		j;		/* block counter */
-	int		nbufs;		/* num bufs of new inodes */
+	int		i;
 	xfs_agino_t	newino;		/* new first inode's number */
 	xfs_agino_t	newlen;		/* new number of inodes */
-	int		ninodes;	/* num inodes per buf */
 	xfs_agino_t	thisino;	/* current inode number, for loop */
-	int		version;	/* inode version number to use */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
-	unsigned int	gen;
 
 	args.tp = tp;
 	args.mp = tp->t_mountp;
@@ -202,12 +274,12 @@ xfs_ialloc_ag_alloc(
  	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
+	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 			XFS_IALLOC_BLOCKS(args.mp);
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.mod = args.total = args.wasdel = args.isfl =
 			args.userdata = args.minalignslop = 0;
@@ -258,8 +330,7 @@ xfs_ialloc_ag_alloc(
 		 * For now, just allocate blocks up front.
 		 */
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
@@ -282,8 +353,7 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.alignment = xfs_ialloc_cluster_alignment(&args);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
@@ -294,85 +364,30 @@ xfs_ialloc_ag_alloc(
 		return 0;
 	}
 	ASSERT(args.len == args.minlen);
-	/*
-	 * Convert the results.
-	 */
-	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
-	/*
-	 * Loop over the new block(s), filling in the inodes.
-	 * For small block sizes, manipulate the inodes in buffers
-	 * which are multiples of the blocks size.
-	 */
-	if (args.mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args.mp)) {
-		blks_per_cluster = 1;
-		nbufs = (int)args.len;
-		ninodes = args.mp->m_sb.sb_inopblock;
-	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args.mp) /
-				   args.mp->m_sb.sb_blocksize;
-		nbufs = (int)args.len / blks_per_cluster;
-		ninodes = blks_per_cluster * args.mp->m_sb.sb_inopblock;
-	}
-	/*
-	 * Figure out what version number to use in the inodes we create.
-	 * If the superblock version has caught up to the one that supports
-	 * the new inode format, then use the new inode version.  Otherwise
-	 * use the old version so that old kernels will continue to be
-	 * able to use the file system.
-	 */
-	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
-		version = 2;
-	else
-		version = 1;
 
 	/*
+	 * Stamp and write the inode buffers.
+	 *
 	 * Seed the new inode cluster with a random generation number. This
 	 * prevents short-term reuse of generation numbers if a chunk is
 	 * freed and then immediately reallocated. We use random numbers
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	gen = random32();
-	for (j = 0; j < nbufs; j++) {
-		/*
-		 * Get the block.
-		 */
-		d = XFS_AGB_TO_DADDR(args.mp, be32_to_cpu(agi->agi_seqno),
-				     args.agbno + (j * blks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, args.mp->m_ddev_targp, d,
-					 args.mp->m_bsize * blks_per_cluster,
-					 XFS_BUF_LOCK);
-		ASSERT(fbuf);
-		ASSERT(!XFS_BUF_GETERROR(fbuf));
+	xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno, args.len,
+			      random32());
 
-		/*
-		 * Initialize all inodes in this buffer and then log them.
-		 *
-		 * XXX: It would be much better if we had just one transaction to
-		 *      log a whole cluster of inodes instead of all the individual
-		 *      transactions causing a lot of log traffic.
-		 */
-		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
-		for (i = 0; i < ninodes; i++) {
-			int	ioffset = i << args.mp->m_sb.sb_inodelog;
-			uint	isize = sizeof(struct xfs_dinode);
-
-			free = xfs_make_iptr(args.mp, fbuf, i);
-			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
-			free->di_version = version;
-			free->di_gen = cpu_to_be32(gen);
-			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
-		}
-		xfs_trans_inode_alloc_buf(tp, fbuf);
-	}
+	/*
+	 * Convert the results.
+	 */
+	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	agno = be32_to_cpu(agi->agi_seqno);
 	down_read(&args.mp->m_peraglock);
 	args.mp->m_perag[agno].pagi_freecount += newlen;
 	up_read(&args.mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
+
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
