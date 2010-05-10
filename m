Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AE6XB9005172 for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:06:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61448C83699
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:09:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id F1skBG3IsmliEl5q for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 07:09:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OBTf3-0004Kh-BO
	for xfs@oss.sgi.com; Mon, 10 May 2010 14:08:45 +0000
Date: Mon, 10 May 2010 10:08:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: remove unneeded #include statements
Message-ID: <20100510140845.GB16540@infradead.org>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-05-10 15:34:12.985261845 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-05-10 15:35:10.422023683 +0200
@@ -21,18 +21,12 @@
 #include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
-#include "xfs_btree.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_iomap.h"
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-05-10 15:34:12.994263312 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-05-10 15:35:10.423022775 +0200
@@ -22,22 +22,15 @@
 #include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
 #include "xfs_ioctl.h"
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-10 15:34:13.003253883 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-10 15:35:10.426003639 +0200
@@ -23,23 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ioctl.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-10 15:34:13.016254162 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-10 15:35:10.429003848 +0200
@@ -27,11 +27,8 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_vnode.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-05-10 15:34:13.025254372 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-05-10 15:35:10.433044217 +0200
@@ -24,20 +24,13 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-10 15:34:13.033254372 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-10 15:35:10.439005455 +0200
@@ -30,8 +30,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
@@ -42,7 +40,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-05-10 15:34:13.044026407 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-05-10 15:35:10.444033810 +0200
@@ -24,24 +24,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_inode.h"
 #include "xfs_dinode.h"
 #include "xfs_error.h"
-#include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
-#include "xfs_utils.h"
-#include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
-#include "xfs_rw.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/linux-2.6/xfs_trace.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.c	2010-05-10 15:34:13.056004337 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.c	2010-05-10 15:35:10.451255839 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-10 15:34:13.064004267 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-10 15:35:10.458255978 +0200
@@ -23,24 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-10 15:34:13.072261147 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-10 15:35:10.464284334 +0200
@@ -23,24 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-05-10 15:34:13.080253813 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-05-10 15:35:10.474255489 +0200
@@ -23,24 +23,18 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
Index: xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2010-05-10 15:34:13.089254931 +0200
+++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2010-05-10 15:35:10.479255699 +0200
@@ -23,24 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
-#include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs/fs/xfs/quota/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_stats.c	2010-05-10 15:34:13.097253883 +0200
+++ xfs/fs/xfs/quota/xfs_qm_stats.c	2010-05-10 15:35:10.484285661 +0200
@@ -23,24 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
-#include "xfs_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-10 15:34:13.109253743 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-10 15:35:10.491283985 +0200
@@ -26,24 +26,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
-#include "xfs_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-05-10 15:34:13.120254232 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-05-10 15:35:10.497255769 +0200
@@ -23,24 +23,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
-#include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-05-10 15:34:13.129004686 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-05-10 15:35:10.502278048 +0200
@@ -24,17 +24,13 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2010-05-10 15:34:13.138004267 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2010-05-10 15:35:10.507255210 +0200
@@ -24,18 +24,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_btree_trace.h"
-#include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-05-10 15:34:13.149004616 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-05-10 15:35:10.513255070 +0200
@@ -25,18 +25,13 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
-#include "xfs_btree.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2010-05-10 15:34:13.157024382 +0200
+++ xfs/fs/xfs/xfs_attr_leaf.c	2010-05-10 15:35:10.520005245 +0200
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
@@ -32,7 +31,6 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2010-05-10 15:34:13.169004267 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2010-05-10 15:35:10.525034439 +0200
@@ -24,20 +24,16 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_trace.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2010-05-10 15:34:13.183024941 +0200
+++ xfs/fs/xfs/xfs_btree.c	2010-05-10 15:35:10.534255489 +0200
@@ -24,19 +24,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_btree_trace.h"
-#include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2010-05-10 15:34:13.192003988 +0200
+++ xfs/fs/xfs/xfs_dfrag.c	2010-05-10 15:35:10.540286848 +0200
@@ -24,23 +24,15 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_dfrag.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_error.c
===================================================================
--- xfs.orig/fs/xfs/xfs_error.c	2010-05-10 15:34:13.199003848 +0200
+++ xfs/fs/xfs/xfs_error.c	2010-05-10 15:35:10.547255489 +0200
@@ -23,11 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_utils.h"
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-05-10 15:34:13.205004616 +0200
+++ xfs/fs/xfs/xfs_filestream.c	2010-05-10 15:35:10.552031995 +0200
@@ -18,9 +18,6 @@
 #include "xfs.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inum.h"
