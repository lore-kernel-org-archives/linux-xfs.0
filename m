Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F74C19F33
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD2661185
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbhG0HKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 03:10:24 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51095 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235727AbhG0HKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:23 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EC5D0864984
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3x-UD
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5b1-MT
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/11] xfs: avoid unnecessary waits in xfs_log_force_lsn()
Date:   Tue, 27 Jul 2021 17:10:08 +1000
Message-Id: <20210727071012.3358033-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=wpwPaxZDQMKr-q5_gskA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Before waiting on a iclog in xfs_log_force_lsn(), we don't check to
see if the iclog has already been completed and the contents on
stable storage. We check for completed iclogs in xfs_log_force(), so
we should do the same thing for xfs_log_force_lsn().

This fixed some random up-to-30s pauses seen in unmounting
filesystems in some tests. A log force ends up waiting on completed
iclog, and that doesn't then get flushed (and hence the log force
get completed) until the background log worker issues a log force
that flushes the iclog in question. Then the unmount unblocks and
continues.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 160b8bb7ee60..1c328efdca66 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3143,6 +3143,35 @@ xlog_state_switch_iclogs(
 	log->l_iclog = iclog->ic_next;
 }
 
+/*
+ * Force the iclog to disk and check if the iclog has been completed before
+ * xlog_force_iclog() returns. This can happen on synchronous (e.g.
+ * pmem) or fast async storage because we drop the icloglock to issue the IO.
+ * If completion has already occurred, tell the caller so that it can avoid an
+ * unnecessary wait on the iclog.
+ */
+static int
+xlog_force_and_check_iclog(
+	struct xlog_in_core	*iclog,
+	bool			*completed)
+{
+	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	int			error;
+
+	*completed = false;
+	error = xlog_force_iclog(iclog);
+	if (error)
+		return error;
+
+	/*
+	 * If the iclog has already been completed and reused the header LSN
+	 * will have been rewritten by completion
+	 */
+	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
+		*completed = true;
+	return 0;
+}
+
 /*
  * Write out all data in the in-core log as of this exact moment in time.
  *
@@ -3177,7 +3206,6 @@ xfs_log_force(
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
-	xfs_lsn_t		lsn;
 
 	XFS_STATS_INC(mp, xs_log_force);
 	trace_xfs_log_force(mp, 0, _RET_IP_);
@@ -3206,11 +3234,12 @@ xfs_log_force(
 	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		if (atomic_read(&iclog->ic_refcnt) == 0) {
 			/* We have exclusive access to this iclog. */
-			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-			if (xlog_force_iclog(iclog))
+			bool	completed;
+
+			if (xlog_force_and_check_iclog(iclog, &completed))
 				goto out_error;
 
-			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
+			if (completed)
 				goto out_unlock;
 		} else {
 			/*
@@ -3250,6 +3279,7 @@ xlog_force_lsn(
 	bool			already_slept)
 {
 	struct xlog_in_core	*iclog;
+	bool			completed;
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
@@ -3287,10 +3317,12 @@ xlog_force_lsn(
 					&log->l_icloglock);
 			return -EAGAIN;
 		}
-		if (xlog_force_iclog(iclog))
+		if (xlog_force_and_check_iclog(iclog, &completed))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
+		if (completed)
+			goto out_unlock;
 		break;
 	case XLOG_STATE_WANT_SYNC:
 		/*
-- 
2.31.1

