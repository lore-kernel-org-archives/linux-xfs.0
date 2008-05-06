Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 22:50:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m465oGff005559
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 22:50:18 -0700
Date: Tue, 6 May 2008 15:50:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Fix xfs_fsync() b0rkage
Message-ID: <20080506055055.GQ155679365@sgi.com>
References: <20080506022701.GN155679365@sgi.com> <20080506051916.GA7402@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506051916.GA7402@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 06, 2008 at 01:19:16AM -0400, Christoph Hellwig wrote:
> On Tue, May 06, 2008 at 12:27:01PM +1000, David Chinner wrote:
> > Fix fsync() b0rkage.
> > 
> > xfs_fsync() fails to wait for data I/O completion before checking if
> > the inode is dirty or clean to decide whether to log the inode or not.
> > This misses inode size updates when the data flushed by the fsync()
> > is extending the file. This results in xfsqa test 179 failures.
> > 
> > Hence, like fdatasync(), we need to wait for I/O completion first,
> > then check the inode for cleanliness. Doing so makes the behaviour of
> > xfs_fsync() identical for fsync and fdatasync and we *always* use
> > synchronous semantics if the inode is dirty. Therefore also kill the
> > differences and remove the unused flags from the xfs_fsync function
> > and callers.
> 
> The change looks good from a quick look, but while you're at it you
> can also remove the unused start/stop arguments.

Yup, good point. Updated patch below that also puts back the
clearing of the ITRUNCATED flag in the dmapi code.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Fix fsync() b0rkage.

xfs_fsync() fails to wait for data I/O completion before checking if
the inode is dirty or clean to decide whether to log the inode or not.
This misses inode size updates when the data flushed by the fsync()
is extending the file.

Hence, like fdatasync(), we need to wait for I/o completion first,
then check the inode for cleanliness. Doing so makes the behaviour of
xfs_fsync() identical for fsync and fdatasync and we *always* use
synchronous semantics if the inode is dirty. Therefore also kill the
differences and remove the unused flags from the xfs_fsync function
and callers.

Version 2:
o remove unused ranges from xfs_fsync() as well.
o still need to clear the XFS_ITRUNCATED flag in dmapi code

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/dmapi/xfs_dm.c        |    8 ---
 fs/xfs/linux-2.6/xfs_file.c  |   17 ++++--
 fs/xfs/linux-2.6/xfs_vnode.h |    8 ---
 fs/xfs/xfs_vnodeops.c        |  114 ++++++++++++++++---------------------------
 fs/xfs/xfs_vnodeops.h        |    3 -
 5 files changed, 57 insertions(+), 93 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2008-04-28 16:35:23.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2008-05-06 15:45:18.321651578 +1000
@@ -2880,19 +2880,15 @@ xfs_dm_sync_by_handle(
 	/* We need to protect against concurrent writers.. */
 	ret = filemap_fdatawrite(inode->i_mapping);
 	down_rw_sems(inode, DM_FLAGS_IMUX);
-	err = xfs_fsync(ip, FSYNC_WAIT, 0, -1);
+	err = -xfs_fsync(ip);
 	if (!ret)
 		ret = err;
 	up_rw_sems(inode, DM_FLAGS_IMUX);
 	err = filemap_fdatawait(inode->i_mapping);
 	if (!ret)
 		ret = err;
-
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	if (ret > 0)
-		ret = -ret;	/* Return negative errors to DMAPI */
-
-	return(ret);
+	return ret;
 }
 
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2008-03-13 13:07:24.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2008-05-06 15:32:35.640495883 +1000
@@ -187,19 +187,24 @@ xfs_file_release(
 	return -xfs_release(XFS_I(inode));
 }
 
