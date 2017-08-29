Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58451 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdH2RtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:49:08 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkdP-0007jf-9G
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:49:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfs: use xfs_iext_*_extent helpers in xfs_bmap_split_extent_at
Date: Tue, 29 Aug 2017 19:48:33 +0200
Message-Id: <20170829174835.2218-7-hch@lst.de>
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
References: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This abstracts the function away from details of the low-level extent
list implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 02725becedfa..51571113b270 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6253,7 +6253,6 @@ xfs_bmap_split_extent_at(
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
-	struct xfs_bmbt_rec_host	*gotp;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		new; /* split extent */
 	struct xfs_mount		*mp = ip->i_mount;
@@ -6285,21 +6284,10 @@ xfs_bmap_split_extent_at(
 	}
 
 	/*
-	 * gotp can be null in 2 cases: 1) if there are no extents
-	 * or 2) split_fsb lies in a hole beyond which there are
-	 * no extents. Either way, we are done.
+	 * If there are not extents, or split_fsb lies in a hole we are done.
 	 */
-	gotp = xfs_iext_bno_to_ext(ifp, split_fsb, &current_ext);
-	if (!gotp)
-		return 0;
-
-	xfs_bmbt_get_all(gotp, &got);
-
-	/*
-	 * Check split_fsb lies in a hole or the start boundary offset
-	 * of the extent.
-	 */
-	if (got.br_startoff >= split_fsb)
+	if (!xfs_iext_lookup_extent(ip, ifp, split_fsb, &current_ext, &got) ||
+	    got.br_startoff >= split_fsb)
 		return 0;
 
 	gotblkcnt = split_fsb - got.br_startoff;
@@ -6322,8 +6310,8 @@ xfs_bmap_split_extent_at(
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
 	}
 
-	xfs_bmbt_set_blockcount(gotp, gotblkcnt);
 	got.br_blockcount = gotblkcnt;
+	xfs_iext_update_extent(ifp, current_ext, &got);
 
 	logflags = XFS_ILOG_CORE;
 	if (cur) {
-- 
2.11.0

