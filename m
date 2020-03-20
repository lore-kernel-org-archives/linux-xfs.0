Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92C1C4332E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD6C20781
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UPH+85AE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCTGxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:53:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EDthvB3qWaC4jyeKUPT5PSQ7K1qMfIAcUiq7GQCL6pE=; b=UPH+85AETFzVRGGj7RrrxbkuTL
        DhthfViHsQ+0vgvxYxOHTW2T3Ns+DOK1lp/wSFr9IqpeYDqFEFPxbPrl/JFdF1uKgO1MxlN+YQDne
        QbS/UEnOhwISHEGk8KKwrw0doDqc1X4RKlHJ9cOR4OJx57d7pDQ89wIZa+MAyFIMvXgaNA37QTyO+
        dkKVP/g/Y1ari2mRg1jXiK+xItlNf1n6ldtYK3n1gkccfIH553YMrz0O19PY5JGoOpT5EX3WnsKBm
        xRxzcMs4lWpuvearf35vXc907NOzblhJw1CCgPZimzrTcDQrwfEh4vMHB9MXgsLrpPNG0dWjoEQSZ
        ptc0IPDA==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBWv-0006EP-HP; Fri, 20 Mar 2020 06:53:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/8] xfs: merge xlog_cil_push into xlog_cil_push_work
Date:   Fri, 20 Mar 2020 07:53:04 +0100
Message-Id: <20200320065311.28134-2-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320065311.28134-1-hch@lst.de>
References: <20200320065311.28134-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48435cf2aa16..9ef0f8b555a4 100644
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
+ * Hence we can allow log forces to run racily and not issue pushes for the
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
2.25.1

