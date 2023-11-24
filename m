Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484A3BB2A
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU/pqnJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFBDC433C7;
	Fri, 24 Nov 2023 23:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869646;
	bh=52DvklFKcgEtkwn1pwM6+uDHPgg4a0/MoCGkIT3zOrs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CU/pqnJTzJ4TlAMumJhjUjNmpknnLzxoYmrf+qEkZiI/ThLJeMUeWXvEZQvFKvxqU
	 VEcefJXk0QItdj0eNrxWuBKcJzkSNR4WV5JnLm2gfjbrwyGLLjdFQ3u29Uy6XPPJHr
	 KK08ByMPetVU77SntD8lazZ196GvBagqbgB7s9ld3pH8FQIbNniPN1KR7Zj/jlrmqb
	 42K6IzYb6+DWWKaJdFpQ7qcGqDZ+swMQL20QS7TISZWdJdlZfGOY11EytY/gi++qer
	 WlQmZBn4GhSSJkbZFlXbQKEwihdOdjlDHaaJmBLooLH5ayv9LFkXh8qPPFF3EzGwQW
	 p2wbJbEVse3PQ==
Date: Fri, 24 Nov 2023 15:47:25 -0800
Subject: [PATCH 2/7] xfs: allow pausing of pending deferred work items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926160.2768790.13588639927943819972.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   98 +++++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_defer.h |   17 +++++++-
 fs/xfs/xfs_trace.h        |   13 +++++-
 3 files changed, 112 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6c283b30ea054..6604eb50058ba 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -417,7 +417,7 @@ xfs_defer_cancel_list(
  * done item to release the intent item; and then log a new intent item.
  * The caller should provide a fresh transaction and roll it after we're done.
  */
-static int
+static void
 xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
@@ -458,10 +458,6 @@ xfs_defer_relog(
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
 	}
-
-	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
-		return xfs_defer_trans_roll(tpp);
-	return 0;
 }
 
 /*
@@ -517,6 +513,24 @@ xfs_defer_finish_one(
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
@@ -532,6 +546,7 @@ xfs_defer_finish_noroll(
 	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
+	LIST_HEAD(dop_paused);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -550,6 +565,8 @@ xfs_defer_finish_noroll(
 		 */
 		int has_intents = xfs_defer_create_intents(*tp);
 
+		xfs_defer_isolate_paused(*tp, &dop_paused);
+
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
 		if (has_intents < 0) {
@@ -562,22 +579,33 @@ xfs_defer_finish_noroll(
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
@@ -590,6 +618,9 @@ int
 xfs_defer_finish(
 	struct xfs_trans	**tp)
 {
+#ifdef DEBUG
+	struct xfs_defer_pending *dfp;
+#endif
 	int			error;
 
 	/*
@@ -609,7 +640,10 @@ xfs_defer_finish(
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
@@ -621,6 +655,7 @@ xfs_defer_cancel(
 	struct xfs_mount	*mp = tp->t_mountp;
 
 	trace_xfs_defer_cancel(tp, _RET_IP_);
+	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
@@ -651,6 +686,10 @@ xfs_defer_try_append(
 	if (dfp->dfp_intent)
 		return NULL;
 
+	/* Paused items cannot absorb more work */
+	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
+		return NULL;
+
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)
 		return NULL;
@@ -659,7 +698,7 @@ xfs_defer_try_append(
 }
 
 /* Add an item for later deferred processing. */
-void
+struct xfs_defer_pending *
 xfs_defer_add(
 	struct xfs_trans		*tp,
 	enum xfs_defer_ops_type		type,
@@ -687,6 +726,8 @@ xfs_defer_add(
 	list_add_tail(li, &dfp->dfp_work);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	dfp->dfp_count++;
+
+	return dfp;
 }
 
 /*
@@ -962,3 +1003,36 @@ xfs_defer_destroy_item_caches(void)
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
index 8788ad5f6a731..094ff9062b251 100644
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

