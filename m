Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF1NR6T159515 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 19:23:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D63101CC777D
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 17:25:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	jC9gZ7zx1aPYIKBH for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 17:25:18 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49873086-1927428
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 11:55:17 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PSg7I-00064W-5r
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:25:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PSg5d-0004HQ-Ty
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: serialise unaligned direct IOs
Date: Wed, 15 Dec 2010 12:23:28 +1100
Message-Id: <1292376208-16282-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1292376208-16282-1-git-send-email-david@fromorbit.com>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 269da12..68f88a5 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -648,10 +648,21 @@ xfs_file_aio_write_checks(
  * xfs_file_dio_aio_write - handle direct IO writes
  *
  * Lock the inode appropriately to prepare for and issue a direct IO write.
- * By spearating it from the buffered write path we remove all the tricky to
+ * By separating it from the buffered write path we remove all the tricky to
  * follow locking changes and looping. This also clearly indicates that XFS
  * does not fall back to buffered IO in the direct IO write path.
  *
+ * In most cases the direct IO writes will be done with IOLOCK_SHARED allowing
+ * them to be done in parallel with reads and other direct IO writes. However,
+ * if the IO is not aligned to filesystem blocks, the direct IO layer needs to
+ * do sub-block zeroing and that requires serialisation against other direct
+ * IOs to the same block. In this case we need to serialise the submission of
+ * the unaligned IOs so that we don't get racing block zeroing in the dio layer.
+ * To avoid the problem with aio, we also need to wait for outstanding IOs to
+ * complete so that unwritten extent conversion is completed before we try to
+ * map the overlapping block. This is currently implemented by hitting it
+ * with a big hammer (i.e. xfs_ioend_wait()).
+ *
  * Returns with locks held indicated by @need_i_mutex and @iolock.
  */
 STATIC ssize_t
@@ -671,6 +682,7 @@ xfs_file_dio_aio_write(
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			error = 0;
 	size_t			count = ocount;
+	int			unaligned_io = 0;
 	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
@@ -679,10 +691,15 @@ xfs_file_dio_aio_write(
 	if ((pos & target->bt_smask) || (count & target->bt_smask))
 		return XFS_ERROR(-EINVAL);
 
-	if (mapping->nrpages || pos > ip->i_size) {
+	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+		unaligned_io = 1;
+
+	if (unaligned_io || mapping->nrpages || pos > ip->i_size) {
 		*iolock = XFS_IOLOCK_EXCL;
 		*need_i_mutex = 1;
 		mutex_lock(&inode->i_mutex);
+		if (unaligned_io)
+			xfs_ioend_wait(ip);
 	} else {
 		*iolock = XFS_IOLOCK_SHARED;
 	}
@@ -700,10 +717,12 @@ xfs_file_dio_aio_write(
 	}
 
 	if (*need_i_mutex) {
-		/* demote the lock now the cached pages are gone */
-		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		/* demote the lock now the cached pages are gone if we can */
+		if (!unaligned_io) {
+			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+			*iolock = XFS_IOLOCK_SHARED;
+		}
 		mutex_unlock(&inode->i_mutex);
-		*iolock = XFS_IOLOCK_SHARED;
 		*need_i_mutex = 0;
 	}
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
