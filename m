Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:31:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741Uv02030321
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:30:57 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 844F3197641E
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:32:09 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id nUE1F5FU4zlqEWE0 for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:32:09 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741WBIF008884
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:32:11 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741WBVb008881
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:32:11 +0200
Date: Mon, 4 Aug 2008 03:32:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/26] kill struct xfs_btree_hdr
Message-ID: <20080804013211.GB8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-btree-hdr
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This type is only embedded in struct xfs_btree_block and never used
directly.  By moving the fields directly into struct xfs_btree_block
a lot of the macros for struct xfs_btree_sblock and struct xfs_btree_lblock
can be used for struct xfs_btree_block too now which helps greatly
with some of the migrations during implementing the generic btree code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-02 04:01:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-02 04:04:22.000000000 +0200
@@ -62,13 +62,13 @@ xfs_btree_maxrecs(
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
 		return (int)XFS_ALLOC_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
+				be16_to_cpu(block->bb_level), cur);
 	case XFS_BTNUM_BMAP:
 		return (int)XFS_BMAP_BLOCK_IMAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
+				be16_to_cpu(block->bb_level), cur);
 	case XFS_BTNUM_INO:
 		return (int)XFS_INOBT_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
+				be16_to_cpu(block->bb_level), cur);
 	default:
 		ASSERT(0);
 		return 0;
@@ -634,7 +634,7 @@ xfs_btree_firstrec(
 	/*
 	 * It's empty, there is no such record.
 	 */
-	if (!block->bb_h.bb_numrecs)
+	if (!block->bb_numrecs)
 		return 0;
 	/*
 	 * Set the ptr value to 1, that's the first record/key.
@@ -663,12 +663,12 @@ xfs_btree_lastrec(
 	/*
 	 * It's empty, there is no such record.
 	 */
-	if (!block->bb_h.bb_numrecs)
+	if (!block->bb_numrecs)
 		return 0;
 	/*
 	 * Set the ptr value to numrecs, that's the last record/key.
 	 */
-	cur->bc_ptrs[level] = be16_to_cpu(block->bb_h.bb_numrecs);
+	cur->bc_ptrs[level] = be16_to_cpu(block->bb_numrecs);
 	return 1;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-02 04:00:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-02 04:05:00.000000000 +0200
@@ -63,15 +63,10 @@ typedef struct xfs_btree_lblock {
 /*
  * Combined header and structure, used by common code.
  */
-typedef struct xfs_btree_hdr
-{
+typedef struct xfs_btree_block {
 	__be32		bb_magic;	/* magic number for block type */
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
-} xfs_btree_hdr_t;
-
-typedef struct xfs_btree_block {
-	xfs_btree_hdr_t	bb_h;		/* header */
 	union {
 		struct {
 			__be32		bb_leftsib;

-- 
