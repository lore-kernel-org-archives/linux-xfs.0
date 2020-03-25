Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7795C54FCE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EBE72072E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCYBmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:11 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55368 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbgCYBmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:11 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CE7683A3B39
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006HN-RN
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-00036H-J6
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: tail updates only need to occur when LSN changes
Date:   Wed, 25 Mar 2020 12:42:04 +1100
Message-Id: <20200325014205.11843-8-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=W3SVq3cs_kfo-QxLsoMA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently wake anything waiting on the log tail to move whenever
the log item at the tail of the log is removed. Historically this
was fine behaviour because there were very few items at any given
LSN. But with delayed logging, there may be thousands of items at
any given LSN, and we can't move the tail until they are all gone.

Hence if we are removing them in near tail-first order, we might be
waking up processes waiting on the tail LSN to change (e.g. log
space waiters) repeatedly without them being able to make progress.
This also occurs with the new sync push waiters, and can result in
thousands of spurious wakeups every second when under heavy direct
reclaim pressure.

To fix this, check that the tail LSN has actually changed on the
AIL before triggering wakeups. This will reduce the number of
spurious wakeups when doing bulk AIL removal and make this code much
more efficient.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 18 ++++++++++----
 fs/xfs/xfs_trans_ail.c  | 52 ++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_trans_priv.h |  4 ++--
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bd8c368098707..a627cb951dc61 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -730,19 +730,27 @@ xfs_iflush_done(
 	 * holding the lock before removing the inode from the AIL.
 	 */
 	if (need_ail) {
-		bool			mlip_changed = false;
+		xfs_lsn_t	tail_lsn = 0;
 
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(blip, &tmp, li_bio_list) {
 			if (INODE_ITEM(blip)->ili_logged &&
-			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
-				mlip_changed |= xfs_ail_delete_one(ailp, blip);
-			else {
+			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
+				/*
+				 * xfs_ail_update_finish() only cares about the
+				 * lsn of the first tail item removed, any
+				 * others will be at the same or higher lsn so
+				 * we just ignore them.
+				 */
+				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
+				if (!tail_lsn && lsn)
+					tail_lsn = lsn;
+			} else {
 				xfs_clear_li_failed(blip);
 			}
 		}
-		xfs_ail_update_finish(ailp, mlip_changed);
+		xfs_ail_update_finish(ailp, tail_lsn);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 26d2e7928121c..564253550b754 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -109,17 +109,25 @@ xfs_ail_next(
  * We need the AIL lock in order to get a coherent read of the lsn of the last
  * item in the AIL.
  */
+static xfs_lsn_t
+__xfs_ail_min_lsn(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_log_item	*lip = xfs_ail_min(ailp);
+
+	if (lip)
+		return lip->li_lsn;
+	return 0;
+}
+
 xfs_lsn_t
 xfs_ail_min_lsn(
 	struct xfs_ail		*ailp)
 {
-	xfs_lsn_t		lsn = 0;
-	struct xfs_log_item	*lip;
+	xfs_lsn_t		lsn;
 
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_ail_min(ailp);
-	if (lip)
-		lsn = lip->li_lsn;
+	lsn = __xfs_ail_min_lsn(ailp);
 	spin_unlock(&ailp->ail_lock);
 
 	return lsn;
@@ -684,11 +692,12 @@ xfs_ail_push_all_sync(
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
-	bool			do_tail_update) __releases(ailp->ail_lock)
+	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
 
-	if (!do_tail_update) {
+	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
+	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
 		spin_unlock(&ailp->ail_lock);
 		return;
 	}
@@ -733,7 +742,7 @@ xfs_trans_ail_update_bulk(
 	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
 {
 	struct xfs_log_item	*mlip;
-	int			mlip_changed = 0;
+	xfs_lsn_t		tail_lsn = 0;
 	int			i;
 	LIST_HEAD(tmp);
 
@@ -748,9 +757,10 @@ xfs_trans_ail_update_bulk(
 				continue;
 
 			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
+			if (mlip == lip && !tail_lsn)
+				tail_lsn = lip->li_lsn;
+
 			xfs_ail_delete(ailp, lip);
-			if (mlip == lip)
-				mlip_changed = 1;
 		} else {
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
@@ -761,15 +771,23 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	xfs_ail_update_finish(ailp, mlip_changed);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
-bool
+/*
+ * Delete one log item from the AIL.
+ *
+ * If this item was at the tail of the AIL, return the LSN of the log item so
+ * that we can use it to check if the LSN of the tail of the log has moved
+ * when finishing up the AIL delete process in xfs_ail_update_finish().
+ */
+xfs_lsn_t
 xfs_ail_delete_one(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
 {
 	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
+	xfs_lsn_t		lsn = lip->li_lsn;
 
 	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
 	xfs_ail_delete(ailp, lip);
@@ -777,7 +795,9 @@ xfs_ail_delete_one(
 	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
 	lip->li_lsn = 0;
 
-	return mlip == lip;
+	if (mlip == lip)
+		return lsn;
+	return 0;
 }
 
 /**
@@ -808,7 +828,7 @@ xfs_trans_ail_delete(
 	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			need_update;
+	xfs_lsn_t		tail_lsn;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -821,8 +841,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	need_update = xfs_ail_delete_one(ailp, lip);
-	xfs_ail_update_finish(ailp, need_update);
+	tail_lsn = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, tail_lsn);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 64ffa746730e4..35655eac01a65 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -91,8 +91,8 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
-bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
-void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
 		int shutdown_type);
-- 
2.26.0.rc2

