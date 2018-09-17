Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbeIRCXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:11 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20X4-0005xS-6J
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] xfs: simplify the IOMAP_ZERO check in xfs_file_iomap_begin a bit
Date: Mon, 17 Sep 2018 22:53:48 +0200
Message-Id: <20180917205354.15401-5-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Merge the two cases for reflink vs not into a single one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6320aca39f39..9595a3c59ade 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1048,16 +1048,20 @@ xfs_file_iomap_begin(
 	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
 		goto out_found;
 
+	/*
+	 * Don't need to allocate over holes when doing zeroing operations,
+	 * unless we need to COW and have an existing extent.
+	 */
+	if ((flags & IOMAP_ZERO) &&
+	    (!xfs_is_reflink_inode(ip) ||
+	     !needs_cow_for_zeroing(&imap, nimaps)))
+		goto out_found;
+
 	/*
 	 * Break shared extents if necessary. Checks for non-blocking IO have
 	 * been done up front, so we don't need to do them here.
 	 */
 	if (xfs_is_reflink_inode(ip)) {
-		/* if zeroing doesn't need COW allocation, then we are done. */
-		if ((flags & IOMAP_ZERO) &&
-		    !needs_cow_for_zeroing(&imap, nimaps))
-			goto out_found;
-
 		if (flags & IOMAP_DIRECT) {
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
@@ -1074,10 +1078,6 @@ xfs_file_iomap_begin(
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	}
 
-	/* Don't need to allocate over holes when doing zeroing operations. */
-	if (flags & IOMAP_ZERO)
-		goto out_found;
-
 	if (!imap_needs_alloc(inode, &imap, nimaps))
 		goto out_found;
 
-- 
2.18.0
