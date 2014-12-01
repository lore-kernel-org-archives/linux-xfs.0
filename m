Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0F407F4E
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 17:23:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0B46304084
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 15:23:14 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GbLhpctGPj1ryRF5 for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 15:23:12 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvaEH-0003vN-9i
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvaEH-0005hm-8m
	for xfs@oss.sgi.com; Tue, 02 Dec 2014 10:18:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: move type conversion functions to xfs_dir.h
Date: Tue,  2 Dec 2014 10:18:03 +1100
Message-Id: <1417475883-21881-3-git-send-email-david@fromorbit.com>
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

These are currently considered private to libxfs, but they are
widely used by the userspace code to decode, walk and check
directory structures. Hence they really form part of the external
API and as such need to bemoved to xfs_dir2.h.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2.h      | 134 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_priv.h | 134 ------------------------------------------
 fs/xfs/xfs_export.c           |   1 +
 fs/xfs/xfs_log_recover.c      |   1 +
 fs/xfs/xfs_mount.c            |   1 +
 5 files changed, 137 insertions(+), 134 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 874720d..e553536 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -183,4 +183,138 @@ extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
 
+/*
+ * Directory offset/block conversion functions.
+ *
+ * DB blocks here are logical directory block numbers, not filesystem blocks.
+ */
+
+/*
+ * Convert dataptr to byte in file space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
+{
+	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
+}
+
+/*
+ * Convert byte in file space to dataptr.  It had better be aligned.
+ */
+static inline xfs_dir2_dataptr_t
+xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
+{
+	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
+}
+
+/*
+ * Convert byte in space to (DB) block
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_byte_to_db(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
+{
+	return (xfs_dir2_db_t)(by >> geo->blklog);
+}
+
+/*
+ * Convert dataptr to a block number
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_dataptr_to_db(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
+{
+	return xfs_dir2_byte_to_db(geo, xfs_dir2_dataptr_to_byte(dp));
+}
+
+/*
+ * Convert byte in space to offset in a block
+ */
+static inline xfs_dir2_data_aoff_t
+xfs_dir2_byte_to_off(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
+{
+	return (xfs_dir2_data_aoff_t)(by & (geo->blksize - 1));
+}
+
+/*
+ * Convert dataptr to a byte offset in a block
+ */
+static inline xfs_dir2_data_aoff_t
+xfs_dir2_dataptr_to_off(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
+{
+	return xfs_dir2_byte_to_off(geo, xfs_dir2_dataptr_to_byte(dp));
+}
+
+/*
+ * Convert block and offset to byte in space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_db_off_to_byte(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
+			xfs_dir2_data_aoff_t o)
+{
+	return ((xfs_dir2_off_t)db << geo->blklog) + o;
+}
+
+/*
+ * Convert block (DB) to block (dablk)
+ */
+static inline xfs_dablk_t
+xfs_dir2_db_to_da(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
+{
+	return (xfs_dablk_t)(db << (geo->blklog - geo->fsblog));
+}
+
+/*
+ * Convert byte in space to (DA) block
+ */
+static inline xfs_dablk_t
+xfs_dir2_byte_to_da(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
+{
+	return xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, by));
+}
+
+/*
+ * Convert block and offset to dataptr
+ */
+static inline xfs_dir2_dataptr_t
+xfs_dir2_db_off_to_dataptr(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
+			   xfs_dir2_data_aoff_t o)
+{
+	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(geo, db, o));
+}
+
+/*
+ * Convert block (dablk) to block (DB)
+ */
+static inline xfs_dir2_db_t
+xfs_dir2_da_to_db(struct xfs_da_geometry *geo, xfs_dablk_t da)
+{
+	return (xfs_dir2_db_t)(da >> (geo->blklog - geo->fsblog));
+}
+
+/*
+ * Convert block (dablk) to byte offset in space
+ */
+static inline xfs_dir2_off_t
+xfs_dir2_da_to_byte(struct xfs_da_geometry *geo, xfs_dablk_t da)
+{
+	return xfs_dir2_db_off_to_byte(geo, xfs_dir2_da_to_db(geo, da), 0);
+}
+
+/*
+ * Directory tail pointer accessor functions. Based on block geometry.
+ */
+static inline struct xfs_dir2_block_tail *
+xfs_dir2_block_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_data_hdr *hdr)
+{
+	return ((struct xfs_dir2_block_tail *)
+		((char *)hdr + geo->blksize)) - 1;
+}
+
+static inline struct xfs_dir2_leaf_tail *
+xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
+{
+	return (struct xfs_dir2_leaf_tail *)
+		((char *)lp + geo->blksize -
+		  sizeof(struct xfs_dir2_leaf_tail));
+}
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 27096ba..ef9f6ea 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -20,140 +20,6 @@
 
 struct dir_context;
 
