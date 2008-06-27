Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 08:45:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RFj3Xg028871
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:45:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2628D293AE4
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:02 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id upWt4Z8L9wavgdha for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:02 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5RFjrNW031768
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:45:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5RFjr8i031766
	for xfs@oss.sgi.com; Fri, 27 Jun 2008 17:45:53 +0200
Date: Fri, 27 Jun 2008 17:45:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] split out xfs value-add from xfs_setattr
Message-ID: <20080627154553.GA31476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_setattr currently doesn't just handle the attributes set through
->setattr but also addition XFS-specific attributes: project id, inode
flags and extent size hint.  Having these in a single function makes it
more complicated and forces to have us a bhv_vattr intermediate
structure eating up stackspace.

This patch adds a new xfs_ioctl_setattr helper for the XFS ioctls that
set these attributes and remove the code to set them through
xfs_setattr.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-15 16:41:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-15 16:42:18.000000000 +0200
@@ -47,6 +47,8 @@
 #include "xfs_dfrag.h"
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
+#include "xfs_quota.h"
+#include "xfs_inode_item.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -875,6 +877,297 @@ xfs_ioc_fsgetxattr(
 	return 0;
 }
 
+STATIC void
+xfs_set_diflags(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	unsigned int		di_flags;
+
+	/* can't set PREALLOC this way, just preserve it */
+	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+	if (xflags & XFS_XFLAG_IMMUTABLE)
+		di_flags |= XFS_DIFLAG_IMMUTABLE;
+	if (xflags & XFS_XFLAG_APPEND)
+		di_flags |= XFS_DIFLAG_APPEND;
+	if (xflags & XFS_XFLAG_SYNC)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if (xflags & XFS_XFLAG_NOATIME)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if (xflags & XFS_XFLAG_NODUMP)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if (xflags & XFS_XFLAG_PROJINHERIT)
+		di_flags |= XFS_DIFLAG_PROJINHERIT;
+	if (xflags & XFS_XFLAG_NODEFRAG)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (xflags & XFS_XFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
+		if (xflags & XFS_XFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (xflags & XFS_XFLAG_NOSYMLINKS)
+			di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		if (xflags & XFS_XFLAG_EXTSZINHERIT)
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+	} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
+		if (xflags & XFS_XFLAG_REALTIME)
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (xflags & XFS_XFLAG_EXTSIZE)
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+	}
+
+	ip->i_d.di_flags = di_flags;
+}
+
+
+#define FSX_PROJID	1
+#define FSX_EXTSIZE	2
+#define FSX_XFLAGS	4
+#define FSX_NONBLOCK	8
+
+STATIC int
+xfs_ioctl_setattr(
+	xfs_inode_t		*ip,
+	struct fsxattr		*fa,
+	int			mask)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	unsigned int		lock_flags = 0;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
+	struct xfs_dquot	*olddquot = NULL;
+	int			code;
+
+	xfs_itrace_entry(ip);
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return XFS_ERROR(EROFS);
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	/*
+	 * If disk quotas is on, we make sure that the dquots do exist on disk,
+	 * before we start any other transactions. Trying to do this later
+	 * is messy. We don't care to take a readlock to look at the ids
+	 * in inode here, because we can't hold it across the trans_reserve.
+	 * If the IDs do change before we take the ilock, we're covered
+	 * because the i_*dquot fields will get updated anyway.
+	 */
+	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
+		code = XFS_QM_DQVOPALLOC(mp, ip, ip->i_d.di_uid,
+					 ip->i_d.di_gid, fa->fsx_projid,
+					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
+		if (code)
+			return code;
+	}
+
+	/*
+	 * For the other attributes, we acquire the inode lock and
+	 * first do an error checking pass.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (code)
+		goto error_return;
+
+	lock_flags = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lock_flags);
+
+	/*
+	 * CAP_FOWNER overrides the following restrictions:
+	 *
+	 * The user ID of the calling process must be equal
+	 * to the file owner ID, except in cases where the
+	 * CAP_FSETID capability is applicable.
+	 */
+	if (current->fsuid != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+		code = XFS_ERROR(EPERM);
+		goto error_return;
+	}
+
+	/*
+	 * Do a quota reservation only if projid is actually going to change.
+	 */
+	if (mask & FSX_PROJID) {
+		if (XFS_IS_PQUOTA_ON(mp) &&
+		    ip->i_d.di_projid != fa->fsx_projid) {
+			ASSERT(tp);
+			code = XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, udqp, gdqp,
+						capable(CAP_FOWNER) ?
+						XFS_QMOPT_FORCE_RES : 0);
+			if (code)	/* out of quota */
+				goto error_return;
+		}
+	}
+
+	if (mask & FSX_EXTSIZE) {
+		/*
+		 * Can't change extent size if any extents are allocated.
+		 */
+		if (ip->i_d.di_nextents &&
+		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
+		     fa->fsx_extsize)) {
+			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			goto error_return;
+		}
+
+		/*
+		 * Extent size must be a multiple of the appropriate block
+		 * size, if set at all.
+		 */
+		if (fa->fsx_extsize != 0) {
+			xfs_extlen_t	size;
+
+			if (XFS_IS_REALTIME_INODE(ip) ||
+			    ((mask & FSX_XFLAGS) &&
+			    (fa->fsx_xflags & XFS_XFLAG_REALTIME))) {
+				size = mp->m_sb.sb_rextsize <<
+				       mp->m_sb.sb_blocklog;
+			} else {
+				size = mp->m_sb.sb_blocksize;
+			}
+
+			if (fa->fsx_extsize % size) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+		}
+	}
+
+
+	if (mask & FSX_XFLAGS) {
+		/*
+		 * Can't change realtime flag if any extents are allocated.
+		 */
+		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
+		    (XFS_IS_REALTIME_INODE(ip)) !=
+		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			goto error_return;
+		}
+
+		/*
+		 * If realtime flag is set then must have realtime data.
+		 */
+		if ((fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+			if ((mp->m_sb.sb_rblocks == 0) ||
+			    (mp->m_sb.sb_rextsize == 0) ||
+			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+		}
+
+		/*
+		 * Can't modify an immutable/append-only file unless
+		 * we have appropriate permission.
+		 */
+		if ((ip->i_d.di_flags &
+				(XFS_DIFLAG_IMMUTABLE|XFS_DIFLAG_APPEND) ||
+		     (fa->fsx_xflags &
+				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
+		    !capable(CAP_LINUX_IMMUTABLE)) {
+			code = XFS_ERROR(EPERM);
+			goto error_return;
+		}
+	}
+
+	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ihold(tp, ip);
+
+	/*
+	 * Change file ownership.  Must be the owner or privileged.
+	 * If the system was configured with the "restricted_chown"
+	 * option, the owner is not permitted to give away the file,
+	 * and can change the group id only to a group of which he
+	 * or she is a member.
+	 */
+	if (mask & FSX_PROJID) {
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
+		if (ip->i_d.di_projid != fa->fsx_projid) {
+			if (XFS_IS_PQUOTA_ON(mp)) {
+				olddquot = XFS_QM_DQVOPCHOWN(mp, tp, ip,
+							&ip->i_gdquot, gdqp);
+			}
+			ip->i_d.di_projid = fa->fsx_projid;
+
+			/*
+			 * We may have to rev the inode as well as
+			 * the superblock version number since projids didn't
+			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
+			 */
+			if (ip->i_d.di_version == XFS_DINODE_VERSION_1)
+				xfs_bump_ino_vers2(tp, ip);
+		}
+
+	}
+
+	if (mask & FSX_EXTSIZE)
+		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+	if (mask & FSX_XFLAGS)
+		xfs_set_diflags(ip, fa->fsx_xflags);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
+
+	XFS_STATS_INC(xs_ig_attrchg);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 * This is slightly sub-optimal in that truncates require
+	 * two sync transactions instead of one for wsync filesystems.
+	 * One for the truncate and one for the timestamps since we
+	 * don't want to change the timestamps unless we're sure the
+	 * truncate worked.  Truncates are less than 1% of the laddis
+	 * mix so this probably isn't worth the trouble to optimize.
+	 */
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
+	code = xfs_trans_commit(tp, 0);
+	xfs_iunlock(ip, lock_flags);
+
+	/*
+	 * Release any dquot(s) the inode had kept before chown.
+	 */
+	XFS_QM_DQRELE(mp, olddquot);
+	XFS_QM_DQRELE(mp, udqp);
+	XFS_QM_DQRELE(mp, gdqp);
+
+	if (code)
+		return code;
+
+	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE)) {
+		XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
+				NULL, DM_RIGHT_NULL, NULL, NULL, 0, 0,
+				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
+	}
+
+	vn_revalidate(XFS_ITOV(ip));	/* update flags */
+	return 0;
+
+ error_return:
+	XFS_QM_DQRELE(mp, udqp);
+	XFS_QM_DQRELE(mp, gdqp);
+	xfs_trans_cancel(tp, 0);
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
+	return code;
+}
+
 STATIC int
 xfs_ioc_fssetxattr(
 	xfs_inode_t		*ip,
@@ -882,31 +1175,16 @@ xfs_ioc_fssetxattr(
 	void			__user *arg)
 {
 	struct fsxattr		fa;
-	struct bhv_vattr	*vattr;
-	int			error;
-	int			attr_flags;
+	unsigned int		mask;
 
 	if (copy_from_user(&fa, arg, sizeof(fa)))
 		return -EFAULT;
 
-	vattr = kmalloc(sizeof(*vattr), GFP_KERNEL);
-	if (unlikely(!vattr))
-		return -ENOMEM;
-
-	attr_flags = 0;
+	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= ATTR_NONBLOCK;
+		mask |= FSX_NONBLOCK;
 
-	vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | XFS_AT_PROJID;
-	vattr->va_xflags  = fa.fsx_xflags;
-	vattr->va_extsize = fa.fsx_extsize;
-	vattr->va_projid  = fa.fsx_projid;
-
-	error = -xfs_setattr(ip, vattr, attr_flags, NULL);
-	if (!error)
-		vn_revalidate(XFS_ITOV(ip));	/* update flags */
-	kfree(vattr);
-	return 0;
+	return -xfs_ioctl_setattr(ip, &fa, mask);
 }
 
 STATIC int
@@ -928,10 +1206,9 @@ xfs_ioc_setxflags(
 	struct file		*filp,
 	void			__user *arg)
 {
-	struct bhv_vattr	*vattr;
+	struct fsxattr		fa;
 	unsigned int		flags;
-	int			attr_flags;
-	int			error;
+	unsigned int		mask;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
@@ -941,22 +1218,12 @@ xfs_ioc_setxflags(
 		      FS_SYNC_FL))
 		return -EOPNOTSUPP;
 
-	vattr = kmalloc(sizeof(*vattr), GFP_KERNEL);
-	if (unlikely(!vattr))
-		return -ENOMEM;
-
-	attr_flags = 0;
+	mask = FSX_XFLAGS;
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= ATTR_NONBLOCK;
+		mask |= FSX_NONBLOCK;
+	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
 
-	vattr->va_mask = XFS_AT_XFLAGS;
-	vattr->va_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
-
-	error = -xfs_setattr(ip, vattr, attr_flags, NULL);
-	if (likely(!error))
-		vn_revalidate(XFS_ITOV(ip));	/* update flags */
-	kfree(vattr);
-	return error;
+	return -xfs_ioctl_setattr(ip, &fa, mask);
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-15 17:32:14.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-15 17:35:44.000000000 +0200
@@ -117,26 +117,11 @@ typedef struct bhv_vattr {
 #define XFS_AT_ACL		0x00080000
 #define XFS_AT_CAP		0x00100000
 #define XFS_AT_INF		0x00200000
-#define XFS_AT_XFLAGS		0x00400000
-#define XFS_AT_EXTSIZE		0x00800000
 #define XFS_AT_NEXTENTS		0x01000000
 #define XFS_AT_ANEXTENTS	0x02000000
-#define XFS_AT_PROJID		0x04000000
 #define XFS_AT_SIZE_NOPERM	0x08000000
 #define XFS_AT_GENCOUNT		0x10000000
 
-#define XFS_AT_ALL	(XFS_AT_TYPE|XFS_AT_MODE|XFS_AT_UID|XFS_AT_GID|\
-		XFS_AT_FSID|XFS_AT_NODEID|XFS_AT_NLINK|XFS_AT_SIZE|\
-		XFS_AT_ATIME|XFS_AT_MTIME|XFS_AT_CTIME|XFS_AT_RDEV|\
-		XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|XFS_AT_MAC|\
-		XFS_AT_ACL|XFS_AT_CAP|XFS_AT_INF|XFS_AT_XFLAGS|XFS_AT_EXTSIZE|\
-		XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_PROJID|XFS_AT_GENCOUNT)
-
-#define XFS_AT_STAT	(XFS_AT_TYPE|XFS_AT_MODE|XFS_AT_UID|XFS_AT_GID|\
-		XFS_AT_FSID|XFS_AT_NODEID|XFS_AT_NLINK|XFS_AT_SIZE|\
-		XFS_AT_ATIME|XFS_AT_MTIME|XFS_AT_CTIME|XFS_AT_RDEV|\
-		XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_PROJID)
-
 #define XFS_AT_TIMES	(XFS_AT_ATIME|XFS_AT_MTIME|XFS_AT_CTIME)
 
 #define XFS_AT_UPDTIMES	(XFS_AT_UPDATIME|XFS_AT_UPDMTIME|XFS_AT_UPDCTIME)
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-06-15 17:32:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-06-15 17:39:09.000000000 +0200
@@ -94,7 +94,6 @@ xfs_setattr(
 	uid_t			uid=0, iuid=0;
 	gid_t			gid=0, igid=0;
 	int			timeflags = 0;
-	xfs_prid_t		projid=0, iprojid=0;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
 	int			file_owner;
 	int			need_iolock = 1;
@@ -139,8 +138,7 @@ xfs_setattr(
 	 * If the IDs do change before we take the ilock, we're covered
 	 * because the i_*dquot fields will get updated anyway.
 	 */
-	if (XFS_IS_QUOTA_ON(mp) &&
-	    (mask & (XFS_AT_UID|XFS_AT_GID|XFS_AT_PROJID))) {
+	if (XFS_IS_QUOTA_ON(mp) && (mask & (XFS_AT_UID|XFS_AT_GID))) {
 		uint	qflags = 0;
 
 		if ((mask & XFS_AT_UID) && XFS_IS_UQUOTA_ON(mp)) {
@@ -155,12 +153,7 @@ xfs_setattr(
 		}  else {
 			gid = ip->i_d.di_gid;
 		}
-		if ((mask & XFS_AT_PROJID) && XFS_IS_PQUOTA_ON(mp)) {
-			projid = vap->va_projid;
-			qflags |= XFS_QMOPT_PQUOTA;
-		}  else {
-			projid = ip->i_d.di_projid;
-		}
+
 		/*
 		 * We take a reference when we initialize udqp and gdqp,
 		 * so it is important that we never blindly double trip on
@@ -168,8 +161,8 @@ xfs_setattr(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		code = XFS_QM_DQVOPALLOC(mp, ip, uid, gid, projid, qflags,
-					 &udqp, &gdqp);
+		code = XFS_QM_DQVOPALLOC(mp, ip, uid, gid, ip->i_d.di_projid,
+					 qflags, &udqp, &gdqp);
 		if (code)
 			return code;
 	}
@@ -219,9 +212,7 @@ xfs_setattr(
 	 * Only the owner or users with CAP_FOWNER
 	 * capability may do these things.
 	 */
-	if (mask &
-	    (XFS_AT_MODE|XFS_AT_XFLAGS|XFS_AT_EXTSIZE|XFS_AT_UID|
-	     XFS_AT_GID|XFS_AT_PROJID)) {
+	if (mask & (XFS_AT_MODE|XFS_AT_UID|XFS_AT_GID)) {
 		/*
 		 * CAP_FOWNER overrides the following restrictions:
 		 *
@@ -270,7 +261,7 @@ xfs_setattr(
 	 * and can change the group id only to a group of which he
 	 * or she is a member.
 	 */
-	if (mask & (XFS_AT_UID|XFS_AT_GID|XFS_AT_PROJID)) {
+	if (mask & (XFS_AT_UID|XFS_AT_GID)) {
 		/*
 		 * These IDs could have changed since we last looked at them.
 		 * But, we're assured that if the ownership did change
@@ -278,12 +269,9 @@ xfs_setattr(
 		 * would have changed also.
 		 */
 		iuid = ip->i_d.di_uid;
-		iprojid = ip->i_d.di_projid;
 		igid = ip->i_d.di_gid;
 		gid = (mask & XFS_AT_GID) ? vap->va_gid : igid;
 		uid = (mask & XFS_AT_UID) ? vap->va_uid : iuid;
-		projid = (mask & XFS_AT_PROJID) ? (xfs_prid_t)vap->va_projid :
-			 iprojid;
 
 		/*
 		 * CAP_CHOWN overrides the following restrictions:
@@ -303,11 +291,10 @@ xfs_setattr(
 			goto error_return;
 		}
 		/*
-		 * Do a quota reservation only if uid/projid/gid is actually
+		 * Do a quota reservation only if uid/gid is actually
 		 * going to change.
 		 */
 		if ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
-		    (XFS_IS_PQUOTA_ON(mp) && iprojid != projid) ||
 		    (XFS_IS_GQUOTA_ON(mp) && igid != gid)) {
 			ASSERT(tp);
 			code = XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, udqp, gdqp,
@@ -361,78 +348,6 @@ xfs_setattr(
 	}
 
 	/*
-	 * Change extent size or realtime flag.
-	 */
-	if (mask & (XFS_AT_EXTSIZE|XFS_AT_XFLAGS)) {
-		/*
-		 * Can't change extent size if any extents are allocated.
-		 */
-		if (ip->i_d.di_nextents && (mask & XFS_AT_EXTSIZE) &&
-		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
-		     vap->va_extsize) ) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
-			goto error_return;
-		}
-
-		/*
-		 * Can't change realtime flag if any extents are allocated.
-		 */
-		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
-		    (mask & XFS_AT_XFLAGS) &&
-		    (XFS_IS_REALTIME_INODE(ip)) !=
-		    (vap->va_xflags & XFS_XFLAG_REALTIME)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
-			goto error_return;
-		}
-		/*
-		 * Extent size must be a multiple of the appropriate block
-		 * size, if set at all.
-		 */
-		if ((mask & XFS_AT_EXTSIZE) && vap->va_extsize != 0) {
-			xfs_extlen_t	size;
-
-			if (XFS_IS_REALTIME_INODE(ip) ||
-			    ((mask & XFS_AT_XFLAGS) &&
-			    (vap->va_xflags & XFS_XFLAG_REALTIME))) {
-				size = mp->m_sb.sb_rextsize <<
-				       mp->m_sb.sb_blocklog;
-			} else {
-				size = mp->m_sb.sb_blocksize;
-			}
-			if (vap->va_extsize % size) {
-				code = XFS_ERROR(EINVAL);
-				goto error_return;
-			}
-		}
-		/*
-		 * If realtime flag is set then must have realtime data.
-		 */
-		if ((mask & XFS_AT_XFLAGS) &&
-		    (vap->va_xflags & XFS_XFLAG_REALTIME)) {
-			if ((mp->m_sb.sb_rblocks == 0) ||
-			    (mp->m_sb.sb_rextsize == 0) ||
-			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
-				code = XFS_ERROR(EINVAL);
-				goto error_return;
-			}
-		}
-
-		/*
-		 * Can't modify an immutable/append-only file unless
-		 * we have appropriate permission.
-		 */
-		if ((mask & XFS_AT_XFLAGS) &&
-		    (ip->i_d.di_flags &
-				(XFS_DIFLAG_IMMUTABLE|XFS_DIFLAG_APPEND) ||
-		     (vap->va_xflags &
-				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
-		    !capable(CAP_LINUX_IMMUTABLE)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-	}
-
-	/*
 	 * Now we can make the changes.  Before we join the inode
 	 * to the transaction, if XFS_AT_SIZE is set then take care of
 	 * the part of the truncation that must be done without the
@@ -568,7 +483,7 @@ xfs_setattr(
 	 * and can change the group id only to a group of which he
 	 * or she is a member.
 	 */
-	if (mask & (XFS_AT_UID|XFS_AT_GID|XFS_AT_PROJID)) {
+	if (mask & (XFS_AT_UID|XFS_AT_GID)) {
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
@@ -603,23 +518,6 @@ xfs_setattr(
 			}
 			ip->i_d.di_gid = gid;
 		}
-		if (iprojid != projid) {
-			if (XFS_IS_PQUOTA_ON(mp)) {
-				ASSERT(!XFS_IS_GQUOTA_ON(mp));
-				ASSERT(mask & XFS_AT_PROJID);
-				ASSERT(gdqp);
-				olddquot2 = XFS_QM_DQVOPCHOWN(mp, tp, ip,
-							&ip->i_gdquot, gdqp);
-			}
-			ip->i_d.di_projid = projid;
-			/*
-			 * We may have to rev the inode as well as
-			 * the superblock version number since projids didn't
-			 * exist before DINODE_VERSION_2 and SB_VERSION_NLINK.
-			 */
-			if (ip->i_d.di_version == XFS_DINODE_VERSION_1)
-				xfs_bump_ino_vers2(tp, ip);
-		}
 
 		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
 		timeflags |= XFS_ICHGTIME_CHG;
@@ -647,57 +545,6 @@ xfs_setattr(
 	}
 
 	/*
-	 * Change XFS-added attributes.
-	 */
-	if (mask & (XFS_AT_EXTSIZE|XFS_AT_XFLAGS)) {
-		if (mask & XFS_AT_EXTSIZE) {
-			/*
-			 * Converting bytes to fs blocks.
-			 */
-			ip->i_d.di_extsize = vap->va_extsize >>
-				mp->m_sb.sb_blocklog;
-		}
-		if (mask & XFS_AT_XFLAGS) {
-			uint	di_flags;
-
-			/* can't set PREALLOC this way, just preserve it */
-			di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
-			if (vap->va_xflags & XFS_XFLAG_IMMUTABLE)
-				di_flags |= XFS_DIFLAG_IMMUTABLE;
-			if (vap->va_xflags & XFS_XFLAG_APPEND)
-				di_flags |= XFS_DIFLAG_APPEND;
-			if (vap->va_xflags & XFS_XFLAG_SYNC)
-				di_flags |= XFS_DIFLAG_SYNC;
-			if (vap->va_xflags & XFS_XFLAG_NOATIME)
-				di_flags |= XFS_DIFLAG_NOATIME;
-			if (vap->va_xflags & XFS_XFLAG_NODUMP)
-				di_flags |= XFS_DIFLAG_NODUMP;
-			if (vap->va_xflags & XFS_XFLAG_PROJINHERIT)
-				di_flags |= XFS_DIFLAG_PROJINHERIT;
-			if (vap->va_xflags & XFS_XFLAG_NODEFRAG)
-				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (vap->va_xflags & XFS_XFLAG_FILESTREAM)
-				di_flags |= XFS_DIFLAG_FILESTREAM;
-			if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
-				if (vap->va_xflags & XFS_XFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (vap->va_xflags & XFS_XFLAG_NOSYMLINKS)
-					di_flags |= XFS_DIFLAG_NOSYMLINKS;
-				if (vap->va_xflags & XFS_XFLAG_EXTSZINHERIT)
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-			} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
-				if (vap->va_xflags & XFS_XFLAG_REALTIME)
-					di_flags |= XFS_DIFLAG_REALTIME;
-				if (vap->va_xflags & XFS_XFLAG_EXTSIZE)
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-			}
-			ip->i_d.di_flags = di_flags;
-		}
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		timeflags |= XFS_ICHGTIME_CHG;
-	}
-
-	/*
 	 * Change file inode change time only if XFS_AT_CTIME set
 	 * AND we have been called by a DMI function.
 	 */
