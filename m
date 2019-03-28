Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfC1Rux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 13:50:53 -0400
Subject: [PATCH 2/3] xfs: reset page mappings after setting immutable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 28 Mar 2019 10:50:47 -0700
Message-ID: <155379544747.24796.1807309281507099911.stgit@magnolia>
In-Reply-To: <155379543409.24796.5783716624820175068.stgit@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

This means that we need to flush the page cache when setting the
immutable flag so that programs cannot continue to write to writable
mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   63 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..2bd1c5ab5008 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -998,6 +998,37 @@ xfs_diflags_to_linux(
 #endif
 }
 
+static int
+xfs_ioctl_setattr_flush(
+	struct xfs_inode	*ip,
+	int			*join_flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	if (S_ISDIR(inode->i_mode))
+		return 0;
+	if ((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
+		return 0;
+
+	/* lock, flush and invalidate mapping in preparation for flag change */
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+	error = invalidate_inode_pages2(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+
+	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	return error;
+
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1067,7 +1098,6 @@ xfs_ioctl_setattr_dax_invalidate(
 {
 	struct inode		*inode = VFS_I(ip);
 	struct super_block	*sb = inode->i_sb;
-	int			error;
 
 	*join_flags = 0;
 
@@ -1092,25 +1122,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
-	if (S_ISDIR(inode->i_mode))
-		return 0;
-
-	/* lock, flush and invalidate mapping in preparation for flag change */
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	error = filemap_write_and_wait(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-	error = invalidate_inode_pages2(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-
-	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
-	return 0;
-
-out_unlock:
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	return error;
-
+	return xfs_ioctl_setattr_flush(ip, join_flags);
 }
 
 /*
@@ -1356,6 +1368,17 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_free_dquots;
 
+	/*
+	 * If we are trying to set immutable then flush everything to disk to
+	 * force all writable memory mappings back through the pagefault
+	 * handler.
+	 */
+	if (!IS_IMMUTABLE(VFS_I(ip)) && (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
+		code = xfs_ioctl_setattr_flush(ip, &join_flags);
+		if (code)
+			goto error_free_dquots;
+	}
+
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
