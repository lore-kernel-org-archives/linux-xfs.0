Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfBOOrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 09:47:51 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] xfs: retry COW fork delalloc conversion when no
Date: Fri, 15 Feb 2019 15:47:25 +0100
Message-Id: <20190215144725.8894-11-hch@lst.de>
In-Reply-To: <20190215144725.8894-1-hch@lst.de>
References: <20190215144725.8894-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

While we can only truncate a block under the page lock for the current
page, there is no high-level synchronization for moving extents from the
COW to the data fork.  This means that for example we can have another
thread doing a direct I/O completion that moves extents from the COW to
the data fork race with writeback.  While this race is very hard to hit
the always_cow seems to reproduce it reasonably well, and it also exists
without that.  Because of that there is a chance that a delalloc
conversion for the COW fork might not find any extents to convert.  In
that case we should retry the whole block lookup and now find the blocks
in the data fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6abb7125203..2ed8733eca49 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -334,7 +334,8 @@ xfs_imap_valid(
  * extent that maps offset_fsb in wpc->imap.
  *
  * The current page is held locked so nothing could have removed the block
- * backing offset_fsb.
+ * backing offset_fsb, although it could have moved from the COW to the data
+ * fork by another thread.
  */
 static int
 xfs_convert_blocks(
@@ -375,6 +376,7 @@ xfs_map_blocks(
 	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
+	int			retries = 0;
 	int			error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -404,6 +406,7 @@ xfs_map_blocks(
 	 * into real extents.  If we return without a valid map, it means we
 	 * landed in a hole and we skip the block.
 	 */
+retry:
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
@@ -471,8 +474,19 @@ xfs_map_blocks(
 	return 0;
 allocate_blocks:
 	error = xfs_convert_blocks(wpc, ip, offset_fsb);
-	if (error)
+	if (error) {
+		/*
+		 * If we failed to find the extent in the COW fork we might have
+		 * raced with a COW to data fork conversion or truncate.
+		 * Restart the lookup to catch the extent in the data fork for
+		 * the former case, but prevent additional retries to avoid
+		 * looping forever for the latter case.
+		 */
+		if (error == -EAGAIN && wpc->fork == XFS_COW_FORK && !retries++)
+			goto retry;
+		ASSERT(error != -EAGAIN);
 		return error;
+	}
 
 	/*
 	 * Due to merging the return real extent might be larger than the
-- 
2.20.1
