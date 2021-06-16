Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1A2C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D989261351
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhFPQgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhFPQft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:35:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B46C061767
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=wCKHjGNk495455IdS8vUcvNie/Cn7eJI8DQ6fVhWTpM=; b=fI6IEykoxD9rE5jJ1PR0t0QvV/
        a4odw3LtWNYB67/B/9+lEqN0k4d0zQUaFM6GmLoMYb8tIGKCTsOPPyaZR6lA2BEeaLq6SDYhbnPFf
        J58/RHHp4+/ZDEinBXgwm01ybJGVD/LwRlAG9unvlPgm4tOfETvPCODi8PGGkHTJlBf9da/onHzkc
        d2mmgFn2oB67dF8K/BAJFChBsN7TdpyYldnGJQbgVZVCteadWdx8Rgadj/DhrNVoa7nkFZreSSNKT
        dc9i3PNojC47SExCAyfTioDaAp2wcIWo2c6aMx2eNm1JV1dwbdkvNn7SdwpcMTTFhhtDGO/rB6Lxl
        L4V0Hwmg==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYTX-008G3t-Ls
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:33:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: factor out a helper to write a log_iovec into the iclog
Date:   Wed, 16 Jun 2021 18:32:07 +0200
Message-Id: <20210616163212.1480297-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new helper to copy the log iovec into the in-core log buffer,
and open code the handling continuation opheader as a special case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 55 +++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 32cb0fc459a364..5b431d53287d2c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2124,6 +2124,26 @@ xlog_print_trans(
 	}
 }
 
+static inline void
+xlog_write_iovec(
+	struct xlog_in_core	*iclog,
+	uint32_t		*log_offset,
+	void			*data,
+	uint32_t		write_len,
+	int			*bytes_left,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt)
+{
+	ASSERT(*log_offset % sizeof(int32_t) == 0);
+	ASSERT(write_len % sizeof(int32_t) == 0);
+
+	memcpy(iclog->ic_datap + *log_offset, data, write_len);
+	*log_offset += write_len;
+	*bytes_left -= write_len;
+	(*record_cnt)++;
+	*data_cnt += write_len;
+}
+
 /*
  * Write whole log vectors into a single iclog which is guaranteed to have
  * either sufficient space for the entire log vector chain to be written or
@@ -2145,13 +2165,11 @@ xlog_write_single(
 	uint32_t		*data_cnt)
 {
 	struct xfs_log_vec	*lv;
-	void			*ptr;
 	int			index;
 
 	ASSERT(*log_offset + *len <= iclog->ic_size ||
 		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
-	ptr = iclog->ic_datap + *log_offset;
 	for (lv = log_vector;
 	     !list_entry_is_head(lv, lv_chain, lv_list);
 	     lv = list_next_entry(lv, lv_list)) {
@@ -2171,16 +2189,13 @@ xlog_write_single(
 			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
 			struct xlog_op_header	*ophdr = reg->i_addr;
 
-			ASSERT(reg->i_len % sizeof(int32_t) == 0);
-			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
-
 			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
 			ophdr->oh_len = cpu_to_be32(reg->i_len -
 						sizeof(struct xlog_op_header));
-			memcpy(ptr, reg->i_addr, reg->i_len);
-			xlog_write_adv_cnt(&ptr, len, log_offset, reg->i_len);
-			(*record_cnt)++;
-			*data_cnt += reg->i_len;
+
+			xlog_write_iovec(iclog, log_offset, reg->i_addr,
+					 reg->i_len, len, record_cnt,
+					 data_cnt);
 		}
 	}
 	if (list_entry_is_head(lv, lv_chain, lv_list))
@@ -2249,12 +2264,10 @@ xlog_write_partial(
 	int			error;
 
 	/* walk the logvec, copying until we run out of space in the iclog */
-	ptr = iclog->ic_datap + *log_offset;
 	for (index = 0; index < lv->lv_niovecs; index++) {
 		uint32_t	reg_offset = 0;
 
 		reg = &lv->lv_iovecp[index];
-		ASSERT(reg->i_len % sizeof(int32_t) == 0);
 
 		/*
 		 * The first region of a continuation must have a non-zero
@@ -2274,7 +2287,6 @@ xlog_write_partial(
 					data_cnt);
 			if (error)
 				return ERR_PTR(error);
-			ptr = iclog->ic_datap + *log_offset;
 		}
 
 		ophdr = reg->i_addr;
@@ -2285,12 +2297,9 @@ xlog_write_partial(
 		if (rlen != reg->i_len)
 			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
-		xlog_verify_dest_ptr(log, ptr);
-		memcpy(ptr, reg->i_addr, rlen);
-		xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
-		(*record_cnt)++;
-		*data_cnt += rlen;
+		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
+		xlog_write_iovec(iclog, log_offset, reg->i_addr, rlen, len,
+				 record_cnt, data_cnt);
 
 		/* If we wrote the whole region, move to the next. */
 		if (rlen == reg->i_len)
@@ -2356,12 +2365,10 @@ xlog_write_partial(
 			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
 			ophdr->oh_len = cpu_to_be32(rlen);
 
-			xlog_verify_dest_ptr(log, ptr);
-			memcpy(ptr, reg->i_addr + reg_offset, rlen);
-			xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
-			(*record_cnt)++;
-			*data_cnt += rlen;
-
+			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
+			xlog_write_iovec(iclog, log_offset,
+					 reg->i_addr + reg_offset, rlen, len,
+					 record_cnt, data_cnt);
 		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
 	}
 
-- 
2.30.2

