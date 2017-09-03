Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53057 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdICHaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:03 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPM3-0005ii-5n
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/17] xfs: fix incorrect extent state in xfs_bmap_add_extent_unwritten_real
Date: Sun,  3 Sep 2017 09:29:40 +0200
Message-Id: <20170903072956.3175-2-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There was one spot in xfs_bmap_add_extent_unwritten_real that didn't use the
passed in new extent state but always converted to normal, leading to wrong
behavior when converting from normal to unwritten.

Only found by code inspection, it seems like this code path to move partial
extent from written to unwritten while merging it with the next extent is
rarely exercised.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9558f5ee1bf9..a60744a46bdf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2573,7 +2573,7 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			cur->bc_rec.b.br_state = XFS_EXT_NORM;
+			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-- 
2.11.0

