Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdIVN7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 09:59:48 -0400
Received: from ip-64-134-232-11.public.wayport.net ([64.134.232.11] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dvOUd-00019b-PW
        for linux-xfs@vger.kernel.org; Fri, 22 Sep 2017 13:59:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/19] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
Date: Fri, 22 Sep 2017 06:59:29 -0700
Message-Id: <20170922135945.31574-4-hch@lst.de>
In-Reply-To: <20170922135945.31574-1-hch@lst.de>
References: <20170922135945.31574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The XFS_BTCUR_BPRV_WASDEL flag is supposed to indicate that we are
converting a delayed allocation to a real one, which isn't the case
in xfs_bunmapi.  Setting it could theoretically lead to misaccounting
here, but it's unlikely that we ever hit it in practice.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 555ff198e28c..ef30b52c32af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5725,11 +5725,7 @@ __xfs_bunmapi(
 					XFS_QMOPT_RES_REGBLKS);
 			}
 			ip->i_delayed_blks -= del.br_blockcount;
-			if (cur)
-				cur->bc_private.b.flags |=
-					XFS_BTCUR_BPRV_WASDEL;
-		} else if (cur)
-			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
+		}
 
 		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
 				&tmp_logflags, whichfork, flags);
-- 
2.14.1

