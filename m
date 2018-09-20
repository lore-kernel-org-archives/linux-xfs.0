Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36142 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITU0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 16:26:15 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g309y-0006fi-MF
        for linux-xfs@vger.kernel.org; Thu, 20 Sep 2018 14:42:27 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: cancel COW blocks before swapext
Date: Thu, 20 Sep 2018 16:42:16 +0200
Message-Id: <20180920144220.2181-2-hch@lst.de>
In-Reply-To: <20180920144220.2181-1-hch@lst.de>
References: <20180920144220.2181-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We need to make sure we have no outstanding COW blocks before we swap
extents, as there is nothing preventing us from having COW preallocations
on an inode that swapext is called on.  That case can easily be
reproduced by the upcoming always_cow mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 414dbc31139c..e0e9cbc98ccd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1515,6 +1515,12 @@ xfs_swap_extent_flush(
 		return error;
 	truncate_pagecache_range(VFS_I(ip), 0, -1);
 
+	if (xfs_inode_has_cow_data(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+		if (error)
+			return error;
+	}
+
 	/* Verify O_DIRECT for ftmp */
 	if (VFS_I(ip)->i_mapping->nrpages)
 		return -EINVAL;
-- 
2.18.0
