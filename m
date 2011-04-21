Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LDHZCb159067 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 08:17:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D07D1E11278
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 06:21:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ldEmEpWoo1JG0jY2 for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 06:21:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QCtod-00011k-HE
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 13:21:03 +0000
Date: Thu, 21 Apr 2011 09:21:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: add an x86 compat handler for XFS_IOC_ZERO_RANGE
Message-ID: <20110421132103.GA3861@infradead.org>
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

XFS_IOC_ZERO_RANGE uses struct xfs_flock64, and thus requires argument
translation for 32-bit binaries on x86.  Add the required
XFS_IOC_ZERO_RANGE_32 defined and add it to the list of commands that
require xfs_flock64 translation.  

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2011-04-21 15:04:11.871434170 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2011-04-21 15:06:46.680595497 +0200
@@ -586,7 +586,8 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_RESVSP_32:
 	case XFS_IOC_UNRESVSP_32:
 	case XFS_IOC_RESVSP64_32:
-	case XFS_IOC_UNRESVSP64_32: {
+	case XFS_IOC_UNRESVSP64_32:
+	case XFS_IOC_ZERO_RANGE_32: {
 		struct xfs_flock64	bf;
 
 		if (xfs_compat_flock64_copyin(&bf, arg))
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2011-04-21 15:06:41.437290568 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2011-04-21 15:07:26.550379502 +0200
@@ -184,6 +184,7 @@ typedef struct compat_xfs_flock64 {
 #define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
 #define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
 #define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
+#define XFS_IOC_ZERO_RANGE_32	_IOW('X', 57, struct compat_xfs_flock64)
 
 typedef struct compat_xfs_fsop_geom_v1 {
 	__u32		blocksize;	/* filesystem (data) block size */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
