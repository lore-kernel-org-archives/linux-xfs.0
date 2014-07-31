Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCE757F99
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 01:12:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F54630404E
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 23:12:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QlLnsxLqGOeCsSxL for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 23:12:19 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCjaz-0005TO-Vf
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 16:12:10 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCjaz-00036i-Uo
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 16:12:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: flush both inodes in xfs_swap_extents
Date: Thu, 31 Jul 2014 16:12:08 +1000
Message-Id: <1406787128-11897-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1406787128-11897-1-git-send-email-david@fromorbit.com>
References: <1406787128-11897-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We need to treat both inodes identically from a page cache point of
view when prepareing them for extent swapping. We don't do this
right now - we assume that one of the inodes empty, because that's
what xfs_fsr currently does. Remove this assumption from the code.

While factoring out the flushing and related checks, move the
transactions reservation to immeidately after the flushes so that we
don't need to pick up and then drop the ilock to do the transaction
reservation. There are no issues with aborting the transaction it if
the checks fail before we join the inodes to the transaction and
dirty them, so this is a safe change to make.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 81 +++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3c60c43..2f1e30d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1619,6 +1619,30 @@ xfs_swap_extents_check_format(
 }
 
 int
+xfs_swap_extent_flush(
+	struct xfs_inode	*ip)
+{
+	int	error;
+
+	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	if (error)
+		return error;
+	truncate_pagecache_range(VFS_I(ip), 0, -1);
+
+	/* Verify O_DIRECT for ftmp */
+	if (VFS_I(ip)->i_mapping->nrpages)
+		return -EINVAL;
+
+	/*
+	 * Don't try to swap extents on mmap()d files because we can't lock
+	 * out races against page faults safely.
+	 */
+	if (mapping_mapped(VFS_I(ip)->i_mapping))
+		return -EBUSY;
+	return 0;
+}
+
+int
 xfs_swap_extents(
 	xfs_inode_t	*ip,	/* target inode */
 	xfs_inode_t	*tip,	/* tmp inode */
@@ -1662,26 +1686,28 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
-	error = filemap_write_and_wait(VFS_I(tip)->i_mapping);
+	error = xfs_swap_extent_flush(ip);
+	if (error)
+		goto out_unlock;
+	error = xfs_swap_extent_flush(tip);
 	if (error)
 		goto out_unlock;
-	truncate_pagecache_range(VFS_I(tip), 0, -1);
-
-	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
-	lock_flags |= XFS_ILOCK_EXCL;
 
-	/* Verify O_DIRECT for ftmp */
-	if (VFS_I(tip)->i_mapping->nrpages) {
-		error = -EINVAL;
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
 		goto out_unlock;
 	}
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
 
 	/* Verify all data are being swapped */
 	if (sxp->sx_offset != 0 ||
 	    sxp->sx_length != ip->i_d.di_size ||
 	    sxp->sx_length != tip->i_d.di_size) {
 		error = -EFAULT;
-		goto out_unlock;
+		goto out_trans_cancel;
 	}
 
 	trace_xfs_swap_extent_before(ip, 0);
@@ -1693,7 +1719,7 @@ xfs_swap_extents(
 		xfs_notice(mp,
 		    "%s: inode 0x%llx format is incompatible for exchanging.",
 				__func__, ip->i_ino);
-		goto out_unlock;
+		goto out_trans_cancel;
 	}
 
 	/*
@@ -1708,41 +1734,8 @@ xfs_swap_extents(
 	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
 	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
 		error = -EBUSY;
-		goto out_unlock;
-	}
-
-	/* We need to fail if the file is memory mapped.  Once we have tossed
-	 * all existing pages, the page fault will have no option
-	 * but to go to the filesystem for pages. By making the page fault call
-	 * vop_read (or write in the case of autogrow) they block on the iolock
-	 * until we have switched the extents.
-	 */
-	if (mapping_mapped(VFS_I(ip)->i_mapping)) {
-		error = -EBUSY;
-		goto out_unlock;
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL);
-	lock_flags &= ~XFS_ILOCK_EXCL;
-
-	/*
-	 * There is a race condition here since we gave up the
-	 * ilock.  However, the data fork will not change since
-	 * we have the iolock (locked for truncation too) so we
-	 * are safe.  We don't really care if non-io related
-	 * fields change.
-	 */
-	truncate_pagecache_range(VFS_I(ip), 0, -1);
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error)
 		goto out_trans_cancel;
-
-	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
-	lock_flags |= XFS_ILOCK_EXCL;
-
+	}
 	/*
 	 * Count the number of extended attribute blocks
 	 */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
