Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfEWRlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:41:01 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTri8-0002Ps-4y
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:41:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/20] xfs: make use of the l_targ field in struct xlog
Date: Thu, 23 May 2019 19:37:34 +0200
Message-Id: <20190523173742.15551-13-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use the slightly shorter way to get at the buftarg for the log device
wherever we can in the log and log recovery code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c         | 6 +++---
 fs/xfs/xfs_log_recover.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1974e47a96fb..3c7489b4619b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -927,7 +927,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	    xfs_readonly_buftarg(log->l_targ)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
 	}
@@ -1481,7 +1481,7 @@ xlog_alloc_log(
 	 * having set it up properly.
 	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, XFS_BUF_DADDR_NULL,
+	bp = xfs_buf_alloc(log->l_targ, XFS_BUF_DADDR_NULL,
 			   BTOBB(log->l_iclog_size), XBF_NO_IOACCT);
 	if (!bp)
 		goto out_free_log;
@@ -1946,7 +1946,7 @@ xlog_sync(
 	 * synchronously here; for an internal log we can simply use the block
 	 * layer state machine for preflushes.
 	 */
-	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split) {
+	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
 		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
 		flush = false;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9329f5adbfbe..4139b907e9cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -134,7 +134,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	bp = xfs_buf_get_uncached(log->l_mp->m_logdev_targp, nbblks, 0);
+	bp = xfs_buf_get_uncached(log->l_targ, nbblks, 0);
 	if (bp)
 		xfs_buf_unlock(bp);
 	return bp;
@@ -1505,7 +1505,7 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
+	if (!xfs_readonly_buftarg(log->l_targ))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-- 
2.20.1
