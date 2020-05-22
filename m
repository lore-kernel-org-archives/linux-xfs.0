Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AB1C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA0720759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgEVDun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:43 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:40682 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbgEVDum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:42 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 3D92ED78DE2
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:38 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002V1-4p
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyhZ-00CgHF-SD
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/24] xfs: remove logged flag from inode log item
Date:   Fri, 22 May 2020 13:50:06 +1000
Message-Id: <20200522035029.3022405-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=RMhDva1DPA6hu7IbcAIA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This was used to track if the item had logged fields being flushed
to disk. We log everything in the inode these days, so this logic is
no longer needed. Remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c      | 13 ++++---------
 fs/xfs/xfs_inode_item.c | 35 ++++++++++-------------------------
 fs/xfs/xfs_inode_item.h |  1 -
 3 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64f5f9a440aed..ca9f2688b745d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2658,7 +2658,6 @@ xfs_ifree_cluster(
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (struct xfs_inode_log_item *)lip;
-				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
 							&iip->ili_flush_lsn,
@@ -2687,7 +2686,6 @@ xfs_ifree_cluster(
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
 			iip->ili_fsync_fields = 0;
-			iip->ili_logged = 1;
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
@@ -3819,19 +3817,16 @@ xfs_iflush_int(
 	 *
 	 * We can play with the ili_fields bits here, because the inode lock
 	 * must be held exclusively in order to set bits there and the flush
-	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
-	 * done routine can tell whether or not to look in the AIL.  Also, store
-	 * the current LSN of the inode so that we can tell whether the item has
-	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
-	 * need the AIL lock, because it is a 64 bit value that cannot be read
-	 * atomically.
+	 * lock protects the ili_last_fields bits.  Store the current LSN of the
+	 * inode so that we can tell whether the item has moved in the AIL from
+	 * xfs_iflush_done().  In order to read the lsn we need the AIL lock,
+	 * because it is a 64 bit value that cannot be read atomically.
 	 */
 	error = 0;
 flush_out:
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
-	iip->ili_logged = 1;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index ba47bf65b772b..b17384aa8df40 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -528,8 +528,6 @@ xfs_inode_item_push(
 	}
 
 	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
-	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
-
 	spin_unlock(&lip->li_ailp->ail_lock);
 
 	error = xfs_iflush(ip, &bp);
@@ -690,30 +688,24 @@ xfs_iflush_done(
 			continue;
 
 		list_move_tail(&blip->li_bio_list, &tmp);
-		/*
-		 * while we have the item, do the unlocked check for needing
-		 * the AIL lock.
-		 */
+
+		/* Do an unlocked check for needing the AIL lock. */
 		iip = INODE_ITEM(blip);
-		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
+		if (blip->li_lsn == iip->ili_flush_lsn ||
 		    test_bit(XFS_LI_FAILED, &blip->li_flags))
 			need_ail++;
 	}
 
 	/* make sure we capture the state of the initial inode. */
 	iip = INODE_ITEM(lip);
-	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
+	if (lip->li_lsn == iip->ili_flush_lsn ||
 	    test_bit(XFS_LI_FAILED, &lip->li_flags))
 		need_ail++;
 
 	/*
-	 * We only want to pull the item from the AIL if it is
-	 * actually there and its location in the log has not
-	 * changed since we started the flush.  Thus, we only bother
-	 * if the ili_logged flag is set and the inode's lsn has not
-	 * changed.  First we check the lsn outside
-	 * the lock since it's cheaper, and then we recheck while
-	 * holding the lock before removing the inode from the AIL.
+	 * We only want to pull the item from the AIL if it is actually there
+	 * and its location in the log has not changed since we started the
+	 * flush.  Thus, we only bother if the inode's lsn has not changed.
 	 */
 	if (need_ail) {
 		xfs_lsn_t	tail_lsn = 0;
@@ -721,8 +713,7 @@ xfs_iflush_done(
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(blip, &tmp, li_bio_list) {
-			if (INODE_ITEM(blip)->ili_logged &&
-			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
+			if (blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
 				/*
 				 * xfs_ail_update_finish() only cares about the
 				 * lsn of the first tail item removed, any
@@ -740,14 +731,13 @@ xfs_iflush_done(
 	}
 
 	/*
-	 * clean up and unlock the flush lock now we are done. We can clear the
+	 * Clean up and unlock the flush lock now we are done. We can clear the
 	 * ili_last_fields bits now that we know that the data corresponding to
 	 * them is safely on disk.
 	 */
 	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
 		list_del_init(&blip->li_bio_list);
 		iip = INODE_ITEM(blip);
-		iip->ili_logged = 0;
 		iip->ili_last_fields = 0;
 		xfs_ifunlock(iip->ili_inode);
 	}
@@ -768,16 +758,11 @@ xfs_iflush_abort(
 
 	if (iip) {
 		xfs_trans_ail_delete(&iip->ili_item, 0);
-		iip->ili_logged = 0;
-		/*
-		 * Clear the ili_last_fields bits now that we know that the
-		 * data corresponding to them is safely on disk.
-		 */
-		iip->ili_last_fields = 0;
 		/*
 		 * Clear the inode logging fields so no more flushes are
 		 * attempted.
 		 */
+		iip->ili_last_fields = 0;
 		iip->ili_fields = 0;
 		iip->ili_fsync_fields = 0;
 	}
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 60b34bb66e8ed..4de5070e07655 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -19,7 +19,6 @@ struct xfs_inode_log_item {
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
 	unsigned short		ili_lock_flags;	   /* lock flags */
-	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
-- 
2.26.2.761.g0e0b3e54be

