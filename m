Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLkt153464 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F6AF1793DB1
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vd9w2EpdMoFR5dCe for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xF-0002un-Gt
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:17 +0000
Message-Id: <20110710205017.485558926@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/11] xfs: factor out xfs_da_grow_inode_int
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-da_grow_inode
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

xfs_da_grow_inode and xfs_dir2_grow_inode are mostly duplicate code.  Factor
the meat of those two functions into a new common helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-07-09 12:20:44.175127246 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-07-09 12:20:45.601793841 +0200
@@ -1543,79 +1543,62 @@ const struct xfs_nameops xfs_default_nam
 	.compname	= xfs_da_compname
 };
 
-/*
- * Add a block to the btree ahead of the file.
- * Return the new block number to the caller.
- */
 int
-xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
+xfs_da_grow_inode_int(
+	struct xfs_da_args	*args,
+	xfs_fileoff_t		*bno,
+	int			count)
 {
-	xfs_fileoff_t bno, b;
-	xfs_bmbt_irec_t map;
-	xfs_bmbt_irec_t	*mapp;
-	xfs_inode_t *dp;
-	int nmap, error, w, count, c, got, i, mapi;
-	xfs_trans_t *tp;
-	xfs_mount_t *mp;
-	xfs_drfsbno_t	nblks;
-
-	dp = args->dp;
-	mp = dp->i_mount;
-	w = args->whichfork;
-	tp = args->trans;
-	nblks = dp->i_d.di_nblocks;
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_inode	*dp = args->dp;
+	int			w = args->whichfork;
+	xfs_drfsbno_t		nblks = dp->i_d.di_nblocks;
+	struct xfs_bmbt_irec	map, *mapp;
+	int			nmap, error, got, i, mapi;
 
 	/*
-	 * For new directories adjust the file offset and block count.
-	 */
-	if (w == XFS_DATA_FORK) {
-		bno = mp->m_dirleafblk;
-		count = mp->m_dirblkfsbs;
-	} else {
-		bno = 0;
-		count = 1;
-	}
-	/*
 	 * Find a spot in the file space to put the new block.
 	 */
-	if ((error = xfs_bmap_first_unused(tp, dp, count, &bno, w)))
+	error = xfs_bmap_first_unused(tp, dp, count, bno, w);
+	if (error)
 		return error;
-	if (w == XFS_DATA_FORK)
-		ASSERT(bno >= mp->m_dirleafblk && bno < mp->m_dirfreeblk);
+
 	/*
 	 * Try mapping it in one filesystem block.
 	 */
 	nmap = 1;
 	ASSERT(args->firstblock != NULL);
-	if ((error = xfs_bmapi(tp, dp, bno, count,
+	error = xfs_bmapi(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
 			XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist))) {
+			args->flist);
+	if (error)
 		return error;
-	}
+
 	ASSERT(nmap <= 1);
 	if (nmap == 1) {
 		mapp = &map;
 		mapi = 1;
-	}
-	/*
-	 * If we didn't get it and the block might work if fragmented,
-	 * try without the CONTIG flag.  Loop until we get it all.
-	 */
-	else if (nmap == 0 && count > 1) {
+	} else if (nmap == 0 && count > 1) {
+		xfs_fileoff_t		b;
+		int			c;
+
+		/*
+		 * If we didn't get it and the block might work if fragmented,
+		 * try without the CONTIG flag.  Loop until we get it all.
+		 */
 		mapp = kmem_alloc(sizeof(*mapp) * count, KM_SLEEP);
-		for (b = bno, mapi = 0; b < bno + count; ) {
+		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
-			c = (int)(bno + count - b);
-			if ((error = xfs_bmapi(tp, dp, b, c,
+			c = (int)(*bno + count - b);
+			error = xfs_bmapi(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
 					XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist))) {
-				kmem_free(mapp);
-				return error;
-			}
+					&mapp[mapi], &nmap, args->flist);
+			if (error)
+				goto out_free_map;
 			if (nmap < 1)
 				break;
 			mapi += nmap;
@@ -1626,24 +1609,53 @@ xfs_da_grow_inode(xfs_da_args_t *args, x
 		mapi = 0;
 		mapp = NULL;
 	}
+
 	/*
 	 * Count the blocks we got, make sure it matches the total.
 	 */
 	for (i = 0, got = 0; i < mapi; i++)
 		got += mapp[i].br_blockcount;
-	if (got != count || mapp[0].br_startoff != bno ||
+	if (got != count || mapp[0].br_startoff != *bno ||
 	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
-	    bno + count) {
-		if (mapp != &map)
-			kmem_free(mapp);
-		return XFS_ERROR(ENOSPC);
+	    *bno + count) {
+		error = XFS_ERROR(ENOSPC);
+		goto out_free_map;
 	}
-	if (mapp != &map)
-		kmem_free(mapp);
+
 	/* account for newly allocated blocks in reserved blocks total */
 	args->total -= dp->i_d.di_nblocks - nblks;
-	*new_blkno = (xfs_dablk_t)bno;
-	return 0;
+
+out_free_map:
+	if (mapp != &map)
+		kmem_free(mapp);
+	return error;
+}
+
+/*
+ * Add a block to the btree ahead of the file.
+ * Return the new block number to the caller.
+ */
+int
+xfs_da_grow_inode(
+	struct xfs_da_args	*args,
+	xfs_dablk_t		*new_blkno)
+{
+	xfs_fileoff_t		bno;
+	int			count;
+	int			error;
+
+	if (args->whichfork == XFS_DATA_FORK) {
+		bno = args->dp->i_mount->m_dirleafblk;
+		count = args->dp->i_mount->m_dirblkfsbs;
+	} else {
+		bno = 0;
+		count = 1;
+	}
+
+	error = xfs_da_grow_inode_int(args, &bno, count);
+	if (!error)
+		*new_blkno = (xfs_dablk_t)bno;
+	return error;
 }
 
 /*
Index: xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.h	2011-07-09 12:20:26.615128136 +0200
+++ xfs/fs/xfs/xfs_da_btree.h	2011-07-09 12:20:45.605127174 +0200
@@ -248,6 +248,8 @@ int	xfs_da_blk_link(xfs_da_state_t *stat
  * Utility routines.
  */
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
+int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
+			      int count);
 int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			      xfs_dabuf_t **bp, int whichfork);
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2011-07-09 12:20:44.175127246 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2011-07-09 12:20:45.608460507 +0200
@@ -497,129 +497,34 @@ xfs_dir_canenter(
 
 /*
  * Add a block to the directory.
- * This routine is for data and free blocks, not leaf/node blocks
- * which are handled by xfs_da_grow_inode.
+ *
+ * This routine is for data and free blocks, not leaf/node blocks which are
+ * handled by xfs_da_grow_inode.
  */
 int
 xfs_dir2_grow_inode(
-	xfs_da_args_t	*args,
-	int		space,		/* v2 dir's space XFS_DIR2_xxx_SPACE */
-	xfs_dir2_db_t	*dbp)		/* out: block number added */
+	struct xfs_da_args	*args,
+	int			space,	/* v2 dir's space XFS_DIR2_xxx_SPACE */
+	xfs_dir2_db_t		*dbp)	/* out: block number added */
 {
-	xfs_fileoff_t	bno;		/* directory offset of new block */
-	int		count;		/* count of filesystem blocks */
-	xfs_inode_t	*dp;		/* incore directory inode */
-	int		error;
-	int		got;		/* blocks actually mapped */
-	int		i;
-	xfs_bmbt_irec_t	map;		/* single structure for bmap */
-	int		mapi;		/* mapping index */
-	xfs_bmbt_irec_t	*mapp;		/* bmap mapping structure(s) */
-	xfs_mount_t	*mp;
-	int		nmap;		/* number of bmap entries */
-	xfs_trans_t	*tp;
-	xfs_drfsbno_t	nblks;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	xfs_fileoff_t		bno;	/* directory offset of new block */
+	int			count;	/* count of filesystem blocks */
+	int			error;
 
 	trace_xfs_dir2_grow_inode(args, space);
 
-	dp = args->dp;
-	tp = args->trans;
-	mp = dp->i_mount;
-	nblks = dp->i_d.di_nblocks;
 	/*
 	 * Set lowest possible block in the space requested.
 	 */
 	bno = XFS_B_TO_FSBT(mp, space * XFS_DIR2_SPACE_SIZE);
 	count = mp->m_dirblkfsbs;
-	/*
-	 * Find the first hole for our block.
-	 */
-	if ((error = xfs_bmap_first_unused(tp, dp, count, &bno, XFS_DATA_FORK)))
-		return error;
-	nmap = 1;
-	ASSERT(args->firstblock != NULL);
-	/*
-	 * Try mapping the new block contiguously (one extent).
-	 */
-	if ((error = xfs_bmapi(tp, dp, bno, count,
-			XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
-			args->firstblock, args->total, &map, &nmap,
-			args->flist)))
-		return error;
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	}
-	/*
-	 * Didn't work and this is a multiple-fsb directory block.
-	 * Try again with contiguous flag turned on.
-	 */
-	else if (nmap == 0 && count > 1) {
-		xfs_fileoff_t	b;	/* current file offset */
 
-		/*
-		 * Space for maximum number of mappings.
-		 */
-		mapp = kmem_alloc(sizeof(*mapp) * count, KM_SLEEP);
-		/*
-		 * Iterate until we get to the end of our block.
-		 */
-		for (b = bno, mapi = 0; b < bno + count; ) {
-			int	c;	/* current fsb count */
-
-			/*
-			 * Can't map more than MAX_NMAP at once.
-			 */
-			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
-			c = (int)(bno + count - b);
-			if ((error = xfs_bmapi(tp, dp, b, c,
-					XFS_BMAPI_WRITE|XFS_BMAPI_METADATA,
-					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist))) {
-				kmem_free(mapp);
-				return error;
-			}
-			if (nmap < 1)
-				break;
-			/*
-			 * Add this bunch into our table, go to the next offset.
-			 */
-			mapi += nmap;
-			b = mapp[mapi - 1].br_startoff +
-			    mapp[mapi - 1].br_blockcount;
-		}
-	}
-	/*
-	 * Didn't work.
-	 */
-	else {
-		mapi = 0;
-		mapp = NULL;
-	}
-	/*
-	 * See how many fsb's we got.
-	 */
-	for (i = 0, got = 0; i < mapi; i++)
-		got += mapp[i].br_blockcount;
-	/*
-	 * Didn't get enough fsb's, or the first/last block's are wrong.
-	 */
-	if (got != count || mapp[0].br_startoff != bno ||
-	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
-	    bno + count) {
-		if (mapp != &map)
-			kmem_free(mapp);
-		return XFS_ERROR(ENOSPC);
-	}
-	/*
-	 * Done with the temporary mapping table.
-	 */
-	if (mapp != &map)
-		kmem_free(mapp);
+	error = xfs_da_grow_inode_int(args, &bno, count);
+	if (error)
+		return error;
 
-	/* account for newly allocated blocks in reserved blocks total */
-	args->total -= dp->i_d.di_nblocks - nblks;
 	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
 
 	/*
@@ -631,7 +536,7 @@ xfs_dir2_grow_inode(
 		size = XFS_FSB_TO_B(mp, bno + count);
 		if (size > dp->i_d.di_size) {
 			dp->i_d.di_size = size;
-			xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+			xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 		}
 	}
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
