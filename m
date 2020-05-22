Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B00C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8378B20812
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgEVDuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:40 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38991 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbgEVDuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:40 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 30FBE82082F
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:33 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyhb-0002W5-62
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgJ1-TU
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/24] xfs: factor xfs_iflush_done
Date:   Fri, 22 May 2020 13:50:28 +1000
Message-Id: <20200522035029.3022405-24-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=5dYq1025zWcnlPueRbEA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_iflush_done() does 3 distinct operations to the inodes attached
to the buffer. Separate these operations out into functions so that
it is easier to modify these operations independently in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 156 +++++++++++++++++++++-------------------
 1 file changed, 82 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index af4764f97a339..4dd4f45dcc46e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -662,104 +662,67 @@ xfs_inode_item_destroy(
 
 
 /*
- * This is the inode flushing I/O completion routine.  It is called
- * from interrupt level when the buffer containing the inode is
- * flushed to disk.  It is responsible for removing the inode item
- * from the AIL if it has not been re-logged, and unlocking the inode's
- * flush lock.
- *
- * To reduce AIL lock traffic as much as possible, we scan the buffer log item
- * list for other inodes that will run this function. We remove them from the
- * buffer list so we can process all the inode IO completions in one AIL lock
- * traversal.
- *
- * Note: Now that we attach the log item to the buffer when we first log the
- * inode in memory, we can have unflushed inodes on the buffer list here. These
- * inodes will have a zero ili_last_fields, so skip over them here.
+ * We only want to pull the item from the AIL if it is actually there
+ * and its location in the log has not changed since we started the
+ * flush.  Thus, we only bother if the inode's lsn has not changed.
  */
 void
-xfs_iflush_done(
-	struct xfs_buf		*bp)
+xfs_iflush_ail_updates(
+	struct xfs_ail		*ailp,
+	struct list_head	*list)
 {
-	struct xfs_inode_log_item *iip;
-	struct xfs_log_item	*lip, *n;
-	struct xfs_ail		*ailp = bp->b_mount->m_ail;
-	int			need_ail = 0;
-	LIST_HEAD(tmp);
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		tail_lsn = 0;
 
-	/*
-	 * Pull the attached inodes from the buffer one at a time and take the
-	 * appropriate action on them.
-	 */
-	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
-		iip = INODE_ITEM(lip);
-		if (!iip->ili_last_fields)
-			continue;
+	/* this is an opencoded batch version of xfs_trans_ail_delete */
+	spin_lock(&ailp->ail_lock);
+	list_for_each_entry(lip, list, li_bio_list) {
+		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+		xfs_lsn_t	lsn;
 
-		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
-			xfs_iflush_abort(iip->ili_inode);
+		if (iip->ili_flush_lsn != lip->li_lsn) {
+			xfs_clear_li_failed(lip);
 			continue;
 		}
 
-		list_move_tail(&lip->li_bio_list, &tmp);
-
-		/* Do an unlocked check for needing the AIL lock. */
-		if (iip->ili_flush_lsn == lip->li_lsn ||
-		    test_bit(XFS_LI_FAILED, &lip->li_flags))
-			need_ail++;
+		lsn = xfs_ail_delete_one(ailp, lip);
+		if (!tail_lsn && lsn)
+			tail_lsn = lsn;
 	}
+	xfs_ail_update_finish(ailp, tail_lsn);
+}
 
-	/*
-	 * We only want to pull the item from the AIL if it is actually there
-	 * and its location in the log has not changed since we started the
-	 * flush.  Thus, we only bother if the inode's lsn has not changed.
-	 */
-	if (need_ail) {
-		xfs_lsn_t	tail_lsn = 0;
-
-		/* this is an opencoded batch version of xfs_trans_ail_delete */
-		spin_lock(&ailp->ail_lock);
-		list_for_each_entry(lip, &tmp, li_bio_list) {
-			iip = INODE_ITEM(lip);
-			if (iip->ili_flush_lsn == lip->li_lsn) {
-				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
-				if (!tail_lsn && lsn)
-					tail_lsn = lsn;
-			} else {
-				xfs_clear_li_failed(lip);
-			}
-		}
-		xfs_ail_update_finish(ailp, tail_lsn);
-	}
+/*
+ * Walk the list of inodes that have completed their IOs. If they are clean
+ * remove them from the list and dissociate them from the buffer. Buffers that
+ * are still dirty remain linked to the buffer and on the list. Caller must
+ * handle them appropriately.
+ */
+void
+xfs_iflush_finish(
+	struct xfs_buf		*bp,
+	struct list_head	*list)
+{
+	struct xfs_log_item	*lip, *n;
 
-	/*
-	 * Clean up and unlock the flush lock now we are done. We can clear the
-	 * ili_last_fields bits now that we know that the data corresponding to
-	 * them is safely on disk.
-	 */
-	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
+	list_for_each_entry_safe(lip, n, list, li_bio_list) {
+		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 		bool	drop_buffer = false;
 
-		list_del_init(&lip->li_bio_list);
-		iip = INODE_ITEM(lip);
-
 		spin_lock(&iip->ili_lock);
 		iip->ili_last_fields = 0;
 		iip->ili_flush_lsn = 0;
 
 		/*
 		 * Remove the reference to the cluster buffer if the inode is
-		 * clean in memory. Drop the buffer reference once we've dropped
-		 * the locks we hold. If the inode is dirty in memory, we need
-		 * to put the inode item back on the buffer list for another
-		 * pass through the flush machinery.
+		 * clean in memory and drop the buffer reference once we've
+		 * dropped the locks we hold.
 		 */
 		ASSERT(iip->ili_item.li_buf == bp);
 		if (!iip->ili_fields) {
 			iip->ili_item.li_buf = NULL;
+			list_del_init(&lip->li_bio_list);
 			drop_buffer = true;
-		} else {
-			list_add(&lip->li_bio_list, &bp->b_li_list);
 		}
 		spin_unlock(&iip->ili_lock);
 		xfs_ifunlock(iip->ili_inode);
@@ -768,6 +731,51 @@ xfs_iflush_done(
 	}
 }
 
+/*
+ * Inode buffer IO completion routine.  It is responsible for removing inodes
+ * attached to the buffer from the AIL if they have not been re-logged, as well
+ * as completing the flush and unlocking the inode.
+ */
+void
+xfs_iflush_done(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip, *n;
+	LIST_HEAD(flushed_inodes);
+	LIST_HEAD(ail_updates);
+
+	/*
+	 * Pull the attached inodes from the buffer one at a time and take the
+	 * appropriate action on them.
+	 */
+	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
+		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+		if (!iip->ili_last_fields)
+			continue;
+
+		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
+			xfs_iflush_abort(iip->ili_inode);
+			continue;
+		}
+
+		/* Do an unlocked check for needing the AIL lock. */
+		if (iip->ili_flush_lsn == lip->li_lsn ||
+		    test_bit(XFS_LI_FAILED, &lip->li_flags))
+			list_move_tail(&lip->li_bio_list, &ail_updates);
+		else
+			list_move_tail(&lip->li_bio_list, &flushed_inodes);
+	}
+
+	if (!list_empty(&ail_updates)) {
+		xfs_iflush_ail_updates(bp->b_mount->m_ail, &ail_updates);
+		list_splice_tail(&ail_updates, &flushed_inodes);
+	}
+
+	xfs_iflush_finish(bp, &flushed_inodes);
+	if (!list_empty(&flushed_inodes))
+		list_splice_tail(&flushed_inodes, &bp->b_li_list);
+}
+
 /*
  * This is the inode flushing abort routine.  It is called from xfs_iflush when
  * the filesystem is shutting down to clean up the inode state.  It is
-- 
2.26.2.761.g0e0b3e54be

