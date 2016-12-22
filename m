Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36503 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938907AbcLVVnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 16:43:15 -0500
Received: by mail-wm0-f68.google.com with SMTP id m203so38326810wma.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 13:43:14 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] libxfs: fix the size of xfs_mode_to_ftype table
Date: Thu, 22 Dec 2016 23:42:54 +0200
Message-Id: <1482442974-22117-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Fix the size of the xfs_mode_to_ftype conversion table,
which was too small to handle a malformed on-disk value
of mode=S_IFMT.

Use a convenience macros S_DT(mode) to convert from
mode to dirent file type and change the name of the table
to xfs_dtype_to_ftype to correctly describe its index values.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 libxfs/xfs_dir2.c    | 17 ++++++++---------
 libxfs/xfs_dir2.h    |  4 +++-
 repair/dino_chunks.c |  3 +--
 repair/phase6.c      |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

Darrick,

This is the matcing patch to the kernel fix patch.

I used S_DT(S_IF*) values in this patch instead of DT_* values to
avoid complicating the build.

Assuming you want the kernel libxfs to stay in sync with this code
feel free to copy&paste the table chunk into the kernel patch I sent you
or I can re-send the kernel patch if you like.

Tested that xfs_repair detects and fixes wrong file type values.

Amir.

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 4180a93..8dd007d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -39,15 +39,14 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
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
+	[S_DT(S_IFREG)]    = XFS_DIR3_FT_REG_FILE,
+	[S_DT(S_IFDIR)]    = XFS_DIR3_FT_DIR,
+	[S_DT(S_IFCHR)]    = XFS_DIR3_FT_CHRDEV,
+	[S_DT(S_IFBLK)]    = XFS_DIR3_FT_BLKDEV,
+	[S_DT(S_IFIFO)]    = XFS_DIR3_FT_FIFO,
+	[S_DT(S_IFSOCK)]   = XFS_DIR3_FT_SOCK,
+	[S_DT(S_IFLNK)]    = XFS_DIR3_FT_SYMLINK,
 };
 
 /*
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 89b9e24..8eeaa0c 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 4db9512..dd893af 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -847,9 +847,8 @@ next_readbuf:
 			 * phase 6.
 			 */
 			di_mode = be16_to_cpu(dino->di_mode);
-			di_mode = (di_mode & S_IFMT) >> S_SHIFT;
 			set_inode_ftype(ino_rec, irec_offset,
-					xfs_mode_to_ftype[di_mode]);
+					xfs_dtype_to_ftype[S_DT(di_mode)]);
 
 			/*
 			 * store on-disk nlink count for comparing in phase 7
diff --git a/repair/phase6.c b/repair/phase6.c
index 06eed16..941fffc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1082,7 +1082,7 @@ mv_orphanage(
 	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
-	xname.type = xfs_mode_to_ftype[(VFS_I(ino_p)->i_mode & S_IFMT)>>S_SHIFT];
+	xname.type = xfs_dtype_to_ftype[S_DT(VFS_I(ino_p)->i_mode)];
 
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
-- 
2.7.4

