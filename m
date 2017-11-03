Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932812AbdKCOpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:45:50 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEC-0001lw-Up
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:45:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/21] xfs: remove a duplicate assignment in xfs_bmap_add_extent_delay_real
Date: Fri,  3 Nov 2017 17:45:20 +0300
Message-Id: <20171103144539.2187-3-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index db369653eb50..e1d61face277 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1765,7 +1765,7 @@ xfs_bmap_add_extent_delay_real(
 		LEFT.br_blockcount += new->br_blockcount;
 		xfs_iext_update_extent(bma->ip, state, bma->idx - 1, &LEFT);
 
-		PREV.br_blockcount = temp = PREV.br_blockcount - new->br_blockcount;
+		PREV.br_blockcount = temp;
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock = nullstartblock(da_new);
 		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
-- 
2.14.2

