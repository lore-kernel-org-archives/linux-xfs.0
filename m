Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B357C433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017C520812
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgEVDuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:39 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:38571 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728097AbgEVDui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:38 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 46AF0105006
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002VF-DQ
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgHe-58
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/24] xfs: call xfs_buf_iodone directly
Date:   Fri, 22 May 2020 13:50:11 +1000
Message-Id: <20200522035029.3022405-7-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=i74C1LsiPU1DTqEVg3QA:9
        a=ADnFq09n_9BQNsJn:21 a=gI_DTO2PJJ1_aKjL:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All unmarked dirty buffers should be in the AIL and have log items
attached to them. Hence when they are written, we will run a
callback to remove the item from the AIL if appropriate. Now that
we've handled inode and dquot buffers, all remaining calls are to
xfs_buf_iodone() and so we can hard code this rather than use an
indirect call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c       | 24 +++++++++---------------
 fs/xfs/xfs_buf.h       |  6 +-----
 fs/xfs/xfs_buf_item.c  | 38 +++++++++-----------------------------
 fs/xfs/xfs_buf_item.h  |  2 +-
 fs/xfs/xfs_trans_buf.c |  9 +--------
 5 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b89685ce8519d..5fc83637f7aff 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -658,7 +658,6 @@ xfs_buf_find(
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		ASSERT(bp->b_iodone == NULL);
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 		bp->b_ops = NULL;
 	}
@@ -1194,10 +1193,13 @@ xfs_buf_ioend(
 	if (!bp->b_error && bp->b_io_error)
 		xfs_buf_ioerror(bp, bp->b_io_error);
 
-	/* Only validate buffers that were read without errors */
-	if (read && !bp->b_error && bp->b_ops) {
-		ASSERT(!bp->b_iodone);
-		bp->b_ops->verify_read(bp);
+	if (read) {
+		if (!bp->b_error && bp->b_ops)
+			bp->b_ops->verify_read(bp);
+		if (!bp->b_error)
+			bp->b_flags |= XBF_DONE;
+		xfs_buf_ioend_finish(bp);
+		return;
 	}
 
 	if (!bp->b_error) {
@@ -1205,9 +1207,6 @@ xfs_buf_ioend(
 		bp->b_flags |= XBF_DONE;
 	}
 
-	if (read)
-		goto out_finish;
-
 	/*
 	 * If this is a log recovery buffer, we aren't doing transactional IO
 	 * yet so we need to let it handle IO completions.
@@ -1229,13 +1228,8 @@ xfs_buf_ioend(
 		return;
 	}
 
-	if (bp->b_iodone) {
-		(*(bp->b_iodone))(bp);
-		return;
-	}
-
-out_finish:
-	xfs_buf_ioend_finish(bp);
+	/* dirty buffers always need to be removed from the AIL */
+	xfs_buf_dirty_iodone(bp);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c5fe4c48c9080..a127d56d5eff0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -18,6 +18,7 @@
 /*
  *	Base types
  */
+struct xfs_buf;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
@@ -103,10 +104,6 @@ typedef struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
 
-struct xfs_buf;
-typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
-
-
 #define XB_PAGES	2
 
 struct xfs_buf_map {
@@ -159,7 +156,6 @@ typedef struct xfs_buf {
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
-	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a42cdf9ccc47d..c2e7d14e35c66 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -460,7 +460,6 @@ xfs_buf_item_unpin(
 			xfs_buf_do_callbacks(bp);
 			bp->b_log_item = NULL;
 			list_del_init(&bp->b_li_list);
-			bp->b_iodone = NULL;
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
@@ -936,11 +935,7 @@ xfs_buf_item_free(
 }
 
 /*
- * This is called when the buf log item is no longer needed.  It should
- * free the buf log item associated with the given buffer and clear
- * the buffer's pointer to the buf log item.  If there are no more
- * items in the list, clear the b_iodone field of the buffer (see
- * xfs_buf_attach_iodone() below).
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
  */
 void
 xfs_buf_item_relse(
@@ -952,9 +947,6 @@ xfs_buf_item_relse(
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
-	if (list_empty(&bp->b_li_list))
-		bp->b_iodone = NULL;
-
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
 }
@@ -962,10 +954,7 @@ xfs_buf_item_relse(
 
 /*
  * Add the given log item with its callback to the list of callbacks
- * to be called when the buffer's I/O completes.  If it is not set
- * already, set the buffer's b_iodone() routine to be
- * xfs_buf_iodone_callbacks() and link the log item into the list of
- * items rooted at b_li_list.
+ * to be called when the buffer's I/O completes.
  */
 void
 xfs_buf_attach_iodone(
@@ -977,10 +966,6 @@ xfs_buf_attach_iodone(
 
 	lip->li_cb = cb;
 	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
-
-	ASSERT(bp->b_iodone == NULL ||
-	       bp->b_iodone == xfs_buf_iodone_callbacks);
-	bp->b_iodone = xfs_buf_iodone_callbacks;
 }
 
 /*
@@ -1096,7 +1081,6 @@ xfs_buf_iodone_callback_error(
 		goto out_stale;
 
 	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-	ASSERT(bp->b_iodone != NULL);
 
 	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
 
@@ -1182,28 +1166,24 @@ xfs_buf_run_callbacks(
 	xfs_buf_do_callbacks(bp);
 	bp->b_log_item = NULL;
 	list_del_init(&bp->b_li_list);
-	bp->b_iodone = NULL;
 }
 
 /*
- * This is the iodone() function for buffers which have had callbacks attached
- * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
- * callback list, mark the buffer as having no more callbacks and then push the
- * buffer through IO completion processing.
+ * Inode buffer iodone callback function.
  */
 void
-xfs_buf_iodone_callbacks(
+xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
-	xfs_buf_ioend(bp);
+	xfs_buf_ioend_finish(bp);
 }
 
 /*
- * Inode buffer iodone callback function.
+ * Dquot buffer iodone callback function.
  */
 void
-xfs_buf_inode_iodone(
+xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
@@ -1211,10 +1191,10 @@ xfs_buf_inode_iodone(
 }
 
 /*
- * Dquot buffer iodone callback function.
+ * Dirty buffer iodone callback function.
  */
 void
-xfs_buf_dquot_iodone(
+xfs_buf_dirty_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 27d13d29b5bbb..96f994ec90915 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -57,10 +57,10 @@ bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, struct xfs_log_item *),
 			      struct xfs_log_item *);
-void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
+void	xfs_buf_dirty_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 93d62cb864c15..69e0ebe94a915 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -465,23 +465,16 @@ xfs_trans_dirty_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(bp->b_iodone == NULL ||
-	       bp->b_iodone == xfs_buf_iodone_callbacks);
 
 	/*
 	 * Mark the buffer as needing to be written out eventually,
 	 * and set its iodone function to remove the buffer's buf log
 	 * item from the AIL and free it when the buffer is flushed
-	 * to disk.  See xfs_buf_attach_iodone() for more details
-	 * on li_cb and xfs_buf_iodone_callbacks().
-	 * If we end up aborting this transaction, we trap this buffer
-	 * inside the b_bdstrat callback so that this won't get written to
-	 * disk.
+	 * to disk.
 	 */
 	bp->b_flags |= XBF_DONE;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
 	/*
-- 
2.26.2.761.g0e0b3e54be

