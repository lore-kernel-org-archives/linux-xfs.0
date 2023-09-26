Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF0CE7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjI0APD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjI0ANC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A81F9D9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:31:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203CC433C7;
        Tue, 26 Sep 2023 23:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771099;
        bh=M+GTiHi7z0MzrioKFxJ0rC1Xn6RxRgWcnLXNbo84Hv4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dKziU1wfiF+n4z+9gaLPOwhxp6s3gC7Z2rzJG56PUO+qnvPp45zuTb+/lruXTfOCe
         fF3k/kiWrV66sej6CFmEUGdmPKYKxiJk1WD99oFCIa0x33N90jYQjj8zfqgR/JEvuC
         hI9MZ+BNQv820GuB2fGEyZaAHQKWXlbmCJnN3sm2yz8J182o8mt7UWLyn0c84eOF7v
         BuANwK5YJaWtgAAwhaYP211MYX55zBusqHek5RH/cdAQe9A4qtk6PA+nk4N3yNS5Fp
         dQnT328ixd7xn5xsK3zwLgm/Gxbw5ES8SwODq0uBzSpjYQkMqy+eA8LRfSBC+vVyf2
         WN1EGM2JYSLRw==
Date:   Tue, 26 Sep 2023 16:31:38 -0700
Subject: [PATCH 2/7] xfs: allow pausing of pending deferred work items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059178.3312911.7770487562460001097.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Traditionally, all pending deferred work attached to a transaction is
finished when one of the xfs_defer_finish* functions is called.
However, online repair wants to be able to allocate space for a new data
structure, format a new metadata structure into the allocated space, and
commit that into the filesystem.

As a hedge against system crashes during repairs, we also want to log
some EFI items for the allocated space speculatively, and cancel them if
we elect to commit the new data structure.

Therefore, introduce the idea of pausing a pending deferred work item.
Log intent items are still created for paused items and relogged as
necessary.  However, paused items are pushed onto a side list before we
start calling ->finish_item, and the whole list is reattach to the
transaction afterwards.  New work items are never attached to paused
pending items.

