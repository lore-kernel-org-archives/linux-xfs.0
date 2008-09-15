Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 17:45:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F0jUtB024415
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:45:30 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D36171FE29E
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id zG9mRMEp6r8SDiU5 for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F0kvIF012316
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:46:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F0kvFk012314
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 02:46:57 +0200
Date: Mon, 15 Sep 2008 02:46:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] always use struct xfs_btree_block instead of short / longform structures
Message-ID: <20080915004657.GF12213@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-always-use-xfs-btree-block
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Always use the generic xfs_btree_block type instead of the short / long
structures.  Add XFS_BTREE_SBLOCK_LEN / XFS_BTREE_LBLOCK_LEN defines for
the length of a short / long form block.  The rationale for this is that
we will grow more btree block header variants to support CRCs and other
RAS information, and always accessing them through the same datatype
with unions for the short / long form pointers makes implementing this
much easier.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-09-15 02:12:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-09-15 02:36:13.000000000 +0200
@@ -382,16 +382,16 @@ xfs_alloc_fixup_trees(
 	}
 #ifdef DEBUG
 	{
-		xfs_alloc_block_t	*bnoblock;
-		xfs_alloc_block_t	*cntblock;
+		struct xfs_btree_block		*bnoblock;
+		struct xfs_btree_block		*cntblock;
+
+		if (bno_cur->bc_nlevels == 1 && cnt_cur->bc_nlevels == 1) {
+			bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
+			cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
 
-		if (bno_cur->bc_nlevels == 1 &&
-		    cnt_cur->bc_nlevels == 1) {
-			bnoblock = XFS_BUF_TO_ALLOC_BLOCK(bno_cur->bc_bufs[0]);
-			cntblock = XFS_BUF_TO_ALLOC_BLOCK(cnt_cur->bc_bufs[0]);
 			XFS_WANT_CORRUPTED_RETURN(
-				be16_to_cpu(bnoblock->bb_numrecs) ==
-				be16_to_cpu(cntblock->bb_numrecs));
+				bnoblock->bb_numrecs ==
+				cntblock->bb_numrecs);
 		}
 	}
 #endif
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:36:13.000000000 +0200
@@ -490,7 +490,7 @@ xfs_allocbt_maxrecs(
 	int			blocklen,
 	int			leaf)
 {
-	blocklen -= sizeof(struct xfs_btree_sblock);
+	blocklen -= XFS_ALLOC_BLOCK_LEN(mp);
 
 	if (leaf)
 		return blocklen / sizeof(xfs_alloc_rec_t);
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:36:13.000000000 +0200
@@ -24,7 +24,6 @@
 
 struct xfs_buf;
 struct xfs_btree_cur;
-struct xfs_btree_sblock;
 struct xfs_mount;
 
 /*
@@ -50,10 +49,6 @@ typedef struct xfs_alloc_rec_incore {
 
 /* btree pointer type */
 typedef __be32 xfs_alloc_ptr_t;
-/* btree block header type */
-typedef	struct xfs_btree_sblock xfs_alloc_block_t;
-
-#define	XFS_BUF_TO_ALLOC_BLOCK(bp)	((xfs_alloc_block_t *)XFS_BUF_PTR(bp))
 
 /*
  * Minimum and maximum blocksize and sectorsize.
@@ -77,24 +72,32 @@ typedef	struct xfs_btree_sblock xfs_allo
 #define	XFS_CNT_BLOCK(mp)	((xfs_agblock_t)(XFS_BNO_BLOCK(mp) + 1))
 
 /*
+ * Btree block header size depends on a superblock flag.
+ *
+ * (not quite yet, but soon)
+ */
+#define XFS_ALLOC_BLOCK_LEN(mp)	XFS_BTREE_SBLOCK_LEN
+
+/*
  * Record, key, and pointer address macros for btree blocks.
+ * (note that some of these may appear unused, but they are used in userspace)
  */
 #define XFS_ALLOC_REC_ADDR(mp, block, index) \
 	((xfs_alloc_rec_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_ALLOC_BLOCK_LEN(mp) + \
 		 (((index) - 1) * sizeof(xfs_alloc_rec_t))))
 
 #define XFS_ALLOC_KEY_ADDR(mp, block, index) \
 	((xfs_alloc_key_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_ALLOC_BLOCK_LEN(mp) + \
 		 ((index) - 1) * sizeof(xfs_alloc_key_t)))
 
 #define XFS_ALLOC_PTR_ADDR(mp, block, index, maxrecs) \
 	((xfs_alloc_ptr_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_ALLOC_BLOCK_LEN(mp) + \
 		 (maxrecs) * sizeof(xfs_alloc_key_t) + \
 		 ((index) - 1) * sizeof(xfs_alloc_ptr_t)))
 
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-15 02:36:13.000000000 +0200
@@ -394,7 +394,7 @@ xfs_bmap_count_leaves(
 STATIC void
 xfs_bmap_disk_count_leaves(
 	struct xfs_mount	*mp,
-	xfs_bmbt_block_t	*block,
+	struct xfs_btree_block	*block,
 	int			numrecs,
 	int			*count);
 
@@ -3042,14 +3042,14 @@ xfs_bmap_btree_to_extents(
 	int			whichfork)  /* data or attr fork */
 {
 	/* REFERENCED */
-	xfs_bmbt_block_t	*cblock;/* child btree block */
+	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
 	xfs_buf_t		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	xfs_ifork_t		*ifp;	/* inode fork data */
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
-	xfs_bmbt_block_t	*rblock;/* root btree block */
+	struct xfs_btree_block	*rblock;/* root btree block */
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -3069,8 +3069,8 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp,
 			XFS_BMAP_BTREE_REF)))
 		return error;
