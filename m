Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 14:00:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBLM0Oqw015129
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 14:00:25 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kBLLxXRe016594
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:59:33 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBLLxXJ2026872
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:59:33 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBLLxXkY003978
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 16:59:33 -0500
Message-ID: <458B03C4.6000306@sandeen.net>
Date: Thu, 21 Dec 2006 15:59:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused arguments from the XFS_BTREE_*_ADDR functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Unused arguments to macros... I don't honestly remember how I stumbled
across these...

It makes it incrementally clearer to read the code when the top of a macro
spaghetti-pile only receives the 3 arguments it uses, rather than 2 extra
ones which are not used.  Also when you start pulling this thread out of the
sweater (i.e. remove unused args from XFS_BTREE_*_ADDR), a couple other 
third arms etc fall off too.  If they're not used in the macro, then they
sometimes don't need to be passed to the function calling the macro either, 
etc....

I suppose this one may take some extra scrutiny to review, but it's a bunch
of dead & therefore confusing code, near as I can tell.

Thanks,

-Eric

 xfs_alloc_btree.h  |   10 +++-------
 xfs_bmap.c         |   35 ++++++++++++-----------------------
 xfs_bmap_btree.c   |    8 ++++----
 xfs_bmap_btree.h   |   46 +++++++++++-----------------------------------
 xfs_btree.h        |    6 +++---
 xfs_fsops.c        |    6 ++----
 xfs_ialloc_btree.h |   10 ++++------
 xfsidbg.c          |   19 +++++++++----------
 8 files changed, 48 insertions(+), 92 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux-allpatches/xfs_alloc_btree.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_alloc_btree.h
+++ xfs-linux-allpatches/xfs_alloc_btree.h
@@ -58,7 +58,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 /*
  * Real block structures have a size equal to the disk block size.
  */
-#define	XFS_ALLOC_BLOCK_SIZE(lev,cur)	(1 << (cur)->bc_blocklog)
 #define	XFS_ALLOC_BLOCK_MAXRECS(lev,cur) ((cur)->bc_mp->m_alloc_mxr[lev != 0])
 #define	XFS_ALLOC_BLOCK_MINRECS(lev,cur) ((cur)->bc_mp->m_alloc_mnr[lev != 0])
 
@@ -87,16 +86,13 @@ typedef	struct xfs_btree_sblock xfs_allo
  * Record, key, and pointer address macros for btree blocks.
  */
 #define	XFS_ALLOC_REC_ADDR(bb,i,cur)	\
-	XFS_BTREE_REC_ADDR(XFS_ALLOC_BLOCK_SIZE(0,cur), xfs_alloc, \
-				bb, i, XFS_ALLOC_BLOCK_MAXRECS(0, cur))
+	XFS_BTREE_REC_ADDR(xfs_alloc, bb, i)
 
 #define	XFS_ALLOC_KEY_ADDR(bb,i,cur)	\
