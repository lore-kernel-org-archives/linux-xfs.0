Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0152CC11F6B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4179613AF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhGNDW4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:22:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56874 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237559AbhGNDWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:22:55 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E76C3104537C
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 13:20:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRJ-006IK0-Bx
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRJ-00Ay9B-47
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: separate out log shutdown callback processing
Date:   Wed, 14 Jul 2021 13:19:56 +1000
Message-Id: <20210714031958.2614411-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714031958.2614411-1-david@fromorbit.com>
References: <20210714031958.2614411-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=eKOPN3Rt75fyAB7gLQ4A:9
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

Further, separating out the IO completion logic from the shutdown
logic avoids callback race conditions from being triggered by log IO
completion after a shutdown. IO completion will now only run
callbacks on iclogs that are in the correct state for a callback to
be run, avoiding the possibility of running callbacks on a
referenced iclog that hasn't yet been submitted for IO.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 53 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 302c1ce27974..4d72d9efed7c 100644
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
@@ -2762,7 +2788,10 @@ xlog_state_iodone_process_iclog(
 
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
@@ -2777,13 +2806,11 @@ xlog_state_do_iclog_callbacks(
 	do {
 		LIST_HEAD(cb_list);
 
-		if (!xlog_is_shutdown(log)) {
-			if (xlog_state_iodone_process_iclog(log, iclog))
-				break;
-			if (iclog->ic_state != XLOG_STATE_CALLBACK) {
-				iclog = iclog->ic_next;
-				continue;
-			}
+		if (xlog_state_iodone_process_iclog(log, iclog))
+			break;
+		if (iclog->ic_state != XLOG_STATE_CALLBACK) {
+			iclog = iclog->ic_next;
+			continue;
 		}
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
 		spin_unlock(&log->l_icloglock);
@@ -2794,10 +2821,7 @@ xlog_state_do_iclog_callbacks(
 		ran_callback = true;
 
 		spin_lock(&log->l_icloglock);
-		if (xlog_is_shutdown(log))
-			wake_up_all(&iclog->ic_force_wait);
-		else
-			xlog_state_clean_iclog(log, iclog);
+		xlog_state_clean_iclog(log, iclog);
 		iclog = iclog->ic_next;
 	} while (iclog != first_iclog);
 
@@ -2830,8 +2854,7 @@ xlog_state_do_callback(
 		}
 	}
 
-	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    xlog_is_shutdown(log))
+	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -3764,7 +3787,7 @@ xlog_force_shutdown(
 	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
-	xlog_state_do_callback(log);
+	xlog_state_shutdown_callbacks(log);
 
 	return log_error;
 }
-- 
2.31.1

