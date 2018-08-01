Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389381AbeHAPFm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A9DE40241C9
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:54 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1636A2026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:54 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 15/15] xfs: fold dfops into the transaction
Date: Wed,  1 Aug 2018 09:19:52 -0400
Message-Id: <20180801131952.60250-16-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-1-bfoster@redhat.com>
References: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

struct xfs_defer_ops has now been reduced to a single list_head. The
external dfops mechanism is unused and thus everywhere a (permanent)
transaction is accessible the associated dfops structure is as well.

Remove the xfs_defer_ops structure and fold the list_head into the
transaction. Also remove the last remnant of external dfops in
xfs_trans_dup().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |  1 -
 fs/xfs/libxfs/xfs_btree.h    |  1 -
 fs/xfs/libxfs/xfs_da_btree.h |  1 -
 fs/xfs/libxfs/xfs_defer.c    | 67 ++++++++++--------------------------
 fs/xfs/libxfs/xfs_defer.h    |  2 --
 fs/xfs/libxfs/xfs_dir2.c     |  2 --
 fs/xfs/libxfs/xfs_dir2.h     |  1 -
 fs/xfs/xfs_inode.h           |  1 -
 fs/xfs/xfs_reflink.c         |  5 ++-
 fs/xfs/xfs_trace.h           | 40 ++++++++++-----------
 fs/xfs/xfs_trans.c           | 13 +++----
 fs/xfs/xfs_trans.h           |  8 ++---
 12 files changed, 46 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f5f1fc47923e..0f9f522ab792 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4285,7 +4285,6 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.datatype = 0;
