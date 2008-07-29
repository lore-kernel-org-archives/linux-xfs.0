Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTAeQ031347
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08741ECE21B
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cNF4xOpmTwDKC3CY for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUNIF019191
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:23 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUNSd019189
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:23 +0200
Date: Tue, 29 Jul 2008 21:30:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/21] add a long pointers flag to xfs_btree_cur
Message-ID: <20080729193023.GE19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-long-flag
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add a flag to the xfs btree cursor when using long (64bit) block pointers
instead of checking btnum == XFS_BTNUM_BMAP.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-11 11:12:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-11 11:13:15.000000000 +0200
@@ -90,7 +90,7 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	xfs_buf_t		*bp)	/* buffer containing block, if any */
 {
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		xfs_btree_check_lblock(cur, (xfs_btree_lblock_t *)block, level,
 			bp);
 	else
@@ -500,7 +500,7 @@ xfs_btree_islastblock(
 
 	block = xfs_btree_get_block(cur, level, &bp);
 	xfs_btree_check_block(cur, block, level, bp);
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO;
 	else
 		return be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK;
@@ -792,7 +792,7 @@ xfs_btree_setbuf(
 	if (!bp)
 		return;
 	b = XFS_BUF_TO_BLOCK(bp);
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum)) {
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(b->bb_u.l.bb_leftsib) == NULLDFSBNO)
 			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
 		if (be64_to_cpu(b->bb_u.l.bb_rightsib) == NULLDFSBNO)
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-11 11:12:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-11 11:13:15.000000000 +0200
@@ -121,11 +121,6 @@ union xfs_btree_rec {
 #define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
 
 /*
- * Boolean to select which form of xfs_btree_block_t.bb_u to use.
- */
-#define	XFS_BTREE_LONG_PTRS(btnum)	((btnum) == XFS_BTNUM_BMAP)
-
-/*
  * Magic numbers for btree blocks.
  */
 extern const __uint32_t	xfs_magics[];
@@ -211,6 +206,7 @@ typedef struct xfs_btree_cur
 } xfs_btree_cur_t;
 
 /* cursor flags */
+#define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-11 11:12:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-11 11:13:15.000000000 +0200
@@ -2667,7 +2667,7 @@ xfs_bmbt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_bmbt_ops;
-	cur->bc_flags = XFS_BTREE_ROOT_IN_INODE;
+	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;

-- 
