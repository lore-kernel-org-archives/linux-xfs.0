Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A65C7F4E
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 17:23:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78099304084
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 15:23:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pcTx19Jf1jICRdAq for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 15:23:11 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvaEH-0003vM-97
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvaEH-0005hh-7m
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: move ftype conversion functions to libxfs
Date: Tue,  2 Dec 2014 10:18:02 +1100
Message-Id: <1417475883-21881-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1417475883-21881-1-git-send-email-david@fromorbit.com>
References: <1417475883-21881-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

These functions are needed in userspace for repair and mkfs to
do the right thing. Move them to libxfs so they can be easily
shared.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2.c      | 16 ++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h      |  6 ++++++
 fs/xfs/libxfs/xfs_dir2_priv.h |  6 ------
 fs/xfs/xfs_dir2_readdir.c     | 18 +-----------------
 fs/xfs/xfs_iops.c             |  2 +-
 5 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index d399f17..a69fb3a 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -34,6 +34,22 @@
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
+/*
+ * @mode, if set, indicates that the type field needs to be set up.
+ * This uses the transformation from file mode to DT_* as defined in linux/fs.h
+ * for file type specification. This will be propagated into the directory
+ * structure if appropriate for the given operation and filesystem config.
+ */
+const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
+	[0]			= XFS_DIR3_FT_UNKNOWN,
+	[S_IFREG >> S_SHIFT]    = XFS_DIR3_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]    = XFS_DIR3_FT_DIR,
+	[S_IFCHR >> S_SHIFT]    = XFS_DIR3_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]    = XFS_DIR3_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]    = XFS_DIR3_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]   = XFS_DIR3_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]    = XFS_DIR3_FT_SYMLINK,
+};
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4dff261..874720d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -32,6 +32,12 @@ struct xfs_dir2_data_unused;
 extern struct xfs_name	xfs_name_dotdot;
 
 /*
+ * directory filetype conversion tables.
+ */
+#define S_SHIFT 12
+extern const unsigned char xfs_mode_to_ftype[];
+
+/*
  * directory operations vector for encode/decode routines
  */
 struct xfs_dir_ops {
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 27ce079..27096ba 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -161,12 +161,6 @@ extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
-#define S_SHIFT 12
-extern const unsigned char xfs_mode_to_ftype[];
-
-extern unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp,
-					__uint8_t filetype);
-
 
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index b5a10d2..098cd78 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -41,7 +41,7 @@ static unsigned char xfs_dir3_filetype_table[] = {
 	DT_FIFO, DT_SOCK, DT_LNK, DT_WHT,
 };
 
-unsigned char
+static unsigned char
 xfs_dir3_get_dtype(
 	struct xfs_mount	*mp,
 	__uint8_t		filetype)
@@ -54,22 +54,6 @@ xfs_dir3_get_dtype(
 
 	return xfs_dir3_filetype_table[filetype];
 }
-/*
- * @mode, if set, indicates that the type field needs to be set up.
- * This uses the transformation from file mode to DT_* as defined in linux/fs.h
- * for file type specification. This will be propagated into the directory
- * structure if appropriate for the given operation and filesystem config.
- */
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
 
 STATIC int
 xfs_dir2_sf_getdents(
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f14a3e5..c50311c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -35,7 +35,7 @@
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
 #include "xfs_da_btree.h"
-#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 
 #include <linux/capability.h>
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
