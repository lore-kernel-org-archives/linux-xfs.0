Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932553AbeCMOg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:26 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl2O-0004cM-Km
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfs: minor cleanup for xfs_reflink_end_cow
Date: Tue, 13 Mar 2018 15:35:59 +0100
Message-Id: <20180313143601.30028-7-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_prev_extent to skip to the previous extent instead of
opencoding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 90aac8889dd9..cdbd342a5249 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -762,10 +762,8 @@ xfs_reflink_end_cow(
 		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
 
 		/* Extent delete may have bumped ext forward */
-		if (!del.br_blockcount) {
-			xfs_iext_prev(ifp, &icur);
-			goto next_extent;
-		}
+		if (!del.br_blockcount)
+			goto prev_extent;
 
 		ASSERT(!isnullstartblock(got.br_startblock));
 
@@ -774,10 +772,8 @@ xfs_reflink_end_cow(
 		 * speculatively preallocated CoW extents that have been
 		 * allocated but have not yet been involved in a write.
 		 */
-		if (got.br_state == XFS_EXT_UNWRITTEN) {
-			xfs_iext_prev(ifp, &icur);
-			goto next_extent;
-		}
+		if (got.br_state == XFS_EXT_UNWRITTEN)
+			goto prev_extent;
 
 		/* Unmap the old blocks in the data fork. */
 		xfs_defer_init(&dfops, &firstfsb);
@@ -816,9 +812,12 @@ xfs_reflink_end_cow(
 		error = xfs_defer_finish(&tp, &dfops);
 		if (error)
 			goto out_defer;
-next_extent:
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
+		continue;
+prev_extent:
+		if (!xfs_iext_prev_extent(ifp, &icur, &got))
+			break;
 	}
 
 	error = xfs_trans_commit(tp);
-- 
2.14.2

