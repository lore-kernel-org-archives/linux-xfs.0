Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38977 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdICHaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:09 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPM9-0006lv-2s
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/17] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
Date: Sun,  3 Sep 2017 09:29:42 +0200
Message-Id: <20170903072956.3175-4-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The XFS_BTCUR_BPRV_WASDEL flag is supposed to indicate that we are
converting a delayed allocation to a real one, which isn't the case
in xfs_bunmapi.  Setting it could theoretically lead to misaccounting
here, but it's unlikely that we ever hit it in practice.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4867df0c1bcd..b5b30415aa2b 100644
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
2.11.0

