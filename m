Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPftK227510 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:41 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 765F82E79BE
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:42 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id xq9AQHnV8wAyTbv8 for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:42 -0700 (PDT)
Message-Id: <20100422190909.201572751@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:51 -0700
From: Greg KH <gregkh@suse.de>
Subject: [020/197] xfs: reclaim all inodes by background tree walks
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 57817c68229984818fea9e614d6f95249c3fb098 upstream

We cannot do direct inode reclaim without taking the flush lock to
ensure that we do not reclaim an inode under IO. We check the inode
is clean before doing direct reclaim, but this is not good enough
because the inode flush code marks the inode clean once it has
copied the in-core dirty state to the backing buffer.

It is the flush lock that determines whether the inode is still
under IO, even though it is marked clean, and the inode is still
required at IO completion so we can't reclaim it even though it is
clean in core. Hence the requirement that we need to take the flush
lock even on clean inodes because this guarantees that the inode
writeback IO has completed and it is safe to reclaim the inode.

With delayed write inode flushing, we could end up waiting a long
time on the flush lock even for a clean inode. The background
reclaim already handles this efficiently, so avoid all the problems
by killing the direct reclaim path altogether.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -953,16 +953,14 @@ xfs_fs_destroy_inode(
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
 
 	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise delay the flush operation.
+	 * We always use background reclaim here because even if the
+	 * inode is clean, it still may be under IO and hence we have
+	 * to take the flush lock. The background reclaim path handles
+	 * this more efficiently than we can here, so simply let background
+	 * reclaim tear down all inodes.
 	 */
-	if (!xfs_inode_clean(ip)) {
-		xfs_inode_set_reclaim_tag(ip);
-		return;
-	}
-
 out_reclaim:
-	xfs_ireclaim(ip);
+	xfs_inode_set_reclaim_tag(ip);
 }
 
 /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
