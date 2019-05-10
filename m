Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/11] libxfs: create new file buf_item.c
Date: Fri, 10 May 2019 15:18:26 -0500
Message-Id: <1557519510-10602-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Pull functions out of libxfs/* into buf_item.c, if they roughly match
the kernel's xfs_buf_item.c file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/Makefile      |   1 +
 libxfs/buf_item.c    | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |   2 +
 libxfs/logitem.c     |  77 ---------------------------
 libxfs/trans.c       |  55 -------------------
 5 files changed, 149 insertions(+), 132 deletions(-)
 create mode 100644 libxfs/buf_item.c

diff --git a/libxfs/Makefile b/libxfs/Makefile
index da0ce79..820ffb0 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -52,6 +52,7 @@ HFILES = \
 	xfs_dir2_priv.h
 
 CFILES = cache.c \
+	buf_item.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
diff --git a/libxfs/buf_item.c b/libxfs/buf_item.c
new file mode 100644
index 0000000..2e64c8c
--- /dev/null
+++ b/libxfs/buf_item.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+
+kmem_zone_t	*xfs_buf_item_zone;
+
+/*
+ * The following are from fs/xfs/xfs_buf_item.c
+ */
+
+void
+xfs_buf_item_put(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	bp->b_log_item = NULL;
+	kmem_zone_free(xfs_buf_item_zone, bip);
+}
+
+void
+buf_item_unlock(
+	xfs_buf_log_item_t	*bip)
+{
+	xfs_buf_t		*bp = bip->bli_buf;
+	uint			hold;
+
+	/* Clear the buffer's association with this transaction. */
+	bip->bli_buf->b_transp = NULL;
+
+	hold = bip->bli_flags & XFS_BLI_HOLD;
+	bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
+	if (!hold)
+		libxfs_putbuf(bp);
+}
+
+/*
+ * Allocate a new buf log item to go with the given buffer.
+ * Set the buffer's b_log_item field to point to the new
+ * buf log item.  If there are other item's attached to the
+ * buffer (see xfs_buf_attach_iodone() below), then put the
+ * buf log item at the front.
+ */
+void
+xfs_buf_item_init(
+	xfs_buf_t		*bp,
+	xfs_mount_t		*mp)
+{
+	xfs_log_item_t		*lip;
+	xfs_buf_log_item_t	*bip;
+
+#ifdef LI_DEBUG
+	fprintf(stderr, "buf_item_init for buffer %p\n", bp);
+#endif
+
+	/*
+	 * Check to see if there is already a buf log item for
+	 * this buffer.	 If there is, it is guaranteed to be
+	 * the first.  If we do already have one, there is
+	 * nothing to do here so return.
+	 */
+	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
+	if (bp->b_log_item != NULL) {
+		lip = bp->b_log_item;
+		if (lip->li_type == XFS_LI_BUF) {
+#ifdef LI_DEBUG
+			fprintf(stderr,
+				"reused buf item %p for pre-logged buffer %p\n",
+				lip, bp);
+#endif
+			return;
+		}
+	}
+
+	bip = (xfs_buf_log_item_t *)kmem_zone_zalloc(xfs_buf_item_zone,
+						    KM_SLEEP);
+#ifdef LI_DEBUG
+	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
+		bip, bp);
+#endif
+	bip->bli_item.li_type = XFS_LI_BUF;
+	bip->bli_item.li_mountp = mp;
+	INIT_LIST_HEAD(&bip->bli_item.li_trans);
+	bip->bli_buf = bp;
+	bip->bli_format.blf_type = XFS_LI_BUF;
+	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
+	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
+	bp->b_log_item = bip;
+}
+
+/*
+ * Mark bytes first through last inclusive as dirty in the buf
+ * item's bitmap.
+ */
+void
+xfs_buf_item_log(
+	xfs_buf_log_item_t	*bip,
+	uint			first,
+	uint			last)
+{
+	/*
+	 * Mark the item as having some dirty data for
+	 * quick reference in xfs_buf_item_dirty.
+	 */
+	bip->bli_flags |= XFS_BLI_DIRTY;
+}
+
+void
+buf_item_done(
+	xfs_buf_log_item_t	*bip)
+{
+	xfs_buf_t		*bp;
+	int			hold;
+
+	bp = bip->bli_buf;
+	ASSERT(bp != NULL);
+	bp->b_transp = NULL;			/* remove xact ptr */
+
+	hold = (bip->bli_flags & XFS_BLI_HOLD);
+	if (bip->bli_flags & XFS_BLI_DIRTY) {
+#ifdef XACT_DEBUG
+		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
+			bp, hold);
+#endif
+		libxfs_writebuf_int(bp, 0);
+	}
+
+	bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
+	if (hold)
+		return;
+	libxfs_putbuf(bp);
+}
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7c07188..155b782 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -520,6 +520,8 @@ void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 void xfs_buf_item_put(struct xfs_buf_log_item *bip);
+void buf_item_unlock(struct xfs_buf_log_item *bip);
+void buf_item_done(struct xfs_buf_log_item *bip);
 
 /* xfs_trans_buf.c */
 struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index ce34c68..c80e2ed 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,86 +16,9 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
