Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AA2C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 08:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D53206B9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 08:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD1IFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:05:52 -0400
Received: from verein.lst.de ([213.95.11.211]:54803 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgD1IFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Apr 2020 04:05:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C5A2868CEC; Tue, 28 Apr 2020 10:05:50 +0200 (CEST)
Date:   Tue, 28 Apr 2020 10:05:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/2] xfs: refactor xlog_recover_buffer_pass1
Message-ID: <20200428080550.GA20138@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out a xlog_add_buffer_cancelled helper which does the low-level
manipulation of the buffer cancelation table, and in that helper call
xlog_find_buffer_cancelled instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 114 +++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fe4dad5b77a95..3bc61838266f1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1913,65 +1913,6 @@ xlog_recover_reorder_trans(
 	return error;
 }
 
-/*
- * Build up the table of buf cancel records so that we don't replay
- * cancelled data in the second pass.  For buffer records that are
- * not cancel records, there is nothing to do here so we just return.
- *
- * If we get a cancel record which is already in the table, this indicates
- * that the buffer was cancelled multiple times.  In order to ensure
- * that during pass 2 we keep the record in the table until we reach its
- * last occurrence in the log, we keep a reference count in the cancel
- * record in the table to tell us how many times we expect to see this
- * record during the second pass.
- */
-STATIC int
-xlog_recover_buffer_pass1(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
-	struct list_head	*bucket;
-	struct xfs_buf_cancel	*bcp;
-
-	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
-		xfs_err(log->l_mp, "bad buffer log item size (%d)",
-				item->ri_buf[0].i_len);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * If this isn't a cancel buffer item, then just return.
-	 */
-	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
-		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
-		return 0;
-	}
-
-	/*
-	 * Insert an xfs_buf_cancel record into the hash table of them.
-	 * If there is already an identical record, bump its reference count.
-	 */
-	bucket = XLOG_BUF_CANCEL_BUCKET(log, buf_f->blf_blkno);
-	list_for_each_entry(bcp, bucket, bc_list) {
-		if (bcp->bc_blkno == buf_f->blf_blkno &&
-		    bcp->bc_len == buf_f->blf_len) {
-			bcp->bc_refcount++;
-			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
-			return 0;
-		}
-	}
-
-	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
-	bcp->bc_blkno = buf_f->blf_blkno;
-	bcp->bc_len = buf_f->blf_len;
-	bcp->bc_refcount = 1;
-	list_add_tail(&bcp->bc_list, bucket);
-
-	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
-	return 0;
-}
-
 static struct xfs_buf_cancel *
 xlog_find_buffer_cancelled(
 	struct xlog		*log,
@@ -1993,6 +1934,35 @@ xlog_find_buffer_cancelled(
 	return NULL;
 }
 
+static bool
+xlog_add_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	/*
+	 * If we find an existing cancel record, this indicates that the buffer
+	 * was cancelled multiple times.  To ensure that during pass 2 we keep
+	 * the record in the table until we reach its last occurrence in the
+	 * log, a reference count is kept to tell how many times we expect to
+	 * see this record during the second pass.
+	 */
+	bcp = xlog_find_buffer_cancelled(log, blkno, len);
+	if (bcp) {
+		bcp->bc_refcount++;
+		return false;
+	}
+
+	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
+	bcp->bc_blkno = blkno;
+	bcp->bc_len = len;
+	bcp->bc_refcount = 1;
+	list_add_tail(&bcp->bc_list, XLOG_BUF_CANCEL_BUCKET(log, blkno));
+	return true;
+}
+
 /*
  * Check if there is and entry for blkno, len in the buffer cancel record table.
  */
@@ -2045,6 +2015,32 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
+/*
+ * Build up the table of buf cancel records so that we don't replay cancelled
+ * data in the second pass.
+ */
+static int
+xlog_recover_buffer_pass1(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
+
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+		xfs_err(log->l_mp, "bad buffer log item size (%d)",
+				item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (!(bf->blf_flags & XFS_BLF_CANCEL))
+		trace_xfs_log_recover_buf_not_cancel(log, bf);
+	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
+		trace_xfs_log_recover_buf_cancel_add(log, bf);
+	else
+		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);
+	return 0;
+}
+
 /*
  * Perform recovery for a buffer full of inodes.  In these buffers, the only
  * data which should be recovered is that which corresponds to the
-- 
2.26.1

