Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045F1C433EA
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE341206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgFAVnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:01 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55634 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728788AbgFAVm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:59 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 686391A84F7
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000XK-Tx
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU6e-LH
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/30] xfs: attach inodes to the cluster buffer when dirtied
Date:   Tue,  2 Jun 2020 07:42:46 +1000
Message-Id: <20200601214251.4167140-26-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=qUdrDcP34_7PpI3gcEgA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than attach inodes to the cluster buffer just when we are
doing IO, attach the inodes to the cluster buffer when they are
dirtied. The means the buffer always carries a list of dirty inodes
that reference it, and we can use that list to make more fundamental
changes to inode writeback that aren't otherwise possible.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_inode.c |  9 ++++++---
 fs/xfs/xfs_buf_item.c           |  1 +
 fs/xfs/xfs_icache.c             |  1 +
 fs/xfs/xfs_inode.c              | 24 +++++-------------------
 fs/xfs/xfs_inode_item.c         | 14 ++++++++------
 5 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 1e7147b90725e..5e7634c13ce78 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -164,13 +164,16 @@ xfs_trans_log_inode(
 		/*
 		 * We need an explicit buffer reference for the log item but
 		 * don't want the buffer to remain attached to the transaction.
-		 * Hold the buffer but release the transaction reference.
+		 * Hold the buffer but release the transaction reference once
+		 * we've attached the inode log item to the buffer log item
+		 * list.
 		 */
 		xfs_buf_hold(bp);
-		xfs_trans_brelse(tp, bp);
-
 		spin_lock(&iip->ili_lock);
 		iip->ili_item.li_buf = bp;
+		bp->b_flags |= _XBF_INODES;
+		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
+		xfs_trans_brelse(tp, bp);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9739d64a46443..6e7a2d460a675 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -465,6 +465,7 @@ xfs_buf_item_unpin(
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_item_done(bp);
 			xfs_iflush_done(bp);
+			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4fe6f250e8448..ed386bc930977 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -115,6 +115,7 @@ __xfs_inode_free(
 {
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
 	XFS_STATS_DEC(ip->i_mount, vn_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb4c614c64fda..af65acd24ec4e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2584,27 +2584,24 @@ xfs_ifree_mark_inode_stale(
 		ASSERT(iip->ili_last_fields);
 		goto out_iunlock;
 	}
-	ASSERT(!iip || list_empty(&iip->ili_item.li_bio_list));
 
 	/*
-	 * Clean inodes can be released immediately.  Everything else has to go
-	 * through xfs_iflush_abort() on journal commit as the flock
-	 * synchronises removal of the inode from the cluster buffer against
-	 * inode reclaim.
+	 * Inodes not attached to the buffer can be released immediately.
+	 * Everything else has to go through xfs_iflush_abort() on journal
+	 * commit as the flock synchronises removal of the inode from the
+	 * cluster buffer against inode reclaim.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (!iip || list_empty(&iip->ili_item.li_bio_list)) {
 		xfs_ifunlock(ip);
 		goto out_iunlock;
 	}
 
 	/* we have a dirty inode in memory that has not yet been flushed. */
-	ASSERT(iip->ili_fields);
 	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
 	spin_unlock(&iip->ili_lock);
-	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
 	ASSERT(iip->ili_last_fields);
 
 out_iunlock:
@@ -3819,19 +3816,8 @@ xfs_iflush_int(
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
 
-	/*
-	 * Attach the inode item callback to the buffer whether the flush
-	 * succeeded or not. If not, the caller will shut down and fail I/O
-	 * completion on the buffer to remove the inode from the AIL and release
-	 * the flush lock.
-	 */
-	bp->b_flags |= _XBF_INODES;
-	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
-
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
-
-	ASSERT(!list_empty(&bp->b_li_list));
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0a7720b7a821a..66675b75de3ec 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -665,10 +665,7 @@ xfs_inode_item_destroy(
  *
  * Note: Now that we attach the log item to the buffer when we first log the
  * inode in memory, we can have unflushed inodes on the buffer list here. These
- * inodes will have a zero ili_last_fields, so skip over them here. We do
- * this check -after- we've checked for stale inodes, because we're guaranteed
- * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
- * not yet had their dirtying transactions committed to disk.
+ * inodes will have a zero ili_last_fields, so skip over them here.
  */
 void
 xfs_iflush_done(
@@ -686,8 +683,8 @@ xfs_iflush_done(
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = INODE_ITEM(lip);
+
 		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
-			list_del_init(&lip->li_bio_list);
 			xfs_iflush_abort(iip->ili_inode);
 			continue;
 		}
@@ -740,12 +737,16 @@ xfs_iflush_done(
 		/*
 		 * Remove the reference to the cluster buffer if the inode is
 		 * clean in memory. Drop the buffer reference once we've dropped
-		 * the locks we hold.
+		 * the locks we hold. If the inode is dirty in memory, we need
+		 * to put the inode item back on the buffer list for another
+		 * pass through the flush machinery.
 		 */
 		ASSERT(iip->ili_item.li_buf == bp);
 		if (!iip->ili_fields) {
 			iip->ili_item.li_buf = NULL;
 			drop_buffer = true;
+		} else {
+			list_add(&lip->li_bio_list, &bp->b_li_list);
 		}
 		iip->ili_last_fields = 0;
 		iip->ili_flush_lsn = 0;
@@ -789,6 +790,7 @@ xfs_iflush_abort(
 		iip->ili_flush_lsn = 0;
 		bp = iip->ili_item.li_buf;
 		iip->ili_item.li_buf = NULL;
+		list_del_init(&iip->ili_item.li_bio_list);
 		spin_unlock(&iip->ili_lock);
 	}
 	xfs_ifunlock(ip);
-- 
2.26.2.761.g0e0b3e54be

