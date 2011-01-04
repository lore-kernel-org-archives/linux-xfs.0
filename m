Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044kn6W175994 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:46:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B195230E29
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:48:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	8LhTzBxGmceL4r6L for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:48:56 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51671917-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:18:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZypJ-0000TJ-Fj
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:53 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZypH-0003ts-P0
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: serialise unaligned direct IOs
Date: Tue,  4 Jan 2011 15:48:38 +1100
Message-Id: <1294116518-14908-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1294116518-14908-1-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_file.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index f21b6ad..a91e1a8 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -678,10 +678,21 @@ xfs_file_aio_write_checks(
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
  * Returns with locks held indicated by @iolock and errors indicated by
  * negative return values.
  */
@@ -701,6 +712,7 @@ xfs_file_dio_aio_write(
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 	size_t			count = ocount;
+	int			unaligned_io = 0;
 	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
@@ -708,7 +720,10 @@ xfs_file_dio_aio_write(
 	if ((pos & target->bt_smask) || (count & target->bt_smask))
 		return -XFS_ERROR(EINVAL);
 
-	if (mapping->nrpages || pos > ip->i_size)
+	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+		unaligned_io = 1;
+
+	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
@@ -725,8 +740,13 @@ xfs_file_dio_aio_write(
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
