Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07BTFH3039135 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 05:29:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F6984F674C
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 03:31:23 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	cjjmD1Drw3MKLMOB for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 03:31:23 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51857746-1927428
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 22:01:22 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PbAXR-0007i3-8m
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 22:31:21 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PbAWw-0000Jo-Fj
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 22:30:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: serialise unaligned direct IOs
Date: Fri,  7 Jan 2011 22:30:25 +1100
Message-Id: <1294399825-1157-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1294399825-1157-1-git-send-email-david@fromorbit.com>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index d6ff7ff..5c1402c 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -677,9 +677,24 @@ xfs_file_aio_write_checks(
  * xfs_file_dio_aio_write - handle direct IO writes
  *
  * Lock the inode appropriately to prepare for and issue a direct IO write.
- * By spearating it from the buffered write path we remove all the tricky to
+ * By separating it from the buffered write path we remove all the tricky to
  * follow locking changes and looping.
  *
+ * If there are cached pages or we're extending the file, we need IOLOCK_EXCL
+ * until we're sure the bytes at the new EOF have been zeroed and/or the cached
+ * pages are flushed out.
+ *
+ * In most cases the direct IO writes will be done holding IOLOCK_SHARED
+ * allowing them to be done in parallel with reads and other direct IO writes.
+ * However, if the IO is not aligned to filesystem blocks, the direct IO layer
+ * needs to do sub-block zeroing and that requires serialisation against other
+ * direct IOs to the same block. In this case we need to serialise the
+ * submission of the unaligned IOs so that we don't get racing block zeroing in
+ * the dio layer.  To avoid the problem with aio, we also need to wait for
+ * outstanding IOs to complete so that unwritten extent conversion is completed
+ * before we try to map the overlapping block. This is currently implemented by
+ * hitting it with a big hammer (i.e. xfs_ioend_wait()).
+ *
  * Returns with locks held indicated by @iolock and errors indicated by
  * negative return values.
  */
@@ -699,6 +714,7 @@ xfs_file_dio_aio_write(
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 	size_t			count = ocount;
+	int			unaligned_io = 0;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
@@ -706,13 +722,10 @@ xfs_file_dio_aio_write(
 	if ((pos & target->bt_smask) || (count & target->bt_smask))
 		return -XFS_ERROR(EINVAL);
 
-	/*
-	 * For direct I/O, if there are cached pages or we're extending
-	 * the file, we need IOLOCK_EXCL until we're sure the bytes at
-	 * the new EOF have been zeroed and/or the cached pages are
-	 * flushed out.
-	 */
-	if (mapping->nrpages || pos > ip->i_size)
+	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+		unaligned_io = 1;
+
+	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
@@ -729,8 +742,13 @@ xfs_file_dio_aio_write(
 			return ret;
 	}
 
-	if (*iolock == XFS_IOLOCK_EXCL) {
-		/* demote the lock now the cached pages are gone */
+	/*
+	 * If we are doing unaligned IO, wait for all other IO to drain,
+	 * otherwise demote the lock if we had to flush cached pages
+	 */
+	if (unaligned_io)
+		xfs_ioend_wait(ip);
+	else if (*iolock == XFS_IOLOCK_EXCL) {
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		*iolock = XFS_IOLOCK_SHARED;
 	}
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
