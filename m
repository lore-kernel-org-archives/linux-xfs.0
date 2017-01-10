Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756358AbdAJNxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:53:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 203/206] xfs: fix crash and data corruption due to removal of busy COW extents
Date: Tue, 10 Jan 2017 14:38:06 +0100
Message-Id: <20170110131512.400028188@linuxfoundation.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


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
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


