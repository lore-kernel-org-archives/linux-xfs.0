Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7618C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACECE61356
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFPQgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhFPQgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:36:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37078C0617A8
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=H5+lhxA85qvY5IJAoi2MDKWmgsIRgqZiw/Nt/fuAKfA=; b=Tuw9VB7rdr7Ry8/SxqeWd6MHau
        VTt98F/uK3TaJsM+D4ysiX+sJxu5kg8eV5cKSIkOiNcq/P/mTb+BqxfjzVxsKiUAc3dYytxTICPyZ
        7qvjOu+a/vj/V60bFPjOZBogHY2NYuwc8Jv7WeRqqphe6H3NkMbOjzMmXYbi+w3NbQT+jfeaNSt1I
        xRTwZfaJC46JeNyLUc68kLAKxgmOR7HJFscMwkoR4XN9LIG1sUnvUTLSg8c7VRvAuQ78sT+WygUd5
        DnUrDb9t3A9qN2pcb6DaUFT/QQWmS5CP1aszFfmFmdjyrdxeoGlUN6qnKgpfE/thuGlIUroS/0Ly0
        Bsvap7WA==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYU7-008G6J-2s
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:33:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: remove xlog_verify_dest_ptr
Date:   Wed, 16 Jun 2021 18:32:09 +0200
Message-Id: <20210616163212.1480297-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check that the offset in xlog_write_vec is smaller than the iclog
size and remove the expensive cycling through all iclogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 35 +----------------------------------
 fs/xfs/xfs_log_priv.h |  4 ----
 2 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1bc32f056a5bcf..5d55d4fff63035 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -59,10 +59,6 @@ xlog_sync(
 	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
-xlog_verify_dest_ptr(
-	struct xlog		*log,
-	void			*ptr);
-STATIC void
 xlog_verify_grant_tail(
 	struct xlog *log);
 STATIC void
@@ -76,7 +72,6 @@ xlog_verify_tail_lsn(
 	struct xlog_in_core	*iclog,
 	xfs_lsn_t		tail_lsn);
 #else
-#define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b,c)
@@ -1501,9 +1496,6 @@ xlog_alloc_log(
 						KM_MAYFAIL | KM_ZERO);
 		if (!iclog->ic_data)
 			goto out_free_iclog;
-#ifdef DEBUG
-		log->l_iclog_bak[i] = &iclog->ic_header;
-#endif
 		head = &iclog->ic_header;
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
@@ -2134,6 +2126,7 @@ xlog_write_iovec(
 	uint32_t		*record_cnt,
 	uint32_t		*data_cnt)
 {
+	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
 	ASSERT(*log_offset % sizeof(int32_t) == 0);
 	ASSERT(write_len % sizeof(int32_t) == 0);
 
@@ -2258,7 +2251,6 @@ xlog_write_partial(
 	struct xfs_log_vec	*lv = log_vector;
 	struct xfs_log_iovec	*reg;
 	struct xlog_op_header	*ophdr;
-	void			*ptr;
 	int			index = 0;
 	uint32_t		rlen;
 	int			error;
@@ -2297,7 +2289,6 @@ xlog_write_partial(
 		if (rlen != reg->i_len)
 			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
 		xlog_write_iovec(iclog, log_offset, reg->i_addr, rlen, len,
 				 record_cnt, data_cnt);
 
@@ -2363,7 +2354,6 @@ xlog_write_partial(
 			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
 			ophdr->oh_len = cpu_to_be32(rlen);
 
-			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
 			xlog_write_iovec(iclog, log_offset,
 					 reg->i_addr + reg_offset, rlen, len,
 					 record_cnt, data_cnt);
@@ -3466,29 +3456,6 @@ xlog_ticket_alloc(
 }
 
 #if defined(DEBUG)
-/*
- * Make sure that the destination ptr is within the valid data region of
- * one of the iclogs.  This uses backup pointers stored in a different
- * part of the log in case we trash the log structure.
- */
-STATIC void
-xlog_verify_dest_ptr(
-	struct xlog	*log,
-	void		*ptr)
-{
-	int i;
-	int good_ptr = 0;
-
-	for (i = 0; i < log->l_iclog_bufs; i++) {
-		if (ptr >= log->l_iclog_bak[i] &&
-		    ptr <= log->l_iclog_bak[i] + log->l_iclog_size)
-			good_ptr++;
-	}
-
-	if (!good_ptr)
-		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
-}
-
 /*
  * Check to make sure the grant write head didn't just over lap the tail.  If
  * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1b3b3d2bb8a5d1..b829d8ba5c6a3f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -434,10 +434,6 @@ struct xlog {
 
 	struct xfs_kobj		l_kobj;
 
-	/* The following field are used for debugging; need to hold icloglock */
-#ifdef DEBUG
-	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
-#endif
 	/* log recovery lsn tracking (for buffer submission */
 	xfs_lsn_t		l_recovery_lsn;
 
-- 
2.30.2

