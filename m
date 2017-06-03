Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50229 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCNP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:15:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/23] xfs: fix integer truncation in xfs_bmap_remap_alloc
Date: Sat,  3 Jun 2017 15:14:53 +0200
Message-Id: <20170603131511.25032-6-hch@lst.de>
In-Reply-To: <20170603131511.25032-1-hch@lst.de>
References: <20170603131511.25032-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 52813fb13ff90bd9c39a93446cbf1103c290b6e9 upstream.

bno should be a xfs_fsblock_t, which is 64-bit wides instead of a
xfs_aglock_t, which truncates the value to 32 bits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9bd104f32908..2a426d127e05 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3863,7 +3863,7 @@ xfs_bmap_remap_alloc(
 {
 	struct xfs_trans	*tp = ap->tp;
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_agblock_t		bno;
+	xfs_fsblock_t		bno;
 	struct xfs_alloc_arg	args;
 	int			error;
 
-- 
2.11.0

