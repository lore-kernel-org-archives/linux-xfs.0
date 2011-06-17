Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HDFNJJ120066 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 08:15:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A30051D7617A
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 06:15:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1ENb5UZyMjU0M7hf for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 06:15:21 -0700 (PDT)
Date: Fri, 17 Jun 2011 09:15:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: split xfs_setattr
Message-ID: <20110617131519.GA2822@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Split up xfs_setattr into two functions, one for the complex truncate
handling, and one for the trivial attribute updates.  Also move both
new routines to xfs_iops.c as they are fairly Linux-specific.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2011-06-17 14:07:57.059091534 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2011-06-17 14:18:42.495725522 +0200
@@ -39,6 +39,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_inode_item.h"
 #include "xfs_trace.h"
 
 #include <linux/capability.h>
@@ -497,12 +498,452 @@ xfs_vn_getattr(
 	return 0;
 }
 
+int
+xfs_setattr_simple(
+	struct xfs_inode	*ip,
+	struct iattr		*iattr,
+	int			flags)
+{
+	xfs_mount_t		*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			mask = iattr->ia_valid;
+	xfs_trans_t		*tp;
+	int			error;
+	uint			lock_flags = 0;
+	uid_t			uid = 0, iuid = 0;
+	gid_t			gid = 0, igid = 0;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
+	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+
+	trace_xfs_setattr(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	error = -inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	ASSERT((mask & ATTR_SIZE) == 0);
+
+	/*
+	 * If disk quotas is on, we make sure that the dquots do exist on disk,
+	 * before we start any other transactions. Trying to do this later
+	 * is messy. We don't care to take a readlock to look at the ids
+	 * in inode here, because we can't hold it across the trans_reserve.
+	 * If the IDs do change before we take the ilock, we're covered
+	 * because the i_*dquot fields will get updated anyway.
+	 */
+	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
+		uint	qflags = 0;
+
+		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
+			uid = iattr->ia_uid;
+			qflags |= XFS_QMOPT_UQUOTA;
+		} else {
+			uid = ip->i_d.di_uid;
+		}
+		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
+			gid = iattr->ia_gid;
+			qflags |= XFS_QMOPT_GQUOTA;
+		}  else {
+			gid = ip->i_d.di_gid;
+		}
+
+		/*
+		 * We take a reference when we initialize udqp and gdqp,
+		 * so it is important that we never blindly double trip on
+		 * the same variable. See xfs_create() for an example.
+		 */
+		ASSERT(udqp == NULL);
+		ASSERT(gdqp == NULL);
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
+					 qflags, &udqp, &gdqp);
+		if (error)
+			return error;
+	}
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error)
+		goto error_return;
+
+	lock_flags = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lock_flags);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 */
+	if (mask & (ATTR_UID|ATTR_GID)) {
+		/*
+		 * These IDs could have changed since we last looked at them.
+		 * But, we're assured that if the ownership did change
+		 * while we didn't have the inode locked, inode's dquot(s)
+		 * would have changed also.
+		 */
+		iuid = ip->i_d.di_uid;
+		igid = ip->i_d.di_gid;
+		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
+		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
+
+		/*
+		 * Do a quota reservation only if uid/gid is actually
+		 * going to change.
+		 */
+		if (XFS_IS_QUOTA_RUNNING(mp) &&
+		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
+		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
+			ASSERT(tp);
+			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+						capable(CAP_FOWNER) ?
+						XFS_QMOPT_FORCE_RES : 0);
+			if (error)	/* out of quota */
+				goto error_return;
+		}
+	}
+
+	xfs_trans_ijoin(tp, ip);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 */
+	if (mask & (ATTR_UID|ATTR_GID)) {
+		/*
+		 * CAP_FSETID overrides the following restrictions:
+		 *
+		 * The set-user-ID and set-group-ID bits of a file will be
+		 * cleared upon successful return from chown()
+		 */
+		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
+		    !capable(CAP_FSETID))
+			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
+
+		/*
+		 * Change the ownerships and register quota modifications
+		 * in the transaction.
+		 */
+		if (iuid != uid) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
+				ASSERT(mask & ATTR_UID);
+				ASSERT(udqp);
+				olddquot1 = xfs_qm_vop_chown(tp, ip,
+							&ip->i_udquot, udqp);
+			}
+			ip->i_d.di_uid = uid;
+			inode->i_uid = uid;
+		}
+		if (igid != gid) {
+			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
+				ASSERT(!XFS_IS_PQUOTA_ON(mp));
+				ASSERT(mask & ATTR_GID);
+				ASSERT(gdqp);
+				olddquot2 = xfs_qm_vop_chown(tp, ip,
+							&ip->i_gdquot, gdqp);
+			}
+			ip->i_d.di_gid = gid;
+			inode->i_gid = gid;
+		}
+	}
+
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+
+		ip->i_d.di_mode &= S_IFMT;
+		ip->i_d.di_mode |= mode & ~S_IFMT;
+
+		inode->i_mode &= S_IFMT;
+		inode->i_mode |= mode & ~S_IFMT;
+	}
+
+	/*
+	 * Change file access or modified times.
+	 */
+	if (mask & ATTR_ATIME) {
+		inode->i_atime = iattr->ia_atime;
+		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_CTIME) {
+		inode->i_ctime = iattr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+
+	xfs_iunlock(ip, lock_flags);
+
+	/*
+	 * Release any dquot(s) the inode had kept before chown.
+	 */
+	xfs_qm_dqrele(olddquot1);
+	xfs_qm_dqrele(olddquot2);
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+
+	if (error)
+		return error;
+
+	/*
+	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
+	 * 	     update.  We could avoid this with linked transactions
+	 * 	     and passing down the transaction pointer all the way
+	 *	     to attr_set.  No previous user of the generic
+	 * 	     Posix ACL code seems to care about this issue either.
+	 */
+	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
+		error = -xfs_acl_chmod(inode);
+		if (error)
+			return XFS_ERROR(error);
+	}
+
+	return 0;
+
+error_return:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	if (tp)
+		xfs_trans_cancel(tp, 0);
+	if (lock_flags != 0)
+		xfs_iunlock(ip, lock_flags);
+	return error;
+}
+
+/*
+ * Truncate file.  Must have write permission and not be a directory.
+ */
+int
+xfs_setattr_size(
+	struct xfs_inode	*ip,
+	struct iattr		*iattr,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			mask = iattr->ia_valid;
+	struct xfs_trans	*tp;
+	int			error;
+	uint			lock_flags;
+	uint			commit_flags = 0;
+
+	trace_xfs_setattr(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	error = -inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	ASSERT(S_ISREG(ip->i_d.di_mode));
+	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
+			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+
+	lock_flags = XFS_ILOCK_EXCL;
+	if (!(flags & XFS_ATTR_NOLOCK))
+		lock_flags |= XFS_IOLOCK_EXCL;
+	xfs_ilock(ip, lock_flags);
+
+	/*
+	 * Short circuit the truncate case for zero length files.
+	 */
+	if (iattr->ia_size == 0 &&
+	    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		lock_flags &= ~XFS_ILOCK_EXCL;
+		if (mask & ATTR_CTIME) {
+			inode->i_mtime = inode->i_ctime =
+					current_fs_time(inode->i_sb);
+			xfs_mark_inode_dirty_sync(ip);
+		}
+		goto out_unlock;
+	}
+
+	/*
+	 * Make sure that the dquots are attached to the inode.
+	 */
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * Now we can make the changes.  Before we join the inode to the
+	 * transaction, take care of the part of the truncation that must be
+	 * done without the inode lock.  This needs to be done before joining
+	 * the inode to the transaction, because the inode cannot be unlocked
+	 * once it is a part of the transaction.
+	 */
+	if (iattr->ia_size > ip->i_size) {
+		/*
+		 * Do the first part of growing a file: zero any data in the
+		 * last block that is beyond the old EOF.  We need to do this
+		 * before the inode is joined to the transaction to modify
+		 * i_size.
+		 */
+		error = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
+		if (error)
+			goto out_unlock;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	lock_flags &= ~XFS_ILOCK_EXCL;
+
+	/*
+	 * We are going to log the inode size change in this transaction so
+	 * any previous writes that are beyond the on disk EOF and the new
+	 * EOF that have not been written out need to be written here.  If we
+	 * do not write the data out, we expose ourselves to the null files
+	 * problem.
+	 *
+	 * Only flush from the on disk size to the smaller of the in memory
+	 * file size or the new size as that's the range we really care about
+	 * here and prevents waiting for other data not within the range we
+	 * care about here.
+	 */
+	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
+		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size,
+					XBF_ASYNC, FI_NONE);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * Wait for all I/O to complete.
+	 */
+	xfs_ioend_wait(ip);
+
+	error = -block_truncate_page(inode->i_mapping, iattr->ia_size,
+				     xfs_get_blocks);
+	if (error)
+		goto out_unlock;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
+	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
+				 XFS_TRANS_PERM_LOG_RES,
+				 XFS_ITRUNCATE_LOG_COUNT);
+	if (error)
+		goto out_trans_cancel;
+
+	truncate_setsize(inode, iattr->ia_size);
+
+	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
+	lock_flags |= XFS_ILOCK_EXCL;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, ip);
+
+	/*
+	 * Only change the c/mtime if we are changing the size or we are
+	 * explicitly asked to change it.  This handles the semantic difference
+	 * between truncate() and ftruncate() as implemented in the VFS.
+	 *
+	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
+	 * special case where we need to update the times despite not having
+	 * these flags set.  For all other operations the VFS set these flags
+	 * explicitly if it wants a timestamp update.
+	 */
+	if (iattr->ia_size != ip->i_size &&
+	    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
+		iattr->ia_ctime = iattr->ia_mtime =
+			current_fs_time(inode->i_sb);
+		mask |= ATTR_CTIME | ATTR_MTIME;
+	}
+
+	if (iattr->ia_size > ip->i_size) {
+		ip->i_d.di_size = iattr->ia_size;
+		ip->i_size = iattr->ia_size;
+	} else if (iattr->ia_size <= ip->i_size ||
+		   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
+		/*
+		 * Signal a sync transaction unless we are truncating an
+		 * already unlinked file on a wsync filesystem.
+		 */
+		error = xfs_itruncate_finish(&tp, ip, iattr->ia_size,
+				    XFS_DATA_FORK,
+				    ((ip->i_d.di_nlink != 0 ||
+				      !(mp->m_flags & XFS_MOUNT_WSYNC))
+				     ? 1 : 0));
+		if (error)
+			goto out_trans_abort;
+
+		/*
+		 * Truncated "down", so we're removing references to old data
+		 * here - if we delay flushing for a long time, we expose
+		 * ourselves unduly to the notorious NULL files problem.  So,
+		 * we mark this inode and flush it when the file is closed,
+		 * and do not wait the usual (long) time for writeout.
+		 */
+		xfs_iflags_set(ip, XFS_ITRUNCATED);
+	}
+
+	if (mask & ATTR_CTIME) {
+		inode->i_ctime = iattr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+	if (mask & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_update_core = 1;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	goto out_unlock;
+
+out_trans_abort:
+	commit_flags |= XFS_TRANS_ABORT;
+out_trans_cancel:
+	xfs_trans_cancel(tp, commit_flags);
+out_unlock:
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
+	return error;
+}
+
 STATIC int
 xfs_vn_setattr(
 	struct dentry	*dentry,
 	struct iattr	*iattr)
 {
-	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0);
+	if (iattr->ia_valid & ATTR_SIZE)
+		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
+	return -xfs_setattr_simple(XFS_I(dentry->d_inode), iattr, 0);
 }
 
 #define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
