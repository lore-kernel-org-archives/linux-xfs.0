Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473C9C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A5A420679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="urej1d8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgCPOq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:46:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731445AbgCPOq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5+2/fxqmRiuXtQcTQ8R4Q7CzfgmvYniXT8Mqcc2Bpxk=; b=urej1d8kSBedbTPuW/8yVYWiPs
        oGFYQ6mK2TtAY/fYKqq+5S2XjumSfQzkhK+B7eG2RB8xm8CyGKEmM8f0IYPGCm0ZPGovvADcO6n/g
        y8F7GKwhxXOV8pC0/ltZWpRWxS+SFmJjxqVzjf6HUi6EFMvERcNylN4D26hpuvSheSL2WxICVZA2i
        La7E0w49GR0FuCMBzcLrVr54rz41XQnxXXHh33qXN9+JfyHyjqjwaDJcAWoarX+0moD6OMqs4tTwB
        pFdWXZH45UjWslx2CXo5zFwiqt4e+TGSAop8ChEuHK8Du9Or1Lt/qqO/apk6rlYWTej/Y5KQ57VGT
        3fTxnInA==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr18-0006pB-3T; Mon, 16 Mar 2020 14:46:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/14] xfs: merge xlog_cil_push into xlog_cil_push_work
Date:   Mon, 16 Mar 2020 15:42:20 +0100
Message-Id: <20200316144233.900390-2-hch@lst.de>
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

xlog_cil_push is only called by xlog_cil_push_work, so merge the two
functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48435cf2aa16..6a6278b8eb2d 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -626,24 +626,26 @@ xlog_cil_process_committed(
 }
 
 /*
- * Push the Committed Item List to the log. If @push_seq flag is zero, then it
- * is a background flush and so we can chose to ignore it. Otherwise, if the
- * current sequence is the same as @push_seq we need to do a flush. If
- * @push_seq is less than the current sequence, then it has already been
+ * Push the Committed Item List to the log.
+ *
+ * If the current sequence is the same as xc_push_seq we need to do a flush. If
+ * xc_push_seq is less than the current sequence, then it has already been
  * flushed and we don't need to do anything - the caller will wait for it to
  * complete if necessary.
  *
- * @push_seq is a value rather than a flag because that allows us to do an
- * unlocked check of the sequence number for a match. Hence we can allows log
- * forces to run racily and not issue pushes for the same sequence twice. If we
- * get a race between multiple pushes for the same sequence they will block on
- * the first one and then abort, hence avoiding needless pushes.
+ * xc_push_seq is checked unlocked against the sequence number for a match.
+ * Hence we can allows log forces to run racily and not issue pushes for the
+ * same sequence twice.  If we get a race between multiple pushes for the same
+ * sequence they will block on the first one and then abort, hence avoiding
+ * needless pushes.
  */
-STATIC int
-xlog_cil_push(
-	struct xlog		*log)
+static void
+xlog_cil_push_work(
+	struct work_struct	*work)
 {
-	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_cil		*cil =
+		container_of(work, struct xfs_cil, xc_push_work);
+	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*ctx;
 	struct xfs_cil_ctx	*new_ctx;
@@ -657,9 +659,6 @@ xlog_cil_push(
 	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
 
-	if (!cil)
-		return 0;
-
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
@@ -867,28 +866,19 @@ xlog_cil_push(
 	spin_unlock(&cil->xc_push_lock);
 
 	/* release the hounds! */
-	return xfs_log_release_iclog(log->l_mp, commit_iclog);
+	xfs_log_release_iclog(log->l_mp, commit_iclog);
+	return;
 
 out_skip:
 	up_write(&cil->xc_ctx_lock);
 	xfs_log_ticket_put(new_ctx->ticket);
 	kmem_free(new_ctx);
-	return 0;
+	return;
 
 out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
 	xlog_cil_committed(ctx, true);
-	return -EIO;
-}
-
-static void
-xlog_cil_push_work(
-	struct work_struct	*work)
-{
-	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
-							xc_push_work);
-	xlog_cil_push(cil->xc_log);
 }
 
 /*
-- 
2.24.1

