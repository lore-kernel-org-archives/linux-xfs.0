Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 025B97CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:22:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7FCE304051
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:22:29 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x4I1uZbWMfiohKo0 for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:22:27 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: dynamically switch modes when XFS_DIFLAG2_DAX is
	set/cleared
Date: Mon, 15 Feb 2016 16:22:13 +1100
Message-Id: <1455513734-15192-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

When we set or clear the XFS_DIFLAG2_DAX flag, we should also
set/clear the S_DAX flag in the VFS inode. To do this, we need to
ensure that we first flush and remove any cached entries in the
radix tree to ensure the correct data access method is used when we
next try to read or write data. We ahve to be especially careful
here to lock out page faults so they don't race with the flush and
invalidation before we change the access mode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 92 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0895967..a870d16 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1051,20 +1051,63 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	xfs_set_diflags(ip, fa->fsx_xflags);
+	xfs_diflags_to_linux(ip);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_STATS_INC(mp, xs_ig_attrchg);
+	return 0;
+}
+
+/*
+ * If we are changing DAX flags, we have to ensure the file is clean and any
+ * cached objects in the address space are invalidated and removed. This
+ * requires us to lock out other IO and page faults similar to a truncate
+ * operation. The locks need to be held until the transaction has been committed
+ * so that the cache invalidation is atomic with respect to the DAX flag
+ * manipulation.
+ */
+static int
+xfs_ioctl_setattr_dax_invalidate(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa,
+	int			*join_flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	*join_flags = 0;
+
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories. On directories it serves as an inherit hint.
 	 */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
-	    !(S_ISREG(VFS_I(ip)->i_mode) || S_ISDIR(VFS_I(ip)->i_mode)))
+	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
-	xfs_set_diflags(ip, fa->fsx_xflags);
-	xfs_diflags_to_linux(ip);
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	XFS_STATS_INC(mp, xs_ig_attrchg);
+	/* If the DAX state is not changing, we have nothing to do here. */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
+		return 0;
+	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
+		return 0;
+
+	/* lock, flush and invalidate mapping in preparation for flag change */
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+	error = invalidate_inode_pages2(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+
+	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
 	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	return error;
+
 }
 
 /*
@@ -1072,19 +1115,27 @@ xfs_ioctl_setattr_xflags(
  * have permission to do so. On success, return a clean transaction and the
  * inode locked exclusively ready for further operation specific checks. On
  * failure, return an error without modifying or locking the inode.
+ *
+ * The inode might already be IO locked on call. If this is the case, it is
+ * indicated in @join_flags and we take full responsibility for ensuring they
+ * are unlocked from now on. Hence if we have an error here, we still have to
+ * unlock them. Otherwise, once they are joined to the transaction, they will
+ * be unlocked on commit/cancel.
  */
 static struct xfs_trans *
 xfs_ioctl_setattr_get_trans(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	int			join_flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
-	int			error;
+	int			error = -EROFS;
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return ERR_PTR(-EROFS);
+		goto out_unlock;
+	error = -EIO;
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return ERR_PTR(-EIO);
+		goto out_unlock;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
@@ -1092,7 +1143,8 @@ xfs_ioctl_setattr_get_trans(
 		goto out_cancel;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | join_flags);
+	join_flags = 0;
 
 	/*
 	 * CAP_FOWNER overrides the following restrictions:
@@ -1112,6 +1164,9 @@ xfs_ioctl_setattr_get_trans(
 
 out_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	if (join_flags)
+		xfs_iunlock(ip, join_flags);
 	return ERR_PTR(error);
 }
 
@@ -1210,6 +1265,7 @@ xfs_ioctl_setattr(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
+	int			join_flags = 0;
 
 	trace_xfs_ioctl_setattr(ip);
 
@@ -1218,6 +1274,17 @@ xfs_ioctl_setattr(
 		return code;
 
 	/*
+	 * Changing DAX config may require inode locking for mapping
+	 * invalidation. These need to be held all the way to transaction commit
+	 * or cancel time, so need to be passed through to
+	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
+	 * appropriately.
+	 */
+	code = xfs_ioctl_setattr_dax_invalidate(ip, fa, &join_flags);
+	if (code)
+		return code;
+
+	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
 	 * before we start any other transactions. Trying to do this later
 	 * is messy. We don't care to take a readlock to look at the ids
@@ -1233,7 +1300,7 @@ xfs_ioctl_setattr(
 			return code;
 	}
 
-	tp = xfs_ioctl_setattr_get_trans(ip);
+	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
 		goto error_free_dquots;
@@ -1349,6 +1416,7 @@ xfs_ioc_setxflags(
 	struct xfs_trans	*tp;
 	struct fsxattr		fa;
 	unsigned int		flags;
+	int			join_flags = 0;
 	int			error;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
@@ -1365,7 +1433,18 @@ xfs_ioc_setxflags(
 	if (error)
 		return error;
 
-	tp = xfs_ioctl_setattr_get_trans(ip);
+	/*
+	 * Changing DAX config may require inode locking for mapping
+	 * invalidation. These need to be held all the way to transaction commit
+	 * or cancel time, so need to be passed through to
+	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
+	 * appropriately.
+	 */
+	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
+	if (error)
+		goto out_drop_write;
+
+	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		error = PTR_ERR(tp);
 		goto out_drop_write;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
