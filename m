Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48225 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937414AbdD0V2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 17:28:22 -0400
Date: Thu, 27 Apr 2017 14:27:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: handle large CoW remapping requests
Message-ID: <20170427212754.GB19158@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>

XFS transactions are constrained both by space and block reservation
limits and the fact that we have to avoid doing 64-bit divisions.  This
means that we can't remap more than 2^32 blocks at a time.  However,
file logical blocks are 64-bit in size, so if we encounter a huge remap
request we have to break it up into smaller pieces.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   83 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ffe6fe7..bb61bb2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -675,49 +675,29 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
-/*
- * Remap parts of a file's data fork after a successful CoW.
- */
-int
-xfs_reflink_end_cow(
+/* Remap a particular subrange of a file. */
+STATIC int
+xfs_reflink_end_cow_range(
 	struct xfs_inode		*ip,
-	xfs_off_t			offset,
-	xfs_off_t			count)
+	struct xfs_ifork		*ifp,
+	xfs_fileoff_t			offset_fsb,
+	xfs_fileoff_t			end_fsb)
 {
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec		got, del;
+	struct xfs_bmbt_irec		got;
+	struct xfs_bmbt_irec		del;
+	struct xfs_defer_ops		dfops;
 	struct xfs_trans		*tp;
-	xfs_fileoff_t			offset_fsb;
-	xfs_fileoff_t			end_fsb;
 	xfs_fsblock_t			firstfsb;
-	struct xfs_defer_ops		dfops;
-	int				error;
-	unsigned int			resblks;
 	xfs_filblks_t			rlen;
+	unsigned int			resblks;
 	xfs_extnum_t			idx;
-
-	trace_xfs_reflink_end_cow(ip, offset, count);
-
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0)
-		return 0;
-
-	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+	int				error;
 
 	/*
-	 * Start a rolling transaction to switch the mappings.  We're
-	 * unlikely ever to have to remap 16T worth of single-block
-	 * extents, so just cap the worst case extent count to 2^32-1.
-	 * Stick a warning in just in case, and avoid 64-bit division.
+	 * Start a rolling transaction to switch the mappings.
+	 * Avoid 64-bit division.
 	 */
-	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
-	if (end_fsb - offset_fsb > UINT_MAX) {
-		error = -EFSCORRUPTED;
-		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
-		ASSERT(0);
-		goto out;
-	}
+	ASSERT(end_fsb - offset_fsb <= UINT_MAX);
 	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
 			(unsigned int)(end_fsb - offset_fsb),
 			XFS_DATA_FORK);
@@ -812,6 +792,41 @@ xfs_reflink_end_cow(
 }
 
 /*
+ * Remap parts of a file's data fork after a successful CoW.
+ */
+int
+xfs_reflink_end_cow(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset,
+	xfs_off_t			count)
+{
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	xfs_fileoff_t			offset_fsb;
+	xfs_fileoff_t			end_fsb;
+	xfs_fileoff_t			opend;
+	int				error = 0;
+
+	trace_xfs_reflink_end_cow(ip, offset, count);
+
+	/* No COW extents?  That's easy! */
+	if (ifp->if_bytes == 0)
+		return 0;
+
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+
+	while (offset_fsb < end_fsb) {
+		opend = min_t(xfs_fileoff_t, offset_fsb + UINT_MAX, end_fsb);
+		error = xfs_reflink_end_cow_range(ip, ifp, offset_fsb, opend);
+		if (error)
+			break;
+		offset_fsb = opend;
+	}
+
+	return error;
+}
+
+/*
  * Free leftover CoW reservations that didn't get cleaned out.
  */
 int
