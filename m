Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48419 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754903AbdJSOXE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:04 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/16] xfs: don't unconditionally clear the reflink flag on zero-block files
Date: Thu, 19 Oct 2017 16:22:44 +0200
Message-Id: <20171019142259.20082-2-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit cc6f77710a6de6210f9feda7cd53e2f5ee7a7e69 upstream.

If we have speculative cow preallocations hanging around in the cow
fork, don't let a truncate operation clear the reflink flag because if
we do then there's a chance we'll forget to free those extents when we
destroy the incore inode.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9e795ab08a53..fe9a9a183b2d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1632,10 +1632,12 @@ xfs_itruncate_extents(
 		goto out;
 
 	/*
-	 * Clear the reflink flag if we truncated everything.
+	 * Clear the reflink flag if there are no data fork blocks and
+	 * there are no extents staged in the cow fork.
 	 */
-	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (xfs_is_reflink_inode(ip) && ip->i_cnextents == 0) {
+		if (ip->i_d.di_nblocks == 0)
+			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 		xfs_inode_clear_cowblocks_tag(ip);
 	}
 
-- 
2.14.2

