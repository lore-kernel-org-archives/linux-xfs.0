Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 021CD7CB4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9011304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id tckMixS1TBn2tMgC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:20 -0700 (PDT)
Subject: [PATCH 069/119] xfs: create bmbt update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:25:14 -0700
Message-ID: <146612671397.12839.14026922023398231899.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Create bmbt update intent/done log items to record redo information in
the log.  Because we roll transactions multiple times for reflink
operations, we also have to track the status of the metadata updates
that will be recorded in the post-roll transactions in case we crash
before committing the final transaction.  This mechanism enables log
recovery to finish what was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_log_format.h |   52 ++++-
 fs/xfs/xfs_bmap_item.c         |  459 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.h         |   97 ++++++++
 fs/xfs/xfs_super.c             |   21 ++
 5 files changed, 628 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_bmap_item.c
 create mode 100644 fs/xfs/xfs_bmap_item.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 2945270..d2ce5db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -103,6 +103,7 @@ xfs-y				+= xfs_aops.o \
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
+				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
 				   xfs_extfree_item.o \
 				   xfs_icreate_item.o \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 923b08f..320a305 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -114,7 +114,9 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_RUD_FORMAT	22
 #define XLOG_REG_TYPE_CUI_FORMAT	23
 #define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_MAX		24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_MAX		26
 
 /*
  * Flags to log operation header
@@ -235,6 +237,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_RUD		0x1241
 #define	XFS_LI_CUI		0x1242	/* refcount update intent */
 #define	XFS_LI_CUD		0x1243
