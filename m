Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCNLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/23] xfs: actually report xattr extents via iomap
Date: Sat,  3 Jun 2017 15:10:43 +0200
Message-Id: <20170603131103.23712-4-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 84358536dc355a9c8978ee425f87e116186bed16 upstream.

Apparently FIEMAP for xattrs has been broken since we switched to
the iomap backend because of an incorrect check for xattr presence.
Also fix the broken locking.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 288ee5b840d7..79e6dfac3dd6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1170,10 +1170,10 @@ xfs_xattr_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	lockmode = xfs_ilock_data_map_shared(ip);
+	lockmode = xfs_ilock_attr_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
+	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
-- 
2.11.0

