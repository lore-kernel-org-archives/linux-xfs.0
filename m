Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06ALfXB013315 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 04:21:43 -0600
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] xfs: serialise unaligned direct IOs
Date: Fri,  6 Jan 2012 16:03:10 +0530
Message-Id: <1325845990-5664-1-git-send-email-amit.sahrawat83@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>, xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Amit Sahrawat <amit.sahrawat83@gmail.com>

From: Amit Sahrawat<amit.sahrawat83@gmail.com>

[ This patch published in 2.6.38 kernel(Original reference
http://oss.sgi.com/archives/xfs/2011-01/msg00013.html), but
can not be applied to 2.6.35 kernel directly, because of the
absence of required function, its reimplmented to resolve
xfstest test 240 fail.]

When two concurrent unaligned, non-overlapping direct IOs are issued
to the same block, the direct Io layer will race to zero the block.
The result is that one of the concurrent IOs will overwrite data
written by the other IO with zeros. This is demonstrated by the
xfsqa test 240.

To avoid this problem, serialise all unaligned direct IOs to an
inode with a big hammer. We need a big hammer approach as we need to
serialise AIO as well, so we can't just block writes on locks.
Hence, the big hammer is calling xfs_ioend_wait() while holding out
other unaligned direct IOs from starting.

We don't bother trying to serialised aligned vs unaligned IOs as
they are overlapping IO and the result of concurrent overlapping IOs
is undefined - the result of either IO is a valid result so we let
them race. Hence we only penalise unaligned IO, which already has a
major overhead compared to aligned IO so this isn't a major problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 257a56b..b943aa1 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -629,6 +629,7 @@ xfs_file_aio_write(
 	int			iolock;
 	int			eventsent = 0;
 	size_t			ocount = 0, count;
+	int			unaligned_io = 0;
 	int			need_i_mutex;
 
 	XFS_STATS_INC(xs_write_calls);
@@ -709,8 +710,26 @@ start:
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
+	/*
+	 * In most cases the direct IO writes will be done with IOLOCK_SHARED
+	 * allowing them to be done in parallel with reads and other direct IO
+	 * writes. However,if the IO is not aligned to filesystem blocks, the
+	 * direct IO layer needs to do sub-block zeroing and that requires
+	 * serialisation against other direct IOs to the same block. In this
+	 * case we need to serialise the submission of the unaligned IOs so
+	 * that we don't get racing block zeroing in the dio layer.
+	 * To avoid the problem with aio, we also need to wait for outstanding
+	 * IOs to complete so that unwritten extent conversion is completed
+	 * before we try to map the overlapping block. This is currently
+	 * implemented by hitting it with a big hammer (i.e. xfs_ioend_wait()).
+	 */
+
+		if ((pos & mp->m_blockmask) ||
+		   ((pos + count) & mp->m_blockmask))
+			unaligned_io = 1;
 
-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
+		if (!need_i_mutex &&
+		   (unaligned_io || mapping->nrpages || pos > ip->i_size)) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
@@ -769,12 +788,18 @@ start:
 		}
 
 		if (need_i_mutex) {
-			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-			mutex_unlock(&inode->i_mutex);
-
-			iolock = XFS_IOLOCK_SHARED;
-			need_i_mutex = 0;
+			if (unaligned_io)
+				xfs_ioend_wait(ip);
+			else {
+				/*
+				 * demote the lock now the cached pages
+				 * are gone if we can
+				 */
+				xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+				iolock = XFS_IOLOCK_SHARED;
+				mutex_unlock(&inode->i_mutex);
+				need_i_mutex = 0;
+			}
 		}
 
 		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
