Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFjDI072051 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:45 -0600
Message-Id: <20111119181543.605305176@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9] [PATCH 2/9] xfs: fix xfs_mark_inode_dirty during umount
References: <20111119181336.964593075@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-xfs-fix-xfs_mark_inode_dirty-during-umount.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

During umount we do not add a dirty inode to the lru and wait for it to
become clean first, but force writeback of data and metadata with
I_WILL_FREE set.  Currently there is no way for XFS to detect that the
inode has been redirtied for metadata operations, as we skip the
mark_inode_dirty call during teardown.  Fix this by setting i_update_core
nanually in that case, so that the inode gets flushed during inode reclaim.

Alternatively we could enable calling mark_inode_dirty for inodes in
I_WILL_FREE state, and let the VFS dirty tracking handle this.  I decided
against this as we will get better I/O patterns from reclaim compared to
the synchronous writeout in write_inode_now, and always marking the inode
dirty in some way from xfs_mark_inode_dirty is a better safetly net in
either case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
(cherry picked from commit da6742a5a4cc844a9982fdd936ddb537c0747856)

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index d44d92c..a9b3e1e 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -69,9 +69,8 @@ xfs_synchronize_times(
 }
 
 /*
- * If the linux inode is valid, mark it dirty.
- * Used when committing a dirty inode into a transaction so that
- * the inode will get written back by the linux code
+ * If the linux inode is valid, mark it dirty, else mark the dirty state
+ * in the XFS inode to make sure we pick it up when reclaiming the inode.
  */
 void
 xfs_mark_inode_dirty_sync(
@@ -81,6 +80,10 @@ xfs_mark_inode_dirty_sync(
 
 	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
 		mark_inode_dirty_sync(inode);
+	else {
+		barrier();
+		ip->i_update_core = 1;
+	}
 }
 
 void
@@ -91,6 +94,11 @@ xfs_mark_inode_dirty(
 
 	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
 		mark_inode_dirty(inode);
+	else {
+		barrier();
+		ip->i_update_core = 1;
+	}
+
 }
 
 /*
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
