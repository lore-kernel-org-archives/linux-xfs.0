Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/20] xfs: update both stat counters together in xlog_sync
Date: Mon,  3 Jun 2019 19:29:35 +0200
Message-Id: <20190603172945.13819-11-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
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
index 02e9ab3af5ee..fa0414b8b111 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1898,7 +1898,6 @@ xlog_sync(
 	unsigned int		size;
 	bool			need_flush = true;
 
-	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
@@ -1916,6 +1915,7 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
-- 
2.20.1
