Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55801 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdDMIFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:05:42 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZl7-0007bA-FE
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:05:42 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/10] xfs: remove the total argument to xfs_bmap_local_to_extents
Date: Thu, 13 Apr 2017 10:05:12 +0200
Message-Id: <20170413080517.12564-6-hch@lst.de>
In-Reply-To: <20170413080517.12564-1-hch@lst.de>
References: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

It must inherently be the same as the minlen/maxlen arguments for
this allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aec4907056ba..53f1386b1868 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -867,7 +867,6 @@ xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_fsblock_t	*firstblock,	/* first block allocated in xaction */
-	xfs_extlen_t	total,		/* total blocks needed by transaction */
 	int		*logflagsp,	/* inode logging flags */
 	int		whichfork,
 	void		(*init_fn)(struct xfs_trans *tp,
@@ -916,8 +915,7 @@ xfs_bmap_local_to_extents(
 		args.fsbno = *firstblock;
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	}
-	args.total = total;
-	args.minlen = args.maxlen = args.prod = 1;
+	args.total = args.minlen = args.maxlen = args.prod = 1;
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto done;
@@ -1067,7 +1065,7 @@ xfs_bmap_add_attrfork_local(
 	}
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
-		return xfs_bmap_local_to_extents(tp, ip, firstblock, 1,
+		return xfs_bmap_local_to_extents(tp, ip, firstblock,
 						 flags, XFS_DATA_FORK,
 						 xfs_symlink_local_to_remote);
 
-- 
2.11.0

