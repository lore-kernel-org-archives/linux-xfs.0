Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45338 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 19:06:31 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 9/9] xfs: abort unaligned nowait directio early
Date: Thu, 18 Jul 2019 23:06:17 +0000
Message-Id: <20190718230617.7439-10-mcgrof@kernel.org>
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1fdeaea4d92c69fb9f871a787af6ad00f32eeea7 upstream.

Dave Chinner noticed that xfs_file_dio_aio_write returns EAGAIN without
dropping the IOLOCK when its deciding not to wait, which means that we
leak the IOLOCK there.  Since we now make unaligned directio always
wait, we have the opportunity to bail out before trying to take the
lock, which should reduce the overhead of this never-gonna-work case
considerably while also solving the dropped lock problem.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 10f75965243c..259549698ba7 100644
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
-- 
2.20.1
