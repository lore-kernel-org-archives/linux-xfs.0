Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:39:11 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrgK-0000XS-Ng
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:39:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Date: Thu, 23 May 2019 19:37:28 +0200
Message-Id: <20190523173742.15551-7-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If we have to split a log write because it wraps the end of the log we
can't just use REQ_PREFLUSH to flush before the first log write,
as the writes might get reordered somewhere in the I/O stack.  Issue
a manual flush in that case so that the ordering of the two log I/Os
doesn't matter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3b82ca8ac9c8..646a190e5730 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1941,7 +1941,7 @@ xlog_sync(
 	 * synchronously here; for an internal log we can simply use the block
 	 * layer state machine for preflushes.
 	 */
-	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
+	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
 		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
 	else
 		bp->b_flags |= XBF_FLUSH;
-- 
2.20.1
