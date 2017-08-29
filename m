Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48383 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdH2Rsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:48:53 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkdA-0007fP-GL
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:48:53 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: use xfs_iext_get_extent in xfs_bmap_first_unused
Date: Tue, 29 Aug 2017 19:48:30 +0200
Message-Id: <20170829174835.2218-4-hch@lst.de>
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
References: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bbde43c99323..c944987c485d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1359,7 +1359,6 @@ xfs_bmap_first_unused(
 	xfs_fileoff_t	lastaddr;		/* last block number seen */
 	xfs_fileoff_t	lowest;			/* lowest useful block */
 	xfs_fileoff_t	max;			/* starting useful block */
-	xfs_fileoff_t	off;			/* offset for this block */
 	xfs_extnum_t	nextents;		/* number of extent entries */
 
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE ||
@@ -1376,16 +1375,19 @@ xfs_bmap_first_unused(
 	lowest = *first_unused;
 	nextents = xfs_iext_count(ifp);
 	for (idx = 0, lastaddr = 0, max = lowest; idx < nextents; idx++) {
-		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
-		off = xfs_bmbt_get_startoff(ep);
+		struct xfs_bmbt_irec got;
+
+		xfs_iext_get_extent(ifp, idx, &got);
+
 		/*
 		 * See if the hole before this extent will work.
 		 */
-		if (off >= lowest + len && off - max >= len) {
+		if (got.br_startoff >= lowest + len &&
+		    got.br_startoff - max >= len) {
 			*first_unused = max;
 			return 0;
 		}
-		lastaddr = off + xfs_bmbt_get_blockcount(ep);
+		lastaddr = got.br_startoff + got.br_blockcount;
 		max = XFS_FILEOFF_MAX(lastaddr, lowest);
 	}
 	*first_unused = max;
-- 
2.11.0

