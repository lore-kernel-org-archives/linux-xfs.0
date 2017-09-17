Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51963 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdIQVHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 40/47] xfs: move bmbt owner change to last step of extent swap
Date: Sun, 17 Sep 2017 14:07:05 -0700
Message-Id: <20170917210712.10804-41-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 6fb10d6d22094bc4062f92b9ccbcee2f54033d04 upstream.

The extent swap operation currently resets bmbt block owners before
the inode forks are swapped. The bmbt buffers are marked as ordered
so they do not have to be physically logged in the transaction.

This use of ordered buffers is not safe as bmbt buffers may have
been previously physically logged. The bmbt owner change algorithm
needs to be updated to physically log buffers that are already dirty
when/if they are encountered. This means that an extent swap will
eventually require multiple rolling transactions to handle large
btrees. In addition, all inode related changes must be logged before
the bmbt owner change scan begins and can roll the transaction for
the first time to preserve fs consistency via log recovery.

In preparation for such fixes to the bmbt owner change algorithm,
refactor the bmbt scan out of the extent fork swap code to the last
operation before the transaction is committed. Update
xfs_swap_extent_forks() to only set the inode log flags when an
owner change scan is necessary. Update xfs_swap_extents() to trigger
the owner change based on the inode log flags. Note that since the
owner change now occurs after the extent fork swap, the inode btrees
must be fixed up with the inode number of the current inode (similar
to log recovery).

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 87b495e2f15a..15cd36f29fc4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1825,29 +1825,18 @@ xfs_swap_extent_forks(
 	}
 
 	/*
-	 * Before we've swapped the forks, lets set the owners of the forks
-	 * appropriately. We have to do this as we are demand paging the btree
-	 * buffers, and so the validation done on read will expect the owner
-	 * field to be correctly set. Once we change the owners, we can swap the
-	 * inode forks.
+	 * Btree format (v3) inodes have the inode number stamped in the bmbt
+	 * block headers. We can't start changing the bmbt blocks until the
+	 * inode owner change is logged so recovery does the right thing in the
+	 * event of a crash. Set the owner change log flags now and leave the
+	 * bmbt scan as the last step.
 	 */
 	if (ip->i_d.di_version == 3 &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
 		(*target_log_flags) |= XFS_ILOG_DOWNER;
-		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
-					      tip->i_ino, NULL);
-		if (error)
-			return error;
-	}
-
 	if (tip->i_d.di_version == 3 &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
 		(*src_log_flags) |= XFS_ILOG_DOWNER;
-		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
-					      ip->i_ino, NULL);
-		if (error)
-			return error;
-	}
 
 	/*
 	 * Swap the data forks of the inodes
@@ -2076,6 +2065,25 @@ xfs_swap_extents(
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
 	xfs_trans_log_inode(tp, tip, target_log_flags);
 
+	/*
+	 * The extent forks have been swapped, but crc=1,rmapbt=0 filesystems
+	 * have inode number owner values in the bmbt blocks that still refer to
+	 * the old inode. Scan each bmbt to fix up the owner values with the
+	 * inode number of the current inode.
+	 */
+	if (src_log_flags & XFS_ILOG_DOWNER) {
+		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK,
+					      ip->i_ino, NULL);
+		if (error)
+			goto out_trans_cancel;
+	}
+	if (target_log_flags & XFS_ILOG_DOWNER) {
+		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK,
+					      tip->i_ino, NULL);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
-- 
2.14.1

