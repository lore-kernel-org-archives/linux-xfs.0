Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60B9C433E1
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF03320748
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FuN5+J7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbgGAQv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732542AbgGAQvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcmA/8D2st/ikVsKrV9dg7pJ0kk9nKtzrNmzJdHufOg=;
        b=FuN5+J7WezLcyr2JrC0AZ6zbjtVmgbBegcmZVX2A+QB11wzwxPxOBHnOTOu+BYWV2cDKdo
        /frUmVgbCAGS9M3nnDxrBdekWrXI0BSbDUx+7kg5ce9knuh5T9nMX5BgZWC6GgpiP5GNmB
        dLlbMLXmIbZiGWjBoraqwM1bdVGTUKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-Tb4zE18tP26oGYf_ysn3IQ-1; Wed, 01 Jul 2020 12:51:20 -0400
X-MC-Unique: Tb4zE18tP26oGYf_ysn3IQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425CEEC1A1
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:19 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F35DB5C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:18 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: automatic log item relog mechanism
Date:   Wed,  1 Jul 2020 12:51:11 -0400
Message-Id: <20200701165116.47344-6-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that relog reservation is available and relog state tracking is
in place, all that remains to automatically relog items is the relog
mechanism itself. An item with relogging enabled is basically pinned
from writeback until relog is disabled. Instead of being written
back, the item must instead be periodically committed in a new
transaction to move it forward in the physical log. The purpose of
moving the item is to avoid long term tail pinning and thus avoid
log deadlocks for long running operations.

The ideal time to relog an item is in response to tail pushing
pressure. This accommodates the current workload at any given time
as opposed to a fixed time interval or log reservation heuristic,
which risks performance regression. This is essentially the same
heuristic that drives metadata writeback. XFS already implements
various log tail pushing heuristics that attempt to keep the log
progressing on an active fileystem under various workloads.

The act of relogging an item simply requires to add it to a
transaction and commit. This pushes the already dirty item into a
subsequent log checkpoint and frees up its previous location in the
on-disk log. Joining an item to a transaction of course requires
locking the item first, which means we have to be aware of
type-specific locks and lock ordering wherever the relog takes
place.

Fundamentally, this points to xfsaild as the ideal location to
process relog enabled items. xfsaild already processes log resident
items, is driven by log tail pushing pressure, processes arbitrary
log item types through callbacks, and is sensitive to type-specific
locking rules by design. The fact that automatic relogging
essentially diverts items between writeback or relog also suggests
xfsaild as an ideal location to process items one way or the other.

Of course, we don't want xfsaild to process transactions as it is a
critical component of the log subsystem for driving metadata
writeback and freeing up log space. Therefore, similar to how
xfsaild builds up a writeback queue of dirty items and queues writes
asynchronously, make xfsaild responsible only for directing pending
relog items into an appropriate queue and create an async
(workqueue) context for processing the queue. The workqueue context
utilizes the pre-reserved log reservation to drain the queue by
rolling a permanent transaction.

