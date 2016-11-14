Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933841AbcKNRNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:33 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Kp2-0005hD-P2
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:33 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] xfs: use new extent lookup helpers in xfs_reflink_cancel_cow_blocks
Date: Mon, 14 Nov 2016 18:12:42 +0100
Message-Id: <1479143565-30615-12-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0668490..a878d42 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -493,18 +493,15 @@ xfs_reflink_cancel_cow_blocks(
 	xfs_fileoff_t			end_fsb)
 {
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec		got, prev, del;
+	struct xfs_bmbt_irec		got, del;
 	xfs_extnum_t			idx;
 	xfs_fsblock_t			firstfsb;
 	struct xfs_defer_ops		dfops;
-	int				error = 0, eof = 0;
+	int				error = 0;
 
 	if (!xfs_is_reflink_inode(ip))
 		return 0;
-
-	xfs_bmap_search_extents(ip, offset_fsb, XFS_COW_FORK, &eof, &idx,
-			&got, &prev);
-	if (eof)
+	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
 		return 0;
 
 	while (got.br_startoff < end_fsb) {
@@ -547,9 +544,8 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
 		}
 
-		if (++idx >= xfs_iext_count(ifp))
+		if (!xfs_iext_get_extent(ifp, ++idx, &got))
 			break;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
 	}
 
 	/* clear tag if cow fork is emptied */
-- 
2.1.4

