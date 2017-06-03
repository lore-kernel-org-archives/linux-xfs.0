Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39695 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFCNTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/25] xfs: fix unaligned access in xfs_btree_visit_blocks
Date: Sat,  3 Jun 2017 15:18:33 +0200
Message-Id: <20170603131836.26661-23-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit a4d768e702de224cc85e0c8eac9311763403b368 upstream.

This structure copy was throwing unaligned access warnings on sparc64:

Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]

xfs_btree_copy_ptrs does a memcpy, which avoids it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2849d3fa3d0b..91c68913d495 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4376,7 +4376,7 @@ xfs_btree_visit_blocks(
 			xfs_btree_readahead_ptr(cur, ptr, 1);
 
 			/* save for the next iteration of the loop */
-			lptr = *ptr;
+			xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);
 		}
 
 		/* for each buffer in the level */
-- 
2.11.0