+/*
+ * We ignore the datasync flag here because a datasync is effectively
+ * identical to an fsync. That is, datasync implies that we need to write
+ * only the metadata needed to be able to access the data that is written
+ * if we crash after the call completes. Hence if we are writing beyond
+ * EOF we have to log the inode size change as well, which makes it a
+ * full fsync. If we don't write beyond EOF, the inode core will be
+ * clean in memory and so we don't need to log the inode, just like
+ * fsync.
+ */
 STATIC int
 xfs_file_fsync(
 	struct file	*filp,
 	struct dentry	*dentry,
 	int		datasync)
 {
-	int		flags = FSYNC_WAIT;
-
-	if (datasync)
-		flags |= FSYNC_DATA;
 	xfs_iflags_clear(XFS_I(dentry->d_inode), XFS_ITRUNCATED);
-	return -xfs_fsync(XFS_I(dentry->d_inode), flags,
-			(xfs_off_t)0, (xfs_off_t)-1);
+	return -xfs_fsync(XFS_I(dentry->d_inode));
 }
 
 #ifdef HAVE_DMAPI
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-04-30 12:32:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-05-06 15:34:23.234545942 +1000
@@ -856,18 +856,14 @@ xfs_readlink(
 /*
  * xfs_fsync
  *
- * This is called to sync the inode and its data out to disk.
- * We need to hold the I/O lock while flushing the data, and
- * the inode lock while flushing the inode.  The inode lock CANNOT
- * be held while flushing the data, so acquire after we're done
- * with that.
+ * This is called to sync the inode and its data out to disk.  We need to hold
+ * the I/O lock while flushing the data, and the inode lock while flushing the
+ * inode.  The inode lock CANNOT be held while flushing the data, so acquire
+ * after we're done with that.
  */
 int
 xfs_fsync(
-	xfs_inode_t	*ip,
-	int		flag,
-	xfs_off_t	start,
-	xfs_off_t	stop)
+	xfs_inode_t	*ip)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -875,103 +871,79 @@ xfs_fsync(
 
 	xfs_itrace_entry(ip);
 
-	ASSERT(start >= 0 && stop >= -1);
-
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return XFS_ERROR(EIO);
 
-	if (flag & FSYNC_DATA)
-		filemap_fdatawait(vn_to_inode(XFS_ITOV(ip))->i_mapping);
+	/* capture size updates in I/O completion before writing the inode. */
+	error = filemap_fdatawait(vn_to_inode(XFS_ITOV(ip))->i_mapping);
+	if (error)
+		return XFS_ERROR(error);
 
 	/*
-	 * We always need to make sure that the required inode state
-	 * is safe on disk.  The vnode might be clean but because
-	 * of committed transactions that haven't hit the disk yet.
-	 * Likewise, there could be unflushed non-transactional
-	 * changes to the inode core that have to go to disk.
+	 * We always need to make sure that the required inode state is safe on
+	 * disk.  The vnode might be clean but we still might need to force the
+	 * log because of committed transactions that haven't hit the disk yet.
+	 * Likewise, there could be unflushed non-transactional changes to the
+	 * inode core that have to go to disk and this requires us to issue
+	 * a synchronous transaction to capture these changes correctly.
 	 *
-	 * The following code depends on one assumption:  that
-	 * any transaction that changes an inode logs the core
-	 * because it has to change some field in the inode core
-	 * (typically nextents or nblocks).  That assumption
-	 * implies that any transactions against an inode will
-	 * catch any non-transactional updates.  If inode-altering
-	 * transactions exist that violate this assumption, the
-	 * code breaks.  Right now, it figures that if the involved
-	 * update_* field is clear and the inode is unpinned, the
-	 * inode is clean.  Either it's been flushed or it's been
-	 * committed and the commit has hit the disk unpinning the inode.
-	 * (Note that xfs_inode_item_format() called at commit clears
-	 * the update_* fields.)
+	 * This code relies on the assumption that if the update_* fields
+	 * of the inode are clear and the inode is unpinned then it is clean
+	 * and no action is required.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	/* If we are flushing data then we care about update_size
-	 * being set, otherwise we care about update_core
-	 */
-	if ((flag & FSYNC_DATA) ?
-			(ip->i_update_size == 0) :
-			(ip->i_update_core == 0)) {
-		/*
-		 * Timestamps/size haven't changed since last inode
-		 * flush or inode transaction commit.  That means
-		 * either nothing got written or a transaction
-		 * committed which caught the updates.	If the
-		 * latter happened and the transaction hasn't
-		 * hit the disk yet, the inode will be still
-		 * be pinned.  If it is, force the log.
+	if (!(ip->i_update_size || ip->i_update_core)) {
+		/*
+		 * Timestamps/size haven't changed since last inode flush or
+		 * inode transaction commit.  That means either nothing got
+		 * written or a transaction committed which caught the updates.
+		 * If the latter happened and the transaction hasn't hit the
+		 * disk yet, the inode will be still be pinned.  If it is,
+		 * force the log.
 		 */
 
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 		if (xfs_ipincount(ip)) {
-			_xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
-				      XFS_LOG_FORCE |
-				      ((flag & FSYNC_WAIT)
-				       ? XFS_LOG_SYNC : 0),
+			error = _xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
+				      XFS_LOG_FORCE | XFS_LOG_SYNC,
 				      &log_flushed);
 		} else {
 			/*
-			 * If the inode is not pinned and nothing
-			 * has changed we don't need to flush the
-			 * cache.
+			 * If the inode is not pinned and nothing has changed
+			 * we don't need to flush the cache.
 			 */
 			changed = 0;
 		}
-		error = 0;
 	} else	{
 		/*
-		 * Kick off a transaction to log the inode
-		 * core to get the updates.  Make it
-		 * sync if FSYNC_WAIT is passed in (which
-		 * is done by everybody but specfs).  The
-		 * sync transaction will also force the log.
+		 * Kick off a transaction to log the inode core to get the
+		 * updates.  The sync transaction will also force the log.
 		 */
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
-		if ((error = xfs_trans_reserve(tp, 0,
-				XFS_FSYNC_TS_LOG_RES(ip->i_mount),
-				0, 0, 0)))  {
+		error = xfs_trans_reserve(tp, 0,
+				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
+		if (error) {
 			xfs_trans_cancel(tp, 0);
 			return error;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 		/*
-		 * Note - it's possible that we might have pushed
-		 * ourselves out of the way during trans_reserve
-		 * which would flush the inode.	 But there's no
-		 * guarantee that the inode buffer has actually
-		 * gone out yet (it's delwri).	Plus the buffer
-		 * could be pinned anyway if it's part of an
-		 * inode in another recent transaction.	 So we
-		 * play it safe and fire off the transaction anyway.
+		 * Note - it's possible that we might have pushed ourselves out
+		 * of the way during trans_reserve which would flush the inode.
+		 * But there's no guarantee that the inode buffer has actually
+		 * gone out yet (it's delwri).	Plus the buffer could be pinned
+		 * anyway if it's part of an inode in another recent
+		 * transaction.	 So we play it safe and fire off the
+		 * transaction anyway.
 		 */
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		xfs_trans_ihold(tp, ip);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		if (flag & FSYNC_WAIT)
-			xfs_trans_set_sync(tp);
+		xfs_trans_set_sync(tp);
 		error = _xfs_trans_commit(tp, 0, &log_flushed);
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.h	2008-04-30 12:32:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.h	2008-05-06 15:34:35.472959313 +1000
@@ -18,8 +18,7 @@ int xfs_open(struct xfs_inode *ip);
 int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
 		struct cred *credp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
-int xfs_fsync(struct xfs_inode *ip, int flag, xfs_off_t start,
-		xfs_off_t stop);
+int xfs_fsync(struct xfs_inode *ip);
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-04-30 12:32:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h	2008-05-06 11:53:21.223604472 +1000
@@ -230,14 +230,6 @@ static inline void vn_atime_to_time_t(bh
 #define ATTR_NOSIZETOK	0x400	/* Don't get the SIZE token */
 
 /*
- * Flags to vop_fsync/reclaim.
- */
-#define FSYNC_NOWAIT	0	/* asynchronous flush */
-#define FSYNC_WAIT	0x1	/* synchronous fsync or forced reclaim */
-#define FSYNC_INVAL	0x2	/* flush and invalidate cached data */
-#define FSYNC_DATA	0x4	/* synchronous fsync of data only */
-
-/*
  * Tracking vnode activity.
  */
 #if defined(XFS_INODE_TRACE)
