Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfFETP6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:58 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/24] xfs: update both stat counters together in xlog_sync
Date: Wed,  5 Jun 2019 21:15:00 +0200
Message-Id: <20190605191511.32695-14-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>

Just a small bit of code tidying up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b22f75affdc5..16f90a8fe49b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1859,7 +1859,6 @@ xlog_sync(
 	unsigned int		size;
 	bool			need_flush = true;
 
-	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
@@ -1877,6 +1876,7 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
-- 
2.20.1