-	XFS_BTREE_KEY_ADDR(XFS_ALLOC_BLOCK_SIZE(1,cur), xfs_alloc, \
-				bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
+	XFS_BTREE_KEY_ADDR(xfs_alloc, bb, i)
 
 #define	XFS_ALLOC_PTR_ADDR(bb,i,cur)	\
-	XFS_BTREE_PTR_ADDR(XFS_ALLOC_BLOCK_SIZE(1,cur), xfs_alloc, \
-				bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
+	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
 /*
  * Decrement cursor by one record at the level.
Index: xfs-linux-allpatches/xfs_bmap.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_bmap.c
+++ xfs-linux-allpatches/xfs_bmap.c
@@ -410,7 +410,6 @@ xfs_bmap_count_leaves(
 STATIC int
 xfs_bmap_disk_count_leaves(
 	xfs_ifork_t		*ifp,
-	xfs_mount_t		*mp,
 	xfs_extnum_t		idx,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
@@ -4533,8 +4532,7 @@ xfs_bmap_read_extents(
 			error0);
 		if (level == 0)
 			break;
-		pp = XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt, block,
-			1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		xfs_trans_brelse(tp, bp);
@@ -4577,8 +4575,7 @@ xfs_bmap_read_extents(
 		/*
 		 * Copy records into the extent records.
 		 */
-		frp = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt,
-			block, 1, mp->m_bmap_dmxr[0]);
+		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
 		start = i;
 		for (j = 0; j < num_recs; j++, i++, frp++) {
 			trp = xfs_iext_get_ext(ifp, i);
@@ -6156,8 +6153,7 @@ xfs_check_block(
 		if (root) {
 			keyp = XFS_BMAP_BROOT_KEY_ADDR(block, i, sz);
 		} else {
-			keyp = XFS_BTREE_KEY_ADDR(mp->m_sb.sb_blocksize,
-				xfs_bmbt, block, i, dmxr);
+			keyp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, i);
 		}
 
 		if (prevp) {
@@ -6172,15 +6168,14 @@ xfs_check_block(
 		if (root) {
 			pp = XFS_BMAP_BROOT_PTR_ADDR(block, i, sz);
 		} else {
-			pp = XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize,
-				xfs_bmbt, block, i, dmxr);
+			pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, i, dmxr);
 		}
 		for (j = i+1; j <= be16_to_cpu(block->bb_numrecs); j++) {
 			if (root) {
 				thispa = XFS_BMAP_BROOT_PTR_ADDR(block, j, sz);
 			} else {
-				thispa = XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize,
-					xfs_bmbt, block, j, dmxr);
+				thispa = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, j,
+							    dmxr);
 			}
 			if (*thispa == *pp) {
 				cmn_err(CE_WARN, "%s: thispa(%d) == pp(%d) %Ld",
@@ -6267,8 +6262,7 @@ xfs_bmap_check_leaf_extents(
 		 */
 
 		xfs_check_block(block, mp, 0, 0);
-		pp = XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt, block,
-			1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(XFS_FSB_SANITY_CHECK(mp, bno), error0);
 		if (bp_release) {
@@ -6305,11 +6299,9 @@ xfs_bmap_check_leaf_extents(
 		 * conform with the first entry in this one.
 		 */
 
-		ep = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt,
-			block, 1, mp->m_bmap_dmxr[0]);
+		ep = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
 		for (j = 1; j < num_recs; j++) {
-			nextp = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_bmbt,
-				block, j + 1, mp->m_bmap_dmxr[0]);
+			nextp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, j + 1);
 			if (lastp) {
 				xfs_btree_check_rec(XFS_BTNUM_BMAP,
 					(void *)lastp, (void *)ep);
@@ -6454,8 +6446,7 @@ xfs_bmap_count_tree(
 		}
 
 		/* Dive to the next level */
-		pp = XFS_BTREE_PTR_ADDR(mp->m_sb.sb_blocksize,
-			xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
+		pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		if (unlikely((error =
 		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
@@ -6470,7 +6461,7 @@ xfs_bmap_count_tree(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
-			if (unlikely(xfs_bmap_disk_count_leaves(ifp, mp,
+			if (unlikely(xfs_bmap_disk_count_leaves(ifp,
 					0, block, numrecs, count) < 0)) {
 				xfs_trans_brelse(tp, bp);
 				XFS_ERROR_REPORT("xfs_bmap_count_tree(2)",
@@ -6518,7 +6509,6 @@ xfs_bmap_count_leaves(
 int
 xfs_bmap_disk_count_leaves(
 	xfs_ifork_t		*ifp,
-	xfs_mount_t		*mp,
 	xfs_extnum_t		idx,
 	xfs_bmbt_block_t	*block,
 	int			numrecs,
@@ -6528,8 +6518,7 @@ xfs_bmap_disk_count_leaves(
 	xfs_bmbt_rec_t	*frp;
 
 	for (b = 1; b <= numrecs; b++) {
-		frp = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize,
-			xfs_bmbt, block, idx + b, mp->m_bmap_dmxr[0]);
+		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx + b);
 		*count += xfs_bmbt_disk_get_blockcount(frp);
 	}
 	return 0;
Index: xfs-linux-allpatches/xfs_bmap_btree.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_bmap_btree.c
+++ xfs-linux-allpatches/xfs_bmap_btree.c
@@ -1731,9 +1731,9 @@ xfs_bmdr_to_bmbt(
 	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
 	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
-	fkp = XFS_BTREE_KEY_ADDR(dblocklen, xfs_bmdr, dblock, 1, dmxr);
+	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
 	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	fpp = XFS_BTREE_PTR_ADDR(dblocklen, xfs_bmdr, dblock, 1, dmxr);
+	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
 	tpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
@@ -2684,9 +2684,9 @@ xfs_bmbt_to_bmdr(
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
 	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	tkp = XFS_BTREE_KEY_ADDR(dblocklen, xfs_bmdr, dblock, 1, dmxr);
+	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
 	fpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
-	tpp = XFS_BTREE_PTR_ADDR(dblocklen, xfs_bmdr, dblock, 1, dmxr);
+	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
Index: xfs-linux-allpatches/xfs_bmap_btree.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_bmap_btree.h
+++ xfs-linux-allpatches/xfs_bmap_btree.h
@@ -175,19 +175,11 @@ typedef struct xfs_btree_lblock xfs_bmbt
 
 #define XFS_BUF_TO_BMBT_BLOCK(bp)	((xfs_bmbt_block_t *)XFS_BUF_PTR(bp))
 
-#define XFS_BMAP_IBLOCK_SIZE(lev,cur)	(1 << (cur)->bc_blocklog)
 #define XFS_BMAP_RBLOCK_DSIZE(lev,cur)	((cur)->bc_private.b.forksize)
 #define XFS_BMAP_RBLOCK_ISIZE(lev,cur)	\
 	((int)XFS_IFORK_PTR((cur)->bc_private.b.ip, \
 		    (cur)->bc_private.b.whichfork)->if_broot_bytes)
 
-#define XFS_BMAP_BLOCK_DSIZE(lev,cur)	\
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-		XFS_BMAP_RBLOCK_DSIZE(lev,cur) : XFS_BMAP_IBLOCK_SIZE(lev,cur)))
-#define XFS_BMAP_BLOCK_ISIZE(lev,cur)	\
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-		XFS_BMAP_RBLOCK_ISIZE(lev,cur) : XFS_BMAP_IBLOCK_SIZE(lev,cur)))
-
 #define XFS_BMAP_BLOCK_DMAXRECS(lev,cur) \
 	(((lev) == (cur)->bc_nlevels - 1 ? \
 		XFS_BTREE_BLOCK_MAXRECS(XFS_BMAP_RBLOCK_DSIZE(lev,cur), \
@@ -210,37 +202,21 @@ typedef struct xfs_btree_lblock xfs_bmbt
 				xfs_bmbt, (lev) == 0) : \
 			((cur)->bc_mp->m_bmap_dmnr[(lev) != 0])))
 
-#define XFS_BMAP_REC_DADDR(bb,i,cur)	\
-	(XFS_BTREE_REC_ADDR(XFS_BMAP_BLOCK_DSIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
-#define XFS_BMAP_REC_IADDR(bb,i,cur)	\
-	(XFS_BTREE_REC_ADDR(XFS_BMAP_BLOCK_ISIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_IMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
+#define XFS_BMAP_REC_DADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
+
+#define XFS_BMAP_REC_IADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
 
 #define XFS_BMAP_KEY_DADDR(bb,i,cur)	\
-	(XFS_BTREE_KEY_ADDR(XFS_BMAP_BLOCK_DSIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
+	(XFS_BTREE_KEY_ADDR(xfs_bmbt, bb, i))
+
 #define XFS_BMAP_KEY_IADDR(bb,i,cur)	\
-	(XFS_BTREE_KEY_ADDR(XFS_BMAP_BLOCK_ISIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_IMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
+	(XFS_BTREE_KEY_ADDR(xfs_bmbt, bb, i))
 
 #define XFS_BMAP_PTR_DADDR(bb,i,cur)	\
-	(XFS_BTREE_PTR_ADDR(XFS_BMAP_BLOCK_DSIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
+	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
 				be16_to_cpu((bb)->bb_level), cur)))
 #define XFS_BMAP_PTR_IADDR(bb,i,cur)	\
-	(XFS_BTREE_PTR_ADDR(XFS_BMAP_BLOCK_ISIZE(			\
-			be16_to_cpu((bb)->bb_level), cur),		\
-			xfs_bmbt, bb, i, XFS_BMAP_BLOCK_IMAXRECS(	\
+	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, XFS_BMAP_BLOCK_IMAXRECS(	\
 				be16_to_cpu((bb)->bb_level), cur)))
 
 /*
@@ -248,11 +224,11 @@ typedef struct xfs_btree_lblock xfs_bmbt
  * we don't have a cursor.
  */
 #define XFS_BMAP_BROOT_REC_ADDR(bb,i,sz) \
-	(XFS_BTREE_REC_ADDR(sz,xfs_bmbt,bb,i,XFS_BMAP_BROOT_MAXRECS(sz)))
+	(XFS_BTREE_REC_ADDR(xfs_bmbt,bb,i))
 #define XFS_BMAP_BROOT_KEY_ADDR(bb,i,sz) \
-	(XFS_BTREE_KEY_ADDR(sz,xfs_bmbt,bb,i,XFS_BMAP_BROOT_MAXRECS(sz)))
+	(XFS_BTREE_KEY_ADDR(xfs_bmbt,bb,i))
 #define XFS_BMAP_BROOT_PTR_ADDR(bb,i,sz) \
-	(XFS_BTREE_PTR_ADDR(sz,xfs_bmbt,bb,i,XFS_BMAP_BROOT_MAXRECS(sz)))
+	(XFS_BTREE_PTR_ADDR(xfs_bmbt,bb,i,XFS_BMAP_BROOT_MAXRECS(sz)))
 
 #define XFS_BMAP_BROOT_NUMRECS(bb)	be16_to_cpu((bb)->bb_numrecs)
 #define XFS_BMAP_BROOT_MAXRECS(sz)	XFS_BTREE_BLOCK_MAXRECS(sz,xfs_bmbt,0)
Index: xfs-linux-allpatches/xfs_btree.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_btree.h
+++ xfs-linux-allpatches/xfs_btree.h
@@ -122,13 +122,13 @@ extern const __uint32_t	xfs_magics[];
  * Given block size, type prefix, block pointer, and index of requested entry
  * (first entry numbered 1).
  */
-#define	XFS_BTREE_REC_ADDR(bsz,t,bb,i,mxr)	\
+#define	XFS_BTREE_REC_ADDR(t,bb,i)	\
 	((t ## _rec_t *)((char *)(bb) + sizeof(t ## _block_t) + \
 	 ((i) - 1) * sizeof(t ## _rec_t)))
-#define	XFS_BTREE_KEY_ADDR(bsz,t,bb,i,mxr)	\
+#define	XFS_BTREE_KEY_ADDR(t,bb,i)	\
 	((t ## _key_t *)((char *)(bb) + sizeof(t ## _block_t) + \
 	 ((i) - 1) * sizeof(t ## _key_t)))
-#define	XFS_BTREE_PTR_ADDR(bsz,t,bb,i,mxr)	\
+#define	XFS_BTREE_PTR_ADDR(t,bb,i,mxr)	\
 	((t ## _ptr_t *)((char *)(bb) + sizeof(t ## _block_t) + \
 	 (mxr) * sizeof(t ## _key_t) + ((i) - 1) * sizeof(t ## _ptr_t)))
 
Index: xfs-linux-allpatches/xfs_fsops.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_fsops.c
+++ xfs-linux-allpatches/xfs_fsops.c
@@ -250,8 +250,7 @@ xfs_growfs_data_private(
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		arec = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_alloc,
-			block, 1, mp->m_alloc_mxr[0]);
+		arec = XFS_BTREE_REC_ADDR(xfs_alloc, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
@@ -272,8 +271,7 @@ xfs_growfs_data_private(
 		block->bb_numrecs = cpu_to_be16(1);
 		block->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		block->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-		arec = XFS_BTREE_REC_ADDR(mp->m_sb.sb_blocksize, xfs_alloc,
-			block, 1, mp->m_alloc_mxr[0]);
+		arec = XFS_BTREE_REC_ADDR(xfs_alloc, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		arec->ar_blockcount = cpu_to_be32(
 			agsize - be32_to_cpu(arec->ar_startblock));
Index: xfs-linux-allpatches/xfs_ialloc_btree.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_ialloc_btree.h
+++ xfs-linux-allpatches/xfs_ialloc_btree.h
@@ -89,7 +89,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 /*
  * Real block structures have a size equal to the disk block size.
  */
-#define	XFS_INOBT_BLOCK_SIZE(lev,cur)	(1 << (cur)->bc_blocklog)
 #define	XFS_INOBT_BLOCK_MAXRECS(lev,cur) ((cur)->bc_mp->m_inobt_mxr[lev != 0])
 #define	XFS_INOBT_BLOCK_MINRECS(lev,cur) ((cur)->bc_mp->m_inobt_mnr[lev != 0])
 #define	XFS_INOBT_IS_LAST_REC(cur)	\
@@ -110,14 +109,13 @@ typedef	struct xfs_btree_sblock xfs_inob
  * Record, key, and pointer address macros for btree blocks.
  */
 #define XFS_INOBT_REC_ADDR(bb,i,cur) \
-	(XFS_BTREE_REC_ADDR(XFS_INOBT_BLOCK_SIZE(0,cur), xfs_inobt, bb, \
-				i, XFS_INOBT_BLOCK_MAXRECS(0, cur)))
+	(XFS_BTREE_REC_ADDR(xfs_inobt, bb, i))
+
 #define	XFS_INOBT_KEY_ADDR(bb,i,cur) \
-	(XFS_BTREE_KEY_ADDR(XFS_INOBT_BLOCK_SIZE(1,cur), xfs_inobt, bb, \
-				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
+	(XFS_BTREE_KEY_ADDR(xfs_inobt, bb, i))
 
 #define	XFS_INOBT_PTR_ADDR(bb,i,cur) \
-	(XFS_BTREE_PTR_ADDR(XFS_INOBT_BLOCK_SIZE(1,cur), xfs_inobt, bb, \
+	(XFS_BTREE_PTR_ADDR(xfs_inobt, bb, \
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
 /*
Index: xfs-linux-allpatches/xfsidbg.c
===================================================================
--- xfs-linux-allpatches.orig/xfsidbg.c
+++ xfs-linux-allpatches/xfsidbg.c
@@ -3227,7 +3227,7 @@ xfs_btalloc(xfs_alloc_block_t *bt, int b
 		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
 			xfs_alloc_rec_t *r;
 
-			r = XFS_BTREE_REC_ADDR(bsz, xfs_alloc, bt, i, 0);
+			r = XFS_BTREE_REC_ADDR(xfs_alloc, bt, i);
 			kdb_printf("rec %d startblock 0x%x blockcount %d\n",
 				i,
 				be32_to_cpu(r->ar_startblock),
@@ -3241,8 +3241,8 @@ xfs_btalloc(xfs_alloc_block_t *bt, int b
 			xfs_alloc_key_t *k;
 			xfs_alloc_ptr_t *p;
 
-			k = XFS_BTREE_KEY_ADDR(bsz, xfs_alloc, bt, i, mxr);
-			p = XFS_BTREE_PTR_ADDR(bsz, xfs_alloc, bt, i, mxr);
+			k = XFS_BTREE_KEY_ADDR(xfs_alloc, bt, i);
+			p = XFS_BTREE_PTR_ADDR(xfs_alloc, bt, i, mxr);
 			kdb_printf("key %d startblock 0x%x blockcount %d ptr 0x%x\n",
 				i,
 				be32_to_cpu(k->ar_startblock),
@@ -3271,8 +3271,7 @@ xfs_btbmap(xfs_bmbt_block_t *bt, int bsz
 			xfs_bmbt_rec_t *r;
 			xfs_bmbt_irec_t	irec;
 
-			r = (xfs_bmbt_rec_t *)XFS_BTREE_REC_ADDR(bsz,
-				xfs_bmbt, bt, i, 0);
+			r = (xfs_bmbt_rec_t *)XFS_BTREE_REC_ADDR(xfs_bmbt, bt, i);
 
 			xfs_bmbt_disk_get_all((xfs_bmbt_rec_t *)r, &irec);
 			kdb_printf("rec %d startoff %Ld startblock %Lx blockcount %Ld flag %d\n",
@@ -3288,8 +3287,8 @@ xfs_btbmap(xfs_bmbt_block_t *bt, int bsz
 			xfs_bmbt_key_t *k;
 			xfs_bmbt_ptr_t *p;
 
-			k = XFS_BTREE_KEY_ADDR(bsz, xfs_bmbt, bt, i, mxr);
-			p = XFS_BTREE_PTR_ADDR(bsz, xfs_bmbt, bt, i, mxr);
+			k = XFS_BTREE_KEY_ADDR(xfs_bmbt, bt, i);
+			p = XFS_BTREE_PTR_ADDR(xfs_bmbt, bt, i, mxr);
 			kdb_printf("key %d startoff %Ld ", i,
 				(unsigned long long)INT_GET(k->br_startoff, ARCH_CONVERT));
 			kdb_printf("ptr %Lx\n",
@@ -3316,7 +3315,7 @@ xfs_btino(xfs_inobt_block_t *bt, int bsz
 		for (i = 1; i <= be16_to_cpu(bt->bb_numrecs); i++) {
 			xfs_inobt_rec_t *r;
 
-			r = XFS_BTREE_REC_ADDR(bsz, xfs_inobt, bt, i, 0);
+			r = XFS_BTREE_REC_ADDR(xfs_inobt, bt, i);
 			kdb_printf("rec %d startino 0x%x freecount %d, free %Lx\n",
 				i, INT_GET(r->ir_startino, ARCH_CONVERT),
 				INT_GET(r->ir_freecount, ARCH_CONVERT),
@@ -3330,8 +3329,8 @@ xfs_btino(xfs_inobt_block_t *bt, int bsz
 			xfs_inobt_key_t *k;
 			xfs_inobt_ptr_t *p;
 
-			k = XFS_BTREE_KEY_ADDR(bsz, xfs_inobt, bt, i, mxr);
-			p = XFS_BTREE_PTR_ADDR(bsz, xfs_inobt, bt, i, mxr);
+			k = XFS_BTREE_KEY_ADDR(xfs_inobt, bt, i);
+			p = XFS_BTREE_PTR_ADDR(xfs_inobt, bt, i, mxr);
 			kdb_printf("key %d startino 0x%x ptr 0x%x\n",
 				i, INT_GET(k->ir_startino, ARCH_CONVERT),
 				be32_to_cpu(*p));
