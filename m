Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6448628EA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422483; cv=none; b=aFbFJN5AgZVW/kNS5vK3OAvMfx6zfyLBYeJRW1zSvVoMvwH7F0RPyFVfI+C+Pba8rFeWFEFVerMNL++QT77dd3VPSEXP9TwTvOl3jo7MWCDfN69o9cpcIMPC9QvjsdD+u1DG2iJMaph6ThiUv8Vps3TGITi3aQ/GQfcdlHKL8dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422483; c=relaxed/simple;
	bh=1TAXR0S3ZlXzLwHrHEPW7XpvZHia1SjJ8IPXp/Nqq1s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCK8mmtJBnp3B7UOuNWTCdphZRjSDLl7NvDGtmj9f85qf8Eme+26i0CSpduyM8URcmFKs4USfwzye/KLmC8Fw+lIt4+wpUXRraxrbzgrlS/lY0yatK+IlzDPhdFUn2ecyK1Tu5Jc5tS8YxF/o4xiW2VFhc8G1MhHGT53xtb2Ptg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tOQkjvdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tOQkjvdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C750C433C7;
	Tue, 26 Mar 2024 03:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422483;
	bh=1TAXR0S3ZlXzLwHrHEPW7XpvZHia1SjJ8IPXp/Nqq1s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tOQkjvdkca8KgSHoGTBblhcKtkhZq38dmWX2jusdUrCu9kzeyc7iHXFfsSbUkAENa
	 8ICmhqL5NgygMgBrAgvbMwE2so5xlyfZEoObtU/u3sybSHFV2n8sMtMyAHJgvybt7T
	 Akj7Y5f3VKSyDdw4pI4uIHODrEoCQOL8Z9Mrtg0dB6NLOBszMD6ReOEcNfXCvjvp9n
	 hj0jM3EJGMfN4ueyBjQCVi+GHB34Vd7mrr4xM3jnWA5WpchBFO7KUNA/xdd4lUtEpy
	 94TTsIR0yIndo+FRPwYzZW952PrOscbMyBEwzY+VKbWGfueXPyNH/2oV/D2SDf/6+V
	 oNwr52RWmwWng==
Date: Mon, 25 Mar 2024 20:08:02 -0700
Subject: [PATCH 20/67] xfs: force small EFIs for reaping btree extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127251.2212320.17906549731886702696.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_defer.h |    3 +
 2 files changed, 99 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 58ad1881d49d..98f1cbe6a67f 100644
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
index b0284154f4e0..5b1990ef3e5d 100644
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

