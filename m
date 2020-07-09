Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59F6C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9029D2077D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a4oBDm3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgGIPNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD979C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=x8VAJ1gNaxl41fNLeBi3ZJ8dSN83l8XgeuiWGLR+Rcc=; b=a4oBDm3Nmadz5J1e0JuUoiBHok
        qR/ir5z+vTVkcHDTr1nA+j+KkhXu2pvKbVBxD8hFBR5nfG9gjx+JNs4qbl1fIQotfKw13fscbXaMt
        64IirSVPQ9MnEVKATmKq5qeShsnaZY3CWZv/2qGdL2sUfW5j1AkONWnu5ZOMxvVbIlRGDgAdCZirJ
        LyyNjsWGCefQYOdMf3U48t72+L5amnvllsLfbKFBYs3JcqLz12bLOxGop4F4DQN4qKfr0kO1M99di
        HN2tVwxQLewEDCzA/lhhpDXuYHiuNStJdQDG+zihK3jznxIJ6+EiA3WkNp0QmEUpFVJK8dQJuPP1i
        8+gZzH6A==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYF5-00057c-LR
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] xfs: refactor xfs_buf_ioend
Date:   Thu,  9 Jul 2020 17:04:43 +0200
Message-Id: <20200709150453.109230-4-hch@lst.de>
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

Refactor the logic for the different I/O completions to prepare for
more code sharing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 41 +++++++++++++++++-----------------------
 fs/xfs/xfs_log_recover.c | 14 +++++++-------
 2 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1bce6457a9b943..7c22d63f43f754 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1199,33 +1199,26 @@ xfs_buf_ioend(
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
 		xfs_buf_ioend_finish(bp);
-		return;
-	}
-
-	if (!bp->b_error) {
-		bp->b_flags &= ~XBF_WRITE_FAIL;
-		bp->b_flags |= XBF_DONE;
-	}
-
-	/*
-	 * If this is a log recovery buffer, we aren't doing transactional IO
-	 * yet so we need to let it handle IO completions.
-	 */
-	if (bp->b_flags & _XBF_LOGRECOVERY) {
+	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
+		/*
+		 * If this is a log recovery buffer, we aren't doing
+		 * transactional I/O yet so we need to let the log recovery code
+		 * handle I/O completions:
+		 */
 		xlog_recover_iodone(bp);
-		return;
-	}
-
-	if (bp->b_flags & _XBF_INODES) {
-		xfs_buf_inode_iodone(bp);
-		return;
-	}
+	} else {
+		if (!bp->b_error) {
+			bp->b_flags &= ~XBF_WRITE_FAIL;
+			bp->b_flags |= XBF_DONE;
+		}
 
-	if (bp->b_flags & _XBF_DQUOTS) {
-		xfs_buf_dquot_iodone(bp);
-		return;
+		if (bp->b_flags & _XBF_INODES)
+			xfs_buf_inode_iodone(bp);
+		else if (bp->b_flags & _XBF_DQUOTS)
+			xfs_buf_dquot_iodone(bp);
+		else
+			xfs_buf_iodone(bp);
 	}
-	xfs_buf_iodone(bp);
 }
 
 static void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 52a65a74208ffe..cf6dabb98f2327 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -269,15 +269,15 @@ void
 xlog_recover_iodone(
 	struct xfs_buf	*bp)
 {
-	if (bp->b_error) {
+	if (!bp->b_error) {
+		bp->b_flags |= XBF_DONE;
+	} else if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
 		/*
-		 * We're not going to bother about retrying
-		 * this during recovery. One strike!
+		 * We're not going to bother about retrying this during
+		 * recovery. One strike!
 		 */
-		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-			xfs_buf_ioerror_alert(bp, __this_address);
-			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
-		}
+		xfs_buf_ioerror_alert(bp, __this_address);
+		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	}
 
 	/*
-- 
2.26.2