Update the AIL pushing infrastructure to support a new RELOG item
state. If a log item push returns the relog state, queue the item
for relog instead of writeback. On completion of a push cycle,
schedule the relog task at the same point metadata buffer I/O is
submitted. This allows items to be relogged automatically under the
same locking rules and pressure heuristics that govern metadata
writeback.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trace.h      |   2 +
 fs/xfs/xfs_trans.c      |  13 ++++-
 fs/xfs/xfs_trans.h      |   6 ++-
 fs/xfs/xfs_trans_ail.c  | 117 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_priv.h |  14 ++++-
 5 files changed, 147 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f6fd598c3912..1f81a47c7f6d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1068,6 +1068,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_relog_queue);
 DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
 DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ba2540d8a6c9..310beaccbc4c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -676,7 +676,8 @@ xfs_trans_relog_item(
 void
 xfs_trans_relog_item_cancel(
 	struct xfs_trans	*tp,
-	struct xfs_log_item	*lip)
+	struct xfs_log_item	*lip,
+	bool			wait)
 {
 	int			res;
 
@@ -684,6 +685,15 @@ xfs_trans_relog_item_cancel(
 		return;
 	trace_xfs_relog_item_cancel(lip);
 
+	/*
+	 * Must wait on active relog to complete before reclaiming reservation.
+	 * Currently a big hammer because the QUEUED state isn't cleared until
+	 * AIL (re)insertion. A separate state might be warranted.
+	 */
+	while (wait && wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOG_QUEUED,
+					   TASK_UNINTERRUPTIBLE, HZ))
+		xfs_log_force(lip->li_mountp, XFS_LOG_SYNC);
+
 	res = xfs_relog_calc_res(lip);
 	if (tp)
 		tp->t_ticket->t_curr_res += res;
@@ -777,6 +787,7 @@ xfs_trans_committed_bulk(
 
 		if (aborted)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		clear_and_wake_up_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags);
 
 		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
 			lip->li_ops->iop_release(lip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 70373e2b8f6d..7f409b0d456a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -64,6 +64,7 @@ struct xfs_log_item {
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
 #define	XFS_LI_RECOVERED 4	/* log intent item has been recovered */
 #define	XFS_LI_RELOG	5	/* automatically relog item */
+#define XFS_LI_RELOG_QUEUED 6	/* queued for relog */
 
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
@@ -71,7 +72,8 @@ struct xfs_log_item {
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
 	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }, \
-	{ (1 << XFS_LI_RELOG),		"RELOG" }
+	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
+	{ (1 << XFS_LI_RELOG_QUEUED),	"RELOG_QUEUED" }
 
 struct xfs_item_ops {
 	unsigned flags;
@@ -86,6 +88,7 @@ struct xfs_item_ops {
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
 	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
+	void (*iop_relog)(struct xfs_log_item *, struct xfs_trans *);
 };
 
 /*
@@ -104,6 +107,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_PINNED		1
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
+#define XFS_ITEM_RELOG		4
 
 /*
  * Deferred operation item relogging limits.
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 5c862821171f..6c4d219801a6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -17,6 +17,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 #ifdef DEBUG
 /*
@@ -152,6 +153,88 @@ xfs_ail_max_lsn(
 	return lsn;
 }
 
+/*
+ * Relog log items on the AIL relog queue.
+ *
+ * Note that relog is incompatible with filesystem freeze due to the
+ * multi-transaction nature of its users. The freeze sequence blocks all
+ * transactions and expects to drain the AIL. Allowing the relog transaction to
+ * proceed while freeze is in progress is not sufficient because it is not
+ * responsible for cancellation of relog state. The higher level operations must
+ * be guaranteed to progress to completion before the AIL can be drained of
+ * relog enabled items. This is currently accomplished by holding
+ * ->s_umount (quotaoff) or superblock write references (scrub) across the high
+ * level operations that depend on relog.
+ */
+static void
+xfs_ail_relog(
+	struct work_struct	*work)
+{
+	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
+						     ail_relog_work);
+	struct xfs_mount	*mp = ailp->ail_mount;
+	struct xfs_trans_res	tres = {};
+	struct xfs_trans	*tp;
+	struct xfs_log_item	*lip, *lipp;
+	int			error;
+	LIST_HEAD(relog_list);
+
+	/*
+	 * Open code allocation of an empty transaction and log ticket. The
+	 * ticket requires no initial reservation because the all outstanding
+	 * relog reservation is attached to log items.
+	 */
+	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	if (error)
+		goto out;
+	ASSERT(tp && !tp->t_ticket);
+	tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
+	tp->t_log_count = 1;
+	tp->t_ticket = xlog_ticket_alloc(mp->m_log, 0, 1, XFS_TRANSACTION,
+					 true, false, 0);
+	/* reset to zero to undo res overhead calculation on ticket alloc */
+	tp->t_ticket->t_curr_res = 0;
+	tp->t_ticket->t_unit_res = 0;
+	tp->t_log_res = 0;
+
+	spin_lock(&ailp->ail_lock);
+	while (!list_empty(&ailp->ail_relog_list)) {
+		list_splice_init(&ailp->ail_relog_list, &relog_list);
+		spin_unlock(&ailp->ail_lock);
+
+		list_for_each_entry_safe(lip, lipp, &relog_list, li_trans) {
+			list_del_init(&lip->li_trans);
+
+			trace_xfs_ail_relog(lip);
+			ASSERT(lip->li_ops->iop_relog);
+			if (lip->li_ops->iop_relog)
+				lip->li_ops->iop_relog(lip, tp);
+		}
+
+		error = xfs_trans_roll(&tp);
+		if (error) {
+			xfs_trans_cancel(tp);
+			goto out;
+		}
+
+		/*
+		 * Now that the transaction has rolled, reset the ticket to
+		 * zero to reflect that the log reservation held by the
+		 * attached items has been replenished.
+		 */
+		tp->t_ticket->t_curr_res = 0;
+		tp->t_ticket->t_unit_res = 0;
+		tp->t_log_res = 0;
+
+		spin_lock(&ailp->ail_lock);
+	}
+	spin_unlock(&ailp->ail_lock);
+	xfs_trans_cancel(tp);
+
+out:
+	ASSERT(!error || XFS_FORCED_SHUTDOWN(mp));
+}
+
 /*
  * The cursor keeps track of where our current traversal is up to by tracking
  * the next item in the list for us. However, for this to be safe, removing an
@@ -413,7 +496,7 @@ static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
 {
-	xfs_mount_t		*mp = ailp->ail_mount;
+	struct xfs_mount	*mp = ailp->ail_mount;
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
@@ -475,6 +558,23 @@ xfsaild_push(
 			ailp->ail_last_pushed_lsn = lsn;
 			break;
 
+		case XFS_ITEM_RELOG:
+			/*
+			 * The item requires a relog. Add to the relog queue
+			 * and set a bit to prevent further relog requests
+			 * until AIL reinsertion.
+			 */
+			if (test_and_set_bit(XFS_LI_RELOG_QUEUED,
+					     &lip->li_flags)) {
+				ailp->ail_log_flush++;
+				break;
+			}
+
+			trace_xfs_ail_relog_queue(lip);
+			ASSERT(list_empty(&lip->li_trans));
+			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
+			break;
+
 		case XFS_ITEM_FLUSHING:
 			/*
 			 * The item or its backing buffer is already being
@@ -541,6 +641,9 @@ xfsaild_push(
 	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
 		ailp->ail_log_flush++;
 
+	if (!list_empty(&ailp->ail_relog_list))
+		queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
+
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
 out_done:
 		/*
@@ -894,16 +997,25 @@ xfs_trans_ail_init(
 	spin_lock_init(&ailp->ail_lock);
 	INIT_LIST_HEAD(&ailp->ail_buf_list);
 	init_waitqueue_head(&ailp->ail_empty);
+	INIT_LIST_HEAD(&ailp->ail_relog_list);
+	INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
 	atomic64_set(&ailp->ail_relog_res, 0);
 
+	ailp->ail_relog_wq = alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
+					     mp->m_super->s_id);
+	if (!ailp->ail_relog_wq)
+		goto out_free_ailp;
+
 	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->ail_mount->m_super->s_id);
 	if (IS_ERR(ailp->ail_task))
-		goto out_free_ailp;
+		goto out_destroy_wq;
 
 	mp->m_ail = ailp;
 	return 0;
 
+out_destroy_wq:
+	destroy_workqueue(ailp->ail_relog_wq);
 out_free_ailp:
 	kmem_free(ailp);
 	return -ENOMEM;
@@ -917,5 +1029,6 @@ xfs_trans_ail_destroy(
 
 	ASSERT(atomic64_read(&ailp->ail_relog_res) == 0);
 	kthread_stop(ailp->ail_task);
+	destroy_workqueue(ailp->ail_relog_wq);
 	kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index d923e79676af..6c15a4f39b68 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -17,7 +17,8 @@ void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_relog_item(struct xfs_trans *, struct xfs_log_item *);
-void	xfs_trans_relog_item_cancel(struct xfs_trans *, struct xfs_log_item *);
+void	xfs_trans_relog_item_cancel(struct xfs_trans *, struct xfs_log_item *,
+				    bool wait);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
@@ -64,6 +65,9 @@ struct xfs_ail {
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
 	atomic64_t		ail_relog_res;
+	struct work_struct	ail_relog_work;
+	struct list_head	ail_relog_list;
+	struct workqueue_struct	*ail_relog_wq;
 };
 
 /*
@@ -85,6 +89,14 @@ xfs_ail_min(
 					li_ail);
 }
 
+static inline bool
+xfs_item_needs_relog(
+	struct xfs_log_item	*lip)
+{
+	return test_bit(XFS_LI_RELOG, &lip->li_flags) &&
+	       !test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags);
+}
+
 static inline void
 xfs_trans_ail_update(
 	struct xfs_ail		*ailp,
-- 
2.21.3

