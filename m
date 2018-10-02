Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCA0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 20:26:39 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g7OgS-0007do-VI
        for linux-xfs@vger.kernel.org; Tue, 02 Oct 2018 17:42:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: remove magic handling of unwritten extents in xfs_bmapi_allocate
Date: Tue,  2 Oct 2018 10:42:02 -0700
Message-Id: <20181002174207.25275-4-hch@lst.de>
In-Reply-To: <20181002174207.25275-1-hch@lst.de>
References: <20181002174207.25275-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There is no real need to treat unwritten delalloc extent special in
any way here, so remove the special casing and related comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index da6b768664e3..3bb250ee6c7c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4069,20 +4069,10 @@ xfs_bmapi_allocate(
 	bma->got.br_startoff = bma->offset;
 	bma->got.br_startblock = bma->blkno;
 	bma->got.br_blockcount = bma->length;
-	bma->got.br_state = XFS_EXT_NORM;
-
-	/*
-	 * In the data fork, a wasdelay extent has been initialized, so
-	 * shouldn't be flagged as unwritten.
-	 *
-	 * For the cow fork, however, we convert delalloc reservations
-	 * (extents allocated for speculative preallocation) to
-	 * allocated unwritten extents, and only convert the unwritten
-	 * extents to real extents when we're about to write the data.
-	 */
-	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
-	    (bma->flags & XFS_BMAPI_PREALLOC))
+	if (bma->flags & XFS_BMAPI_PREALLOC)
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
+	else
+		bma->got.br_state = XFS_EXT_NORM;
 
 	if (bma->wasdel)
 		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
-- 
2.19.0
