Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601423BB2A
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGrsOvY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463FC433C8;
	Fri, 24 Nov 2023 23:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869724;
	bh=bOl95GungcrajEnWiARtB0ld5PmV27e3ntZ9LReOoTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bGrsOvY0efVs5mrp+cJWoKxV7UGR9chKi1RgwH5evWee93c+W+zoQ3pT9HlsSm3no
	 lo4eEuRiTulQelK+7Kc3f5zyiv6MzWwbNwaU/+jMHhycIsrjpz79V0godQhEo6TqQ5
	 0TUkWeTzB5OxFCdC+E0Y7BEZdv8uNLEk9REMDO4p8vhCFKUvqKY6tWVyRdjELmygd3
	 mprml6CnFm2YBqnqf81clmOblCZTL5VZy5SgbvQnKuP+5Pu6ik0BDAoeNwKb5f12M+
	 Hc1HFf9ebnQr0zqV4Dl6k/nHyTGsGaE4LBtyC8POOANI/uA/zVE2tGm8V7TFWE3ezm
	 eYC36VMHc5cKw==
Date: Fri, 24 Nov 2023 15:48:43 -0800
Subject: [PATCH 7/7] xfs: force small EFIs for reaping btree extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926238.2768790.8811874509215907711.stgit@frogsfrogsfrogs>
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

Introduce the concept of a defer ops barrier to separate consecutively
queued pending work items of the same type.  With a barrier in place,
the two work items will be tracked separately, and receive separate log
intent items.  The goal here is to prevent reaping of old metadata
blocks from creating unnecessarily huge EFIs that could then run the
risk of overflowing the scrub transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |   83 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_defer.h |    3 ++
 fs/xfs/scrub/reap.c       |    5 +++
 3 files changed, 91 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6604eb50058ba..6b0d4c2e844b0 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -181,6 +181,58 @@ static struct kmem_cache	*xfs_defer_pending_cache;
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
@@ -189,6 +241,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
+	[XFS_DEFER_OPS_TYPE_BARRIER]	= &xfs_barrier_defer_type,
 };
 
 /*
@@ -1036,3 +1089,33 @@ xfs_defer_item_unpause(
 
 	trace_xfs_defer_item_unpause(tp->t_mountp, dfp);
 }
+
+/*
+ * Add a defer ops barrier to force two otherwise adjacent deferred work items
+ * to be tracked separately and have separate log items.
+ */
+void
+xfs_defer_add_barrier(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/* If the last defer op added was a barrier, we're done. */
+	if (!list_empty(&tp->t_dfops)) {
+		dfp = list_last_entry(&tp->t_dfops,
+				struct xfs_defer_pending, dfp_list);
+		if (dfp->dfp_type == XFS_DEFER_OPS_TYPE_BARRIER)
+			return;
+	}
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = XFS_DEFER_OPS_TYPE_BARRIER;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+
+	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
+	dfp->dfp_count++;
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 094ff9062b251..0112678a8856b 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -20,6 +20,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_ATTR,
+	XFS_DEFER_OPS_TYPE_BARRIER,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -141,4 +142,6 @@ void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
+void xfs_defer_add_barrier(struct xfs_trans *tp);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 78c9f2085db46..ee26fcb500b78 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -31,6 +31,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
+#include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -409,6 +410,8 @@ xreap_agextent_iter(
 	/*
 	 * Use deferred frees to get rid of the old btree blocks to try to
 	 * minimize the window in which we could crash and lose the old blocks.
+	 * Add a defer ops barrier every other extent to avoid stressing the
+	 * system with large EFIs.
 	 */
 	error = xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
 			rs->resv, true);
@@ -416,6 +419,8 @@ xreap_agextent_iter(
 		return error;
 
 	rs->deferred++;
+	if (rs->deferred % 2 == 0)
+		xfs_defer_add_barrier(sc->tp);
 	return 0;
 }
 

