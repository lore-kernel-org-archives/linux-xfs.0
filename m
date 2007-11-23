Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 23:05:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAN75mdj018862
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 23:05:52 -0800
Message-ID: <47467B87.2000000@sgi.com>
Date: Fri, 23 Nov 2007 18:04:39 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH, RFC] Delayed logging of file sizes
Content-Type: multipart/mixed;
 boundary="------------070405030101040701060405"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------070405030101040701060405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here's a patch for an idea to address an issue we have with log
replay.  The problem stems from the fact that not all changes to
inodes result in transactions.  Some changes (such as file size
updates, timestamp updates) would generate too much log traffic
if we logged a transaction for every event.  So we update the inode
and flag it as dirty (ie set i_update_core/i_update_size).  If the
inode gets logged in a later transaction then the update gets
rolled into that transaction and the flag is cleared.  If the inode
gets flushed to disk before another transaction then the on-disk
version of the inode is newer than what is in the log.

On log replay we risk overwriting a newer inode on disk with an
older version of the inode from the log.  We try to prevent this with
the i_flushiter counter in the inode (the on-disk inode will have a
greater flushiter than the inode in the log) but this does not work
for newly created inode cluster buffers.  When log replay encounters
a newly allocated inode cluster buffer in the log it cannot determine
if the on-disk version of the cluster is older, newer or even valid.
Since we cannot determine if the on-disk inode cluster has been
initialised since it was logged we cannot read it to check the
i_flushiter values.  If we write out the log record anyway we risk
overwriting newer inode data, if we don't write out the log record
we risk exposing an uninitialised inode cluster.

The easy solution is to log everything so that log replay doesn't need
to check if the on-disk version is newer - it can just replay the log.
But logging everything would cause too much log traffic so this patch
is a compromise and it logs a transaction before we flush an inode to
disk only if it has changes that have not yet been logged.  With this
scheme we don't clear the i_update_core flag when flushing an inode -
we only do that when logging a transaction.  The flag is used to
determine if a transaction needs to be done.  It needs to be this way
because the log pushing code may need to flush an inode and we cannot
create a transaction at that point.

Anyway it's an idea and needs a little polishing so comments are welcome.

Lachlan

--------------070405030101040701060405
Content-Type: text/x-patch;
 name="logsize.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="logsize.diff"

--- fs/xfs/xfs_inode.c_1.487	2007-11-23 14:18:58.000000000 +1100
+++ fs/xfs/xfs_inode.c	2007-11-23 14:20:55.000000000 +1100
@@ -3331,21 +3331,6 @@ xfs_iflush_int(
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_boffset);
 
 	/*
-	 * Clear i_update_core before copying out the data.
-	 * This is for coordination with our timestamp updates
-	 * that don't hold the inode lock. They will always
-	 * update the timestamps BEFORE setting i_update_core,
-	 * so if we clear i_update_core after they set it we
-	 * are guaranteed to see their updates to the timestamps.
-	 * I believe that this depends on strongly ordered memory
-	 * semantics, but we have that.  We use the SYNCHRONIZE
-	 * macro to make sure that the compiler does not reorder
-	 * the i_update_core access below the data copy below.
-	 */
-	ip->i_update_core = 0;
-	SYNCHRONIZE();
-
-	/*
 	 * Make sure to get the latest atime from the Linux inode.
 	 */
 	xfs_synchronize_atime(ip);
--- fs/xfs/xfs_vfsops.c_1.548	2007-11-23 14:26:52.000000000 +1100
+++ fs/xfs/xfs_vfsops.c	2007-11-23 14:18:03.000000000 +1100
@@ -1162,6 +1162,12 @@ xfs_sync_inodes(
 			if (mount_locked)
 				IPOINTER_INSERT(ip, mp);
 
+			if (ip->i_update_core) {
+				xfs_iunlock(ip, XFS_ILOCK_SHARED);
+				error = xfs_log_inode(ip, flags & SYNC_WAIT);
+				xfs_ilock(ip, XFS_ILOCK_SHARED);
+			}
+
 			if (flags & SYNC_WAIT) {
 				xfs_iflock(ip);
 				error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
--- fs/xfs/xfs_vnodeops.c_1.726	2007-11-23 14:26:53.000000000 +1100
+++ fs/xfs/xfs_vnodeops.c	2007-11-23 14:18:03.000000000 +1100
@@ -3527,6 +3527,39 @@ xfs_rwunlock(
 
 
 int
+xfs_log_inode(
+	xfs_inode_t	*ip,
+	int		sync)
+{
+	xfs_trans_t	*tp;
+	int		error;
+
+	xfs_itrace_entry(ip);
+
+	if (ip->i_update_core == 0)
+		return 0;
+
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
+	if ((error = xfs_trans_reserve(tp, 0,
+			XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0))) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_synchronize_atime(ip);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ihold(tp, ip);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	if (sync)
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
+
+int
 xfs_inode_flush(
 	xfs_inode_t	*ip,
 	int		flags)
@@ -3579,6 +3612,10 @@ xfs_inode_flush(
 	if (flags & FLUSH_INODE) {
 		int	flush_flags;
 
+		error = xfs_log_inode(ip, flags & FLUSH_SYNC);
+		if (error)
+			return error;
+
 		if (flags & FLUSH_SYNC) {
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
 			xfs_iflock(ip);
@@ -3751,6 +3788,15 @@ xfs_finish_reclaim(
 		if (ip->i_update_core ||
 		    ((ip->i_itemp != NULL) &&
 		     (ip->i_itemp->ili_format.ilf_fields != 0))) {
+
+			if (ip->i_update_core) {
+				xfs_ifunlock(ip);
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				error = xfs_log_inode(ip, sync_mode & XFS_IFLUSH_SYNC);
+				xfs_ilock(ip, XFS_ILOCK_EXCL);
+				xfs_iflock(ip);
+			}
+
 			error = xfs_iflush(ip, sync_mode);
 			/*
 			 * If we hit an error, typically because of filesystem
--- fs/xfs/xfs_vnodeops.h_1.4	2007-10-04 14:53:13.000000000 +1000
+++ fs/xfs/xfs_vnodeops.h	2007-10-04 18:11:51.000000000 +1000
@@ -80,4 +80,6 @@ int xfs_flushinval_pages(struct xfs_inod
 int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, uint64_t flags, int fiopt);
 
+int xfs_log_inode(struct xfs_inode *ip, int sync);
+
 #endif /* _XFS_VNODEOPS_H */

--------------070405030101040701060405--
