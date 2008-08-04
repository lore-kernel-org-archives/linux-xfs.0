Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:33:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741XLFO032251
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:33:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9359D1976448
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:34:34 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jmuM2grRkgb4HdxB for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:34:34 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741YaIF009168
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:34:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741YafG009166
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:34:36 +0200
Date: Mon, 4 Aug 2008 03:34:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/26] add get_maxrecs btree operation
Message-ID: <20080804013436.GP8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-get_maxrecs-method
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Factor xfs_btree_maxrecs into a per-btree operation.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-02 04:08:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-02 04:08:43.000000000 +0200
@@ -52,31 +52,6 @@ const __uint32_t xfs_magics[XFS_BTNUM_MA
 };
 
 /*
- * Checking routine: return maxrecs for the block.
- */
-STATIC int				/* number of records fitting in block */
-xfs_btree_maxrecs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block)	/* generic btree block pointer */
-{
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		return (int)XFS_ALLOC_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_level), cur);
-	case XFS_BTNUM_BMAP:
-		return (int)XFS_BMAP_BLOCK_IMAXRECS(
-				be16_to_cpu(block->bb_level), cur);
-	case XFS_BTNUM_INO:
-		return (int)XFS_INOBT_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_level), cur);
-	default:
-		ASSERT(0);
-		return 0;
-	}
-}
-
-/*
  * External routines.
  */
 
@@ -208,7 +183,7 @@ xfs_btree_check_lblock(
 		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
+			cur->bc_ops->get_maxrecs(cur, level) &&
 		block->bb_leftsib &&
 		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
 		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
@@ -245,7 +220,7 @@ xfs_btree_check_sblock(
 		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
+			cur->bc_ops->get_maxrecs(cur, level) &&
 		(be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK ||
 		 be32_to_cpu(block->bb_leftsib) < agflen) &&
 		block->bb_leftsib &&
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-02 04:08:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-02 04:08:43.000000000 +0200
@@ -200,6 +200,9 @@ struct xfs_btree_ops {
 	union xfs_btree_rec *(*rec_addr)(struct xfs_btree_cur *cur, int index,
 					 struct xfs_btree_block *block);
 
+	/* records in block/level */
+	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
+
 	/* init values of btree structures */
 	void	(*init_key_from_rec)(struct xfs_btree_cur *cur,
 				     union xfs_btree_key *key,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-02 04:08:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-02 04:08:43.000000000 +0200
@@ -1655,6 +1655,14 @@ xfs_allocbt_update_lastrec(
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
+STATIC int
+xfs_allocbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_alloc_mxr[level != 0];
+}
+
 STATIC void
 xfs_allocbt_init_key_from_rec(
 	struct xfs_btree_cur	*cur,
@@ -1895,6 +1903,7 @@ xfs_allocbt_trace_record(
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
+	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.ptr_addr		= xfs_allocbt_ptr_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-02 04:08:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-02 04:08:43.000000000 +0200
@@ -1955,6 +1955,14 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
+STATIC int
+xfs_bmbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_IMAXRECS(level, cur);
+}
+
 STATIC void
 xfs_bmbt_init_key_from_rec(
 	struct xfs_btree_cur	*cur,
@@ -2179,6 +2187,7 @@ static const struct xfs_btree_ops xfs_bm
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
+	.get_maxrecs		= xfs_bmbt_get_maxrecs,
 	.ptr_addr		= xfs_bmbt_ptr_addr,
 	.key_addr		= xfs_bmbt_key_addr,
 	.rec_addr		= xfs_bmbt_rec_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-02 04:08:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-02 04:08:43.000000000 +0200
@@ -1516,6 +1516,14 @@ xfs_inobt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+STATIC int
+xfs_inobt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_inobt_mxr[level != 0];
+}
+
 STATIC void
 xfs_inobt_init_key_from_rec(
 	struct xfs_btree_cur	*cur,
@@ -1720,6 +1728,7 @@ xfs_inobt_trace_record(
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.ptr_addr		= xfs_inobt_ptr_addr,

-- 
