Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36747 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdDLKaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 06:30:19 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyFXW-0004jP-NG
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2017 10:30:19 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] xfs: fix integer truncation in xfs_bmap_remap_alloc
Date: Wed, 12 Apr 2017 12:30:08 +0200
Message-Id: <20170412103013.9355-2-hch@lst.de>
In-Reply-To: <20170412103013.9355-1-hch@lst.de>
References: <20170412103013.9355-1-hch@lst.de>
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

