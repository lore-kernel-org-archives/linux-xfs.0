Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA179C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9252075E
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rniKnzr8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgCPOvj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5Pc6JPsBI5ieZ88bOSZHjuuTO1w7GqYvdW+/u9rokaY=; b=rniKnzr8FV+WwFlU9cs4GroHoI
        SYmfPhsm2p0dt3Xo/szzderlwEaGst6Y8vt0JbtdaUxPDHGZunWZ5ORkg5n8bq7J/dYymmmGAJ/6z
        LaxBU8hrMymVOVqvdMFYTQ8RHL4Vab9TR53oB/fmemgIIdBZcyGveXsGGB/Z17oc4iiHoyLMOilQy
        f7imKB7nNfeAExiGezemLHSFPa6A+bLO80pb0H92erQCXbukkAwceA8o2IkkmJhiknzwcmzmSBqtb
        /CJ62MEdna28oBwICUQMWTPiumLsuh9j/dsGBnbFeGp8AAd+G9M1EbSQUhSs2fs9XYPG1P96eOlW9
        s4PYFb1g==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5e-00007Y-Iu; Mon, 16 Mar 2020 14:51:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: move xlog_state_do_iclog_callbacks up
Date:   Mon, 16 Mar 2020 15:42:27 +0100
Message-Id: <20200316144233.900390-9-hch@lst.de>
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

Move xlog_state_do_iclog_callbacks a little up, to avoid the need for a
forward declaration with upcoming changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 74 ++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c490c5b0d8b7..c534d7007aa3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2701,6 +2701,43 @@ xlog_state_set_callback(
 	xlog_grant_push_ail(log, 0);
 }
 
+/*
+ * Keep processing entries in the iclog callback list until we come around and
+ * it is empty.  We need to atomically see that the list is empty and change the
+ * state to DIRTY so that we don't miss any more callbacks being added.
+ *
+ * This function is called with the icloglock held and returns with it held. We
+ * drop it while running callbacks, however, as holding it over thousands of
+ * callbacks is unnecessary and causes excessive contention if we do.
+ */
+static void
+xlog_state_do_iclog_callbacks(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
+{
+	spin_unlock(&log->l_icloglock);
+	spin_lock(&iclog->ic_callback_lock);
+	while (!list_empty(&iclog->ic_callbacks)) {
+		LIST_HEAD(tmp);
+
+		list_splice_init(&iclog->ic_callbacks, &tmp);
+
+		spin_unlock(&iclog->ic_callback_lock);
+		xlog_cil_process_committed(&tmp);
+		spin_lock(&iclog->ic_callback_lock);
+	}
+
+	/*
+	 * Pick up the icloglock while still holding the callback lock so we
+	 * serialise against anyone trying to add more callbacks to this iclog
+	 * now we've finished processing.
+	 */
+	spin_lock(&log->l_icloglock);
+	spin_unlock(&iclog->ic_callback_lock);
+}
+
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2754,43 +2791,6 @@ xlog_state_iodone_process_iclog(
 	}
 }
 
-/*
- * Keep processing entries in the iclog callback list until we come around and
- * it is empty.  We need to atomically see that the list is empty and change the
- * state to DIRTY so that we don't miss any more callbacks being added.
- *
- * This function is called with the icloglock held and returns with it held. We
- * drop it while running callbacks, however, as holding it over thousands of
- * callbacks is unnecessary and causes excessive contention if we do.
- */
-static void
-xlog_state_do_iclog_callbacks(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-		__releases(&log->l_icloglock)
-		__acquires(&log->l_icloglock)
-{
-	spin_unlock(&log->l_icloglock);
-	spin_lock(&iclog->ic_callback_lock);
-	while (!list_empty(&iclog->ic_callbacks)) {
-		LIST_HEAD(tmp);
-
-		list_splice_init(&iclog->ic_callbacks, &tmp);
-
-		spin_unlock(&iclog->ic_callback_lock);
-		xlog_cil_process_committed(&tmp);
-		spin_lock(&iclog->ic_callback_lock);
-	}
-
-	/*
-	 * Pick up the icloglock while still holding the callback lock so we
-	 * serialise against anyone trying to add more callbacks to this iclog
-	 * now we've finished processing.
-	 */
-	spin_lock(&log->l_icloglock);
-	spin_unlock(&iclog->ic_callback_lock);
-}
-
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log)
-- 
2.24.1

