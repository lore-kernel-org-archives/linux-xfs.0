Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E42C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524702077D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m2UmESDZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGIPNv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D489C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=ZUyM6o9aU77S+vJJPinZV+tKi4AAmA3bOYVQDWy/kuM=; b=m2UmESDZbBWWoWlqywEcefDTGY
        WwuKifqCfx+igAs5E1XxCw9LU4hnybzGp8RAj+VTep52yT5jkLEGOuMv1YIOOW+KTQonAaeTMsG5L
        lhWIV/FrPhzt4OZ7AFu4GThHz2mfmTsrK0Cu2MJsHpu6jpChbMEZm8ac5cW0HtxfT5UdQmWv21dlo
        bszTRD1MTov7y0DYjYs/uHEcyBAW4MCpPOOOybxin4HuJXcHLtYU8lmApgKlbM1qFEvHT4Xy0P9/C
        ZVPUmyvm2m5NArXKh5NPbToLqs5ttRSZPuwx8yAUt0hqM8dlI9WrAMdg1mPtYmwdfDDEKtn9JScZZ
        4261JqcQ==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFB-00058E-Op
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] xfs: remove xfs_buf_ioerror_retry
Date:   Thu,  9 Jul 2020 17:04:47 +0200
Message-Id: <20200709150453.109230-8-hch@lst.de>
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

Merge xfs_buf_ioerror_retry into its only caller to make the resubmission
flow a little more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2f2ce3faab0826..e5592563dda6a1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1187,23 +1187,6 @@ xfs_buf_ioerror_alert_ratelimited(
 	lasttarg = bp->b_target;
 }
 
-static bool
-xfs_buf_ioerror_retry(
-	struct xfs_buf		*bp,
-	struct xfs_error_cfg	*cfg)
-{
-	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
-	    bp->b_last_error == bp->b_error)
-		return false;
-
-	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
-	bp->b_last_error = bp->b_error;
-	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
-	    !bp->b_first_retry_time)
-		bp->b_first_retry_time = jiffies;
-	return true;
-}
-
 /*
  * Account for this latest trip around the retry handler, and decide if
  * we've failed enough times to constitute a permanent failure.
@@ -1283,10 +1266,13 @@ xfs_buf_ioend_disposition(
 	trace_xfs_buf_iodone_async(bp, _RET_IP_);
 
 	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
-	if (xfs_buf_ioerror_retry(bp, cfg)) {
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_submit(bp);
-		return XBF_IOEND_DONE;
+	if (bp->b_last_error != bp->b_error ||
+	    !(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL))) {
+		bp->b_last_error = bp->b_error;
+		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+		    !bp->b_first_retry_time)
+			bp->b_first_retry_time = jiffies;
+		goto resubmit;
 	}
 
 	/*
@@ -1301,6 +1287,11 @@ xfs_buf_ioend_disposition(
 	/* Still considered a transient error. Caller will schedule retries. */
 	return XBF_IOEND_FAIL;
 
+resubmit:
+	xfs_buf_ioerror(bp, 0);
+	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
+	xfs_buf_submit(bp);
+	return XBF_IOEND_DONE;
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
-- 
2.26.2

