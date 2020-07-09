Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59032C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AECD206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="haiovo+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGIPJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIPJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:09:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8DBC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=7o2UulIjTaQVseT8vnbo1iDMZH3sTe49MkopTXsYar8=; b=haiovo+oXDm1+xQWcwFQrxilvu
        2cWVYBuCT/pE70mO7yLOORT8JacvBR/U362C+jROUT3yWaSlQt9e5t2bDD5w2oTqf6rxHtc1Emw0I
        xDadmK6lzlqLegmxAiasUTYUbePOpIxYAVO2NSzq3nrini59RBCG1HHqzOcK5vaWE12cEXqEFECfg
        ryXAGIpyXETghBjFy/ZafM298Jf96a9RiC7Qredr/jlYcjwGVKHWwLCpa98VeSjqOMh21lLwBNbSo
        ptAscEfoq8IOl1bdHtDiiGLP4uLIfy8da+qclFg0nGAsZX4wPXElPEJzTEGtvRHdkSegcBJbzLGcF
        EN0fLCsg==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYAn-0004vT-O7
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:09:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] xfs: refactor the buf ioend disposition code
Date:   Thu,  9 Jul 2020 17:04:41 +0200
Message-Id: <20200709150453.109230-2-hch@lst.de>
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

Handle the no-error case in xfs_buf_iodone_error as well, and to clarify
the code rename the function, use the actual enum type as return value
and then switch on it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 115 +++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e9428c30862a98..19896884189973 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1046,24 +1046,27 @@ xfs_buf_ioerror_permanent(
  *
  * Multi-state return value:
  *
- * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
- * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
- * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
+ * XBF_IOEND_FINISH: run callback completions
+ * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
+ * XBF_IOEND_FAIL: transient error, run failure callback completions and then
  *    release the buffer
  */
-enum {
-	XBF_IOERROR_FINISH,
-	XBF_IOERROR_DONE,
-	XBF_IOERROR_FAIL,
+enum xfs_buf_ioend_disposition {
+	XBF_IOEND_FINISH,
+	XBF_IOEND_DONE,
+	XBF_IOEND_FAIL,
 };
 
-static int
-xfs_buf_iodone_error(
+static enum xfs_buf_ioend_disposition
+xfs_buf_ioend_disposition(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
 
+	if (likely(!bp->b_error))
+		return XBF_IOEND_FINISH;
+
 	if (xfs_buf_ioerror_fail_without_retry(bp))
 		goto out_stale;
 
@@ -1073,7 +1076,7 @@ xfs_buf_iodone_error(
 	if (xfs_buf_ioerror_retry(bp, cfg)) {
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
-		return XBF_IOERROR_DONE;
+		return XBF_IOEND_DONE;
 	}
 
 	/*
@@ -1086,13 +1089,13 @@ xfs_buf_iodone_error(
 	}
 
 	/* Still considered a transient error. Caller will schedule retries. */
-	return XBF_IOERROR_FAIL;
+	return XBF_IOEND_FAIL;
 
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return XBF_IOERROR_FINISH;
+	return XBF_IOEND_FINISH;
 }
 
 static void
@@ -1128,6 +1131,19 @@ xfs_buf_clear_ioerror_retry_state(
 	bp->b_first_retry_time = 0;
 }
 
+static void
+xfs_buf_inode_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
+
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
+}
+
 /*
  * Inode buffer iodone callback function.
  */
@@ -1135,30 +1151,36 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		struct xfs_log_item *lip;
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
-		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			set_bit(XFS_LI_FAILED, &lip->li_flags);
-		}
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_relse(bp);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
+		xfs_buf_inode_io_fail(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
 
+static void
+xfs_buf_dquot_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	spin_lock(&bp->b_mount->m_ail->ail_lock);
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		xfs_set_li_failed(lip, bp);
+	spin_unlock(&bp->b_mount->m_ail->ail_lock);
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
+}
+
 /*
  * Dquot buffer iodone callback function.
  */
@@ -1166,26 +1188,16 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		struct xfs_log_item *lip;
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
-		spin_lock(&bp->b_mount->m_ail->ail_lock);
-		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			xfs_set_li_failed(lip, bp);
-		}
-		spin_unlock(&bp->b_mount->m_ail->ail_lock);
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_relse(bp);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
+		xfs_buf_dquot_io_fail(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	/* a newly allocated dquot buffer might have a log item attached */
 	xfs_buf_item_done(bp);
@@ -1203,21 +1215,18 @@ void
 xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
 		ASSERT(list_empty(&bp->b_li_list));
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_relse(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_buf_ioend_finish(bp);
-- 
2.26.2

