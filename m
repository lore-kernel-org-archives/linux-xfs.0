Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4604BC433E7
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22FAD204EA
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TXLkqPAS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgH3GPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgH3GP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BEC061575
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=x4QM51j6t3VOMvnTA2bltq+1y1WSHrsXHfIMUJmhJLU=; b=TXLkqPASqHxTHk9QsFXPhD+WB1
        ZuG2UqU2tQdB3x9ij547BCTVlpxHzGEqdRJGXxQN/jRqNSgPB6VeNsjLxHxPB65sRzfxadLOjEvRl
        UbQRXQs7O+MRYVfEn+/e0oTrpjgIgxLxSuI/vHSX5B1xCNA1rpXLM9ykZbwl7IlLiIOF4sa6CbfrY
        Iligde8nAFOYs0k8wlCxlwXLtxLJZTCShcs7P9nwXJmfEEEbf0fWk6YWRqTxAyUnt8a4ojo4u2/aq
        dqrehYWJ0ezvY/lmKQlF/VkbgScrhgQDMyjQmxU7Isvo9hUGcrg+ZagW4h/HoINXZ6Dcns2EAU2N8
        54sTxF9w==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGch-0001zJ-RK; Sun, 30 Aug 2020 06:15:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/13] xfs: remove xlog_recover_iodone
Date:   Sun, 30 Aug 2020 08:15:11 +0200
Message-Id: <20200830061512.1148591-13-hch@lst.de>
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

The log recovery I/O completion handler does not substancially differ from
the normal one except for the fact that it:

 a) never retries failed writes
 b) can have log items that aren't on the AIL
 c) never has inode/dquot log items attached and thus don't need to
    handle them

Add conditionals for (a) and (b) to the ioend code, while (c) doesn't
need special handling anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 -
 fs/xfs/xfs_buf.c                | 20 ++++++++++++--------
 fs/xfs/xfs_buf_item.c           |  4 ++++
 fs/xfs/xfs_buf_item_recover.c   |  2 +-
 fs/xfs/xfs_log_recover.c        | 25 -------------------------
 5 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 641132d0e39ddd..3cca2bfe714cb2 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -121,7 +121,6 @@ struct xlog_recover {
 void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
 		const struct xfs_buf_ops *ops);
 bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
-void xlog_recover_iodone(struct xfs_buf *bp);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 24cc0c94b5b803..7f8abcbe98a447 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1243,6 +1243,15 @@ xfs_buf_ioend_handle_error(
 
 	xfs_buf_ioerror_alert_ratelimited(bp);
 
+	/*
+	 * We're not going to bother about retrying this during recovery.
+	 * One strike!
+	 */
+	if (bp->b_flags & _XBF_LOGRECOVERY) {
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		return false;
+	}
+
 	/*
 	 * Synchronous writes will have callers process the error.
 	 */
@@ -1312,13 +1321,6 @@ xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
-	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
-		/*
-		 * If this is a log recovery buffer, we aren't doing
-		 * transactional I/O yet so we need to let the log recovery code
-		 * handle I/O completions:
-		 */
-		xlog_recover_iodone(bp);
 	} else {
 		if (!bp->b_error) {
 			bp->b_flags &= ~XBF_WRITE_FAIL;
@@ -1345,9 +1347,11 @@ xfs_buf_ioend(
 			xfs_buf_inode_iodone(bp);
 		else if (bp->b_flags & _XBF_DQUOTS)
 			xfs_buf_dquot_iodone(bp);
+
 	}
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
+			 _XBF_LOGRECOVERY);
 
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5a7293d0719bb4..0356f2e340a10e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -966,8 +966,12 @@ xfs_buf_item_done(
 	 * xfs_trans_ail_delete() takes care of these.
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
+	 *
+	 * Note that log recovery writes might have buffer items that are not on
+	 * the AIL even when the file system is not shut down.
 	 */
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
+			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_relse(bp);
 }
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8f0457d67d779e..24c7a8d11e1a84 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -414,7 +414,7 @@ xlog_recover_validate_buf_type(
 	 *
 	 * Write verifiers update the metadata LSN from log items attached to
 	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
-	 * the verifier. We'll clean it up in our ->iodone() callback.
+	 * the verifier.
 	 */
 	if (bp->b_ops) {
 		struct xfs_buf_log_item	*bip;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7e75c79dc31138..5449cba657352c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -265,31 +265,6 @@ xlog_header_check_mount(
 	return 0;
 }
 
-void
-xlog_recover_iodone(
-	struct xfs_buf	*bp)
-{
-	if (!bp->b_error) {
-		bp->b_flags |= XBF_DONE;
-	} else if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		/*
-		 * We're not going to bother about retrying this during
-		 * recovery. One strike!
-		 */
-		xfs_buf_ioerror_alert(bp, __this_address);
-		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
-	}
-
-	/*
-	 * On v5 supers, a bli could be attached to update the metadata LSN.
-	 * Clean it up.
-	 */
-	if (bp->b_log_item)
-		xfs_buf_item_relse(bp);
-	ASSERT(bp->b_log_item == NULL);
-	bp->b_flags &= ~_XBF_LOGRECOVERY;
-}
-
 /*
  * This routine finds (to an approximation) the first block in the physical
  * log which contains the given cycle.  It uses a binary search algorithm.
-- 
2.28.0

