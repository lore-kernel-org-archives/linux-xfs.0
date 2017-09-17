Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59157 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdIQVHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/47] xfs: fix multi-AG deadlock in xfs_bunmapi
Date: Sun, 17 Sep 2017 14:06:40 -0700
Message-Id: <20170917210712.10804-16-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 5b094d6dac0451ad89b1dc088395c7b399b7e9e8 upstream.

Just like in the allocator we must avoid touching multiple AGs out of
order when freeing blocks, as freeing still locks the AGF and can cause
the same AB-BA deadlocks as in the allocation path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 73571fb4dfed..2ab50caca14c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5556,6 +5556,7 @@ __xfs_bunmapi(
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		max_len;
+	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5658,6 +5659,17 @@ __xfs_bunmapi(
 		ASSERT(ep != NULL);
 		del = got;
 		wasdel = isnullstartblock(del.br_startblock);
+
+		/*
+		 * Make sure we don't touch multiple AGF headers out of order
+		 * in a single transaction, as that could cause AB-BA deadlocks.
+		 */
+		if (!wasdel) {
+			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
+			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
+				break;
+			prev_agno = agno;
+		}
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;
-- 
2.14.1

