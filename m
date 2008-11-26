Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KUEE000814 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:30 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4478F15FCD90
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 4PbPP4pkFNm072wF for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:29 -0800 (PST)
Message-Id: <20081126032028.382309095@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:11 -0600
From: sandeen@sandeen.net
Subject: [patch 06/12] Make the bulkstat_one compat ioctl handling more sane
Content-Disposition: inline; filename=compat_ioctl_bulkstat_sanity
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Currently the compat formatter was handled by passing
in "private_data" for the xfs_bulkstat_one formatter,
which was really just another formatter... IMHO this
got confusing.

Instead, just make a new xfs_bulkstat_one_compat
formatter for xfs_bulkstat, and call it via a wrapper.

Also, don't translate the ioctl nrs into their native
counterparts, that just clouds the issue; we're in a
compat handler anyway, just switch on the 32-bit cmds.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:29.615001209 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:27.779001802 -0600
@@ -224,14 +224,30 @@ xfs_bulkstat_one_fmt_compat(
 	return sizeof(*p32);
 }
 
+STATIC int
+xfs_bulkstat_one_compat(
+	xfs_mount_t	*mp,		/* mount point for filesystem */
+	xfs_ino_t	ino,		/* inode number to get data for */
+	void		__user *buffer,	/* buffer to place output in */
+	int		ubsize,		/* size of buffer */
+	void		*private_data,	/* my private data */
+	xfs_daddr_t	bno,		/* starting bno of inode cluster */
+	int		*ubused,	/* bytes used by me */
+	void		*dibuff,	/* on-disk inode buffer */
+	int		*stat)		/* BULKSTAT_RV_... */
+{
+	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
+				    xfs_bulkstat_one_fmt_compat, bno,
+				    ubused, dibuff, stat);
+}
+
 /* copied from xfs_ioctl.c */
 STATIC int
-xfs_ioc_bulkstat_compat(
-	xfs_mount_t		*mp,
-	unsigned int		cmd,
-	void			__user *arg)
+xfs_compat_ioc_bulkstat(
+	xfs_mount_t		  *mp,
+	unsigned int		  cmd,
+	compat_xfs_fsop_bulkreq_t __user *p32)
 {
-	compat_xfs_fsop_bulkreq_t __user *p32 = (void __user *)arg;
 	u32			addr;
 	xfs_fsop_bulkreq_t	bulkreq;
 	int			count;	/* # of records returned */
@@ -268,14 +284,12 @@ xfs_ioc_bulkstat_compat(
 	if (bulkreq.ubuffer == NULL)
 		return -XFS_ERROR(EINVAL);
 
-	if (cmd == XFS_IOC_FSINUMBERS)
+	if (cmd == XFS_IOC_FSINUMBERS_32)
 		error = xfs_inumbers(mp, &inlast, &count,
 				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
 	else {
-		/* declare a var to get a warning in case the type changes */
-		bulkstat_one_fmt_pf formatter = xfs_bulkstat_one_fmt_compat;
 		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one, formatter,
+			xfs_bulkstat_one_compat, NULL,
 			sizeof(compat_xfs_bstat_t), bulkreq.ubuffer,
 			BULKSTAT_FG_QUICK, &done);
 	}
@@ -423,9 +437,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
-		return xfs_ioc_bulkstat_compat(XFS_I(inode)->i_mount,
-				cmd, (void __user*)arg);
+		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32: {
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-11-24 16:59:25.772001741 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-11-24 17:09:27.779001802 -0600
@@ -206,13 +206,13 @@ xfs_bulkstat_one_fmt(
  * Return stat information for one inode.
  * Return 0 if ok, else errno.
  */
-int		       		/* error status */
-xfs_bulkstat_one(
+int		   	    		/* error status */
+xfs_bulkstat_one_int(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* buffer to place output in */
 	int		ubsize,		/* size of buffer */
-	void		*private_data,	/* my private data */
+	bulkstat_one_fmt_pf formatter,	/* formatter, copy to user */
 	xfs_daddr_t	bno,		/* starting bno of inode cluster */
 	int		*ubused,	/* bytes used by me */
 	void		*dibuff,	/* on-disk inode buffer */
@@ -221,7 +221,6 @@ xfs_bulkstat_one(
 	xfs_bstat_t	*buf;		/* return buffer */
 	int		error = 0;	/* error value */
 	xfs_dinode_t	*dip;		/* dinode inode pointer */
-	bulkstat_one_fmt_pf formatter = private_data ? : xfs_bulkstat_one_fmt;
 
 	dip = (xfs_dinode_t *)dibuff;
 	*stat = BULKSTAT_RV_NOTHING;
@@ -259,6 +258,23 @@ xfs_bulkstat_one(
 	return error;
 }
 
+int
+xfs_bulkstat_one(
+	xfs_mount_t	*mp,		/* mount point for filesystem */
+	xfs_ino_t	ino,		/* inode number to get data for */
+	void		__user *buffer,	/* buffer to place output in */
+	int		ubsize,		/* size of buffer */
+	void		*private_data,	/* my private data */
+	xfs_daddr_t	bno,		/* starting bno of inode cluster */
+	int		*ubused,	/* bytes used by me */
+	void		*dibuff,	/* on-disk inode buffer */
+	int		*stat)		/* BULKSTAT_RV_... */
+{
+	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
+				    xfs_bulkstat_one_fmt, bno,
+				    ubused, dibuff, stat);
+}
+
 /*
  * Test to see whether we can use the ondisk inode directly, based
  * on the given bulkstat flags, filling in dipp accordingly.
Index: linux-2.6-xfs/fs/xfs/xfs_itable.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.h	2008-11-24 16:59:25.773001344 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_itable.h	2008-11-24 17:09:27.780001260 -0600
@@ -74,6 +74,18 @@ typedef int (*bulkstat_one_fmt_pf)(  /* 
 	const xfs_bstat_t	*buffer);        /* buffer to read from */
 
 int
+xfs_bulkstat_one_int(
+	xfs_mount_t		*mp,
+	xfs_ino_t		ino,
+	void			__user *buffer,
+	int			ubsize,
+	bulkstat_one_fmt_pf	formatter,
+	xfs_daddr_t		bno,
+	int			*ubused,
+	void			*dibuff,
+	int			*stat);
+
+int
 xfs_bulkstat_one(
 	xfs_mount_t		*mp,
 	xfs_ino_t		ino,

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
