Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388112AbeGWOFZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32BED4064304
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:15 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DBB1111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:15 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 08/15] xfs: support embedded dfops in transaction
Date: Mon, 23 Jul 2018 09:04:07 -0400
Message-Id: <20180723130414.47980-9-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The dfops structure used by multi-transaction operations is
typically stored on the stack and carried around by the associated
transaction. The lifecycle of dfops does not quite match that of the
transaction, but they are tightly related in that the former depends
on the latter.

The relationship of these objects is tight enough that we can avoid
the cumbersome boilerplate code required in most cases to manage
them separately by just embedding an xfs_defer_ops in the
transaction itself. This means that a transaction allocation returns
with an initialized dfops, a transaction commit finishes pending
deferred items before the tx commit, a transaction cancel cancels
the dfops before the transaction and a transaction dup operation
transfers the current dfops state to the new transaction.

The dup operation is slightly complicated by the fact that we can no
longer just copy a dfops pointer from the old transaction to the new
transaction. This is solved through a dfops move helper that
transfers the pending items and other dfops state across the
transactions. This also requires that transaction rolling code
always refer to the transaction for the current dfops reference.

Finally, to facilitate incremental conversion to the internal dfops
and continue to support the current external dfops mode of
operation, create the new ->t_dfops_internal field with a layer of
indirection. On allocation, ->t_dfops points to the internal dfops.
This state is overridden by callers who re-init a local dfops on the
transaction. Once ->t_dfops is overridden, the external dfops
reference is maintained as the transaction rolls.

This patch adds the fundamental ability to support an internal
dfops. All codepaths that perform deferred processing continue to
override the internal dfops until they are converted over in
subsequent patches.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_defer.h | 16 ++--------------
 fs/xfs/xfs_trans.c        | 30 ++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h        | 17 ++++++++++++++++-
 4 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 23f2a52b088e..b63cc9e730da 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -555,3 +555,25 @@ xfs_defer_init(
 	}
 	trace_xfs_defer_init(mp, dop, _RET_IP_);
 }
+
+/*
+ * Move state from one xfs_defer_ops to another and reset the source to initial
+ * state. This is primarily used to carry state forward across transaction rolls
+ * with internal dfops.
+ */
+void
+xfs_defer_move(
+	struct xfs_defer_ops	*dst,
+	struct xfs_defer_ops	*src)
+{
+	ASSERT(dst != src);
+
+	list_splice_init(&src->dop_intake, &dst->dop_intake);
+	list_splice_init(&src->dop_pending, &dst->dop_pending);
+
+	memcpy(dst->dop_inodes, src->dop_inodes, sizeof(dst->dop_inodes));
+	memcpy(dst->dop_bufs, src->dop_bufs, sizeof(dst->dop_bufs));
+	dst->dop_low = src->dop_low;
+
+	xfs_defer_reset(src);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8f58f217fdff..35507ca9a148 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -7,6 +7,7 @@
 #define	__XFS_DEFER_H__
 
 struct xfs_defer_op_type;
+struct xfs_defer_ops;
 
 /*
  * Save a log intent item and a list of extents, so that we can replay
@@ -45,20 +46,6 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
-#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
-
-struct xfs_defer_ops {
-	struct list_head	dop_intake;	/* unlogged pending work */
-	struct list_head	dop_pending;	/* logged pending work */
-
-	/* relog these with each roll */
-	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
-	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
-
-	bool			dop_low;	/* alloc in low mode */
-};
-
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
@@ -67,6 +54,7 @@ void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
 int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
+void xfs_defer_move(struct xfs_defer_ops *dst, struct xfs_defer_ops *src);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index de00f79ff698..412c8d236c71 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -119,7 +119,13 @@ xfs_trans_dup(
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
-	ntp->t_dfops = tp->t_dfops;
+
+	/* copy the dfops pointer if it's external, otherwise move it */
+	xfs_defer_init(ntp, &ntp->t_dfops_internal);
+	if (tp->t_dfops != &tp->t_dfops_internal)
+		ntp->t_dfops = tp->t_dfops;
+	else
+		xfs_defer_move(ntp->t_dfops, tp->t_dfops);
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
@@ -275,6 +281,13 @@ xfs_trans_alloc(
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
 	tp->t_firstblock = NULLFSBLOCK;
+	/*
+	 * We only roll transactions with permanent log reservation. Don't init
+	 * ->t_dfops to skip attempts to finish or cancel an empty dfops with a
+	 * non-permanent res.
+	 */
+	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
+		xfs_defer_init(tp, &tp->t_dfops_internal);
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
@@ -916,11 +929,17 @@ __xfs_trans_commit(
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
-	ASSERT(!tp->t_dfops ||
-	       !xfs_defer_has_unfinished_work(tp->t_dfops) || regrant);
-
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
+	/* finish deferred items on final commit */
+	if (!regrant && tp->t_dfops) {
+		error = xfs_defer_finish(&tp, tp->t_dfops);
+		if (error) {
+			xfs_defer_cancel(tp->t_dfops);
+			goto out_unreserve;
+		}
+	}
+
 	/*
 	 * If there is nothing to be logged by the transaction,
 	 * then unlock all of the items associated with the
@@ -1010,6 +1029,9 @@ xfs_trans_cancel(
 
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
+	if (tp->t_dfops)
+		xfs_defer_cancel(tp->t_dfops);
+
 	/*
 	 * See if the caller is relying on us to shut down the
 	 * filesystem.  This happens in paths where we detect
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6f857af61455..dc79e3c1d3e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -24,7 +24,6 @@ struct xfs_rui_log_item;
 struct xfs_btree_cur;
 struct xfs_cui_log_item;
 struct xfs_cud_log_item;
-struct xfs_defer_ops;
 struct xfs_bui_log_item;
 struct xfs_bud_log_item;
 
@@ -90,6 +89,21 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
 
+/*
+ * Deferred operations tracking structure.
+ */
+#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
+struct xfs_defer_ops {
+	struct list_head	dop_intake;	/* unlogged pending work */
+	struct list_head	dop_pending;	/* logged pending work */
+
+	/* relog these with each roll */
+	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
+
+	bool			dop_low;	/* alloc in low mode */
+};
 
 /*
  * This is the structure maintained for every active transaction.
@@ -130,6 +144,7 @@ typedef struct xfs_trans {
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
+	struct xfs_defer_ops	t_dfops_internal;
 } xfs_trans_t;
 
 /*
-- 
2.17.1

