Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p29NYvWP067845 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 17:35:03 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3311D1BD2FB9
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 15:37:46 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nCmKqKXy4CT1YEV8 for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 15:37:46 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxSwW-0002rw-Su
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 10:37:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxSwe-000207-JD
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 10:37:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: preallocation transactions do not need to be synchronous
Date: Thu, 10 Mar 2011 10:37:32 +1100
Message-Id: <1299713852-7663-1-git-send-email-david@fromorbit.com>
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

Preallocation and hole punch transactions are currently synchronous
and this is causing performance problems in some cases. The
transactions don't need to be synchronous as we don't need to
guarantee the preallocation is persistent on disk until a
fdatasync, fsync, sync operation occurs. If the file is opened
O_SYNC or O_DATASYNC, only then should the transaction be issued
synchronously.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c  |    4 ++++
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 ++++
 fs/xfs/xfs_vnodeops.c        |    3 ++-
 fs/xfs/xfs_vnodeops.h        |    1 +
 4 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ae59865..baa2cb3 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -896,6 +896,7 @@ xfs_file_fallocate(
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
 	int		cmd = XFS_IOC_RESVSP;
+	int		attr_flags = XFS_ATTR_NOLOCK;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE |
 		     FALLOC_FL_PUNCH_HOLE |
@@ -922,6 +923,9 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	if (file->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
 	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
 	if (error)
 		goto out_unlock;
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 0ca0e3c..acca2c5 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -624,6 +624,10 @@ xfs_ioc_space(
 
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
 		attr_flags |= XFS_ATTR_NONBLOCK;
+
+	if (filp->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
 	if (ioflags & IO_INVIS)
 		attr_flags |= XFS_ATTR_DMI;
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 37d8146..c48b421 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2831,7 +2831,8 @@ xfs_change_file_space(
 		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
+	if (attr_flags & XFS_ATTR_SYNC)
+		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp, 0);
 
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index f670292..3bcd233 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -18,6 +18,7 @@ int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
+#define XFS_ATTR_SYNC		0x10	/* synchronous operation required */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_release(struct xfs_inode *ip);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
