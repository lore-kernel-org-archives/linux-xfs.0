Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13N7Sxw251063 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 17:07:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3B5C1C9F344
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 15:08:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	nG1hZjoQx0xLyHHh for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2010 15:08:36 -0800 (PST)
Date: Thu, 4 Feb 2010 10:08:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: move the inode locking outside xfs_fsync()
Message-ID: <20100203230833.GC5332@discord.disaster>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-9-git-send-email-david@fromorbit.com>
	<20100203112917.GB19996@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203112917.GB19996@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 06:29:17AM -0500, Christoph Hellwig wrote:
> On Wed, Feb 03, 2010 at 10:25:02AM +1100, Dave Chinner wrote:
> > We have a need for a delayed write inode flush operation
> > to be made atomically with an fsync to avoid physically
> > writing inodes but still keeping inode buffer information
> > up to date for bulkstat.
> > 
> > Move the inode locking outside xfs_fsync() to allow this to
> > be done.
> 
> What's the point of the lock_flags argument?  It should always
> be IOLOCK_SHARED, so instead of passing it in as an argument
> I'd rather add an assert to enforce it.

Fair enough. Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: move the inode locking outside xfs_fsync() V2

We have a need for a delayed write inode flush operation
to be made atomically with an fsync to avoid physically
writing inodes but still keeping inode buffer information
up to date for bulkstat.

Move the inode locking outside xfs_fsync() to allow this to
be done.

Version 2
- kill the lock_flags argument and simply assert XFS_IOLOCK_SHARED
  in xfs_fsync().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    6 +++++-
 fs/xfs/linux-2.6/xfs_lrw.c  |    3 ++-
 fs/xfs/xfs_vnodeops.c       |   29 +++++++++++++----------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index e4caeb2..94d9d6d 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -177,9 +177,13 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	int			error;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	return -xfs_fsync(ip);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = -xfs_fsync(ip);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index c80fa00..d7f1a71 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -754,11 +754,12 @@ write_retry:
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_ilock(xip, iolock);
+		xfs_ilock(xip, iolock | XFS_ILOCK_SHARED);
 
 		error2 = xfs_fsync(xip);
 		if (!error)
 			error = error2;
+		xfs_iunlock(xip, XFS_ILOCK_SHARED);
 	}
 
  out_unlock_internal:
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 43241e2..b5689a4 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -590,6 +590,17 @@ xfs_readlink(
  * the I/O lock while flushing the data, and the inode lock while flushing the
  * inode.  The inode lock CANNOT be held while flushing the data, so acquire
  * after we're done with that.
+ *
+ * We always need to make sure that the required inode state is safe on disk.
+ * The inode might be clean but we still might need to force the log because of
+ * committed transactions that haven't hit the disk yet.  Likewise, there could
+ * be unflushed non-transactional changes to the inode core that have to go to
+ * disk and this requires us to issue a synchronous transaction to capture
+ * these changes correctly.
+ *
+ * This code relies on the assumption that if the update_* fields of the inode
+ * are clear and the inode is unpinned then it is clean and no action is
+ * required.
  */
 int
 xfs_fsync(
@@ -600,24 +611,11 @@ xfs_fsync(
 	int		log_flushed = 0;
 
 	xfs_itrace_entry(ip);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return XFS_ERROR(EIO);
 
-	/*
-	 * We always need to make sure that the required inode state is safe on
-	 * disk.  The inode might be clean but we still might need to force the
-	 * log because of committed transactions that haven't hit the disk yet.
-	 * Likewise, there could be unflushed non-transactional changes to the
-	 * inode core that have to go to disk and this requires us to issue
-	 * a synchronous transaction to capture these changes correctly.
-	 *
-	 * This code relies on the assumption that if the update_* fields
-	 * of the inode are clear and the inode is unpinned then it is clean
-	 * and no action is required.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
 	if (!ip->i_update_core) {
 		/*
 		 * Timestamps/size haven't changed since last inode flush or
@@ -627,7 +625,6 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
 					       &log_flushed);
@@ -662,7 +659,7 @@ xfs_fsync(
 		xfs_trans_set_sync(tp);
 		error = _xfs_trans_commit(tp, 0, &log_flushed);
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
 	}
 
 	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
