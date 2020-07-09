Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0C1C433E1
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8D1206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aLFzyQqs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGIPN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D50C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=LilcVFtLhwdHH/+YMvU0t0F2vRMI3sH7I2pl5xfOtMM=; b=aLFzyQqsKGYAq3eLcvSREzaxBr
        ENgUkTVWk4xtr1KmdLI+Ga+sgyA924ltbuDuqgt8JfH5P9EX1uXbSDewBnggTS8UFAjf7FKoWU5ZW
        seyC528RVSR+WDEcnrkIeIBuV8WIfXbTFcXLCuvlWxHTv43Daxexm5S4RFBORTkuBUNfsZDgScVKm
        OqOJ2xG2ncSWVdSC7COUFEVpRIgQ5lkKyvDChJLCpybwmMR77dY3NZ3I3a0bVohFB9CXZYpc3L48b
        JV1zlNR0n+/icgrJZn8XZY+miHjJ/9FP5SFee1dSDmX/qZbCcNYnWPqRLcnPfKN6MDWcFBWtq99nK
        1avPtjiA==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFG-00059C-N6
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] xfs: clear the read/write flags later in xfs_buf_ioend
Date:   Thu,  9 Jul 2020 17:04:51 +0200
Message-Id: <20200709150453.109230-12-hch@lst.de>
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

Clear the flags at the end of xfs_buf_ioend so that they can be used
during the completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4a9034a9175504..8bbd28f39a927b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1281,12 +1281,13 @@ xfs_buf_ioend_handle_error(
 
 resubmit:
 	xfs_buf_ioerror(bp, 0);
-	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
+	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
 	xfs_buf_submit(bp);
 	return true;
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
+	bp->b_flags &= ~XBF_WRITE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
 	return false;
 }
@@ -1295,12 +1296,8 @@ static void
 xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
-	bool		read = bp->b_flags & XBF_READ;
-
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-
 	/*
 	 * Pull in IO completion errors now. We are guaranteed to be running
 	 * single threaded, so we don't need the lock to read b_io_error.
@@ -1308,7 +1305,7 @@ xfs_buf_ioend(
 	if (!bp->b_error && bp->b_io_error)
 		xfs_buf_ioerror(bp, bp->b_io_error);
 
-	if (read) {
+	if (bp->b_flags & XBF_READ) {
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1348,6 +1345,8 @@ xfs_buf_ioend(
 			xfs_buf_dquot_iodone(bp);
 	}
 
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else
-- 
2.26.2

