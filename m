Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K1LPX//8"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1762AB
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 01:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mCuzOkboSfizH+Mdtf/xb64+GyDAgt5sC8TpfK2MLZI=; b=K1LPX//8iEvtYV3JFI9o3R4HXJ
	Tax4qfSaYRXYkDL/va3m/MNRYXVMILTwP12POeZ8I3N2jVZ32y3lqtKWqMGGGMhJQlCrIjrDX+0L1
	6PrwpmvX2FNgWAGhZbZqlqlyTOnI+JFoU7FzPnBrRvOKdZhRZynyCjWWN3kwJV3jbHny0X3N9xkCI
	5bNtFthWcLksH08FJFQlF+QLCGBRY43jpscVLMJKlpI+uyC9jmoLZEXmuuGg6Epkak12MTbaAJcJp
	HtCds1kL1nju6KOT54f+86/FWLzLrde66pWMt4iCoea+S9JOgd6/OZHQhtb9a9T35n5fyWo04f9kf
	7ZyUZ1pw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDLCY-00E6e3-1L;
	Wed, 13 Dec 2023 09:06:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 3/5] xfs: store an ops pointer in struct xfs_defer_pending
Date: Wed, 13 Dec 2023 10:06:31 +0100
Message-Id: <20231213090633.231707-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231213090633.231707-1-hch@lst.de>
References: <20231213090633.231707-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The dfp_type field in struct xfs_defer_pending is only used to either
look up the operations associated with the pending word or in trace
points.  Replace it with a direct pointer to the operations vector,
and store a pretty name in the vector for tracing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  | 43 +++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_defer.h  |  5 +++--
 fs/xfs/xfs_attr_item.c     |  1 +
 fs/xfs/xfs_bmap_item.c     |  1 +
 fs/xfs/xfs_extfree_item.c  |  2 ++
 fs/xfs/xfs_refcount_item.c |  1 +
 fs/xfs/xfs_rmap_item.c     |  1 +
 fs/xfs/xfs_trace.h         | 16 +++++++-------
 8 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ecc2f7ec699169..e70881ae5cc597 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -251,7 +251,6 @@ xfs_defer_create_done(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
 	/* If there is no log intent item, there can be no log done item. */
@@ -266,7 +265,7 @@ xfs_defer_create_done(
 	 * 2.) shuts down the filesystem
 	 */
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lip = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	lip = dfp->dfp_ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
 	if (!lip)
 		return;
 
@@ -287,13 +286,13 @@ xfs_defer_create_intent(
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
@@ -338,12 +337,10 @@ xfs_defer_pending_abort(
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
@@ -353,7 +350,6 @@ xfs_defer_pending_cancel_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct list_head		*pwi;
 	struct list_head		*n;
 
@@ -364,7 +360,7 @@ xfs_defer_pending_cancel_work(
 		list_del(pwi);
 		dfp->dfp_count--;
 		trace_xfs_defer_cancel_item(mp, dfp, pwi);
-		ops->cancel_item(pwi);
+		dfp->dfp_ops->cancel_item(pwi);
 	}
 	ASSERT(dfp->dfp_count == 0);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
@@ -522,11 +518,10 @@ xfs_defer_relog_intent(
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
@@ -593,7 +588,7 @@ xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
 {
-	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
 	int				error;
@@ -790,7 +785,6 @@ xfs_defer_cancel(
 static inline struct xfs_defer_pending *
 xfs_defer_find_last(
 	struct xfs_trans		*tp,
-	enum xfs_defer_ops_type		type,
 	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp = NULL;
@@ -803,7 +797,7 @@ xfs_defer_find_last(
 			dfp_list);
 
 	/* Wrong type? */
-	if (dfp->dfp_type != type)
+	if (dfp->dfp_ops != ops)
 		return NULL;
 	return dfp;
 }
@@ -836,13 +830,13 @@ xfs_defer_can_append(
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
 
@@ -862,9 +856,9 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	dfp = xfs_defer_find_last(tp, type, ops);
+	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
-		dfp = xfs_defer_alloc(tp, type);
+		dfp = xfs_defer_alloc(tp, ops);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -880,17 +874,15 @@ xfs_defer_add_barrier(
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
@@ -909,7 +901,7 @@ xfs_defer_start_recovery(
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 			GFP_NOFS | __GFP_NOFAIL);
-	dfp->dfp_type = dfp_type;
+	dfp->dfp_ops = defer_op_types[dfp_type];
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, r_dfops);
@@ -935,13 +927,12 @@ xfs_defer_finish_recovery(
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
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 5b1990ef3e5df4..957a06278e880d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
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
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4e0eaa2640e0d2..beae2de824507b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -677,6 +677,7 @@ xfs_attr_create_done(
 }
 
 const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.name		= "attr",
 	.max_items	= 1,
 	.create_intent	= xfs_attr_create_intent,
 	.abort_intent	= xfs_attr_abort_intent,
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index bc48d733634a1f..f43abf0b648641 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -563,6 +563,7 @@ xfs_bmap_relog_intent(
 }
 
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.name		= "bmap",
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_bmap_update_create_intent,
 	.abort_intent	= xfs_bmap_update_abort_intent,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3e3469504271eb..e67907a379c8e8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -670,6 +670,7 @@ xfs_extent_free_relog_intent(
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.name		= "extent_free",
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
@@ -682,6 +683,7 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 
 /* sub-type with special handling for AGFL deferred frees */
 const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.name		= "agfl_free",
 	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_extent_free_create_intent,
 	.abort_intent	= xfs_extent_free_abort_intent,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 9974be81cb2bae..b08839550f34a3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,6 +523,7 @@ xfs_refcount_relog_intent(
 }
 
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.name		= "refcount",
 	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_refcount_update_create_intent,
 	.abort_intent	= xfs_refcount_update_abort_intent,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 488c4a2a80a3bd..65b432eb5d025d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -576,6 +576,7 @@ xfs_rmap_relog_intent(
 }
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.name		= "rmap",
 	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
 	.create_intent	= xfs_rmap_update_create_intent,
 	.abort_intent	= xfs_rmap_update_abort_intent,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 516529c151ae1c..0efcdb79d10e51 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2549,7 +2549,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 	TP_ARGS(mp, dfp),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(int, type)
+		__string(name, dfp->dfp_ops->name)
 		__field(void *, intent)
 		__field(unsigned int, flags)
 		__field(char, committed)
@@ -2557,15 +2557,15 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__entry->type = dfp->dfp_type;
+		__assign_str(name, dfp->dfp_ops->name);
 		__entry->intent = dfp->dfp_intent;
 		__entry->flags = dfp->dfp_flags;
 		__entry->committed = dfp->dfp_done != NULL;
 		__entry->nr = dfp->dfp_count;
 	),
-	TP_printk("dev %d:%d optype %d intent %p flags %s committed %d nr %d",
+	TP_printk("dev %d:%d optype %s intent %p flags %s committed %d nr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __get_str(name),
 		  __entry->intent,
 		  __print_flags(__entry->flags, "|", XFS_DEFER_PENDING_STRINGS),
 		  __entry->committed,
@@ -2694,7 +2694,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	TP_ARGS(mp, dfp, item),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(int, type)
+		__string(name, dfp->dfp_ops->name)
 		__field(void *, intent)
 		__field(void *, item)
 		__field(char, committed)
@@ -2703,16 +2703,16 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__entry->type = dfp->dfp_type;
+		__assign_str(name, dfp->dfp_ops->name);
 		__entry->intent = dfp->dfp_intent;
 		__entry->item = item;
 		__entry->committed = dfp->dfp_done != NULL;
 		__entry->flags = dfp->dfp_flags;
 		__entry->nr = dfp->dfp_count;
 	),
-	TP_printk("dev %d:%d optype %d intent %p item %p flags %s committed %d nr %d",
+	TP_printk("dev %d:%d optype %s intent %p item %p flags %s committed %d nr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __get_str(name),
 		  __entry->intent,
 		  __entry->item,
 		  __print_flags(__entry->flags, "|", XFS_DEFER_PENDING_STRINGS),
-- 
2.39.2

