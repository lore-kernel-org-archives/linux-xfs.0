Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938119AbdAIPkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 31/32] xfs: fix crash and data corruption due to removal of busy COW extents
Date: Mon,  9 Jan 2017 16:39:02 +0100
Message-Id: <1483976343-661-32-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

commit a1b7a4dea6166cf46be895bce4aac67ea5160fe8 upstream.

There is a race window between write_cache_pages calling
clear_page_dirty_for_io and XFS calling set_page_writeback, in which
the mapping for an inode is tagged neither as dirty, nor as writeback.

If the COW shrinker hits in exactly that window we'll remove the delayed
COW extents and writepages trying to write it back, which in release
kernels will manifest as corruption of the bmap btree, and in debug
kernels will trip the ASSERT about now calling xfs_bmapi_write with the
COWFORK flag for holes.  A complex customer load manages to hit this
window fairly reliably, probably by always having COW writeback in flight
while the cow shrinker runs.

This patch adds another check for having the I_DIRTY_PAGES flag set,
which is still set during this race window.  While this fixes the problem
I'm still not overly happy about the way the COW shrinker works as it
still seems a bit fragile.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9c3e5c6..29cc988 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1599,7 +1599,8 @@ xfs_inode_free_cowblocks(
 	 * If the mapping is dirty or under writeback we cannot touch the
 	 * CoW fork.  Leave it alone if we're in the midst of a directio.
 	 */
-	if (mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
+	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
 	    atomic_read(&VFS_I(ip)->i_dio_count))
 		return 0;
-- 
2.1.4

