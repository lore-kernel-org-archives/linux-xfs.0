Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 535D17CB4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:24:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 074638F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uSJBJpuHXHXGqi5V (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:24:28 -0700 (PDT)
Subject: [PATCH 061/119] xfs: create refcount update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:24:22 -0700
Message-ID: <146612666207.12839.4040372869535080968.stgit@birch.djwong.org>
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

Create refcount update intent/done log items to record redo
information in the log.  Because we need to roll transactions between
updating the bmbt mapping and updating the reverse mapping, we also
have to track the status of the metadata updates that will be recorded
in the post-roll transactions, just in case we crash before committing
the final transaction.  This mechanism enables log recovery to finish
what was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_log_format.h |   52 ++++-
 fs/xfs/xfs_refcount_item.c     |  459 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.h     |  100 +++++++++
 fs/xfs/xfs_super.c             |   21 ++
 5 files changed, 631 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_refcount_item.c
 create mode 100644 fs/xfs/xfs_refcount_item.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e0c3067..322c386 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -107,6 +107,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_extfree_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
+				   xfs_refcount_item.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b9627b7..1dfa02c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -112,7 +112,9 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_ICREATE		20
 #define XLOG_REG_TYPE_RUI_FORMAT	21
 #define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_MAX		22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_MAX		24
 
 /*
  * Flags to log operation header
@@ -231,6 +233,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_ICREATE		0x123f
 #define	XFS_LI_RUI		0x1240	/* rmap update intent */
 #define	XFS_LI_RUD		0x1241
+#define	XFS_LI_CUI		0x1242	/* refcount update intent */
+#define	XFS_LI_CUD		0x1243
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -242,7 +246,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
 	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }, \
 	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
