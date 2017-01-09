Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33801 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933203AbdAINGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 08:06:45 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so21873636wmi.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2017 05:06:44 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 1/3] xfs: fix the size of xfs_mode_to_ftype table
Date: Mon,  9 Jan 2017 15:06:27 +0200
Message-Id: <1483967189-27313-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Fix the size of the xfs_mode_to_ftype conversion table,
which was too small to handle an invalid value of mode=S_IFMT.

Use a convenience macro S_DT(mode) to convert from
mode to dirent file type and change the name of the table
to xfs_dtype_to_ftype to correctly describe its index values.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 18 +++++++++---------
 fs/xfs/libxfs/xfs_dir2.h |  4 +++-
 fs/xfs/xfs_iops.c        |  2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c58d72c..48d7c45 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -41,15 +41,15 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
  * for file type specification. This will be propagated into the directory
  * structure if appropriate for the given operation and filesystem config.
  */
-const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
-	[0]			= XFS_DIR3_FT_UNKNOWN,
-	[S_IFREG >> S_SHIFT]    = XFS_DIR3_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]    = XFS_DIR3_FT_DIR,
-	[S_IFCHR >> S_SHIFT]    = XFS_DIR3_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]    = XFS_DIR3_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]    = XFS_DIR3_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]   = XFS_DIR3_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]    = XFS_DIR3_FT_SYMLINK,
+const unsigned char xfs_dtype_to_ftype[S_DT_MAX+1] = {
+	[0]                = XFS_DIR3_FT_UNKNOWN,
+	[S_DT(S_IFREG)]    = XFS_DIR3_FT_REG_FILE,
+	[S_DT(S_IFDIR)]    = XFS_DIR3_FT_DIR,
+	[S_DT(S_IFCHR)]    = XFS_DIR3_FT_CHRDEV,
+	[S_DT(S_IFBLK)]    = XFS_DIR3_FT_BLKDEV,
+	[S_DT(S_IFIFO)]    = XFS_DIR3_FT_FIFO,
+	[S_DT(S_IFSOCK)]   = XFS_DIR3_FT_SOCK,
+	[S_DT(S_IFLNK)]    = XFS_DIR3_FT_SYMLINK,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0197590..4934d38 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,7 +35,9 @@ extern struct xfs_name	xfs_name_dotdot;
  * directory filetype conversion tables.
  */
 #define S_SHIFT 12
-extern const unsigned char xfs_mode_to_ftype[];
+#define S_DT(mode)     (((mode) & S_IFMT) >> S_SHIFT)
+#define S_DT_MAX       S_DT(S_IFMT)
+extern const unsigned char xfs_dtype_to_ftype[];
 
 /*
  * directory operations vector for encode/decode routines
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 308bebb..d2da9ca 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -103,7 +103,7 @@ xfs_dentry_to_name(
 {
 	namep->name = dentry->d_name.name;
 	namep->len = dentry->d_name.len;
-	namep->type = xfs_mode_to_ftype[(mode & S_IFMT) >> S_SHIFT];
+	namep->type = xfs_dtype_to_ftype[S_DT(mode)];
 }
 
 STATIC void
-- 
2.7.4

