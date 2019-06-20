Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55560 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFTV3k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:40 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/11] libxfs: remove unneeded includes
Date: Thu, 20 Jun 2019 16:29:29 -0500
Message-Id: <1561066174-13144-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c              |  7 -------
 libxfs/defer_item.c         |  3 ---
 libxfs/init.c               | 13 -------------
 libxfs/logitem.c            |  4 ----
 libxfs/rdwr.c               | 10 ----------
 libxfs/trans.c              |  3 ---
 libxfs/util.c               | 22 ----------------------
 libxfs/xfs_ag.c             |  2 --
 libxfs/xfs_ag_resv.c        | 12 ------------
 libxfs/xfs_alloc.c          |  5 -----
 libxfs/xfs_alloc_btree.c    |  5 -----
 libxfs/xfs_attr.c           |  3 ---
 libxfs/xfs_attr_leaf.c      |  5 -----
 libxfs/xfs_attr_remote.c    |  7 -------
 libxfs/xfs_bit.c            |  1 -
 libxfs/xfs_bmap.c           |  4 ----
 libxfs/xfs_bmap_btree.c     |  3 ---
 libxfs/xfs_btree.c          |  6 ------
 libxfs/xfs_da_btree.c       |  5 -----
 libxfs/xfs_da_format.c      |  5 -----
 libxfs/xfs_defer.c          |  7 -------
 libxfs/xfs_dir2.c           |  6 ------
 libxfs/xfs_dir2_block.c     |  4 ----
 libxfs/xfs_dir2_data.c      |  5 -----
 libxfs/xfs_dir2_leaf.c      |  4 ----
 libxfs/xfs_dir2_node.c      |  4 ----
 libxfs/xfs_dir2_sf.c        |  3 ---
 libxfs/xfs_dquot_buf.c      |  7 -------
 libxfs/xfs_ialloc.c         |  4 ----
 libxfs/xfs_ialloc_btree.c   |  4 ----
 libxfs/xfs_iext_tree.c      |  4 ----
 libxfs/xfs_inode_buf.c      |  5 -----
 libxfs/xfs_inode_fork.c     |  2 --
 libxfs/xfs_log_rlimit.c     |  3 ---
 libxfs/xfs_refcount.c       |  5 -----
 libxfs/xfs_refcount_btree.c |  5 -----
 libxfs/xfs_rmap.c           |  9 ---------
 libxfs/xfs_rmap_btree.c     |  6 ------
 libxfs/xfs_rtbitmap.c       |  5 -----
 libxfs/xfs_sb.c             |  7 -------
 libxfs/xfs_symlink_remote.c |  4 ----
 libxfs/xfs_trans_inode.c    |  4 ----
 libxfs/xfs_trans_resv.c     |  4 ----
 libxfs/xfs_types.c          | 11 -----------
 44 files changed, 247 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 139c7c1..b38bead 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -6,16 +6,9 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
 #include <pthread.h>
 
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_bit.h"
 
 #define CACHE_DEBUG 1
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 2ebc12b..6b4e1dc 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -4,13 +4,10 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
diff --git a/libxfs/init.c b/libxfs/init.c
index 1baccb3..96e0b94 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -8,19 +8,6 @@
 #include "init.h"
 
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
-#include "xfs_inode.h"
-#include "xfs_trans.h"
-#include "xfs_rmap_btree.h"
-#include "xfs_refcount_btree.h"
 
 #include "libxfs.h"		/* for now */
 
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 14c62f6..e7f368f 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -5,14 +5,10 @@
  */
 
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index e3ff584..7da7d3c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -7,16 +7,6 @@
 
 #include "libxfs_priv.h"
 #include "init.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
-#include "xfs_inode.h"
-#include "xfs_trans.h"
 
 #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 5c56b4f..0ed55f8 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -6,14 +6,11 @@
  */
 
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/libxfs/util.c b/libxfs/util.c
index 171a172..853b328 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -6,28 +6,6 @@
 
 #include "libxfs_priv.h"
 #include "libxfs.h"
-#include "libxfs_io.h"
-#include "init.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
-#include "xfs_inode.h"
-#include "xfs_trans.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_trans_space.h"
-#include "xfs_ialloc.h"
-#include "xfs_alloc.h"
-#include "xfs_bit.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
-#include "xfs_dir2_priv.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 014e2ad..77a070a 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -6,8 +6,6 @@
  */
 
 #include "libxfs_priv.h"
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 6242918..4aa95aa 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -4,24 +4,12 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_alloc.h"
-#include "xfs_errortag.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
-#include "xfs_trans.h"
-#include "xfs_bit.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ag_resv.h"
-#include "xfs_trans_space.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 7c2f2d7..adec16b 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -4,22 +4,17 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_errortag.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag_resv.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 5fa3c63..cd1dfdb 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -4,10 +4,7 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
@@ -15,8 +12,6 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
-#include "xfs_trans.h"
 
 
 STATIC struct xfs_btree_cur *
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 170e64c..ba51de7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -4,19 +4,16 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_sf.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1027ca0..22a8a3d 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -5,16 +5,12 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
@@ -24,7 +20,6 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_dir2.h"
 
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 7fe28a0..a2822c1 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -5,8 +5,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -16,14 +14,9 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_attr_remote.h"
-#include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
diff --git a/libxfs/xfs_bit.c b/libxfs/xfs_bit.c
index 3f97fa3..6a76a5a 100644
--- a/libxfs/xfs_bit.c
+++ b/libxfs/xfs_bit.c
@@ -5,7 +5,6 @@
  */
 #include "libxfs_priv.h"
 #include "xfs_log_format.h"
