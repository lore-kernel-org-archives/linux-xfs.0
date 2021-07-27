Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B42EC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AAD61163
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhG0HKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 03:10:23 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:54301 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234803AbhG0HKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:21 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id ED9F180B9DE
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3j-P8
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5ap-HF
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/11] xfs: fold __xlog_state_release_iclog into xlog_state_release_iclog
Date:   Tue, 27 Jul 2021 17:10:04 +1000
Message-Id: <20210727071012.3358033-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=m2tONhP6haBYosPBVmYA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Fold __xlog_state_release_iclog into its only caller to prepare
make an upcoming fix easier.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a3c4d48195d9..82f5996d3889 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,29 +487,6 @@ xfs_log_reserve(
 	return error;
 }
 
-static bool
-__xlog_state_release_iclog(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-{
-	lockdep_assert_held(&log->l_icloglock);
-
-	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
-		/* update tail before writing to iclog */
-		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-
-		iclog->ic_state = XLOG_STATE_SYNCING;
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
-		xlog_verify_tail_lsn(log, iclog, tail_lsn);
-		/* cycle incremented when incrementing curr_block */
-		trace_xlog_iclog_syncing(iclog, _RET_IP_);
-		return true;
-	}
-
-	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
-	return false;
-}
-
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
  * it is in the WANT_SYNC state.
@@ -519,19 +496,31 @@ xlog_state_release_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
+	xfs_lsn_t		tail_lsn;
 	lockdep_assert_held(&log->l_icloglock);
 
 	trace_xlog_iclog_release(iclog, _RET_IP_);
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
 		return -EIO;
 
-	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
-	    __xlog_state_release_iclog(log, iclog)) {
-		spin_unlock(&log->l_icloglock);
-		xlog_sync(log, iclog);
-		spin_lock(&log->l_icloglock);
+	if (!atomic_dec_and_test(&iclog->ic_refcnt))
+		return 0;
+
+	if (iclog->ic_state != XLOG_STATE_WANT_SYNC) {
+		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+		return 0;
 	}
 
+	/* update tail before writing to iclog */
+	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+	iclog->ic_state = XLOG_STATE_SYNCING;
+	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+	xlog_verify_tail_lsn(log, iclog, tail_lsn);
+	trace_xlog_iclog_syncing(iclog, _RET_IP_);
+
+	spin_unlock(&log->l_icloglock);
+	xlog_sync(log, iclog);
+	spin_lock(&log->l_icloglock);
 	return 0;
 }
 
-- 
2.31.1