-/*
- * Directory offset/block conversion functions.
- *
- * DB blocks here are logical directory block numbers, not filesystem blocks.
- */
-
-/*
- * Convert dataptr to byte in file space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
-{
-	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
-}
-
-/*
- * Convert byte in file space to dataptr.  It had better be aligned.
- */
-static inline xfs_dir2_dataptr_t
-xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
-{
-	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
-}
-
-/*
- * Convert byte in space to (DB) block
- */
-static inline xfs_dir2_db_t
-xfs_dir2_byte_to_db(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
-{
-	return (xfs_dir2_db_t)(by >> geo->blklog);
-}
-
-/*
- * Convert dataptr to a block number
- */
-static inline xfs_dir2_db_t
-xfs_dir2_dataptr_to_db(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
-{
-	return xfs_dir2_byte_to_db(geo, xfs_dir2_dataptr_to_byte(dp));
-}
-
-/*
- * Convert byte in space to offset in a block
- */
-static inline xfs_dir2_data_aoff_t
-xfs_dir2_byte_to_off(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
-{
-	return (xfs_dir2_data_aoff_t)(by & (geo->blksize - 1));
-}
-
-/*
- * Convert dataptr to a byte offset in a block
- */
-static inline xfs_dir2_data_aoff_t
-xfs_dir2_dataptr_to_off(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
-{
-	return xfs_dir2_byte_to_off(geo, xfs_dir2_dataptr_to_byte(dp));
-}
-
-/*
- * Convert block and offset to byte in space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_db_off_to_byte(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
-			xfs_dir2_data_aoff_t o)
-{
-	return ((xfs_dir2_off_t)db << geo->blklog) + o;
-}
-
-/*
- * Convert block (DB) to block (dablk)
- */
-static inline xfs_dablk_t
-xfs_dir2_db_to_da(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
-{
-	return (xfs_dablk_t)(db << (geo->blklog - geo->fsblog));
-}
-
-/*
- * Convert byte in space to (DA) block
- */
-static inline xfs_dablk_t
-xfs_dir2_byte_to_da(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
-{
-	return xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, by));
-}
-
-/*
- * Convert block and offset to dataptr
- */
-static inline xfs_dir2_dataptr_t
-xfs_dir2_db_off_to_dataptr(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
-			   xfs_dir2_data_aoff_t o)
-{
-	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(geo, db, o));
-}
-
-/*
- * Convert block (dablk) to block (DB)
- */
-static inline xfs_dir2_db_t
-xfs_dir2_da_to_db(struct xfs_da_geometry *geo, xfs_dablk_t da)
-{
-	return (xfs_dir2_db_t)(da >> (geo->blklog - geo->fsblog));
-}
-
-/*
- * Convert block (dablk) to byte offset in space
- */
-static inline xfs_dir2_off_t
-xfs_dir2_da_to_byte(struct xfs_da_geometry *geo, xfs_dablk_t da)
-{
-	return xfs_dir2_db_off_to_byte(geo, xfs_dir2_da_to_db(geo, da), 0);
-}
-
-/*
- * Directory tail pointer accessor functions. Based on block geometry.
- */
-static inline struct xfs_dir2_block_tail *
-xfs_dir2_block_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_data_hdr *hdr)
-{
-	return ((struct xfs_dir2_block_tail *)
-		((char *)hdr + geo->blksize)) - 1;
-}
-
-static inline struct xfs_dir2_leaf_tail *
-xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
-{
-	return (struct xfs_dir2_leaf_tail *)
-		((char *)lp + geo->blksize -
-		  sizeof(struct xfs_dir2_leaf_tail));
-}
-
 /* xfs_dir2.c */
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 0a0a6fa..5eb4a14 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_export.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 75705dd..a5a945f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -25,6 +25,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index aa5c75a..5ef9aa2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -25,6 +25,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_ialloc.h"
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
