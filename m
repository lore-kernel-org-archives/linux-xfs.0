Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 17:45:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F0jJcg024264
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:45:20 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 949F6129CD8D
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:49 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jkZsi6oUH0rutLK2 for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:46:49 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F0kmIF012291
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:46:48 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F0kmwn012289
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 02:46:48 +0200
Date: Mon, 15 Sep 2008 02:46:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] cleanup maxrecs calculation
Message-ID: <20080915004648.GD12213@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-maxrecs-cleanup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Clean up the way the maximum and minimum records for the btree blocks are
calculated.  For the alloc and inobt btrees all the values are pre-calculated
in xfs_mount_common, and we switch the current loop around the ugly generic
macros that use cpp token pasting to generate type names to two small helpers
in normal C code.  For the bmbt and bmdr trees these helpers also exist,
but can be called during runtime, too.  Here we also kill various macros
dealing with them and inline the logic into the get_minrecs / get_maxrecs /
get_dmaxrecs methods in xfs_bmap_btree.c.

Note that all these new helpers take an xfs_mount * argument which will
be needed to determine the size of a btree block once we add support for
extended btree blocks with CRCs and other RAS information.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-09-15 02:30:21.000000000 +0200
@@ -567,8 +567,6 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 STATIC void
 xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 {
-	int	i;
-
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
@@ -605,24 +603,20 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	}
 	ASSERT(mp->m_attroffset < XFS_LITINO(mp));
 
-	for (i = 0; i < 2; i++) {
-		mp->m_alloc_mxr[i] = XFS_BTREE_BLOCK_MAXRECS(sbp->sb_blocksize,
-			xfs_alloc, i == 0);
-		mp->m_alloc_mnr[i] = XFS_BTREE_BLOCK_MINRECS(sbp->sb_blocksize,
-			xfs_alloc, i == 0);
-	}
-	for (i = 0; i < 2; i++) {
-		mp->m_bmap_dmxr[i] = XFS_BTREE_BLOCK_MAXRECS(sbp->sb_blocksize,
-			xfs_bmbt, i == 0);
-		mp->m_bmap_dmnr[i] = XFS_BTREE_BLOCK_MINRECS(sbp->sb_blocksize,
-			xfs_bmbt, i == 0);
-	}
-	for (i = 0; i < 2; i++) {
-		mp->m_inobt_mxr[i] = XFS_BTREE_BLOCK_MAXRECS(sbp->sb_blocksize,
-			xfs_inobt, i == 0);
-		mp->m_inobt_mnr[i] = XFS_BTREE_BLOCK_MINRECS(sbp->sb_blocksize,
-			xfs_inobt, i == 0);
-	}
+	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
+	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
+
+	mp->m_inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_inobt_mnr[0] = mp->m_inobt_mxr[0] / 2;
+	mp->m_inobt_mnr[1] = mp->m_inobt_mxr[1] / 2;
+
+	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
+	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
 
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-15 02:30:21.000000000 +0200
@@ -3051,15 +3051,15 @@ xfs_bmap_btree_to_extents(
 	__be64			*pp;	/* ptr to block address */
 	xfs_bmbt_block_t	*rblock;/* root btree block */
 
+	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 	rblock = ifp->if_broot;
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes) == 1);
-	mp = ip->i_mount;
-	pp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, ifp->if_broot_bytes);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 	*logflagsp = 0;
 #ifdef DEBUG