+#define	XFS_LI_BUI		0x1244	/* bmbt update intent */
+#define	XFS_LI_BUD		0x1245
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -248,7 +252,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
 	{ XFS_LI_RUD,		"XFS_LI_RUD" }, \
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
-	{ XFS_LI_CUD,		"XFS_LI_CUD" }
+	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
+	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -717,6 +723,48 @@ struct xfs_cud_log_format {
 };
 
 /*
+ * BUI/BUD (inode block mapping) log format definitions
+ */
+
+/* bmbt me_flags: upper bits are flags, lower byte is type code */
+#define XFS_BMAP_EXTENT_MAP		1
+#define XFS_BMAP_EXTENT_UNMAP		2
+#define XFS_BMAP_EXTENT_TYPE_MASK	0xFF
+
+#define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
+#define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+
+#define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
+					 XFS_BMAP_EXTENT_ATTR_FORK | \
+					 XFS_BMAP_EXTENT_UNWRITTEN)
+
+/*
+ * This is the structure used to lay out an bui log item in the
+ * log.  The bui_extents field is a variable size array whose
+ * size is given by bui_nextents.
+ */
+struct xfs_bui_log_format {
+	__uint16_t		bui_type;	/* bui log item type */
+	__uint16_t		bui_size;	/* size of this item */
+	__uint32_t		bui_nextents;	/* # extents to free */
+	__uint64_t		bui_id;		/* bui identifier */
+	struct xfs_map_extent	bui_extents[1];	/* array of extents to bmap */
+};
+
+/*
+ * This is the structure used to lay out an bud log item in the
+ * log.  The bud_extents array is a variable size array whose
+ * size is given by bud_nextents;
+ */
+struct xfs_bud_log_format {
+	__uint16_t		bud_type;	/* bud log item type */
+	__uint16_t		bud_size;	/* size of this item */
+	__uint32_t		bud_nextents;	/* # of extents freed */
+	__uint64_t		bud_bui_id;	/* id of corresponding bui */
+	struct xfs_map_extent	bud_extents[1];	/* array of extents bmapped */
+};
+
+/*
  * Dquot Log format definitions.
  *
  * The first two fields must be the type and size fitting into
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
new file mode 100644
index 0000000..19bd7dd
--- /dev/null
+++ b/fs/xfs/xfs_bmap_item.c
@@ -0,0 +1,459 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_log.h"
+
+
+kmem_zone_t	*xfs_bui_zone;
+kmem_zone_t	*xfs_bud_zone;
+
+static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_bui_log_item, bui_item);
+}
+
+void
+xfs_bui_item_free(
+	struct xfs_bui_log_item	*buip)
+{
+	if (buip->bui_format.bui_nextents > XFS_BUI_MAX_FAST_EXTENTS)
+		kmem_free(buip);
+	else
+		kmem_zone_free(xfs_bui_zone, buip);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given bui item.
+ * We only need 1 iovec for an bui item.  It just logs the bui_log_format
+ * structure.
+ */
+static inline int
+xfs_bui_item_sizeof(
+	struct xfs_bui_log_item *buip)
+{
+	return sizeof(struct xfs_bui_log_format) +
+			(buip->bui_format.bui_nextents - 1) *
+			sizeof(struct xfs_map_extent);
+}
+
+STATIC void
+xfs_bui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += xfs_bui_item_sizeof(BUI_ITEM(lip));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given bui log item. We use only 1 iovec, and we point that
+ * at the bui_log_format structure embedded in the bui item.
+ * It is at this point that we assert that all of the extent
+ * slots in the bui item have been filled.
+ */
+STATIC void
+xfs_bui_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	ASSERT(atomic_read(&buip->bui_next_extent) ==
+			buip->bui_format.bui_nextents);
+
+	buip->bui_format.bui_type = XFS_LI_BUI;
+	buip->bui_format.bui_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
+			xfs_bui_item_sizeof(buip));
+}
+
+/*
+ * Pinning has no meaning for an bui item, so just return.
+ */
+STATIC void
+xfs_bui_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * The unpin operation is the last place an BUI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the BUI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the BUI to either construct
+ * and commit the BUD or drop the BUD's reference in the event of error. Simply
+ * drop the log's BUI reference now that the log is done with it.
+ */
+STATIC void
+xfs_bui_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+
+	xfs_bui_release(buip);
+}
+
+/*
+ * BUI items have no locking or pushing.  However, since BUIs are pulled from
+ * the AIL when their corresponding BUDs are committed to disk, their situation
+ * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
+ * will eventually flush the log.  This should help in getting the BUI out of
+ * the AIL.
+ */
+STATIC uint
+xfs_bui_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The BUI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an BUD isn't going to be
+ * constructed and thus we free the BUI here directly.
+ */
+STATIC void
+xfs_bui_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_bui_item_free(BUI_ITEM(lip));
+}
+
+/*
+ * The BUI is logged only once and cannot be moved in the log, so simply return
+ * the lsn at which it's been logged.
+ */
+STATIC xfs_lsn_t
+xfs_bui_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	return lsn;
+}
+
+/*
+ * The BUI dependency tracking op doesn't do squat.  It can't because
+ * it doesn't know where the free extent is coming from.  The dependency
+ * tracking has to be handled by the "enclosing" metadata object.  For
+ * example, for inodes, the inode is locked throughout the extent freeing
+ * so the dependency should be recorded there.
+ */
+STATIC void
+xfs_bui_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all bui log items.
+ */
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_pin	= xfs_bui_item_pin,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_unlock	= xfs_bui_item_unlock,
+	.iop_committed	= xfs_bui_item_committed,
+	.iop_push	= xfs_bui_item_push,
+	.iop_committing = xfs_bui_item_committing,
+};
+
+/*
+ * Allocate and initialize an bui item with the given number of extents.
+ */
+struct xfs_bui_log_item *
+xfs_bui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_bui_log_item		*buip;
+	uint				size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_BUI_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_bui_log_item) +
+			((nextents - 1) * sizeof(struct xfs_map_extent)));
+		buip = kmem_zalloc(size, KM_SLEEP);
+	} else {
+		buip = kmem_zone_zalloc(xfs_bui_zone, KM_SLEEP);
+	}
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = nextents;
+	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
+	atomic_set(&buip->bui_next_extent, 0);
+	atomic_set(&buip->bui_refcount, 2);
+
+	return buip;
+}
+
+/*
+ * Copy an BUI format buffer from the given buf, and into the destination
+ * BUI format structure.  The BUI/BUD items were designed not to need any
+ * special alignment handling.
+ */
+int
+xfs_bui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_bui_log_format	*dst_bui_fmt)
+{
+	struct xfs_bui_log_format	*src_bui_fmt;
+	uint				len;
+
+	src_bui_fmt = buf->i_addr;
+	len = sizeof(struct xfs_bui_log_format) +
+			(src_bui_fmt->bui_nextents - 1) *
+			sizeof(struct xfs_map_extent);
+
+	if (buf->i_len == len) {
+		memcpy((char *)dst_bui_fmt, (char *)src_bui_fmt, len);
+		return 0;
+	}
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Freeing the BUI requires that we remove it from the AIL if it has already
+ * been placed there. However, the BUI may not yet have been placed in the AIL
+ * when called by xfs_bui_release() from BUD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the BUI.
+ */
+void
+xfs_bui_release(
+	struct xfs_bui_log_item	*buip)
+{
+	if (atomic_dec_and_test(&buip->bui_refcount)) {
+		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_bui_item_free(buip);
+	}
+}
+
+static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_bud_log_item, bud_item);
+}
+
+STATIC void
+xfs_bud_item_free(struct xfs_bud_log_item *budp)
+{
+	if (budp->bud_format.bud_nextents > XFS_BUD_MAX_FAST_EXTENTS)
+		kmem_free(budp);
+	else
+		kmem_zone_free(xfs_bud_zone, budp);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given bud item.
+ * We only need 1 iovec for an bud item.  It just logs the bud_log_format
+ * structure.
+ */
+static inline int
+xfs_bud_item_sizeof(
+	struct xfs_bud_log_item	*budp)
+{
+	return sizeof(struct xfs_bud_log_format) +
+			(budp->bud_format.bud_nextents - 1) *
+			sizeof(struct xfs_map_extent);
+}
+
+STATIC void
+xfs_bud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += xfs_bud_item_sizeof(BUD_ITEM(lip));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given bud log item. We use only 1 iovec, and we point that
+ * at the bud_log_format structure embedded in the bud item.
+ * It is at this point that we assert that all of the extent
+ * slots in the bud item have been filled.
+ */
+STATIC void
+xfs_bud_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	ASSERT(budp->bud_next_extent == budp->bud_format.bud_nextents);
+
+	budp->bud_format.bud_type = XFS_LI_BUD;
+	budp->bud_format.bud_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
+			xfs_bud_item_sizeof(budp));
+}
+
+/*
+ * Pinning has no meaning for an bud item, so just return.
+ */
+STATIC void
+xfs_bud_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * Since pinning has no meaning for an bud item, unpinning does
+ * not either.
+ */
+STATIC void
+xfs_bud_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+}
+
+/*
+ * There isn't much you can do to push on an bud item.  It is simply stuck
+ * waiting for the log to be flushed to disk.
+ */
+STATIC uint
+xfs_bud_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The BUD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the BUI and free the
+ * BUD.
+ */
+STATIC void
+xfs_bud_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
+
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		xfs_bui_release(budp->bud_buip);
+		xfs_bud_item_free(budp);
+	}
+}
+
+/*
+ * When the bud item is committed to disk, all we need to do is delete our
+ * reference to our partner bui item and then free ourselves. Since we're
+ * freeing ourselves we must return -1 to keep the transaction code from
+ * further referencing this item.
+ */
+STATIC xfs_lsn_t
+xfs_bud_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
+
+	/*
+	 * Drop the BUI reference regardless of whether the BUD has been
+	 * aborted. Once the BUD transaction is constructed, it is the sole
+	 * responsibility of the BUD to release the BUI (even if the BUI is
+	 * aborted due to log I/O error).
+	 */
+	xfs_bui_release(budp->bud_buip);
+	xfs_bud_item_free(budp);
+
+	return (xfs_lsn_t)-1;
+}
+
+/*
+ * The BUD dependency tracking op doesn't do squat.  It can't because
+ * it doesn't know where the free extent is coming from.  The dependency
+ * tracking has to be handled by the "enclosing" metadata object.  For
+ * example, for inodes, the inode is locked throughout the extent freeing
+ * so the dependency should be recorded there.
+ */
+STATIC void
+xfs_bud_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all bud log items.
+ */
+static const struct xfs_item_ops xfs_bud_item_ops = {
+	.iop_size	= xfs_bud_item_size,
+	.iop_format	= xfs_bud_item_format,
+	.iop_pin	= xfs_bud_item_pin,
+	.iop_unpin	= xfs_bud_item_unpin,
+	.iop_unlock	= xfs_bud_item_unlock,
+	.iop_committed	= xfs_bud_item_committed,
+	.iop_push	= xfs_bud_item_push,
+	.iop_committing = xfs_bud_item_committing,
+};
+
+/*
+ * Allocate and initialize an bud item with the given number of extents.
+ */
+struct xfs_bud_log_item *
+xfs_bud_init(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip,
+	uint				nextents)
+
+{
+	struct xfs_bud_log_item	*budp;
+	uint			size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_BUD_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_bud_log_item) +
+			((nextents - 1) * sizeof(struct xfs_map_extent)));
+		budp = kmem_zalloc(size, KM_SLEEP);
+	} else {
+		budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
+	}
+
+	xfs_log_item_init(mp, &budp->bud_item, XFS_LI_BUD, &xfs_bud_item_ops);
+	budp->bud_buip = buip;
+	budp->bud_format.bud_nextents = nextents;
+	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
+
+	return budp;
+}
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
new file mode 100644
index 0000000..a992c09
--- /dev/null
+++ b/fs/xfs/xfs_bmap_item.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef	__XFS_BMAP_ITEM_H__
+#define	__XFS_BMAP_ITEM_H__
+
+/*
+ * There are (currently) two pairs of bmap btree redo item types: map & unmap.
+ * The common abbreviations for these are BUI (bmap update intent) and BUD
+ * (bmap update done).  The redo item type is encoded in the flags field of
+ * each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * bmbt metadata updates in the non-first transaction.
+ */
+
+/* kernel only BUI/BUD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_BUI_MAX_FAST_EXTENTS	16
+
+/*
+ * Define BUI flag bits. Manipulated by set/clear/test_bit operators.
+ */
+#define	XFS_BUI_RECOVERED		1
+
+/*
+ * This is the "bmap update intent" log item.  It is used to log the fact that
+ * some reverse mappings need to change.  It is used in conjunction with the
+ * "bmap update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_bui_log_item {
+	struct xfs_log_item		bui_item;
+	atomic_t			bui_refcount;
+	atomic_t			bui_next_extent;
+	unsigned long			bui_flags;	/* misc flags */
+	struct xfs_bui_log_format	bui_format;
+};
+
+/*
+ * This is the "bmap update done" log item.  It is used to log the fact that
+ * some bmbt updates mentioned in an earlier bui item have been performed.
+ */
+struct xfs_bud_log_item {
+	struct xfs_log_item		bud_item;
+	struct xfs_bui_log_item		*bud_buip;
+	uint				bud_next_extent;
+	struct xfs_bud_log_format	bud_format;
+};
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_BUD_MAX_FAST_EXTENTS	16
+
+extern struct kmem_zone	*xfs_bui_zone;
+extern struct kmem_zone	*xfs_bud_zone;
+
+struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *, uint);
+struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
+		struct xfs_bui_log_item *, uint);
+int xfs_bui_copy_format(struct xfs_log_iovec *buf,
+		struct xfs_bui_log_format *dst_bui_fmt);
+void xfs_bui_item_free(struct xfs_bui_log_item *);
+void xfs_bui_release(struct xfs_bui_log_item *);
+
+#endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a0c7bdc..18f74b3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,7 @@
 #include "xfs_defer.h"
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
+#include "xfs_bmap_item.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1796,8 +1797,26 @@ xfs_init_zones(void)
 	if (!xfs_cui_zone)
 		goto out_destroy_cud_zone;
 
