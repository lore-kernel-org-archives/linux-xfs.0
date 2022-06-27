Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4D1CCA485
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiF0Anp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiF0Anp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:45 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2D6E26C7
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 27AC010E7601
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:40 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BU02-Jh
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000uag-IC
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: add log item precommit operation
Date:   Mon, 27 Jun 2022 10:43:35 +1000
Message-Id: <20220627004336.217366-9-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b8fd3c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=E9wXMvJij-PDQt6hmJUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For inodes that are dirty, we have an attached cluster buffer that
we want to use to track the dirty inode through the AIL.
Unfortunately, locking the cluster buffer and adding it to the
transaction when the inode is first logged in a transaction leads to
buffer lock ordering inversions.

The specific problem is ordering against the AGI buffer. When
modifying unlinked lists, the buffer lock order is AGI -> inode
cluster buffer as the AGI buffer lock serialises all access to the
unlinked lists. Unfortunately, functionality like xfs_droplink()
logs the inode before calling xfs_iunlink(), as do various directory
manipulation functions. The inode can be logged way down in the
stack as far as the bmapi routines and hence, without a major
rewrite of lots of APIs there's no way we can avoid the inode being
logged by something until after the AGI has been logged.

As we are going to be using ordered buffers for inode AIL tracking,
there isn't a need to actually lock that buffer against modification
as all the modifications are captured by logging the inode item
itself. Hence we don't actually need to join the cluster buffer into
the transaction until just before it is committed. This means we do
not perturb any of the existing buffer lock orders in transactions,
and the inode cluster buffer is always locked last in a transaction
that doesn't otherwise touch inode cluster buffers.

We do this by introducing a precommit log item method. A log item
method is used because it is likely dquots will be moved to this
same ordered buffer tracking scheme and hence will need a similar
callout. This commit just introduces the mechanism; the inode item
implementation is in followup commits.

The precommit items need to be sorted into consistent order as we
may be locking multiple items here. Hence if we have two dirty
inodes in cluster buffers A and B, and some other transaction has
two separate dirty inodes in the same cluster buffers, locking them
in different orders opens us up to ABBA deadlocks. Hence we sort the
items on the transaction based on the presence of a sort log item
method.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |  1 +
 fs/xfs/xfs_trans.c  | 91 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h  |  6 ++-
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9fc324a29535..374b3bafaeb0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -914,6 +914,7 @@ xfs_reclaim_inode(
 	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	ASSERT(!ip->i_itemp || ip->i_itemp->ili_item.li_buf == NULL);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 82cf0189c0db..0acb31093d9f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -844,6 +844,90 @@ xfs_trans_committed_bulk(
 	spin_unlock(&ailp->ail_lock);
 }
 
+/*
+ * Sort transaction items prior to running precommit operations. This will
+ * attempt to order the items such that they will always be locked in the same
+ * order. Items that have no sort function are moved to the end of the list
+ * and so are locked last (XXX: need to check the logic matches the comment).
+ *
+ * This may need refinement as different types of objects add sort functions.
+ *
+ * Function is more complex than it needs to be because we are comparing 64 bit
+ * values and the function only returns 32 bit values.
+ */
+static int
+xfs_trans_precommit_sort(
+	void			*unused_arg,
+	const struct list_head	*a,
+	const struct list_head	*b)
+{
+	struct xfs_log_item	*lia = container_of(a,
+					struct xfs_log_item, li_trans);
+	struct xfs_log_item	*lib = container_of(b,
+					struct xfs_log_item, li_trans);
+	int64_t			diff;
+
+	/*
+	 * If both items are non-sortable, leave them alone. If only one is
+	 * sortable, move the non-sortable item towards the end of the list.
+	 */
+	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
+		return 0;
+	if (!lia->li_ops->iop_sort)
+		return 1;
+	if (!lib->li_ops->iop_sort)
+		return -1;
+
+	diff = lia->li_ops->iop_sort(lia) - lib->li_ops->iop_sort(lib);
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Run transaction precommit functions.
+ *
+ * If there is an error in any of the callouts, then stop immediately and
+ * trigger a shutdown to abort the transaction. There is no recovery possible
+ * from errors at this point as the transaction is dirty....
+ */
+static int
+xfs_trans_run_precommits(
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_log_item	*lip, *n;
+	int			error = 0;
+
+	/*
+	 * Sort the item list to avoid ABBA deadlocks with other transactions
+	 * running precommit operations that lock multiple shared items such as
+	 * inode cluster buffers.
+	 */
+	list_sort(NULL, &tp->t_items, xfs_trans_precommit_sort);
+
+	/*
+	 * Precommit operations can remove the log item from the transaction
+	 * if the log item exists purely to delay modifications until they
+	 * can be ordered against other operations. Hence we have to use
+	 * list_for_each_entry_safe() here.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
+			continue;
+		if (lip->li_ops->iop_precommit) {
+			error = lip->li_ops->iop_precommit(tp, lip);
+			if (error)
+				break;
+		}
+	}
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return error;
+}
+
 /*
  * Commit the given transaction to the log.
  *
@@ -869,6 +953,13 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
+	error = xfs_trans_run_precommits(tp);
+	if (error) {
+		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+			xfs_defer_cancel(tp);
+		goto out_unreserve;
+	}
+
 	/*
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9561f193e7e1..64062e3b788b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -71,10 +71,12 @@ struct xfs_item_ops {
 	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
-	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	uint64_t (*iop_sort)(struct xfs_log_item *lip);
+	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
 	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
-	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
+	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	void (*iop_release)(struct xfs_log_item *);
 	int (*iop_recover)(struct xfs_log_item *lip,
 			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
-- 
2.36.1

