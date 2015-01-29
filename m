Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9187F7F87
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:31:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7045E304062
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:31:10 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id SSr4go7VgwPlFO27
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:31:08 -0800 (PST)
Received: by mail-pa0-f46.google.com with SMTP id lj1so39092359pab.5
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:31:08 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.215.112])
	by mx.google.com with ESMTPSA id w8sm7832072pds.64.2015.01.29.05.31.06
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 29 Jan 2015 05:31:07 -0800 (PST)
Message-ID: <54ca361b.6841460a.02cf.3cca@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Thu, 29 Jan 2015 19:01:02 +0530
Subject: [PATCH 4/4] xfsprogs: Adding XFS_IOC_FIEMAPFS ioctl for use in
	xfs_spaceman
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


This patch is concerned with the changes to be done in userspace code for
turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman 
into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
fiemap insfrastructure.
By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
fiemap commands and allows us to review it and push it as we need, making the
process much simpler.

----------------------------------------------------------------------------------------

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
---
include/xfs_fs.h	| 1 +
spaceman/freesp.c	| 6 +++---
2 files changed, 4 insertions(+), 3 deletions(-) 

--- a/include/xfs_fs.h	2015-01-29 15:26:50.954401773 +0530
+++ b/include/xfs_fs.h	2015-01-29 11:29:59.531652554 +0530

@@ -505,6 +505,7 @@
 #define XFS_IOC_DIOINFO	_IOR ('X', 30, struct dioattr)
 #define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
 #define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FIEMAPFS	_IOWR('X', 33, struct fiemap)
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP	_IOWR('X', 38, struct getbmap)

----------------------------------------------------------------------------------------

--- a/spaceman/freesp.c	2015-01-29 15:27:03.737227849 +0530
+++ b/spaceman/freesp.c	2015-01-29 15:23:48.865235168 +0530

@@ -31,7 +31,7 @@
 #define FIEMAPFS_FLAG_FREESP_SIZE_HINT	0x20000000
 #define	FIEMAPFS_FLAG_FREESP_CONTINUE   0x10000000
 
-#define FS_IOC_FIEMAPFS			_IOWR('f', 12, struct fiemap)
+#define XFS_IOC_FIEMAPFS			_IOWR('X', 33, struct fiemap)
 #endif
 
 typedef struct histent
@@ -201,9 +201,9 @@
 		fiemap->fm_length = length;
 		fiemap->fm_extent_count = NR_EXTENTS;
 
-		ret = ioctl(file->fd, FS_IOC_FIEMAPFS, (unsigned long)fiemap);
+		ret = xfsctl(file->name,file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
		if (ret < 0) {
-			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAPFS) [\"%s\"]: "
+			fprintf(stderr, "%s: xfsctl(XFS_IOC_FIEMAPFS) [\"%s\"]: "
 				"%s\n", progname, file->name, strerror(errno));
 			free(fiemap);
 			exitcode = 1;

----------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
