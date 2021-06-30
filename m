Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9002C11F6D
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C324861D19
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhF3Gks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:40:48 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36992 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232513AbhF3Gkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:40:47 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AE37880BC23
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 16:38:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrU-0012kR-3k
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-007LlM-ST
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: reowrk up xlog_state_do_callback
Date:   Wed, 30 Jun 2021 16:38:10 +1000
Message-Id: <20210630063813.1751007-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630063813.1751007-1-david@fromorbit.com>
References: <20210630063813.1751007-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=82o3TGu9-macBWZsXEwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Clean it up a bit by factoring and rearranging some of the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 99 ++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6c7cfc052135..bb44dcfcae89 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2758,67 +2758,74 @@ xlog_state_iodone_process_iclog(
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
+	struct xlog_in_core	*iclog = log->l_iclog;
+	struct xlog_in_core	*first_iclog = NULL;
+	bool			ran_callback = false;
+
+	for (; iclog != first_iclog; iclog = iclog->ic_next) {
+		LIST_HEAD(cb_list);
+
+		if (!first_iclog)
+			first_iclog = iclog;
+
+		if (!xlog_is_shutdown(log)) {
+			if (xlog_state_iodone_process_iclog(log, iclog))
+				break;
+			if (iclog->ic_state != XLOG_STATE_CALLBACK)
+				continue;
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
+	};
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
-		repeats++;
+	while (xlog_state_do_iclog_callbacks(log)) {
+		if (xlog_is_shutdown(log))
+			break;
 
-		/*
-		 * Scan all iclogs starting with the one pointed to by the
-		 * log.  Reset this starting point each time the log is
-		 * unlocked (during callbacks).
-		 *
-		 * Keep looping through iclogs until one full pass is made
-		 * without running any callbacks.
-		 */
-		cycled_icloglock = false;
-		first_iclog = NULL;
-		for (iclog = log->l_iclog;
-		     iclog != first_iclog;
-		     iclog = iclog->ic_next) {
-			LIST_HEAD(cb_list);
-
-			if (!first_iclog)
-				first_iclog = iclog;
-
-			if (!xlog_is_shutdown(log)) {
-				if (xlog_state_iodone_process_iclog(log, iclog))
-					break;
-				if (iclog->ic_state != XLOG_STATE_CALLBACK)
-					continue;
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
-		};
-
-		if (repeats > 5000) {
+		if (repeats++ > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
 			xfs_warn(log->l_mp,
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!xlog_is_shutdown(log) && cycled_icloglock);
+	};
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
 	    xlog_is_shutdown(log))
-- 
2.31.1

