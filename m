Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6rjX031657 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0F05164F1BF
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cShg7ZyyzIlhVF75 for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xm0-0007YW-92
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:52 +0000
Message-Id: <20081202160652.147347000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 18/22] kill xfs_unmount_flush
Content-Disposition: inline; filename=xfs-kill-xfs_unmountfs_flush
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

There's almost nothing left in this function, instead remove the IRELE
on the real times inodes and the call to XFS_QM_UNMOUNT into xfs_unmountfs.

For the regular unmount case that means it now also happenes after dmapi
notification, but otherwise there is no difference in behaviour.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_mount.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.c	2008-12-01 19:28:02.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.c	2008-12-01 19:28:11.000000000 +0100
@@ -1220,6 +1220,16 @@ xfs_unmountfs(
 	__uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Release dquot that rootinode, rbmino and rsumino might be holding,
+	 * and release the quota inodes.
+	 */
+	XFS_QM_UNMOUNT(mp);
+
+	if (mp->m_rbmip)
+		IRELE(mp->m_rbmip);
+	if (mp->m_rsumip)
+		IRELE(mp->m_rsumip);
 	IRELE(mp->m_rootip);
 
 	/*
Index: xfs-master/fs/xfs/xfs_mount.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.h	2008-12-01 19:28:08.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.h	2008-12-01 19:28:11.000000000 +0100
@@ -510,7 +510,6 @@ extern void	xfs_mountfs_check_barriers(x
 
 extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
-extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_unlocked(xfs_mount_t *, xfs_sb_field_t,
 			int64_t, int);
Index: xfs-master/fs/xfs/xfs_vfsops.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_vfsops.c	2008-12-01 19:28:07.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,83 +0,0 @@
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_dmapi.h"
-#include "xfs_mount.h"
-#include "xfs_da_btree.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
-#include "xfs_quota.h"
-#include "xfs_error.h"
-#include "xfs_bmap.h"
-#include "xfs_rw.h"
-#include "xfs_buf_item.h"
-#include "xfs_log_priv.h"
-#include "xfs_dir2_trace.h"
-#include "xfs_extfree_item.h"
-#include "xfs_acl.h"
-#include "xfs_attr.h"
-#include "xfs_mru_cache.h"
-#include "xfs_filestream.h"
-#include "xfs_fsops.h"
-#include "xfs_vnodeops.h"
-#include "xfs_utils.h"
-#include "xfs_sync.h"
-
-
-/*
- * xfs_unmount_flush implements a set of flush operation on special
- * inodes, which are needed as a separate set of operations so that
- * they can be called as part of relocation process.
- */
-int
-xfs_unmount_flush(
-	xfs_mount_t	*mp,		/* Mount structure we are getting
-					   rid of. */
-	int             relocation)	/* Called from vfs relocation. */
-{
-	/*
-	 * Release dquot that rootinode, rbmino and rsumino might be holding,
-	 * flush and purge the quota inodes.
-	 */
-	XFS_QM_UNMOUNT(mp);
-
-	if (mp->m_rbmip)
-		IRELE(mp->m_rbmip);
-	if (mp->m_rsumip)
-		IRELE(mp->m_rsumip);
-
-	return 0;
-}
Index: xfs-master/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_super.c	2008-12-01 19:28:02.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_super.c	2008-12-01 19:28:11.000000000 +0100
@@ -1043,7 +1043,6 @@ xfs_fs_put_super(
 	struct xfs_mount	*mp = XFS_M(sb);
 	struct xfs_inode	*rip = mp->m_rootip;
 	int			unmount_event_flags = 0;
-	int			error;
 
 	xfs_syncd_stop(mp);
 	xfs_sync_inodes(mp, SYNC_ATTR|SYNC_DELWRI);
@@ -1071,8 +1070,6 @@ xfs_fs_put_super(
 	xfs_filestream_unmount(mp);
 
 	XFS_bflush(mp->m_ddev_targp);
-	error = xfs_unmount_flush(mp, 0);
-	WARN_ON(error);
 
 	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
@@ -1535,8 +1532,6 @@ xfs_fs_fill_super(
 	xfs_filestream_unmount(mp);
 
 	XFS_bflush(mp->m_ddev_targp);
-	error = xfs_unmount_flush(mp, 0);
-	WARN_ON(error);
 
 	xfs_unmountfs(mp);
 	goto out_free_sb;
Index: xfs-master/fs/xfs/Makefile
===================================================================
--- xfs-master.orig/fs/xfs/Makefile	2008-12-01 19:26:35.000000000 +0100
+++ xfs-master/fs/xfs/Makefile	2008-12-01 19:28:11.000000000 +0100
@@ -85,7 +85,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_trans_inode.o \
 				   xfs_trans_item.o \
 				   xfs_utils.o \
-				   xfs_vfsops.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
