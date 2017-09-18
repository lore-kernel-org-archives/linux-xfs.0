Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56963 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdIRPYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:24:23 -0400
Received: from [107.17.164.65] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dtxuJ-0005DH-JU
        for linux-xfs@vger.kernel.org; Mon, 18 Sep 2017 15:24:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/19] xfs: fix incorrect extent state in xfs_bmap_add_extent_unwritten_real
Date: Mon, 18 Sep 2017 08:24:04 -0700
Message-Id: <20170918152422.24345-2-hch@lst.de>
In-Reply-To: <20170918152422.24345-1-hch@lst.de>
References: <20170918152422.24345-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 459f4b4f08fe..f2f5bdb9e092 100644
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
2.14.1