Modify xfs_defer_cancel to clean up pending deferred work items holding
a log intent item but not a log intent done item, since that is now
possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   98 +++++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_defer.h |   17 +++++++-
 fs/xfs/xfs_trace.h        |   13 +++++-
 3 files changed, 112 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ad41c6d0113ce..6ed1ab8a7e522 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -410,7 +410,7 @@ xfs_defer_cancel_list(
  * done item to release the intent item; and then log a new intent item.
  * The caller should provide a fresh transaction and roll it after we're done.
  */
-static int
+static void
 xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
@@ -451,10 +451,6 @@ xfs_defer_relog(
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
 	}
-
-	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
-		return xfs_defer_trans_roll(tpp);
-	return 0;
 }
 
 /*
@@ -510,6 +506,24 @@ xfs_defer_finish_one(
 	return error;
 }
 
+/* Move all paused deferred work from @tp to @paused_list. */
+static void
+xfs_defer_isolate_paused(
+	struct xfs_trans		*tp,
+	struct list_head		*paused_list)
+{
+	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*pli;
+
+	list_for_each_entry_safe(dfp, pli, &tp->t_dfops, dfp_list) {
+		if (!(dfp->dfp_flags & XFS_DEFER_PAUSED))
+			continue;
+
+		list_move_tail(&dfp->dfp_list, paused_list);
+		trace_xfs_defer_isolate_paused(tp->t_mountp, dfp);
+	}
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -525,6 +539,7 @@ xfs_defer_finish_noroll(
 	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
+	LIST_HEAD(dop_paused);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -543,6 +558,8 @@ xfs_defer_finish_noroll(
 		 */
 		int has_intents = xfs_defer_create_intents(*tp);
 
+		xfs_defer_isolate_paused(*tp, &dop_paused);
+
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
 		if (has_intents < 0) {
@@ -555,22 +572,33 @@ xfs_defer_finish_noroll(
 				goto out_shutdown;
 
 			/* Relog intent items to keep the log moving. */
-			error = xfs_defer_relog(tp, &dop_pending);
-			if (error)
-				goto out_shutdown;
+			xfs_defer_relog(tp, &dop_pending);
+			xfs_defer_relog(tp, &dop_paused);
+
+			if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+				error = xfs_defer_trans_roll(tp);
+				if (error)
+					goto out_shutdown;
+			}
 		}
 
-		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
-				       dfp_list);
+		dfp = list_first_entry_or_null(&dop_pending,
+				struct xfs_defer_pending, dfp_list);
+		if (!dfp)
+			break;
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
 	}
 
+	/* Requeue the paused items in the outgoing transaction. */
+	list_splice_tail_init(&dop_paused, &(*tp)->t_dfops);
+
 	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
 
 out_shutdown:
+	list_splice_tail_init(&dop_paused, &dop_pending);
 	xfs_defer_trans_abort(*tp, &dop_pending);
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
@@ -583,6 +611,9 @@ int
 xfs_defer_finish(
 	struct xfs_trans	**tp)
 {
+#ifdef DEBUG
+	struct xfs_defer_pending *dfp;
+#endif
 	int			error;
 
 	/*
@@ -602,7 +633,10 @@ xfs_defer_finish(
 	}
 
 	/* Reset LOWMODE now that we've finished all the dfops. */
-	ASSERT(list_empty(&(*tp)->t_dfops));
+#ifdef DEBUG
+	list_for_each_entry(dfp, &(*tp)->t_dfops, dfp_list)
+		ASSERT(dfp->dfp_flags & XFS_DEFER_PAUSED);
+#endif
 	(*tp)->t_flags &= ~XFS_TRANS_LOWMODE;
 	return 0;
 }
@@ -614,6 +648,7 @@ xfs_defer_cancel(
 	struct xfs_mount	*mp = tp->t_mountp;
 
 	trace_xfs_defer_cancel(tp, _RET_IP_);
+	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
@@ -644,6 +679,10 @@ xfs_defer_try_append(
 	if (dfp->dfp_intent)
 		return NULL;
 
+	/* Paused items cannot absorb more work */
+	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
+		return NULL;
+
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)
 		return NULL;
@@ -652,7 +691,7 @@ xfs_defer_try_append(
 }
 
 /* Add an item for later deferred processing. */
-void
+struct xfs_defer_pending *
 xfs_defer_add(
 	struct xfs_trans		*tp,
 	enum xfs_defer_ops_type		type,
@@ -680,6 +719,8 @@ xfs_defer_add(
 	list_add_tail(li, &dfp->dfp_work);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	dfp->dfp_count++;
+
+	return dfp;
 }
 
 /*
@@ -954,3 +995,36 @@ xfs_defer_destroy_item_caches(void)
 	xfs_rmap_intent_destroy_cache();
 	xfs_defer_destroy_cache();
 }
+
+/*
+ * Mark a deferred work item so that it will be requeued indefinitely without
+ * being finished.  Caller must ensure there are no data dependencies on this
+ * work item in the meantime.
+ */
+void
+xfs_defer_item_pause(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	ASSERT(!(dfp->dfp_flags & XFS_DEFER_PAUSED));
+
+	dfp->dfp_flags |= XFS_DEFER_PAUSED;
+
+	trace_xfs_defer_item_pause(tp->t_mountp, dfp);
+}
+
+/*
+ * Release a paused deferred work item so that it will be finished during the
+ * next transaction roll.
+ */
+void
+xfs_defer_item_unpause(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	ASSERT(dfp->dfp_flags & XFS_DEFER_PAUSED);
+
+	dfp->dfp_flags &= ~XFS_DEFER_PAUSED;
+
+	trace_xfs_defer_item_unpause(tp->t_mountp, dfp);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3c..7fb4f60e5e4c5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -34,11 +34,24 @@ struct xfs_defer_pending {
 	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	struct xfs_log_item		*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
+	unsigned int			dfp_flags;
 	enum xfs_defer_ops_type		dfp_type;
 };
 
-void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
-		struct list_head *h);
+/*
+ * Create a log intent item for this deferred item, but don't actually finish
+ * the work.  Caller must clear this before the final transaction commit.
+ */
+#define XFS_DEFER_PAUSED	(1U << 0)
+
+#define XFS_DEFER_PENDING_STRINGS \
+	{ XFS_DEFER_PAUSED,	"paused" }
+
+void xfs_defer_item_pause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
+void xfs_defer_item_unpause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
+
+struct xfs_defer_pending *xfs_defer_add(struct xfs_trans *tp,
+		enum xfs_defer_ops_type type, struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 void xfs_defer_cancel(struct xfs_trans *);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3926cf7f2a6ed..514095b6ba2bd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2551,6 +2551,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 		__field(dev_t, dev)
 		__field(int, type)
 		__field(void *, intent)
+		__field(unsigned int, flags)
 		__field(char, committed)
 		__field(int, nr)
 	),
@@ -2558,13 +2559,15 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->type = dfp->dfp_type;
 		__entry->intent = dfp->dfp_intent;
+		__entry->flags = dfp->dfp_flags;
 		__entry->committed = dfp->dfp_done != NULL;
 		__entry->nr = dfp->dfp_count;
 	),
-	TP_printk("dev %d:%d optype %d intent %p committed %d nr %d",
+	TP_printk("dev %d:%d optype %d intent %p flags %s committed %d nr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->intent,
+		  __print_flags(__entry->flags, "|", XFS_DEFER_PENDING_STRINGS),
 		  __entry->committed,
 		  __entry->nr)
 )
@@ -2675,6 +2678,9 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_isolate_paused);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_pause);
+DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_unpause);
 
 #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
@@ -2692,6 +2698,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 		__field(void *, intent)
 		__field(void *, item)
 		__field(char, committed)
+		__field(unsigned int, flags)
 		__field(int, nr)
 	),
 	TP_fast_assign(
@@ -2700,13 +2707,15 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 		__entry->intent = dfp->dfp_intent;
 		__entry->item = item;
 		__entry->committed = dfp->dfp_done != NULL;
+		__entry->flags = dfp->dfp_flags;
 		__entry->nr = dfp->dfp_count;
 	),
-	TP_printk("dev %d:%d optype %d intent %p item %p committed %d nr %d",
+	TP_printk("dev %d:%d optype %d intent %p item %p flags %s committed %d nr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->intent,
 		  __entry->item,
+		  __print_flags(__entry->flags, "|", XFS_DEFER_PENDING_STRINGS),
 		  __entry->committed,
 		  __entry->nr)
 )

