Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57548 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:41 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/20] xfs: merge xfs_trans_extfree.c into xfs_extfree_item.c
Date: Thu, 13 Jun 2019 20:02:57 +0200
Message-Id: <20190613180300.30447-18-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Keep all the extree item related code together in one file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile            |   1 -
 fs/xfs/xfs_extfree_item.c  | 247 ++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h         |   8 --
 fs/xfs/xfs_trans_extfree.c | 260 -------------------------------------
 4 files changed, 246 insertions(+), 270 deletions(-)
 delete mode 100644 fs/xfs/xfs_trans_extfree.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 701028e3e4ac..ddaf774313ff 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -107,7 +107,6 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_ail.o \
 				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
-				   xfs_trans_extfree.o \
 				   xfs_trans_inode.o \
 				   xfs_trans_refcount.o \
 				   xfs_trans_rmap.o \
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index b797db8b9967..99fd40ebffef 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -5,11 +5,14 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_trans.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
@@ -17,6 +20,9 @@
 #include "xfs_log.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
 
 
 kmem_zone_t	*xfs_efi_zone;
@@ -316,7 +322,7 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
  * extents.  The caller must use all nextents extents, because we are not
  * flexible about this at all.
  */
-struct xfs_efd_log_item *
+static struct xfs_efd_log_item *
 xfs_trans_get_efd(
 	struct xfs_trans		*tp,
 	struct xfs_efi_log_item		*efip,
@@ -344,6 +350,245 @@ xfs_trans_get_efd(
 	return efdp;
 }
 
+/*
+ * Free an extent and log it to the EFD. Note that the transaction is marked
+ * dirty regardless of whether the extent free succeeds or fails to support the
+ * EFI/EFD lifecycle rules.
+ */
+static int
+xfs_trans_free_extent(
+	struct xfs_trans		*tp,
+	struct xfs_efd_log_item		*efdp,
+	xfs_fsblock_t			start_block,
+	xfs_extlen_t			ext_len,
+	const struct xfs_owner_info	*oinfo,
+	bool				skip_discard)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_extent		*extp;
+	uint				next_extent;
+	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, start_block);
+	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
+								start_block);
+	int				error;
+
+	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
+
+	error = __xfs_free_extent(tp, start_block, ext_len,
+				  oinfo, XFS_AG_RESV_NONE, skip_discard);
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the EFI and frees the EFD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	next_extent = efdp->efd_next_extent;
+	ASSERT(next_extent < efdp->efd_format.efd_nextents);
+	extp = &(efdp->efd_format.efd_extents[next_extent]);
+	extp->ext_start = start_block;
+	extp->ext_len = ext_len;
+	efdp->efd_next_extent++;
+
+	return error;
+}
+
+/* Sort bmap items by AG. */
+static int
+xfs_extent_free_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_extent_free_item	*ra;
+	struct xfs_extent_free_item	*rb;
+
+	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
+	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->xefi_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
+}
+
+/* Get an EFI. */
+STATIC void *
+xfs_extent_free_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	struct xfs_efi_log_item		*efip;
+
+	ASSERT(tp != NULL);
+	ASSERT(count > 0);
+
+	efip = xfs_efi_init(tp->t_mountp, count);
+	ASSERT(efip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &efip->efi_item);
+	return efip;
+}
+
+/* Log a free extent to the intent item. */
+STATIC void
+xfs_extent_free_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_efi_log_item		*efip = intent;
+	struct xfs_extent_free_item	*free;
+	uint				next_extent;
+	struct xfs_extent		*extp;
+
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
+	ASSERT(next_extent < efip->efi_format.efi_nextents);
+	extp = &efip->efi_format.efi_extents[next_extent];
+	extp->ext_start = free->xefi_startblock;
+	extp->ext_len = free->xefi_blockcount;
+}
+
+/* Get an EFD so we can process all the free extents. */
+STATIC void *
+xfs_extent_free_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_efd(tp, intent, count);
+}
+
+/* Process a free extent. */
+STATIC int
+xfs_extent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_extent_free_item	*free;
+	int				error;
+
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	error = xfs_trans_free_extent(tp, done_item,
+			free->xefi_startblock,
+			free->xefi_blockcount,
+			&free->xefi_oinfo, free->xefi_skip_discard);
+	kmem_free(free);
+	return error;
+}
+
+/* Abort all pending EFIs. */
+STATIC void
+xfs_extent_free_abort_intent(
+	void				*intent)
+{
+	xfs_efi_release(intent);
+}
+
+/* Cancel a free extent. */
+STATIC void
+xfs_extent_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_extent_free_item	*free;
+
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	kmem_free(free);
+}
+
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_extent_free_diff_items,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.log_item	= xfs_extent_free_log_item,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+};
+
+/*
+ * AGFL blocks are accounted differently in the reserve pools and are not
+ * inserted into the busy extent list.
+ */
+STATIC int
+xfs_agfl_free_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_efd_log_item		*efdp = done_item;
+	struct xfs_extent_free_item	*free;
+	struct xfs_extent		*extp;
+	struct xfs_buf			*agbp;
+	int				error;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	uint				next_extent;
+
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	ASSERT(free->xefi_blockcount == 1);
+	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+
+	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (!error)
+		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
+					    &free->xefi_oinfo);
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the EFI and frees the EFD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
+
+	next_extent = efdp->efd_next_extent;
+	ASSERT(next_extent < efdp->efd_format.efd_nextents);
+	extp = &(efdp->efd_format.efd_extents[next_extent]);
+	extp->ext_start = free->xefi_startblock;
+	extp->ext_len = free->xefi_blockcount;
+	efdp->efd_next_extent++;
+
+	kmem_free(free);
+	return error;
+}
+
+/* sub-type with special handling for AGFL deferred frees */
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_extent_free_diff_items,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.log_item	= xfs_extent_free_log_item,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_agfl_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+};
+
 /*
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f75042bdd2ea..a0fd818e0e95 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -230,14 +230,6 @@ void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
 bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
-struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
-				  struct xfs_efi_log_item *,
-				  uint);
-int		xfs_trans_free_extent(struct xfs_trans *,
-				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t,
-				      const struct xfs_owner_info *,
-				      bool);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
deleted file mode 100644
index 20ab1c9d758f..000000000000
--- a/fs/xfs/xfs_trans_extfree.c
+++ /dev/null
@@ -1,260 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_bit.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_extfree_item.h"
-#include "xfs_alloc.h"
-#include "xfs_bmap.h"
-#include "xfs_trace.h"
-
-/*
- * Free an extent and log it to the EFD. Note that the transaction is marked
- * dirty regardless of whether the extent free succeeds or fails to support the
- * EFI/EFD lifecycle rules.
- */
-int
-xfs_trans_free_extent(
-	struct xfs_trans		*tp,
-	struct xfs_efd_log_item		*efdp,
-	xfs_fsblock_t			start_block,
-	xfs_extlen_t			ext_len,
-	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent		*extp;
-	uint				next_extent;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, start_block);
-	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-								start_block);
-	int				error;
-
-	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
-
-	error = __xfs_free_extent(tp, start_block, ext_len,
-				  oinfo, XFS_AG_RESV_NONE, skip_discard);
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the EFI and frees the EFD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
-
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = start_block;
-	extp->ext_len = ext_len;
-	efdp->efd_next_extent++;
-
-	return error;
-}
-
-/* Sort bmap items by AG. */
-static int
-xfs_extent_free_diff_items(
-	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
-{
-	struct xfs_mount		*mp = priv;
-	struct xfs_extent_free_item	*ra;
-	struct xfs_extent_free_item	*rb;
-
-	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
-	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->xefi_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
-}
-
-/* Get an EFI. */
-STATIC void *
-xfs_extent_free_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_efi_log_item		*efip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	efip = xfs_efi_init(tp->t_mountp, count);
-	ASSERT(efip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efip->efi_item);
-	return efip;
-}
-
-/* Log a free extent to the intent item. */
-STATIC void
-xfs_extent_free_log_item(
-	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
-{
-	struct xfs_efi_log_item		*efip = intent;
-	struct xfs_extent_free_item	*free;
-	uint				next_extent;
-	struct xfs_extent		*extp;
-
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
-
-	/*
-	 * atomic_inc_return gives us the value after the increment;
-	 * we want to use it as an array index so we need to subtract 1 from
-	 * it.
-	 */
-	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
-	ASSERT(next_extent < efip->efi_format.efi_nextents);
-	extp = &efip->efi_format.efi_extents[next_extent];
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
-}
-
-/* Get an EFD so we can process all the free extents. */
-STATIC void *
-xfs_extent_free_create_done(
-	struct xfs_trans		*tp,
-	void				*intent,
-	unsigned int			count)
-{
-	return xfs_trans_get_efd(tp, intent, count);
-}
-
-/* Process a free extent. */
-STATIC int
-xfs_extent_free_finish_item(
-	struct xfs_trans		*tp,
-	struct list_head		*item,
-	void				*done_item,
-	void				**state)
-{
-	struct xfs_extent_free_item	*free;
-	int				error;
-
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	error = xfs_trans_free_extent(tp, done_item,
-			free->xefi_startblock,
-			free->xefi_blockcount,
-			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
-	return error;
-}
-
-/* Abort all pending EFIs. */
-STATIC void
-xfs_extent_free_abort_intent(
-	void				*intent)
-{
-	xfs_efi_release(intent);
-}
-
-/* Cancel a free extent. */
-STATIC void
-xfs_extent_free_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_extent_free_item	*free;
-
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
-}
-
-const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_extent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
-/*
- * AGFL blocks are accounted differently in the reserve pools and are not
- * inserted into the busy extent list.
- */
-STATIC int
-xfs_agfl_free_finish_item(
-	struct xfs_trans		*tp,
-	struct list_head		*item,
-	void				*done_item,
-	void				**state)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_efd_log_item		*efdp = done_item;
-	struct xfs_extent_free_item	*free;
-	struct xfs_extent		*extp;
-	struct xfs_buf			*agbp;
-	int				error;
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
-	uint				next_extent;
-
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	ASSERT(free->xefi_blockcount == 1);
-	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
-
-	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
-
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
-	if (!error)
-		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
-					    &free->xefi_oinfo);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the EFI and frees the EFD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
-
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
-	efdp->efd_next_extent++;
-
-	kmem_free(free);
-	return error;
-}
-
-
-/* sub-type with special handling for AGFL deferred frees */
-const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_extent_free_diff_items,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.log_item	= xfs_extent_free_log_item,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_agfl_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-- 
2.20.1
