Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46344 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeKULtP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 06:49:15 -0500
Date: Tue, 20 Nov 2018 17:17:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: reflink should flush after an unaligned directio cow
 write
Message-ID: <20181121011706.GO6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If userspace hands us a not-block-aligned directio write, we'll fall
back to a buffered write for the read-modify-write operation.
Unfortunately, we don't flush the page cache after a successful
fallback CoW, which means we break userspace's expectation that the data
has been sent to the drive.  Fix that by upgrading the iocb to DSYNC so
that the buffered CoW is synchronous.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..675da7e9c001 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -692,6 +692,8 @@ xfs_file_write_iter(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	size_t			ocount = iov_iter_count(from);
+	bool			was_dsync = iocb->ki_flags & IOCB_DSYNC;
+	int			error;
 
 	XFS_STATS_INC(ip->i_mount, xs_write_calls);
 
@@ -714,9 +716,13 @@ xfs_file_write_iter(
 		ret = xfs_file_dio_aio_write(iocb, from);
 		if (ret != -EREMCHG)
 			return ret;
+		iocb->ki_flags |= IOCB_DSYNC;
 	}
 
-	return xfs_file_buffered_aio_write(iocb, from);
+	error = xfs_file_buffered_aio_write(iocb, from);
+	if (!was_dsync)
+		iocb->ki_flags &= ~IOCB_DSYNC;
+	return error;
 }
 
 static void
