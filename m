Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbeIRCXE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:04 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20Wx-0005wO-RG
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/10] xfs: don't bring in extents in xfs_bmap_punch_delalloc_range
Date: Mon, 17 Sep 2018 22:53:46 +0200
Message-Id: <20180917205354.15401-3-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This function is only used to punch out delayed allocations on I/O
failure, which means we need to have read the extents earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index addbd74ecd8e..418e1e725f3a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -702,13 +702,9 @@ xfs_bmap_punch_delalloc_range(
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
-		if (error)
-			goto out_unlock;
-	}
+	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
 		goto out_unlock;
 
-- 
2.18.0
