Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeCMOgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:07 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl27-0004ZN-7y
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] xfs: fix the check for COW extents in xfs_swap_extents
Date: Tue, 13 Mar 2018 15:35:54 +0100
Message-Id: <20180313143601.30028-2-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

i_cnextents does not include delayed allocated extents, so switch
to the inode fork size check that we already use in other places
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e0a442f504e5..19ea7d086cf8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -2014,11 +2014,11 @@ xfs_swap_extents(
 		ip->i_cowfp = tip->i_cowfp;
 		tip->i_cowfp = cowfp;
 
-		if (ip->i_cowfp && ip->i_cnextents)
+		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
 			xfs_inode_set_cowblocks_tag(ip);
 		else
 			xfs_inode_clear_cowblocks_tag(ip);
-		if (tip->i_cowfp && tip->i_cnextents)
+		if (tip->i_cowfp && tip->i_cowfp->if_bytes)
 			xfs_inode_set_cowblocks_tag(tip);
 		else
 			xfs_inode_clear_cowblocks_tag(tip);
-- 
2.14.2

