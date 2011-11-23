Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN0gATD182931 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:42:10 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7588926FB71
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:42:09 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id iWuDLmWTDa7kWMrn for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:42:09 -0800 (PST)
Message-Id: <20111123002408.725504127@clark.kroah.org>
Date: Tue, 22 Nov 2011 16:23:51 -0800
From: Greg KH <gregkh@suse.de>
Subject: [44/53] xfs: fix xfs_mark_inode_dirty during umount
In-Reply-To: <20111123002419.GA8531@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 866e4ed77448a0c311e1b055eb72ea05423fd799 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_iops.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