-kmem_zone_t	*xfs_buf_item_zone;
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
 
 /*
- * The following are from fs/xfs/xfs_buf_item.c
- */
-
-/*
- * Allocate a new buf log item to go with the given buffer.
- * Set the buffer's b_log_item field to point to the new
- * buf log item.  If there are other item's attached to the
- * buffer (see xfs_buf_attach_iodone() below), then put the
- * buf log item at the front.
- */
-void
-xfs_buf_item_init(
-	xfs_buf_t		*bp,
-	xfs_mount_t		*mp)
-{
-	xfs_log_item_t		*lip;
-	xfs_buf_log_item_t	*bip;
-
-#ifdef LI_DEBUG
-	fprintf(stderr, "buf_item_init for buffer %p\n", bp);
-#endif
-
-	/*
-	 * Check to see if there is already a buf log item for
-	 * this buffer.	 If there is, it is guaranteed to be
-	 * the first.  If we do already have one, there is
-	 * nothing to do here so return.
-	 */
-	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
-	if (bp->b_log_item != NULL) {
-		lip = bp->b_log_item;
-		if (lip->li_type == XFS_LI_BUF) {
-#ifdef LI_DEBUG
-			fprintf(stderr,
-				"reused buf item %p for pre-logged buffer %p\n",
-				lip, bp);
-#endif
-			return;
-		}
-	}
-
-	bip = (xfs_buf_log_item_t *)kmem_zone_zalloc(xfs_buf_item_zone,
-						    KM_SLEEP);
-#ifdef LI_DEBUG
-	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
-		bip, bp);
-#endif
-	bip->bli_item.li_type = XFS_LI_BUF;
-	bip->bli_item.li_mountp = mp;
-	INIT_LIST_HEAD(&bip->bli_item.li_trans);
-	bip->bli_buf = bp;
-	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
-	bp->b_log_item = bip;
-}
-
-
-/*
- * Mark bytes first through last inclusive as dirty in the buf
- * item's bitmap.
- */
-void
-xfs_buf_item_log(
-	xfs_buf_log_item_t	*bip,
-	uint			first,
-	uint			last)
-{
-	/*
-	 * Mark the item as having some dirty data for
-	 * quick reference in xfs_buf_item_dirty.
-	 */
-	bip->bli_flags |= XFS_BLI_DIRTY;
-}
-
-/*
  * Initialize the inode log item for a newly allocated (in-core) inode.
  */
 void
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 295f167..7d3899c 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -422,16 +422,6 @@ xfs_trans_roll_inode(
 	return error;
 }
 
-void
-xfs_buf_item_put(
-	struct xfs_buf_log_item	*bip)
-{
-	struct xfs_buf		*bp = bip->bli_buf;
-
-	bp->b_log_item = NULL;
-	kmem_zone_free(xfs_buf_item_zone, bip);
-}
-
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
@@ -548,34 +538,6 @@ free:
 }
 
 static void
-buf_item_done(
-	xfs_buf_log_item_t	*bip)
-{
-	xfs_buf_t		*bp;
-	int			hold;
-	extern kmem_zone_t	*xfs_buf_item_zone;
-
-	bp = bip->bli_buf;
-	ASSERT(bp != NULL);
-	bp->b_transp = NULL;			/* remove xact ptr */
-
-	hold = (bip->bli_flags & XFS_BLI_HOLD);
-	if (bip->bli_flags & XFS_BLI_DIRTY) {
-#ifdef XACT_DEBUG
-		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
-			bp, hold);
-#endif
-		libxfs_writebuf_int(bp, 0);
-	}
-
-	bip->bli_flags &= ~XFS_BLI_HOLD;
-	xfs_buf_item_put(bip);
-	if (hold)
-		return;
-	libxfs_putbuf(bp);
-}
-
-static void
 trans_committed(
 	xfs_trans_t		*tp)
 {
@@ -597,23 +559,6 @@ trans_committed(
 }
 
 static void
-buf_item_unlock(
-	xfs_buf_log_item_t	*bip)
-{
-	xfs_buf_t		*bp = bip->bli_buf;
-	uint			hold;
-
-	/* Clear the buffer's association with this transaction. */
-	bip->bli_buf->b_transp = NULL;
-
-	hold = bip->bli_flags & XFS_BLI_HOLD;
-	bip->bli_flags &= ~XFS_BLI_HOLD;
-	xfs_buf_item_put(bip);
-	if (!hold)
-		libxfs_putbuf(bp);
-}
-
-static void
 inode_item_unlock(
 	xfs_inode_log_item_t	*iip)
 {
-- 
1.8.3.1
