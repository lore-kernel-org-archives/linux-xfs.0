Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbeIRCXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:20 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20XD-0005yh-6Z
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:19 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/10] xfs: handle extent size hints in xfs_file_iomap_begin_delay
Date: Mon, 17 Sep 2018 22:53:51 +0200
Message-Id: <20180917205354.15401-8-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

For files with extent size hints we always allocate unwritten extents
first and then convert them to real extents later to avoid exposing
stale data outside the blocks actually written.  But there is no
reason we can't do unwritten extent allocations from delalloc blocks,
in fact we already do that for COW operations.

Note that this does not handle files on the RT subvolume (yet), as
we removed code handling RT allocations from the delalloc path this
would be a slightly bigger project, and it doesn't really help with
simplifying the COW path either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e12ff5e9a8ec..2d08ace09e25 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -533,7 +533,6 @@ xfs_file_iomap_begin_delay(
 	xfs_fsblock_t		prealloc_blocks = 0;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
-	ASSERT(!xfs_get_extsz_hint(ip));
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -1035,7 +1034,7 @@ xfs_file_iomap_begin(
 		return -EIO;
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
-			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
+			!IS_DAX(inode) && !XFS_IS_REALTIME_INODE(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
 		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
 				iomap);
@@ -1088,17 +1087,9 @@ xfs_file_iomap_begin(
 	 * been done up front, so we don't need to do them here.
 	 */
 	if (xfs_is_reflink_inode(ip)) {
-		if (flags & IOMAP_DIRECT) {
-			/* may drop and re-acquire the ilock */
-			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
-					&lockmode);
-			if (error)
-				goto out_unlock;
-		} else {
-			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode);
+		if (error)
+			goto out_unlock;
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
-- 
2.18.0
