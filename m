Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:47 -0400
Subject: [PATCH 15/15] xfs: support returning partial reflink results
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:46:27 -0700
Message-ID: <153870038708.29072.12551299927251008289.stgit@magnolia>
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

Back when the XFS reflink code only supported clone_file_range, we were
only able to return zero or negative error codes to userspace.  However,
now that copy_file_range (which returns bytes copied) can use XFS'
clone_file_range, we have the opportunity to return partial results.
For example, if userspace sends a 1GB clone request and we run out of
space halfway through, we at least can tell userspace that we completed
512M of that request like a regular write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |   14 ++++----------
 fs/xfs/xfs_reflink.c |   46 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_reflink.h |    5 +++--
 3 files changed, 37 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d5d6681ca714..4f7aff6d3360 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -928,11 +928,8 @@ xfs_file_clone_range(
 	u64		len,
 	unsigned int	flags)
 {
-	int		ret;
-
-	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-			len, false);
-	return ret < 0 ? ret : len;
+	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, flags);
 }
 
 STATIC s64
@@ -943,11 +940,8 @@ xfs_file_dedupe_range(
 	loff_t		pos_out,
 	u64		len)
 {
-	int		ret;
-
-	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-			len, true);
-	return ret < 0 ? ret : len;
+	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, CLONERANGE_DEDUPE | CLONERANGE_SHORT);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 40684dd011ee..784cebbd0157 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1090,7 +1090,7 @@ xfs_reflink_remap_extent(
 /*
  * Iteratively remap one file's extents (and holes) to another's.
  */
-STATIC int
+STATIC int64_t
 xfs_reflink_remap_blocks(
 	struct xfs_inode	*src,
 	xfs_fileoff_t		srcoff,
@@ -1100,6 +1100,7 @@ xfs_reflink_remap_blocks(
 	xfs_off_t		new_isize)
 {
 	struct xfs_bmbt_irec	imap;
+	int64_t			remapped = 0;
 	int			nimaps;
 	int			error = 0;
 	xfs_filblks_t		range_len;
@@ -1142,13 +1143,14 @@ xfs_reflink_remap_blocks(
 		srcoff += range_len;
 		destoff += range_len;
 		len -= range_len;
+		remapped += range_len;
 	}
 
-	return 0;
+	return remapped;
 
 err:
 	trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
-	return error;
+	return remapped > 0 ? remapped : error;
 }
 
 /*
@@ -1247,14 +1249,15 @@ xfs_reflink_remap_prep(
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			len,
-	bool			is_dedupe)
+	u64			*len,
+	unsigned int		flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
+	bool			is_dedupe = (flags & CLONERANGE_DEDUPE);
 	ssize_t			ret;
 
 	/* Lock both files against IO */
@@ -1278,7 +1281,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe ? CLONERANGE_DEDUPE : 0);
+			len, flags);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1302,7 +1305,7 @@ xfs_reflink_remap_prep(
 
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
+				   PAGE_ALIGN(pos_out + *len) - 1);
 
 	/* If we're altering the file contents... */
 	if (!is_dedupe) {
@@ -1336,14 +1339,14 @@ xfs_reflink_remap_prep(
 /*
  * Link a range of blocks from one file to another.
  */
-int
+s64
 xfs_reflink_remap_range(
 	struct file		*file_in,
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
 	u64			len,
-	bool			is_dedupe)
+	unsigned int		flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
@@ -1352,8 +1355,10 @@ xfs_reflink_remap_range(
 	struct xfs_mount	*mp = src->i_mount;
 	xfs_fileoff_t		sfsbno, dfsbno;
 	xfs_filblks_t		fsblen;
+	s64			remapped;
 	xfs_extlen_t		cowextsize;
-	ssize_t			ret;
+	int			ret;
+	bool			is_dedupe = (flags & CLONERANGE_DEDUPE);
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1363,19 +1368,25 @@ xfs_reflink_remap_range(
 
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
-			len, is_dedupe);
+			&len, flags);
 	if (ret)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
+	if (len == 0)
+		goto done;
+
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
-	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
+	remapped = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
 			pos_out + len);
-	if (ret)
+	if (remapped < 0) {
+		ret = remapped;
 		goto out_unlock;
+	}
+	remapped = min_t(int64_t, len, XFS_FSB_TO_B(mp, remapped));
 
 	/*
 	 * Carry the cowextsize hint from src to dest if we're sharing the
@@ -1391,11 +1402,14 @@ xfs_reflink_remap_range(
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			is_dedupe);
-
+	if (ret)
+		goto out_unlock;
+done:
+	xfs_reflink_remap_unlock(file_in, file_out);
+	return remapped;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
-	if (ret)
-		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
+	trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c585ad9552b2..b53470904373 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -27,8 +27,9 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
-extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
+extern s64 xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
+		struct file *file_out, loff_t pos_out, u64 len,
+		unsigned int flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
 		struct xfs_inode *ip, bool *has_shared);
 extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
