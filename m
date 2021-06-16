Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E38BC48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5900F61356
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhFPQhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbhFPQhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:37:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BE0C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=Nn8TfUVhaH5GRsCmm3ljXHlRGPEJzdb+4yTT3UIPqMI=; b=ir6TXTUHFjxRlYv7kJsXJQSD64
        9LHVR3nWGetKsZ/0EExyjMbvNeJ97VTjUzNSavnQ9VHTqWDLV3V4Xak4ZylPZ4hi81QZwVOV9Pzpy
        peDxlHwv8cDUB+mVgoq4E2WUgfSkrPGV2KQW4eslr29cfUas7Su+WEV0bAdCX5m0xml3IsPu4mZWb
        gK2JpSRP+LEp5VIvf3Vv0qu+saqNe4COklZgqcPfojaUDOVY/DKat/jeZQ6d180Gyx/uIW3QTFYlW
        OIhj2mFdAOB+ie6+iw8leeio53PIgWZD0u6PwWaMH+lzVtmpsbkged+8P2bIP+J1a+WTKPGA03Ya2
        Dja/qIBg==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYV8-008GAx-1r
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:34:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: simplify the list iteration in xlog_write
Date:   Wed, 16 Jun 2021 18:32:12 +0200
Message-Id: <20210616163212.1480297-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just use a single list_for_each_entry in xlog_write which then
dispatches to the simple or partial cases instead of using nested
loops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 73 +++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f8df09f37c3b84..365914c25ff0f0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2175,47 +2175,6 @@ xlog_write_full(
 	}
 }
 
-/*
- * Write whole log vectors into a single iclog which is guaranteed to have
- * either sufficient space for the entire log vector chain to be written or
- * exclusive access to the remaining space in the iclog.
- *
- * Return the number of iovecs and data written into the iclog, as well as
- * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
- * end of the chain.
- */
-static struct xfs_log_vec *
-xlog_write_single(
-	struct list_head	*lv_chain,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	*iclog,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
-{
-	struct xfs_log_vec	*lv;
-
-	for (lv = log_vector;
-	     !list_entry_is_head(lv, lv_chain, lv_list);
-	     lv = list_next_entry(lv, lv_list)) {
-		/*
-		 * If the entire log vec does not fit in the iclog, punt it to
-		 * the partial copy loop which can handle this case.
-		 */
-		if (lv->lv_niovecs &&
-		    lv->lv_bytes > iclog->ic_size - *log_offset)
-			break;
-		xlog_write_full(lv, ticket, iclog, log_offset, len, record_cnt,
-				data_cnt);
-	}
-	if (list_entry_is_head(lv, lv_chain, lv_list))
-		lv = NULL;
-	ASSERT(*len == 0 || lv);
-	return lv;
-}
-
 static int
 xlog_write_get_more_iclog_space(
 	struct xlog		*log,
@@ -2454,22 +2413,24 @@ xlog_write(
 	if (start_lsn)
 		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
-	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
-	while (lv) {
-		lv = xlog_write_single(lv_chain, lv, ticket, iclog, &log_offset,
-					&len, &record_cnt, &data_cnt);
-		if (!lv)
-			break;
-
-		error = xlog_write_partial(lv, ticket, &iclog, &log_offset,
-					   &len, &record_cnt, &data_cnt);
-		if (error)
-			break;
-		lv = list_next_entry(lv, lv_list);
-		if (list_entry_is_head(lv, lv_chain, lv_list))
-			break;
+	list_for_each_entry(lv, lv_chain, lv_list) {
+		/*
+		 * If the entire log vec does not fit in the iclog, punt it to
+		 * the partial copy loop which can handle this case.
+		 */
+		if (lv->lv_niovecs &&
+		    lv->lv_bytes > iclog->ic_size - log_offset) {
+			error = xlog_write_partial(lv, ticket, &iclog,
+						   &log_offset, &len,
+						   &record_cnt, &data_cnt);
+			if (error)
+				break;
+		} else {
+			xlog_write_full(lv, ticket, iclog, &log_offset, &len,
+					&record_cnt, &data_cnt);
+		}
 	}
-	ASSERT((len == 0 && !lv) || error);
+	ASSERT(len == 0 || error);
 
 	/*
 	 * We've already been guaranteed that the last writes will fit inside
-- 
2.30.2

