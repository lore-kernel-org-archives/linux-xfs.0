Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48374 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbeK1DPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 22:15:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wARGFjPe059007
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 16:16:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nxxkqd06m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 16:16:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wARGGuDN017363
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 16:16:57 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wARGGuJt022640
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 16:16:56 GMT
Date: Tue, 27 Nov 2018 08:16:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: fix transaction block reservation in
 xfs_reflink_end_cow
Message-ID: <20181127161652.GE6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_reflink_end_cow, we have to swap written extents from the CoW
fork into the data fork, which can require extensive block map updates.
The block calculation has an off-by-one underflow, which can lead to
following shutdown:

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
 fs/xfs/xfs_reflink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 322a852ce284..d7a451e8b0b9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -657,14 +657,14 @@ xfs_reflink_end_cow(
 	 * Stick a warning in just in case, and avoid 64-bit division.
 	 */
 	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
-	if (end_fsb - offset_fsb > UINT_MAX) {
+	if (end_fsb - offset_fsb >= UINT_MAX) {
 		error = -EFSCORRUPTED;
 		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
 		ASSERT(0);
 		goto out;
 	}
 	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
-			(unsigned int)(end_fsb - offset_fsb),
+			(unsigned int)(end_fsb - offset_fsb + 1),
 			XFS_DATA_FORK);
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
 			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
