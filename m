Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5803C54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F08D206D4
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bxK/UUdg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgD0Nwf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 09:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgD0Nwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 09:52:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB38BC0610D5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 06:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=cIzNKLvof+tXyXlqYnzPfAAH5T9OGxjcvvKRjPsb5VU=; b=bxK/UUdgiO4E9sS6kizxyU5dM6
        5KU9StCz1q1znfvvUwXlY3u5xCS0LSvQ4GOpnbZuMGTujTpX2oX0yY601gY0wUtdS1KLb8QaaFU6G
        l+RKGTga6XNGYKweuwD7K6XjDtswB30E/yck3cfTc++brxRBaBrC/nUHUfexyAyTM8p4JyW/DhOLT
        qzzowPSzcit1s9dYyFqP0ETmpbaExY5n2lsP6cajeGQP7z/qCxt0EI1n0bdZzhPtDeEF0vaHhK+or
        Tijcyoacl5nW6hIgno6hGvrB6VqdAEPxDkwg7n3DgZdGRfE5IIeUOzGNmecYe0rMSCiYIvtzB7zT3
        l5vb0KoA==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT4BW-0003vp-AY
        for linux-xfs@vger.kernel.org; Mon, 27 Apr 2020 13:52:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: refactor the buffer cancellation table helpers
Date:   Mon, 27 Apr 2020 15:52:28 +0200
Message-Id: <20200427135229.1480993-2-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427135229.1480993-1-hch@lst.de>
References: <20200427135229.1480993-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the somewhat convoluted use of xlog_peek_buffer_cancelled and
xlog_check_buffer_cancelled with two obvious helpers:

 xlog_is_buffer_cancelled, which returns true if there is a buffer in
 the cancellation table, and
 xlog_put_buffer_cancelled, which also decrements the reference count
 of the buffer cancellation table.

Both share a little helper to look up the entry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 109 ++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11c3502b07b13..750a81b941ea4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1972,26 +1972,17 @@ xlog_recover_buffer_pass1(
 	return 0;
 }
 
-/*
- * Check to see whether the buffer being recovered has a corresponding
- * entry in the buffer cancel record table. If it is, return the cancel
- * buffer structure to the caller.
- */
-STATIC struct xfs_buf_cancel *
-xlog_peek_buffer_cancelled(
+static struct xfs_buf_cancel *
+xlog_find_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
-	uint			len,
-	unsigned short			flags)
+	uint			len)
 {
 	struct list_head	*bucket;
 	struct xfs_buf_cancel	*bcp;
 
-	if (!log->l_buf_cancel_table) {
-		/* empty table means no cancelled buffers in the log */
-		ASSERT(!(flags & XFS_BLF_CANCEL));
+	if (!log->l_buf_cancel_table)
 		return NULL;
-	}
 
 	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
 	list_for_each_entry(bcp, bucket, bc_list) {
@@ -1999,50 +1990,48 @@ xlog_peek_buffer_cancelled(
 			return bcp;
 	}
 
-	/*
-	 * We didn't find a corresponding entry in the table, so return 0 so
-	 * that the buffer is NOT cancelled.
-	 */
-	ASSERT(!(flags & XFS_BLF_CANCEL));
 	return NULL;
 }
 
 /*
- * If the buffer is being cancelled then return 1 so that it will be cancelled,
- * otherwise return 0.  If the buffer is actually a buffer cancel item
- * (XFS_BLF_CANCEL is set), then decrement the refcount on the entry in the
- * table and remove it from the table if this is the last reference.
+ * Check if there is and entry for blkno, len in the buffer cancel record table.
+ */
+static bool
+xlog_is_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
+}
+
+/*
+ * Check if there is and entry for blkno, len in the buffer cancel record table,
+ * and decremented the reference count on it if there is one.
  *
- * We remove the cancel record from the table when we encounter its last
- * occurrence in the log so that if the same buffer is re-used again after its
- * last cancellation we actually replay the changes made at that point.
+ * Remove the cancel record once the refcount hits zero, so that if the same
+ * buffer is re-used again after its last cancellation we actually replay the
+ * changes made at that point.
  */
