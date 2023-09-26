Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6908E7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjI0APG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjI0ANF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91FD30CD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:32:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71056C433C7;
        Tue, 26 Sep 2023 23:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771177;
        bh=9YIpxyf44PWFDrzquU0FHnz1QFvCaiUtxKhiGoeudH8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pqaO+ts3BkzGbrsF56ZFGcY3GRjhSoEMuiMyNpN+hONKlC4JpKtfpRruH85SF70T6
         p5iFU0xqTTh0hao18XzpiNXTX++QB3M11jFGsVn3tzfcnx+Zxw/Ks6zRwA40fqgUSs
         QRRffJzgyjJtdXHeH/pBlJ8kbno9Up5CHpqKMOUrUG2oc+6ncEb/9E3ZWn/XM840Ni
         J+ZC7L79+rdyIhjvBnN+fgiq2uy35cnD2G1d/sfHwz5X8Y+tcT0DFNzipW2HTncE9C
         G0BYlO/Bt57bFSCzzARKZfYtN+NJZJoalll5ej0cgUb0Z/2FmrtOq4OiooDxF4evyF
         Kq+lvCMxx1VfA==
Date:   Tue, 26 Sep 2023 16:32:56 -0700
Subject: [PATCH 7/7] xfs: force small EFIs for reaping btree extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059253.3312911.14232325060465598331.stgit@frogsfrogsfrogs>
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

Introduce the concept of a defer ops barrier to separate consecutively
queued pending work items of the same type.  With a barrier in place,
the two work items will be tracked separately, and receive separate log
intent items.  The goal here is to prevent reaping of old metadata
blocks from creating unnecessarily huge EFIs that could then run the
risk of overflowing the scrub transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   83 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_defer.h |    3 ++
 fs/xfs/scrub/reap.c       |    5 +++
 3 files changed, 91 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6ed1ab8a7e522..072e6458ba30b 100644
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
@@ -1028,3 +1081,33 @@ xfs_defer_item_unpause(
 
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
index 7fb4f60e5e4c5..c8889ea5ab8bf 100644
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
 

