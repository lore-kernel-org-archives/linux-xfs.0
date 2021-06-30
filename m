Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B07EC11F6E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B8861D0D
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhF3Gks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:40:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48286 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232518AbhF3Gkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:40:47 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BBFD71044EC3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 16:38:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrU-0012kU-4e
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-007LlP-TN
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: separate out log shutdown callback processing
Date:   Wed, 30 Jun 2021 16:38:11 +1000
Message-Id: <20210630063813.1751007-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630063813.1751007-1-david@fromorbit.com>
References: <20210630063813.1751007-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=ysDKc0d8BF8DvfF-6jkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The iclog callback processing done during a forced log shutdown has
different logic to normal runtime IO completion callback processing.
Separate out eh shutdown callbacks into their own function and call
that from the shutdown code instead.

We don't need this shutdown specific logic in the normal runtime
completion code - we'll always run the shutdown version on shutdown,
and it will do what shutdown needs regardless of whether there are
racing IO completion callbacks scheduled or in progress. Hence we
can also simplify the normal IO completion callpath and only abort
if shutdown occurred while we actively were processing callbacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 51 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bb44dcfcae89..e9e16eeb99e3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,6 +487,32 @@ xfs_log_reserve(
 	return error;
 }
 
+/*
+ * Run all the pending iclog callbacks and wake log force waiters and iclog
+ * space waiters so they can process the newly set shutdown state. We really
+ * don't care what order we process callbacks here because the log is shut down
+ * and so state cannot change on disk anymore.
+ */
+static void
+xlog_state_shutdown_callbacks(
+	struct xlog		*log)
+{
+	struct xlog_in_core	*iclog;
+	LIST_HEAD(cb_list);
+
+	spin_lock(&log->l_icloglock);
+	iclog = log->l_iclog;
+	do {
+		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		wake_up_all(&iclog->ic_force_wait);
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+
+	wake_up_all(&log->l_flush_wait);
+	spin_unlock(&log->l_icloglock);
+
+	xlog_cil_process_committed(&cb_list);
+}
+
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -2760,7 +2786,10 @@ xlog_state_iodone_process_iclog(
 
 /*
  * Loop over all the iclogs, running attached callbacks on them. Return true if
- * we ran any callbacks, indicating that we dropped the icloglock.
+ * we ran any callbacks, indicating that we dropped the icloglock. We don't need
+ * to handle transient shutdown state here at all because
+ * xlog_state_shutdown_callbacks() will be run to do the necessary shutdown
+ * cleanup of the callbacks.
  */
 static bool
 xlog_state_do_iclog_callbacks(
@@ -2778,12 +2807,10 @@ xlog_state_do_iclog_callbacks(
 		if (!first_iclog)
 			first_iclog = iclog;
 
-		if (!xlog_is_shutdown(log)) {
-			if (xlog_state_iodone_process_iclog(log, iclog))
-				break;
-			if (iclog->ic_state != XLOG_STATE_CALLBACK)
-				continue;
-		}
+		if (xlog_state_iodone_process_iclog(log, iclog))
+			break;
+		if (iclog->ic_state != XLOG_STATE_CALLBACK)
+			continue;
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
 		spin_unlock(&log->l_icloglock);
 
@@ -2793,10 +2820,7 @@ xlog_state_do_iclog_callbacks(
 		ran_callback = true;
 
 		spin_lock(&log->l_icloglock);
-		if (xlog_is_shutdown(log))
-			wake_up_all(&iclog->ic_force_wait);
-		else
-			xlog_state_clean_iclog(log, iclog);
+		xlog_state_clean_iclog(log, iclog);
 	};
 	return ran_callback;
 }
@@ -2827,8 +2851,7 @@ xlog_state_do_callback(
 		}
 	};
 
-	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    xlog_is_shutdown(log))
+	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -3761,7 +3784,7 @@ xlog_force_shutdown(
 	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
-	xlog_state_do_callback(log);
+	xlog_state_shutdown_callbacks(log);
 
 	return log_error;
 }
-- 
2.31.1