-	cblock = XFS_BUF_TO_BMBT_BLOCK(cbp);
-	if ((error = xfs_btree_check_lblock(cur, cblock, 0, cbp)))
+	cblock = XFS_BUF_TO_BLOCK(cbp);
+	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
 	ip->i_d.di_nblocks--;
@@ -3450,11 +3450,11 @@ xfs_bmap_extents_to_btree(
 	int			*logflagsp,	/* inode logging flags */
 	int			whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_block_t	*ablock;	/* allocated (child) bt block */
+	struct xfs_btree_block	*ablock;	/* allocated (child) bt block */
 	xfs_buf_t		*abp;		/* buffer for ablock */
 	xfs_alloc_arg_t		args;		/* allocation arguments */
 	xfs_bmbt_rec_t		*arp;		/* child record pointer */
-	xfs_bmbt_block_t	*block;		/* btree root block */
+	struct xfs_btree_block	*block;		/* btree root block */
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
 	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
 	int			error;		/* error return value */
@@ -3474,6 +3474,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	xfs_iroot_realloc(ip, 1, whichfork);
 	ifp->if_flags |= XFS_IFBROOT;
+
 	/*
 	 * Fill in the root.
 	 */
@@ -3481,8 +3482,9 @@ xfs_bmap_extents_to_btree(
 	block->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	block->bb_level = cpu_to_be16(1);
 	block->bb_numrecs = cpu_to_be16(1);
-	block->bb_leftsib = cpu_to_be64(NULLDFSBNO);
-	block->bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	block->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+	block->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
+
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -3534,11 +3536,11 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	ablock = XFS_BUF_TO_BMBT_BLOCK(abp);
+	ablock = XFS_BUF_TO_BLOCK(abp);
 	ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	ablock->bb_level = 0;
-	ablock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
-	ablock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	ablock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+	ablock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
@@ -3550,7 +3552,8 @@ xfs_bmap_extents_to_btree(
 		}
 	}
 	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));
-	ablock->bb_numrecs = cpu_to_be16(cnt);
+	xfs_btree_set_numrecs(ablock, cnt);
+
 	/*
 	 * Fill in the root key and pointer.
 	 */
@@ -4533,7 +4536,7 @@ xfs_bmap_read_extents(
 	xfs_inode_t		*ip,	/* incore inode */
 	int			whichfork) /* data or attr fork */
 {
-	xfs_bmbt_block_t	*block;	/* current btree block */
+	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
 	xfs_buf_t		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
@@ -4570,7 +4573,7 @@ xfs_bmap_read_extents(
 		if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF)))
 			return error;
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
 			XFS_BMAP_SANITY_CHECK(mp, block, level),
 			error0);
