Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdBBH4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:20 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/19] xfs: bump up reserved blocks in xfs_alloc_set_aside
Date: Thu,  2 Feb 2017 08:55:53 +0100
Message-Id: <1486022171-8076-2-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5149fd327f16e393c1d04fa5325ab072c32472bf upstream.

Setting aside 4 blocks globally for bmbt splits isn't all that useful,
as different threads can allocate space in parallel.  Bump it to 4
blocks per AG to allow each thread that is currently doing an
allocation to dip into it separately.  Without that we may no have
enough reserved blocks if there are enough parallel transactions
in an almost out space file system that all run into bmap btree
splits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5050056..0a46f84 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -95,10 +95,7 @@ unsigned int
 xfs_alloc_set_aside(
 	struct xfs_mount	*mp)
 {
-	unsigned int		blocks;
-
-	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
-	return blocks;
+	return mp->m_sb.sb_agcount * (XFS_ALLOC_AGFL_RESERVE + 4);
 }
 
 /*
-- 
2.1.4

