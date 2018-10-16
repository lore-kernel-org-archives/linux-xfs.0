Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbeJPLJQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 07:09:16 -0400
Subject: [PATCH 25/26] xfs: support returning partial reflink results
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Oct 2018 20:20:55 -0700
Message-ID: <153966005536.3607.787445581785795364.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

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
 fs/xfs/xfs_file.c    |    5 +----
 fs/xfs/xfs_reflink.c |   20 +++++++++++++++-----
 fs/xfs/xfs_reflink.h |    2 +-
 3 files changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 38fde4e11714..7d42ab8fe6e1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -928,14 +928,11 @@ xfs_file_remap_range(
 	loff_t		len,
 	unsigned int	remap_flags)
 {
-	int		ret;
-
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	return ret < 0 ? ret : len;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e8e86646bb4b..af3368862c56 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1123,6 +1123,7 @@ xfs_reflink_remap_blocks(
 	struct xfs_inode	*dest,
 	xfs_fileoff_t		destoff,
 	xfs_filblks_t		len,
+	xfs_filblks_t		*remapped_len,
 	xfs_off_t		new_isize)
 {
 	struct xfs_bmbt_irec	imap;
@@ -1130,6 +1131,7 @@ xfs_reflink_remap_blocks(
 	int			error = 0;
 	xfs_filblks_t		range_len;
 
+	*remapped_len = 0;
 	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
 	while (len) {
 		uint		lock_mode;
@@ -1168,6 +1170,7 @@ xfs_reflink_remap_blocks(
 		srcoff += range_len;
 		destoff += range_len;
 		len -= range_len;
+		*remapped_len += range_len;
 	}
 
 	return 0;
@@ -1382,7 +1385,7 @@ xfs_reflink_remap_prep(
 /*
  * Link a range of blocks from one file to another.
  */
-int
+loff_t
 xfs_reflink_remap_range(
 	struct file		*file_in,
 	loff_t			pos_in,
@@ -1397,9 +1400,10 @@ xfs_reflink_remap_range(
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	struct xfs_mount	*mp = src->i_mount;
 	xfs_fileoff_t		sfsbno, dfsbno;
-	xfs_filblks_t		fsblen;
+	xfs_filblks_t		fsblen, remappedfsb = 0;
+	loff_t			remapped_bytes = 0;
 	xfs_extlen_t		cowextsize;
-	ssize_t			ret;
+	int			ret;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1415,11 +1419,17 @@ xfs_reflink_remap_range(
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
+	if (len == 0) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
 	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
-			pos_out + len);
+			&remappedfsb, pos_out + len);
+	remapped_bytes = min_t(loff_t, len, XFS_FSB_TO_B(mp, remappedfsb));
 	if (ret)
 		goto out_unlock;
 
@@ -1442,7 +1452,7 @@ xfs_reflink_remap_range(
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
-	return ret;
+	return remapped_bytes > 0 ? remapped_bytes : ret;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c3c46c276fe1..cbc26ff79a8f 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -27,7 +27,7 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
-extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
+extern loff_t xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, loff_t len,
 		unsigned int remap_flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
