Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D7EC433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090B1206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OjDqokAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGIPNu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417D5C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=mPdG5KEeVXF86GDCvqiEyJwqO0BWUut0/iuKmcseJvg=; b=OjDqokAZT6UUPCiUA5yE/sLg/k
        khpT64ARY0UEsQN8JCpjBCdShFg3iiftmGUUvdQ9zqCYkmP2q5gqMJqPXQ065dwxc0+v7ua5+Rd6G
        h/ESbVfpWqjrRR/JzRFaWk6yRAO1bltmMz0/YPf/T3IZQKa7z9rI0D2oIhSlpgX5E9gsjUDD1R4n1
        flaKTLCeDn+1DGieAePEnj1x+RCb+vqPBytaihZkdlXLEp1rYN6XVjG/ipfTBy6TvOpeTjOLFBO1O
        /ELhTE+5y9ZK4zt++todK4P6ung/aHUBX/856Y+4y1fNaYRAQf7e9J1OUrWCTPrnC1DQwEufp3ts2
        Lb/a558Q==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFA-000589-LC
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] xfs: refactor xfs_buf_ioerror_fail_without_retry
Date:   Thu,  9 Jul 2020 17:04:46 +0200
Message-Id: <20200709150453.109230-7-hch@lst.de>
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

xfs_buf_ioerror_fail_without_retry is a somewhat weird function in
that it has two trivial checks that decide the return value, while
the rest implements a ratelimited warning.  Just lift the two checks
into the caller, and give the remainder a suitable name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e6a73e455caa1a..2f2ce3faab0826 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1172,36 +1172,19 @@ xfs_buf_wait_unpin(
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
@@ -1282,7 +1265,19 @@ xfs_buf_ioend_disposition(
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
2.26.2

