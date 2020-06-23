Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1CEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4E8206C0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732163AbgFWJuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 05:50:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47833 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732168AbgFWJuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 05:50:24 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C05913A4EB6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 19:50:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnfZH-0004gl-Uu
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 19:50:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnfZH-0087BA-MN
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 19:50:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: add log item precommit operation
Date:   Tue, 23 Jun 2020 19:50:13 +1000
Message-Id: <20200623095015.1934171-3-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200623095015.1934171-1-david@fromorbit.com>
References: <20200623095015.1934171-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=E9wXMvJij-PDQt6hmJUA:9
Sender: linux-xfs-owner@vger.kernel.org
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
 fs/xfs/xfs_trans.c  | 90 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h  |  6 ++-
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0d73559f2d58..1c744dbb313f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1077,6 +1077,7 @@ xfs_reclaim_inode(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	ASSERT(!ip->i_itemp || ip->i_itemp->ili_item.li_buf == NULL);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..6f350490f84b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -799,6 +799,89 @@ xfs_trans_committed_bulk(
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
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xfs_log_item	*lia = container_of(a,
+					struct xfs_log_item, li_trans);
+	struct xfs_log_item	*lib = container_of(b,
+					struct xfs_log_item, li_trans);
+	int64_t			diff;
+
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
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
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
@@ -823,6 +906,13 @@ __xfs_trans_commit(
 
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
index b752501818d2..26ea19bd0621 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -70,10 +70,12 @@ struct xfs_item_ops {
 	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
-	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	uint64_t (*iop_sort)(struct xfs_log_item *);
+	int (*iop_precommit)(struct xfs_trans *, struct xfs_log_item *);
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
-	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
+	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	void (*iop_release)(struct xfs_log_item *);
 	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
-- 
2.26.2.761.g0e0b3e54be