@@ -4221,7 +4221,7 @@ xfs_bmap_compute_maxlevels(
 		maxleafents = MAXAEXTNUM;
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	}
-	maxrootrecs = (int)XFS_BTREE_BLOCK_MAXRECS(sz, xfs_bmdr, 0);
+	maxrootrecs = xfs_bmdr_maxrecs(mp, sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
 	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
@@ -4555,7 +4555,7 @@ xfs_bmap_read_extents(
 	 */
 	level = be16_to_cpu(block->bb_level);
 	ASSERT(level > 0);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(block, 1, ifp->if_broot_bytes);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 	ASSERT(bno != NULLDFSBNO);
 	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
@@ -6205,13 +6205,13 @@ xfs_check_block(
 		 */
 
 		if (root) {
-			pp = XFS_BMAP_BROOT_PTR_ADDR(block, i, sz);
+			pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, i, sz);
 		} else {
 			pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, i, dmxr);
 		}
 		for (j = i+1; j <= be16_to_cpu(block->bb_numrecs); j++) {
 			if (root) {
-				thispa = XFS_BMAP_BROOT_PTR_ADDR(block, j, sz);
+				thispa = XFS_BMAP_BROOT_PTR_ADDR(mp, block, j, sz);
 			} else {
 				thispa = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, j,
 							    dmxr);
@@ -6266,7 +6266,7 @@ xfs_bmap_check_leaf_extents(
 	level = be16_to_cpu(block->bb_level);
 	ASSERT(level > 0);
 	xfs_check_block(block, mp, 1, ifp->if_broot_bytes);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(block, 1, ifp->if_broot_bytes);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
 	ASSERT(bno != NULLDFSBNO);
@@ -6426,7 +6426,7 @@ xfs_bmap_count_blocks(
 	block = ifp->if_broot;
 	level = be16_to_cpu(block->bb_level);
 	ASSERT(level > 0);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(block, 1, ifp->if_broot_bytes);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 	ASSERT(bno != NULLDFSBNO);
 	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-09-15 02:30:21.000000000 +0200
@@ -66,6 +66,7 @@ xfs_extent_state(
  */
 void
 xfs_bmdr_to_bmbt(
+	struct xfs_mount	*mp,
 	xfs_bmdr_block_t	*dblock,
 	int			dblocklen,
 	xfs_bmbt_block_t	*rblock,
@@ -83,11 +84,11 @@ xfs_bmdr_to_bmbt(
 	rblock->bb_numrecs = dblock->bb_numrecs;
 	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
 	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
-	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
+	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
 	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
 	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
 	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
-	tpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
@@ -428,6 +429,7 @@ xfs_bmbt_set_state(
  */
 void
 xfs_bmbt_to_bmdr(
+	struct xfs_mount	*mp,
 	xfs_bmbt_block_t	*rblock,
 	int			rblocklen,
 	xfs_bmdr_block_t	*dblock,
@@ -445,10 +447,10 @@ xfs_bmbt_to_bmdr(
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
-	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
+	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
 	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
 	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
-	fpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
 	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
@@ -626,15 +628,36 @@ xfs_bmbt_get_minrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	return XFS_BMAP_BLOCK_IMINRECS(level, cur);
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp;
+
+		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
+				    cur->bc_private.b.whichfork);
+
+		return xfs_bmbt_maxrecs(cur->bc_mp,
+					ifp->if_broot_bytes, level == 0) / 2;
+	}
+
+	return cur->bc_mp->m_bmap_dmnr[level != 0];
 }
 
-STATIC int
+int
 xfs_bmbt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	return XFS_BMAP_BLOCK_IMAXRECS(level, cur);
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp;
+
+		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
+				    cur->bc_private.b.whichfork);
+
+		return xfs_bmbt_maxrecs(cur->bc_mp,
+					ifp->if_broot_bytes, level == 0);
+	}
+
+	return cur->bc_mp->m_bmap_dmxr[level != 0];
+
 }
 
 /*
@@ -651,7 +674,10 @@ xfs_bmbt_get_dmaxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
-	return XFS_BMAP_BLOCK_DMAXRECS(level, cur);
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_bmap_dmxr[level != 0];
+	return xfs_bmdr_maxrecs(cur->bc_mp, cur->bc_private.b.forksize,
+				level == 0);
 }
 
 STATIC void
@@ -871,3 +897,35 @@ xfs_bmbt_init_cursor(
 
 	return cur;
 }
+
+/*
+ * Calculate number of records in a bmap btree block.
+ */
+int
+xfs_bmbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= sizeof(struct xfs_btree_lblock);
+
+	if (leaf)
+		return blocklen / sizeof(xfs_bmbt_rec_t);
+	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
+}
+
+/*
+ * Calculate number of records in a bmap btree inode root.
+ */
+int
+xfs_bmdr_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= sizeof(xfs_bmdr_block_t);
+
+	if (leaf)
+		return blocklen / sizeof(xfs_bmdr_rec_t);
+	return blocklen / (sizeof(xfs_bmdr_key_t) + sizeof(xfs_bmdr_ptr_t));
+}
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:30:21.000000000 +0200
@@ -151,33 +151,6 @@ typedef struct xfs_btree_lblock xfs_bmbt
 
 #define XFS_BUF_TO_BMBT_BLOCK(bp)	((xfs_bmbt_block_t *)XFS_BUF_PTR(bp))
 
-#define XFS_BMAP_RBLOCK_DSIZE(lev,cur)	((cur)->bc_private.b.forksize)
-#define XFS_BMAP_RBLOCK_ISIZE(lev,cur)	\
-	((int)XFS_IFORK_PTR((cur)->bc_private.b.ip, \
-		    (cur)->bc_private.b.whichfork)->if_broot_bytes)
-
-#define XFS_BMAP_BLOCK_DMAXRECS(lev,cur) \
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-		XFS_BTREE_BLOCK_MAXRECS(XFS_BMAP_RBLOCK_DSIZE(lev,cur), \
-			xfs_bmdr, (lev) == 0) : \
-		((cur)->bc_mp->m_bmap_dmxr[(lev) != 0])))
-#define XFS_BMAP_BLOCK_IMAXRECS(lev,cur) \
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-			XFS_BTREE_BLOCK_MAXRECS(XFS_BMAP_RBLOCK_ISIZE(lev,cur),\
-				xfs_bmbt, (lev) == 0) : \
-			((cur)->bc_mp->m_bmap_dmxr[(lev) != 0])))
-
-#define XFS_BMAP_BLOCK_DMINRECS(lev,cur) \
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-			XFS_BTREE_BLOCK_MINRECS(XFS_BMAP_RBLOCK_DSIZE(lev,cur),\
-				xfs_bmdr, (lev) == 0) : \
-			((cur)->bc_mp->m_bmap_dmnr[(lev) != 0])))
-#define XFS_BMAP_BLOCK_IMINRECS(lev,cur) \
-	(((lev) == (cur)->bc_nlevels - 1 ? \
-			XFS_BTREE_BLOCK_MINRECS(XFS_BMAP_RBLOCK_ISIZE(lev,cur),\
-				xfs_bmbt, (lev) == 0) : \
-			((cur)->bc_mp->m_bmap_dmnr[(lev) != 0])))
-
 #define XFS_BMAP_REC_DADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
 
 #define XFS_BMAP_REC_IADDR(bb,i,cur)	(XFS_BTREE_REC_ADDR(xfs_bmbt, bb, i))
