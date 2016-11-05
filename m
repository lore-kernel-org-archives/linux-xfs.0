Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39783 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbcKEA0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:52 -0400
Subject: [PATCH 21/39] xfs: scrub extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:48 -0700
Message-ID: <147830560846.4165.7036237898701363825.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub the hash tree, keys, and values in an extended attribute structure.
Refactor the attribute code to use the transaction if the caller supplied
one to avoid buffer deadlocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        |   26 ++++++++++++++++++--------
 libxfs/xfs_attr_remote.c |    5 +++--
 libxfs/xfs_fs.h          |    3 ++-
 3 files changed, 23 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 60513f9..cd9cda1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -109,6 +109,23 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
+/* Retrieve an extended attribute and its value.  Must have iolock. */
+int
+xfs_attr_get_locked(
+	struct xfs_inode	*ip,
+	struct xfs_da_args	*args)
+{
+	if (!xfs_inode_hasattr(ip))
+		return -ENOATTR;
+	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+		return xfs_attr_shortform_getvalue(args);
+	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
+		return xfs_attr_leaf_get(args);
+	else
+		return xfs_attr_node_get(args);
+}
+
+/* Retrieve an extended attribute by name, and its value. */
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
@@ -139,14 +156,7 @@ xfs_attr_get(
 	args.op_flags = XFS_DA_OP_OKNOENT;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
-	if (!xfs_inode_hasattr(ip))
-		error = -ENOATTR;
-	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
-		error = xfs_attr_shortform_getvalue(&args);
-	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_get(&args);
-	else
-		error = xfs_attr_node_get(&args);
+	error = xfs_attr_get_locked(ip, &args);
 	xfs_iunlock(ip, lock_mode);
 
 	*valuelenp = args.valuelen;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index abe1705..b7040ec 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -381,7 +381,8 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+			error = xfs_trans_read_buf(mp, args->trans,
+						   mp->m_ddev_targp,
 						   dblkno, dblkcnt, 0, &bp,
 						   &xfs_attr3_rmt_buf_ops);
 			if (error)
@@ -390,7 +391,7 @@ xfs_attr_rmtval_get(
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_buf_relse(bp);
+			xfs_trans_brelse(args->trans, bp);
 			if (error)
 				return error;
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5dfa0bb..c5d7dd9 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -614,7 +614,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
-#define XFS_SCRUB_TYPE_MAX	15
+#define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
+#define XFS_SCRUB_TYPE_MAX	16
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */

