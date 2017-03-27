Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdC0Iva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:51:30 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/27] xfs: don't reserve blocks for right shift transactions
Date: Mon, 27 Mar 2017 10:49:15 +0200
Message-Id: <20170327084922.11691-21-hch@lst.de>
In-Reply-To: <20170327084922.11691-1-hch@lst.de>
References: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 48af96ab92bc68fb645068b978ce36df2379e076 upstream.

The block reservation for the transaction allocated in
xfs_shift_file_space() is an artifact of the original collapse range
support. It exists to handle the case where a collapse range occurs,
the initial extent is left shifted into a location that forms a
contiguous boundary with the previous extent and thus the extents
are merged. This code was subsequently refactored and reused for
insert range (right shift) support.

If an insert range occurs under low free space conditions, the
extent at the starting offset is split before the first shift
transaction is allocated. If the block reservation fails, this
leaves separate, but contiguous extents around in the inode. While
not a fatal problem, this is unexpected and will flag a warning on
subsequent insert range operations on the inode. This problem has
been reproduce intermittently by generic/270 running against a
ramdisk device.

Since right shift does not create new extent boundaries in the
inode, a block reservation for extent merge is unnecessary. Update
xfs_shift_file_space() to conditionally reserve fs blocks for left
shift transactions only. This avoids the warning reproduced by
generic/270.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fd459b69161e..5c395e485170 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1387,10 +1387,16 @@ xfs_shift_file_space(
 	xfs_fileoff_t		stop_fsb;
 	xfs_fileoff_t		next_fsb;
 	xfs_fileoff_t		shift_fsb;
+	uint			resblks;
 
 	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
 
 	if (direction == SHIFT_LEFT) {
+		/*
+		 * Reserve blocks to cover potential extent merges after left
+		 * shift operations.
+		 */
+		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
 	} else {
@@ -1398,6 +1404,7 @@ xfs_shift_file_space(
 		 * If right shift, delegate the work of initialization of
 		 * next_fsb to xfs_bmap_shift_extent as it has ilock held.
 		 */
+		resblks = 0;
 		next_fsb = NULLFSBLOCK;
 		stop_fsb = XFS_B_TO_FSB(mp, offset);
 	}
@@ -1439,21 +1446,14 @@ xfs_shift_file_space(
 	}
 
 	while (!error && !done) {
-		/*
-		 * We would need to reserve permanent block for transaction.
-		 * This will come into picture when after shifting extent into
-		 * hole we found that adjacent extents can be merged which
-		 * may lead to freeing of a block during record update.
-		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
-				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
+					&tp);
 		if (error)
 			break;
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
-				ip->i_gdquot, ip->i_pdquot,
-				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+				ip->i_gdquot, ip->i_pdquot, resblks, 0,
 				XFS_QMOPT_RES_REGBLKS);
 		if (error)
 			goto out_trans_cancel;
-- 
2.11.0

