Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC476C11F66
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD9AF60720
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhGNDXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:23:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41252 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237718AbhGNDXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:23:08 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E7F9D86481A
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 13:20:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRJ-006IJx-Am
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRJ-00Ay98-2p
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: rework xlog_state_do_callback()
Date:   Wed, 14 Jul 2021 13:19:55 +1000
Message-Id: <20210714031958.2614411-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714031958.2614411-1-david@fromorbit.com>
References: <20210714031958.2614411-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=p1iSVuLfdZg6vMKyjxMA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Clean it up a bit by factoring and rearranging some of the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 96 ++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f996f51c6cee..302c1ce27974 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2760,56 +2760,66 @@ xlog_state_iodone_process_iclog(
 	}
 }
 
+/*
+ * Loop over all the iclogs, running attached callbacks on them. Return true if
+ * we ran any callbacks, indicating that we dropped the icloglock.
+ */
+static bool
+xlog_state_do_iclog_callbacks(
+	struct xlog		*log)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
+{
+	struct xlog_in_core	*first_iclog = log->l_iclog;
+	struct xlog_in_core	*iclog = first_iclog;
+	bool			ran_callback = false;
+
+	do {
+		LIST_HEAD(cb_list);
+
+		if (!xlog_is_shutdown(log)) {
+			if (xlog_state_iodone_process_iclog(log, iclog))
+				break;
+			if (iclog->ic_state != XLOG_STATE_CALLBACK) {
+				iclog = iclog->ic_next;
+				continue;
+			}
+		}
+		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		spin_unlock(&log->l_icloglock);
+
+		trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
+		xlog_cil_process_committed(&cb_list);
+		trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
+		ran_callback = true;
+
+		spin_lock(&log->l_icloglock);
+		if (xlog_is_shutdown(log))
+			wake_up_all(&iclog->ic_force_wait);
+		else
+			xlog_state_clean_iclog(log, iclog);
+		iclog = iclog->ic_next;
+	} while (iclog != first_iclog);
+
+	return ran_callback;
+}
+
+
+/*
+ * Loop running iclog completion callbacks until there are no more iclogs in a
+ * state that can run callbacks.
+ */
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log)
 {
-	struct xlog_in_core	*iclog;
-	struct xlog_in_core	*first_iclog;
-	bool			cycled_icloglock;
 	int			flushcnt = 0;
 	int			repeats = 0;
 
 	spin_lock(&log->l_icloglock);
-	do {
-		/*
-		 * Scan all iclogs starting with the one pointed to by the
-		 * log.  Reset this starting point each time the log is
-		 * unlocked (during callbacks).
-		 *
-		 * Keep looping through iclogs until one full pass is made
-		 * without running any callbacks.
-		 */
-		cycled_icloglock = false;
-		first_iclog = log->l_iclog;
-		iclog = first_iclog;
-
-		do {
-			LIST_HEAD(cb_list);
-
-			if (!xlog_is_shutdown(log)) {
-				if (xlog_state_iodone_process_iclog(log, iclog))
-					break;
-				if (iclog->ic_state != XLOG_STATE_CALLBACK) {
-					iclog = iclog->ic_next;
-					continue;
-				}
-			}
-			list_splice_init(&iclog->ic_callbacks, &cb_list);
-			spin_unlock(&log->l_icloglock);
-
-			trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
-			xlog_cil_process_committed(&cb_list);
-			trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
-			cycled_icloglock = true;
-
-			spin_lock(&log->l_icloglock);
-			if (xlog_is_shutdown(log))
-				wake_up_all(&iclog->ic_force_wait);
-			else
-				xlog_state_clean_iclog(log, iclog);
-			iclog = iclog->ic_next;
-		} while (iclog != first_iclog);
+	while (xlog_state_do_iclog_callbacks(log)) {
+		if (xlog_is_shutdown(log))
+			break;
 
 		if (++repeats > 5000) {
 			flushcnt += repeats;
@@ -2818,7 +2828,7 @@ xlog_state_do_callback(
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!xlog_is_shutdown(log) && cycled_icloglock);
+	}
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
 	    xlog_is_shutdown(log))
-- 
2.31.1

