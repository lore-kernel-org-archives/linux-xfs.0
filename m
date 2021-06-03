Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F98C4709D
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B98613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhFCFYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:24:53 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:54970 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhFCFYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:52 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id F3C99105E82
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008Mq0-CA
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000ilK-3z
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/39] xfs: remove xfs_blkdev_issue_flush
Date:   Thu,  3 Jun 2021 15:22:04 +1000
Message-Id: <20210603052240.171998-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=yPCof4ZbAAAA:8 a=yhN9clXqsoNjLXMs1aUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a one line wrapper around blkdev_issue_flush(). Just replace it
with direct calls to blkdev_issue_flush().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c   | 2 +-
 fs/xfs/xfs_file.c  | 6 +++---
 fs/xfs/xfs_log.c   | 2 +-
 fs/xfs/xfs_super.c | 7 -------
 fs/xfs/xfs_super.h | 1 -
 5 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f..f5f95100a39e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1958,7 +1958,7 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	xfs_blkdev_issue_flush(btp);
+	blkdev_issue_flush(btp->bt_bdev);
 
 	kmem_free(btp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396ef36dcd0a..f3e834563a56 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -197,9 +197,9 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
@@ -219,7 +219,7 @@ xfs_file_fsync(
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
 	    mp->m_logdev_targp == mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4cd5840e953a..969eebbf3f64 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1964,7 +1964,7 @@ xlog_sync(
 	 * layer state machine for preflushes.
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
-		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
+		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 		need_flush = false;
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..9500ad115233 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -339,13 +339,6 @@ xfs_blkdev_put(
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
-void
-xfs_blkdev_issue_flush(
-	xfs_buftarg_t		*buftarg)
-{
-	blkdev_issue_flush(buftarg->bt_bdev);
-}
-
 STATIC void
 xfs_close_devices(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index d2b40dc60dfc..167d23f92ffe 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -87,7 +87,6 @@ struct xfs_buftarg;
 struct block_device;
 
 extern void xfs_flush_inodes(struct xfs_mount *mp);
-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 					   xfs_agnumber_t agcount);
 
-- 
2.31.1

