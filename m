Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034C7C48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17B361375
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFPQgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhFPQgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:36:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E60FC061760
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=KcDSHBFHpogeWb37JH6IsrtjDkPG5LkJQotCBwXS6ho=; b=GPJADTupBus1uGRtIxclglC01p
        JFUjxWHLHwvuMTr9VPFJ5XesbNYekwDijCCtyJ/kz86vLkoec+Vd/SaKDjl0pUPiAxOoj2hRvKGhU
        UNsPE8lGGIFMnaVRLdlJHCD8e88VmBrwp3qtfb326AKBVc5IYczJH1z9vf6Jw60QqxElo1Z1TCemV
        A41yHFWYd4B/nrnzi5rOlyMEkignJBpSACBrjsWKfxWMEN1jog787UptIQKpT8AnEvbf69lfnK+kM
        wnLKpN49pYtBKq6tNhwEjPeHdW85pGUuT9bzSg40gSd3wGRBPg5CNs9l25HuztSmzXaVgSu0oHbW4
        xcA6QE+Q==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYUU-008G7y-Mc
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:34:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: simplify the xlog_write_partial calling conventions
Date:   Wed, 16 Jun 2021 18:32:10 +0200
Message-Id: <20210616163212.1480297-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the iteration to the next log_vec into the callers, and drop
the pointless log argument that can be trivially derived.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5d55d4fff63035..4afa8ff1a82076 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2232,14 +2232,11 @@ xlog_write_get_more_iclog_space(
 /*
  * Write log vectors into a single iclog which is smaller than the current chain
  * length. We write until we cannot fit a full record into the remaining space
- * and then stop. We return the log vector that is to be written that cannot
- * wholly fit in the iclog.
+ * and then stop.
  */
-static struct xfs_log_vec *
+static int
 xlog_write_partial(
-	struct xlog		*log,
-	struct list_head	*lv_chain,
-	struct xfs_log_vec	*log_vector,
+	struct xfs_log_vec	*lv,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclogp,
 	uint32_t		*log_offset,
@@ -2248,8 +2245,7 @@ xlog_write_partial(
 	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
-	struct xfs_log_vec	*lv = log_vector;
-	struct xfs_log_iovec	*reg;
+	struct xlog		*log = iclog->ic_log;
 	struct xlog_op_header	*ophdr;
 	int			index = 0;
 	uint32_t		rlen;
@@ -2257,9 +2253,8 @@ xlog_write_partial(
 
 	/* walk the logvec, copying until we run out of space in the iclog */
 	for (index = 0; index < lv->lv_niovecs; index++) {
-		uint32_t	reg_offset = 0;
-
-		reg = &lv->lv_iovecp[index];
+		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+		uint32_t		reg_offset = 0;
 
 		/*
 		 * The first region of a continuation must have a non-zero
@@ -2278,7 +2273,7 @@ xlog_write_partial(
 					&iclog, log_offset, *len, record_cnt,
 					data_cnt);
 			if (error)
-				return ERR_PTR(error);
+				return error;
 		}
 
 		ophdr = reg->i_addr;
@@ -2329,7 +2324,7 @@ xlog_write_partial(
 					*len + sizeof(struct xlog_op_header),
 					record_cnt, data_cnt);
 			if (error)
-				return ERR_PTR(error);
+				return error;
 
 			ophdr = iclog->ic_datap + *log_offset;
 			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
@@ -2365,10 +2360,7 @@ xlog_write_partial(
 	 * the caller so it can go back to fast path copying.
 	 */
 	*iclogp = iclog;
-	lv = list_next_entry(lv, lv_list);
-	if (list_entry_is_head(lv, lv_chain, lv_list))
-		return NULL;
-	return lv;
+	return 0;
 }
 
 /*
@@ -2450,13 +2442,13 @@ xlog_write(
 		if (!lv)
 			break;
 
-		lv = xlog_write_partial(log, lv_chain, lv, ticket, &iclog,
-					&log_offset, &len, &record_cnt,
-					&data_cnt);
-		if (IS_ERR_OR_NULL(lv)) {
-			error = PTR_ERR_OR_ZERO(lv);
+		error = xlog_write_partial(lv, ticket, &iclog, &log_offset,
+					   &len, &record_cnt, &data_cnt);
+		if (error)
+			break;
+		lv = list_next_entry(lv, lv_list);
+		if (list_entry_is_head(lv, lv_chain, lv_list))
 			break;
-		}
 	}
 	ASSERT((len == 0 && !lv) || error);
 
-- 
2.30.2

