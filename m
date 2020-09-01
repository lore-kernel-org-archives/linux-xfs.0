Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6C8C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8AAE206EB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jD0S5wL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgIAPvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgIAPug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AD4C061251
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PPCvJmUAwHhHiLUMWS0+T1vrF/uuwXtFbGwE0YRmTrc=; b=jD0S5wL0w8QD00RWJznVl5oIwH
        +buV5Zz+Ed1QXxLLcjMtUIrifKwO8KLtXOfTUAhtqK3GWaX+QotXmNgxR0Z1JQI7V+Al8xD185kFB
        UWA7xaAukjAqoIwJn4choDGR0+QuVAM6/1b0n5EieAa6vmbrcKFcCiBLA1APuOdcXbfYeknAgz7kV
        c4RrgKMzVj5u/saUEMv5qGTY/A1yAAqlZ1bb7TW0TtehRzJ4i2bRIyeWq1tTv7gph5cl5Jya/SuOr
        J/AH7N/Rw05KJaFFNZfkJbotK4yFTza37L8qHkElx6mjVXqK3yAa2I4yGJb7YdPRJnjEGUhRVwvxX
        dv0lVkew==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YG-0003mI-Nl; Tue, 01 Sep 2020 15:50:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/15] xfs: fold xfs_buf_ioend_finish into xfs_ioend
Date:   Tue,  1 Sep 2020 17:50:08 +0200
Message-Id: <20200901155018.2524-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need to keep a separate helper for this logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c         | 8 +++++---
 fs/xfs/xfs_buf.h         | 7 -------
 fs/xfs/xfs_log_recover.c | 1 -
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 16a325d6e21f82..19a49969431b8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1333,7 +1333,6 @@ xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
-		xfs_buf_ioend_finish(bp);
 	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
 		/*
 		 * If this is a log recovery buffer, we aren't doing
@@ -1381,9 +1380,12 @@ xfs_buf_ioend(
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
index 7d744df7076274..7e75c79dc31138 100644
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
2.28.0

