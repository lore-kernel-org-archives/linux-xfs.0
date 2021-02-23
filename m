Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48E4C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C77164E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBWDf3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:35:29 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:37026 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhBWDf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 22:35:28 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 97FEFFA628C
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 14:34:46 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-0001kZ-Qc
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-00Di0F-JM
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: move and rename xfs_blkdev_issue_flush
Date:   Tue, 23 Feb 2021 14:34:37 +1100
Message-Id: <20210223033442.3267258-4-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210223033442.3267258-1-david@fromorbit.com>
References: <20210223033442.3267258-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=3J8Cqu4lOtRIifzBSocA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move it to xfs_bio_io.c as we are about to add new async cache flush
functionality that uses bios directly, so all this stuff should be
in the same place. Rename the function to xfs_flush_bdev() to match
the xfs_rw_bdev() function that already exists in this file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bio_io.c | 8 ++++++++
 fs/xfs/xfs_buf.c    | 2 +-
 fs/xfs/xfs_file.c   | 6 +++---
 fs/xfs/xfs_linux.h  | 1 +
 fs/xfs/xfs_log.c    | 2 +-
 fs/xfs/xfs_super.c  | 7 -------
 fs/xfs/xfs_super.h  | 1 -
 7 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index e2148f2d5d6b..5abf653a45d4 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -59,3 +59,11 @@ xfs_rw_bdev(
 		invalidate_kernel_vmap_range(data, count);
 	return error;
 }
+
+void
+xfs_flush_bdev(
+	struct block_device	*bdev)
+{
+	blkdev_issue_flush(bdev, GFP_NOFS);
+}
+
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f6e5235df7c9..b1d6c530c693 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1958,7 +1958,7 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	xfs_blkdev_issue_flush(btp);
+	xfs_flush_bdev(btp->bt_bdev);
 
 	kmem_free(btp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 38528e59030e..dd33ef2d0e20 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -196,9 +196,9 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+		xfs_flush_bdev(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		xfs_flush_bdev(mp->m_ddev_targp->bt_bdev);
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
@@ -218,7 +218,7 @@ xfs_file_fsync(
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
 	    mp->m_logdev_targp == mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		xfs_flush_bdev(mp->m_ddev_targp->bt_bdev);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index af6be9b9ccdf..e94a2aeefee8 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -196,6 +196,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 
 int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, unsigned int op);
+void xfs_flush_bdev(struct block_device *bdev);
 
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ff26fb46d70f..493454c98c6f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2015,7 +2015,7 @@ xlog_sync(
 	 * layer state machine for preflushes.
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
-		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
+		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
 		need_flush = false;
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 21b1d034aca3..85dd9593b40b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -339,13 +339,6 @@ xfs_blkdev_put(
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
-void
-xfs_blkdev_issue_flush(
-	xfs_buftarg_t		*buftarg)
-{
-	blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS);
-}
-
 STATIC void
 xfs_close_devices(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 1ca484b8357f..79cb2dece811 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -88,7 +88,6 @@ struct block_device;
 
 extern void xfs_quiesce_attr(struct xfs_mount *mp);
 extern void xfs_flush_inodes(struct xfs_mount *mp);
-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 					   xfs_agnumber_t agcount);
 
-- 
2.28.0

