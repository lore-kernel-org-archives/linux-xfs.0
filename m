Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BCFC18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B72620752
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TlmZYcml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbgCPOvo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HphUtX3nCPTOD4vjmlUm+urpRMO87ozpp1r6t9zqMcY=; b=TlmZYcml/E+aLjBHm+Z1AQDvZS
        I6MbqxE1qI1APLrdbJyyXf2Vydz02DtVPlrMprcptvnEj3O5Y9f3Ytbot/yGk1sTlqwAAELMq6J8/
        5RGHA5OJj/MR8OtduNzyI6OowonQuOT5zlybCsNOVNFkqK9MkxPkUwHLkkw7OtztIasinTVATp+Sc
        4mcYHawQ5J3nz4Z/r4o+4jBKG7Tv1u1t1nxxEqi/nYe+py2+nYCPSJbTOJ3EGoM6R25of6dNPNcl7
        bRjKVQGOWLiFjnhQ0sJLVJ2cjEhLAqqQfgTzeD/sOboJXpCVqEnK7v+ktF+BvN/5DvkwjWp/tV1Tx
        1R2d7fmA==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5j-00008D-C1; Mon, 16 Mar 2020 14:51:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/14] xfs: refactor xlog_state_iodone_process_iclog
Date:   Mon, 16 Mar 2020 15:42:29 +0100
Message-Id: <20200316144233.900390-11-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316144233.900390-1-hch@lst.de>
References: <20200316144233.900390-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move all state checks into the caller to make the loop flow more clear,
and instead move the callback processing together with marking the iclog
for callbacks.

This also allows to easily indicate when we actually dropped the
icloglock instead of assuming we do so for any iclog processed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 82 ++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4efaa248a03d..a38d495b6e81 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2738,47 +2738,28 @@ xlog_state_do_iclog_callbacks(
 	spin_unlock(&iclog->ic_callback_lock);
 }
 
-/*
- * Return true if we need to stop processing, false to continue to the next
- * iclog. The caller will need to run callbacks if the iclog is returned in the
- * XLOG_STATE_CALLBACK state.
- */
 static bool
 xlog_state_iodone_process_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	xfs_lsn_t		lowest_lsn;
-	xfs_lsn_t		header_lsn;
+	xfs_lsn_t		header_lsn, lowest_lsn;
 
-	switch (iclog->ic_state) {
-	case XLOG_STATE_ACTIVE:
-	case XLOG_STATE_DIRTY:
-		/*
-		 * Skip all iclogs in the ACTIVE & DIRTY states:
-		 */
-		return false;
-	case XLOG_STATE_DONE_SYNC:
-		/*
-		 * Now that we have an iclog that is in the DONE_SYNC state, do
-		 * one more check here to see if we have chased our tail around.
-		 * If this is not the lowest lsn iclog, then we will leave it
-		 * for another completion to process.
-		 */
-		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-		lowest_lsn = xlog_get_lowest_lsn(log);
-		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
-			return false;
-		xlog_state_set_callback(log, iclog, header_lsn);
+	/*
+	 * Now that we have an iclog that is in the DONE_SYNC state, do one more
+	 * check here to see if we have chased our tail around.  If this is not
+	 * the lowest lsn iclog, then we will leave it for another completion to
+	 * process.
+	 */
+	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	lowest_lsn = xlog_get_lowest_lsn(log);
+	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 		return false;
-	default:
-		/*
-		 * Can only perform callbacks in order.  Since this iclog is not
-		 * in the DONE_SYNC state, we skip the rest and just try to
-		 * clean up.
-		 */
-		return true;
-	}
+
+	xlog_state_set_callback(log, iclog, header_lsn);
+	xlog_state_do_iclog_callbacks(log, iclog);
+	xlog_state_clean_iclog(log, iclog);
+	return true;
 }
 
 STATIC void
@@ -2795,10 +2776,6 @@ xlog_state_do_callback(
 	 *
 	 * Keep looping through iclogs until one full pass is made without
 	 * running any callbacks.
-	 *
-	 * If the log has been shut down, still perform the callbacks once per
-	 * iclog to abort all log items, but don't bother to restart the loop
-	 * after dropping the log as no new callbacks can show up.
 	 */
 	spin_lock(&log->l_icloglock);
 	do {
@@ -2809,25 +2786,40 @@ xlog_state_do_callback(
 		repeats++;
 
 		do {
+			/*
+			 * If the log has been shut down, still perform the
+			 * callbacks to abort all log items to clean up any
+			 * allocate resource, but don't bother to restart the
+			 * loop after dropping the log as no new callbacks can
+			 * be attached now.
+			 */
 			if (XLOG_FORCED_SHUTDOWN(log)) {
 				xlog_state_do_iclog_callbacks(log, iclog);
 				wake_up_all(&iclog->ic_force_wait);
 				continue;
 			}
 
-			if (xlog_state_iodone_process_iclog(log, iclog))
-				break;
-
-			if (iclog->ic_state != XLOG_STATE_CALLBACK)
+			/*
+			 * Skip all iclogs in the ACTIVE & DIRTY states:
+			 */
+			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
+			    iclog->ic_state == XLOG_STATE_DIRTY)
 				continue;
 
+			/*
+			 * We can only perform callbacks in order.  If this
+			 * iclog is not in the DONE_SYNC state, we skip the rest
+			 * and just try to clean up.
+			 */
+			if (iclog->ic_state != XLOG_STATE_DONE_SYNC)
+				break;
+
 			/*
 			 * Running callbacks will drop the icloglock which means
 			 * we'll have to run at least one more complete loop.
 			 */
-			cycled_icloglock = true;
-			xlog_state_do_iclog_callbacks(log, iclog);
-			xlog_state_clean_iclog(log, iclog);
+			if (xlog_state_iodone_process_iclog(log, iclog))
+				cycled_icloglock = true;
 		} while ((iclog = iclog->ic_next) != first_iclog);
 
 		if (repeats > 5000) {
-- 
2.24.1

