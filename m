Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbcJJNGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 09:06:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: convert COW blocks to real blocks before unwritten extent conversion
Date: Mon, 10 Oct 2016 15:06:34 +0200
Message-Id: <1476104794-28175-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

We need to splice COW blocks we've completed in xfs_end_io_direct_write
into the data fork before converting unwritten extents.  Otherwise
xfs_bmapi_write might first allocate blocks for any holes in the data
fork, which isn't only not needed but also harmful as it might cause
reserved block underruns in the transaction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0e2a931..3e57a56 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1547,13 +1547,13 @@ xfs_end_io_direct_write(
 		i_size_write(inode, offset + size);
 	spin_unlock(&ip->i_flags_lock);
 
+	if (flags & XFS_DIO_FLAG_COW)
+		error = xfs_reflink_end_cow(ip, offset, size);
 	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
 		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
 
 		error = xfs_iomap_write_unwritten(ip, offset, size);
 	}
-	if (flags & XFS_DIO_FLAG_COW)
-		error = xfs_reflink_end_cow(ip, offset, size);
 	if (flags & XFS_DIO_FLAG_APPEND) {
 		trace_xfs_end_io_direct_write_append(ip, offset, size);
 
-- 
2.10.1.382.ga23ca1b

