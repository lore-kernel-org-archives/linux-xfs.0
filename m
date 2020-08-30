Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74831C28B49
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52EED2087D
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nCT60mxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgH3GPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D8AC061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gwSg107NBqula7feC369Rx6S7PD7xsV/FT1cXO1oRHw=; b=nCT60mxYJpp22G/nK+lc6DZoYj
        b1Cri/ltZXT3bYdAoBJ5JoicJUqhjG5xzmQc1taJ/Q/apjgj5LfHnVjFWLbIrGLERfvEXHl9pgl7W
        8LkX7FA7XfA68Uo9der5Yw+am1s16HiCz2mEYlP3Mra0BrsFeVVkZXbxqOqYdvDUvQrL2b2z+7GF2
        ysTwBrErgygMyF6MQLOiKWrvMBts7SrUFpS6yieP6julpfmEN3qri+E6ljCGOj/k1YSz8SbOg/W3D
        KlO/Z7RSSZ1KBmsFo61KIpY9r4D+DFY+J3a4/fcBET50u3U4Hju9RzkVIb8Xu2QK4CJJKjLC3oE+q
        +Y9KOhgA==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcY-0001xL-VC; Sun, 30 Aug 2020 06:15:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/13] xfs: refactor xfs_buf_ioend
Date:   Sun, 30 Aug 2020 08:15:02 +0200
Message-Id: <20200830061512.1148591-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830061512.1148591-1-hch@lst.de>
References: <20200830061512.1148591-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the log recovery I/O completion handling entirely into the log
recovery code, and re-arrange the normal I/O completion handler flow
to prepare to lifting more logic into common code in the next commits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c         | 41 +++++++++++++++++-----------------------
 fs/xfs/xfs_log_recover.c | 14 +++++++-------
 2 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 03dd12a83b82a1..6447cf051e08c9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1197,33 +1197,26 @@ xfs_buf_ioend(
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
index e2ec91b2d0f46d..7d744df7076274 100644
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
2.28.0

