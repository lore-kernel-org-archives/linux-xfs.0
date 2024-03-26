Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D038128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422421; cv=none; b=qyzzWUohEATWC45HJNq3szO6E86pp2Y90gCwdJyB+injjvtnOIYW089o23/KBpXKOn9NiOOtjXKOwxfsQoqA+1cjmolewcZ0MhO+Bfi/rfPniwK6Dqtl2Z56LRsuQn+fdrVIlIyqdr2TY2jeAEcs1JcVY03z1LmOik2o5a69jio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422421; c=relaxed/simple;
	bh=wlbRHAmE3WjXoFaHtpi0NFIp3DFXk3LF/MOo2GtX2yY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j1Do59bPYtAD9LRhAfKRwQ0/2GiuQa7mIcnIJNFTm2Z2ofHH2kom1j0L1uCFB37n1Vxy9S/2JJRFo3Iy31hOb/BjJIij+FtVdT9F3ayu9DykAnZDl0+OZ0rR6mgStnkPLCtansJNSLzRYhcpfna7AGK3qJAJg0y/beHes+/YwNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4ogpULo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4ogpULo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F1C433F1;
	Tue, 26 Mar 2024 03:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422420;
	bh=wlbRHAmE3WjXoFaHtpi0NFIp3DFXk3LF/MOo2GtX2yY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y4ogpULo6wS7TNMO2SgocKbMkUVSwg3BJ1ixAtozcjsFU0maanuNk64VBwJxbxzQk
	 IzIIfNOOQ0XDSUwQBD119IbJK6nZEpu1XUPheRMLR/vGCHkaO1DoKycGofBgF/Bu1a
	 1SLvAzPMHDVnEo7l4bzAMKyYWlcIUBC9GqIU/xSTCskQOuDADF6HFG4j0VSncZRSvL
	 aoSb16xbAjj57t2B+xc1WRsidWb5oYYIpF0WuyhB2AiW7xFNBnr+cYluKJCaNERbjh
	 yCaiyTuRa4iWG26P4mSEFscsGilKAE0UHbYEHWDYnS39tWJ+vtle42X3ckQ6saCBNY
	 wuh5yxLk5dZFw==
Date: Mon, 25 Mar 2024 20:07:00 -0700
Subject: [PATCH 16/67] xfs: allow pausing of pending deferred work items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127193.2212320.3325273444534508621.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4dffb2cbb4839fd6f9bbac0b3fd06cc9015cbb9b

Traditionally, all pending deferred work attached to a transaction is
finished when one of the xfs_defer_finish* functions is called.
However, online repair wants to be able to allocate space for a new data
structure, format a new metadata structure into the allocated space, and

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 include/list.h      |   14 +++++++
 include/xfs_trace.h |    3 ++
 libxfs/xfs_defer.c  |   97 +++++++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_defer.h  |   17 ++++++++-
 4 files changed, 117 insertions(+), 14 deletions(-)


diff --git a/include/list.h b/include/list.h
index e59cbd53734b..852a355aae08 100644
--- a/include/list.h
+++ b/include/list.h
@@ -152,6 +152,20 @@ static inline void list_splice_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_first_entry_or_null - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_or_null(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = head__->next; \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 #define container_of(ptr, type, member) ({			\
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index c79a4bd74dcb..f172b61d6a55 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -228,6 +228,9 @@
 #define trace_xfs_defer_finish_done(a,b)	((void) 0)
 #define trace_xfs_defer_cancel_list(a,b)	((void) 0)
 #define trace_xfs_defer_create_intent(a,b)	((void) 0)
+#define trace_xfs_defer_isolate_paused(...)	((void) 0)
+#define trace_xfs_defer_item_pause(...)		((void) 0)
+#define trace_xfs_defer_item_unpause(...)	((void) 0)
 
 #define trace_xfs_bmap_free_defer(...)		((void) 0)
 #define trace_xfs_bmap_free_deferred(...)	((void) 0)
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 200d1b300f95..58ad1881d49d 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -481,7 +481,7 @@ xfs_defer_relog_intent(
  * done item to release the intent item; and then log a new intent item.
  * The caller should provide a fresh transaction and roll it after we're done.
  */
-static int
+static void
 xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
@@ -523,10 +523,6 @@ xfs_defer_relog(
 
 		xfs_defer_relog_intent(*tpp, dfp);
 	}
-
-	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
-		return xfs_defer_trans_roll(tpp);
-	return 0;
 }
 
 /*
@@ -582,6 +578,24 @@ xfs_defer_finish_one(
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
@@ -597,6 +611,7 @@ xfs_defer_finish_noroll(
 	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
+	LIST_HEAD(dop_paused);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -615,6 +630,8 @@ xfs_defer_finish_noroll(
 		 */
 		int has_intents = xfs_defer_create_intents(*tp);
 
+		xfs_defer_isolate_paused(*tp, &dop_paused);
+
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
 		if (has_intents < 0) {
@@ -627,22 +644,33 @@ xfs_defer_finish_noroll(
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
@@ -655,6 +683,9 @@ int
 xfs_defer_finish(
 	struct xfs_trans	**tp)
 {
+#ifdef DEBUG
+	struct xfs_defer_pending *dfp;
+#endif
 	int			error;
 
 	/*
@@ -674,7 +705,10 @@ xfs_defer_finish(
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
@@ -686,6 +720,7 @@ xfs_defer_cancel(
 	struct xfs_mount	*mp = tp->t_mountp;
 
 	trace_xfs_defer_cancel(tp, _RET_IP_);
+	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
@@ -727,6 +762,10 @@ xfs_defer_can_append(
 	if (dfp->dfp_intent)
 		return false;
 
+	/* Paused items cannot absorb more work */
+	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
+		return NULL;
+
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)
 		return false;
@@ -735,7 +774,7 @@ xfs_defer_can_append(
 }
 
 /* Add an item for later deferred processing. */
-void
+struct xfs_defer_pending *
 xfs_defer_add(
 	struct xfs_trans		*tp,
 	enum xfs_defer_ops_type		type,
@@ -762,6 +801,7 @@ xfs_defer_add(
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
+	return dfp;
 }
 
 /*
@@ -1087,3 +1127,36 @@ xfs_defer_destroy_item_caches(void)
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 78d6dcd1af2c..b0284154f4e0 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
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
 int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);

