Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdDKLKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:10:22 -0400
Received: from 212095007090.public.telering.at ([212.95.7.90] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxtgj-0004oX-2q
        for linux-xfs@vger.kernel.org; Tue, 11 Apr 2017 11:10:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] xfs: fix integer truncation in xfs_bmap_remap_alloc
Date: Tue, 11 Apr 2017 13:10:06 +0200
Message-Id: <20170411111011.9437-2-hch@lst.de>
In-Reply-To: <20170411111011.9437-1-hch@lst.de>
References: <20170411111011.9437-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

bno should be a xfs_fsblock_t, which is 64-bit wides instead of a
xfs_aglock_t, which truncates the value to 32 bits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

