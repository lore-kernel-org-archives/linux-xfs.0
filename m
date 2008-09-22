Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 04:05:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MB5Dw5018097
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:05:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D9CD1BD18D8
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:46 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id sVe7BBZyp9H28XQq for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:46 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8MB6kIF026123
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 13:06:46 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8MB6kZo026121
	for xfs@oss.sgi.com; Mon, 22 Sep 2008 13:06:46 +0200
Date: Mon, 22 Sep 2008 13:06:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] move XFS_BMAP_SANITY_CHECK out of line
Message-ID: <20080922110646.GG26007@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-move-XFS_BMAP_SANITY_CHECK-out-of-line
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Move the XFS_BMAP_SANITY_CHECK macro out of line and make it a properly typed
function.  Also pass the xfs_buf for the btree block instead of just the btree
block header, as we will need some additional information for it to implement
CRC checking of btree blocks.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-09-15 02:39:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-09-15 02:39:09.000000000 +0200
@@ -4524,6 +4524,22 @@ xfs_bmap_one_block(
 	return rval;
 }
 
+STATIC int
+xfs_bmap_sanity_check(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	int			level)
+{
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+
+	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC ||
+	    be16_to_cpu(block->bb_level) != level ||
+	    be16_to_cpu(block->bb_numrecs) == 0 ||
+	    be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
+		return 0;
+	return 1;
+}
+
 /*
  * Read in the extents to if_extents.
  * All inode fields are set up by caller, we just traverse the btree
@@ -4575,7 +4591,7 @@ xfs_bmap_read_extents(
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
-			XFS_BMAP_SANITY_CHECK(mp, block, level),
+			xfs_bmap_sanity_check(mp, bp, level),
 			error0);
 		if (level == 0)
 			break;
@@ -4611,7 +4627,7 @@ xfs_bmap_read_extents(
 			goto error0;
 		}
 		XFS_WANT_CORRUPTED_GOTO(
-			XFS_BMAP_SANITY_CHECK(mp, block, 0),
+			xfs_bmap_sanity_check(mp, bp, 0),
 			error0);
 		/*
 		 * Read-ahead the next leaf block, if any.
@@ -6287,7 +6303,7 @@ xfs_bmap_check_leaf_extents(
 			goto error_norelse;
 		block = XFS_BUF_TO_BLOCK(bp);
 		XFS_WANT_CORRUPTED_GOTO(
-			XFS_BMAP_SANITY_CHECK(mp, block, level),
+			xfs_bmap_sanity_check(mp, bp, level),
 			error0);
 		if (level == 0)
 			break;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:39:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-09-15 02:39:25.000000000 +0200
@@ -213,13 +213,6 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_
  */
 #define XFS_BM_MAXLEVELS(mp,w)		((mp)->m_bm_maxlevels[(w)])
 
-#define XFS_BMAP_SANITY_CHECK(mp,bb,level) \
-	(be32_to_cpu((bb)->bb_magic) == XFS_BMAP_MAGIC && \
-	 be16_to_cpu((bb)->bb_level) == level && \
-	 be16_to_cpu((bb)->bb_numrecs) > 0 && \
-	 be16_to_cpu((bb)->bb_numrecs) <= (mp)->m_bmap_dmxr[(level) != 0])
-
-
 /*
  * Prototypes for xfs_bmap.c to call.
  */

-- 
