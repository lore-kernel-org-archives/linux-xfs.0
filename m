Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HJYtdk255596 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:34:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A0BB1CDAB0B
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:36:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UIFGbBfwHhsGRwMe for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:36:13 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nhpgz-0006KH-9M
	for xfs@oss.sgi.com; Wed, 17 Feb 2010 19:36:13 +0000
Date: Wed, 17 Feb 2010 14:36:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: kill xfs_lrw.h
Message-ID: <20100217193613.GB21840@infradead.org>
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

Move the two declarations to better fitting headers now that xfs_lrw.c
is gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-02-17 11:02:16.540004170 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2010-02-17 11:02:27.898006405 +0100
@@ -88,7 +88,6 @@
 #include <xfs_super.h>
 #include <xfs_globals.h>
 #include <xfs_fs_subr.h>
-#include <xfs_lrw.h>
 #include <xfs_buf.h>
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2010-02-17 11:01:12.235003823 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,29 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_LRW_H__
-#define __XFS_LRW_H__
-
-struct xfs_mount;
-struct xfs_inode;
-struct xfs_buf;
-
-extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
-
-extern int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
-
-#endif	/* __XFS_LRW_H__ */
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-02-17 11:01:12.247003962 +0100
+++ xfs/fs/xfs/xfs_mount.h	2010-02-17 11:01:26.692256092 +0100
@@ -436,6 +436,8 @@ extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
+extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
+
 extern int	xfs_dmops_get(struct xfs_mount *);
 extern void	xfs_dmops_put(struct xfs_mount *);
 
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2010-02-17 11:01:52.290253576 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2010-02-17 11:02:04.977005288 +0100
@@ -59,4 +59,6 @@ int xfs_flush_pages(struct xfs_inode *ip
 		xfs_off_t last, uint64_t flags, int fiopt);
 int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
+int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
+
 #endif /* _XFS_VNODEOPS_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
