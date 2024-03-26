Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE17428EA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422577; cv=none; b=iyhxX+BHkQfOf04DhuNUuj12NfAMWpB/ML67O0cUPO6NAwK+QSfeTYE5iDa2dF6Ma/9iZoaLUTNov4uceOhj//NfH1zclZ2v0D39EBjyDCswHXg9J3E/f5Tj3jVtx+lC0T9e1vyU87snlNt1d7FTq7aTHnNhyyHuupCosQHzHoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422577; c=relaxed/simple;
	bh=vEZrwFG0BnRvmqK8VaRO2YeoEJdvG6mFP+v3MAYyFDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4kYst3jSYqF23gDds87Rwmb9SURVqBRe6NdLbCsZt0wyvX4QSyus7/afMJSskO0wOR3ddoUgiwOA/zUhKxcCy0OKe1FJFBPOtrh12Bln+6xNpXA9aVl/Yzwl/QoMUY8ncvKY7tLNQP4gmM9XBEk3JXW/r515aRFHIoC+DAM8dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izmDd/I8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izmDd/I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D31DC433C7;
	Tue, 26 Mar 2024 03:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422577;
	bh=vEZrwFG0BnRvmqK8VaRO2YeoEJdvG6mFP+v3MAYyFDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=izmDd/I8JQyN2LzR37UEEq1kTEHSOgEWdawE/wcFz3JvBOQYWZ5YA/eB3Ns3ah0Xw
	 tjRLhAAz+EBxoHJTZwAI1bIWnYg3+65mK44v1Ir6XgkOwjSVYRoLLD/ZTtryTMTQdK
	 jW1WMaEUHvXF+70Xr0SmrooGWb1yyl9cBq5fjPBWTzjBr/cROuBWclfaJoIwAChtvp
	 bvxNc66Y8CZhDatjy/d0iIc94nELAor5c8KdF4BKRreK3zK+s6kuRaBGmlMphn29JH
	 xnRFQilG1+0Aba1xWSoqi6uiD/xhU1JUBejdguvOnrwZ6ItTDUApWUpiGxzNVX4GkD
	 mCyZ2umW5WNoA==
Date: Mon, 25 Mar 2024 20:09:36 -0700
Subject: [PATCH 26/67] xfs: store an ops pointer in struct xfs_defer_pending
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127337.2212320.6940452972722781203.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7f2f7531e0d455f1abb9f48fbbe17c37e8742590

