Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7C3C41621
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4973F2074D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgCYBmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:14 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46858 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbgCYBmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:14 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D9BF67EB97E
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006HK-Q8
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-00036C-Hd
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: factor common AIL item deletion code
Date:   Wed, 25 Mar 2020 12:42:03 +1100
Message-Id: <20200325014205.11843-7-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=gUbHUyCUizMO0ogC8dcA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Factor the common AIL deletion code that does all the wakeups into a
helper so we only have one copy of this somewhat tricky code to
interface with all the wakeups necessary when the LSN of the log
tail changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c | 12 +----------
 fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h |  4 +++-
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4a3d13d4a0228..bd8c368098707 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -742,17 +742,7 @@ xfs_iflush_done(
 				xfs_clear_li_failed(blip);
 			}
 		}
-
-		if (mlip_changed) {
-			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-				xlog_assign_tail_lsn_locked(ailp->ail_mount);
-			if (list_empty(&ailp->ail_head))
-				wake_up_all(&ailp->ail_empty);
-		}
-		spin_unlock(&ailp->ail_lock);
-
-		if (mlip_changed)
-			xfs_log_space_wake(ailp->ail_mount);
+		xfs_ail_update_finish(ailp, mlip_changed);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2ef0dfbfb303d..26d2e7928121c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -681,6 +681,27 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+void
+xfs_ail_update_finish(
+	struct xfs_ail		*ailp,
+	bool			do_tail_update) __releases(ailp->ail_lock)
+{
+	struct xfs_mount	*mp = ailp->ail_mount;
+
+	if (!do_tail_update) {
+		spin_unlock(&ailp->ail_lock);
+		return;
+	}
+
+	if (!XFS_FORCED_SHUTDOWN(mp))
+		xlog_assign_tail_lsn_locked(mp);
+
+	if (list_empty(&ailp->ail_head))
+		wake_up_all(&ailp->ail_empty);
+	spin_unlock(&ailp->ail_lock);
+	xfs_log_space_wake(mp);
+}
+
 /*
  * xfs_trans_ail_update - bulk AIL insertion operation.
  *
@@ -740,15 +761,7 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-			xlog_assign_tail_lsn_locked(ailp->ail_mount);
-		spin_unlock(&ailp->ail_lock);
-
-		xfs_log_space_wake(ailp->ail_mount);
-	} else {
-		spin_unlock(&ailp->ail_lock);
-	}
+	xfs_ail_update_finish(ailp, mlip_changed);
 }
 
 bool
@@ -792,10 +805,10 @@ void
 xfs_trans_ail_delete(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
-	int			shutdown_type) __releases(ailp->ail_lock)
+	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			mlip_changed;
+	bool			need_update;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -808,17 +821,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	mlip_changed = xfs_ail_delete_one(ailp, lip);
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(mp))
-			xlog_assign_tail_lsn_locked(mp);
-		if (list_empty(&ailp->ail_head))
-			wake_up_all(&ailp->ail_empty);
-	}
-
-	spin_unlock(&ailp->ail_lock);
-	if (mlip_changed)
-		xfs_log_space_wake(ailp->ail_mount);
+	need_update = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, need_update);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2e073c1c4614f..64ffa746730e4 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -92,8 +92,10 @@ xfs_trans_ail_update(
 }
 
 bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
-		int shutdown_type) __releases(ailp->ail_lock);
+		int shutdown_type);
 
 static inline void
 xfs_trans_ail_remove(
-- 
2.26.0.rc2