@@ -4596,7 +4599,7 @@ xfs_bmap_read_extents(
 		xfs_extnum_t	start;
 
 
-		num_recs = be16_to_cpu(block->bb_numrecs);
+		num_recs = xfs_btree_get_numrecs(block);
 		if (unlikely(i + num_recs > room)) {
 			ASSERT(i + num_recs <= room);
 			xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
@@ -4613,7 +4616,7 @@ xfs_bmap_read_extents(
 		/*
 		 * Read-ahead the next leaf block, if any.
 		 */
-		nextbno = be64_to_cpu(block->bb_rightsib);
+		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		if (nextbno != NULLFSBLOCK)
 			xfs_btree_reada_bufl(mp, nextbno, 1);
 		/*
@@ -4650,7 +4653,7 @@ xfs_bmap_read_extents(
 		if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF)))
 			return error;
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 	}
 	ASSERT(i == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
 	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));
@@ -6175,7 +6178,7 @@ xfs_bmap_get_bp(
 
 void
 xfs_check_block(
-	xfs_bmbt_block_t        *block,
+	struct xfs_btree_block	*block,
 	xfs_mount_t		*mp,
 	int			root,
 	short			sz)
@@ -6187,7 +6190,7 @@ xfs_check_block(
 	ASSERT(be16_to_cpu(block->bb_level) > 0);
 
 	prevp = NULL;
-	for( i = 1; i <= be16_to_cpu(block->bb_numrecs); i++) {
+	for( i = 1; i <= xfs_btree_get_numrecs(block); i++) {
 		dmxr = mp->m_bmap_dmxr[0];
 		keyp = XFS_BMBT_KEY_ADDR(mp, block, i);
 
@@ -6232,7 +6235,7 @@ xfs_bmap_check_leaf_extents(
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			whichfork)	/* data or attr fork */
 {
-	xfs_bmbt_block_t	*block;	/* current btree block */
+	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
 	xfs_buf_t		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
@@ -6282,7 +6285,7 @@ xfs_bmap_check_leaf_extents(
 		if (!bp && (error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF)))
 			goto error_norelse;
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
 			XFS_BMAP_SANITY_CHECK(mp, block, level),
 			error0);
@@ -6317,13 +6320,13 @@ xfs_bmap_check_leaf_extents(
 		xfs_extnum_t	num_recs;
 
 
-		num_recs = be16_to_cpu(block->bb_numrecs);
+		num_recs = xfs_btree_get_numrecs(block);
 
 		/*
 		 * Read-ahead the next leaf block, if any.
 		 */
 
-		nextbno = be64_to_cpu(block->bb_rightsib);
+		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 		/*
 		 * Check all the extents to make sure they are OK.
@@ -6367,7 +6370,7 @@ xfs_bmap_check_leaf_extents(
 		if (!bp && (error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF)))
 			goto error_norelse;
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 	}
 	if (bp_release) {
 		bp_release = 0;
@@ -6397,7 +6400,7 @@ xfs_bmap_count_blocks(
 	int			whichfork,	/* data or attr fork */
 	int			*count)		/* out: count of blocks */
 {
-	xfs_bmbt_block_t	*block;	/* current btree block */
+	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
 	xfs_ifork_t		*ifp;	/* fork structure */
 	int			level;	/* btree level, for checking */
@@ -6454,24 +6457,24 @@ xfs_bmap_count_tree(
 	__be64			*pp;
 	xfs_fsblock_t           bno = blockno;
 	xfs_fsblock_t		nextbno;
-	xfs_bmbt_block_t        *block, *nextblock;
+	struct xfs_btree_block	*block, *nextblock;
 	int			numrecs;
 
 	if ((error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF)))
 		return error;
 	*count += 1;
-	block = XFS_BUF_TO_BMBT_BLOCK(bp);
+	block = XFS_BUF_TO_BLOCK(bp);
 
 	if (--level) {
 		/* Not at node above leafs, count this level of nodes */
-		nextbno = be64_to_cpu(block->bb_rightsib);
+		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		while (nextbno != NULLFSBLOCK) {
 			if ((error = xfs_btree_read_bufl(mp, tp, nextbno,
 				0, &nbp, XFS_BMAP_BTREE_REF)))
 				return error;
 			*count += 1;
-			nextblock = XFS_BUF_TO_BMBT_BLOCK(nbp);
-			nextbno = be64_to_cpu(nextblock->bb_rightsib);
+			nextblock = XFS_BUF_TO_BLOCK(nbp);
+			nextbno = be64_to_cpu(nextblock->bb_u.l.bb_rightsib);
 			xfs_trans_brelse(tp, nbp);
 		}
 
@@ -6489,7 +6492,7 @@ xfs_bmap_count_tree(
 	} else {
 		/* count all level 1 nodes and their leaves */
 		for (;;) {
-			nextbno = be64_to_cpu(block->bb_rightsib);
+			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
 			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
 			xfs_trans_brelse(tp, bp);
@@ -6500,7 +6503,7 @@ xfs_bmap_count_tree(
 				XFS_BMAP_BTREE_REF)))
 				return error;
 			*count += 1;
-			block = XFS_BUF_TO_BMBT_BLOCK(bp);
+			block = XFS_BUF_TO_BLOCK(bp);
 		}
 	}
 	return 0;
@@ -6531,7 +6534,7 @@ xfs_bmap_count_leaves(
 STATIC void
 xfs_bmap_disk_count_leaves(
 	struct xfs_mount	*mp,
-	xfs_bmbt_block_t	*block,
+	struct xfs_btree_block	*block,
 	int			numrecs,
 	int			*count)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:36:13.000000000 +0200
@@ -68,7 +68,7 @@ xfs_bmdr_to_bmbt(
 	struct xfs_mount	*mp,
 	xfs_bmdr_block_t	*dblock,
 	int			dblocklen,
-	xfs_bmbt_block_t	*rblock,
+	struct xfs_btree_block	*rblock,
 	int			rblocklen)
 {
 	int			dmxr;
@@ -81,8 +81,8 @@ xfs_bmdr_to_bmbt(
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
-	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
-	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	rblock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
+	rblock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
 	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
@@ -429,7 +429,7 @@ xfs_bmbt_set_state(
 void
 xfs_bmbt_to_bmdr(
 	struct xfs_mount	*mp,
-	xfs_bmbt_block_t	*rblock,
+	struct xfs_btree_block	*rblock,
 	int			rblocklen,
 	xfs_bmdr_block_t	*dblock,
 	int			dblocklen)
@@ -441,8 +441,8 @@ xfs_bmbt_to_bmdr(
 	__be64			*tpp;
 
 	ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
-	ASSERT(be64_to_cpu(rblock->bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(rblock->bb_rightsib) == NULLDFSBNO);
+	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_leftsib) == NULLDFSBNO);
+	ASSERT(be64_to_cpu(rblock->bb_u.l.bb_rightsib) == NULLDFSBNO);
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
@@ -906,7 +906,7 @@ xfs_bmbt_maxrecs(
 	int			blocklen,
 	int			leaf)
 {
-	blocklen -= sizeof(struct xfs_btree_lblock);
+	blocklen -= XFS_BMBT_BLOCK_LEN(mp);
 
 	if (leaf)
 		return blocklen / sizeof(xfs_bmbt_rec_t);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:36:13.000000000 +0200
@@ -22,7 +22,6 @@
 
 struct xfs_btree_cur;
 struct xfs_btree_block;
-struct xfs_btree_lblock;
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_trans;
@@ -147,27 +146,29 @@ typedef struct xfs_bmbt_key {
 /* btree pointer type */
 typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
 
-/* btree block header type */
-typedef struct xfs_btree_lblock xfs_bmbt_block_t;
-
-#define XFS_BUF_TO_BMBT_BLOCK(bp)	((xfs_bmbt_block_t *)XFS_BUF_PTR(bp))
+/*
+ * Btree block header size depends on a superblock flag.
+ *
+ * (not quite yet, but soon)
+ */
+#define XFS_BMBT_BLOCK_LEN(mp)	XFS_BTREE_LBLOCK_LEN
 
 #define XFS_BMBT_REC_ADDR(mp, block, index) \
 	((xfs_bmbt_rec_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_lblock) + \
+		 XFS_BMBT_BLOCK_LEN(mp) + \
 		 ((index) - 1) * sizeof(xfs_bmbt_rec_t)))
 
 #define XFS_BMBT_KEY_ADDR(mp, block, index) \
 	((xfs_bmbt_key_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_lblock) + \
+		 XFS_BMBT_BLOCK_LEN(mp) + \
 		 ((index) - 1) * sizeof(xfs_bmbt_key_t)))
 
 #define XFS_BMBT_PTR_ADDR(mp, block, index, maxrecs) \
 	((xfs_bmbt_ptr_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_lblock) + \
+		 XFS_BMBT_BLOCK_LEN(mp) + \
 		 (maxrecs) * sizeof(xfs_bmbt_key_t) + \
 		 ((index) - 1) * sizeof(xfs_bmbt_ptr_t)))
 
@@ -198,7 +199,7 @@ typedef struct xfs_btree_lblock xfs_bmbt
 	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
 
 #define XFS_BMAP_BROOT_SPACE_CALC(nrecs) \
-	(int)(sizeof(xfs_bmbt_block_t) + \
+	(int)(XFS_BTREE_LBLOCK_LEN + \
 	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
 
 #define XFS_BMAP_BROOT_SPACE(bb) \
@@ -223,7 +224,7 @@ typedef struct xfs_btree_lblock xfs_bmbt
  * Prototypes for xfs_bmap.c to call.
  */
 extern void xfs_bmdr_to_bmbt(struct xfs_mount *, xfs_bmdr_block_t *, int,
-			xfs_bmbt_block_t *, int);
+			struct xfs_btree_block *, int);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
@@ -246,7 +247,7 @@ extern void xfs_bmbt_disk_set_all(xfs_bm
 extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
-extern void xfs_bmbt_to_bmdr(struct xfs_mount *, xfs_bmbt_block_t *, int,
+extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);
 
 extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-09-15 02:12:10.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-09-15 02:36:13.000000000 +0200
@@ -53,10 +53,10 @@ const __uint32_t xfs_magics[XFS_BTNUM_MA
 };
 
 
-int					/* error (0 or EFSCORRUPTED) */
+STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_btree_lblock	*block,	/* btree long form block pointer */
+	struct xfs_btree_block	*block,	/* btree long form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer for block, if any */
 {
@@ -69,12 +69,14 @@ xfs_btree_check_lblock(
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
-		block->bb_leftsib &&
-		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
-		block->bb_rightsib &&
-		(be64_to_cpu(block->bb_rightsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_rightsib)));
+		block->bb_u.l.bb_leftsib &&
+		(be64_to_cpu(block->bb_u.l.bb_leftsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp,
+		 	be64_to_cpu(block->bb_u.l.bb_leftsib))) &&
+		block->bb_u.l.bb_rightsib &&
+		(be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp,
+		 	be64_to_cpu(block->bb_u.l.bb_rightsib)));
 	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
 			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
 			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
@@ -90,7 +92,7 @@ xfs_btree_check_lblock(
 STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sblock(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_btree_sblock	*block,	/* btree short form block pointer */
+	struct xfs_btree_block	*block,	/* btree short form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block */
 {
@@ -107,12 +109,12 @@ xfs_btree_check_sblock(
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
 			cur->bc_ops->get_maxrecs(cur, level) &&
-		(be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK ||
-		 be32_to_cpu(block->bb_leftsib) < agflen) &&
-		block->bb_leftsib &&
-		(be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK ||
-		 be32_to_cpu(block->bb_rightsib) < agflen) &&
-		block->bb_rightsib;
+		(be32_to_cpu(block->bb_u.s.bb_leftsib) == NULLAGBLOCK ||
+		 be32_to_cpu(block->bb_u.s.bb_leftsib) < agflen) &&
+		block->bb_u.s.bb_leftsib &&
+		(be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK ||
+		 be32_to_cpu(block->bb_u.s.bb_rightsib) < agflen) &&
+		block->bb_u.s.bb_rightsib;
 	if (unlikely(XFS_TEST_ERROR(!sblock_ok, cur->bc_mp,
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
@@ -135,13 +137,10 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		return xfs_btree_check_lblock(cur,
-				(struct xfs_btree_lblock *)block, level, bp);
-	} else {
-		return xfs_btree_check_sblock(cur,
-				(struct xfs_btree_sblock *)block, level, bp);
-	}
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return xfs_btree_check_lblock(cur, block, level, bp);
+	else
+		return xfs_btree_check_sblock(cur, block, level, bp);
 }
 
 /*
@@ -324,8 +323,8 @@ xfs_btree_dup_cursor(
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
 	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
-		sizeof(struct xfs_btree_lblock) :
-		sizeof(struct xfs_btree_sblock);
+		XFS_BTREE_LBLOCK_LEN :
+		XFS_BTREE_SBLOCK_LEN;
 }
 
 /*
@@ -508,7 +507,7 @@ xfs_btree_islastblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level)	/* level to check */
 {
-	xfs_btree_block_t	*block;	/* generic btree block pointer */
+	struct xfs_btree_block	*block;	/* generic btree block pointer */
 	xfs_buf_t		*bp;	/* buffer containing block */
 
 	block = xfs_btree_get_block(cur, level, &bp);
@@ -528,7 +527,7 @@ xfs_btree_firstrec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
-	xfs_btree_block_t	*block;	/* generic btree block pointer */
+	struct xfs_btree_block	*block;	/* generic btree block pointer */
 	xfs_buf_t		*bp;	/* buffer containing block */
 
 	/*
@@ -557,7 +556,7 @@ xfs_btree_lastrec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
-	xfs_btree_block_t	*block;	/* generic btree block pointer */
+	struct xfs_btree_block	*block;	/* generic btree block pointer */
 	xfs_buf_t		*bp;	/* buffer containing block */
 
 	/*
@@ -812,7 +811,7 @@ xfs_btree_setbuf(
 	int			lev,	/* level in btree */
 	xfs_buf_t		*bp)	/* new buffer to set */
 {
-	xfs_btree_block_t	*b;	/* btree block */
+	struct xfs_btree_block	*b;	/* btree block */
 	xfs_buf_t		*obp;	/* old buffer pointer */
 
 	obp = cur->bc_bufs[lev];
@@ -1250,20 +1249,20 @@ xfs_btree_log_block(
 	int			first;	/* first byte offset logged */
 	int			last;	/* last byte offset logged */
 	static const short	soffsets[] = {	/* table of offsets (short) */
-		offsetof(struct xfs_btree_sblock, bb_magic),
-		offsetof(struct xfs_btree_sblock, bb_level),
-		offsetof(struct xfs_btree_sblock, bb_numrecs),
-		offsetof(struct xfs_btree_sblock, bb_leftsib),
-		offsetof(struct xfs_btree_sblock, bb_rightsib),
-		sizeof(struct xfs_btree_sblock)
+		offsetof(struct xfs_btree_block, bb_magic),
+		offsetof(struct xfs_btree_block, bb_level),
+		offsetof(struct xfs_btree_block, bb_numrecs),
+		offsetof(struct xfs_btree_block, bb_u.s.bb_leftsib),
+		offsetof(struct xfs_btree_block, bb_u.s.bb_rightsib),
+		XFS_BTREE_SBLOCK_LEN
 	};
 	static const short	loffsets[] = {	/* table of offsets (long) */
-		offsetof(struct xfs_btree_lblock, bb_magic),
-		offsetof(struct xfs_btree_lblock, bb_level),
-		offsetof(struct xfs_btree_lblock, bb_numrecs),
-		offsetof(struct xfs_btree_lblock, bb_leftsib),
-		offsetof(struct xfs_btree_lblock, bb_rightsib),
-		sizeof(struct xfs_btree_lblock)
+		offsetof(struct xfs_btree_block, bb_magic),
+		offsetof(struct xfs_btree_block, bb_level),
+		offsetof(struct xfs_btree_block, bb_numrecs),
+		offsetof(struct xfs_btree_block, bb_u.l.bb_leftsib),
+		offsetof(struct xfs_btree_block, bb_u.l.bb_rightsib),
+		XFS_BTREE_LBLOCK_LEN
 	};
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
@@ -3016,7 +3015,7 @@ xfs_btree_kill_iroot(
 	if (index) {
 		xfs_iroot_realloc(cur->bc_private.b.ip, index,
 				  cur->bc_private.b.whichfork);
-		block = (struct xfs_btree_block *)ifp->if_broot;
+		block = ifp->if_broot;
 	}
 
 	be16_add_cpu(&block->bb_numrecs, index);
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-09-15 02:36:39.000000000 +0200
@@ -39,31 +39,16 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 
 /*
- * Short form header: space allocation btrees.
- */
-typedef struct xfs_btree_sblock {
-	__be32		bb_magic;	/* magic number for block type */
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-	__be32		bb_leftsib;	/* left sibling block or NULLAGBLOCK */
-	__be32		bb_rightsib;	/* right sibling block or NULLAGBLOCK */
-} xfs_btree_sblock_t;
-
-/*
- * Long form header: bmap btrees.
- */
-typedef struct xfs_btree_lblock {
-	__be32		bb_magic;	/* magic number for block type */
-	__be16		bb_level;	/* 0 is a leaf */
-	__be16		bb_numrecs;	/* current # of data records */
-	__be64		bb_leftsib;	/* left sibling block or NULLDFSBNO */
-	__be64		bb_rightsib;	/* right sibling block or NULLDFSBNO */
-} xfs_btree_lblock_t;
-
-/*
- * Combined header and structure, used by common code.
+ * Generic btree header.
+ *
+ * This is a comination of the actual format used on disk for short and long
+ * format btrees.  The first three fields are shared by both format, but
+ * the pointers are different and should be used with care.
+ *
+ * To get the size of the actual short or long form headers please use
+ * the size macros below.  Never use sizeof(xfs_btree_block).
  */
-typedef struct xfs_btree_block {
+struct xfs_btree_block {
 	__be32		bb_magic;	/* magic number for block type */
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
@@ -77,7 +62,11 @@ typedef struct xfs_btree_block {
 			__be64		bb_rightsib;
 		} l;			/* long form pointers */
 	} bb_u;				/* rest */
-} xfs_btree_block_t;
+};
+
+#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
+#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
+
 
 /*
  * Generic key, ptr and record wrapper structures.
@@ -294,20 +283,8 @@ typedef struct xfs_btree_cur
 /*
  * Convert from buffer to btree block header.
  */
-#define	XFS_BUF_TO_BLOCK(bp)	((xfs_btree_block_t *)XFS_BUF_PTR(bp))
-#define	XFS_BUF_TO_LBLOCK(bp)	((xfs_btree_lblock_t *)XFS_BUF_PTR(bp))
-#define	XFS_BUF_TO_SBLOCK(bp)	((xfs_btree_sblock_t *)XFS_BUF_PTR(bp))
-
+#define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)XFS_BUF_PTR(bp))
 
-/*
- * Check that long form block header is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_btree_lblock	*block,	/* btree long form block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
 /*
  * Check that block header is ok.
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-09-15 02:36:13.000000000 +0200
@@ -126,7 +126,7 @@ xfs_growfs_data_private(
 	xfs_extlen_t		agsize;
 	xfs_extlen_t		tmpsize;
 	xfs_alloc_rec_t		*arec;
-	xfs_btree_sblock_t	*block;
+	struct xfs_btree_block	*block;
 	xfs_buf_t		*bp;
 	int			bucket;
 	int			dpct;
@@ -251,13 +251,13 @@ xfs_growfs_data_private(
 		bp = xfs_buf_get(mp->m_ddev_targp,
 			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
 			BTOBB(mp->m_sb.sb_blocksize), 0);
-		block = XFS_BUF_TO_SBLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = cpu_to_be16(1);
-		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
@@ -272,13 +272,13 @@ xfs_growfs_data_private(
 		bp = xfs_buf_get(mp->m_ddev_targp,
 			XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
 			BTOBB(mp->m_sb.sb_blocksize), 0);
-		block = XFS_BUF_TO_SBLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = cpu_to_be16(1);
-		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
@@ -294,13 +294,13 @@ xfs_growfs_data_private(
 		bp = xfs_buf_get(mp->m_ddev_targp,
 			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
 			BTOBB(mp->m_sb.sb_blocksize), 0);
-		block = XFS_BUF_TO_SBLOCK(bp);
+		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
 		block->bb_level = 0;
 		block->bb_numrecs = 0;
-		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		error = xfs_bwrite(mp, bp);
 		if (error) {
 			goto error0;
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:30:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:36:13.000000000 +0200
@@ -375,7 +375,7 @@ xfs_inobt_maxrecs(
 	int			blocklen,
 	int			leaf)
 {
-	blocklen -= sizeof(struct xfs_btree_sblock);
+	blocklen -= XFS_INOBT_BLOCK_LEN(mp);
 
 	if (leaf)
 		return blocklen / sizeof(xfs_inobt_rec_t);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:36:13.000000000 +0200
@@ -24,7 +24,6 @@
 
 struct xfs_buf;
 struct xfs_btree_cur;
-struct xfs_btree_sblock;
 struct xfs_mount;
 
 /*
@@ -70,11 +69,6 @@ typedef struct xfs_inobt_key {
 /* btree pointer type */
 typedef __be32 xfs_inobt_ptr_t;
 
-/* btree block header type */
-typedef	struct xfs_btree_sblock xfs_inobt_block_t;
-
-#define	XFS_BUF_TO_INOBT_BLOCK(bp)	((xfs_inobt_block_t *)XFS_BUF_PTR(bp))
-
 /*
  * Bit manipulations for ir_free.
  */
@@ -96,24 +90,33 @@ typedef	struct xfs_btree_sblock xfs_inob
 #define	XFS_PREALLOC_BLOCKS(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
 
 /*
+ * Btree block header size depends on a superblock flag.
+ *
+ * (not quite yet, but soon)
+ */
+#define XFS_INOBT_BLOCK_LEN(mp)	XFS_BTREE_SBLOCK_LEN
+
+/*
  * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
  */
 #define XFS_INOBT_REC_ADDR(mp, block, index) \
 	((xfs_inobt_rec_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_INOBT_BLOCK_LEN(mp) + \
 		 (((index) - 1) * sizeof(xfs_inobt_rec_t))))
 
 #define XFS_INOBT_KEY_ADDR(mp, block, index) \
 	((xfs_inobt_key_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_INOBT_BLOCK_LEN(mp) + \
 		 ((index) - 1) * sizeof(xfs_inobt_key_t)))
 
 #define XFS_INOBT_PTR_ADDR(mp, block, index, maxrecs) \
 	((xfs_inobt_ptr_t *) \
 		((char *)(block) + \
-		 sizeof(struct xfs_btree_sblock) + \
+		 XFS_INOBT_BLOCK_LEN(mp) + \
 		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-15 02:36:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-15 02:36:13.000000000 +0200
@@ -2352,7 +2352,7 @@ xfs_iroot_realloc(
 	struct xfs_mount	*mp = ip->i_mount;
 	int			cur_max;
 	xfs_ifork_t		*ifp;
-	xfs_bmbt_block_t	*new_broot;
+	struct xfs_btree_block	*new_broot;
 	int			new_max;
 	size_t			new_size;
 	char			*np;
@@ -2373,8 +2373,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
-			ifp->if_broot = (xfs_bmbt_block_t*)kmem_alloc(new_size,
-								     KM_SLEEP);
+			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -2388,9 +2387,7 @@ xfs_iroot_realloc(
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
 		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
-		ifp->if_broot = (xfs_bmbt_block_t *)
-		  kmem_realloc(ifp->if_broot,
-				new_size,
+		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
 				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
 				KM_SLEEP);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -2418,11 +2415,11 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = (xfs_bmbt_block_t *)kmem_alloc(new_size, KM_SLEEP);
+		new_broot = kmem_alloc(new_size, KM_SLEEP);
 		/*
 		 * First copy over the btree block header.
 		 */
-		memcpy(new_broot, ifp->if_broot, sizeof(xfs_bmbt_block_t));
+		memcpy(new_broot, ifp->if_broot, XFS_BTREE_LBLOCK_LEN);
 	} else {
 		new_broot = NULL;
 		ifp->if_flags &= ~XFS_IFBROOT;
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-09-15 02:12:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-09-15 02:36:13.000000000 +0200
@@ -63,7 +63,7 @@ typedef struct xfs_ext_irec {
 typedef struct xfs_ifork {
 	int			if_bytes;	/* bytes in if_u1 */
 	int			if_real_bytes;	/* bytes allocated in if_u1 */
-	xfs_bmbt_block_t	*if_broot;	/* file's incore btree root */
+	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
 	unsigned char		if_ext_max;	/* max # of extent records */
@@ -110,7 +110,6 @@ struct ktrace;
 struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_bmbt_irec;
-struct xfs_bmbt_block;
 struct xfs_inode;
 struct xfs_inode_log_item;
 struct xfs_mount;
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-15 02:30:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-15 02:36:13.000000000 +0200
@@ -2452,8 +2452,8 @@ xlog_recover_do_inode_trans(
 		break;
 
 	case XFS_ILOG_DBROOT:
-		xfs_bmbt_to_bmdr(mp, (xfs_bmbt_block_t *)src, len,
-				 &(dip->di_u.di_bmbt),
+		xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src, len,
+				 &dip->di_u.di_bmbt,
 				 XFS_DFORK_DSIZE(dip, mp));
 		break;
 
@@ -2490,8 +2490,8 @@ xlog_recover_do_inode_trans(
 
 		case XFS_ILOG_ABROOT:
 			dest = XFS_DFORK_APTR(dip);
-			xfs_bmbt_to_bmdr(mp, (xfs_bmbt_block_t *)src, len,
-					 (xfs_bmdr_block_t*)dest,
+			xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src,
+					 len, (xfs_bmdr_block_t*)dest,
 					 XFS_DFORK_ASIZE(dip, mp));
 			break;
 
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-15 02:26:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-15 02:36:13.000000000 +0200
@@ -3078,7 +3078,7 @@ xfsidbg_print_alloc_key(int i, union xfs
 }
 
 static struct xfsidbg_btree xfsidbg_allocbt = {
-	.block_len	= sizeof(struct xfs_btree_sblock),
+	.block_len	= XFS_BTREE_SBLOCK_LEN,
 	.key_len	= sizeof(xfs_alloc_key_t),
 	.rec_len	= sizeof(xfs_alloc_rec_t),
 	.ptr_len	= sizeof(__be32),
@@ -3110,7 +3110,7 @@ xfsidbg_print_bmbt_key(int i, union xfs_
 }
 
 static struct xfsidbg_btree xfsidbg_bmbt = {
-	.block_len	= sizeof(struct xfs_btree_lblock),
+	.block_len	= XFS_BTREE_LBLOCK_LEN,
 	.key_len	= sizeof(xfs_bmbt_key_t),
 	.rec_len	= sizeof(xfs_bmbt_rec_t),
 	.ptr_len	= sizeof(__be64),
@@ -3138,7 +3138,7 @@ xfsidbg_print_inobt_key(int i, union xfs
 }
 
 static struct xfsidbg_btree xfsidbg_inobtbt = {
-	.block_len	= sizeof(struct xfs_btree_sblock),
+	.block_len	= XFS_BTREE_SBLOCK_LEN,
 	.key_len	= sizeof(xfs_inobt_key_t),
 	.rec_len	= sizeof(xfs_inobt_rec_t),
 	.ptr_len	= sizeof(__be32),
@@ -3162,8 +3162,7 @@ xfs_broot(xfs_inode_t *ip, xfs_ifork_t *
 		return;
 	}
 
-	xfs_btblock((struct xfs_btree_block *)f->if_broot, f->if_broot_bytes,
-		    &xfsidbg_bmbt);
+	xfs_btblock(f->if_broot, f->if_broot_bytes, &xfsidbg_bmbt);
 }
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-09-15 02:30:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-09-15 02:36:13.000000000 +0200
@@ -165,7 +165,7 @@ typedef enum xfs_dinode_fmt
  */
 #define	XFS_LITINO(mp)	((mp)->m_litino)
 #define	XFS_BROOT_SIZE_ADJ	\
-	(sizeof(xfs_bmbt_block_t) - sizeof(xfs_bmdr_block_t))
+	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
 
 /*
  * Inode data & attribute fork sizes, per inode.

-- 
