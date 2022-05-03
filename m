Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4118FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbiECWVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243533AbiECWVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:21:09 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B40A3F33C
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:17:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 339E55345A9
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 08:17:31 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-007gGR-5q
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 08:17:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-000mGY-4P
        for linux-xfs@vger.kernel.org;
        Wed, 04 May 2022 08:17:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: tag transactions that contain intent done items
Date:   Wed,  4 May 2022 08:17:24 +1000
Message-Id: <20220503221728.185449-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503221728.185449-1-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6271a9fb
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
        a=f4-_iRGBJiCRqTHycS8A:9 a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 25c4cab58851..c4381388c0c1 100644
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
+#define XFS_TRANS_DIRTY			(1u << 0)
+/* Superblock is dirty and needs to be logged */
+#define XFS_TRANS_SB_DIRTY		(1u << 1)
+/* Transaction took a permanent log reservation */
+#define XFS_TRANS_PERM_LOG_RES		(1u << 2)
+/* Synchronous transaction commit needed */
+#define XFS_TRANS_SYNC			(1u << 3)
+/* Transaction can use reserve block pool */
+#define XFS_TRANS_RESERVE		(1u << 4)
+/* Transaction should avoid VFS level superblock write accounting */
+#define XFS_TRANS_NO_WRITECOUNT		(1u << 5)
+/* Transaction has freed blocks returned to it's reservation */
+#define XFS_TRANS_RES_FDBLKS		(1u << 6)
+/* Transaction contains an intent done log item */
+#define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0e0aae83308c..3d1fa8edf28f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -257,7 +257,7 @@ xfs_trans_log_finish_bmap_update(
 	 * 1.) releases the BUI and frees the BUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 21a159f9d8c5..96735f23d12d 100644
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
index 71225d094e03..b37a9d2ce652 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -262,7 +262,7 @@ xfs_trans_log_finish_refcount_update(
 	 * 1.) releases the CUI and frees the CUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 6ecbc37e4b8d..5221fd1e6f6f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -330,7 +330,7 @@ xfs_trans_log_finish_rmap_update(
 	 * 1.) releases the RUI and frees the RUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
 
 	return error;
-- 
2.35.1

