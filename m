Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40588 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391644AbeKXEkH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Nov 2018 23:40:07 -0500
Date: Fri, 23 Nov 2018 09:54:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: reserve blocks for rmapbt changes in xfs_reflink_end_cow
Message-ID: <20181123175448.GX6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_reflink_end_cow, we have to swap written extents from the CoW
fork into the data fork, which can require extensive rmapbt updates.
The transaction block reservation calculation forgot that part of the
calculation, which lead to a shutdown during an end_cow transaction roll
during fsx exercises:

XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 116
<machine registers snipped>
Call Trace:
 xfs_trans_dup+0x211/0x250 [xfs]
 xfs_trans_roll+0x6d/0x180 [xfs]
 xfs_defer_trans_roll+0x10c/0x3b0 [xfs]
 xfs_defer_finish_noroll+0xdf/0x740 [xfs]
 xfs_defer_finish+0x13/0x70 [xfs]
 xfs_reflink_end_cow+0x2c6/0x680 [xfs]
 xfs_dio_write_end_io+0x115/0x220 [xfs]
 iomap_dio_complete+0x3f/0x130
 iomap_dio_rw+0x3c3/0x420
 xfs_file_dio_aio_write+0x132/0x3c0 [xfs]
 xfs_file_write_iter+0x8b/0xc0 [xfs]
 __vfs_write+0x193/0x1f0
 vfs_write+0xba/0x1c0
 ksys_write+0x52/0xc0
 do_syscall_64+0x50/0x160
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 322a852ce284..c706d7791479 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -663,9 +663,14 @@ xfs_reflink_end_cow(
 		ASSERT(0);
 		goto out;
 	}
-	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
-			(unsigned int)(end_fsb - offset_fsb),
-			XFS_DATA_FORK);
+	if (xfs_sb_version_hasrmapbt(&ip->i_mount->m_sb))
+		resblks = XFS_SWAP_RMAP_SPACE_RES(ip->i_mount,
+				(unsigned int)(end_fsb - offset_fsb),
+				XFS_DATA_FORK);
+	else
+		resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
+				(unsigned int)(end_fsb - offset_fsb),
+				XFS_DATA_FORK);
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
 			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
 	if (error)
