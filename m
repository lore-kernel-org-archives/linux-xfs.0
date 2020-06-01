Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E1EC433E8
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D90D6206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgFAVnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:08 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55680 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728817AbgFAVnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:43:01 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C66C91A80E0
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:56 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000Wc-9E
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU5W-0H
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/30] xfs: clean up the buffer iodone callback functions
Date:   Tue,  2 Jun 2020 07:42:32 +1000
Message-Id: <20200601214251.4167140-12-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=QrwaDmlbODsJXtoaXeEA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we've sorted inode and dquot buffers, we can apply the same
cleanups to dirty buffers with buffer log items. They only have one
callback, too, so we don't need the log item callback. Collapse the
iodone functions and remove all the now unnecessary infrastructure
around callback processing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c  | 140 +++++++++--------------------------------
 fs/xfs/xfs_buf_item.h  |   1 -
 fs/xfs/xfs_trans_buf.c |   2 -
 3 files changed, 29 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f46e5ec28111c..0ece5de9dd711 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -30,7 +30,7 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
+static void xfs_buf_item_done(struct xfs_buf *bp);
 
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
@@ -462,9 +462,8 @@ xfs_buf_item_unpin(
 		 * the AIL lock.
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			lip->li_cb(bp, lip);
+			xfs_buf_item_done(bp);
 			xfs_iflush_done(bp);
-			bp->b_log_item = NULL;
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
@@ -973,46 +972,6 @@ xfs_buf_attach_iodone(
 	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 }
 
-/*
- * We can have many callbacks on a buffer. Running the callbacks individually
- * can cause a lot of contention on the AIL lock, so we allow for a single
- * callback to be able to scan the remaining items in bp->b_li_list for other
- * items of the same type and callback to be processed in the first call.
- *
- * As a result, the loop walking the callback list below will also modify the
- * list. it removes the first item from the list and then runs the callback.
- * The loop then restarts from the new first item int the list. This allows the
- * callback to scan and modify the list attached to the buffer and we don't
- * have to care about maintaining a next item pointer.
- */
-STATIC void
-xfs_buf_do_callbacks(
-	struct xfs_buf		*bp)
-{
-	struct xfs_buf_log_item *blip = bp->b_log_item;
-	struct xfs_log_item	*lip;
-
-	/* If there is a buf_log_item attached, run its callback */
-	if (blip) {
-		lip = &blip->bli_item;
-		lip->li_cb(bp, lip);
-	}
-
-	while (!list_empty(&bp->b_li_list)) {
-		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
-				       li_bio_list);
-
-		/*
-		 * Remove the item from the list, so we don't have any
-		 * confusion if the item is added to another buf.
-		 * Don't touch the log item after calling its
-		 * callback, because it could have freed itself.
-		 */
-		list_del_init(&lip->li_bio_list);
-		lip->li_cb(bp, lip);
-	}
-}
-
 /*
  * Invoke the error state callback for each log item affected by the failed I/O.
  *
@@ -1025,8 +984,8 @@ STATIC void
 xfs_buf_do_callbacks_fail(
 	struct xfs_buf		*bp)
 {
+	struct xfs_ail		*ailp = bp->b_mount->m_ail;
 	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp;
 
 	/*
 	 * Buffer log item errors are handled directly by xfs_buf_item_push()
@@ -1036,9 +995,6 @@ xfs_buf_do_callbacks_fail(
 	if (list_empty(&bp->b_li_list))
 		return;
 
-	lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
-			li_bio_list);
-	ailp = lip->li_ailp;
 	spin_lock(&ailp->ail_lock);
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 		if (lip->li_ops->iop_error)
@@ -1051,22 +1007,11 @@ static bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	struct xfs_log_item	*lip;
-	struct xfs_mount	*mp;
+	struct xfs_mount	*mp = bp->b_mount;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
 	struct xfs_error_cfg	*cfg;
 
-	/*
-	 * The failed buffer might not have a buf_log_item attached or the
-	 * log_item list might be empty. Get the mp from the available
-	 * xfs_log_item
-	 */
-	lip = list_first_entry_or_null(&bp->b_li_list, struct xfs_log_item,
-				       li_bio_list);
-	mp = lip ? lip->li_mountp : bip->bli_item.li_mountp;
-
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
@@ -1171,14 +1116,27 @@ xfs_buf_had_callback_errors(
 }
 
 static void
