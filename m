Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB69C25AEB
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B16F61053
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhIBKAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:35 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44751 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233325AbhIBKAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:34 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9EEA01143E51
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIm-Li
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCo-E2
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: tag transactions that contain intent done items
Date:   Thu,  2 Sep 2021 19:59:22 +1000
Message-Id: <20210902095927.911100-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=Zy-FAL8c0QFeftCiL8gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Intent whiteouts will require extra work to be done during
transaction commit if the transaction contains an intent done item.

To determine if a transaction contains an intent done item, we want
to avoid having to walk all the items in the transaction to check if
they are intent done items. Hence when we add an intent done item to
a transaction, tag the transaction to indicate that it contains such
an item.

We don't tag the transaction when the defer ops is relogging an
intent to move it forward in the log. Whiteouts will never apply to
these cases, so we don't need to bother looking for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
 fs/xfs/xfs_attr_item.c     |  4 +++-
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 6 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 25c4cab58851..e96618dbde29 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /*
  * Values for t_flags.
  */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
-#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
+/* Transaction needs to be logged */
+#define XFS_TRANS_DIRTY			(1 << 0)
+/* Superblock is dirty and needs to be logged */
+#define XFS_TRANS_SB_DIRTY		(1 << 1)
+/* Transaction took a permanent log reservation */
+#define XFS_TRANS_PERM_LOG_RES		(1 << 2)
+/* Synchronous transaction commit needed */
+#define XFS_TRANS_SYNC			(1 << 3)
+/* Transaction can use reserve block pool */
+#define XFS_TRANS_RESERVE		(1 << 4)
+/* Transaction should avoid VFS level superblock write accounting */
+#define XFS_TRANS_NO_WRITECOUNT		(1 << 5)
+/* Transaction has freed blocks returned to it's reservation */
+#define XFS_TRANS_RES_FDBLKS		(1 << 6)
+/* Transaction contains an intent done log item */
+#define XFS_TRANS_HAS_INTENT_DONE	(1 << 7)
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f900001e8f3a..572edb7fb2cd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -311,8 +311,10 @@ xfs_trans_attr_finish_update(
 	/*
 	 * attr intent/done items are null when delayed attributes are disabled
 	 */
-	if (attrdp)
+	if (attrdp) {
 		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+		args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8de644a343b5..5244d85b1ba4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -255,7 +255,7 @@ xfs_trans_log_finish_bmap_update(
 	 * 1.) releases the BUI and frees the BUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 952a46477907..f689530aaa75 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -381,7 +381,7 @@ xfs_trans_free_extent(
 	 * 1.) releases the EFI and frees the EFD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
 	next_extent = efdp->efd_next_extent;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 38b38a734fd6..b426e98d7f4f 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -260,7 +260,7 @@ xfs_trans_log_finish_refcount_update(
 	 * 1.) releases the CUI and frees the CUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1b3655090113..df3e61c1bf69 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -328,7 +328,7 @@ xfs_trans_log_finish_rmap_update(
 	 * 1.) releases the RUI and frees the RUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
 
 	return error;
-- 
2.31.1

