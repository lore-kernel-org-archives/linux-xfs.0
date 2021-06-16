Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA40C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CE1613DC
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhFPQg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhFPQg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:36:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B70C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=AWmt/JAQcf5OF2oa8CpgUiKffxILYfQkA/gxmYiZ22o=; b=bPO87/ySMLGBHzEr+08p5Bv87d
        sMGBd41rDVV8YDfqmXgs/99pIFTGahPe9KPZUYyWOXJLFudUyp0xzfzCVWtvl4QpFMfuiXa+veNV1
        bxmvTvgL9IzI5y8YvxEpF7k4PAl9cHoi07XKWcL70C9q+KCTspeb6FlkSVCvaL2A4+lq+ICNuHeK8
        y2DGFGu2xooVfY1P6cglwlIkCXq9rvyf7korrfXXA1OpyQ9a61eXhIpRHxUVpiRCcZMXWGfxHo1DK
        g3W9pUyT1+QT1LmeDVgktlTlARafUkWYUfEC4OcLm3CxLGRv//Vpbk8oWWxl2rnvKeXLRqAuKiSCK
        YIzN7F+g==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYUn-008G9H-L0
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:34:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: factor out a xlog_write_full_log_vec helper
Date:   Wed, 16 Jun 2021 18:32:11 +0200
Message-Id: <20210616163212.1480297-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a helper to write out an entire log_vec to prepare for additional
cleanups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 61 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4afa8ff1a82076..f8df09f37c3b84 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2137,6 +2137,44 @@ xlog_write_iovec(
 	*data_cnt += write_len;
 }
 
+/*
+ * Write a whole log vector into a single iclog which is guaranteed to have
+ * either sufficient space for the entire log vector chain to be written or
+ * exclusive access to the remaining space in the iclog.
+ *
+ * Return the number of iovecs and data written into the iclog.
+ */
+static void
+xlog_write_full(
+	struct xfs_log_vec	*lv,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	*iclog,
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt)
+{
+	int			i;
+
+	ASSERT(*log_offset + *len <= iclog->ic_size ||
+		iclog->ic_state == XLOG_STATE_WANT_SYNC);
+
+	/*
+	 * Ordered log vectors have no regions to write so this loop will
+	 * naturally skip them.
+	 */
+	for (i = 0; i < lv->lv_niovecs; i++) {
+		struct xfs_log_iovec	*reg = &lv->lv_iovecp[i];
+		struct xlog_op_header	*ophdr = reg->i_addr;
+
+		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		ophdr->oh_len =
+			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
+		xlog_write_iovec(iclog, log_offset, reg->i_addr, reg->i_len,
+				 len, record_cnt, data_cnt);
+	}
+}
+
 /*
  * Write whole log vectors into a single iclog which is guaranteed to have
  * either sufficient space for the entire log vector chain to be written or
@@ -2158,10 +2196,6 @@ xlog_write_single(
 	uint32_t		*data_cnt)
 {
 	struct xfs_log_vec	*lv;
-	int			index;
-
-	ASSERT(*log_offset + *len <= iclog->ic_size ||
-		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	for (lv = log_vector;
 	     !list_entry_is_head(lv, lv_chain, lv_list);
@@ -2173,23 +2207,8 @@ xlog_write_single(
 		if (lv->lv_niovecs &&
 		    lv->lv_bytes > iclog->ic_size - *log_offset)
 			break;
-
-		/*
-		 * Ordered log vectors have no regions to write so this
-		 * loop will naturally skip them.
-		 */
-		for (index = 0; index < lv->lv_niovecs; index++) {
-			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-			struct xlog_op_header	*ophdr = reg->i_addr;
-
-			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-			ophdr->oh_len = cpu_to_be32(reg->i_len -
-						sizeof(struct xlog_op_header));
-
-			xlog_write_iovec(iclog, log_offset, reg->i_addr,
-					 reg->i_len, len, record_cnt,
-					 data_cnt);
-		}
+		xlog_write_full(lv, ticket, iclog, log_offset, len, record_cnt,
+				data_cnt);
 	}
 	if (list_entry_is_head(lv, lv_chain, lv_list))
 		lv = NULL;
-- 
2.30.2