-xfs_buf_run_callbacks(
+xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (xfs_buf_had_callback_errors(bp))
+	if (!bip)
 		return;
-	xfs_buf_do_callbacks(bp);
+
+	/*
+	 * If we are forcibly shutting down, this may well be off the AIL
+	 * already. That's because we simulate the log-committed callbacks to
+	 * unpin these buffers. Or we may never have put this item on AIL
+	 * because of the transaction was aborted forcibly.
+	 * xfs_trans_ail_delete() takes care of these.
+	 *
+	 * Either way, AIL is useless if we're forcing a shutdown.
+	 */
+	xfs_trans_ail_delete(&bip->bli_item, SHUTDOWN_CORRUPT_INCORE);
 	bp->b_log_item = NULL;
+	xfs_buf_item_free(bip);
+	xfs_buf_rele(bp);
 }
 
 /*
@@ -1188,19 +1146,10 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item *blip = bp->b_log_item;
-	struct xfs_log_item	*lip;
-
 	if (xfs_buf_had_callback_errors(bp))
 		return;
 
-	/* If there is a buf_log_item attached, run its callback */
-	if (blip) {
-		lip = &blip->bli_item;
-		lip->li_cb(bp, lip);
-		bp->b_log_item = NULL;
-	}
-
+	xfs_buf_item_done(bp);
 	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
@@ -1212,59 +1161,28 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item *blip = bp->b_log_item;
-	struct xfs_log_item	*lip;
-
 	if (xfs_buf_had_callback_errors(bp))
 		return;
 
 	/* a newly allocated dquot buffer might have a log item attached */
-	if (blip) {
-		lip = &blip->bli_item;
-		lip->li_cb(bp, lip);
-		bp->b_log_item = NULL;
-	}
-
+	xfs_buf_item_done(bp);
 	xfs_dquot_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
 
 /*
  * Dirty buffer iodone callback function.
+ *
+ * Note that for things like remote attribute buffers, there may not be a buffer
+ * log item here, so processing the buffer log item must remain be optional.
  */
 void
 xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
-	xfs_buf_run_callbacks(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
-/*
- * This is the iodone() function for buffers which have been
- * logged.  It is called when they are eventually flushed out.
- * It should remove the buf item from the AIL, and free the buf item.
- * It is called by xfs_buf_iodone_callbacks() above which will take
- * care of cleaning up the buffer itself.
- */
-void
-xfs_buf_item_iodone(
-	struct xfs_buf		*bp,
-	struct xfs_log_item	*lip)
-{
-	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
-
-	xfs_buf_rele(bp);
+	if (xfs_buf_had_callback_errors(bp))
+		return;
 
-	/*
-	 * If we are forcibly shutting down, this may well be off the AIL
-	 * already. That's because we simulate the log-committed callbacks to
-	 * unpin these buffers. Or we may never have put this item on AIL
-	 * because of the transaction was aborted forcibly.
-	 * xfs_trans_ail_delete() takes care of these.
-	 *
-	 * Either way, AIL is useless if we're forcing a shutdown.
-	 */
-	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_free(BUF_ITEM(lip));
+	xfs_buf_item_done(bp);
+	xfs_buf_ioend_finish(bp);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 610cd00193289..7c0bd2a210aff 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -57,7 +57,6 @@ bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, struct xfs_log_item *),
 			      struct xfs_log_item *);
-void	xfs_buf_item_iodone(struct xfs_buf *, struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6752676b94fe7..11cd666cd99a6 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -475,7 +475,6 @@ xfs_trans_dirty_buf(
 	bp->b_flags |= XBF_DONE;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	bip->bli_item.li_cb = xfs_buf_item_iodone;
 
 	/*
 	 * If we invalidated the buffer within this transaction, then
@@ -644,7 +643,6 @@ xfs_trans_stale_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
-	bip->bli_item.li_cb = xfs_buf_item_iodone;
 	bp->b_flags |= _XBF_INODES;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
-- 
2.26.2.761.g0e0b3e54be

