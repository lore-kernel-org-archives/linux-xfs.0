Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfBRJSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 04:18:45 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: also truncate holes covered by COW blocks
Date: Mon, 18 Feb 2019 10:18:23 +0100
Message-Id: <20190218091827.12619-5-hch@lst.de>
In-Reply-To: <20190218091827.12619-1-hch@lst.de>
References: <20190218091827.12619-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>

This only matters if we want to write data through the COW fork that is
not actually an overwrite of existing data.  Reasons for that are
speculative COW fork allocations using the cowextsize, or a mode where
we always write through the COW fork.  Currently both can't actually
happen, but I plan to enable them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2ed8733eca49..983d11c27d32 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -447,28 +447,29 @@ xfs_map_blocks(
 
 	wpc->fork = XFS_DATA_FORK;
 
+	/* landed in a hole or beyond EOF? */
 	if (imap.br_startoff > offset_fsb) {
-		/* landed in a hole or beyond EOF */
 		imap.br_blockcount = imap.br_startoff - offset_fsb;
 		imap.br_startoff = offset_fsb;
 		imap.br_startblock = HOLESTARTBLOCK;
 		imap.br_state = XFS_EXT_NORM;
-	} else {
-		/*
-		 * Truncate to the next COW extent if there is one.  This is the
-		 * only opportunity to do this because we can skip COW fork
-		 * lookups for the subsequent blocks in the mapping; however,
-		 * the requirement to treat the COW range separately remains.
-		 */
-		if (cow_fsb != NULLFILEOFF &&
-		    cow_fsb < imap.br_startoff + imap.br_blockcount)
-			imap.br_blockcount = cow_fsb - imap.br_startoff;
-
-		/* got a delalloc extent? */
-		if (isnullstartblock(imap.br_startblock))
-			goto allocate_blocks;
 	}
 
+	/*
+	 * Truncate to the next COW extent if there is one.  This is the only
+	 * opportunity to do this because we can skip COW fork lookups for the
+	 * subsequent blocks in the mapping; however, the requirement to treat
+	 * the COW range separately remains.
+	 */
+	if (cow_fsb != NULLFILEOFF &&
+	    cow_fsb < imap.br_startoff + imap.br_blockcount)
+		imap.br_blockcount = cow_fsb - imap.br_startoff;
+
+	/* got a delalloc extent? */
+	if (imap.br_startblock != HOLESTARTBLOCK &&
+	    isnullstartblock(imap.br_startblock))
+		goto allocate_blocks;
+
 	wpc->imap = imap;
 	trace_xfs_map_blocks_found(ip, offset, count, wpc->fork, &imap);
 	return 0;
-- 
2.20.1