-	{ XFS_LI_RUD,		"XFS_LI_RUD" }
+	{ XFS_LI_RUD,		"XFS_LI_RUD" }, \
+	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
+	{ XFS_LI_CUD,		"XFS_LI_CUD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -667,6 +673,48 @@ struct xfs_rud_log_format {
 };
 
 /*
+ * CUI/CUD (refcount update) log format definitions
+ */
+struct xfs_phys_extent {
+	__uint64_t		pe_startblock;
+	__uint32_t		pe_len;
+	__uint32_t		pe_flags;
+};
+
+/* refcount pe_flags: upper bits are flags, lower byte is type code */
+#define XFS_REFCOUNT_EXTENT_INCREASE	1
+#define XFS_REFCOUNT_EXTENT_DECREASE	2
+#define XFS_REFCOUNT_EXTENT_ALLOC_COW	3
+#define XFS_REFCOUNT_EXTENT_FREE_COW	4
+#define XFS_REFCOUNT_EXTENT_TYPE_MASK	0xFF
+
+/*
+ * This is the structure used to lay out a cui log item in the
+ * log.  The cui_extents field is a variable size array whose
+ * size is given by cui_nextents.
+ */
+struct xfs_cui_log_format {
+	__uint16_t		cui_type;	/* cui log item type */
+	__uint16_t		cui_size;	/* size of this item */
+	__uint32_t		cui_nextents;	/* # extents to free */
+	__uint64_t		cui_id;		/* cui identifier */
+	struct xfs_phys_extent	cui_extents[1];	/* array of extents */
+};
+
+/*
+ * This is the structure used to lay out a cud log item in the
+ * log.  The cud_extents array is a variable size array whose
+ * size is given by cud_nextents;
+ */
+struct xfs_cud_log_format {
+	__uint16_t		cud_type;	/* cud log item type */
+	__uint16_t		cud_size;	/* size of this item */
+	__uint32_t		cud_nextents;	/* # of extents freed */
+	__uint64_t		cud_cui_id;	/* id of corresponding cui */
+	struct xfs_phys_extent	cud_extents[1];	/* array of extents */
+};
+
+/*
  * Dquot Log format definitions.
  *
  * The first two fields must be the type and size fitting into
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
new file mode 100644
index 0000000..681d068
--- /dev/null
+++ b/fs/xfs/xfs_refcount_item.c
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
+#include "xfs_refcount_item.h"
+#include "xfs_log.h"
+
+
+kmem_zone_t	*xfs_cui_zone;
+kmem_zone_t	*xfs_cud_zone;
+
+static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_cui_log_item, cui_item);
+}
+
+void
+xfs_cui_item_free(
+	struct xfs_cui_log_item	*cuip)
+{
+	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
+		kmem_free(cuip);
+	else
+		kmem_zone_free(xfs_cui_zone, cuip);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given cui item.
+ * We only need 1 iovec for an cui item.  It just logs the cui_log_format
+ * structure.
+ */
+static inline int
+xfs_cui_item_sizeof(
+	struct xfs_cui_log_item *cuip)
+{
+	return sizeof(struct xfs_cui_log_format) +
+			(cuip->cui_format.cui_nextents - 1) *
+			sizeof(struct xfs_phys_extent);
+}
+
+STATIC void
+xfs_cui_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += xfs_cui_item_sizeof(CUI_ITEM(lip));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given cui log item. We use only 1 iovec, and we point that
+ * at the cui_log_format structure embedded in the cui item.
+ * It is at this point that we assert that all of the extent
+ * slots in the cui item have been filled.
+ */
+STATIC void
+xfs_cui_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	ASSERT(atomic_read(&cuip->cui_next_extent) ==
+			cuip->cui_format.cui_nextents);
+
+	cuip->cui_format.cui_type = XFS_LI_CUI;
+	cuip->cui_format.cui_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
+			xfs_cui_item_sizeof(cuip));
+}
+
+/*
+ * Pinning has no meaning for an cui item, so just return.
+ */
+STATIC void
+xfs_cui_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * The unpin operation is the last place an CUI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the CUI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the CUI to either construct
+ * and commit the CUD or drop the CUD's reference in the event of error. Simply
+ * drop the log's CUI reference now that the log is done with it.
+ */
+STATIC void
+xfs_cui_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+
+	xfs_cui_release(cuip);
+}
+
+/*
+ * CUI items have no locking or pushing.  However, since CUIs are pulled from
+ * the AIL when their corresponding CUDs are committed to disk, their situation
+ * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
+ * will eventually flush the log.  This should help in getting the CUI out of
+ * the AIL.
+ */
+STATIC uint
+xfs_cui_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The CUI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an CUD isn't going to be
+ * constructed and thus we free the CUI here directly.
+ */
+STATIC void
+xfs_cui_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_cui_item_free(CUI_ITEM(lip));
+}
+
+/*
+ * The CUI is logged only once and cannot be moved in the log, so simply return
+ * the lsn at which it's been logged.
+ */
+STATIC xfs_lsn_t
+xfs_cui_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	return lsn;
+}
+
+/*
+ * The CUI dependency tracking op doesn't do squat.  It can't because
+ * it doesn't know where the free extent is coming from.  The dependency
+ * tracking has to be handled by the "enclosing" metadata object.  For
+ * example, for inodes, the inode is locked throughout the extent freeing
+ * so the dependency should be recorded there.
+ */
+STATIC void
+xfs_cui_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all cui log items.
+ */
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_pin	= xfs_cui_item_pin,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_unlock	= xfs_cui_item_unlock,
+	.iop_committed	= xfs_cui_item_committed,
+	.iop_push	= xfs_cui_item_push,
+	.iop_committing = xfs_cui_item_committing,
+};
+
+/*
+ * Allocate and initialize an cui item with the given number of extents.
+ */
+struct xfs_cui_log_item *
+xfs_cui_init(
+	struct xfs_mount		*mp,
+	uint				nextents)
+
+{
+	struct xfs_cui_log_item		*cuip;
+	uint				size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_CUI_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_cui_log_item) +
+			((nextents - 1) * sizeof(struct xfs_phys_extent)));
+		cuip = kmem_zalloc(size, KM_SLEEP);
+	} else {
+		cuip = kmem_zone_zalloc(xfs_cui_zone, KM_SLEEP);
+	}
+
+	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
+	cuip->cui_format.cui_nextents = nextents;
+	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
+	atomic_set(&cuip->cui_next_extent, 0);
+	atomic_set(&cuip->cui_refcount, 2);
+
+	return cuip;
+}
+
+/*
+ * Copy an CUI format buffer from the given buf, and into the destination
+ * CUI format structure.  The CUI/CUD items were designed not to need any
+ * special alignment handling.
+ */
+int
+xfs_cui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_cui_log_format	*dst_cui_fmt)
+{
+	struct xfs_cui_log_format	*src_cui_fmt;
+	uint				len;
+
+	src_cui_fmt = buf->i_addr;
+	len = sizeof(struct xfs_cui_log_format) +
+			(src_cui_fmt->cui_nextents - 1) *
+			sizeof(struct xfs_phys_extent);
+
+	if (buf->i_len == len) {
+		memcpy((char *)dst_cui_fmt, (char *)src_cui_fmt, len);
+		return 0;
+	}
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Freeing the CUI requires that we remove it from the AIL if it has already
+ * been placed there. However, the CUI may not yet have been placed in the AIL
+ * when called by xfs_cui_release() from CUD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the CUI.
+ */
+void
+xfs_cui_release(
+	struct xfs_cui_log_item	*cuip)
+{
+	if (atomic_dec_and_test(&cuip->cui_refcount)) {
+		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_cui_item_free(cuip);
+	}
+}
+
+static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_cud_log_item, cud_item);
+}
+
+STATIC void
+xfs_cud_item_free(struct xfs_cud_log_item *cudp)
+{
+	if (cudp->cud_format.cud_nextents > XFS_CUD_MAX_FAST_EXTENTS)
+		kmem_free(cudp);
+	else
+		kmem_zone_free(xfs_cud_zone, cudp);
+}
+
+/*
+ * This returns the number of iovecs needed to log the given cud item.
+ * We only need 1 iovec for an cud item.  It just logs the cud_log_format
+ * structure.
+ */
+static inline int
+xfs_cud_item_sizeof(
+	struct xfs_cud_log_item	*cudp)
+{
+	return sizeof(struct xfs_cud_log_format) +
+			(cudp->cud_format.cud_nextents - 1) *
+			sizeof(struct xfs_phys_extent);
+}
+
+STATIC void
+xfs_cud_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += xfs_cud_item_sizeof(CUD_ITEM(lip));
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the
+ * given cud log item. We use only 1 iovec, and we point that
+ * at the cud_log_format structure embedded in the cud item.
+ * It is at this point that we assert that all of the extent
+ * slots in the cud item have been filled.
+ */
+STATIC void
+xfs_cud_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
+	struct xfs_log_iovec	*vecp = NULL;
+
+	ASSERT(cudp->cud_next_extent == cudp->cud_format.cud_nextents);
+
+	cudp->cud_format.cud_type = XFS_LI_CUD;
+	cudp->cud_format.cud_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
+			xfs_cud_item_sizeof(cudp));
+}
+
+/*
+ * Pinning has no meaning for an cud item, so just return.
+ */
+STATIC void
+xfs_cud_item_pin(
+	struct xfs_log_item	*lip)
+{
+}
+
+/*
+ * Since pinning has no meaning for an cud item, unpinning does
+ * not either.
+ */
+STATIC void
+xfs_cud_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+}
+
+/*
+ * There isn't much you can do to push on an cud item.  It is simply stuck
+ * waiting for the log to be flushed to disk.
+ */
+STATIC uint
+xfs_cud_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	return XFS_ITEM_PINNED;
+}
+
+/*
+ * The CUD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the CUI and free the
+ * CUD.
+ */
+STATIC void
+xfs_cud_item_unlock(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
+
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		xfs_cui_release(cudp->cud_cuip);
+		xfs_cud_item_free(cudp);
+	}
+}
+
+/*
+ * When the cud item is committed to disk, all we need to do is delete our
+ * reference to our partner cui item and then free ourselves. Since we're
+ * freeing ourselves we must return -1 to keep the transaction code from
+ * further referencing this item.
+ */
+STATIC xfs_lsn_t
+xfs_cud_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
+
+	/*
+	 * Drop the CUI reference regardless of whether the CUD has been
+	 * aborted. Once the CUD transaction is constructed, it is the sole
+	 * responsibility of the CUD to release the CUI (even if the CUI is
+	 * aborted due to log I/O error).
+	 */
+	xfs_cui_release(cudp->cud_cuip);
+	xfs_cud_item_free(cudp);
+
+	return (xfs_lsn_t)-1;
+}
+
+/*
+ * The CUD dependency tracking op doesn't do squat.  It can't because
+ * it doesn't know where the free extent is coming from.  The dependency
+ * tracking has to be handled by the "enclosing" metadata object.  For
+ * example, for inodes, the inode is locked throughout the extent freeing
+ * so the dependency should be recorded there.
+ */
+STATIC void
+xfs_cud_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
+{
+}
+
+/*
+ * This is the ops vector shared by all cud log items.
+ */
+static const struct xfs_item_ops xfs_cud_item_ops = {
+	.iop_size	= xfs_cud_item_size,
+	.iop_format	= xfs_cud_item_format,
+	.iop_pin	= xfs_cud_item_pin,
+	.iop_unpin	= xfs_cud_item_unpin,
+	.iop_unlock	= xfs_cud_item_unlock,
+	.iop_committed	= xfs_cud_item_committed,
+	.iop_push	= xfs_cud_item_push,
+	.iop_committing = xfs_cud_item_committing,
+};
+
+/*
+ * Allocate and initialize an cud item with the given number of extents.
+ */
+struct xfs_cud_log_item *
+xfs_cud_init(
+	struct xfs_mount		*mp,
+	struct xfs_cui_log_item		*cuip,
+	uint				nextents)
+
+{
+	struct xfs_cud_log_item	*cudp;
+	uint			size;
+
+	ASSERT(nextents > 0);
+	if (nextents > XFS_CUD_MAX_FAST_EXTENTS) {
+		size = (uint)(sizeof(struct xfs_cud_log_item) +
+			((nextents - 1) * sizeof(struct xfs_phys_extent)));
+		cudp = kmem_zalloc(size, KM_SLEEP);
+	} else {
+		cudp = kmem_zone_zalloc(xfs_cud_zone, KM_SLEEP);
+	}
+
+	xfs_log_item_init(mp, &cudp->cud_item, XFS_LI_CUD, &xfs_cud_item_ops);
+	cudp->cud_cuip = cuip;
+	cudp->cud_format.cud_nextents = nextents;
+	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
+
+	return cudp;
+}
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
new file mode 100644
index 0000000..9af4c9b
--- /dev/null
+++ b/fs/xfs/xfs_refcount_item.h
@@ -0,0 +1,100 @@
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
+#ifndef	__XFS_REFCOUNT_ITEM_H__
+#define	__XFS_REFCOUNT_ITEM_H__
+
+/*
+ * There are (currently) two pairs of refcount btree redo item types:
+ * increase and decrease.  The log items for these are CUI (refcount
+ * update intent) and CUD (refcount update done).  The redo item type
+ * is encoded in the flags field of each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same
+ * transaction that records the associated refcountbt updates.
+ *
+ * Should the system crash after the commit of the first transaction
+ * but before the commit of the final transaction in a series, log
+ * recovery will use the redo information recorded by the intent items
+ * to replay the refcountbt metadata updates.
+ */
+
+/* kernel only CUI/CUD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_CUI_MAX_FAST_EXTENTS	16
+
+/*
+ * Define CUI flag bits. Manipulated by set/clear/test_bit operators.
+ */
+#define	XFS_CUI_RECOVERED		1
+
+/*
+ * This is the "refcount update intent" log item.  It is used to log
+ * the fact that some reverse mappings need to change.  It is used in
+ * conjunction with the "refcount update done" log item described
+ * below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item;
+ * see the comments about that structure (in xfs_extfree_item.h) for
+ * more details.
+ */
+struct xfs_cui_log_item {
+	struct xfs_log_item		cui_item;
+	atomic_t			cui_refcount;
+	atomic_t			cui_next_extent;
+	unsigned long			cui_flags;	/* misc flags */
+	struct xfs_cui_log_format	cui_format;
+};
+
+/*
+ * This is the "refcount update done" log item.  It is used to log the
+ * fact that some refcountbt updates mentioned in an earlier cui item
+ * have been performed.
+ */
+struct xfs_cud_log_item {
+	struct xfs_log_item		cud_item;
+	struct xfs_cui_log_item		*cud_cuip;
+	uint				cud_next_extent;
+	struct xfs_cud_log_format	cud_format;
+};
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_CUD_MAX_FAST_EXTENTS	16
+
+extern struct kmem_zone	*xfs_cui_zone;
+extern struct kmem_zone	*xfs_cud_zone;
+
+struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
+struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
+		struct xfs_cui_log_item *, uint);
+int xfs_cui_copy_format(struct xfs_log_iovec *buf,
+		struct xfs_cui_log_format *dst_cui_fmt);
+void xfs_cui_item_free(struct xfs_cui_log_item *);
+void xfs_cui_release(struct xfs_cui_log_item *);
+
+#endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9328821..a0c7bdc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -48,6 +48,7 @@
 #include "xfs_ondisk.h"
 #include "xfs_defer.h"
 #include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1781,8 +1782,26 @@ xfs_init_zones(void)
 	if (!xfs_rui_zone)
 		goto out_destroy_rud_zone;
 
