Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoM4Q153547 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6DA65CC9A
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xWB7hBPQZI2Kobbk for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xE-0002tC-Tk
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:16 +0000
Message-Id: <20110710205016.890382263@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/11] xfs: reshuffle dir2 headers
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dir2-factor-headers
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

Replace the current mess of dir2 headers with just three that have a clear
purpose:

 - xfs_dir2_format.h for all format defintions, including the inline helpers
   to access our variable size structures
 - xfs_dir2_priv.h for all prototypes that are internal to the dir2 code
   and no needed by anything outside of the directory code.  For this
   purpose xfs_da_btree.c, and phase6.c in xfs_repair are considered part
   of the directory code.
 - xfs_dir2.h for the public interface to the directory code

In addition to the reshuffle I have also update the comments to not only
match the new file structure, but also to describe the directory format
better.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-07-09 13:29:18.194918955 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-07-09 13:29:20.434918841 +0200
@@ -29,15 +29,11 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_mount.h"
 #include "xfs_itable.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-07-09 13:29:18.208252287 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-07-09 13:29:20.434918841 +0200
@@ -24,11 +24,12 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
@@ -36,10 +37,6 @@
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
-#include "xfs_dir2_node.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2011-07-09 13:29:18.218252286 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2011-07-09 13:29:20.434918841 +0200
@@ -24,20 +24,17 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
-#include "xfs_dir2_node.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-07-09 13:29:18.231585620 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-07-09 13:29:20.438252174 +0200
@@ -23,17 +23,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-07-09 13:29:18.241585619 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2011-07-09 13:29:20.441585507 +0200
@@ -23,16 +23,13 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 
 STATIC xfs_dir2_data_free_t *
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-09 13:29:18.251585618 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-09 13:29:20.444918840 +0200
@@ -24,18 +24,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
-#include "xfs_dir2_node.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2011-07-09 13:29:18.261585617 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2011-07-09 13:29:20.448252173 +0200
@@ -23,18 +23,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
-#include "xfs_dir2_node.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-07-09 13:29:18.274918951 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-07-09 13:29:20.448252173 +0200
@@ -23,18 +23,16 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_error.h"
-#include "xfs_dir2_data.h"
-#include "xfs_dir2_leaf.h"
-#include "xfs_dir2_block.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 
 /*
Index: xfs/fs/xfs/xfs_dir2.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.h	2011-07-09 13:29:18.284918951 +0200
+++ xfs/fs/xfs/xfs_dir2.h	2011-07-09 13:29:29.221585064 +0200
@@ -16,49 +16,14 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #ifndef __XFS_DIR2_H__
-#define	__XFS_DIR2_H__
+#define __XFS_DIR2_H__
 
-struct uio;
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_dir2_put_args;
 struct xfs_bmap_free;
+struct xfs_da_args;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * Directory version 2.
- * There are 4 possible formats:
- *	shortform
- *	single block - data with embedded leaf at the end
- *	multiple data blocks, single leaf+freeindex block
- *	data blocks, node&leaf blocks (btree), freeindex blocks
- *
- *	The shortform format is in xfs_dir2_sf.h.
- *	The single block format is in xfs_dir2_block.h.
- *	The data block format is in xfs_dir2_data.h.
- *	The leaf and freeindex block formats are in xfs_dir2_leaf.h.
- *	Node blocks are the same as the other version, in xfs_da_btree.h.
- */
-
-/*
- * Byte offset in data block and shortform entry.
- */
-typedef	__uint16_t	xfs_dir2_data_off_t;
-#define	NULLDATAOFF	0xffffU
-typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
-
-/*
- * Directory block number (logical dirblk in file)
- */
-typedef	__uint32_t	xfs_dir2_db_t;
-
-/*
- * Byte offset in a directory.
- */
-typedef	xfs_off_t	xfs_dir2_off_t;
-
 extern struct xfs_name	xfs_name_dotdot;
 
 /*
@@ -86,21 +51,10 @@ extern int xfs_dir_replace(struct xfs_tr
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, uint resblks);
-extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 /*
- * Utility routines for v2 directories.
+ * Direct call from the bmap code, bypassing the generic directory layer.
  */
-extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
-				xfs_dir2_db_t *dbp);
-extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp,
-				int *vp);
-extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp,
-				int *vp);
-extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
-				struct xfs_dabuf *bp);
-
-extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
-				const unsigned char *name, int len);
+extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 
 #endif	/* __XFS_DIR2_H__ */
