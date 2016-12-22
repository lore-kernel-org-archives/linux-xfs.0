Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966324AbcLVUAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:00:32 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: fix the alignment fallback in xfs_bmap_btalloc
Date: Thu, 22 Dec 2016 21:00:19 +0100
Message-Id: <1482436822-31546-3-git-send-email-hch@lst.de>
In-Reply-To: <1482436822-31546-1-git-send-email-hch@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

The way the alignment field is used the minimum possible alignment is 1.
By setting it to 0 we'll mess up calculations that rely on this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2760bc3..19c05e9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3796,7 +3796,7 @@ xfs_bmap_btalloc(
 		 */
 		args.type = atype;
 		args.fsbno = ap->blkno;
-		args.alignment = 0;
+		args.alignment = 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-- 
2.1.4

