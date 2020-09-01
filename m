Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC62DC433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E54D206EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QjdrunMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbgIAPuz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbgIAPuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BFCC06125E
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hG2ywK6aHGgnYKipJ+qrdnDSaDEYS/qM+JdiZC1Y8E4=; b=QjdrunMaa14iXgv/STPW+Ch617
        lpVDkY2bzuyRPN7v44HqYcoGqs4Btfz+f8cm23Sd38RBQVbgp+KjMwQ0jZ4bdJ1NuaiTTjVKAab+r
        PplJcNYGP3OlPkq6dUylqwIIwXzYxyXJVLRA21YgSTSFy3OAjGYSA+bTI0IB8bbxWoIKdTYyDtwA/
        SoApLgPt/zdesbyq8pL509iwr4apkbjshW8SObNOhroaVs9AIWOLzlM8eva59yR8IxzDbFb46gj9I
        n2Zy5bA3Prvvrjv1eeXGnYOFa2yW541/fIv4B+qc7sZNbxcxtqJ+46+u/j01EHyVsnaazJ/51WG3G
        HRrLDiLA==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YI-0003mO-7F; Tue, 01 Sep 2020 15:50:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/15] xfs: refactor xfs_buf_ioerror_fail_without_retry
Date:   Tue,  1 Sep 2020 17:50:09 +0200
Message-Id: <20200901155018.2524-7-hch@lst.de>
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

xfs_buf_ioerror_fail_without_retry is a somewhat weird function in
that it has two trivial checks that decide the return value, while
the rest implements a ratelimited warning.  Just lift the two checks
into the caller, and give the remainder a suitable name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 19a49969431b8c..4e1adbb02737ec 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1170,36 +1170,19 @@ xfs_buf_wait_unpin(
 	set_current_state(TASK_RUNNING);
 }
 
-/*
- * Decide if we're going to retry the write after a failure, and prepare
- * the buffer for retrying the write.
- */
-static bool
-xfs_buf_ioerror_fail_without_retry(
+static void
+xfs_buf_ioerror_alert_ratelimited(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_mount;
 	static unsigned long	lasttime;
 	static struct xfs_buftarg *lasttarg;
 
-	/*
-	 * If we've already decided to shutdown the filesystem because of
-	 * I/O errors, there's no point in giving this a retry.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return true;
-
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
 		xfs_buf_ioerror_alert(bp, __this_address);
 	}
 	lasttarg = bp->b_target;
-
-	/* synchronous writes will have callers process the error */
-	if (!(bp->b_flags & XBF_ASYNC))
-		return true;
-	return false;
 }
 
 static bool
@@ -1280,7 +1263,19 @@ xfs_buf_ioend_disposition(
 	if (likely(!bp->b_error))
 		return XBF_IOEND_FINISH;
 
-	if (xfs_buf_ioerror_fail_without_retry(bp))
+	/*
+	 * If we've already decided to shutdown the filesystem because of I/O
+	 * errors, there's no point in giving this a retry.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out_stale;
+
+	xfs_buf_ioerror_alert_ratelimited(bp);
+
+	/*
+	 * Synchronous writes will have callers process the error.
+	 */
+	if (!(bp->b_flags & XBF_ASYNC))
 		goto out_stale;
 
 	trace_xfs_buf_iodone_async(bp, _RET_IP_);
-- 
2.28.0

