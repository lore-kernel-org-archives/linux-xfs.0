Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33544 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966157AbcLVVHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 16:07:42 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4] xfs: fix the size of xfs_mode_to_ftype table
Date: Thu, 22 Dec 2016 23:07:21 +0200
Message-Id: <1482440841-10819-1-git-send-email-amir73il@gmail.com>
In-Reply-To: <1482343293-9028-1-git-send-email-amir73il@gmail.com>
References: <1482343293-9028-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Fix the size of the xfs_mode_to_ftype conversion table,
which was too small to handle a malformed on-disk value
of mode=S_IFMT.

Use a convenience macros S_DT(mode) to convert from
mode to dirent file type and change the name of the table
to xfs_dtype_to_ftype to correctly describe its index values.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 17 ++++++++---------
 fs/xfs/libxfs/xfs_dir2.h |  4 +++-
 fs/xfs/xfs_iops.c        |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

Darrick,

So my holiday season cleanup is now down to this one patch.
I pulled back the common code and added the needed macros in
xfs code, so this can be safely applied to xfsprogs as well.
I will send a patch to xfsprogs later.

Tested with generic/396 with -n ftype=0|1.

Amir.

v4:
- independent fix patch for xfs

v3:
- resort to simpler cleanup with macros DT_MAX and S_DT()
- mention the minor bug fix in commit message

v2:
- add private conversion from common to on-disk values

v1:
- use common conversion functions to get on-disk values

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c58d72c..539f498 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -41,15 +41,14 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
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
+const unsigned char xfs_dtype_to_ftype[S_DT_MAX] = {
+	[DT_REG]    = XFS_DIR3_FT_REG_FILE,
+	[DT_DIR]    = XFS_DIR3_FT_DIR,
+	[DT_CHR]    = XFS_DIR3_FT_CHRDEV,
+	[DT_BLK]    = XFS_DIR3_FT_BLKDEV,
+	[DT_FIFO]   = XFS_DIR3_FT_FIFO,
+	[DT_SOCK]   = XFS_DIR3_FT_SOCK,
+	[DT_LNK]    = XFS_DIR3_FT_SYMLINK,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0197590..a069c3e 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,7 +35,9 @@ extern struct xfs_name	xfs_name_dotdot;
  * directory filetype conversion tables.
  */
 #define S_SHIFT 12
-extern const unsigned char xfs_mode_to_ftype[];
+#define S_DT(mode)     (((mode) & S_IFMT) >> S_SHIFT)
+#define S_DT_MAX       (S_DT(S_IFMT) + 1)
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

