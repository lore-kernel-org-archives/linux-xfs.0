Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6IHe9x8210469 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 12:40:09 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q6IHe939002543
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 12:40:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q6IHe9XE002542
	for xfs@oss.sgi.com; Wed, 18 Jul 2012 12:40:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120718220003.396849822@tinguelysgi.com>
Date: Tue, 18 Jul 2012 12:33:58 -0500
From: tinguely@sgi.com
Subject: [RFC] xfs: wait for the write of the superblock on unmount
References: <20120717215957.855744999@tinguelysgi.com>
Content-Disposition: inline; filename=xfs-lock_sbcount_wait.patch
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

Sorry, I have been distracted away from this regression. This was previously
titled "xfs: synchronously write the superblock on unmount".

xfs_wait_buftarg() does not wait for the completion of the write of the
uncached superblock. This write can race with the shutdown of the log and
causes a panic if the write does not win the race.

The log write of the superblock is important for possible recovery, but a
second syncronous write of the same superblock seems redundant. Would just
waiting for the iodone() of the log write before tearing down the log be
enough?

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_mount.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1457,6 +1457,7 @@ void
 xfs_unmountfs(
 	struct xfs_mount	*mp)
 {
+	struct xfs_buf		*bp = mp->m_sb_bp;
 	__uint64_t		resblks;
 	int			error;
 
@@ -1529,6 +1530,13 @@ xfs_unmountfs(
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
+	/*
+	 * Wait for the superblock to be written out. The superblock buffer
+	 * will remain locked until the iodone().
+	 */
+	xfs_buf_lock(bp);
+	xfs_buf_unlock(bp);
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
