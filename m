Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbdLGS6L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 13:58:11 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF5706016A
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EC1377662
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 2/4] xfs: defer agfl block frees when dfops is available
Date: Thu,  7 Dec 2017 13:58:08 -0500
Message-Id: <20171207185810.48757-3-bfoster@redhat.com>
In-Reply-To: <20171207185810.48757-1-bfoster@redhat.com>
References: <20171207185810.48757-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The AGFL fixup code executes before every block allocation/free and
rectifies the AGFL based on the current, dynamic allocation
requirements of the fs. The AGFL must hold a minimum number of
blocks to satisfy a worst case split of the free space btrees caused
by the impending allocation operation. The AGFL is also updated to
maintain the implicit requirement for a minimum number of free slots
to satisfy a worst case join of the free space btrees.

Since the AGFL caches individual blocks, AGFL reduction typically
involves multiple, single block frees. We've had reports of
transaction overrun problems during certain workloads that boil down
to AGFL reduction freeing multiple blocks and consuming more space
in the log than was reserved for the transaction.

Since the objective of freeing AGFL blocks is to ensure free AGFL
free slots are available for the upcoming allocation, one way to
address this problem is to release surplus blocks from the AGFL
immediately but defer the free of those blocks (similar to how
file-mapped blocks are unmapped from the file in one transaction and
freed via a deferred operation) until the transaction is rolled.
This turns AGFL reduction into an operation with predictable log
reservation consumption.

Add the capability to defer AGFL block frees when a deferred ops
list is handed to the AGFL fixup code. Deferring AGFL frees is a
conditional behavior based on whether the caller has populated the
new dfops field of the xfs_alloc_arg structure. A bit of
customization is required to handle deferred completion processing
because AGFL blocks are accounted against a separate reservation
pool and AGFL are not inserted into the extent busy list when freed
(they are inserted when used and released back to the AGFL). Reuse
the majority of the existing deferred extent free infrastructure and
customize it appropriately to handle AGFL blocks.

Note that this patch only adds infrastructure. It does not change
behavior because no callers have been updated to pass dfops into the
allocation code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 51 ++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_alloc.h  |  1 +
 fs/xfs/libxfs/xfs_defer.h  |  1 +
 fs/xfs/xfs_trace.h         |  2 ++
 fs/xfs/xfs_trans_extfree.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 8a2235ebca08..ab636181471c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -39,6 +39,9 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
+#include "xfs_bmap.h"
+
+extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2065,6 +2068,40 @@ xfs_free_agfl_block(
 }
 
 /*
+ * Defer an AGFL block free. This is effectively equivalent to
+ * xfs_bmap_add_free() with some special handling particular to AGFL blocks.
+ *
+ * Deferring AGFL frees helps prevent log reservation overruns due to too many
+ * allocation operations in a transaction. AGFL frees are prone to this problem
+ * because for one they are always freed one at a time. Further, an immediate
+ * AGFL block free can cause a btree join and require another block free before
+ * the real allocation can proceed. Deferring the free disconnects freeing up
+ * the AGFL slot from freeing the block.
+ */
+STATIC void
+xfs_defer_agfl_block(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_agnumber_t			agno,
+	xfs_fsblock_t			agbno,
+	struct xfs_owner_info		*oinfo)
+{
+	struct xfs_extent_free_item	*new;		/* new element */
+
+	ASSERT(xfs_bmap_free_item_zone != NULL);
+	ASSERT(oinfo != NULL);
+
+	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
+	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
+	new->xefi_blockcount = 1;
+	new->xefi_oinfo = *oinfo;
+
+	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
+}
+
+/*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  */
@@ -2164,10 +2201,16 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 
-		error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
-					    &targs.oinfo);
-		if (error)
-			goto out_agbp_relse;
+		/* defer agfl frees if dfops is provided */
+		if (args->dfops) {
+			xfs_defer_agfl_block(mp, args->dfops, args->agno, bno,
+						     &targs.oinfo);
+		} else {
+			error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
+						    &targs.oinfo);
+			if (error)
+				goto out_agbp_relse;
+		}
 	}
 
 	targs.tp = tp;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d3a150180b1d..559568806265 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -61,6 +61,7 @@ typedef unsigned int xfs_alloctype_t;
  */
 typedef struct xfs_alloc_arg {
 	struct xfs_trans *tp;		/* transaction pointer */
+	struct xfs_defer_ops	*dfops;	/* deferred ops (for agfl) */
 	struct xfs_mount *mp;		/* file system mount point */
 	struct xfs_buf	*agbp;		/* buffer for a.g. freelist header */
 	struct xfs_perag *pag;		/* per-ag struct for this agno */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d4f046dd44bd..29c6b550f49b 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -55,6 +55,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_REFCOUNT,
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
+	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d718a10c2271..3c5d9f8cbb9d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2426,6 +2426,8 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
+DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_defer);
+DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
 
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index ab438647592a..f5620796ae25 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -231,9 +231,79 @@ static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+/*
+ * AGFL blocks are accounted differently in the reserve pools and are not
+ * inserted into the busy extent list.
+ */
+STATIC int
+xfs_agfl_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
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
+	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
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
+
+/* sub-type with special handling for AGFL deferred frees */
+static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
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
 /* Register the deferred op type. */
 void
 xfs_extent_free_init_defer_op(void)
 {
 	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
+	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
 }
-- 
2.13.6

