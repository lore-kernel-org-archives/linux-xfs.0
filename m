Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5584AC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33FF860F0F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhGZF0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 01:26:54 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45854 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231559AbhGZF0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 01:26:52 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1456010A44D
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 16:07:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00AtQA-Nk
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00DpCN-GA
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: factor out forced iclog flushes
Date:   Mon, 26 Jul 2021 16:07:11 +1000
Message-Id: <20210726060716.3295008-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726060716.3295008-1-david@fromorbit.com>
References: <20210726060716.3295008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=2543SYbkfoBWPhur4msA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We force iclogs in several places - we need them all to have the
same cache flush semantics, so start by factoring out the iclog
force into a common helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1f8c00e40c53..7107cf542eda 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -781,6 +781,20 @@ xfs_log_mount_cancel(
 	xfs_log_unmount(mp);
 }
 
+/*
+ * Flush out the iclog to disk ensuring that device caches are flushed and
+ * the iclog hits stable storage before any completion waiters are woken.
+ */
+static inline int
+xlog_force_iclog(
+	struct xlog_in_core	*iclog)
+{
+	atomic_inc(&iclog->ic_refcnt);
+	if (iclog->ic_state == XLOG_STATE_ACTIVE)
+		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
+	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
+}
+
 /*
  * Wait for the iclog and all prior iclogs to be written disk as required by the
  * log force state machine. Waiting on ic_force_wait ensures iclog completions
@@ -866,18 +880,8 @@ xlog_unmount_write(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	atomic_inc(&iclog->ic_refcnt);
-	if (iclog->ic_state == XLOG_STATE_ACTIVE)
-		xlog_state_switch_iclogs(log, iclog, 0);
-	else
-		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		       iclog->ic_state == XLOG_STATE_IOERROR);
-	/*
-	 * Ensure the journal is fully flushed and on stable storage once the
-	 * iclog containing the unmount record is written.
-	 */
 	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
-	error = xlog_state_release_iclog(log, iclog, 0);
+	error = xlog_force_iclog(iclog);
 	xlog_wait_on_iclog(iclog);
 
 	if (tic) {
@@ -3204,17 +3208,9 @@ xfs_log_force(
 		iclog = iclog->ic_prev;
 	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		if (atomic_read(&iclog->ic_refcnt) == 0) {
-			/*
-			 * We are the only one with access to this iclog.
-			 *
-			 * Flush it out now.  There should be a roundoff of zero
-			 * to show that someone has already taken care of the
-			 * roundoff from the previous sync.
-			 */
-			atomic_inc(&iclog->ic_refcnt);
+			/* We have exclusive access to this iclog. */
 			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-			xlog_state_switch_iclogs(log, iclog, 0);
-			if (xlog_state_release_iclog(log, iclog, 0))
+			if (xlog_force_iclog(iclog))
 				goto out_error;
 
 			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
@@ -3292,9 +3288,7 @@ xlog_force_lsn(
 					&log->l_icloglock);
 			return -EAGAIN;
 		}
-		atomic_inc(&iclog->ic_refcnt);
-		xlog_state_switch_iclogs(log, iclog, 0);
-		if (xlog_state_release_iclog(log, iclog, 0))
+		if (xlog_force_iclog(iclog))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
-- 
2.31.1