+	xfs_bud_zone = kmem_zone_init((sizeof(struct xfs_bud_log_item) +
+			((XFS_BUD_MAX_FAST_EXTENTS - 1) *
+				 sizeof(struct xfs_map_extent))),
+			"xfs_bud_item");
+	if (!xfs_bud_zone)
+		goto out_destroy_cui_zone;
+
+	xfs_bui_zone = kmem_zone_init((sizeof(struct xfs_bui_log_item) +
+			((XFS_BUI_MAX_FAST_EXTENTS - 1) *
+				sizeof(struct xfs_map_extent))),
+			"xfs_bui_item");
+	if (!xfs_bui_zone)
+		goto out_destroy_bud_zone;
+
 	return 0;
 
+ out_destroy_bud_zone:
+	kmem_zone_destroy(xfs_bud_zone);
+ out_destroy_cui_zone:
+	kmem_zone_destroy(xfs_cui_zone);
  out_destroy_cud_zone:
 	kmem_zone_destroy(xfs_cud_zone);
  out_destroy_rui_zone:
@@ -1844,6 +1863,8 @@ xfs_destroy_zones(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_zone_destroy(xfs_bui_zone);
+	kmem_zone_destroy(xfs_bud_zone);
 	kmem_zone_destroy(xfs_cui_zone);
 	kmem_zone_destroy(xfs_cud_zone);
 	kmem_zone_destroy(xfs_rui_zone);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
