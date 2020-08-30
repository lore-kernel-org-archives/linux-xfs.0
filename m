Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C22C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 364D420757
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vjVjRva1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgH3GPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgH3GPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D9C061575
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ww2JewZ6Z/+0nwkN0l8Lax8sigJyMnuk6WlATsDrGcU=; b=vjVjRva15vZStoE8gLlJTMlZl2
        0wlIeL3pDTLzhdP6Q6L2d9P4sEQxUTQ4CPkdxEIByp/xQ1n4BydAhr/hKK5nUOl/4gXJA77jygSQg
        EXiiYI+BFe5Qwmfug5QwpcmkY+kPcSfv4q1ghnbk/R+lKLez+MguLkkeYqlPlg1n11eMXSnUBXo8X
        rKQIjIHu51Kwkc6TMMnYzWzpH3ql7A7VlVBATpsCgPWnmdDYJ8e86MamS/AbyLuVvw2kPOI1drEou
        mA8eYnxQwzIDqPA6O5/0AvrDW0o1Z5XUYAmkCtwjjsOw4vJii/NZES9Ctk2BGDX6/Pf/501XHQQMC
        SAG9P2jg==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcc-0001y2-T6; Sun, 30 Aug 2020 06:15:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/13] xfs: remove xfs_buf_ioerror_retry
Date:   Sun, 30 Aug 2020 08:15:06 +0200
Message-Id: <20200830061512.1148591-8-hch@lst.de>
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

Merge xfs_buf_ioerror_retry into its only caller to make the resubmission
flow a little easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e1adbb02737ec..0d4eb06826f5e7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1185,23 +1185,6 @@ xfs_buf_ioerror_alert_ratelimited(
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
@@ -1281,10 +1264,13 @@ xfs_buf_ioend_disposition(
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
@@ -1299,6 +1285,11 @@ xfs_buf_ioend_disposition(
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
2.28.0

