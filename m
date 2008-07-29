Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJT7UH031298
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:07 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C0F333F1E1
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id vepgEF1feBeJJ0PC for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:17 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUGIF019179
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:17 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUGXu019177
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:16 +0200
Date: Tue, 29 Jul 2008 21:30:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/21] make btree root in inode support generic
Message-ID: <20080729193016.GD19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-generic-inode-root-support
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The bmap btree is rooted in the inode and not in a single disk block.  Make
the support for this feature more generic by:

 (a) adding a btree flag to check for instead of the XFS_BTNUM_BMAP type
 (b) add a get_root_from_inode btree operation to get a btree block from
     the inode, with the implementation details left to the individual btree.

Also clean up xfs_btree_get_block, which is the place these two features
are used.

The XFS_BTREE_ROOT_IN_INODE is based upon a patch from Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-08 20:05:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-08 20:41:49.000000000 +0200
@@ -2630,8 +2630,19 @@ xfs_bmbt_dup_cursor(
 	return new;
 }
 
+STATIC struct xfs_btree_block *
+xfs_bmbt_get_root_from_inode(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_ifork	*ifp;
+
+	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+	return (struct xfs_btree_block *)ifp->if_broot;
+}
+
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
+	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
 };
 
 /*
@@ -2656,6 +2667,7 @@ xfs_bmbt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_bmbt_ops;
+	cur->bc_flags = XFS_BTREE_ROOT_IN_INODE;
 
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-08 20:05:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-08 20:42:43.000000000 +0200
@@ -425,29 +425,20 @@ xfs_btree_dup_cursor(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be a bmap btree root or from a buffer.
  */
-STATIC xfs_btree_block_t *		/* generic btree block pointer */
+STATIC struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
-	xfs_buf_t		**bpp)	/* buffer containing the block */
+	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	xfs_btree_block_t	*block;	/* return value */
-	xfs_buf_t		*bp;	/* return buffer */
-	xfs_ifork_t		*ifp;	/* inode fork pointer */
-	int			whichfork; /* data or attr fork */
-
-	if (cur->bc_btnum == XFS_BTNUM_BMAP && level == cur->bc_nlevels - 1) {
-		whichfork = cur->bc_private.b.whichfork;
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, whichfork);
-		block = (xfs_btree_block_t *)ifp->if_broot;
-		bp = NULL;
-	} else {
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_BLOCK(bp);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1)) {
+		*bpp = NULL;
+		return cur->bc_ops->get_root_from_inode(cur);
 	}
-	ASSERT(block != NULL);
-	*bpp = bp;
-	return block;
+
+	*bpp = cur->bc_bufs[level];
+	return XFS_BUF_TO_BLOCK(*bpp);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-08 20:06:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-08 20:41:49.000000000 +0200
@@ -164,6 +164,9 @@ extern const __uint32_t	xfs_magics[];
 struct xfs_btree_ops {
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
+
+	/* get inode rooted btree root */
+	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
 };
 
 /*
@@ -175,6 +178,7 @@ typedef struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
+	uint			bc_flags; /* btree features - below */
 	union {
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
@@ -206,6 +210,10 @@ typedef struct xfs_btree_cur
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
 
+/* cursor flags */
+#define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
+
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 

-- 
