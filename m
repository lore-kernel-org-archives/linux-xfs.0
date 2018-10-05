Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbeJEHlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:03 -0400
Subject: [PATCH 02/15] xfs: refactor clonerange preparation into a separate
 helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:44:47 -0700
Message-ID: <153870028762.29072.5369530877410002226.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the reflink preparation steps into a separate helper that
we'll use to land all the upcoming fixes for insufficient input checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   96 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 71 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 38f405415b88..80ca9b6793cd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1195,11 +1195,33 @@ xfs_iolock_two_inodes_and_break_layout(
 	return 0;
 }
 
+/* Unlock both inodes after they've been prepped for a range clone. */
+STATIC void
+xfs_reflink_remap_unlock(
+	struct file		*file_in,
+	struct file		*file_out)
+{
+	struct inode		*inode_in = file_inode(file_in);
+	struct xfs_inode	*src = XFS_I(inode_in);
+	struct inode		*inode_out = file_inode(file_out);
+	struct xfs_inode	*dest = XFS_I(inode_out);
+	bool			same_inode = (inode_in == inode_out);
+
+	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+	if (!same_inode)
+		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
+	inode_unlock(inode_out);
+	if (!same_inode)
+		inode_unlock_shared(inode_in);
+}
+
 /*
- * Link a range of blocks from one file to another.
+ * Prepare two files for range cloning.  Upon a successful return both inodes
+ * will have the iolock and mmaplock held, the page cache of the out file
+ * will be truncated, and any leases on the out file will have been broken.
  */
-int
-xfs_reflink_remap_range(
+STATIC int
+xfs_reflink_remap_prep(
 	struct file		*file_in,
 	loff_t			pos_in,
 	struct file		*file_out,
@@ -1211,19 +1233,9 @@ xfs_reflink_remap_range(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
-	struct xfs_mount	*mp = src->i_mount;
 	bool			same_inode = (inode_in == inode_out);
-	xfs_fileoff_t		sfsbno, dfsbno;
-	xfs_filblks_t		fsblen;
-	xfs_extlen_t		cowextsize;
 	ssize_t			ret;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return -EOPNOTSUPP;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
 	/* Lock both files against IO */
 	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
 	if (ret)
@@ -1254,8 +1266,6 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
-
 	/*
 	 * Clear out post-eof preallocations because we don't have page cache
 	 * backing the delayed allocations and they'll never get freed on
@@ -1272,6 +1282,51 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
+	/* Zap any page cache for the destination file's range. */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
+	return 0;
+out_unlock:
+	xfs_reflink_remap_unlock(file_in, file_out);
+	return ret;
+}
+
+/*
+ * Link a range of blocks from one file to another.
+ */
+int
+xfs_reflink_remap_range(
+	struct file		*file_in,
+	loff_t			pos_in,
+	struct file		*file_out,
+	loff_t			pos_out,
+	u64			len,
+	bool			is_dedupe)
+{
+	struct inode		*inode_in = file_inode(file_in);
+	struct xfs_inode	*src = XFS_I(inode_in);
+	struct inode		*inode_out = file_inode(file_out);
+	struct xfs_inode	*dest = XFS_I(inode_out);
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		sfsbno, dfsbno;
+	xfs_filblks_t		fsblen;
+	xfs_extlen_t		cowextsize;
+	ssize_t			ret;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* Prepare and then clone file data. */
+	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
+			len, is_dedupe);
+	if (ret)
+		return ret;
+
+	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
+
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
@@ -1280,10 +1335,6 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
-
 	/*
 	 * Carry the cowextsize hint from src to dest if we're sharing the
 	 * entire source file to the entire destination file, the source file
@@ -1300,12 +1351,7 @@ xfs_reflink_remap_range(
 			is_dedupe);
 
 out_unlock:
-	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-	if (!same_inode)
-		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
-	inode_unlock(inode_out);
-	if (!same_inode)
-		inode_unlock_shared(inode_in);
+	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return ret;
