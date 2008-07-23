Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:07:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK7KWT015445
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:07:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60F05E8E5DF
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:30 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id bizUDCjcyDDRyy0m for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:30 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NK8KNg007430
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:08:20 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NK8KLV007428
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 22:08:20 +0200
Date: Wed, 23 Jul 2008 22:08:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/15] small cleanups in xfs_btree.c
Message-ID: <20080723200820.GB7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-cleanup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - remove unneeded xfs_btree_get_block forward declaration
 - move xfs_btree_firstrec next to xfs_btree_lastrec


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-06 16:08:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-06 16:12:13.000000000 +0200
@@ -46,38 +46,11 @@ kmem_zone_t	*xfs_btree_cur_zone;
 /*
  * Btree magic numbers.
  */
-const __uint32_t xfs_magics[XFS_BTNUM_MAX] =
-{
+const __uint32_t xfs_magics[XFS_BTNUM_MAX] = {
 	XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC
 };
 
 /*
- * Prototypes for internal routines.
- */
-
-/*
- * Checking routine: return maxrecs for the block.
- */
-STATIC int				/* number of records fitting in block */
-xfs_btree_maxrecs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block);/* generic btree block pointer */
-
-/*
- * Internal routines.
- */
-
-/*
- * Retrieve the block pointer from the cursor at the given level.
- * This may be a bmap btree root or from a buffer.
- */
-STATIC xfs_btree_block_t *			/* generic btree block pointer */
-xfs_btree_get_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree */
-	struct xfs_buf		**bpp);	/* buffer containing the block */
-
-/*
  * Checking routine: return maxrecs for the block.
  */
 STATIC int				/* number of records fitting in block */
@@ -457,35 +430,6 @@ xfs_btree_dup_cursor(
 }
 
 /*
- * Change the cursor to point to the first record at the given level.
- * Other levels are unaffected.
- */
-int					/* success=1, failure=0 */
-xfs_btree_firstrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level)	/* level to change */
-{
-	xfs_btree_block_t	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
-
-	/*
-	 * Get the block pointer for this level.
-	 */
-	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
-	/*
-	 * It's empty, there is no such record.
-	 */
-	if (!block->bb_h.bb_numrecs)
-		return 0;
-	/*
-	 * Set the ptr value to 1, that's the first record/key.
-	 */
-	cur->bc_ptrs[level] = 1;
-	return 1;
-}
-
-/*
  * Retrieve the block pointer from the cursor at the given level.
  * This may be a bmap btree root or from a buffer.
  */
@@ -671,6 +615,35 @@ xfs_btree_islastblock(
 }
 
 /*
+ * Change the cursor to point to the first record at the given level.
+ * Other levels are unaffected.
+ */
+int					/* success=1, failure=0 */
+xfs_btree_firstrec(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			level)	/* level to change */
+{
+	xfs_btree_block_t	*block;	/* generic btree block pointer */
+	xfs_buf_t		*bp;	/* buffer containing block */
+
+	/*
+	 * Get the block pointer for this level.
+	 */
+	block = xfs_btree_get_block(cur, level, &bp);
+	xfs_btree_check_block(cur, block, level, bp);
+	/*
+	 * It's empty, there is no such record.
+	 */
+	if (!block->bb_h.bb_numrecs)
+		return 0;
+	/*
+	 * Set the ptr value to 1, that's the first record/key.
+	 */
+	cur->bc_ptrs[level] = 1;
+	return 1;
+}
+
+/*
  * Change the cursor to point to the last record in the current block
  * at the given level.  Other levels are unaffected.
  */

-- 
