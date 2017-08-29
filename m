Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55715 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdH2Rs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:48:57 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkdE-0007hU-OQ
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: move some code around inside xfs_bmap_shift_extents
Date: Tue, 29 Aug 2017 19:48:31 +0200
Message-Id: <20170829174835.2218-5-hch@lst.de>
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
References: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

For the first right move we need to look up next_fsb.  That means
our last fsb that contains next_fsb must also be the current extent,
so take advantage of that by moving the code around a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 54 ++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c944987c485d..6af3cc1fc630 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6127,7 +6127,6 @@ xfs_bmap_shift_extents(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
-	ASSERT(*next_fsb != NULLFSBLOCK || direction == SHIFT_RIGHT);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -6159,43 +6158,48 @@ xfs_bmap_shift_extents(
 	 * In case of first right shift, we need to initialize next_fsb
 	 */
 	if (*next_fsb == NULLFSBLOCK) {
-		gotp = xfs_iext_get_ext(ifp, total_extents - 1);
+		ASSERT(direction == SHIFT_RIGHT);
+
+		current_ext = total_extents - 1;
+		gotp = xfs_iext_get_ext(ifp, current_ext);
 		xfs_bmbt_get_all(gotp, &got);
 		*next_fsb = got.br_startoff;
 		if (stop_fsb > *next_fsb) {
 			*done = 1;
 			goto del_cursor;
 		}
+	} else {
+		/*
+		 * Look up the extent index for the fsb where we start shifting. We can
+		 * henceforth iterate with current_ext as extent list changes are locked
+		 * out via ilock.
+		 *
+		 * gotp can be null in 2 cases: 1) if there are no extents or 2)
+		 * *next_fsb lies in a hole beyond which there are no extents. Either
+		 * way, we are done.
+		 */
+		gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
+		if (!gotp) {
+			*done = 1;
+			goto del_cursor;
+		}
 	}
 
 	/* Lookup the extent index at which we have to stop */
 	if (direction == SHIFT_RIGHT) {
-		gotp = xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
+		xfs_iext_bno_to_ext(ifp, stop_fsb, &stop_extent);
 		/* Make stop_extent exclusive of shift range */
 		stop_extent--;
-	} else
+		if (current_ext <= stop_extent) {
+			error = -EIO;
+			goto del_cursor;
+		}
+	} else {
 		stop_extent = total_extents;
-
-	/*
-	 * Look up the extent index for the fsb where we start shifting. We can
-	 * henceforth iterate with current_ext as extent list changes are locked
-	 * out via ilock.
-	 *
-	 * gotp can be null in 2 cases: 1) if there are no extents or 2)
-	 * *next_fsb lies in a hole beyond which there are no extents. Either
-	 * way, we are done.
-	 */
-	gotp = xfs_iext_bno_to_ext(ifp, *next_fsb, &current_ext);
-	if (!gotp) {
-		*done = 1;
-		goto del_cursor;
-	}
-
-	/* some sanity checking before we finally start shifting extents */
-	if ((direction == SHIFT_LEFT && current_ext >= stop_extent) ||
-	     (direction == SHIFT_RIGHT && current_ext <= stop_extent)) {
-		error = -EIO;
-		goto del_cursor;
+		if (current_ext >= stop_extent) {
+			error = -EIO;
+			goto del_cursor;
+		}
 	}
 
 	while (nexts++ < num_exts) {
-- 
2.11.0

