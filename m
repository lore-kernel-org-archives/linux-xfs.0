Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44926 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfDQOka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 10:40:30 -0400
Date: Wed, 17 Apr 2019 07:40:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: abort unaligned nowait directio early
Message-ID: <20190417144006.GH114154@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Dave Chinner noticed that xfs_file_dio_aio_write returns EAGAIN without
dropping the IOLOCK when its deciding not to wait, which means that we
leak the IOLOCK there.  Since we now make unaligned directio always
wait, we have the opportunity to bail out before trying to take the
lock, which should reduce the overhead of this never-gonna-work case
considerably while also solving the dropped lock problem.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cdcc75735521..3a45e3b0efa7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -517,6 +517,9 @@ xfs_file_dio_aio_write(
 	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* unaligned dio always waits, bail */
+		if (unaligned_io)
+			return -EAGAIN;
 		if (!xfs_ilock_nowait(ip, iolock))
 			return -EAGAIN;
 	} else {
@@ -536,9 +539,6 @@ xfs_file_dio_aio_write(
 	 * xfs_file_aio_write_checks() for other reasons.
 	 */
 	if (unaligned_io) {
-		/* unaligned dio always waits, bail */
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
 		inode_dio_wait(inode);
 	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
