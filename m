Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 410647FC3
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2EAFF8F8081
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BA7DFZfYRFDoA6VR for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:26 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gY-TR
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003yM-SX
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: kill xfs_vnode.h
Date: Thu, 31 Jul 2014 17:33:15 +1000
Message-Id: <1406791995-14723-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1406791995-14723-1-git-send-email-david@fromorbit.com>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Move the IO flag definitions to xfs_inode.h and kill the header file
as it is now empty.

Removing the xfs_vnode.h file showed up an implicit header include
path:
	xfs_linux.h -> xfs_vnode.h -> xfs_fs.h

And so every xfs header file has been inplicitly been including
xfs_fs.h where it is needed or not. Hence the removal of xfs_vnode.h
causes all sorts of build issues because BBTOB() and friends are no
longer automatically included in the build. This also gets fixed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_file.c    | 10 +++++-----
 fs/xfs/xfs_inode.h   | 10 ++++++++++
 fs/xfs/xfs_ioctl.c   |  6 +++---
 fs/xfs/xfs_ioctl32.c |  3 +--
 fs/xfs/xfs_linux.h   |  2 +-
 fs/xfs/xfs_vnode.h   | 37 -------------------------------------
 6 files changed, 20 insertions(+), 48 deletions(-)
 delete mode 100644 fs/xfs/xfs_vnode.h

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 181605d..5284a7e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -246,11 +246,11 @@ xfs_file_read_iter(
 	XFS_STATS_INC(xs_read_calls);
 
 	if (unlikely(file->f_flags & O_DIRECT))
-		ioflags |= IO_ISDIRECT;
+		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
+		ioflags |= XFS_IO_INVIS;
 
-	if (unlikely(ioflags & IO_ISDIRECT)) {
+	if (unlikely(ioflags & XFS_IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
@@ -283,7 +283,7 @@ xfs_file_read_iter(
 	 * proceeed concurrently without serialisation.
 	 */
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
+	if ((ioflags & XFS_IO_ISDIRECT) && inode->i_mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
@@ -325,7 +325,7 @@ xfs_file_splice_read(
 	XFS_STATS_INC(xs_read_calls);
 
 	if (infilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
+		ioflags |= XFS_IO_INVIS;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f72bffa..c10e3fa 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -398,4 +398,14 @@ do { \
 
 extern struct kmem_zone	*xfs_inode_zone;
 
+/*
+ * Flags for read/write calls
+ */
+#define XFS_IO_ISDIRECT	0x00001		/* bypass page cache */
+#define XFS_IO_INVIS	0x00002		/* don't update inode timestamps */
+
+#define XFS_IO_FLAGS \
+	{ XFS_IO_ISDIRECT,	"DIRECT" }, \
+	{ XFS_IO_INVIS,		"INVIS"}
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 30983b8..12ef44e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -736,7 +736,7 @@ xfs_ioc_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	if (!(ioflags & IO_INVIS)) {
+	if (!(ioflags & XFS_IO_INVIS)) {
 		ip->i_d.di_mode &= ~S_ISUID;
 		if (ip->i_d.di_mode & S_IXGRP)
 			ip->i_d.di_mode &= ~S_ISGID;
@@ -1376,7 +1376,7 @@ xfs_ioc_getbmap(
 		return -EINVAL;
 
 	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
-	if (ioflags & IO_INVIS)
+	if (ioflags & XFS_IO_INVIS)
 		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 
 	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
@@ -1520,7 +1520,7 @@ xfs_file_ioctl(
 	int			error;
 
 	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
+		ioflags |= XFS_IO_INVIS;
 
 	trace_xfs_file_ioctl(ip);
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e65ea67..04ffc1b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_vnode.h"
 #include "xfs_inode.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
@@ -537,7 +536,7 @@ xfs_file_compat_ioctl(
 	int			error;
 
 	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
+		ioflags |= XFS_IO_INVIS;
 
 	trace_xfs_file_compat_ioctl(ip);
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index d3ef6de..d10dc8f 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -101,7 +101,7 @@ typedef __uint64_t __psunsigned_t;
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include "xfs_vnode.h"
+#include "xfs_fs.h"
 #include "xfs_stats.h"
 #include "xfs_sysctl.h"
 #include "xfs_iops.h"
diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
deleted file mode 100644
index 300725d..0000000
--- a/fs/xfs/xfs_vnode.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_VNODE_H__
-#define __XFS_VNODE_H__
-
-#include "xfs_fs.h"
-
-struct file;
-struct xfs_inode;
-struct attrlist_cursor_kern;
-
-/*
- * Flags for read/write calls - same values as IRIX
- */
-#define IO_ISDIRECT	0x00004		/* bypass page cache */
-#define IO_INVIS	0x00020		/* don't update inode timestamps */
-
-#define XFS_IO_FLAGS \
-	{ IO_ISDIRECT,	"DIRECT" }, \
-	{ IO_INVIS,	"INVIS"}
-
-#endif	/* __XFS_VNODE_H__ */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