Index: xfs/fs/xfs/xfs_dir2_block.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.h	2011-07-09 13:29:18.294918950 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,93 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_BLOCK_H__
-#define	__XFS_DIR2_BLOCK_H__
-
-/*
- * Directory version 2, single block format structures.
- *
- * The single block format looks like the following drawing on disk:
- *
- *    +-------------------------------------------------+
- *    | xfs_dir2_data_hdr_t                             |
- *    +-------------------------------------------------+
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | ...                                             |
- *    +-------------------------------------------------+
- *    | unused space                                    |
- *    +-------------------------------------------------+
- *    | ...                                             |
- *    | xfs_dir2_leaf_entry_t                           |
- *    | xfs_dir2_leaf_entry_t                           |
- *    +-------------------------------------------------+
- *    | xfs_dir2_block_tail_t                           |
- *    +-------------------------------------------------+
- *
- * As all the entries are variable size structures the accessors in this
- * file and xfs_dir2_data.h should be used to iterate over them.
- */
-struct uio;
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_dir2_data_hdr;
-struct xfs_dir2_leaf_entry;
-struct xfs_inode;
-struct xfs_mount;
-struct xfs_trans;
-
-#define	XFS_DIR2_BLOCK_MAGIC	0x58443242	/* XD2B: for one block dirs */
-
-typedef struct xfs_dir2_block_tail {
-	__be32		count;			/* count of leaf entries */
-	__be32		stale;			/* count of stale lf entries */
-} xfs_dir2_block_tail_t;
-
-/*
- * Pointer to the leaf header embedded in a data block (1-block format)
- */
-static inline xfs_dir2_block_tail_t *
-xfs_dir2_block_tail_p(struct xfs_mount *mp, xfs_dir2_data_hdr_t *hdr)
-{
-	return ((xfs_dir2_block_tail_t *)((char *)hdr + mp->m_dirblksize)) - 1;
-}
-
-/*
- * Pointer to the leaf entries embedded in a data block (1-block format)
- */
-static inline struct xfs_dir2_leaf_entry *
-xfs_dir2_block_leaf_p(xfs_dir2_block_tail_t *btp)
-{
-	return ((struct xfs_dir2_leaf_entry *)btp) - be32_to_cpu(btp->count);
-}
-
-/*
- * Function declarations.
- */
-extern int xfs_dir2_block_addname(struct xfs_da_args *args);
-extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
-				   xfs_off_t *offset, filldir_t filldir);
-extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
-extern int xfs_dir2_block_removename(struct xfs_da_args *args);
-extern int xfs_dir2_block_replace(struct xfs_da_args *args);
-extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
-				  struct xfs_dabuf *lbp, struct xfs_dabuf *dbp);
-extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
-
-#endif	/* __XFS_DIR2_BLOCK_H__ */
Index: xfs/fs/xfs/xfs_dir2_data.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-07-09 13:29:18.304918949 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,182 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_DATA_H__
-#define	__XFS_DIR2_DATA_H__
-
-/*
- * Directory format 2, data block structures.
- *
- * A pure data block looks like the following drawing on disk:
- *
- *    +-------------------------------------------------+
- *    | xfs_dir2_data_hdr_t                             |
- *    +-------------------------------------------------+
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
- *    | ...                                             |
- *    +-------------------------------------------------+
- *    | unused space                                    |
- *    +-------------------------------------------------+
- *
- * As all the entries are variable size structures the accessors in this
- * file should be used to iterate over them.
- */
-
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_inode;
-struct xfs_trans;
-
-/*
- * Constants.
- */
-#define	XFS_DIR2_DATA_MAGIC	0x58443244	/* XD2D: for multiblock dirs */
-#define	XFS_DIR2_DATA_ALIGN_LOG	3		/* i.e., 8 bytes */
-#define	XFS_DIR2_DATA_ALIGN	(1 << XFS_DIR2_DATA_ALIGN_LOG)
-#define	XFS_DIR2_DATA_FREE_TAG	0xffff
-#define	XFS_DIR2_DATA_FD_COUNT	3
-
-/*
- * Directory address space divided into sections,
- * spaces separated by 32GB.
- */
-#define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
-#define	XFS_DIR2_DATA_SPACE	0
-#define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_DATA_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_DATA_OFFSET)
-
-/*
- * Offsets of . and .. in data space (always block 0)
- */
-#define	XFS_DIR2_DATA_DOT_OFFSET	\
-	((xfs_dir2_data_aoff_t)sizeof(xfs_dir2_data_hdr_t))
-#define	XFS_DIR2_DATA_DOTDOT_OFFSET	\
-	(XFS_DIR2_DATA_DOT_OFFSET + xfs_dir2_data_entsize(1))
-#define	XFS_DIR2_DATA_FIRST_OFFSET		\
-	(XFS_DIR2_DATA_DOTDOT_OFFSET + xfs_dir2_data_entsize(2))
-
-/*
- * Structures.
- */
-
-/*
- * Describe a free area in the data block.
- * The freespace will be formatted as a xfs_dir2_data_unused_t.
- */
-typedef struct xfs_dir2_data_free {
-	__be16			offset;		/* start of freespace */
-	__be16			length;		/* length of freespace */
-} xfs_dir2_data_free_t;
-
-/*
- * Header for the data blocks.
- * Always at the beginning of a directory-sized block.
- * The code knows that XFS_DIR2_DATA_FD_COUNT is 3.
- */
-typedef struct xfs_dir2_data_hdr {
-	__be32			magic;		/* XFS_DIR2_DATA_MAGIC */
-						/* or XFS_DIR2_BLOCK_MAGIC */
-	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
-} xfs_dir2_data_hdr_t;
-
-/*
- * Active entry in a data block.  Aligned to 8 bytes.
- *
- * After the variable length name field there is a 2 byte tag field, which
- * can be accessed using xfs_dir2_data_entry_tag_p.
- */
-typedef struct xfs_dir2_data_entry {
-	__be64			inumber;	/* inode number */
-	__u8			namelen;	/* name length */
-	__u8			name[];		/* name bytes, no null */
-     /*	__be16                  tag; */		/* starting offset of us */
-} xfs_dir2_data_entry_t;
-
-/*
- * Unused entry in a data block.  Aligned to 8 bytes.
- * Tag appears as the last 2 bytes.
- */
-typedef struct xfs_dir2_data_unused {
-	__be16			freetag;	/* XFS_DIR2_DATA_FREE_TAG */
-	__be16			length;		/* total free length */
-						/* variable offset */
-	__be16			tag;		/* starting offset of us */
-} xfs_dir2_data_unused_t;
-
-/*
- * Size of a data entry.
- */
-static inline int xfs_dir2_data_entsize(int n)
-{
-	return (int)roundup(offsetof(xfs_dir2_data_entry_t, name[0]) + (n) + \
-		 (uint)sizeof(xfs_dir2_data_off_t), XFS_DIR2_DATA_ALIGN);
-}
-
-/*
- * Pointer to an entry's tag word.
- */
-static inline __be16 *
-xfs_dir2_data_entry_tag_p(xfs_dir2_data_entry_t *dep)
-{
-	return (__be16 *)((char *)dep +
-		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
-}
-
-/*
- * Pointer to a freespace's tag word.
- */
-static inline __be16 *
-xfs_dir2_data_unused_tag_p(xfs_dir2_data_unused_t *dup)
-{
-	return (__be16 *)((char *)dup +
-			be16_to_cpu(dup->length) - sizeof(__be16));
-}
-
-/*
- * Function declarations.
- */
-#ifdef DEBUG
-extern void xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_dabuf *bp);
-#else
-#define	xfs_dir2_data_check(dp,bp)
-#endif
-extern xfs_dir2_data_free_t *xfs_dir2_data_freeinsert(xfs_dir2_data_hdr_t *hdr,
-				xfs_dir2_data_unused_t *dup, int *loghead);
-extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
-				xfs_dir2_data_hdr_t *hdr, int *loghead);
-extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
-				struct xfs_dabuf **bpp);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				xfs_dir2_data_entry_t *dep);
-extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
-				struct xfs_dabuf *bp);
-extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				xfs_dir2_data_unused_t *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				xfs_dir2_data_aoff_t offset,
-				xfs_dir2_data_aoff_t len, int *needlogp,
-				int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
-			       xfs_dir2_data_unused_t *dup,
-			       xfs_dir2_data_aoff_t offset,
-			       xfs_dir2_data_aoff_t len, int *needlogp,
-			       int *needscanp);
-
-#endif	/* __XFS_DIR2_DATA_H__ */
Index: xfs/fs/xfs/xfs_dir2_format.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/xfs_dir2_format.h	2011-07-09 13:29:33.488251514 +0200
@@ -0,0 +1,602 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_DIR2_FORMAT_H__
+#define __XFS_DIR2_FORMAT_H__
+
+/*
+ * Directory version 2.
+ *
+ * There are 4 possible formats:
+ *  - shortform - embedded into the inode
+ *  - single block - data with embedded leaf at the end
+ *  - multiple data blocks, single leaf+freeindex block
+ *  - data blocks, node and leaf blocks (btree), freeindex blocks
+ *
+ * Note: many node blocks structures and constants are shared with the attributes
+ * code and defined in xfs_da_btree.h.
+ */
+
+#define	XFS_DIR2_BLOCK_MAGIC	0x58443242	/* XD2B: for one block dirs */
+#define	XFS_DIR2_DATA_MAGIC	0x58443244	/* XD2D: for multiblock dirs */
+#define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F */
+
+/*
+ * Byte offset in data block and shortform entry.
+ */
+typedef	__uint16_t	xfs_dir2_data_off_t;
+#define	NULLDATAOFF	0xffffU
+typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
+
+/*
+ * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
+ * Only need 16 bits, this is the byte offset into the single block form.
+ */
+typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
+
+/*
+ * Offset in data space of a data entry.
+ */
+typedef	__uint32_t	xfs_dir2_dataptr_t;
+#define	XFS_DIR2_MAX_DATAPTR	((xfs_dir2_dataptr_t)0xffffffff)
+#define	XFS_DIR2_NULL_DATAPTR	((xfs_dir2_dataptr_t)0)
+
+/*
+ * Byte offset in a directory.
+ */
+typedef	xfs_off_t	xfs_dir2_off_t;
+
+/*
+ * Directory block number (logical dirblk in file)
+ */
+typedef	__uint32_t	xfs_dir2_db_t;
+
+/*
+ * Inode number stored as 8 8-bit values.
+ */
+typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
+
+/*
+ * Inode number stored as 4 8-bit values.
+ * Works a lot of the time, when all the inode numbers in a directory
+ * fit in 32 bits.
+ */
+typedef struct { __uint8_t i[4]; } xfs_dir2_ino4_t;
+
+typedef union {
+	xfs_dir2_ino8_t	i8;
+	xfs_dir2_ino4_t	i4;
+} xfs_dir2_inou_t;
+#define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)
+
+/*
+ * Directory layout when stored internal to an inode.
+ *
+ * Small directories are packed as tightly as possible so as to fit into the
+ * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
+ * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
+ * inode number storage size and the variable length name field in
+ * the xfs_dir2_sf_entry all these structure are variable length, and the
+ * accessors in this file should be used to iterate over them.
+ *
+ *
+ * The parent directory has a dedicated field, and the self-pointer must
+ * be calculated on the fly.
+ *
+ * Entries are packed toward the top as tightly as possible, and thus may
+ * be misaligned.  Care needs to be taken to access them through special
+ * helpers or copy them into aligned variables first.
+ */
+typedef struct xfs_dir2_sf_hdr {
+	__uint8_t		count;		/* count of entries */
+	__uint8_t		i8count;	/* count of 8-byte inode #s */
+	xfs_dir2_inou_t		parent;		/* parent dir inode number */
+} __arch_pack xfs_dir2_sf_hdr_t;
+
+typedef struct xfs_dir2_sf_entry {
+	__u8			namelen;	/* actual name length */
+	xfs_dir2_sf_off_t	offset;		/* saved offset */
+	__u8			name[];		/* name, variable size */
+	/*
+	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
+	 * variable offset after the name.
+	 */
+} __arch_pack xfs_dir2_sf_entry_t;
+
+static inline int xfs_dir2_sf_hdr_size(int i8count)
+{
+	return sizeof(struct xfs_dir2_sf_hdr) -
+		(i8count == 0) *
+		(sizeof(xfs_dir2_ino8_t) - sizeof(xfs_dir2_ino4_t));
+}
+
+static inline xfs_dir2_data_aoff_t
+xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
+{
+	return get_unaligned_be16(&sfep->offset.i);
+}
+
+static inline void
+xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
+{
+	put_unaligned_be16(off, &sfep->offset.i);
+}
+
+static inline int
+xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
+{
+	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
+		len +					/* name */
+		(hdr->i8count ?				/* ino */
+		 sizeof(xfs_dir2_ino8_t) :
+		 sizeof(xfs_dir2_ino4_t));
+}
+
+static inline struct xfs_dir2_sf_entry *
+xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
+{
+	return (struct xfs_dir2_sf_entry *)
+		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
+}
+
+static inline struct xfs_dir2_sf_entry *
+xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
+		struct xfs_dir2_sf_entry *sfep)
+{
+	return (struct xfs_dir2_sf_entry *)
+		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
+}
+
+
+/*
+ * Data block structures.
+ *
+ * A pure data block looks like the following drawing on disk:
+ *
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_hdr_t                             |
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | ...                                             |
+ *    +-------------------------------------------------+
+ *    | unused space                                    |
+ *    +-------------------------------------------------+
+ *
+ * As all the entries are variable size structures the accessors below should
+ * be used to iterate over them.
+ *
+ * In addition to the pure data blocks for the data and node formats it,
+ * most structures are also used for the combined data/freespace "block"
+ * format below.
+ */
+
+#define	XFS_DIR2_DATA_ALIGN_LOG	3		/* i.e., 8 bytes */
+#define	XFS_DIR2_DATA_ALIGN	(1 << XFS_DIR2_DATA_ALIGN_LOG)
+#define	XFS_DIR2_DATA_FREE_TAG	0xffff
+#define	XFS_DIR2_DATA_FD_COUNT	3
+
+/*
+ * Directory address space divided into sections,
+ * spaces separated by 32GB.
+ */
+#define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
+#define	XFS_DIR2_DATA_SPACE	0
+#define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
+#define	XFS_DIR2_DATA_FIRSTDB(mp)	\
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_DATA_OFFSET)
+
+/*
+ * Offsets of . and .. in data space (always block 0)
+ */
+#define	XFS_DIR2_DATA_DOT_OFFSET	\
+	((xfs_dir2_data_aoff_t)sizeof(struct xfs_dir2_data_hdr))
+#define	XFS_DIR2_DATA_DOTDOT_OFFSET	\
+	(XFS_DIR2_DATA_DOT_OFFSET + xfs_dir2_data_entsize(1))
+#define	XFS_DIR2_DATA_FIRST_OFFSET		\
+	(XFS_DIR2_DATA_DOTDOT_OFFSET + xfs_dir2_data_entsize(2))
+
+/*
+ * Describe a free area in the data block.
+ *
+ * The freespace will be formatted as a xfs_dir2_data_unused_t.
+ */
+typedef struct xfs_dir2_data_free {
+	__be16			offset;		/* start of freespace */
+	__be16			length;		/* length of freespace */
+} xfs_dir2_data_free_t;
+
+/*
+ * Header for the data blocks.
+ *
+ * The code knows that XFS_DIR2_DATA_FD_COUNT is 3.
+ */
+typedef struct xfs_dir2_data_hdr {
+	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
+						/* XFS_DIR2_BLOCK_MAGIC */
+	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
+} xfs_dir2_data_hdr_t;
+
+/*
+ * Active entry in a data block.
+ *
+ * Aligned to 8 bytes.  After the variable length name field there is a
+ * 2 byte tag field, which can be accessed using xfs_dir2_data_entry_tag_p.
+ */
+typedef struct xfs_dir2_data_entry {
+	__be64			inumber;	/* inode number */
+	__u8			namelen;	/* name length */
+	__u8			name[];		/* name bytes, no null */
+     /*	__be16                  tag; */		/* starting offset of us */
+} xfs_dir2_data_entry_t;
+
+/*
+ * Unused entry in a data block.
+ *
+ * Aligned to 8 bytes.  Tag appears as the last 2 bytes and must be accessed
+ * using xfs_dir2_data_unused_tag_p.
+ */
+typedef struct xfs_dir2_data_unused {
+	__be16			freetag;	/* XFS_DIR2_DATA_FREE_TAG */
+	__be16			length;		/* total free length */
+						/* variable offset */
+	__be16			tag;		/* starting offset of us */
+} xfs_dir2_data_unused_t;
+
+/*
+ * Size of a data entry.
+ */
+static inline int xfs_dir2_data_entsize(int n)
+{
+	return (int)roundup(offsetof(struct xfs_dir2_data_entry, name[0]) + n +
+		 (uint)sizeof(xfs_dir2_data_off_t), XFS_DIR2_DATA_ALIGN);
+}
+
+/*
+ * Pointer to an entry's tag word.
+ */
+static inline __be16 *
+xfs_dir2_data_entry_tag_p(struct xfs_dir2_data_entry *dep)
+{
+	return (__be16 *)((char *)dep +
+		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
+}
+
+/*
+ * Pointer to a freespace's tag word.
+ */
+static inline __be16 *
+xfs_dir2_data_unused_tag_p(struct xfs_dir2_data_unused *dup)
+{
+	return (__be16 *)((char *)dup +
+			be16_to_cpu(dup->length) - sizeof(__be16));
+}
+
+/*
+ * Leaf block structures.
+ *
+ * A pure leaf block looks like the following drawing on disk:
+ *
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_hdr_t       |
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | ...                       |
+ *    +---------------------------+
+ *    | xfs_dir2_data_off_t       |
+ *    | xfs_dir2_data_off_t       |
+ *    | xfs_dir2_data_off_t       |
+ *    | ...                       |
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_tail_t      |
+ *    +---------------------------+
+ *
+ * The xfs_dir2_data_off_t members (bests) and tail are at the end of the block
+ * for single-leaf (magic = XFS_DIR2_LEAF1_MAGIC) blocks only, but not present
+ * for directories with separate leaf nodes and free space blocks
+ * (magic = XFS_DIR2_LEAFN_MAGIC).
+ *
+ * As all the entries are variable size structures the accessors below should
+ * be used to iterate over them.
+ */
+
+/*
+ * Offset of the leaf/node space.  First block in this space
+ * is the btree root.
+ */
+#define	XFS_DIR2_LEAF_SPACE	1
+#define	XFS_DIR2_LEAF_OFFSET	(XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
+#define	XFS_DIR2_LEAF_FIRSTDB(mp)	\
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET)
+
+/*
+ * Leaf block header.
+ */
+typedef struct xfs_dir2_leaf_hdr {
+	xfs_da_blkinfo_t	info;		/* header for da routines */
+	__be16			count;		/* count of entries */
+	__be16			stale;		/* count of stale entries */
+} xfs_dir2_leaf_hdr_t;
+
+/*
+ * Leaf block entry.
+ */
+typedef struct xfs_dir2_leaf_entry {
+	__be32			hashval;	/* hash value of name */
+	__be32			address;	/* address of data entry */
+} xfs_dir2_leaf_entry_t;
+
+/*
+ * Leaf block tail.
+ */
+typedef struct xfs_dir2_leaf_tail {
+	__be32			bestcount;
+} xfs_dir2_leaf_tail_t;
+
+/*
+ * Leaf block.
+ */
+typedef struct xfs_dir2_leaf {
+	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
+	xfs_dir2_leaf_entry_t	ents[];	/* entries */
+} xfs_dir2_leaf_t;
+
+/*
+ * DB blocks here are logical directory block numbers, not filesystem blocks.
+ */
+
+static inline int xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - (uint)sizeof(struct xfs_dir2_leaf_hdr)) /
+		(uint)sizeof(struct xfs_dir2_leaf_entry);
+}
+
+/*
+ * Get address of the bestcount field in the single-leaf block.
+ */
+static inline struct xfs_dir2_leaf_tail *
+xfs_dir2_leaf_tail_p(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
+{
+	return (struct xfs_dir2_leaf_tail *)
+		((char *)lp + mp->m_dirblksize -
+		  sizeof(struct xfs_dir2_leaf_tail));
+}
+
+/*
+ * Get address of the bests array in the single-leaf block.
+ */
+static inline __be16 *
+xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
+{
+	return (__be16 *)ltp - be32_to_cpu(ltp->bestcount);
+}
+
+/*
+ * Convert dataptr to byte in file space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+{
+	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
+}
+
+/*
+ * Convert byte in file space to dataptr.  It had better be aligned.
+ */
+static inline xfs_dir2_dataptr_t
+xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
+{
+	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
+}
+
+/*
+ * Convert byte in space to (DB) block
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
+{
+	return (xfs_dir2_db_t)
+		(by >> (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog));
+}
+
+/*
+ * Convert dataptr to a block number
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+{
+	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+}
+
+/*
+ * Convert byte in space to offset in a block
+ */
+static inline xfs_dir2_data_aoff_t
+xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
+{
+	return (xfs_dir2_data_aoff_t)(by &
+		((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) - 1));
+}
+
+/*
+ * Convert dataptr to a byte offset in a block
+ */
+static inline xfs_dir2_data_aoff_t
+xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+{
+	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+}
+
+/*
+ * Convert block and offset to byte in space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
+			xfs_dir2_data_aoff_t o)
+{
+	return ((xfs_dir2_off_t)db <<
+		(mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) + o;
+}
+
+/*
+ * Convert block (DB) to block (dablk)
+ */
+static inline xfs_dablk_t
+xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return (xfs_dablk_t)(db << mp->m_sb.sb_dirblklog);
+}
+
+/*
+ * Convert byte in space to (DA) block
+ */
+static inline xfs_dablk_t
+xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
+{
+	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
+}
+
+/*
+ * Convert block and offset to dataptr
+ */
+static inline xfs_dir2_dataptr_t
+xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
+			   xfs_dir2_data_aoff_t o)
+{
+	return xfs_dir2_byte_to_dataptr(mp, xfs_dir2_db_off_to_byte(mp, db, o));
+}
+
+/*
+ * Convert block (dablk) to block (DB)
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
+{
+	return (xfs_dir2_db_t)(da >> mp->m_sb.sb_dirblklog);
+}
+
+/*
+ * Convert block (dablk) to byte offset in space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
+{
+	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
+}
+
+/*
+ * Free space block defintions for the node format.
+ */
+
+/*
+ * Offset of the freespace index.
+ */
+#define	XFS_DIR2_FREE_SPACE	2
+#define	XFS_DIR2_FREE_OFFSET	(XFS_DIR2_FREE_SPACE * XFS_DIR2_SPACE_SIZE)
+#define	XFS_DIR2_FREE_FIRSTDB(mp)	\
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)
+
+typedef	struct xfs_dir2_free_hdr {
+	__be32			magic;		/* XFS_DIR2_FREE_MAGIC */
+	__be32			firstdb;	/* db of first entry */
+	__be32			nvalid;		/* count of valid entries */
+	__be32			nused;		/* count of used entries */
+} xfs_dir2_free_hdr_t;
+
+typedef struct xfs_dir2_free {
+	xfs_dir2_free_hdr_t	hdr;		/* block header */
+	__be16			bests[1];	/* best free counts */
+						/* unused entries are -1 */
+} xfs_dir2_free_t;
+
+#define	XFS_DIR2_MAX_FREE_BESTS(mp)	\
+	(((mp)->m_dirblksize - (uint)sizeof(struct xfs_dir2_free_hdr)) / \
+	 (uint)sizeof(xfs_dir2_data_off_t))
+
+/*
+ * Convert data space db to the corresponding free db.
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return XFS_DIR2_FREE_FIRSTDB(mp) + db / XFS_DIR2_MAX_FREE_BESTS(mp);
+}
+
+/*
+ * Convert data space db to the corresponding index in a free db.
+ */
+static inline int
+xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return db % XFS_DIR2_MAX_FREE_BESTS(mp);
+}
+
+/*
+ * Single block format.
+ *
+ * The single block format looks like the following drawing on disk:
+ *
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_hdr_t                             |
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t :
+ *    | ...                                             |
+ *    +-------------------------------------------------+
+ *    | unused space                                    |
+ *    +-------------------------------------------------+
+ *    | ...                                             |
+ *    | xfs_dir2_leaf_entry_t                           |
+ *    | xfs_dir2_leaf_entry_t                           |
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_block_tail_t                           |
+ *    +-------------------------------------------------+
+ *
+ * As all the entries are variable size structures the accessors below should
+ * be used to iterate over them.
+ */
+
+typedef struct xfs_dir2_block_tail {
+	__be32		count;			/* count of leaf entries */
+	__be32		stale;			/* count of stale lf entries */
+} xfs_dir2_block_tail_t;
+
+/*
+ * Pointer to the leaf header embedded in a data block (1-block format)
+ */
+static inline struct xfs_dir2_block_tail *
+xfs_dir2_block_tail_p(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr)
+{
+	return ((struct xfs_dir2_block_tail *)
+		((char *)hdr + mp->m_dirblksize)) - 1;
+}
+
+/*
+ * Pointer to the leaf entries embedded in a data block (1-block format)
+ */
+static inline struct xfs_dir2_leaf_entry *
+xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
+{
+	return ((struct xfs_dir2_leaf_entry *)btp) - be32_to_cpu(btp->count);
+}
+
+#endif /* __XFS_DIR2_FORMAT_H__ */
Index: xfs/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-07-09 13:29:18.321585614 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,281 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_LEAF_H__
-#define	__XFS_DIR2_LEAF_H__
-
-/*
- * Directory format 2, leaf block structures.
- *
- * A pure data block looks like the following drawing on disk:
- *
- *    +---------------------------+
- *    | xfs_dir2_leaf_hdr_t       |
- *    +---------------------------+
- *    | xfs_dir2_leaf_entry_t     |
- *    | xfs_dir2_leaf_entry_t     |
- *    | xfs_dir2_leaf_entry_t     |
- *    | xfs_dir2_leaf_entry_t     |
- *    | ...                       |
- *    +---------------------------+
- *    | xfs_dir2_data_off_t       |
- *    | xfs_dir2_data_off_t       |
- *    | xfs_dir2_data_off_t       |
- *    | ...                       |
- *    +---------------------------+
- *    | xfs_dir2_leaf_tail_t      |
- *    +---------------------------+
- *
- * The bests (xfs_dir2_data_off_t members) and tail are at the end of the
- * block for single-leaf only (magic = XFS_DIR2_LEAF1_MAGIC not
- * XFS_DIR2_LEAFN_MAGIC).
- *
- * As all the entries are variable size structures the accessors in this
- * file should be used to iterate over them.
- */
-
-struct uio;
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_inode;
-struct xfs_mount;
-struct xfs_trans;
-
-/*
- * Offset of the leaf/node space.  First block in this space
- * is the btree root.
- */
-#define	XFS_DIR2_LEAF_SPACE	1
-#define	XFS_DIR2_LEAF_OFFSET	(XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_LEAF_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET)
-
-/*
- * Offset in data space of a data entry.
- */
-typedef	__uint32_t	xfs_dir2_dataptr_t;
-#define	XFS_DIR2_MAX_DATAPTR	((xfs_dir2_dataptr_t)0xffffffff)
-#define	XFS_DIR2_NULL_DATAPTR	((xfs_dir2_dataptr_t)0)
-
-/*
- * Leaf block header.
- */
-typedef struct xfs_dir2_leaf_hdr {
-	xfs_da_blkinfo_t	info;		/* header for da routines */
-	__be16			count;		/* count of entries */
-	__be16			stale;		/* count of stale entries */
-} xfs_dir2_leaf_hdr_t;
-
-/*
- * Leaf block entry.
- */
-typedef struct xfs_dir2_leaf_entry {
-	__be32			hashval;	/* hash value of name */
-	__be32			address;	/* address of data entry */
-} xfs_dir2_leaf_entry_t;
-
-/*
- * Leaf block tail.
- */
-typedef struct xfs_dir2_leaf_tail {
-	__be32			bestcount;
-} xfs_dir2_leaf_tail_t;
-
-/*
- * Leaf block.
- */
-typedef struct xfs_dir2_leaf {
-	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
-	xfs_dir2_leaf_entry_t	ents[];	/* entries */
-} xfs_dir2_leaf_t;
-
-/*
- * DB blocks here are logical directory block numbers, not filesystem blocks.
- */
-
-static inline int xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
-{
-	return (int)(((mp)->m_dirblksize - (uint)sizeof(xfs_dir2_leaf_hdr_t)) /
-	       (uint)sizeof(xfs_dir2_leaf_entry_t));
-}
-
-/*
- * Get address of the bestcount field in the single-leaf block.
- */
-static inline xfs_dir2_leaf_tail_t *
-xfs_dir2_leaf_tail_p(struct xfs_mount *mp, xfs_dir2_leaf_t *lp)
-{
-	return (xfs_dir2_leaf_tail_t *)
-		((char *)(lp) + (mp)->m_dirblksize - 
-		  (uint)sizeof(xfs_dir2_leaf_tail_t));
-}
-
-/*
- * Get address of the bests array in the single-leaf block.
- */
-static inline __be16 *
-xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail_t *ltp)
-{
-	return (__be16 *)ltp - be32_to_cpu(ltp->bestcount);
-}
-
-/*
- * Convert dataptr to byte in file space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
-{
-	return (xfs_dir2_off_t)(dp) << XFS_DIR2_DATA_ALIGN_LOG;
-}
-
-/*
- * Convert byte in file space to dataptr.  It had better be aligned.
- */
-static inline xfs_dir2_dataptr_t
-xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
-{
-	return (xfs_dir2_dataptr_t)((by) >> XFS_DIR2_DATA_ALIGN_LOG);
-}
-
-/*
- * Convert byte in space to (DB) block
- */
-static inline xfs_dir2_db_t
-xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
-{
-	return (xfs_dir2_db_t)((by) >> \
-		 ((mp)->m_sb.sb_blocklog + (mp)->m_sb.sb_dirblklog));
-}
-
-/*
- * Convert dataptr to a block number
- */
-static inline xfs_dir2_db_t
-xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
-{
-	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(mp, dp));
-}
-
-/*
- * Convert byte in space to offset in a block
- */
-static inline xfs_dir2_data_aoff_t
-xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
-{
-	return (xfs_dir2_data_aoff_t)((by) & \
-		((1 << ((mp)->m_sb.sb_blocklog + (mp)->m_sb.sb_dirblklog)) - 1));
-}
-
-/*
- * Convert dataptr to a byte offset in a block
- */
-static inline xfs_dir2_data_aoff_t
-xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
-{
-	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(mp, dp));
-}
-
-/*
- * Convert block and offset to byte in space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
-			xfs_dir2_data_aoff_t o)
-{
-	return ((xfs_dir2_off_t)(db) << \
-		((mp)->m_sb.sb_blocklog + (mp)->m_sb.sb_dirblklog)) + (o);
-}
-
-/*
- * Convert block (DB) to block (dablk)
- */
-static inline xfs_dablk_t
-xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
-{
-	return (xfs_dablk_t)((db) << (mp)->m_sb.sb_dirblklog);
-}
-
-/*
- * Convert byte in space to (DA) block
- */
-static inline xfs_dablk_t
-xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
-{
-	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
-}
-
-/*
- * Convert block and offset to dataptr
- */
-static inline xfs_dir2_dataptr_t
-xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
-			   xfs_dir2_data_aoff_t o)
-{
-	return xfs_dir2_byte_to_dataptr(mp, xfs_dir2_db_off_to_byte(mp, db, o));
-}
-
-/*
- * Convert block (dablk) to block (DB)
- */
-static inline xfs_dir2_db_t
-xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
-{
-	return (xfs_dir2_db_t)((da) >> (mp)->m_sb.sb_dirblklog);
-}
-
-/*
- * Convert block (dablk) to byte offset in space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
-{
-	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
-}
-
-/*
- * Function declarations.
- */
-extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
-				  struct xfs_dabuf *dbp);
-extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
-extern void xfs_dir2_leaf_compact(struct xfs_da_args *args,
-				  struct xfs_dabuf *bp);
-extern void xfs_dir2_leaf_compact_x1(struct xfs_dabuf *bp, int *indexp,
-				     int *lowstalep, int *highstalep,
-				     int *lowlogp, int *highlogp);
-extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
-				  size_t bufsize, xfs_off_t *offset,
-				  filldir_t filldir);
-extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
-			      struct xfs_dabuf **bpp, int magic);
-extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				   int first, int last);
-extern void xfs_dir2_leaf_log_header(struct xfs_trans *tp,
-				     struct xfs_dabuf *bp);
-extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
-extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
-extern int xfs_dir2_leaf_replace(struct xfs_da_args *args);
-extern int xfs_dir2_leaf_search_hash(struct xfs_da_args *args,
-				     struct xfs_dabuf *lbp);
-extern int xfs_dir2_leaf_trim_data(struct xfs_da_args *args,
-				   struct xfs_dabuf *lbp, xfs_dir2_db_t db);
-extern xfs_dir2_leaf_entry_t *xfs_dir2_leaf_find_entry(xfs_dir2_leaf_t *, int,
-						       int, int, int,
-						       int *, int *);
-extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
-
-#endif	/* __XFS_DIR2_LEAF_H__ */
Index: xfs/fs/xfs/xfs_dir2_node.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.h	2011-07-09 13:29:18.331585614 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,100 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_NODE_H__
-#define	__XFS_DIR2_NODE_H__
-
-/*
- * Directory version 2, btree node format structures
- */
-
-struct uio;
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_da_state;
-struct xfs_da_state_blk;
-struct xfs_inode;
-struct xfs_trans;
-
-/*
- * Offset of the freespace index.
- */
-#define	XFS_DIR2_FREE_SPACE	2
-#define	XFS_DIR2_FREE_OFFSET	(XFS_DIR2_FREE_SPACE * XFS_DIR2_SPACE_SIZE)
-#define	XFS_DIR2_FREE_FIRSTDB(mp)	\
-	xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)
-
-#define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F */
-
-typedef	struct xfs_dir2_free_hdr {
-	__be32			magic;		/* XFS_DIR2_FREE_MAGIC */
-	__be32			firstdb;	/* db of first entry */
-	__be32			nvalid;		/* count of valid entries */
-	__be32			nused;		/* count of used entries */
-} xfs_dir2_free_hdr_t;
-
-typedef struct xfs_dir2_free {
-	xfs_dir2_free_hdr_t	hdr;		/* block header */
-	__be16			bests[1];	/* best free counts */
-						/* unused entries are -1 */
-} xfs_dir2_free_t;
-
-#define	XFS_DIR2_MAX_FREE_BESTS(mp)	\
-	(((mp)->m_dirblksize - (uint)sizeof(xfs_dir2_free_hdr_t)) / \
-	 (uint)sizeof(xfs_dir2_data_off_t))
-
-/*
- * Convert data space db to the corresponding free db.
- */
-static inline xfs_dir2_db_t
-xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
-{
-	return (XFS_DIR2_FREE_FIRSTDB(mp) + (db) / XFS_DIR2_MAX_FREE_BESTS(mp));
-}
-
-/*
- * Convert data space db to the corresponding index in a free db.
- */
-static inline int
-xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
-{
-	return ((db) % XFS_DIR2_MAX_FREE_BESTS(mp));
-}
-
-extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
-				 struct xfs_dabuf *lbp);
-extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
-extern int xfs_dir2_leafn_lookup_int(struct xfs_dabuf *bp,
-				     struct xfs_da_args *args, int *indexp,
-				     struct xfs_da_state *state);
-extern int xfs_dir2_leafn_order(struct xfs_dabuf *leaf1_bp,
-				struct xfs_dabuf *leaf2_bp);
-extern int xfs_dir2_leafn_split(struct xfs_da_state *state,
-				struct xfs_da_state_blk *oldblk,
-				struct xfs_da_state_blk *newblk);
-extern int xfs_dir2_leafn_toosmall(struct xfs_da_state *state, int *action);
-extern void xfs_dir2_leafn_unbalance(struct xfs_da_state *state,
-				     struct xfs_da_state_blk *drop_blk,
-				     struct xfs_da_state_blk *save_blk);
-extern int xfs_dir2_node_addname(struct xfs_da_args *args);
-extern int xfs_dir2_node_lookup(struct xfs_da_args *args);
-extern int xfs_dir2_node_removename(struct xfs_da_args *args);
-extern int xfs_dir2_node_replace(struct xfs_da_args *args);
-extern int xfs_dir2_node_trim_free(struct xfs_da_args *args, xfs_fileoff_t fo,
-				   int *rvalp);
-
-#endif	/* __XFS_DIR2_NODE_H__ */
Index: xfs/fs/xfs/xfs_dir2_priv.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/xfs_dir2_priv.h	2011-07-09 13:29:40.948251135 +0200
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_DIR2_PRIV_H__
+#define __XFS_DIR2_PRIV_H__
+
+/* xfs_dir2.c */
+extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
+extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
+extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
+				xfs_dir2_db_t *dbp);
+extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
+				struct xfs_dabuf *bp);
+extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
+				const unsigned char *name, int len);
+
+/* xfs_dir2_block.c */
+extern int xfs_dir2_block_addname(struct xfs_da_args *args);
+extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
+		xfs_off_t *offset, filldir_t filldir);
+extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
+extern int xfs_dir2_block_removename(struct xfs_da_args *args);
+extern int xfs_dir2_block_replace(struct xfs_da_args *args);
+extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
+		struct xfs_dabuf *lbp, struct xfs_dabuf *dbp);
+
+/* xfs_dir2_data.c */
+#ifdef DEBUG
+extern void xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_dabuf *bp);
+#else
+#define	xfs_dir2_data_check(dp,bp)
+#endif
+extern struct xfs_dir2_data_free *
+xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
+		struct xfs_dir2_data_unused *dup, int *loghead);
+extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
+		struct xfs_dir2_data_hdr *hdr, int *loghead);
+extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
+		struct xfs_dabuf **bpp);
+extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_dir2_data_entry *dep);
+extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
+		struct xfs_dabuf *bp);
+extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_dir2_data_unused *dup);
+extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
+		int *needlogp, int *needscanp);
+extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
+		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
+
+/* xfs_dir2_leaf.c */
+extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
+		struct xfs_dabuf *dbp);
+extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
+extern void xfs_dir2_leaf_compact(struct xfs_da_args *args,
+		struct xfs_dabuf *bp);
+extern void xfs_dir2_leaf_compact_x1(struct xfs_dabuf *bp, int *indexp,
+		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
+extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
+		size_t bufsize, xfs_off_t *offset, filldir_t filldir);
+extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
+		struct xfs_dabuf **bpp, int magic);
+extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		int first, int last);
+extern void xfs_dir2_leaf_log_header(struct xfs_trans *tp,
+		struct xfs_dabuf *bp);
+extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
+extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
+extern int xfs_dir2_leaf_replace(struct xfs_da_args *args);
+extern int xfs_dir2_leaf_search_hash(struct xfs_da_args *args,
+		struct xfs_dabuf *lbp);
+extern int xfs_dir2_leaf_trim_data(struct xfs_da_args *args,
+		struct xfs_dabuf *lbp, xfs_dir2_db_t db);
+extern struct xfs_dir2_leaf_entry *
+xfs_dir2_leaf_find_entry(struct xfs_dir2_leaf *leaf, int index, int compact,
+		int lowstale, int highstale,
+		int *lfloglow, int *lfloghigh);
+extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
+
+/* xfs_dir2_node.c */
+extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
+		struct xfs_dabuf *lbp);
+extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
+extern int xfs_dir2_leafn_lookup_int(struct xfs_dabuf *bp,
+		struct xfs_da_args *args, int *indexp,
+		struct xfs_da_state *state);
+extern int xfs_dir2_leafn_order(struct xfs_dabuf *leaf1_bp,
+		struct xfs_dabuf *leaf2_bp);
+extern int xfs_dir2_leafn_split(struct xfs_da_state *state,
+	struct xfs_da_state_blk *oldblk, struct xfs_da_state_blk *newblk);
+extern int xfs_dir2_leafn_toosmall(struct xfs_da_state *state, int *action);
+extern void xfs_dir2_leafn_unbalance(struct xfs_da_state *state,
+		struct xfs_da_state_blk *drop_blk,
+		struct xfs_da_state_blk *save_blk);
+extern int xfs_dir2_node_addname(struct xfs_da_args *args);
+extern int xfs_dir2_node_lookup(struct xfs_da_args *args);
+extern int xfs_dir2_node_removename(struct xfs_da_args *args);
+extern int xfs_dir2_node_replace(struct xfs_da_args *args);
+extern int xfs_dir2_node_trim_free(struct xfs_da_args *args, xfs_fileoff_t fo,
+		int *rvalp);
+
+/* xfs_dir2_sf.c */
+extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
+extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
+		struct xfs_dir2_sf_entry *sfep);
+extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
+		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
+extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_dabuf *bp,
+		int size, xfs_dir2_sf_hdr_t *sfhp);
+extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
+extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
+extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, void *dirent,
+		xfs_off_t *offset, filldir_t filldir);
+extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
+extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
+extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
+
+#endif /* __XFS_DIR2_PRIV_H__ */
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-07-09 13:29:18.351585613 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,151 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DIR2_SF_H__
-#define	__XFS_DIR2_SF_H__
-
-/*
- * Directory layout when stored internal to an inode.
- *
- * Small directories are packed as tightly as possible so as to fit into the
- * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
- * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
- * inode number storage size and the variable length name field in
- * the xfs_dir2_sf_entry all these structure are variable length, and the
- * accessors in this file should be used to iterate over them.
- */
-
-struct uio;
-struct xfs_dabuf;
-struct xfs_da_args;
-struct xfs_dir2_data_hdr;
-struct xfs_inode;
-struct xfs_mount;
-struct xfs_trans;
-
-/*
- * Inode number stored as 8 8-bit values.
- */
-typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
-
-/*
- * Inode number stored as 4 8-bit values.
- * Works a lot of the time, when all the inode numbers in a directory
- * fit in 32 bits.
- */
-typedef struct { __uint8_t i[4]; } xfs_dir2_ino4_t;
-
-typedef union {
-	xfs_dir2_ino8_t	i8;
-	xfs_dir2_ino4_t	i4;
-} xfs_dir2_inou_t;
-#define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)
-
-/*
- * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
- * Only need 16 bits, this is the byte offset into the single block form.
- */
-typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
-
-/*
- * The parent directory has a dedicated field, and the self-pointer must
- * be calculated on the fly.
- *
- * Entries are packed toward the top as tightly as possible, and thus may
- * be misaligned.  Care needs to be taken to access them through special
- * helpers or copy them into aligned variables first.
- */
-typedef struct xfs_dir2_sf_hdr {
-	__uint8_t		count;		/* count of entries */
-	__uint8_t		i8count;	/* count of 8-byte inode #s */
-	xfs_dir2_inou_t		parent;		/* parent dir inode number */
-} __arch_pack xfs_dir2_sf_hdr_t;
-
-typedef struct xfs_dir2_sf_entry {
-	__u8			namelen;	/* actual name length */
-	xfs_dir2_sf_off_t	offset;		/* saved offset */
-	__u8			name[];		/* name, variable size */
-	/*
-	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
-	 * variable offset after the name.
-	 */
-} __arch_pack xfs_dir2_sf_entry_t; 
-
-static inline int xfs_dir2_sf_hdr_size(int i8count)
-{
-	return ((uint)sizeof(xfs_dir2_sf_hdr_t) - \
-		((i8count) == 0) * \
-		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
-}
-
-static inline xfs_dir2_data_aoff_t
-xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
-{
-	return get_unaligned_be16(&sfep->offset.i);
-}
-
-static inline void
-xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
-{
-	put_unaligned_be16(off, &sfep->offset.i);
-}
-
-static inline int
-xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
-{
-	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
-		len +					/* name */
-		(hdr->i8count ?				/* ino */
-		 sizeof(xfs_dir2_ino8_t) :
-		 sizeof(xfs_dir2_ino4_t));
-}
-
-static inline struct xfs_dir2_sf_entry *
-xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
-{
-	return (struct xfs_dir2_sf_entry *)
-		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
-}
-
-static inline struct xfs_dir2_sf_entry *
-xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
-		struct xfs_dir2_sf_entry *sfep)
-{
-	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
-}
-
-/*
- * Functions.
- */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-				      struct xfs_dir2_sf_entry *sfep);
-extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
-				 struct xfs_dir2_data_hdr *block,
-				 xfs_dir2_sf_hdr_t *sfhp);
-extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_dabuf *bp,
-				int size, xfs_dir2_sf_hdr_t *sfhp);
-extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
-extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
-extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, void *dirent,
-				xfs_off_t *offset, filldir_t filldir);
-extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
-extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
-extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-
-#endif	/* __XFS_DIR2_SF_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
