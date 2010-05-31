Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6YSQ178921 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CE6E157FB97
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XfhQD6p1pmWh3pKd for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xw-0000uz-6s
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:00 +0000
Message-Id: <20100531160900.057188886@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/17] xfs: remove unneeded #include statements
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-reduce-includes
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

---

V1 -> V2

 - updated to account for the delayed logging branch merge

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-05-25 11:14:59.286031150 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-05-25 11:38:00.497004330 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-05-25 11:14:59.236274548 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-05-25 11:38:00.498004261 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-25 11:14:59.237275526 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-25 11:38:00.505033035 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-25 11:14:59.317003422 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-25 11:38:00.512033733 +0200
@@ -28,11 +28,8 @@
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-05-25 11:14:59.319042045 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-05-25 11:38:00.519033454 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-25 11:15:23.496005936 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-25 11:38:00.525005726 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-05-25 11:14:59.335006286 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-05-25 11:38:00.531005657 +0200
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
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.c	2010-05-25 11:14:59.338005727 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.c	2010-05-25 11:38:00.534004958 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-25 11:14:59.344006076 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-25 11:38:00.540006006 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-25 11:14:59.350033035 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-25 11:38:00.546006565 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-05-25 11:14:59.357004121 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-05-25 11:38:00.552267005 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2010-05-25 11:14:59.361013061 +0200
+++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2010-05-25 11:38:00.557255481 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_qm_stats.c	2010-05-25 11:14:59.363010267 +0200
+++ xfs/fs/xfs/quota/xfs_qm_stats.c	2010-05-25 11:38:00.560284396 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-25 11:14:59.368004121 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-25 11:38:00.565285095 +0200
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
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-05-25 11:14:59.372003632 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-05-25 11:38:00.570255481 +0200
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
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-05-25 11:14:59.381273222 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-05-25 11:38:00.578255621 +0200
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
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2010-05-25 11:14:59.386036737 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2010-05-25 11:38:00.584254923 +0200
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
--- xfs.orig/fs/xfs/xfs_attr.c	2010-05-25 11:14:59.390255762 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-05-25 11:38:00.592255901 +0200
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
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2010-05-25 11:14:59.398255692 +0200
+++ xfs/fs/xfs/xfs_attr_leaf.c	2010-05-25 11:38:00.599285444 +0200
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
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2010-05-25 11:14:59.404255552 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2010-05-25 11:38:00.605255621 +0200
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
--- xfs.orig/fs/xfs/xfs_btree.c	2010-05-25 11:14:59.410003911 +0200
+++ xfs/fs/xfs/xfs_btree.c	2010-05-25 11:38:00.611255412 +0200
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
--- xfs.orig/fs/xfs/xfs_dfrag.c	2010-05-25 11:14:59.430031918 +0200
+++ xfs/fs/xfs/xfs_dfrag.c	2010-05-25 11:38:00.613284745 +0200
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
--- xfs.orig/fs/xfs/xfs_error.c	2010-05-25 11:14:59.684255901 +0200
+++ xfs/fs/xfs/xfs_error.c	2010-05-25 11:38:00.620282861 +0200
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
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-05-25 11:14:59.694256111 +0200
+++ xfs/fs/xfs/xfs_filestream.c	2010-05-25 11:38:00.627283908 +0200
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
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-05-25 11:14:59.700275318 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2010-05-25 11:38:00.634282791 +0200
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
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-05-25 11:14:59.705254086 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2010-05-25 11:38:00.640284956 +0200
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
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2010-05-25 11:14:59.709254155 +0200
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2010-05-25 11:38:00.646284886 +0200
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
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-25 11:14:59.713253736 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-25 11:38:00.653255482 +0200
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
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-25 11:14:59.716253946 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-25 11:38:00.661255413 +0200
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
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-25 11:14:59.722275178 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-25 11:38:00.664256321 +0200
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
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-05-25 11:14:59.733005937 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-05-25 11:38:00.669284676 +0200
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
--- xfs.orig/fs/xfs/xfs_itable.c	2010-05-25 11:14:59.740006635 +0200
+++ xfs/fs/xfs/xfs_itable.c	2010-05-25 11:38:00.674285794 +0200
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
--- xfs.orig/fs/xfs/xfs_log.c	2010-05-25 11:14:59.753006007 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-05-25 11:38:00.683255622 +0200
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
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-25 11:14:59.762003492 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-05-25 11:38:00.689033734 +0200
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
--- xfs.orig/fs/xfs/xfs_mount.c	2010-05-25 11:14:59.764011664 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-05-25 11:38:00.697283978 +0200
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
--- xfs.orig/fs/xfs/xfs_rename.c	2010-05-25 11:14:59.266265051 +0200
+++ xfs/fs/xfs/xfs_rename.c	2010-05-25 11:38:00.703005448 +0200
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
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2010-05-25 11:14:59.778003841 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2010-05-25 11:38:00.706025842 +0200
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
--- xfs.orig/fs/xfs/xfs_rw.c	2010-05-25 11:14:59.784026331 +0200
+++ xfs/fs/xfs/xfs_rw.c	2010-05-25 11:38:00.711005378 +0200
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
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-25 11:14:59.797257578 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-25 11:38:00.715067607 +0200
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
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-25 11:14:59.808006007 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-25 11:38:00.720005588 +0200
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
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-05-25 11:14:59.816006845 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-25 11:38:00.729033873 +0200
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
--- xfs.orig/fs/xfs/xfs_utils.c	2010-05-25 11:14:59.820006076 +0200
+++ xfs/fs/xfs/xfs_utils.c	2010-05-25 11:38:00.736033663 +0200
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
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-05-25 11:14:59.274016343 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-05-25 11:38:00.742005377 +0200
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
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-25 11:14:59.261004260 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-25 11:38:00.753005587 +0200
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
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-05-25 11:14:59.424006216 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-05-25 11:38:00.760005726 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2.c	2010-05-25 11:14:59.435037366 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2010-05-25 11:38:00.762068235 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2010-05-25 11:14:59.440014527 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2010-05-25 11:38:00.767067886 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2010-05-25 11:14:59.442011873 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2010-05-25 11:38:00.775006634 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2010-05-25 11:14:59.454006216 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2010-05-25 11:38:00.780034013 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2010-05-25 11:14:59.671255345 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2010-05-25 11:38:00.788005377 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2010-05-25 11:14:59.678033455 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2010-05-25 11:38:00.794039181 +0200
@@ -28,7 +28,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2010-05-25 11:38:09.226004051 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2010-05-25 11:40:49.242004818 +0200
@@ -26,7 +26,6 @@
 #include "xfs_log_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_alloc.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