+	xfs_cud_zone = kmem_zone_init((sizeof(struct xfs_cud_log_item) +
+			((XFS_CUD_MAX_FAST_EXTENTS - 1) *
+				 sizeof(struct xfs_phys_extent))),
+			"xfs_cud_item");
+	if (!xfs_cud_zone)
+		goto out_destroy_rui_zone;
+
+	xfs_cui_zone = kmem_zone_init((sizeof(struct xfs_cui_log_item) +
+			((XFS_CUI_MAX_FAST_EXTENTS - 1) *
+				sizeof(struct xfs_phys_extent))),
+			"xfs_cui_item");
+	if (!xfs_cui_zone)
+		goto out_destroy_cud_zone;
+
 	return 0;
 
+ out_destroy_cud_zone:
+	kmem_zone_destroy(xfs_cud_zone);
+ out_destroy_rui_zone:
+	kmem_zone_destroy(xfs_rui_zone);
  out_destroy_rud_zone:
 	kmem_zone_destroy(xfs_rud_zone);
  out_destroy_icreate_zone:
@@ -1825,6 +1844,8 @@ xfs_destroy_zones(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_zone_destroy(xfs_cui_zone);
+	kmem_zone_destroy(xfs_cud_zone);
 	kmem_zone_destroy(xfs_rui_zone);
 	kmem_zone_destroy(xfs_rud_zone);
 	kmem_zone_destroy(xfs_icreate_zone);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
