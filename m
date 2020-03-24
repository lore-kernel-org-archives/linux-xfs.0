Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605CFC41621
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39976208E0
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uMH5pB4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgCXRpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:45:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgCXRpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hqshxegvpLRjgTp1YMLCJKba9+oZDRnDa6tvMdVljSw=; b=uMH5pB4qyODfpIb0LA69GuVKqa
        fD56l6kv7fSFyQmWLaJSLGOl3VH6tLjvsadyw752Om8f45ylJZ5lnWgZlkgn7k6lhpl3lvI9ephfk
        SkG/obcnncdWyvqr0ZF+a5e60MiG81JgVFc4XSeEpduANRBw+Gn3krtX1Hk8e2g2X4jTnYwTE2/Aj
        fEFLpLZ/NJyoQ7sZrSGJE/3W2gEK3yt/DipNhXA3QwukdRrNq3Z0NLcscWTCgBnzkRmoRKx2xqYYd
        BEbkG1ygQfCaR04ZtXbmYlZmhAf4Ks6N+4jZXEa/lm8qPQO+vknceOfqtFUqCVSZMcs2XgTJV1qco
        goCzzJsw==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnby-00036H-IG; Tue, 24 Mar 2020 17:45:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/8] xfs: kill XLOG_TIC_INITED
Date:   Tue, 24 Mar 2020 18:44:55 +0100
Message-Id: <20200324174459.770999-5-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324174459.770999-1-hch@lst.de>
References: <20200324174459.770999-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is not longer used or checked by anything, so remove the last
traces from the log ticket code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c      | 4 ----
 fs/xfs/xfs_log_priv.h | 6 ++----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 528ace7a6bb9..b30bb6452494 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2346,9 +2346,6 @@ xlog_write(
 	 * to account for an extra xlog_op_header here.
 	 */
 	ticket->t_curr_res -= sizeof(struct xlog_op_header);
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		ticket->t_flags &= ~XLOG_TIC_INITED;
-
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
@@ -3488,7 +3485,6 @@ xlog_ticket_alloc(
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
-	tic->t_flags		= XLOG_TIC_INITED;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 32bb6856e69d..cfe5295ef4e3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -51,13 +51,11 @@ enum xlog_iclog_state {
 };
 
 /*
- * Flags to log ticket
+ * Log ticket flags
  */
-#define XLOG_TIC_INITED		0x1	/* has been initialized */
-#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
+#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
 
 #define XLOG_TIC_FLAGS \
-	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
 	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
 /*
-- 
2.25.1

