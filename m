Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37313C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0AC2064B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MdKUgK2X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgIAPux (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgIAPuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3821C061262
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DhXz/LIncd1hAxsZLT580maUYEqABL5l83uIKFTA+dk=; b=MdKUgK2XzmjZ/05AW3wsfp0Nz3
        dbEVhvHrOja/GBYMcTXoGcTvsScPBJFi8iqYt725CmEaMuO2+Jbl5rc2i60V6l9iAjBOR6UXCtIc/
        zXj4nteORIA8x4+tk5nDEKde4F1p4aoVK/l5jqqqJO/85hTvbiHWI/QTkhnM7DqWj9mjFTD1jdxMh
        5ej2miKMWkKn6aYbD1DyKKJ2qMOINdmbt5InPYwiEW+ryg907SgkEWcQW/P+TgNk6bfI9E6sLLJ4K
        Mko9EotsAlv/b3jbt7JFsWJluXG4qWGAl03S7NtZOCYe1akMByXx99HDIROtehsxXzrfVCK+Q5u10
        QSYXCg5w==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YM-0003mh-6P; Tue, 01 Sep 2020 15:50:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/15] xfs: simplify the xfs_buf_ioend_disposition calling convention
Date:   Tue,  1 Sep 2020 17:50:12 +0200
Message-Id: <20200901155018.2524-10-hch@lst.de>
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

Now that all the actual error handling is in a single place,
xfs_buf_ioend_disposition just needs to return true if took ownership of
the buffer, or false if not instead of the tristate.  Also move the
error check back in the caller to optimize for the fast path, and give
the function a better fitting name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 951d9c35b3170c..13435cce2699e4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1223,29 +1223,17 @@ xfs_buf_ioerror_permanent(
  * If we get repeated async write failures, then we take action according to the
  * error configuration we have been set up to use.
  *
- * Multi-state return value:
- *
- * XBF_IOEND_FINISH: run callback completions
- * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
- * XBF_IOEND_FAIL: transient error, run failure callback completions and then
- *    release the buffer
+ * Returns true if this function took care of error handling and the caller must
+ * not touch the buffer again.  Return false if the caller should proceed with
+ * normal I/O completion handling.
  */
-enum xfs_buf_ioend_disposition {
-	XBF_IOEND_FINISH,
-	XBF_IOEND_DONE,
-	XBF_IOEND_FAIL,
-};
-
-static enum xfs_buf_ioend_disposition
-xfs_buf_ioend_disposition(
+static bool
+xfs_buf_ioend_handle_error(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
 
-	if (likely(!bp->b_error))
-		return XBF_IOEND_FINISH;
-
 	/*
 	 * If we've already decided to shutdown the filesystem because of I/O
 	 * errors, there's no point in giving this a retry.
@@ -1291,18 +1279,18 @@ xfs_buf_ioend_disposition(
 		ASSERT(list_empty(&bp->b_li_list));
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
-	return XBF_IOEND_FAIL;
+	return true;
 
 resubmit:
 	xfs_buf_ioerror(bp, 0);
 	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 	xfs_buf_submit(bp);
-	return XBF_IOEND_DONE;
+	return true;
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return XBF_IOEND_FINISH;
+	return false;
 }
 
 static void
@@ -1340,14 +1328,8 @@ xfs_buf_ioend(
 			bp->b_flags |= XBF_DONE;
 		}
 
-		switch (xfs_buf_ioend_disposition(bp)) {
-		case XBF_IOEND_DONE:
-			return;
-		case XBF_IOEND_FAIL:
+		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
 			return;
-		default:
-			break;
-		}
 
 		/* clear the retry state */
 		bp->b_last_error = 0;
-- 
2.28.0