-#include "xfs_dir2.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-05-10 15:34:13.216253953 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2010-05-10 15:35:10.557005524 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-05-10 15:34:13.227254302 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2010-05-10 15:35:10.563005315 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2010-05-10 15:34:13.236254372 +0200
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2010-05-10 15:35:10.567067544 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-10 15:34:13.251275115 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-10 15:35:10.572005664 +0200
@@ -25,13 +25,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-10 15:34:13.260253464 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-10 15:35:10.578005524 +0200
@@ -27,12 +27,10 @@
 #include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
@@ -43,7 +41,6 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
-#include "xfs_rw.h"
 #include "xfs_error.h"
 #include "xfs_utils.h"
 #include "xfs_quota.h"
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-10 15:34:13.267254093 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-10 15:35:10.583005734 +0200
@@ -22,23 +22,14 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
-#include "xfs_buf_item.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_rw.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-05-10 15:34:13.276003848 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-05-10 15:35:10.588017607 +0200
@@ -23,18 +23,14 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_alloc.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2010-05-10 15:34:13.282003778 +0200
+++ xfs/fs/xfs/xfs_itable.c	2010-05-10 15:35:10.595282239 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-05-10 15:34:13.290004058 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-05-10 15:35:10.603005663 +0200
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
@@ -34,8 +33,6 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_log_recover.h"
 #include "xfs_trans_priv.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_rw.h"
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-10 15:34:13.303027245 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-05-10 15:35:10.610008038 +0200
@@ -24,14 +24,11 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-05-10 15:34:13.311007270 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-05-10 15:35:10.618005244 +0200
@@ -29,8 +29,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2010-05-10 15:34:13.319011950 +0200
+++ xfs/fs/xfs/xfs_rename.c	2010-05-10 15:35:10.621005524 +0200
@@ -27,8 +27,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2010-05-10 15:34:13.329004337 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2010-05-10 15:35:10.627266244 +0200
@@ -27,14 +27,8 @@
 #include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2010-05-10 15:34:13.337254302 +0200
+++ xfs/fs/xfs/xfs_rw.c	2010-05-10 15:35:10.632255628 +0200
@@ -24,26 +24,12 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_itable.h"
-#include "xfs_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
-#include "xfs_attr.h"
-#include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_buf_item.h"
 #include "xfs_rw.h"
-#include "xfs_trace.h"
 
 /*
  * Force a shutdown of the filesystem instantly while keeping
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-10 15:34:13.345274277 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-10 15:35:10.635255768 +0200
@@ -24,15 +24,12 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-10 15:34:13.355254093 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-10 15:35:10.643317299 +0200
@@ -24,13 +24,10 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_buf_item.h"
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-05-10 15:34:13.369004267 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-10 15:35:10.649255768 +0200
@@ -24,17 +24,13 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2010-05-10 15:34:13.377012020 +0200
+++ xfs/fs/xfs/xfs_utils.c	2010-05-10 15:35:10.655255349 +0200
@@ -27,15 +27,12 @@
 #include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
-#include "xfs_rw.h"
 #include "xfs_itable.h"
 #include "xfs_utils.h"
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-05-10 15:34:13.389003988 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-05-10 15:35:10.661255558 +0200
@@ -29,15 +29,11 @@
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_itable.h"
-#include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-10 15:34:13.398004616 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-10 15:35:10.672005663 +0200
@@ -30,12 +30,10 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_mount.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_dir2_data.h"
 #include "xfs_dir2_leaf.h"
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-05-10 15:34:13.406003988 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-05-10 15:35:10.680254930 +0200
@@ -28,15 +28,11 @@
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
-#include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2010-05-10 15:34:13.414004197 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2010-05-10 15:35:10.682255209 +0200
@@ -30,7 +30,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2010-05-10 15:34:13.428254372 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2010-05-10 15:35:10.687292295 +0200
@@ -28,7 +28,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2010-05-10 15:34:13.437276302 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2010-05-10 15:35:10.692280352 +0200
@@ -28,7 +28,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_dir2_data.h"
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2010-05-10 15:34:13.446254302 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2010-05-10 15:35:10.695255628 +0200
@@ -28,7 +28,6 @@
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2010-05-10 15:34:13.454275534 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2010-05-10 15:35:10.703255349 +0200
@@ -28,7 +28,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2010-05-10 15:34:13.463025569 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2010-05-10 15:35:10.709005593 +0200
@@ -28,7 +28,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
