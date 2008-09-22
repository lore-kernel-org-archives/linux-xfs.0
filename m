Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 04:05:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MB55QI018052
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:05:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 397969448C6
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:38 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 3lcw0QkDFKDolAAD for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:38 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8MB6bIF026086
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 13:06:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8MB6bCJ026084
	for xfs@oss.sgi.com; Mon, 22 Sep 2008 13:06:37 +0200
Date: Mon, 22 Sep 2008 13:06:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] cleanup btree record / key / ptr addressing macros
Message-ID: <20080922110637.GE26007@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-macro-cleanup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Replace the generic record / key / ptr addressing macros that use cpp token
pasting with simpler macros that do the job for just one given btree type.
The new macros lose the cur argument and thus can be used outside the core
btree code, but also gain an xfs_mount * argument to allow for checking the
CRC flag in the near future.  Note that many of these macros aren't actually
used in the kernel code, but only in userspace (mostly in xfs_repair).


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-09-19 11:41:18.000000000 +0200
@@ -179,7 +179,7 @@ xfs_allocbt_update_lastrec(
 		if (numrecs) {
 			xfs_alloc_rec_t *rrp;
 
-			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
+			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
 			len = rrp->ar_blockcount;
 		} else {
 			len = 0;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-09-19 11:41:17.000000000 +0200
@@ -44,7 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
-
 /*
  * Determine the extent state.
  */
@@ -85,9 +84,9 @@ xfs_bmdr_to_bmbt(
 	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
-	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
-	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
+	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
+	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
+	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
 	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
@@ -448,10 +447,10 @@ xfs_bmbt_to_bmdr(
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
-	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
+	fkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
+	tkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
-	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
+	tpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-09-19 11:41:27.000000000 +0200
@@ -78,16 +78,27 @@ typedef	struct xfs_btree_sblock xfs_allo
 
 /*
  * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
  */
-#define	XFS_ALLOC_REC_ADDR(bb,i,cur)	\
-	XFS_BTREE_REC_ADDR(xfs_alloc, bb, i)
-
-#define	XFS_ALLOC_KEY_ADDR(bb,i,cur)	\
-	XFS_BTREE_KEY_ADDR(xfs_alloc, bb, i)
-
-#define	XFS_ALLOC_PTR_ADDR(bb,i,cur)	\
-	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
-
+#define XFS_ALLOC_REC_ADDR(mp, block, index) \
+	((xfs_alloc_rec_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 (((index) - 1) * sizeof(xfs_alloc_rec_t))))
+
+#define XFS_ALLOC_KEY_ADDR(mp, block, index) \
+	((xfs_alloc_key_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 ((index) - 1) * sizeof(xfs_alloc_key_t)))
+
+#define XFS_ALLOC_PTR_ADDR(mp, block, index, maxrecs) \
+	((xfs_alloc_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 (maxrecs) * sizeof(xfs_alloc_key_t) + \
+		 ((index) - 1) * sizeof(xfs_alloc_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-09-19 11:41:17.000000000 +0200
@@ -97,16 +97,27 @@ typedef	struct xfs_btree_sblock xfs_inob
 
 /*
  * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
  */
-#define XFS_INOBT_REC_ADDR(bb,i,cur) \
-	(XFS_BTREE_REC_ADDR(xfs_inobt, bb, i))
+#define XFS_INOBT_REC_ADDR(mp, block, index) \
+	((xfs_inobt_rec_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 (((index) - 1) * sizeof(xfs_inobt_rec_t))))
 
-#define	XFS_INOBT_KEY_ADDR(bb,i,cur) \
-	(XFS_BTREE_KEY_ADDR(xfs_inobt, bb, i))
+#define XFS_INOBT_KEY_ADDR(mp, block, index) \
+	((xfs_inobt_key_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 ((index) - 1) * sizeof(xfs_inobt_key_t)))
 
-#define	XFS_INOBT_PTR_ADDR(bb,i,cur) \
-	(XFS_BTREE_PTR_ADDR(xfs_inobt, bb, \
-				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
+#define XFS_INOBT_PTR_ADDR(mp, block, index, maxrecs) \
+	((xfs_inobt_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_sblock) + \
+		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
+		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-19 11:41:17.000000000 +0200
@@ -393,7 +393,7 @@ xfs_bmap_count_leaves(
 
 STATIC void
 xfs_bmap_disk_count_leaves(
-	xfs_extnum_t		idx,
+	struct xfs_mount	*mp,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
 	int			*count);
@@ -3539,7 +3539,7 @@ xfs_bmap_extents_to_btree(
 	ablock->bb_level = 0;
 	ablock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	ablock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
-	arp = XFS_BMAP_REC_IADDR(ablock, 1, cur);
+	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
@@ -3554,11 +3554,13 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the root key and pointer.
 	 */
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	arp = XFS_BMAP_REC_IADDR(ablock, 1, cur);
+	kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
+	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
+	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, xfs_bmbt_get_maxrecs(cur,
+						be16_to_cpu(block->bb_level)));
 	*pp = cpu_to_be64(args.fsbno);
+
 	/*
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
@@ -4574,7 +4576,7 @@ xfs_bmap_read_extents(
 			error0);
 		if (level == 0)
 			break;
-		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		xfs_trans_brelse(tp, bp);
@@ -4617,7 +4619,7 @@ xfs_bmap_read_extents(
 		/*
 		 * Copy records into the extent records.
 		 */
-		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
+		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
 		start = i;
 		for (j = 0; j < num_recs; j++, i++, frp++) {
 			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
@@ -6187,12 +6189,7 @@ xfs_check_block(
 	prevp = NULL;
 	for( i = 1; i <= be16_to_cpu(block->bb_numrecs); i++) {
 		dmxr = mp->m_bmap_dmxr[0];
-
-		if (root) {
-			keyp = XFS_BMAP_BROOT_KEY_ADDR(block, i, sz);
-		} else {
-			keyp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, i);
-		}
+		keyp = XFS_BMBT_KEY_ADDR(mp, block, i);
 
 		if (prevp) {
 			ASSERT(be64_to_cpu(prevp->br_startoff) <
@@ -6203,19 +6200,16 @@ xfs_check_block(
 		/*
 		 * Compare the block numbers to see if there are dups.
 		 */
-
-		if (root) {
+		if (root)
 			pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, i, sz);
-		} else {
-			pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, i, dmxr);
-		}
+		else
+			pp = XFS_BMBT_PTR_ADDR(mp, block, i, dmxr);
+
 		for (j = i+1; j <= be16_to_cpu(block->bb_numrecs); j++) {
-			if (root) {
+			if (root)
 				thispa = XFS_BMAP_BROOT_PTR_ADDR(mp, block, j, sz);
-			} else {
-				thispa = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, j,
-							    dmxr);
-			}
+			else
+				thispa = XFS_BMBT_PTR_ADDR(mp, block, j, dmxr);
 			if (*thispa == *pp) {
 				cmn_err(CE_WARN, "%s: thispa(%d) == pp(%d) %Ld",
 					__func__, j, i,
@@ -6301,7 +6295,7 @@ xfs_bmap_check_leaf_extents(
 		 */
 
 		xfs_check_block(block, mp, 0, 0);
-		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		if (bp_release) {
@@ -6337,14 +6331,14 @@ xfs_bmap_check_leaf_extents(
 		 * conform with the first entry in this one.
 		 */
 
-		ep = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
+		ep = XFS_BMBT_REC_ADDR(mp, block, 1);
 		if (i) {
 			ASSERT(xfs_bmbt_disk_get_startoff(&last) +
 			       xfs_bmbt_disk_get_blockcount(&last) <=
 			       xfs_bmbt_disk_get_startoff(ep));
 		}
 		for (j = 1; j < num_recs; j++) {
-			nextp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, j + 1);
+			nextp = XFS_BMBT_REC_ADDR(mp, block, j + 1);
 			ASSERT(xfs_bmbt_disk_get_startoff(ep) +
 			       xfs_bmbt_disk_get_blockcount(ep) <=
 			       xfs_bmbt_disk_get_startoff(nextp));
@@ -6482,7 +6476,7 @@ xfs_bmap_count_tree(
 		}
 
 		/* Dive to the next level */
-		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (unlikely((error =
 		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
@@ -6497,7 +6491,7 @@ xfs_bmap_count_tree(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
-			xfs_bmap_disk_count_leaves(0, block, numrecs, count);
+			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
 			xfs_trans_brelse(tp, bp);
 			if (nextbno == NULLFSBLOCK)
 				break;
@@ -6536,7 +6530,7 @@ xfs_bmap_count_leaves(
  */
 STATIC void
 xfs_bmap_disk_count_leaves(
-	xfs_extnum_t		idx,
+	struct xfs_mount	*mp,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
 	int			*count)
@@ -6545,7 +6539,7 @@ xfs_bmap_disk_count_leaves(
 	xfs_bmbt_rec_t	*frp;
 
 	for (b = 1; b <= numrecs; b++) {
-		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx + b);
+		frp = XFS_BMBT_REC_ADDR(mp, block, b);
 		*count += xfs_bmbt_disk_get_blockcount(frp);
 	}
 }
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-09-19 11:41:17.000000000 +0200
@@ -21,6 +21,7 @@
 #define XFS_BMAP_MAGIC	0x424d4150	/* 'BMAP' */
 
 struct xfs_btree_cur;
+struct xfs_btree_block;
 struct xfs_btree_lblock;
 struct xfs_mount;
 struct xfs_inode;
@@ -151,33 +152,50 @@ typedef struct xfs_btree_lblock xfs_bmbt
 
 #define XFS_BUF_TO_BMBT_BLOCK(bp)	((xfs_bmbt_block_t *)XFS_BUF_PTR(bp))
 
-#define XFS_BMAP_REC_DADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
-
-#define XFS_BMAP_REC_IADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
-
-#define XFS_BMAP_KEY_DADDR(bb,i,cur)	\
-	(XFS_BTREE_KEY_ADDR(xfs_bmbt, bb, i))
-
-#define XFS_BMAP_KEY_IADDR(bb,i,cur)	\
-	(XFS_BTREE_KEY_ADDR(xfs_bmbt, bb, i))
-
-#define XFS_BMAP_PTR_DADDR(bb,i,cur)	\
-	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
-#define XFS_BMAP_PTR_IADDR(bb,i,cur)	\
-	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, xfs_bmbt_get_maxrecs(cur,	\
-				be16_to_cpu((bb)->bb_level))))
+#define XFS_BMBT_REC_ADDR(mp, block, index) \
+	((xfs_bmbt_rec_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_lblock) + \
+		 ((index) - 1) * sizeof(xfs_bmbt_rec_t)))
+
+#define XFS_BMBT_KEY_ADDR(mp, block, index) \
+	((xfs_bmbt_key_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_lblock) + \
+		 ((index) - 1) * sizeof(xfs_bmbt_key_t)))
+
+#define XFS_BMBT_PTR_ADDR(mp, block, index, maxrecs) \
+	((xfs_bmbt_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_btree_lblock) + \
+		 (maxrecs) * sizeof(xfs_bmbt_key_t) + \
+		 ((index) - 1) * sizeof(xfs_bmbt_ptr_t)))
+
+#define XFS_BMDR_REC_ADDR(block, index) \
+	((xfs_bmdr_rec_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_bmdr_block) + \
+	         ((index) - 1) * sizeof(xfs_bmdr_rec_t)))
+
+#define XFS_BMDR_KEY_ADDR(block, index) \
+	((xfs_bmdr_key_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_bmdr_block) + \
+		 ((index) - 1) * sizeof(xfs_bmdr_key_t)))
+
+#define XFS_BMDR_PTR_ADDR(block, index, maxrecs) \
+	((xfs_bmdr_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_bmdr_block) + \
+		 (maxrecs) * sizeof(xfs_bmdr_key_t) + \
+		 ((index) - 1) * sizeof(xfs_bmdr_ptr_t)))
 
 /*
  * These are to be used when we know the size of the block and
  * we don't have a cursor.
  */
-#define XFS_BMAP_BROOT_REC_ADDR(bb,i,sz) \
-	(XFS_BTREE_REC_ADDR(xfs_bmbt,bb,i))
-#define XFS_BMAP_BROOT_KEY_ADDR(bb,i,sz) \
-	(XFS_BTREE_KEY_ADDR(xfs_bmbt,bb,i))
-#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb,i,sz) \
-	(XFS_BTREE_PTR_ADDR(xfs_bmbt,bb,i,xfs_bmbt_maxrecs(mp, sz, 0)))
+#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
+	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
 
 #define XFS_BMAP_BROOT_SPACE_CALC(nrecs) \
 	(int)(sizeof(xfs_bmbt_block_t) + \
Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2008-09-19 11:41:17.000000000 +0200
@@ -258,7 +258,7 @@ xfs_growfs_data_private(
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		arec = XFS_BTREE_REC_ADDR(xfs_alloc, block, 1);
+		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
@@ -279,7 +279,7 @@ xfs_growfs_data_private(
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		arec = XFS_BTREE_REC_ADDR(xfs_alloc, block, 1);
+		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-19 11:30:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-19 11:41:17.000000000 +0200
@@ -2435,10 +2435,8 @@ xfs_iroot_realloc(
 		/*
 		 * First copy the records.
 		 */
-		op = (char *)XFS_BMAP_BROOT_REC_ADDR(ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_REC_ADDR(new_broot, 1,
-						     (int)new_size);
+		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
 
 		/*
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-09-19 11:30:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-09-19 11:41:17.000000000 +0200
@@ -149,21 +149,6 @@ do {    \
 	}       \
 } while (0)
 
-/*
- * Record, key, and pointer address calculation macros.
- * Given block size, type prefix, block pointer, and index of requested entry
- * (first entry numbered 1).
- */
-#define	XFS_BTREE_REC_ADDR(t,bb,i)	\
-	((t ## _rec_t *)((char *)(bb) + sizeof(t ## _block_t) + \
-	 ((i) - 1) * sizeof(t ## _rec_t)))
-#define	XFS_BTREE_KEY_ADDR(t,bb,i)	\
-	((t ## _key_t *)((char *)(bb) + sizeof(t ## _block_t) + \
-	 ((i) - 1) * sizeof(t ## _key_t)))
-#define	XFS_BTREE_PTR_ADDR(t,bb,i,mxr)	\
-	((t ## _ptr_t *)((char *)(bb) + sizeof(t ## _block_t) + \
-	 (mxr) * sizeof(t ## _key_t) + ((i) - 1) * sizeof(t ## _ptr_t)))
-
 #define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
 
 struct xfs_btree_ops {

-- 
