Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E151C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79FD22077D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cwx/Wrh5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGIPNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABD8C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=URV6uRDymuh8l/76dmUwEqCJPZpuEa+zKq2jFipiEwo=; b=Cwx/Wrh5VftUbLU5ZNct4LrdXP
        Xv9kCceYlKthBwdwVB3QCgsC9d2jwosEkAd18LPvxxy5Vz5GpP6j9rcIfyo2G894qhus2CceevJpY
        TQT4bPrJrcCMv9BZgW+sMowpGRv6pByvUFIQOd2ZEfSzhF49A+a0DU7J4nRvlhpEkKqszbXtu+uKp
        jgTqA31dQCRU6ar5PHPAA2RzfVZdlDRH0KmxnMtb88KF6OcHZIUlVaKFsP+iD2RXA3sAs111NvPcN
        Vq/zySBOqq8tjoEe8GClHdgKYcEabNSv8hwqFa+Hn6ZRuFT6o+D06z0Ytsw2MxHFTd/cF8DYiYAUA
        gymdEL5A==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFE-00058i-5C
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs: simplify the xfs_buf_ioend_disposition calling convention
Date:   Thu,  9 Jul 2020 17:04:49 +0200
Message-Id: <20200709150453.109230-10-hch@lst.de>
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

Now that all the actual error handling is in a single place,
xfs_buf_ioend_disposition just needs to return true if took ownership of
the buffer, or false if not instead of the tristate.  Also move the
error check back in the caller to optimize for the fast path, and give
the function a better fitting name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e3e80615c5ed9e..4a9034a9175504 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1224,30 +1224,14 @@ xfs_buf_ioerror_permanent(
  *
  * If we get repeated async write failures, then we take action according to the
  * error configuration we have been set up to use.
- *
- * Multi-state return value:
- *
- * XBF_IOEND_FINISH: run callback completions
- * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
- * XBF_IOEND_FAIL: transient error, run failure callback completions and then
- *    release the buffer
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
@@ -1293,18 +1277,18 @@ xfs_buf_ioend_disposition(
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
@@ -1342,14 +1326,8 @@ xfs_buf_ioend(
 			bp->b_flags |= XBF_DONE;
 		}
 
-		switch (xfs_buf_ioend_disposition(bp)) {
-		case XBF_IOEND_DONE:
+		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
 			return;
-		case XBF_IOEND_FAIL:
-			return;
-		default:
-			break;
-		}
 
 		/* clear the retry state */
 		bp->b_last_error = 0;
-- 
2.26.2