@@ -192,8 +165,8 @@ typedef struct xfs_btree_lblock xfs_bmbt
 	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, XFS_BMAP_BLOCK_DMAXRECS(	\
 				be16_to_cpu((bb)->bb_level), cur)))
 #define XFS_BMAP_PTR_IADDR(bb,i,cur)	\
-	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, XFS_BMAP_BLOCK_IMAXRECS(	\
-				be16_to_cpu((bb)->bb_level), cur)))
+	(XFS_BTREE_PTR_ADDR(xfs_bmbt, bb, i, xfs_bmbt_get_maxrecs(cur,	\
+				be16_to_cpu((bb)->bb_level))))
 
 /*
  * These are to be used when we know the size of the block and
@@ -203,11 +176,8 @@ typedef struct xfs_btree_lblock xfs_bmbt
 	(XFS_BTREE_REC_ADDR(xfs_bmbt,bb,i))
 #define XFS_BMAP_BROOT_KEY_ADDR(bb,i,sz) \
 	(XFS_BTREE_KEY_ADDR(xfs_bmbt,bb,i))
-#define XFS_BMAP_BROOT_PTR_ADDR(bb,i,sz) \
-	(XFS_BTREE_PTR_ADDR(xfs_bmbt,bb,i,XFS_BMAP_BROOT_MAXRECS(sz)))
-
-#define XFS_BMAP_BROOT_NUMRECS(bb)	be16_to_cpu((bb)->bb_numrecs)
-#define XFS_BMAP_BROOT_MAXRECS(sz)	XFS_BTREE_BLOCK_MAXRECS(sz,xfs_bmbt,0)
+#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb,i,sz) \
+	(XFS_BTREE_PTR_ADDR(xfs_bmbt,bb,i,xfs_bmbt_maxrecs(mp, sz, 0)))
 
 #define XFS_BMAP_BROOT_SPACE_CALC(nrecs) \
 	(int)(sizeof(xfs_bmbt_block_t) + \
@@ -234,7 +204,8 @@ typedef struct xfs_btree_lblock xfs_bmbt
 /*
  * Prototypes for xfs_bmap.c to call.
  */
