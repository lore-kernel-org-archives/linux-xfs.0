Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19179 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbcI1Cza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:55:30 -0400
Subject: [PATCH 18/63] xfs: create bmbt update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:55:26 -0700
Message-ID: <147503132684.30303.3828588290721057828.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create bmbt update intent/done log items to record redo information in
the log.  Because we roll transactions multiple times for reflink
operations, we also have to track the status of the metadata updates
that will be recorded in the post-roll transactions in case we crash
before committing the final transaction.  This mechanism enables log
recovery to finish what was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Only allow one item per BUI to simpify inode locking during
recovery and to avoid exceeding the transaction reservation.
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_log_format.h |   59 ++++++
 fs/xfs/xfs_bmap_item.c         |  397 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.h         |   99 ++++++++++
 fs/xfs/xfs_super.c             |   18 ++
 5 files changed, 572 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_bmap_item.c
 create mode 100644 fs/xfs/xfs_bmap_item.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6a9ea9e..b850961 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -102,6 +102,7 @@ xfs-y				+= xfs_aops.o \
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
+				   xfs_bmap_item.o \
 				   xfs_buf_item.o \
 				   xfs_extfree_item.o \
 				   xfs_icreate_item.o \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 2428944..6db3366 100644
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
@@ -729,6 +735,55 @@ struct xfs_cud_log_format {
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
+	struct xfs_map_extent	bui_extents[];	/* array of extents to bmap */
+};
+
+static inline size_t
+xfs_bui_log_format_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_bui_log_format) +
+			nr * sizeof(struct xfs_map_extent);
+}
+
+/*
+ * This is the structure used to lay out an bud log item in the
+ * log.  The bud_extents array is a variable size array whose
+ * size is given by bud_nextents;
+ */
+struct xfs_bud_log_format {
+	__uint16_t		bud_type;	/* bud log item type */
+	__uint16_t		bud_size;	/* size of this item */
+	__uint32_t		__pad;
+	__uint64_t		bud_bui_id;	/* id of corresponding bui */
+};
+
+/*
  * Dquot Log format definitions.
  *
  * The first two fields must be the type and size fitting into
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
new file mode 100644
index 0000000..c93ff6f
--- /dev/null
+++ b/fs/xfs/xfs_bmap_item.c
@@ -0,0 +1,397 @@
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
+	kmem_zone_free(xfs_bui_zone, buip);
+}
+
+STATIC void
+xfs_bui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents);
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
+			xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents));
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
+	struct xfs_mount		*mp)
+
+{
+	struct xfs_bui_log_item		*buip;
+
+	buip = kmem_zone_zalloc(xfs_bui_zone, KM_SLEEP);
+
+	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
+	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
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
+	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
+
+	if (buf->i_len == len) {
+		memcpy(dst_bui_fmt, src_bui_fmt, len);
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
+xfs_bud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_bud_log_format);
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
+	budp->bud_format.bud_type = XFS_LI_BUD;
+	budp->bud_format.bud_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
+			sizeof(struct xfs_bud_log_format));
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
+		kmem_zone_free(xfs_bud_zone, budp);
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
+	kmem_zone_free(xfs_bud_zone, budp);
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
+	struct xfs_bui_log_item		*buip)
+
+{
+	struct xfs_bud_log_item	*budp;
+
+	budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
+	xfs_log_item_init(mp, &budp->bud_item, XFS_LI_BUD, &xfs_bud_item_ops);
+	budp->bud_buip = buip;
+	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
+
+	return budp;
+}
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
new file mode 100644
index 0000000..f7e2fa2
--- /dev/null
+++ b/fs/xfs/xfs_bmap_item.h
@@ -0,0 +1,99 @@
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
+#define	XFS_BUI_MAX_FAST_EXTENTS	1
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
+static inline size_t
+xfs_bui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_bui_log_item, bui_format) +
+			xfs_bui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "bmap update done" log item.  It is used to log the fact that
+ * some bmbt updates mentioned in an earlier bui item have been performed.
+ */
+struct xfs_bud_log_item {
+	struct xfs_log_item		bud_item;
+	struct xfs_bui_log_item		*bud_buip;
+	struct xfs_bud_log_format	bud_format;
+};
+
+extern struct kmem_zone	*xfs_bui_zone;
+extern struct kmem_zone	*xfs_bud_zone;
+
+struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
+struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
+		struct xfs_bui_log_item *);
+int xfs_bui_copy_format(struct xfs_log_iovec *buf,
+		struct xfs_bui_log_format *dst_bui_fmt);
+void xfs_bui_item_free(struct xfs_bui_log_item *);
+void xfs_bui_release(struct xfs_bui_log_item *);
+
+#endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6234622..071bae0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -48,6 +48,7 @@
 #include "xfs_ondisk.h"
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
+#include "xfs_bmap_item.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1800,8 +1801,23 @@ xfs_init_zones(void)
 	if (!xfs_cui_zone)
 		goto out_destroy_cud_zone;
 
+	xfs_bud_zone = kmem_zone_init(sizeof(struct xfs_bud_log_item),
+			"xfs_bud_item");
+	if (!xfs_bud_zone)
+		goto out_destroy_cui_zone;
+
+	xfs_bui_zone = kmem_zone_init(
+			xfs_bui_log_item_sizeof(XFS_BUI_MAX_FAST_EXTENTS),
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
@@ -1848,6 +1864,8 @@ xfs_destroy_zones(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_zone_destroy(xfs_bui_zone);
+	kmem_zone_destroy(xfs_bud_zone);
 	kmem_zone_destroy(xfs_cui_zone);
 	kmem_zone_destroy(xfs_cud_zone);
 	kmem_zone_destroy(xfs_rui_zone);

