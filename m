Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbdJaOWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:46 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRG-0007aq-3N
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/18] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_delay
Date: Tue, 31 Oct 2017 16:22:16 +0200
Message-Id: <20171031142230.11755-5-hch@lst.de>
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
 fs/xfs/libxfs/xfs_bmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 83f5a503dce1..6358b30b70f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2583,7 +2583,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		--*idx;
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
 
@@ -2594,9 +2593,10 @@ xfs_bmap_add_extent_hole_delay(
 					 oldlen);
 		left.br_startblock = nullstartblock(newlen);
 		left.br_blockcount = temp;
-		xfs_iext_update_extent(ip, state, *idx, &left);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx, 1, state);
+		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &left);
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -2605,7 +2605,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		--*idx;
 		temp = left.br_blockcount + new->br_blockcount;
 
 		oldlen = startblockval(left.br_startblock) +
@@ -2614,6 +2613,8 @@ xfs_bmap_add_extent_hole_delay(
 					 oldlen);
 		left.br_blockcount = temp;
 		left.br_startblock = nullstartblock(newlen);
+
+		--*idx;
 		xfs_iext_update_extent(ip, state, *idx, &left);
 		break;
 
-- 
2.14.2

