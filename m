Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05559C48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0D261356
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFPQfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhFPQfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:35:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7694C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=TiA/jKSIaDaUx28iReaPf9vZd06digMfKfn74wIvAZk=; b=otyLR23P/DjS1SQ+vJpPuMyUw3
        x5i1krgUf5oA5dgEppVvIkplF9RUxKZq8k6AVfuySfOdo+2BWDDWVruYFdpexbkrDVcBTOaSzOI3z
        SxdTWVJEvsvXVcpSAchfFzDmOKGSuSfkE4Jy+62F4ernMiWSuPqKYplnU4Q1EwrA/SjGjz06jAMED
        ohFZ4v54m9F5N8BQcCRpJfs7Cd1VBfENuowlT0tXCDMHYWvloNRGvXO9OWoRreUNBTL/NoCQsCQc/
        p8zrPQMFyDArFHKJUI5K5M5nQ9WWEDZpD8r/z+Ke1ewH6S9qvgqKa4edPd0XgkzLpgWRB/zNnzebZ
        226DxA3g==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYSs-008G1N-MJ
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:32:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: change the type of ic_datap
Date:   Wed, 16 Jun 2021 18:32:05 +0200
Message-Id: <20210616163212.1480297-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Turn ic_datap from a char into a void pointer given that it points
to arbitrary data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 2 +-
 fs/xfs/xfs_log_priv.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e921b554b68367..8999c78f3ac6d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3613,7 +3613,7 @@ xlog_verify_iclog(
 		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
-			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
+			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e4e421a7033558..96dbe713954f7e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -185,7 +185,7 @@ typedef struct xlog_in_core {
 	u32			ic_offset;
 	enum xlog_iclog_state	ic_state;
 	unsigned int		ic_flags;
-	char			*ic_datap;	/* pointer to iclog data */
+	void			*ic_datap;	/* pointer to iclog data */
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
-- 
2.30.2