-#include "xfs_bit.h"
 
 /*
  * XFS bit manipulation routines, used in non-realtime code.
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cd570fb..aae8b08 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,8 +12,6 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
@@ -22,7 +19,6 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_errortag.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index b16f901..2a4190b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -4,14 +4,12 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
@@ -19,7 +17,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_rmap.h"
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index eb78a9a..f45c39d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4,21 +4,15 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_btree.h"
-#include "xfs_errortag.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
-#include "xfs_alloc.h"
 
 /*
  * Cursor allocation zone.
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 87b2bc3..91922eb 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -5,24 +5,19 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 
 /*
  * xfs_da_btree.c
diff --git a/libxfs/xfs_da_format.c b/libxfs/xfs_da_format.c
index 918bf99..158a8e8 100644
--- a/libxfs/xfs_da_format.c
+++ b/libxfs/xfs_da_format.c
@@ -5,17 +5,12 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
-#include "xfs_dir2_priv.h"
 
 /*
  * Shortform directory ops
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index d9d4271..9398d82 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -4,17 +4,10 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_bit.h"
-#include "xfs_sb.h"
-#include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
-#include "xfs_inode.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 6b51a52..cd7621b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -4,21 +4,15 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_ialloc.h"
-#include "xfs_errortag.h"
 #include "xfs_trace.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index d13fafa..f7577b7 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -5,20 +5,16 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 
 /*
  * Local function prototypes.
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index e3d698f..1d1a48a 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -5,18 +5,13 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
-#include "xfs_dir2_priv.h"
 #include "xfs_trans.h"
-#include "xfs_cksum.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 4c3a05a..31f737f 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -5,20 +5,16 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
-#include "xfs_cksum.h"
 
 /*
  * Local function declarations.
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 2de174c..4a54dcd 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -5,20 +5,16 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
-#include "xfs_cksum.h"
 
 /*
  * Function declarations.
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 24a0e61..729988a 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -4,13 +4,10 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 8bcae16..a59b230 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -5,16 +5,9 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode.h"
-#include "xfs_trans.h"
-#include "xfs_cksum.h"
-#include "xfs_trace.h"
 #include "xfs_quota_defs.h"
 
 int
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 0cdf39e..a838839 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -12,15 +11,12 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_errortag.h"
 #include "xfs_bmap.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 599c79d..6033419 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -4,20 +4,16 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
 
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 5bfe8f0..b5b168f 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -11,10 +11,6 @@
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_bmap.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 108e541..7abb71b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -4,16 +4,11 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
-#include "xfs_errortag.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4cad396..a502437 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -15,7 +14,6 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-#include "xfs_attr_sf.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 051c8fd..e21aade 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -12,9 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_trans_space.h"
-#include "xfs_inode.h"
 #include "xfs_da_btree.h"
-#include "xfs_attr_leaf.h"
 #include "xfs_bmap_btree.h"
 
 /*
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 0a517f5..7a3c9f6 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -4,21 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_errortag.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 65018b1..31ae0cf 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -4,21 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
-#include "xfs_bmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
-#include "xfs_bit.h"
 #include "xfs_rmap.h"
 
 static struct xfs_btree_cur *
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 42938e6..0911d1e 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -4,28 +4,19 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_errortag.h"
-#include "xfs_bmap.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 59abe41..3d86395 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -4,23 +4,17 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_ag_resv.h"
 
 /*
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index d7cde0d..74553c5 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,11 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc.h"
 #include "xfs_trans.h"
-#include "xfs_trans_space.h"
-#include "xfs_trace.h"
 
 
 /*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f1e2ba5..66af5ad 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -4,29 +4,22 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_bmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 66de21a..4666a3a 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -5,16 +5,12 @@
  * All rights reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 
 
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 87e6335..1d3b16f 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -4,15 +4,11 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_trace.h"
 
 /*
  * Add a locked inode to the transaction.
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 4ecf7c2..c73be3e 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -5,7 +5,6 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,12 +12,9 @@
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_inode.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
-#include "xfs_trace.h"
 #include "xfs_quota_defs.h"
 
 #define _ALLOC	true
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 715d205..cd69f60 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -5,21 +5,10 @@
  * All Rights Reserved.
  */
 #include "libxfs_priv.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_rmap.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
 
 /* Find the size of the AG, in blocks. */
 xfs_agblock_t
-- 
1.8.3.1
