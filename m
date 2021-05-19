Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C3CC43611
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85458613AC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346300AbhESMOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:46 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:48611 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238273AbhESMOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:42 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8167E1AFD96
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002m0S-Ho
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SGa-AQ
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/39] xfs: remove xfs_blkdev_issue_flush
Date:   Wed, 19 May 2021 22:12:41 +1000
Message-Id: <20210519121317.585244-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=GmExBpR_1cBMw-p9ekUA:9 a=AjGcO6oz07-iQ99wixmX:22
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
---
 fs/xfs/xfs_buf.c   | 2 +-
 fs/xfs/xfs_file.c  | 6 +++---
 fs/xfs/xfs_log.c   | 2 +-
 fs/xfs/xfs_super.c | 7 -------
 fs/xfs/xfs_super.h | 1 -
 5 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a10d49facadf..ebfcba2e8a77 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1945,7 +1945,7 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	xfs_blkdev_issue_flush(btp);
+	blkdev_issue_flush(btp->bt_bdev);
 
 	kmem_free(btp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c068dcd414f4..e7e9af57e788 100644
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
index 688309dbe18b..e339d1de2419 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -340,13 +340,6 @@ xfs_blkdev_put(
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

