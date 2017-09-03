Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36820 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbdICHaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:21 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPMK-0006we-TW
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/17] xfs: use the proper state defines in xfs_bmap_del_extent_real
Date: Sun,  3 Sep 2017 09:29:46 +0200
Message-Id: <20170903072956.3175-8-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use the same defines as the other extent add and delete helpers, which
both improves code readability and trace point output.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index add690cb19a3..0a4bcef1cca8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5162,13 +5162,13 @@ xfs_bmap_del_extent_real(
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 	}
 
-	/*
-	 * Set flag value to use in switch statement.
-	 * Left-contig is 2, right-contig is 1.
-	 */
-	switch (((got.br_startoff == del->br_startoff) << 1) |
-		(got_endoff == del_endoff)) {
-	case 3:
+	if (got.br_startoff == del->br_startoff)
+		state |= BMAP_LEFT_CONTIG;
+	if (got_endoff == del_endoff)
+		state |= BMAP_RIGHT_CONTIG;
+
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
@@ -5188,8 +5188,7 @@ xfs_bmap_del_extent_real(
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		break;
-
-	case 2:
+	case BMAP_LEFT_CONTIG:
 		/*
 		 * Deleting the first part of the extent.
 		 */
@@ -5208,8 +5207,7 @@ xfs_bmap_del_extent_real(
 				got.br_state)))
 			goto done;
 		break;
-
-	case 1:
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * Deleting the last part of the extent.
 		 */
@@ -5227,7 +5225,6 @@ xfs_bmap_del_extent_real(
 				got.br_state)))
 			goto done;
 		break;
-
 	case 0:
 		/*
 		 * Deleting the middle of the extent.
-- 
2.11.0

