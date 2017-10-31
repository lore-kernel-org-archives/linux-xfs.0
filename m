Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58211 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdJaOWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:49 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRJ-0007bP-0q
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/18] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_real
Date: Tue, 31 Oct 2017 16:22:17 +0200
Message-Id: <20171031142230.11755-6-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6358b30b70f9..7bd27c08981f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2741,11 +2741,11 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		--*idx;
 		left.br_blockcount += new->br_blockcount + right.br_blockcount;
-		xfs_iext_update_extent(ip, state, *idx, &left);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx, 1, state);
+		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &left);
 
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -2777,10 +2777,10 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		--*idx;
 		old = left;
-
 		left.br_blockcount += new->br_blockcount;
+
+		--*idx;
 		xfs_iext_update_extent(ip, state, *idx, &left);
 
 		if (cur == NULL) {
-- 
2.14.2

