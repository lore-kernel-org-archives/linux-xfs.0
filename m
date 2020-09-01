Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC320C2BC0E
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE282098B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JMGtro4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgIAPuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgIAPui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B3DC061245
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1GZzX7JPYYeMpYOfrAvDfZnmaLTnjZkFmmRblPnSFnU=; b=JMGtro4SARn9jSNCJNvvErXkOE
        Q5ZaJQamk5yBBZKEMhH0AFyR8eurzwjVmL5uNx0rmk3Koq5iVjQZ5zJxz9gt64fQX2yKgiHDvNQEM
        kmYC8Lfwn5zIbK2S3WpjFgQALdWyADdL3ItT2RhdOjobLiz4HnOMMVmaVYXcLIEN69uvwgZsZ/6IE
        vjRfUcURfAmgEPEFS7IwH705fCYEpIWVbpSfdrIAHOhwkVPzCshE65rq3j2JiD1x5NZ8UqQliJFhD
        D1UPlDtm8DSioKbpnxz3e4GGCBuOlYmETBIpo6hbbYoNy3hYRvhpYj1PjxKygosADSap6rsb/ERtE
        RCJej4Ew==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YO-0003mr-Sw; Tue, 01 Sep 2020 15:50:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/15] xfs: clear the read/write flags later in xfs_buf_ioend
Date:   Tue,  1 Sep 2020 17:50:14 +0200
Message-Id: <20200901155018.2524-12-hch@lst.de>
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

Clear the flags at the end of xfs_buf_ioend so that they can be used
during the completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 13435cce2699e4..24cc0c94b5b803 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1283,12 +1283,13 @@ xfs_buf_ioend_handle_error(
 
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
@@ -1297,12 +1298,8 @@ static void
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
@@ -1310,7 +1307,7 @@ xfs_buf_ioend(
 	if (!bp->b_error && bp->b_io_error)
 		xfs_buf_ioerror(bp, bp->b_io_error);
 
-	if (read) {
+	if (bp->b_flags & XBF_READ) {
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1350,6 +1347,8 @@ xfs_buf_ioend(
 			xfs_buf_dquot_iodone(bp);
 	}
 
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else
-- 
2.28.0

