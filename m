Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegVg067667 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:46 -0600
Message-Id: <20121203144311.853211105@sgi.com>
Date: Mon, 03 Dec 2012 17:42:41 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 33/36] xfs: check for stale inode before acquiring
	iflock on push
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=103
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
Cc: xfs@oss.sgi.com

From: Brian Foster <bfoster@redhat.com>

Upstream commit: 9a3a5dab63461b84213052888bf38a962b22d035

    An inode in the AIL can be flush locked and marked stale if
    a cluster free transaction occurs at the right time. The
    inode item is then marked as flushing, which causes xfsaild
    to spin and leaves the filesystem stalled. This is
    reproduced by running xfstests 273 in a loop for an
    extended period of time.
 
    Check for stale inodes before the flush lock. This marks
    the inode as pinned, leads to a log flush and allows the
    filesystem to proceed.

    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>


---
 fs/xfs/xfs_inode_item.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_inode_item.c
===================================================================
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -588,6 +588,21 @@ xfs_inode_item_trylock(
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 		return XFS_ITEM_LOCKED;
 
+	/*
+	 * Re-check the pincount now that we stabilized the value by
+	 * taking the ilock.
+	 */
+	if (xfs_ipincount(ip) > 0) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_PINNED;
+	}
+
+	/* Stale items should force out the iclog */
+	if (ip->i_flags & XFS_ISTALE) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_PINNED;
+	}
+
 	if (!xfs_iflock_nowait(ip)) {
 		/*
 		 * inode has already been flushed to the backing buffer,
@@ -597,17 +612,6 @@ xfs_inode_item_trylock(
 		return XFS_ITEM_PUSHBUF;
 	}
 
-	/* Stale items should force out the iclog */
-	if (ip->i_flags & XFS_ISTALE) {
-		xfs_ifunlock(ip);
-		/*
-		 * we hold the AIL lock - notify the unlock routine of this
-		 * so it doesn't try to get the lock again.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED|XFS_IUNLOCK_NONOTIFY);
-		return XFS_ITEM_PINNED;
-	}
-
 #ifdef DEBUG
 	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ASSERT(iip->ili_format.ilf_fields != 0);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