The dfp_type field in struct xfs_defer_pending is only used to either
look up the operations associated with the pending word or in trace
points.  Replace it with a direct pointer to the operations vector,
and store a pretty name in the vector for tracing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/defer_item.c |    6 ++++++
 libxfs/xfs_defer.c  |   43 +++++++++++++++++--------------------------
 libxfs/xfs_defer.h  |    5 +++--
 3 files changed, 26 insertions(+), 28 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b8afda0ceb58..014589f82ec8 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -152,6 +152,7 @@ xfs_extent_free_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.name		= "extent_free",
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
@@ -195,6 +196,7 @@ xfs_agfl_free_finish_item(
 
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.name		= "agfl_free",
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
 	.create_done	= xfs_extent_free_create_done,
@@ -306,6 +308,7 @@ xfs_rmap_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.name		= "rmap",
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
 	.create_done	= xfs_rmap_update_create_done,
@@ -424,6 +427,7 @@ xfs_refcount_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.name		= "refcount",
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
 	.create_done	= xfs_refcount_update_create_done,
@@ -546,6 +550,7 @@ xfs_bmap_update_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.name		= "bmap",
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
 	.create_done	= xfs_bmap_update_create_done,
@@ -641,6 +646,7 @@ xfs_attr_cancel_item(
 }
 
 const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.name		= "attr",
 	.max_items	= 1,
 	.create_intent	= xfs_attr_create_intent,
 	.abort_intent	= xfs_attr_abort_intent,
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 98f1cbe6a67f..bb5411b84545 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -245,7 +245,6 @@ xfs_defer_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
 	/* If there is no log intent item, there can be no log done item. */
@@ -260,7 +259,7 @@ xfs_defer_create_done(
 	 * 2.) shuts down the filesystem
 	 */
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lip = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	lip = dfp->dfp_ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
 	if (!lip)
 		return;
 
@@ -281,13 +280,13 @@ xfs_defer_create_intent(
 	struct xfs_defer_pending	*dfp,
 	bool				sort)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
 	if (dfp->dfp_intent)
 		return 1;
 
-	lip = ops->create_intent(tp, &dfp->dfp_work, dfp->dfp_count, sort);
+	lip = dfp->dfp_ops->create_intent(tp, &dfp->dfp_work, dfp->dfp_count,
+			sort);
 	if (!lip)
 		return 0;
 	if (IS_ERR(lip))
@@ -332,12 +331,10 @@ xfs_defer_pending_abort(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
-
 	trace_xfs_defer_pending_abort(mp, dfp);
 
 	if (dfp->dfp_intent && !dfp->dfp_done) {
-		ops->abort_intent(dfp->dfp_intent);
+		dfp->dfp_ops->abort_intent(dfp->dfp_intent);
 		dfp->dfp_intent = NULL;
 	}
 }
@@ -347,7 +344,6 @@ xfs_defer_pending_cancel_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct list_head		*pwi;
 	struct list_head		*n;
 
@@ -358,7 +354,7 @@ xfs_defer_pending_cancel_work(
 		list_del(pwi);
 		dfp->dfp_count--;
 		trace_xfs_defer_cancel_item(mp, dfp, pwi);
-		ops->cancel_item(pwi);
+		dfp->dfp_ops->cancel_item(pwi);
 	}
 	ASSERT(dfp->dfp_count == 0);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
@@ -516,11 +512,10 @@ xfs_defer_relog_intent(
 	struct xfs_defer_pending	*dfp)
 {
 	struct xfs_log_item		*lip;
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
 	xfs_defer_create_done(tp, dfp);
 
-	lip = ops->relog_intent(tp, dfp->dfp_intent, dfp->dfp_done);
+	lip = dfp->dfp_ops->relog_intent(tp, dfp->dfp_intent, dfp->dfp_done);
 	if (lip) {
 		xfs_trans_add_item(tp, lip);
 		set_bit(XFS_LI_DIRTY, &lip->li_flags);
@@ -587,7 +582,7 @@ xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
 	int				error;
@@ -784,7 +779,6 @@ xfs_defer_cancel(
 static inline struct xfs_defer_pending *
 xfs_defer_find_last(
 	struct xfs_trans		*tp,
-	enum xfs_defer_ops_type		type,
 	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp = NULL;
@@ -797,7 +791,7 @@ xfs_defer_find_last(
 			dfp_list);
 
 	/* Wrong type? */
-	if (dfp->dfp_type != type)
+	if (dfp->dfp_ops != ops)
 		return NULL;
 	return dfp;
 }
@@ -830,13 +824,13 @@ xfs_defer_can_append(
 static inline struct xfs_defer_pending *
 xfs_defer_alloc(
 	struct xfs_trans		*tp,
-	enum xfs_defer_ops_type		type)
+	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 			GFP_NOFS | __GFP_NOFAIL);
-	dfp->dfp_type = type;
+	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
 
@@ -856,9 +850,9 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	dfp = xfs_defer_find_last(tp, type, ops);
+	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
-		dfp = xfs_defer_alloc(tp, type);
+		dfp = xfs_defer_alloc(tp, ops);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -874,17 +868,15 @@ xfs_defer_add_barrier(
 	struct xfs_trans		*tp)
 {
 	struct xfs_defer_pending	*dfp;
-	const enum xfs_defer_ops_type	type = XFS_DEFER_OPS_TYPE_BARRIER;
-	const struct xfs_defer_op_type	*ops = defer_op_types[type];
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	/* If the last defer op added was a barrier, we're done. */
-	dfp = xfs_defer_find_last(tp, type, ops);
+	dfp = xfs_defer_find_last(tp, &xfs_barrier_defer_type);
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(tp, type);
+	xfs_defer_alloc(tp, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
@@ -903,7 +895,7 @@ xfs_defer_start_recovery(
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 			GFP_NOFS | __GFP_NOFAIL);
-	dfp->dfp_type = dfp_type;
+	dfp->dfp_ops = defer_op_types[dfp_type];
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, r_dfops);
@@ -929,13 +921,12 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	int				error;
 
-	error = ops->recover_work(dfp, capture_list);
+	error = dfp->dfp_ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+				dfp->dfp_ops->recover_work);
 	return error;
 }
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 5b1990ef3e5d..957a06278e88 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -34,9 +34,9 @@ struct xfs_defer_pending {
 	struct list_head		dfp_work;	/* work items */
 	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	struct xfs_log_item		*dfp_done;	/* log done item */
+	const struct xfs_defer_op_type	*dfp_ops;
 	unsigned int			dfp_count;	/* # extent items */
 	unsigned int			dfp_flags;
-	enum xfs_defer_ops_type		dfp_type;
 };
 
 /*
@@ -61,6 +61,8 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
+	const char		*name;
+	unsigned int		max_items;
 	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
 			struct list_head *items, unsigned int count, bool sort);
 	void (*abort_intent)(struct xfs_log_item *intent);
@@ -76,7 +78,6 @@ struct xfs_defer_op_type {
 	struct xfs_log_item *(*relog_intent)(struct xfs_trans *tp,
 			struct xfs_log_item *intent,
 			struct xfs_log_item *done_item);
-	unsigned int		max_items;
 };
 
 extern const struct xfs_defer_op_type xfs_bmap_update_defer_type;

