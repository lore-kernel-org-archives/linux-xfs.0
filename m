Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeGLN7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jul 2018 09:59:02 -0400
Received: from 213-225-6-92.nat.highway.a1.net ([213.225.6.92] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdbyF-0008Ft-9f
        for linux-xfs@vger.kernel.org; Thu, 12 Jul 2018 13:49:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: simplify xfs_idata_realloc
Date: Thu, 12 Jul 2018 15:49:06 +0200
Message-Id: <20180712134910.30298-3-hch@lst.de>
In-Reply-To: <20180712134910.30298-1-hch@lst.de>
References: <20180712134910.30298-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Streamline the code and take advantage of the fact that kmem_realloc
through krealloc will be have like a normal allocation if passing in a
NULL old pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 55 ++++++++++++----------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index dee85b0f8846..a0e3fb804605 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -468,51 +468,34 @@ xfs_iroot_realloc(
  */
 void
 xfs_idata_realloc(
-	xfs_inode_t	*ip,
-	int		byte_diff,
-	int		whichfork)
+	struct xfs_inode	*ip,
+	int			byte_diff,
+	int			whichfork)
 {
-	xfs_ifork_t	*ifp;
-	int		new_size;
-	int		real_size;
-
-	if (byte_diff == 0) {
-		return;
-	}
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	int			new_size = (int)ifp->if_bytes + byte_diff;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	new_size = (int)ifp->if_bytes + byte_diff;
 	ASSERT(new_size >= 0);
+	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
+
+	if (byte_diff == 0)
+		return;
 
 	if (new_size == 0) {
 		kmem_free(ifp->if_u1.if_data);
 		ifp->if_u1.if_data = NULL;
-		real_size = 0;
-	} else {
-		/*
-		 * Stuck with malloc/realloc.
-		 * For inline data, the underlying buffer must be
-		 * a multiple of 4 bytes in size so that it can be
-		 * logged and stay on word boundaries.  We enforce
-		 * that here.
-		 */
-		real_size = roundup(new_size, 4);
-		if (ifp->if_u1.if_data == NULL) {
-			ifp->if_u1.if_data = kmem_alloc(real_size,
-							KM_SLEEP | KM_NOFS);
-		} else {
-			/*
-			 * Only do the realloc if the underlying size
-			 * is really changing.
-			 */
-			ifp->if_u1.if_data =
-				kmem_realloc(ifp->if_u1.if_data,
-						real_size,
-						KM_SLEEP | KM_NOFS);
-		}
+		ifp->if_bytes = 0;
+		return;
 	}
+
+	/*
+	 * For inline data, the underlying buffer must be a multiple of 4 bytes
+	 * in size so that it can be logged and stay on word boundaries.
+	 * We enforce that here.
+	 */
+	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
+			roundup(new_size, 4), KM_SLEEP | KM_NOFS);
 	ifp->if_bytes = new_size;
-	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
 }
 
 void
-- 
2.18.0

