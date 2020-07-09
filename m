Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D36BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D34032077D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dcbJ6mGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGIPNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A97EC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=bPGBQolre54dR4kfOUzfsYKiHVQ5rs7/kiqZOVcwwlw=; b=dcbJ6mGDYMmBGBN0BMxoXjBD5i
        soJRREYSBFm518O4NR4BV0RUy6/TYN+10H3qn/wHKljFi8ElM63GJhi+ScTl/jjI4buVPG8GhsL4L
        jIG0uXHoenVxb9RkQOMFiS53XAPxOuMJLq8yyEfDM/k5TBfOehxqtpMZlrZqss/Xn6G4JumQI4cYs
        YeWoojGIVYIx4fBHVAENeWEM3FR1RkLJSo16+AbXYD6AVP3XMePznhu3PKceqfowIYwuhmtbWdfUg
        iKqn+D2mTuCxd5RvJ6Z0xwBsrJvRQO9hbI+lQxvHYpK3/hH3c/SlqauedoDD0aFf0uhI8DqlG1+N5
        L9CWvM9w==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYF9-00057r-4c
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] xfs: fold xfs_buf_ioend_finish into xfs_ioend
Date:   Thu,  9 Jul 2020 17:04:45 +0200
Message-Id: <20200709150453.109230-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709150453.109230-1-hch@lst.de>
References: <20200709150453.109230-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need to keep a separate helper for this logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 8 +++++---
 fs/xfs/xfs_buf.h         | 7 -------
 fs/xfs/xfs_log_recover.c | 1 -
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 443d11bdfcf502..e6a73e455caa1a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1335,7 +1335,6 @@ xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
-		xfs_buf_ioend_finish(bp);
 	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
 		/*
 		 * If this is a log recovery buffer, we aren't doing
@@ -1383,9 +1382,12 @@ xfs_buf_ioend(
 			xfs_buf_inode_iodone(bp);
 		else if (bp->b_flags & _XBF_DQUOTS)
 			xfs_buf_dquot_iodone(bp);
-
-		xfs_buf_ioend_finish(bp);
 	}
+
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+	else
+		complete(&bp->b_iowait);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bea20d43a38191..9eb4044597c985 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -269,13 +269,6 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_buf *bp);
-static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
-{
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
-		complete(&bp->b_iowait);
-}
 
 extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cf6dabb98f2327..741a2c247bc585 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -288,7 +288,6 @@ xlog_recover_iodone(
 		xfs_buf_item_relse(bp);
 	ASSERT(bp->b_log_item == NULL);
 	bp->b_flags &= ~_XBF_LOGRECOVERY;
-	xfs_buf_ioend_finish(bp);
 }
 
 /*
-- 
2.26.2

