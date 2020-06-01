Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2308BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 067FE206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgFAVnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:00 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57990 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728766AbgFAVm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id F2FC8D596E9
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000WW-6I
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-00HU5M-Tw
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/30] xfs: make inode IO completion buffer centric
Date:   Tue,  2 Jun 2020 07:42:30 +1000
Message-Id: <20200601214251.4167140-10-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=SUfCrG0rDGvUTUl_RgwA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Having different io completion callbacks for different inode states
makes things complex. We can detect if the inode is stale via the
XFS_ISTALE flag in IO completion, so we don't need a special
callback just for this.

This means inodes only have a single iodone callback, and inode IO
completion is entirely buffer centric at this point. Hence we no
longer need to use a log item callback at all as we can just call
xfs_iflush_done() directly from the buffer completions and walk the
buffer log item list to complete the all inodes under IO.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c   | 35 ++++++++++++++++++----
 fs/xfs/xfs_inode.c      |  6 ++--
 fs/xfs/xfs_inode_item.c | 65 ++++++++++++++---------------------------
 fs/xfs/xfs_inode_item.h |  5 ++--
 4 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5b3cd5e90947c..a4e416af5c614 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -13,6 +13,8 @@
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
@@ -457,7 +459,8 @@ xfs_buf_item_unpin(
 		 * the AIL lock.
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_do_callbacks(bp);
+			lip->li_cb(bp, lip);
+			xfs_iflush_done(bp);
 			bp->b_log_item = NULL;
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
@@ -1141,8 +1144,8 @@ xfs_buf_iodone_callback_error(
 	return false;
 }
 
-static void
-xfs_buf_run_callbacks(
+static inline bool
+xfs_buf_had_callback_errors(
 	struct xfs_buf		*bp)
 {
 
@@ -1152,7 +1155,7 @@ xfs_buf_run_callbacks(
 	 * appropriate action.
 	 */
 	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
-		return;
+		return true;
 
 	/*
 	 * Successful IO or permanent error. Either way, we can clear the
@@ -1161,7 +1164,16 @@ xfs_buf_run_callbacks(
 	bp->b_last_error = 0;
 	bp->b_retries = 0;
 	bp->b_first_retry_time = 0;
+	return false;
+}
 
+static void
+xfs_buf_run_callbacks(
+	struct xfs_buf		*bp)
+{
+
+	if (xfs_buf_had_callback_errors(bp))
+		return;
 	xfs_buf_do_callbacks(bp);
 	bp->b_log_item = NULL;
 }
@@ -1173,7 +1185,20 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	xfs_buf_run_callbacks(bp);
+	struct xfs_buf_log_item *blip = bp->b_log_item;
+	struct xfs_log_item	*lip;
+
+	if (xfs_buf_had_callback_errors(bp))
+		return;
+
+	/* If there is a buf_log_item attached, run its callback */
+	if (blip) {
+		lip = &blip->bli_item;
+		lip->li_cb(bp, lip);
+		bp->b_log_item = NULL;
+	}
+
+	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d5dee57f914a9..1b4e8e0bb0cf0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2677,7 +2677,6 @@ xfs_ifree_cluster(
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (struct xfs_inode_log_item *)lip;
-				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
 							&iip->ili_flush_lsn,
 							&iip->ili_item.li_lsn);
@@ -2710,8 +2709,7 @@ xfs_ifree_cluster(
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
-			xfs_buf_attach_iodone(bp, xfs_istale_done,
-						  &iip->ili_item);
+			xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
 
 			if (ip != free_ip)
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3861,7 +3859,7 @@ xfs_iflush_int(
 	 * the flush lock.
 	 */
 	bp->b_flags |= _XBF_INODES;
-	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
+	xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6ef9cbcfc94a7..7049f2ae8d186 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -668,40 +668,34 @@ xfs_inode_item_destroy(
  */
 void
 xfs_iflush_done(
-	struct xfs_buf		*bp,
-	struct xfs_log_item	*lip)
+	struct xfs_buf		*bp)
 {
 	struct xfs_inode_log_item *iip;
-	struct xfs_log_item	*blip, *n;
-	struct xfs_ail		*ailp = lip->li_ailp;
+	struct xfs_log_item	*lip, *n;
+	struct xfs_ail		*ailp = bp->b_mount->m_ail;
 	int			need_ail = 0;
 	LIST_HEAD(tmp);
 
 	/*
-	 * Scan the buffer IO completions for other inodes being completed and
-	 * attach them to the current inode log item.
+	 * Pull the attached inodes from the buffer one at a time and take the
+	 * appropriate action on them.
 	 */
-
-	list_add_tail(&lip->li_bio_list, &tmp);
-
-	list_for_each_entry_safe(blip, n, &bp->b_li_list, li_bio_list) {
-		if (lip->li_cb != xfs_iflush_done)
+	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
+		iip = INODE_ITEM(lip);
+		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
+			list_del_init(&lip->li_bio_list);
+			xfs_iflush_abort(iip->ili_inode);
 			continue;
+		}
 
-		list_move_tail(&blip->li_bio_list, &tmp);
+		list_move_tail(&lip->li_bio_list, &tmp);
 
 		/* Do an unlocked check for needing the AIL lock. */
-		iip = INODE_ITEM(blip);
-		if (blip->li_lsn == iip->ili_flush_lsn ||
-		    test_bit(XFS_LI_FAILED, &blip->li_flags))
+		if (lip->li_lsn == iip->ili_flush_lsn ||
+		    test_bit(XFS_LI_FAILED, &lip->li_flags))
 			need_ail++;
 	}
-
-	/* make sure we capture the state of the initial inode. */
-	iip = INODE_ITEM(lip);
-	if (lip->li_lsn == iip->ili_flush_lsn ||
-	    test_bit(XFS_LI_FAILED, &lip->li_flags))
-		need_ail++;
+	ASSERT(list_empty(&bp->b_li_list));
 
 	/*
 	 * We only want to pull the item from the AIL if it is actually there
@@ -713,19 +707,13 @@ xfs_iflush_done(
 
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
-		list_for_each_entry(blip, &tmp, li_bio_list) {
-			if (blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
-				/*
-				 * xfs_ail_update_finish() only cares about the
-				 * lsn of the first tail item removed, any
-				 * others will be at the same or higher lsn so
-				 * we just ignore them.
-				 */
-				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
+		list_for_each_entry(lip, &tmp, li_bio_list) {
+			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
+				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
 				if (!tail_lsn && lsn)
 					tail_lsn = lsn;
 			} else {
-				xfs_clear_li_failed(blip);
+				xfs_clear_li_failed(lip);
 			}
 		}
 		xfs_ail_update_finish(ailp, tail_lsn);
@@ -736,9 +724,9 @@ xfs_iflush_done(
 	 * ili_last_fields bits now that we know that the data corresponding to
 	 * them is safely on disk.
 	 */
-	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
-		list_del_init(&blip->li_bio_list);
-		iip = INODE_ITEM(blip);
+	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
+		list_del_init(&lip->li_bio_list);
+		iip = INODE_ITEM(lip);
 
 		spin_lock(&iip->ili_lock);
 		iip->ili_last_fields = 0;
@@ -746,7 +734,6 @@ xfs_iflush_done(
 
 		xfs_ifunlock(iip->ili_inode);
 	}
-	list_del(&tmp);
 }
 
 /*
@@ -779,14 +766,6 @@ xfs_iflush_abort(
 	xfs_ifunlock(ip);
 }
 
-void
-xfs_istale_done(
-	struct xfs_buf		*bp,
-	struct xfs_log_item	*lip)
-{
-	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
-}
-
 /*
  * convert an xfs_inode_log_format struct from the old 32 bit version
  * (which can have different field alignments) to the native 64 bit version
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 44c47c08b0b59..1545fccad4eeb 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -36,15 +36,14 @@ struct xfs_inode_log_item {
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
 };
 
-static inline int xfs_inode_clean(xfs_inode_t *ip)
+static inline int xfs_inode_clean(struct xfs_inode *ip)
 {
 	return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);
 }
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
-extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
+extern void xfs_iflush_done(struct xfs_buf *);
 extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
-- 
2.26.2.761.g0e0b3e54be