-extern void xfs_bmdr_to_bmbt(xfs_bmdr_block_t *, int, xfs_bmbt_block_t *, int);
+extern void xfs_bmdr_to_bmbt(struct xfs_mount *, xfs_bmdr_block_t *, int,
+			xfs_bmbt_block_t *, int);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
@@ -257,7 +228,12 @@ extern void xfs_bmbt_disk_set_all(xfs_bm
 extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
-extern void xfs_bmbt_to_bmdr(xfs_bmbt_block_t *, int, xfs_bmdr_block_t *, int);
+extern void xfs_bmbt_to_bmdr(struct xfs_mount *, xfs_bmbt_block_t *, int,
+			xfs_bmdr_block_t *, int);
+
+extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
+extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
+extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-09-15 02:30:21.000000000 +0200
@@ -78,8 +78,7 @@ typedef struct xfs_dinode
 	xfs_dinode_core_t	di_core;
 	/*
 	 * In adding anything between the core and the union, be
-	 * sure to update the macros like XFS_LITINO below and
-	 * XFS_BMAP_RBLOCK_DSIZE in xfs_bmap_btree.h.
+	 * sure to update the macros like XFS_LITINO below.
 	 */
 	__be32			di_next_unlinked;/* agi unlinked list ptr */
 	union {
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-09-15 02:30:21.000000000 +0200
@@ -56,12 +56,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 #define	XFS_BUF_TO_ALLOC_BLOCK(bp)	((xfs_alloc_block_t *)XFS_BUF_PTR(bp))
 
 /*
- * Real block structures have a size equal to the disk block size.
- */
-#define	XFS_ALLOC_BLOCK_MAXRECS(lev,cur) ((cur)->bc_mp->m_alloc_mxr[lev != 0])
-#define	XFS_ALLOC_BLOCK_MINRECS(lev,cur) ((cur)->bc_mp->m_alloc_mnr[lev != 0])
-
-/*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
  * The sectorsize upper limit is due to sizeof(sb_sectsize).
@@ -98,5 +92,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
+extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-09-15 02:30:21.000000000 +0200
@@ -85,14 +85,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 #define	XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
 
 /*
- * Real block structures have a size equal to the disk block size.
- */
-#define	XFS_INOBT_BLOCK_MAXRECS(lev,cur) ((cur)->bc_mp->m_inobt_mxr[lev != 0])
-#define	XFS_INOBT_BLOCK_MINRECS(lev,cur) ((cur)->bc_mp->m_inobt_mnr[lev != 0])
-#define	XFS_INOBT_IS_LAST_REC(cur)	\
-	((cur)->bc_ptrs[0] == be16_to_cpu(XFS_BUF_TO_INOBT_BLOCK((cur)->bc_bufs[0])->bb_numrecs))
-
-/*
  * Maximum number of inode btree levels.
  */
 #define	XFS_IN_MAXLEVELS(mp)		((mp)->m_in_maxlevels)
@@ -118,5 +110,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
+extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-15 02:30:21.000000000 +0200
@@ -622,7 +622,7 @@ xfs_iformat_btree(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	size = XFS_BMAP_BROOT_SPACE(dfp);
-	nrecs = XFS_BMAP_BROOT_NUMRECS(dfp);
+	nrecs = be16_to_cpu(dfp->bb_numrecs);
 
 	/*
 	 * blow out if -- fork has less extents than can fit in
@@ -650,7 +650,8 @@ xfs_iformat_btree(
 	 * Copy and convert from the on-disk structure
 	 * to the in-memory structure.
 	 */
-	xfs_bmdr_to_bmbt(dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
+	xfs_bmdr_to_bmbt(ip->i_mount, dfp,
+			 XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
 		ifp->if_broot, size);
 	ifp->if_flags &= ~XFS_IFEXTENTS;
 	ifp->if_flags |= XFS_IFBROOT;
@@ -2348,6 +2349,7 @@ xfs_iroot_realloc(
 	int			rec_diff,
 	int			whichfork)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	int			cur_max;
 	xfs_ifork_t		*ifp;
 	xfs_bmbt_block_t	*new_broot;
@@ -2383,7 +2385,7 @@ xfs_iroot_realloc(
 		 * location.  The records don't change location because
 		 * they are kept butted up against the btree block header.
 		 */
-		cur_max = XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes);
+		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
 		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
 		ifp->if_broot = (xfs_bmbt_block_t *)
@@ -2391,10 +2393,10 @@ xfs_iroot_realloc(
 				new_size,
 				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
 				KM_SLEEP);
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(ifp->if_broot, 1,
-						      ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(ifp->if_broot, 1,
-						      (int)new_size);
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     ifp->if_broot_bytes);
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(ifp->if_broot_bytes <=
 			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
@@ -2408,7 +2410,7 @@ xfs_iroot_realloc(
 	 * records, just get rid of the root and clear the status bit.
 	 */
 	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes);
+	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
@@ -2442,9 +2444,9 @@ xfs_iroot_realloc(
 		/*
 		 * Then copy the pointers.
 		 */
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(ifp->if_broot, 1,
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(new_broot, 1,
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
 						     (int)new_size);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_dfsbno_t));
 	}
@@ -2920,7 +2922,7 @@ xfs_iflush_fork(
 			ASSERT(ifp->if_broot_bytes <=
 			       (XFS_IFORK_SIZE(ip, whichfork) +
 				XFS_BROOT_SIZE_ADJ));
-			xfs_bmbt_to_bmdr(ifp->if_broot, ifp->if_broot_bytes,
+			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
 				XFS_DFORK_SIZE(dip, mp, whichfork));
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-09-15 02:30:21.000000000 +0200
@@ -275,12 +275,12 @@ typedef struct xfs_mount {
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
-	uint			m_alloc_mxr[2];	/* XFS_ALLOC_BLOCK_MAXRECS */
-	uint			m_alloc_mnr[2];	/* XFS_ALLOC_BLOCK_MINRECS */
-	uint			m_bmap_dmxr[2];	/* XFS_BMAP_BLOCK_DMAXRECS */
-	uint			m_bmap_dmnr[2];	/* XFS_BMAP_BLOCK_DMINRECS */
-	uint			m_inobt_mxr[2];	/* XFS_INOBT_BLOCK_MAXRECS */
-	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
+	uint			m_alloc_mxr[2];	/* max alloc btree records */
+	uint			m_alloc_mnr[2];	/* min alloc btree records */
+	uint			m_bmap_dmxr[2];	/* max bmap btree records */
+	uint			m_bmap_dmnr[2];	/* min bmap btree records */
+	uint			m_inobt_mxr[2];	/* max inobt btree records */
+	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-09-15 02:30:21.000000000 +0200
@@ -148,19 +148,6 @@ do {    \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
-/*
- * Maximum and minimum records in a btree block.
- * Given block size, type prefix, and leaf flag (0 or 1).
- * The divisor below is equivalent to lf ? (e1) : (e2) but that produces
- * compiler warnings.
- */
-#define	XFS_BTREE_BLOCK_MAXRECS(bsz,t,lf)	\
-	((int)(((bsz) - (uint)sizeof(t ## _block_t)) / \
-	 (((lf) * (uint)sizeof(t ## _rec_t)) + \
-	  ((1 - (lf)) * \
-	   ((uint)sizeof(t ## _key_t) + (uint)sizeof(t ## _ptr_t))))))
-#define	XFS_BTREE_BLOCK_MINRECS(bsz,t,lf)	\
-	(XFS_BTREE_BLOCK_MAXRECS(bsz,t,lf) / 2)
 
 /*
  * Record, key, and pointer address calculation macros.
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-09-15 02:30:21.000000000 +0200
@@ -480,3 +480,19 @@ xfs_allocbt_init_cursor(
 
 	return cur;
 }
+
+/*
+ * Calculate number of records in an alloc btree block.
+ */
+int
+xfs_allocbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= sizeof(struct xfs_btree_sblock);
+
+	if (leaf)
+		return blocklen / sizeof(xfs_alloc_rec_t);
+	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
+}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-09-15 02:30:21.000000000 +0200
@@ -365,3 +365,19 @@ xfs_inobt_init_cursor(
 
 	return cur;
 }
+
+/*
+ * Calculate number of records in an inobt btree block.
+ */
+int
+xfs_inobt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= sizeof(struct xfs_btree_sblock);
+
+	if (leaf)
+		return blocklen / sizeof(xfs_inobt_rec_t);
+	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
+}
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-15 02:26:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-15 02:30:21.000000000 +0200
@@ -2452,7 +2452,7 @@ xlog_recover_do_inode_trans(
 		break;
 
 	case XFS_ILOG_DBROOT:
-		xfs_bmbt_to_bmdr((xfs_bmbt_block_t *)src, len,
+		xfs_bmbt_to_bmdr(mp, (xfs_bmbt_block_t *)src, len,
 				 &(dip->di_u.di_bmbt),
 				 XFS_DFORK_DSIZE(dip, mp));
 		break;
@@ -2490,7 +2490,7 @@ xlog_recover_do_inode_trans(
 
 		case XFS_ILOG_ABROOT:
 			dest = XFS_DFORK_APTR(dip);
-			xfs_bmbt_to_bmdr((xfs_bmbt_block_t *)src, len,
+			xfs_bmbt_to_bmdr(mp, (xfs_bmbt_block_t *)src, len,
 					 (xfs_bmdr_block_t*)dest,
 					 XFS_DFORK_ASIZE(dip, mp));
 			break;

-- 
