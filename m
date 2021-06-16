Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF6AC48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0765A61356
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFPQgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhFPQfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB87C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=wf1ZtzWA/fYEmFI1ias1swk53gjv9unRVGn7yXvVZJ0=; b=f3oQ9gWDOeTDonHe49HSJIbkhn
        qwHwgZlWCr+BL5GRtATzazSbPC5Y4lcoazKApJQGwbc5wYWfibjcKbDSoR3dAmHGNFvVS7yhxOb2v
        oqNZDomLx3m58OaRvZKq6cgAa0T3bipeD9VZwvfFjKZDfCutKxo0hEMbujLxSq2vhejT71jkMczNx
        GuJ778kWSgWKoc+pTsHgMAX/X8nspXkCKeilcNzYpjHyAZ6395Ab8qal/ohZZPg/ENb9/sm5XGtEJ
        oCpkydB/ZJn2Cbrg3qCvCRVwE2OnWgTQCYsXaH/Aqjn9UjqgAN9RV6MfSdjRK5lwWSNFUspYNXU+C
        yHI2ExGA==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYTn-008G4j-UG
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:33:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: remove xlog_write_adv_cnt and simplify xlog_write_partial
Date:   Wed, 16 Jun 2021 18:32:08 +0200
Message-Id: <20210616163212.1480297-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xlog_write_adv_cnt is now only used for writing the continuation ophdr.
Remove xlog_write_adv_cnt and simplify the caller now that we don't need
the ptr iteration variable, and don't need to increment / decrement
len for the accounting shengians.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 12 +++++-------
 fs/xfs/xfs_log_priv.h |  8 --------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5b431d53287d2c..1bc32f056a5bcf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2331,24 +2331,22 @@ xlog_write_partial(
 			 * a new iclog. This is necessary so that we reserve
 			 * space in the iclog for it.
 			 */
-			*len += sizeof(struct xlog_op_header);
 			ticket->t_curr_res -= sizeof(struct xlog_op_header);
 
 			error = xlog_write_get_more_iclog_space(log, ticket,
-					&iclog, log_offset, *len, record_cnt,
-					data_cnt);
+					&iclog, log_offset,
+					*len + sizeof(struct xlog_op_header),
+					record_cnt, data_cnt);
 			if (error)
 				return ERR_PTR(error);
-			ptr = iclog->ic_datap + *log_offset;
 
-			ophdr = ptr;
+			ophdr = iclog->ic_datap + *log_offset;
 			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
 			ophdr->oh_clientid = XFS_TRANSACTION;
 			ophdr->oh_res2 = 0;
 			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
 
-			xlog_write_adv_cnt(&ptr, len, log_offset,
-						sizeof(struct xlog_op_header));
+			*log_offset += sizeof(struct xlog_op_header);
 			*data_cnt += sizeof(struct xlog_op_header);
 
 			/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 96dbe713954f7e..1b3b3d2bb8a5d1 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -467,14 +467,6 @@ extern kmem_zone_t *xfs_log_ticket_zone;
 struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
 		int count, bool permanent);
 
-static inline void
-xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
-{
-	*ptr += bytes;
-	*len -= bytes;
-	*off += bytes;
-}
-
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct list_head *lv_chain,
-- 
2.30.2