Index: xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_acl.c	2011-06-09 11:50:25.016311672 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_acl.c	2011-06-17 14:18:42.495725522 +0200
@@ -264,7 +264,7 @@ xfs_set_mode(struct inode *inode, mode_t
 		iattr.ia_mode = mode;
 		iattr.ia_ctime = current_fs_time(inode->i_sb);
 
-		error = -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
+		error = -xfs_setattr_simple(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
 	}
 
 	return error;
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2011-06-17 14:07:57.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2011-06-17 14:18:42.499058855 +0200
@@ -944,7 +944,7 @@ xfs_file_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 out_unlock:
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-06-09 11:50:25.039645004 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-06-17 14:18:42.499058855 +0200
@@ -50,430 +50,6 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
-int
-xfs_setattr(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
-{
-	xfs_mount_t		*mp = ip->i_mount;
-	struct inode		*inode = VFS_I(ip);
-	int			mask = iattr->ia_valid;
-	xfs_trans_t		*tp;
-	int			code;
-	uint			lock_flags;
-	uint			commit_flags=0;
-	uid_t			uid=0, iuid=0;
-	gid_t			gid=0, igid=0;
-	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
-	int			need_iolock = 1;
-
-	trace_xfs_setattr(ip);
-
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	code = -inode_change_ok(inode, iattr);
-	if (code)
-		return code;
-
-	olddquot1 = olddquot2 = NULL;
-	udqp = gdqp = NULL;
-
-	/*
-	 * If disk quotas is on, we make sure that the dquots do exist on disk,
-	 * before we start any other transactions. Trying to do this later
-	 * is messy. We don't care to take a readlock to look at the ids
-	 * in inode here, because we can't hold it across the trans_reserve.
-	 * If the IDs do change before we take the ilock, we're covered
-	 * because the i_*dquot fields will get updated anyway.
-	 */
-	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
-		uint	qflags = 0;
-
-		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
-			uid = iattr->ia_uid;
-			qflags |= XFS_QMOPT_UQUOTA;
-		} else {
-			uid = ip->i_d.di_uid;
-		}
-		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
-			gid = iattr->ia_gid;
-			qflags |= XFS_QMOPT_GQUOTA;
-		}  else {
-			gid = ip->i_d.di_gid;
-		}
-
-		/*
-		 * We take a reference when we initialize udqp and gdqp,
-		 * so it is important that we never blindly double trip on
-		 * the same variable. See xfs_create() for an example.
-		 */
-		ASSERT(udqp == NULL);
-		ASSERT(gdqp == NULL);
-		code = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
-		if (code)
-			return code;
-	}
-
-	/*
-	 * For the other attributes, we acquire the inode lock and
-	 * first do an error checking pass.
-	 */
-	tp = NULL;
-	lock_flags = XFS_ILOCK_EXCL;
-	if (flags & XFS_ATTR_NOLOCK)
-		need_iolock = 0;
-	if (!(mask & ATTR_SIZE)) {
-		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-		commit_flags = 0;
-		code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp),
-					 0, 0, 0);
-		if (code) {
-			lock_flags = 0;
-			goto error_return;
-		}
-	} else {
-		if (need_iolock)
-			lock_flags |= XFS_IOLOCK_EXCL;
-	}
-
-	xfs_ilock(ip, lock_flags);
-
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
-		/*
-		 * These IDs could have changed since we last looked at them.
-		 * But, we're assured that if the ownership did change
-		 * while we didn't have the inode locked, inode's dquot(s)
-		 * would have changed also.
-		 */
-		iuid = ip->i_d.di_uid;
-		igid = ip->i_d.di_gid;
-		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
-		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
-
-		/*
-		 * Do a quota reservation only if uid/gid is actually
-		 * going to change.
-		 */
-		if (XFS_IS_QUOTA_RUNNING(mp) &&
-		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
-		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
-			ASSERT(tp);
-			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
-			if (code)	/* out of quota */
-				goto error_return;
-		}
-	}
-
-	/*
-	 * Truncate file.  Must have write permission and not be a directory.
-	 */
-	if (mask & ATTR_SIZE) {
-		/* Short circuit the truncate case for zero length files */
-		if (iattr->ia_size == 0 &&
-		    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			lock_flags &= ~XFS_ILOCK_EXCL;
-			if (mask & ATTR_CTIME) {
-				inode->i_mtime = inode->i_ctime =
-						current_fs_time(inode->i_sb);
-				xfs_mark_inode_dirty_sync(ip);
-			}
-			code = 0;
-			goto error_return;
-		}
-
-		if (S_ISDIR(ip->i_d.di_mode)) {
-			code = XFS_ERROR(EISDIR);
-			goto error_return;
-		} else if (!S_ISREG(ip->i_d.di_mode)) {
-			code = XFS_ERROR(EINVAL);
-			goto error_return;
-		}
-
-		/*
-		 * Make sure that the dquots are attached to the inode.
-		 */
-		code = xfs_qm_dqattach_locked(ip, 0);
-		if (code)
-			goto error_return;
-
-		/*
-		 * Now we can make the changes.  Before we join the inode
-		 * to the transaction, if ATTR_SIZE is set then take care of
-		 * the part of the truncation that must be done without the
-		 * inode lock.  This needs to be done before joining the inode
-		 * to the transaction, because the inode cannot be unlocked
-		 * once it is a part of the transaction.
-		 */
-		if (iattr->ia_size > ip->i_size) {
-			/*
-			 * Do the first part of growing a file: zero any data
-			 * in the last block that is beyond the old EOF.  We
-			 * need to do this before the inode is joined to the
-			 * transaction to modify the i_size.
-			 */
-			code = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
-			if (code)
-				goto error_return;
-		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		lock_flags &= ~XFS_ILOCK_EXCL;
-
-		/*
-		 * We are going to log the inode size change in this
-		 * transaction so any previous writes that are beyond the on
-		 * disk EOF and the new EOF that have not been written out need
-		 * to be written here. If we do not write the data out, we
-		 * expose ourselves to the null files problem.
-		 *
-		 * Only flush from the on disk size to the smaller of the in
-		 * memory file size or the new size as that's the range we
-		 * really care about here and prevents waiting for other data
-		 * not within the range we care about here.
-		 */
-		if (ip->i_size != ip->i_d.di_size &&
-		    iattr->ia_size > ip->i_d.di_size) {
-			code = xfs_flush_pages(ip,
-					ip->i_d.di_size, iattr->ia_size,
-					XBF_ASYNC, FI_NONE);
-			if (code)
-				goto error_return;
-		}
-
-		/* wait for all I/O to complete */
-		xfs_ioend_wait(ip);
-
-		code = -block_truncate_page(inode->i_mapping, iattr->ia_size,
-					    xfs_get_blocks);
-		if (code)
-			goto error_return;
-
-		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-		code = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-					 XFS_TRANS_PERM_LOG_RES,
-					 XFS_ITRUNCATE_LOG_COUNT);
-		if (code)
-			goto error_return;
-
-		truncate_setsize(inode, iattr->ia_size);
-
-		commit_flags = XFS_TRANS_RELEASE_LOG_RES;
-		lock_flags |= XFS_ILOCK_EXCL;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-		xfs_trans_ijoin(tp, ip);
-
-		/*
-		 * Only change the c/mtime if we are changing the size
-		 * or we are explicitly asked to change it. This handles
-		 * the semantic difference between truncate() and ftruncate()
-		 * as implemented in the VFS.
-		 *
-		 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME
-		 * is a special case where we need to update the times despite
-		 * not having these flags set.  For all other operations the
-		 * VFS set these flags explicitly if it wants a timestamp
-		 * update.
-		 */
-		if (iattr->ia_size != ip->i_size &&
-		    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
-			iattr->ia_ctime = iattr->ia_mtime =
-				current_fs_time(inode->i_sb);
-			mask |= ATTR_CTIME | ATTR_MTIME;
-		}
-
-		if (iattr->ia_size > ip->i_size) {
-			ip->i_d.di_size = iattr->ia_size;
-			ip->i_size = iattr->ia_size;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		} else if (iattr->ia_size <= ip->i_size ||
-			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
-			/*
-			 * signal a sync transaction unless
-			 * we're truncating an already unlinked
-			 * file on a wsync filesystem
-			 */
-			code = xfs_itruncate_finish(&tp, ip, iattr->ia_size,
-					    XFS_DATA_FORK,
-					    ((ip->i_d.di_nlink != 0 ||
-					      !(mp->m_flags & XFS_MOUNT_WSYNC))
-					     ? 1 : 0));
-			if (code)
-				goto abort_return;
-			/*
-			 * Truncated "down", so we're removing references
-			 * to old data here - if we now delay flushing for
-			 * a long time, we expose ourselves unduly to the
-			 * notorious NULL files problem.  So, we mark this
-			 * vnode and flush it when the file is closed, and
-			 * do not wait the usual (long) time for writeout.
-			 */
-			xfs_iflags_set(ip, XFS_ITRUNCATED);
-		}
-	} else if (tp) {
-		xfs_trans_ijoin(tp, ip);
-	}
-
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID)) {
-			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
-		}
-
-		/*
-		 * Change the ownerships and register quota modifications
-		 * in the transaction.
-		 */
-		if (iuid != uid) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
-				ASSERT(mask & ATTR_UID);
-				ASSERT(udqp);
-				olddquot1 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_udquot, udqp);
-			}
-			ip->i_d.di_uid = uid;
-			inode->i_uid = uid;
-		}
-		if (igid != gid) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(!XFS_IS_PQUOTA_ON(mp));
-				ASSERT(mask & ATTR_GID);
-				ASSERT(gdqp);
-				olddquot2 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
-			}
-			ip->i_d.di_gid = gid;
-			inode->i_gid = gid;
-		}
-	}
-
-	/*
-	 * Change file access modes.
-	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
-
-	/*
-	 * Change file access or modified times.
-	 */
-	if (mask & ATTR_ATIME) {
-		inode->i_atime = iattr->ia_atime;
-		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-	if (mask & ATTR_CTIME) {
-		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-	if (mask & ATTR_MTIME) {
-		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-		ip->i_update_core = 1;
-	}
-
-	/*
-	 * And finally, log the inode core if any attribute in it
-	 * has been changed.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID|ATTR_MODE|
-		    ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	XFS_STATS_INC(xs_ig_attrchg);
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
-	 * This is slightly sub-optimal in that truncates require
-	 * two sync transactions instead of one for wsync filesystems.
-	 * One for the truncate and one for the timestamps since we
-	 * don't want to change the timestamps unless we're sure the
-	 * truncate worked.  Truncates are less than 1% of the laddis
-	 * mix so this probably isn't worth the trouble to optimize.
-	 */
-	code = 0;
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(tp);
-
-	code = xfs_trans_commit(tp, commit_flags);
-
-	xfs_iunlock(ip, lock_flags);
-
-	/*
-	 * Release any dquot(s) the inode had kept before chown.
-	 */
-	xfs_qm_dqrele(olddquot1);
-	xfs_qm_dqrele(olddquot2);
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-
-	if (code)
-		return code;
-
-	/*
-	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
-	 * 	     update.  We could avoid this with linked transactions
-	 * 	     and passing down the transaction pointer all the way
-	 *	     to attr_set.  No previous user of the generic
-	 * 	     Posix ACL code seems to care about this issue either.
-	 */
-	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
-		code = -xfs_acl_chmod(inode);
-		if (code)
-			return XFS_ERROR(code);
-	}
-
-	return 0;
-
- abort_return:
-	commit_flags |= XFS_TRANS_ABORT;
- error_return:
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	if (tp) {
-		xfs_trans_cancel(tp, commit_flags);
-	}
-	if (lock_flags != 0) {
-		xfs_iunlock(ip, lock_flags);
-	}
-	return code;
-}
-
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 2 extents back from
@@ -2781,7 +2357,7 @@ xfs_change_file_space(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
-		error = xfs_setattr(ip, &iattr, attr_flags);
+		error = xfs_setattr_size(ip, &iattr, attr_flags);
 
 		if (error)
 			return error;
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2011-06-09 11:50:25.056311670 +0200
+++ xfs/fs/xfs/xfs_vnodeops.h	2011-06-17 14:18:42.502392188 +0200
@@ -13,7 +13,8 @@ struct xfs_inode;
 struct xfs_iomap;
 
 
-int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags);
+int xfs_setattr_simple(struct xfs_inode *ip, struct iattr *vap, int flags);
+int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
