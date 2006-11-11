Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 19:29:57 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAB3TmaG014577
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 19:29:49 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DA91D1CF284
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 19:29:01 -0800 (PST)
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4B38018CF23E6
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 21:29:00 -0600 (CST)
Message-ID: <4555437B.4040904@sandeen.net>
Date: Fri, 10 Nov 2006 21:28:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused filp from ioctl functions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There's a stuct file * passed around the ioctl code that is never
used... just takes up precious stack space near as I can tell :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 linux-2.4/xfs_ioctl.c |   16 +++++-----------
 linux-2.6/xfs_ioctl.c |   16 +++++-----------
 2 files changed, 10 insertions(+), 22 deletions(-)

Index: xfs-linux-allpatches/linux-2.4/xfs_ioctl.c
===================================================================
--- xfs-linux-allpatches.orig/linux-2.4/xfs_ioctl.c
+++ xfs-linux-allpatches/linux-2.4/xfs_ioctl.c
@@ -349,7 +349,6 @@ STATIC int
 xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
 	unsigned long		arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -400,7 +399,6 @@ STATIC int
 xfs_fssetdm_by_handle(
 	xfs_mount_t		*mp,
 	unsigned long		arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -442,7 +440,6 @@ STATIC int
 xfs_attrlist_by_handle(
 	xfs_mount_t		*mp,
 	unsigned long		arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -563,7 +560,6 @@ STATIC int
 xfs_attrmulti_by_handle(
 	xfs_mount_t		*mp,
 	unsigned long		arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -683,7 +679,6 @@ xfs_ioc_xattr(
 STATIC int
 xfs_ioc_getbmap(
 	bhv_desc_t		*bdp,
-	struct file		*filp,
 	int			flags,
 	unsigned int		cmd,
 	unsigned long		arg);
@@ -779,7 +774,7 @@ xfs_ioctl(
 
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(bdp, filp, ioflags, cmd, arg);
+		return xfs_ioc_getbmap(bdp, ioflags, cmd, arg);
 
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(bdp, arg);
@@ -793,16 +788,16 @@ xfs_ioctl(
 		return xfs_open_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(mp, arg, filp, inode);
+		return xfs_fssetdm_by_handle(mp, arg, inode);
 
 	case XFS_IOC_READLINK_BY_HANDLE:
-		return xfs_readlink_by_handle(mp, arg, filp, inode);
+		return xfs_readlink_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(mp, arg, filp, inode);
+		return xfs_attrlist_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
+		return xfs_attrmulti_by_handle(mp, arg, inode);
 
 	case XFS_IOC_SWAPEXT: {
 		error = xfs_swapext((struct xfs_swapext *)arg);
@@ -1258,7 +1253,6 @@ xfs_ioc_xattr(
 STATIC int
 xfs_ioc_getbmap(
 	bhv_desc_t		*bdp,
-	struct file		*filp,
 	int			ioflags,
 	unsigned int		cmd,
 	unsigned long		arg)
Index: xfs-linux-allpatches/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs-linux-allpatches.orig/linux-2.6/xfs_ioctl.c
+++ xfs-linux-allpatches/linux-2.6/xfs_ioctl.c
@@ -352,7 +352,6 @@ STATIC int
 xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -403,7 +402,6 @@ STATIC int
 xfs_fssetdm_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -445,7 +443,6 @@ STATIC int
 xfs_attrlist_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -566,7 +563,6 @@ STATIC int
 xfs_attrmulti_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
-	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -686,7 +682,6 @@ xfs_ioc_xattr(
 STATIC int
 xfs_ioc_getbmap(
 	bhv_desc_t		*bdp,
-	struct file		*filp,
 	int			flags,
 	unsigned int		cmd,
 	void			__user *arg);
@@ -785,7 +780,7 @@ xfs_ioctl(
 
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(bdp, filp, ioflags, cmd, arg);
+		return xfs_ioc_getbmap(bdp, ioflags, cmd, arg);
 
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(bdp, arg);
@@ -799,16 +794,16 @@ xfs_ioctl(
 		return xfs_open_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(mp, arg, filp, inode);
+		return xfs_fssetdm_by_handle(mp, arg, inode);
 
 	case XFS_IOC_READLINK_BY_HANDLE:
-		return xfs_readlink_by_handle(mp, arg, filp, inode);
+		return xfs_readlink_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(mp, arg, filp, inode);
+		return xfs_attrlist_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
+		return xfs_attrmulti_by_handle(mp, arg, inode);
 
 	case XFS_IOC_SWAPEXT: {
 		error = xfs_swapext((struct xfs_swapext __user *)arg);
@@ -1278,7 +1273,6 @@ xfs_ioc_xattr(
 STATIC int
 xfs_ioc_getbmap(
 	bhv_desc_t		*bdp,
-	struct file		*filp,
 	int			ioflags,
 	unsigned int		cmd,
 	void			__user *arg)