-STATIC int
-xlog_check_buffer_cancelled(
+static bool
+xlog_put_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
-	uint			len,
-	unsigned short			flags)
+	uint			len)
 {
 	struct xfs_buf_cancel	*bcp;
 
-	bcp = xlog_peek_buffer_cancelled(log, blkno, len, flags);
-	if (!bcp)
-		return 0;
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (!bcp) {
+		ASSERT(0);
+		return false;
+	}
 
-	/*
-	 * We've go a match, so return 1 so that the recovery of this buffer
-	 * is cancelled.  If this buffer is actually a buffer cancel log
-	 * item, then decrement the refcount on the one in the table and
-	 * remove it if this is the last reference.
-	 */
-	if (flags & XFS_BLF_CANCEL) {
-		if (--bcp->bc_refcount == 0) {
-			list_del(&bcp->bc_list);
-			kmem_free(bcp);
-		}
+	if (--bcp->bc_refcount == 0) {
+		list_del(&bcp->bc_list);
+		kmem_free(bcp);
 	}
-	return 1;
+	return true;
 }
 
 /*
@@ -2733,10 +2722,15 @@ xlog_recover_buffer_pass2(
 	 * In this pass we only want to recover all the buffers which have
 	 * not been cancelled and are not cancellation buffers themselves.
 	 */
-	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
-			buf_f->blf_len, buf_f->blf_flags)) {
-		trace_xfs_log_recover_buf_cancel(log, buf_f);
-		return 0;
+	if (buf_f->blf_flags & XFS_BLF_CANCEL) {
+		if (xlog_put_buffer_cancelled(log, buf_f->blf_blkno,
+				buf_f->blf_len))
+			goto cancelled;
+	} else {
+
+		if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno,
+				buf_f->blf_len))
+			goto cancelled;
 	}
 
 	trace_xfs_log_recover_buf_recover(log, buf_f);
@@ -2820,6 +2814,9 @@ xlog_recover_buffer_pass2(
 out_release:
 	xfs_buf_relse(bp);
 	return error;
+cancelled:
+	trace_xfs_log_recover_buf_cancel(log, buf_f);
+	return 0;
 }
 
 /*
@@ -2937,8 +2934,7 @@ xlog_recover_inode_pass2(
 	 * Inode buffers can be freed, look out for it,
 	 * and do not replay the inode.
 	 */
-	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
-					in_f->ilf_len, 0)) {
+	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
 		error = 0;
 		trace_xfs_log_recover_inode_cancel(log, in_f);
 		goto error;
@@ -3840,7 +3836,7 @@ xlog_recover_do_icreate_pass2(
 
 		daddr = XFS_AGB_TO_DADDR(mp, agno,
 				agbno + i * igeo->blocks_per_cluster);
-		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
+		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
 			cancel_count++;
 	}
 
@@ -3876,11 +3872,8 @@ xlog_recover_buffer_ra_pass2(
 	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
 	struct xfs_mount		*mp = log->l_mp;
 
-	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
-			buf_f->blf_len, buf_f->blf_flags)) {
+	if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno, buf_f->blf_len))
 		return;
-	}
-
 	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
 				buf_f->blf_len, NULL);
 }
@@ -3905,9 +3898,8 @@ xlog_recover_inode_ra_pass2(
 			return;
 	}
 
-	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
+	if (xlog_is_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len))
 		return;
-
 	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
 				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
 }
@@ -3943,9 +3935,8 @@ xlog_recover_dquot_ra_pass2(
 	ASSERT(dq_f->qlf_len == 1);
 
 	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
-	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
+	if (xlog_is_buffer_cancelled(log, dq_f->qlf_blkno, len))
 		return;
-
 	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
 			  &xfs_dquot_buf_ra_ops);
 }
-- 
2.26.1

