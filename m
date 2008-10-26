Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 13:35:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QKYvd4027255
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:57 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15C5112ABC90
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ptQ26tTK1jtaEpOn for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:57 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuCK9-0001ts-C4
	for xfs@oss.sgi.com; Sun, 26 Oct 2008 20:34:57 +0000
Date: Sun, 26 Oct 2008 16:34:57 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] remove xfs_vfs.h
Message-ID: <20081026203457.GF4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-kill-xfs_vfs.h"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The only thing left are the forced shutdown flags and freeze macros which
fit into xfs_mount.h much better.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-15 07:31:21.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-15 18:18:49.000000000 -0400
@@ -36,7 +36,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_vfs.h"
 #include "xfs_vnode.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-10-15 07:46:49.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-10-15 18:18:49.000000000 -0400
@@ -85,7 +85,6 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include <xfs_vfs.h>
 #include <xfs_cred.h>
 #include <xfs_vnode.h>
 #include <xfs_stats.h>
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2008-10-15 18:18:49.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,44 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#ifndef __XFS_VFS_H__
-#define __XFS_VFS_H__
-
-#include <linux/vfs.h>
-#include "xfs_fs.h"
-
-struct inode;
-
-struct fid;
-struct cred;
-struct seq_file;
-struct super_block;
-struct xfs_inode;
-struct xfs_mount;
-struct xfs_mount_args;
-
-#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
-#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
-#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
-#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
-#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
-#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
-
-#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
-#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
-
-#endif	/* __XFS_VFS_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-10-15 18:18:49.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-10-15 18:18:49.000000000 -0400
@@ -435,6 +435,16 @@ void xfs_do_force_shutdown(struct xfs_mo
 #define xfs_force_shutdown(m,f)	\
 	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
 
+#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
+#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
+#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
+#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
+#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
+#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
+
+#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
+#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
+
 /*
  * Flags for xfs_mountfs
  */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-10-15 07:31:17.000000000 -0400
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-10-15 18:19:30.000000000 -0400
@@ -18,7 +18,10 @@
 #ifndef __XFS_VNODE_H__
 #define __XFS_VNODE_H__
 
+#include "xfs_fs.h"
+
 struct file;
+struct xfs_inode;
 struct xfs_iomap;
 struct attrlist_cursor_kern;
 

-- 
