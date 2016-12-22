Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966324AbcLVUA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:00:29 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: bump up reserved blocks in xfs_alloc_set_aside
Date: Thu, 22 Dec 2016 21:00:18 +0100
Message-Id: <1482436822-31546-2-git-send-email-hch@lst.de>
In-Reply-To: <1482436822-31546-1-git-send-email-hch@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

Setting aside 4 blocks globally for bmbt splits isn't all that useful,
as different threads can allocate space in parallel.  Bump it to 4
blocks per AG to allow each thread that is currently doing an
allocation to dip into it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

