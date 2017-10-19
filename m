Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdJSHrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:47:09 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e55Xo-0008Ij-JM
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:47:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH for-4.14] xfs: fix AIM7 regression
Date: Thu, 19 Oct 2017 09:47:05 +0200
Message-Id: <20171019074705.24827-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Apparently our current rwsem code doesn't like doing the trylock, then
lock for real scheme.  So change our read/write methods to just do the
trylock for the RWF_NOWAIT case.  This fixes a ~25% regression in
AIM7.

Fixes: 91f9943e ("fs: support RWF_NOWAIT for buffered reads")
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 309e26c9dddb..f40b5da5d467 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -237,11 +237,13 @@ xfs_file_dax_read(
 	if (!count)
 		return 0; /* skip atime */
 
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
 			return -EAGAIN;
+	} else {
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
+
 	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
@@ -259,9 +261,10 @@ xfs_file_buffered_aio_read(
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
 
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
 			return -EAGAIN;
+	} else {
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
 	ret = generic_file_read_iter(iocb, to);
@@ -552,9 +555,10 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	if (!xfs_ilock_nowait(ip, iolock)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, iolock))
 			return -EAGAIN;
+	} else {
 		xfs_ilock(ip, iolock);
 	}
 
@@ -606,9 +610,10 @@ xfs_file_dax_write(
 	size_t			count;
 	loff_t			pos;
 
-	if (!xfs_ilock_nowait(ip, iolock)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, iolock))
 			return -EAGAIN;
+	} else {
 		xfs_ilock(ip, iolock);
 	}
 
-- 
2.14.2

