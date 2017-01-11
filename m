Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36512 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdAKGae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 01:30:34 -0500
Received: by mail-wj0-f196.google.com with SMTP id dh1so9252043wjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 22:30:33 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] xfsprogs: replace xfs_mode_to_ftype table with switch statement
Date: Wed, 11 Jan 2017 08:30:17 +0200
Message-Id: <1484116217-7594-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

The size of the xfs_mode_to_ftype[] conversion table
was too small to handle an invalid value of mode=S_IFMT.

Instead of fixing the table size, replace the conversion table
with a conversion helper that uses a switch statement.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 libxfs/xfs_dir2.c    | 36 ++++++++++++++++++++++--------------
 libxfs/xfs_dir2.h    |  5 ++---
 repair/dino_chunks.c |  6 +-----
 repair/phase6.c      |  2 +-
 4 files changed, 26 insertions(+), 23 deletions(-)

Eric,

This is a matching patch to the one that got Reviewed-by Darrick for kernel.

Tested xfs_repair with the new xfs/348 test with -n ftype=0|1.

Amir.

v3:
- Replaced xfs_mode_to_ftype table with switch statement

v2:
- remove wrong argument about on-disk malformed mode from commit message
- address Brian's review comments
- test with new xfs/348

v1:
- fix patch for xfsprogs derived from kernel patch

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 4180a93..257a99b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -34,21 +34,29 @@
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 89b9e24..ea20c12 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -32,10 +32,9 @@ struct xfs_dir2_data_unused;
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
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 4db9512..a3909ac 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -826,8 +826,6 @@ next_readbuf:
 		 * we do now, this is where to start.
 		 */
 		if (is_used)  {
-			__uint16_t	di_mode;
-
 			if (is_inode_free(ino_rec, irec_offset))  {
 				if (verbose || no_modify)  {
 					do_warn(
@@ -846,10 +844,8 @@ next_readbuf:
 			 * store the on-disk file type for comparing in
 			 * phase 6.
 			 */
-			di_mode = be16_to_cpu(dino->di_mode);
-			di_mode = (di_mode & S_IFMT) >> S_SHIFT;
 			set_inode_ftype(ino_rec, irec_offset,
-					xfs_mode_to_ftype[di_mode]);
+				xfs_mode_to_ftype(be16_to_cpu(dino->di_mode)));
 
 			/*
 			 * store on-disk nlink count for comparing in phase 7
diff --git a/repair/phase6.c b/repair/phase6.c
index 06eed16..c492dd9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1082,7 +1082,7 @@ mv_orphanage(
 	if ((err = -libxfs_iget(mp, NULL, ino, 0, &ino_p)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
-	xname.type = xfs_mode_to_ftype[(VFS_I(ino_p)->i_mode & S_IFMT)>>S_SHIFT];
+	xname.type = xfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
-- 
2.7.4

