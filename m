Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0148AC3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE1692072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BAtswwhU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgCWNHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgCWNHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=647dI4BhCnNe+EY0o0Tq8IZvZCzQQ21CGoNJGN4yuXQ=; b=BAtswwhUnVFkatuZFxn/EZc6FY
        mt6dS1jQKU0PIAaXKpEChO920ZGZS6I+027AzIKWnLAS0NkjeQ6WBZTmwm51D7X5CFjL8Ixb0PXCI
        f8ophiLl34xujhAx62aNX9NtD0PkUekqdi2SO/0vkCqmBu3fb4L1UVYJdg64VbvDrfXA1OWG2Uf9v
        OzM2E8i+sFhi2iQpxhIoZAxwhxfxeflTXfYoFcbkTrrlYd4zX44KMW5JJxmpnKXi7yna465gBIBYy
        7VaS00wv7mn+FpdCgtQmXf+/X8QBIGalZd3qOJ/a32oKpnKBWSV850x21qEdHGIt6NgNo8r/axQea
        ExutVQ1g==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMnc-0005j6-Cx; Mon, 23 Mar 2020 13:07:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5/9] xfs: merge xlog_commit_record with xlog_write_done()
Date:   Mon, 23 Mar 2020 14:07:02 +0100
Message-Id: <20200323130706.300436-6-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323130706.300436-1-hch@lst.de>
References: <20200323130706.300436-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xlog_write_done() is just a thin wrapper around
xlog_commit_record(), so they can be merged together easily. Convert
all the xlog_commit_record() callers to use xlog_write_done() and
merge the implementations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c4ee4d95c658..e34aaa7d3da3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -24,13 +24,6 @@
 kmem_zone_t	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
-STATIC int
-xlog_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp);
-
 STATIC struct xlog *
 xlog_alloc_log(
 	struct xfs_mount	*mp,
@@ -478,22 +471,6 @@ xfs_log_reserve(
  *		marked as with WANT_SYNC.
  */
 
-/*
- * Write a commit record to the log to close off a running log write.
- */
-int
-xlog_write_done(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*lsn)
-{
-	if (XLOG_FORCED_SHUTDOWN(log))
-		return -EIO;
-
-	return xlog_commit_record(log, ticket, iclog, lsn);
-}
-
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -1463,20 +1440,17 @@ xlog_alloc_log(
 	return ERR_PTR(error);
 }	/* xlog_alloc_log */
 
-
 /*
  * Write out the commit record of a transaction associated with the given
- * ticket.  Return the lsn of the commit record.
+ * ticket to close off a running log write. Return the lsn of the commit record.
  */
-STATIC int
-xlog_commit_record(
+int
+xlog_write_done(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp)
+	xfs_lsn_t		*lsn)
 {
-	struct xfs_mount *mp = log->l_mp;
-	int	error;
 	struct xfs_log_iovec reg = {
 		.i_addr = NULL,
 		.i_len = 0,
@@ -1486,12 +1460,16 @@ xlog_commit_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	int	error;
 
 	ASSERT_ALWAYS(iclog);
-	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
-					XLOG_COMMIT_TRANS);
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
+
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
 	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
 }
 
-- 
2.25.1

