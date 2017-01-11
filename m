Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34983 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933746AbdAKIYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 03:24:35 -0500
Received: by mail-wm0-f67.google.com with SMTP id l2so35346556wml.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 00:24:35 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 4/6] xfs: replace xfs_mode_to_ftype table with switch statement
Date: Wed, 11 Jan 2017 10:24:08 +0200
Message-Id: <1484123050-11064-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

The size of the xfs_mode_to_ftype[] conversion table
was too small to handle an invalid value of mode=S_IFMT.

Instead of fixing the table size, replace the conversion table
with a conversion helper that uses a switch statement.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 36 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_dir2.h |  5 ++---
 fs/xfs/xfs_iops.c        |  2 +-
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 4f7913f..eb64f38 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -36,21 +36,29 @@
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
 /*
- * @mode, if set, indicates that the type field needs to be set up.
- * This uses the transformation from file mode to DT_* as defined in linux/fs.h
- * for file type specification. This will be propagated into the directory
- * structure if appropriate for the given operation and filesystem config.
+ * Convert inode mode to directory entry filetype
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
-};
+const unsigned char xfs_mode_to_ftype(int mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		return XFS_DIR3_FT_REG_FILE;
+	case S_IFDIR:
+		return XFS_DIR3_FT_DIR;
+	case S_IFCHR:
+		return XFS_DIR3_FT_CHRDEV;
+	case S_IFBLK:
+		return XFS_DIR3_FT_BLKDEV;
+	case S_IFIFO:
+		return XFS_DIR3_FT_FIFO;
+	case S_IFSOCK:
+		return XFS_DIR3_FT_SOCK;
+	case S_IFLNK:
+		return XFS_DIR3_FT_SYMLINK;
+	default:
+		return XFS_DIR3_FT_UNKNOWN;
+	}
+}
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 72df0dc..d4b77ab 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,10 +35,9 @@ struct xfs_dir2_data_unused;
 extern struct xfs_name	xfs_name_dotdot;
 
 /*
- * directory filetype conversion tables.
+ * Convert inode mode to directory entry filetype
  */
-#define S_SHIFT 12
-extern const unsigned char xfs_mode_to_ftype[];
+extern const unsigned char xfs_mode_to_ftype(int mode);
 
 /*
  * directory operations vector for encode/decode routines
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 308bebb..821f08d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -103,7 +103,7 @@ xfs_dentry_to_name(
 {
 	namep->name = dentry->d_name.name;
 	namep->len = dentry->d_name.len;
-	namep->type = xfs_mode_to_ftype[(mode & S_IFMT) >> S_SHIFT];
+	namep->type = xfs_mode_to_ftype(mode);
 }
 
 STATIC void
-- 
2.7.4

