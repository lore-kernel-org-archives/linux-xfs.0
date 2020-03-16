Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DE6C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2509820752
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RRkjzq6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbgCPOvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m8lXdWGSFBGSauY28HixaPWtPr7J68VmLTEPdAH1MlY=; b=RRkjzq6cLIBp62JMZui/61nX0v
        JuCSLT/+Yj95UakaftDo2mwGTOQ8os6QV6wnGD3UzH5zJH/NlF/xMZ0h52kkoYqbTu8rxSdKX39Qa
        T+IkqOFkpkzL92id46RK/2oc1IkRzA4K8tsnT1gBksAV0bxCjeBNc8N79Qa+3Cwi+P/8gSWhP8bu1
        dplz2JfROu+J2ZHbkwTeS8A3FMla7qMjduoeg5HM6O780OW8ER1+9fOlBXWHWRzdBh4+3XrAFj9Fr
        BuQ1deSVs1uoBf9r2PwbSGRugRMLD3E//vpXLHoHi4YrSm9VqszB+YDyX06c/dthkhsCpDkm1HXpz
        BzdONY3g==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5o-000090-44; Mon, 16 Mar 2020 14:51:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/14] xfs: merge xlog_state_set_callback into xlog_state_iodone_process_iclog
Date:   Mon, 16 Mar 2020 15:42:31 +0100
Message-Id: <20200316144233.900390-13-hch@lst.de>
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

Merge xlog_state_set_callback into its only caller, which makes the iclog
I/O completion handling a little easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 74 +++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 899c324d07e2..865dd1e08679 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2645,46 +2645,6 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
-/*
- * Completion of a iclog IO does not imply that a transaction has completed, as
- * transactions can be large enough to span many iclogs. We cannot change the
- * tail of the log half way through a transaction as this may be the only
- * transaction in the log and moving the tail to point to the middle of it
- * will prevent recovery from finding the start of the transaction. Hence we
- * should only update the last_sync_lsn if this iclog contains transaction
- * completion callbacks on it.
- *
- * We have to do this before we drop the icloglock to ensure we are the only one
- * that can update it.
- *
- * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
- * the reservation grant head pushing. This is due to the fact that the push
- * target is bound by the current last_sync_lsn value. Hence if we have a large
- * amount of log space bound up in this committing transaction then the
- * last_sync_lsn value may be the limiting factor preventing tail pushing from
- * freeing space in the log. Hence once we've updated the last_sync_lsn we
- * should push the AIL to ensure the push target (and hence the grant head) is
- * no longer bound by the old log head location and can move forwards and make
- * progress again.
- */
-static void
-xlog_state_set_callback(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		header_lsn)
-{
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-
-	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-			   header_lsn) <= 0);
-
-	if (list_empty_careful(&iclog->ic_callbacks))
-		return;
-
-	atomic64_set(&log->l_last_sync_lsn, header_lsn);
-	xlog_grant_push_ail(log, 0);
-}
-
 /*
  * Keep processing entries in the iclog callback list until we come around and
  * it is empty.  We need to atomically see that the list is empty and change the
@@ -2741,7 +2701,39 @@ xlog_state_iodone_process_iclog(
 	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 		return false;
 
-	xlog_state_set_callback(log, iclog, header_lsn);
+	iclog->ic_state = XLOG_STATE_CALLBACK;
+
+	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
+			   header_lsn) <= 0);
+
+	/*
+	 * Completion of an iclog I/O does not imply that a transaction has
+	 * completed, as transactions can be large enough to span multiple
+	 * iclogs.  We cannot change the tail of the log half way through a
+	 * transaction as this may be the only transaction in the log and moving
+	 * the tail to point to the middle of it will prevent recovery from
+	 * finding the start of the transaction. Hence we should only update
+	 * the last_sync_lsn if this iclog contains transaction completion
+	 * callbacks on it.
+	 *
+	 * We have to do this before we drop the icloglock to ensure we are the
+	 * only one that can update it.
+	 *
+	 * If we are moving last_sync_lsn forwards, we also need to ensure we
+	 * kick the reservation grant head pushing. This is due to the fact that
+	 * the push target is bound by the current last_sync_lsn value.  If we
+	 * have a large amount of log space bound up in this committing
+	 * transaction then the last_sync_lsn value may be the limiting factor
+	 * preventing tail pushing from freeing space in the log.  Hence once
+	 * we've updated the last_sync_lsn we should push the AIL to ensure the
+	 * push target (and hence the grant head) is no longer bound by the old
+	 * log head location and can move forwards and make progress again.
+	 */
+	if (!list_empty_careful(&iclog->ic_callbacks)) {
+		atomic64_set(&log->l_last_sync_lsn, header_lsn);
+		xlog_grant_push_ail(log, 0);
+	}
+
 	xlog_state_do_iclog_callbacks(log, iclog);
 
 	iclog->ic_state = XLOG_STATE_DIRTY;
-- 
2.24.1

