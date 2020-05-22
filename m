Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC113C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBB820759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgEVDul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33023 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728097AbgEVDuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:40 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A8CB03A3270
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002VV-LI
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgI3-Ct
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/24] xfs: get rid of log item callbacks
Date:   Fri, 22 May 2020 13:50:16 +1000
Message-Id: <20200522035029.3022405-12-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=IxSPRu1M28NFb9wgbagA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

They are not used anymore, so remove them from the log item and the
buffer iodone attachment interfaces.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 17 -----------------
 fs/xfs/xfs_buf_item.h |  3 ---
 fs/xfs/xfs_dquot.c    |  6 +++---
 fs/xfs/xfs_inode.c    |  5 +++--
 fs/xfs/xfs_trans.h    |  3 ---
 5 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d44b3e3f46613..d855a2b7486c5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -955,23 +955,6 @@ xfs_buf_item_relse(
 	xfs_buf_item_free(bip);
 }
 
-
-/*
- * Add the given log item with its callback to the list of callbacks
- * to be called when the buffer's I/O completes.
- */
-void
-xfs_buf_attach_iodone(
-	struct xfs_buf		*bp,
-	void			(*cb)(struct xfs_buf *, struct xfs_log_item *),
-	struct xfs_log_item	*lip)
-{
-	ASSERT(xfs_buf_islocked(bp));
-
-	lip->li_cb = cb;
-	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
-}
-
 /*
  * Invoke the error state callback for each log item affected by the failed I/O.
  *
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3f436efb0b67a..ecfad1915a86b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -54,9 +54,6 @@ void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-void	xfs_buf_attach_iodone(struct xfs_buf *,
-			      void(*)(struct xfs_buf *, struct xfs_log_item *),
-			      struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
 void	xfs_buf_dirty_iodone(struct xfs_buf *);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1d7f34a9bc989..34fc1bcb1eefd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1191,11 +1191,11 @@ xfs_qm_dqflush(
 	}
 
 	/*
-	 * Attach an iodone routine so that we can remove this dquot from the
-	 * AIL and release the flush lock once the dquot is synced to disk.
+	 * Attach the dquot to the buffer so that we can remove this dquot from
+	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
+	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c75d625de7945..c5529853f513c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2690,7 +2690,8 @@ xfs_ifree_cluster(
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
-			xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
+			list_add_tail(&iip->ili_item.li_bio_list,
+						&bp->b_li_list);
 
 			if (ip != free_ip)
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3840,7 +3841,7 @@ xfs_iflush_int(
 	 * the flush lock.
 	 */
 	bp->b_flags |= _XBF_INODES;
-	xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
+	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8308bf6d7e404..d27429e3a82a6 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -37,9 +37,6 @@ struct xfs_log_item {
 	unsigned long			li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct list_head		li_bio_list;	/* buffer item list */
-	void				(*li_cb)(struct xfs_buf *,
-						 struct xfs_log_item *);
-							/* buffer item iodone */
 							/* callback func */
 	const struct xfs_item_ops	*li_ops;	/* function list */
 
-- 
2.26.2.761.g0e0b3e54be