-	ASSERT(!tp || tp->t_dfops);
 
 	while (bno < end && n < *nmap) {
 		bool			need_alloc = false, wasdelay = false;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 503615f4d729..e3b3e9dce5da 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -7,7 +7,6 @@
 #define	__XFS_BTREE_H__
 
 struct xfs_buf;
-struct xfs_defer_ops;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 59e290ef334f..84dd865b6c3d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -7,7 +7,6 @@
 #ifndef __XFS_DA_BTREE_H__
 #define	__XFS_DA_BTREE_H__
 
-struct xfs_defer_ops;
 struct xfs_inode;
 struct xfs_trans;
 struct zone;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ded038e4051e..679c675eb252 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -183,11 +183,10 @@ STATIC void
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
-	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
 
-	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
+	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
 		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
 				dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
@@ -205,10 +204,9 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending,
 	int				error)
 {
-	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct xfs_defer_pending	*dfp;
 
-	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
 
 	/* Abort intent items that don't have a done item. */
 	if (dop_pending) {
@@ -273,13 +271,12 @@ xfs_defer_trans_roll(
 		}
 	}
 
-	trace_xfs_defer_trans_roll((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
+	trace_xfs_defer_trans_roll(*tp, _RET_IP_);
 
 	/* Roll the transaction. */
 	error = xfs_trans_roll(tp);
 	if (error) {
-		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
-						 (*tp)->t_dfops, error);
+		trace_xfs_defer_trans_roll_error(*tp, error);
 		xfs_defer_trans_abort(*tp,  dop_pending, error);
 		return error;
 	}
@@ -304,7 +301,7 @@ static void
 xfs_defer_reset(
 	struct xfs_trans	*tp)
 {
-	ASSERT(list_empty(&tp->t_dfops->dop_intake));
+	ASSERT(list_empty(&tp->t_dfops));
 
 	/*
 	 * Low mode state transfers across transaction rolls to mirror dfops
@@ -365,15 +362,13 @@ xfs_defer_finish_noroll(
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
-	trace_xfs_defer_finish((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
+	trace_xfs_defer_finish(*tp, _RET_IP_);
 
 	/* Until we run out of pending work to finish... */
-	while (!list_empty(&dop_pending) ||
-	       !list_empty(&(*tp)->t_dfops->dop_intake)) {
+	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
 		/* log intents and pull in intake items */
 		xfs_defer_create_intents(*tp);
-		list_splice_tail_init(&(*tp)->t_dfops->dop_intake,
-				      &dop_pending);
+		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
 
 		/*
 		 * Roll the transaction.
@@ -444,14 +439,13 @@ xfs_defer_finish_noroll(
 
 out:
 	if (error) {
-		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
-					     error);
+		trace_xfs_defer_finish_error(*tp, error);
 		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 		xfs_defer_cancel(*tp);
 		return error;
 	}
 
-	trace_xfs_defer_finish_done((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
+	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
 }
 
@@ -483,8 +477,8 @@ xfs_defer_cancel(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	trace_xfs_defer_cancel(mp, tp->t_dfops, _RET_IP_);
-	xfs_defer_cancel_list(mp, &tp->t_dfops->dop_intake);
+	trace_xfs_defer_cancel(tp, _RET_IP_);
+	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
 /* Add an item for later deferred processing. */
@@ -494,7 +488,6 @@ xfs_defer_add(
 	enum xfs_defer_ops_type		type,
 	struct list_head		*li)
 {
-	struct xfs_defer_ops		*dop = tp->t_dfops;
 	struct xfs_defer_pending	*dfp = NULL;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -504,8 +497,8 @@ xfs_defer_add(
 	 * If the last pending item has the same type, reuse it.  Else,
 	 * create a new pending item at the end of the intake list.
 	 */
-	if (!list_empty(&dop->dop_intake)) {
-		dfp = list_last_entry(&dop->dop_intake,
+	if (!list_empty(&tp->t_dfops)) {
+		dfp = list_last_entry(&tp->t_dfops,
 				struct xfs_defer_pending, dfp_list);
 		if (dfp->dfp_type->type != type ||
 		    (dfp->dfp_type->max_items &&
@@ -520,7 +513,7 @@ xfs_defer_add(
 		dfp->dfp_done = NULL;
 		dfp->dfp_count = 0;
 		INIT_LIST_HEAD(&dfp->dfp_work);
-		list_add_tail(&dfp->dfp_list, &dop->dop_intake);
+		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
 	}
 
 	list_add_tail(li, &dfp->dfp_work);
@@ -535,39 +528,17 @@ xfs_defer_init_op_type(
 	defer_op_types[type->type] = type;
 }
 
-/* Initialize a deferred operation. */
-void
-xfs_defer_init(
-	struct xfs_trans		*tp,
-	struct xfs_defer_ops		*dop)
-{
-	struct xfs_mount		*mp = NULL;
-
-	memset(dop, 0, sizeof(struct xfs_defer_ops));
-	INIT_LIST_HEAD(&dop->dop_intake);
-	if (tp) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		tp->t_dfops = dop;
-		mp = tp->t_mountp;
-	}
-	trace_xfs_defer_init(mp, dop, _RET_IP_);
-}
-
 /*
- * Move state from one xfs_defer_ops to another and reset the source to initial
- * state. This is primarily used to carry state forward across transaction rolls
- * with internal dfops.
+ * Move deferred ops from one transaction to another and reset the source to
+ * initial state. This is primarily used to carry state forward across
+ * transaction rolls with pending dfops.
  */
 void
 xfs_defer_move(
 	struct xfs_trans	*dtp,
 	struct xfs_trans	*stp)
 {
-	struct xfs_defer_ops	*dst = dtp->t_dfops;
-	struct xfs_defer_ops	*src = stp->t_dfops;
-	ASSERT(dst != src);
-
-	list_splice_init(&src->dop_intake, &dst->dop_intake);
+	list_splice_init(&stp->t_dfops, &dtp->t_dfops);
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index b2675f1ca909..2584a5b95b0d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -7,7 +7,6 @@
 #define	__XFS_DEFER_H__
 
 struct xfs_defer_op_type;
-struct xfs_defer_ops;
 
 /*
  * Save a log intent item and a list of extents, so that we can replay
@@ -40,7 +39,6 @@ void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void xfs_defer_cancel(struct xfs_trans *);
-void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 4ea1fddb126f..229152cd1a24 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -424,7 +424,6 @@ xfs_dir_removename(
 	int			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
-	ASSERT(tp->t_dfops);
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
@@ -483,7 +482,6 @@ xfs_dir_replace(
 	int			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
-	ASSERT(tp->t_dfops);
 
 	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
 	if (rval)
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ba5acd03de94..c3e3f6b813d8 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -9,7 +9,6 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 
-struct xfs_defer_ops;
 struct xfs_da_args;
 struct xfs_inode;
 struct xfs_mount;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 79a3e61a6991..be2014520155 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -15,7 +15,6 @@
 struct xfs_dinode;
 struct xfs_inode;
 struct xfs_buf;
-struct xfs_defer_ops;
 struct xfs_bmbt_irec;
 struct xfs_inode_log_item;
 struct xfs_mount;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cbceb320a2e7..38f405415b88 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -502,7 +502,6 @@ xfs_reflink_cancel_cow_blocks(
 			if (error)
 				break;
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
-			ASSERT((*tpp)->t_dfops);
 			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
 
 			/* Free the CoW orphan record. */
@@ -678,7 +677,7 @@ xfs_reflink_end_cow(
 			goto prev_extent;
 
 		/* Unmap the old blocks in the data fork. */
-		ASSERT(tp->t_dfops && tp->t_firstblock == NULLFSBLOCK);
+		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		rlen = del.br_blockcount;
 		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
 		if (error)
@@ -1021,7 +1020,7 @@ xfs_reflink_remap_extent(
 	/* Unmap the old blocks in the data fork. */
 	rlen = unmap_len;
 	while (rlen) {
-		ASSERT(tp->t_dfops && tp->t_firstblock == NULLFSBLOCK);
+		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
 		if (error)
 			goto out_cancel;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fec9cfe3dfb4..ad315e83bc02 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2213,57 +2213,54 @@ DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
 
 /* deferred ops */
 struct xfs_defer_pending;
-struct xfs_defer_ops;
 
 DECLARE_EVENT_CLASS(xfs_defer_class,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop,
-		 unsigned long caller_ip),
-	TP_ARGS(mp, dop, caller_ip),
+	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),
+	TP_ARGS(tp, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(void *, dop)
+		__field(struct xfs_trans *, tp)
 		__field(char, committed)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__entry->dop = dop;
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->tp = tp;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ops %p caller %pS",
+	TP_printk("dev %d:%d tp %p caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->dop,
+		  __entry->tp,
 		  (char *)__entry->caller_ip)
 )
 #define DEFINE_DEFER_EVENT(name) \
 DEFINE_EVENT(xfs_defer_class, name, \
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, \
-		 unsigned long caller_ip), \
-	TP_ARGS(mp, dop, caller_ip))
+	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip), \
+	TP_ARGS(tp, caller_ip))
 
 DECLARE_EVENT_CLASS(xfs_defer_error_class,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, int error),
-	TP_ARGS(mp, dop, error),
+	TP_PROTO(struct xfs_trans *tp, int error),
+	TP_ARGS(tp, error),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(void *, dop)
+		__field(struct xfs_trans *, tp)
 		__field(char, committed)
 		__field(int, error)
 	),
 	TP_fast_assign(
-		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__entry->dop = dop;
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->tp = tp;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ops %p err %d",
+	TP_printk("dev %d:%d tp %p err %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->dop,
+		  __entry->tp,
 		  __entry->error)
 )
 #define DEFINE_DEFER_ERROR_EVENT(name) \
 DEFINE_EVENT(xfs_defer_error_class, name, \
-	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_ops *dop, int error), \
-	TP_ARGS(mp, dop, error))
+	TP_PROTO(struct xfs_trans *tp, int error), \
+	TP_ARGS(tp, error))
 
 DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp),
@@ -2382,7 +2379,6 @@ DEFINE_EVENT(xfs_map_extent_deferred_class, name, \
 		 xfs_exntst_t state), \
 	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 
-DEFINE_DEFER_EVENT(xfs_defer_init);
 DEFINE_DEFER_EVENT(xfs_defer_cancel);
 DEFINE_DEFER_EVENT(xfs_defer_trans_roll);
 DEFINE_DEFER_EVENT(xfs_defer_trans_abort);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 413e4138357f..bedc5a5133a5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -100,6 +100,7 @@ xfs_trans_dup(
 	ntp->t_mountp = tp->t_mountp;
 	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
+	INIT_LIST_HEAD(&ntp->t_dfops);
 	ntp->t_firstblock = NULLFSBLOCK;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -120,12 +121,8 @@ xfs_trans_dup(
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
 
-	/* copy the dfops pointer if it's external, otherwise move it */
-	xfs_defer_init(ntp, &ntp->t_dfops_internal);
-	if (tp->t_dfops != &tp->t_dfops_internal)
-		ntp->t_dfops = tp->t_dfops;
-	else
-		xfs_defer_move(ntp, tp);
+	/* move deferred ops over to the new tp */
+	xfs_defer_move(ntp, tp);
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
@@ -280,8 +277,8 @@ xfs_trans_alloc(
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
+	INIT_LIST_HEAD(&tp->t_dfops);
 	tp->t_firstblock = NULLFSBLOCK;
-	xfs_defer_init(tp, &tp->t_dfops_internal);
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error) {
@@ -929,7 +926,7 @@ __xfs_trans_commit(
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
 	 */
-	WARN_ON_ONCE(!list_empty(&tp->t_dfops->dop_intake) &&
+	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
 		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
 	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
 		error = xfs_defer_finish_noroll(&tp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1cdc7c0ebeac..c3d278e96ad1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -90,13 +90,10 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_FLUSHING	3
 
 /*
- * Deferred operations tracking structure.
+ * Deferred operation item relogging limits.
  */
 #define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
-struct xfs_defer_ops {
-	struct list_head	dop_intake;	/* unlogged pending work */
-};
 
 /*
  * This is the structure maintained for every active transaction.
@@ -114,7 +111,6 @@ typedef struct xfs_trans {
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	struct xfs_defer_ops	*t_dfops;	/* dfops reference */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
 	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
@@ -136,8 +132,8 @@ typedef struct xfs_trans {
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
+	struct list_head	t_dfops;	/* deferred operations */
 	unsigned long		t_pflags;	/* saved process flags state */
-	struct xfs_defer_ops	t_dfops_internal;
 } xfs_trans_t;
 
 /*
-- 
2.17.1

