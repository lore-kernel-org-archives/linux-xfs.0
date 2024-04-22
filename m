Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2939154432
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803979; cv=none; b=dqBIvG6FxQimYx78G+xJKBPAxctP9Fo2wLogvBGXezy5oMURQnQuh6xLa4Ofaf53M9KnVNlcLRRz6VcWhvooeXFE+o9Vc7dToGOpc8ckZDyKVuQUhI6FV27kCTT31QYRzl16h1bA3OHqsDqAoh7gS7wTm0gCzK6/FO9JT0F4gMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803979; c=relaxed/simple;
	bh=ojxpQjaEGx/XjEa3JtD3O2n1DdffhYcZOZJKf3ZsBl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVRGrgSF6itsWz0++aocxRHuzremSebxYns30kZVOd3z3jqQlbA+kf+X6RLFtrW9MqIKix8FE7vhMIEZtgrDDUXv3mUemuGLoF/zzm7Vsoup4oMAAsNbBDAvjZYh4BncLXbMXe4Fju6dfJ1/ZQNxqCVAQsWWmz9IdTYHYMyNNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/v+f/LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/v+f/LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B67C116B1;
	Mon, 22 Apr 2024 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803978;
	bh=ojxpQjaEGx/XjEa3JtD3O2n1DdffhYcZOZJKf3ZsBl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/v+f/LUNSM+63WmC3hNGyQvoYeHDo2JbZn4Ttr0zzr2MCyAuTwEIAY1XNwG3E/t9
	 SrdO5qVJ1kfO87H9eoZPUkOOjC9d+dxp5FDZf1C3Gmv0bmzQhpqeLziGK7qJaEhbN/
	 kv7NxHXvgn2hhUflvMg+HD+F+sbEegqrAHSsfYKotuNRQ7iVmT+kxUcC96oaLhkGff
	 9pOmHTiLnb/3BojfGnoehIGkrx9wE4mwER3arn7mb0Ds2h3sgi63j0wvwaLDpXcMaS
	 mH7l06/ATzbxWH5qPxcu16a7HZnV6bLFLyRbZ/6+/HwrJjYMmHlL3j4wRskYmP0pZE
	 KRmaY3lYzGt2Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 20/67] xfs: force small EFIs for reaping btree extents
Date: Mon, 22 Apr 2024 18:25:42 +0200
Message-ID: <20240422163832.858420-22-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 3f3cec031099c37513727efc978a12b6346e326d

Introduce the concept of a defer ops barrier to separate consecutively
queued pending work items of the same type.  With a barrier in place,
the two work items will be tracked separately, and receive separate log
intent items.  The goal here is to prevent reaping of old metadata
blocks from creating unnecessarily huge EFIs that could then run the
risk of overflowing the scrub transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 107 ++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_defer.h |   3 ++
 2 files changed, 99 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 58ad1881d..98f1cbe6a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -176,6 +176,58 @@ static struct kmem_cache	*xfs_defer_pending_cache;
  * Note that the continuation requested between t2 and t3 is likely to
  * reoccur.
  */
+STATIC struct xfs_log_item *
+xfs_defer_barrier_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+
+STATIC void
+xfs_defer_barrier_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	/* empty */
+}
+
+STATIC struct xfs_log_item *
+xfs_defer_barrier_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+STATIC int
+xfs_defer_barrier_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+STATIC void
+xfs_defer_barrier_cancel_item(
+	struct list_head		*item)
+{
+	ASSERT(0);
+}
+
+static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_defer_barrier_create_intent,
+	.abort_intent	= xfs_defer_barrier_abort_intent,
+	.create_done	= xfs_defer_barrier_create_done,
+	.finish_item	= xfs_defer_barrier_finish_item,
+	.cancel_item	= xfs_defer_barrier_cancel_item,
+};
 
 static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
@@ -184,6 +236,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
+	[XFS_DEFER_OPS_TYPE_BARRIER]	= &xfs_barrier_defer_type,
 };
 
 /* Create a log intent done item for a log intent item. */
@@ -773,6 +826,23 @@ xfs_defer_can_append(
 	return true;
 }
 
+/* Create a new pending item at the end of the transaction list. */
+static inline struct xfs_defer_pending *
+xfs_defer_alloc(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = type;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+
+	return dfp;
+}
+
 /* Add an item for later deferred processing. */
 struct xfs_defer_pending *
 xfs_defer_add(
@@ -787,23 +857,38 @@ xfs_defer_add(
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	dfp = xfs_defer_find_last(tp, type, ops);
-	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
-		/* Create a new pending item at the end of the intake list. */
-		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-				GFP_NOFS | __GFP_NOFAIL);
-		dfp->dfp_type = type;
-		dfp->dfp_intent = NULL;
-		dfp->dfp_done = NULL;
-		dfp->dfp_count = 0;
-		INIT_LIST_HEAD(&dfp->dfp_work);
-		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
-	}
+	if (!dfp || !xfs_defer_can_append(dfp, ops))
+		dfp = xfs_defer_alloc(tp, type);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	return dfp;
 }
 
+/*
+ * Add a defer ops barrier to force two otherwise adjacent deferred work items
+ * to be tracked separately and have separate log items.
+ */
+void
+xfs_defer_add_barrier(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_pending	*dfp;
+	const enum xfs_defer_ops_type	type = XFS_DEFER_OPS_TYPE_BARRIER;
+	const struct xfs_defer_op_type	*ops = defer_op_types[type];
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/* If the last defer op added was a barrier, we're done. */
+	dfp = xfs_defer_find_last(tp, type, ops);
+	if (dfp)
+		return;
+
+	xfs_defer_alloc(tp, type);
+
+	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
+}
+
 /*
  * Create a pending deferred work item to replay the recovered intent item
  * and add it to the list.
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index b0284154f..5b1990ef3 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -20,6 +20,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_ATTR,
+	XFS_DEFER_OPS_TYPE_BARRIER,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -163,4 +164,6 @@ xfs_defer_add_item(
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
+void xfs_defer_add_barrier(struct xfs_trans *tp);
+
 #endif /* __XFS_DEFER_H__ */
-- 
2.44.0

