Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBq2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 21:46:28 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E95E97EBC4
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:46:27 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A505F1001B2A
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 01:46:27 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove unused header files
Message-ID: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
Date: Thu, 20 Jun 2019 20:46:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

There are many, many xfs header files which are included but
unneeded (or included twice) in the xfs code, so remove them.

nb: xfs_linux.h includes about 9 headers for everyone, so those
explicit includes get removed by this.  I'm not sure what the
preference is, but if we wanted explicit includes everywhere,
a followup patch could remove those xfs_*.h includes from
xfs_linux.h and move them into the files that need them.
Or it could be left as-is.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 libxfs/xfs_ag.c             |    1 -
 libxfs/xfs_ag_resv.c        |   10 ----------
 libxfs/xfs_alloc.c          |    4 ----
 libxfs/xfs_alloc_btree.c    |    3 ---
 libxfs/xfs_attr.c           |    6 ------
 libxfs/xfs_attr_leaf.c      |    5 -----
 libxfs/xfs_attr_remote.c    |   10 ----------
 libxfs/xfs_bit.c            |    1 -
 libxfs/xfs_bmap.c           |    8 --------
 libxfs/xfs_bmap_btree.c     |    4 ----
 libxfs/xfs_btree.c          |    5 -----
 libxfs/xfs_da_btree.c       |    7 -------
 libxfs/xfs_da_format.c      |    5 -----
 libxfs/xfs_defer.c          |    3 ---
 libxfs/xfs_dir2.c           |    7 -------
 libxfs/xfs_dir2_block.c     |    5 -----
 libxfs/xfs_dir2_data.c      |    5 -----
 libxfs/xfs_dir2_leaf.c      |    5 -----
 libxfs/xfs_dir2_node.c      |    4 ----
 libxfs/xfs_dir2_sf.c        |    5 -----
 libxfs/xfs_dquot_buf.c      |    4 ----
 libxfs/xfs_ialloc.c         |    5 -----
 libxfs/xfs_ialloc_btree.c   |    4 ----
 libxfs/xfs_iext_tree.c      |    2 --
 libxfs/xfs_inode_buf.c      |    4 ----
 libxfs/xfs_inode_fork.c     |    2 --
 libxfs/xfs_log_rlimit.c     |    3 ---
 libxfs/xfs_refcount.c       |    5 -----
 libxfs/xfs_refcount_btree.c |    4 ----
 libxfs/xfs_rmap.c           |   10 ----------
 libxfs/xfs_rmap_btree.c     |    6 ------
 libxfs/xfs_rtbitmap.c       |    9 ---------
 libxfs/xfs_sb.c             |    7 -------
 libxfs/xfs_symlink_remote.c |    5 -----
 libxfs/xfs_trans_resv.c     |    3 ---
 libxfs/xfs_types.c          |   11 -----------
 scrub/agheader.c            |    9 ---------
 scrub/agheader_repair.c     |    6 ------
 scrub/alloc.c               |    9 ---------
 scrub/attr.c                |   10 ----------
 scrub/bitmap.c              |    7 -------
 scrub/bmap.c                |   10 ----------
 scrub/btree.c               |    9 ---------
 scrub/common.c              |   10 ----------
 scrub/dabtree.c             |    9 ---------
 scrub/dir.c                 |   12 ------------
 scrub/fscounters.c          |   15 ---------------
 scrub/health.c              |   10 ----------
 scrub/ialloc.c              |    9 ---------
 scrub/inode.c               |   12 ------------
 scrub/parent.c              |   10 ----------
 scrub/quota.c               |   13 -------------
 scrub/refcount.c            |   12 ------------
 scrub/repair.c              |   10 ----------
 scrub/rmap.c                |   11 -----------
 scrub/rtbitmap.c            |    9 ---------
 scrub/scrub.c               |   23 -----------------------
 scrub/symlink.c             |   10 ----------
 scrub/trace.c               |    8 --------
 xfs_acl.c                   |    1 -
 xfs_aops.c                  |    4 ----
 xfs_attr_inactive.c         |    7 -------
 xfs_attr_list.c             |    7 -------
 xfs_bmap_item.c             |    3 ---
 xfs_bmap_util.c             |    6 ------
 xfs_buf.c                   |    1 -
 xfs_buf_item.c              |    4 ----
 xfs_dir2_readdir.c          |    5 -----
 xfs_discard.c               |    3 ---
 xfs_dquot.c                 |    5 -----
 xfs_dquot_item.c            |    2 --
 xfs_error.c                 |    5 -----
 xfs_export.c                |    3 ---
 xfs_extent_busy.c           |    2 --
 xfs_extfree_item.c          |    3 ---
 xfs_file.c                  |    4 ----
 xfs_filestream.c            |    3 ---
 xfs_fsmap.c                 |    6 ------
 xfs_fsops.c                 |    5 -----
 xfs_globals.c               |    1 -
 xfs_health.c                |    6 ------
 xfs_icache.c                |    2 --
 xfs_icreate_item.c          |    5 -----
 xfs_inode.c                 |    7 -------
 xfs_inode_item.c            |    2 --
 xfs_ioctl.c                 |    4 ----
 xfs_ioctl32.c               |    3 ---
 xfs_iomap.c                 |    4 ----
 xfs_iops.c                  |    8 --------
 xfs_itable.c                |    2 --
 xfs_log.c                   |    6 ------
 xfs_log_cil.c               |    5 -----
 xfs_log_recover.c           |    4 ----
 xfs_message.c               |    2 --
 xfs_mount.c                 |    5 -----
 xfs_pnfs.c                  |    6 ------
 xfs_qm.c                    |    5 -----
 xfs_qm_bhv.c                |    2 --
 xfs_qm_syscalls.c           |    5 -----
 xfs_quotaops.c              |    1 -
 xfs_refcount_item.c         |    2 --
 xfs_reflink.c               |   12 ------------
 xfs_rmap_item.c             |    3 ---
 xfs_rtalloc.c               |    7 -------
 xfs_super.c                 |    5 -----
 xfs_symlink.c               |   10 ----------
 xfs_sysctl.c                |    2 --
 xfs_sysfs.c                 |    2 --
 xfs_trace.c                 |    9 ---------
 xfs_trans.c                 |    2 --
 xfs_trans_ail.c             |    2 --
 xfs_trans_bmap.c            |    4 ----
 xfs_trans_buf.c             |    3 ---
 xfs_trans_dquot.c           |    2 --
 xfs_trans_extfree.c         |    1 -
 xfs_trans_inode.c           |    4 ----
 xfs_trans_refcount.c        |    2 --
 xfs_trans_rmap.c            |    2 --
 xfs_xattr.c                 |    4 ----
 119 files changed, 672 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5efb82744664..e9c123eaeaa0 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -6,7 +6,6 @@
  */
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e2ba2a3b63b2..29f39a07211c 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -4,25 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_alloc.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
-#include "xfs_bit.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ag_resv.h"
-#include "xfs_trans_space.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index dbbff823d9e2..4eea311aba05 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
@@ -13,15 +12,12 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 9fe949f6055e..402fef4f8792 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -4,8 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -17,7 +15,6 @@
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c441f41f14e8..e12452eb0f19 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -4,28 +4,22 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
-#include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1f6e3965ff74..0a176a3cdf4f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -5,19 +5,15 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
@@ -27,7 +23,6 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
-#include "xfs_cksum.h"
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 8b47f9110ddd..950b2133df64 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -5,8 +5,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -16,18 +14,10 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_attr.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_attr_remote.h"
-#include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
-#include "xfs_buf_item.h"
 #include "xfs_error.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 40ce5f3094d1..7071ff98fdbc 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
@@ -5,7 +5,6 @@
  */
 #include "xfs.h"
 #include "xfs_log_format.h"
-#include "xfs_bit.h"
 
 /*
  * XFS bit manipulation routines, used in non-realtime code.
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4133bc461e3e..9417cfd3cd90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,26 +12,19 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtalloc.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
-#include "xfs_buf_item.h"
 #include "xfs_trace.h"
-#include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index aff82ed112c9..4c98db534f8f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -4,17 +4,14 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
-#include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
@@ -22,7 +19,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_rmap.h"
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7d3d7c42da40..4c61f1934854 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4,23 +4,18 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
-#include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
 #include "xfs_btree.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_alloc.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e2737e2ac2ae..a7726624187d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -5,27 +5,20 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
-#include "xfs_inode_item.h"
-#include "xfs_alloc.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b39053dcb643..3c048eaeb001 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -5,17 +5,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1c6bf2105939..1440f56c3843 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -4,13 +4,10 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 156ce95c9c45..0116ae7d5ec2 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -4,22 +4,15 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_ialloc.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index b7d6d78f4ce2..922356e83f83 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -5,23 +5,18 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_log.h"
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index b7b9ce002cb9..d7c95eacd026 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -5,20 +5,15 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
-#include "xfs_cksum.h"
 #include "xfs_log.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9c2a0a13ed61..c394f9de03dd 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -5,13 +5,10 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
@@ -20,8 +17,6 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
-#include "xfs_cksum.h"
-#include "xfs_log.h"
 
 /*
  * Local function declarations.
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 16731d2d684b..d781aa11b330 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -5,13 +5,10 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
@@ -20,7 +17,6 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
-#include "xfs_cksum.h"
 #include "xfs_log.h"
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 585dfdb7b6b6..99b48eed9d4f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -4,17 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_error.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 88fa11071f9f..28c6bf52f1a8 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -5,8 +5,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -16,8 +14,6 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_error.h"
-#include "xfs_cksum.h"
-#include "xfs_trace.h"
 
 int
 xfs_calc_dquots_per_chunk(
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0f5ff2a4b0b8..9534296f9aa7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -12,17 +11,13 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_rtalloc.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ac4b65da4c2b..100a889f2a95 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -4,21 +4,17 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
 
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index bc690f2409fa..61c2bce88e19 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -11,10 +11,8 @@
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_bmap.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fd7c02ee744b..c7dde8582d22 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -4,17 +4,13 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
-#include "xfs_cksum.h"
 #include "xfs_icache.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f9acf1d436f6..38f6d1e7b288 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -6,7 +6,6 @@
 #include <linux/log2.h>
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -19,7 +18,6 @@
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_attr_sf.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 1b542ec11d5d..c7b1d5fdb825 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 542aa1475b5f..53d56cfc93da 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -4,22 +4,17 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 5d9de9b21726..4eb333e4decf 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -4,20 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_rmap.h"
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8ed885507dd8..41d487c490e6 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -4,30 +4,20 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
-#include "xfs_extent_busy.h"
-#include "xfs_bmap.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 5d1f8884c888..4578401f9b5b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -4,23 +4,17 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index eaaff67e9626..41d23ef1df21 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,15 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
-#include "xfs_trans_space.h"
-#include "xfs_trace.h"
-#include "xfs_buf.h"
-#include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 326872eced21..1e3a9da28451 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -4,21 +4,16 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_bmap_btree.h"
@@ -26,10 +21,8 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_bmap.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_health.h"
 
 /*
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index a0ccc253c43d..a3f4ebe15b9b 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -5,18 +5,13 @@
  * All rights reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
-#include "xfs_trace.h"
-#include "xfs_symlink.h"
-#include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 9d1326d14af9..d790dfc9540b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -5,7 +5,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -15,12 +14,10 @@
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_ialloc.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
-#include "xfs_trace.h"
 
 #define _ALLOC	true
 #define _FREE	false
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index a2bd9f5a5e30..2bc0f57b119d 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -5,21 +5,10 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index adaeabdefdd3..184572e1f416 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -4,25 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 
 /* Superblock */
 
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 64e31f87d490..bb8c328f4d1f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -4,27 +4,21 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 44883e9112ad..8a4d856ceafb 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -4,24 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "scrub/trace.h"
 
 /*
  * Set us up to scrub free space btrees.
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index dce74ec57038..487e35e80198 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -4,28 +4,18 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
-#include "xfs_dir2.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
-#include "scrub/trace.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index fdadc9e1dc49..94519f16d6e5 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -4,17 +4,10 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
-#include "scrub/xfs_scrub.h"
-#include "scrub/scrub.h"
-#include "scrub/common.h"
-#include "scrub/trace.h"
-#include "scrub/repair.h"
 #include "scrub/bitmap.h"
 
 /*
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a703cd58a90e..be91fb2ebb1b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -4,32 +4,22 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
 #include "xfs_alloc.h"
-#include "xfs_rtalloc.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_refcount.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "scrub/trace.h"
 
 /* Set us up with an inode's bmap. */
 int
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 117910db51b8..4af1482a2cf5 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -4,19 +4,10 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 973aa59975e3..39eabc7fa4bb 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -4,27 +4,19 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
@@ -32,11 +24,9 @@
 #include "xfs_trans_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-#include "scrub/btree.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 90527b094878..ab7bb7c4065e 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -4,25 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index a38a22785a1a..0792282d7588 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -4,29 +4,17 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-#include "xfs_itable.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_ialloc.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 #include "scrub/dabtree.h"
 
 /* Set us up to scrub directories. */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 07c11e3e6437..8570b195a6dd 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -4,27 +4,12 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
-#include "xfs_rmap.h"
-#include "xfs_error.h"
-#include "xfs_errortag.h"
-#include "xfs_icache.h"
-#include "xfs_health.h"
-#include "xfs_bmap.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 23cf8e2f25db..d4626e6bcd59 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -4,21 +4,11 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_inode.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
-#include "scrub/health.h"
 
 /*
  * Scrub and In-Core Filesystem Health Assessments
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 3c3abd096143..9d67e2cacaf8 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -4,26 +4,17 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_icache.h"
 #include "xfs_rmap.h"
-#include "xfs_log.h"
-#include "xfs_trans_priv.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e213efc194a1..5fd58df22eb2 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -4,32 +4,20 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_icache.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
 #include "xfs_ialloc.h"
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
-#include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "scrub/trace.h"
 
 /*
  * Grab total control of the inode metadata.  It doesn't matter here if
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index d5d197f1b80f..99067efebc7c 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -4,26 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_ialloc.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
 int
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index de75effddb0d..2f56d452508b 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -4,29 +4,16 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
-#include "xfs_alloc.h"
-#include "xfs_bmap.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_dquot.h"
-#include "xfs_dquot_item.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 static inline uint
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 708b4158eb90..643b50f032f8 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -4,25 +4,13 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "scrub/trace.h"
 
 /*
  * Set us up to scrub reference count btrees.
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e710005a0c9e..431083a973ef 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -4,34 +4,24 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_icache.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
-#include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
-#include "xfs_trans_space.h"
 #include "xfs_quota.h"
-#include "xfs_attr.h"
-#include "xfs_reflink.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 92a140c5b55e..1e43801bce8f 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -4,26 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_btree.h"
-#include "xfs_bit.h"
-#include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "scrub/trace.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index dbe115b075f7..fa0b4fb81d5a 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -4,24 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 
 /* Set us up with the realtime metadata locked. */
 int
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f630389ee176..6fb0719f6726 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -4,41 +4,18 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_icache.h"
-#include "xfs_itable.h"
-#include "xfs_alloc.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_refcount.h"
-#include "xfs_refcount_btree.h"
-#include "xfs_rmap.h"
-#include "xfs_rmap_btree.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
-#include "xfs_log.h"
-#include "xfs_trans_priv.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-#include "scrub/btree.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
 
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index f7ebaa946999..45da5172265c 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -4,24 +4,14 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_btree.h"
-#include "xfs_bit.h"
 #include "xfs_log_format.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
 #include "xfs_inode.h"
-#include "xfs_inode_fork.h"
 #include "xfs_symlink.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-#include "scrub/trace.h"
 
 /* Set us up to scrub a symbolic link. */
 int
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 96feaf8dcdec..195a733a2d18 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -4,21 +4,13 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_trans.h"
-#include "xfs_bit.h"
-#include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
-#include "scrub/common.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 8039e35147dd..1dd3429b5278 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -9,7 +9,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include <linux/slab.h>
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6f0f4761a37..12232b5253a1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -12,14 +12,10 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
-#include "xfs_alloc.h"
-#include "xfs_error.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include <linux/writeback.h>
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 228821b2ebe0..3a77b17c2629 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -5,8 +5,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -15,18 +13,13 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
-#include "xfs_alloc.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_error.h"
 #include "xfs_quota.h"
-#include "xfs_trace.h"
 #include "xfs_dir2.h"
-#include "xfs_defer.h"
 
 /*
  * Look at all the extents for this logical region,
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 3d213a7394c5..f4a035b6fbbc 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -5,26 +5,19 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
-#include "xfs_buf_item.h"
-#include "xfs_cksum.h"
 #include "xfs_dir2.h"
 
 STATIC int
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ce45f066995e..c04afd852cce 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -14,12 +13,10 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_log.h"
 #include "xfs_bmap.h"
 #include "xfs_icache.h"
-#include "xfs_trace.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b8fa6d337413..a2db249518fa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -5,19 +5,16 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
 #include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
-#include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
@@ -28,11 +25,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_log.h"
-#include "xfs_rmap_btree.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
-#include "xfs_refcount.h"
 
 /* Kernel only BMAP related definitions and functions */
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index be8afa1673c7..a682e07e769b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -29,7 +29,6 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 
 static kmem_zone_t *xfs_buf_zone;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 65b32acfa0f6..b05ea2803bd5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -4,20 +4,16 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
-#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-#include "xfs_inode.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5142e64e2345..e9a83f11987a 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -5,18 +5,13 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d0df0ed50f4b..e2241b3e2ac2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -9,14 +9,11 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_quota.h"
-#include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
-#include "xfs_discard.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a1af984e4913..231766b9bb8b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_shared.h"
@@ -14,16 +13,12 @@
 #include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
-#include "xfs_alloc.h"
 #include "xfs_quota.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 87b23ae44397..2644608f6b0a 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -4,14 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a1e177f66404..0dcedc58ded7 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -5,13 +5,8 @@
  */
 #include "xfs.h"
 #include "xfs_format.h"
-#include "xfs_fs.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
-#include "xfs_sysfs.h"
 #include "xfs_inode.h"
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f2284ceb129f..9482e1aaf40b 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -8,14 +8,11 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_export.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
-#include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_pnfs.h"
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 0ed68379e551..b5016e843de5 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -6,10 +6,8 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 74ddf66f4cfe..27741b4dceaa 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -12,10 +11,8 @@
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_log.h"
-#include "xfs_btree.h"
 #include "xfs_rmap.h"
 
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 916a35cae5e9..7db37fd9ac26 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -4,20 +4,16 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_error.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_ioctl.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 182501373af2..6444c3d3e12b 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -10,13 +10,10 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
-#include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3d76a9e35870..1f62503b5589 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -4,21 +4,15 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_error.h"
 #include "xfs_btree.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
-#include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
 #include "xfs_bit.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 773cb02e7312..e8aa1712668a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -4,22 +4,17 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
-#include "xfs_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_fsops.h"
 #include "xfs_trans_space.h"
-#include "xfs_rtalloc.h"
-#include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index d0d377384120..4e4a7a299ccb 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_sysctl.h"
 
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 4c4929f9e7bf..79fbbaccdc75 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -4,17 +4,11 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a76b27565a18..202c49a6321f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -4,14 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 8381d34cb102..a2c3fa3c375b 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -4,16 +4,11 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_bit.h"
-#include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_error.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 48756e0219fa..141336d69726 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -7,7 +7,6 @@
 #include <linux/iversion.h>
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -16,10 +15,7 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_inode.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
-#include "xfs_attr_sf.h"
 #include "xfs_attr.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
@@ -28,11 +24,9 @@
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_filestream.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
@@ -40,7 +34,6 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
-#include "xfs_dir2_priv.h"
 
 kmem_zone_t *xfs_inode_zone;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..b75f4ce24736 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -12,7 +11,6 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
-#include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d7dfc13f30f5..375e8b2c5988 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -4,15 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_ioctl.h"
-#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
@@ -25,7 +22,6 @@
 #include "xfs_export.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_acl.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 614fc6886d24..d5c38032957d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -10,16 +10,13 @@
 #include <linux/uaccess.h>
 #include <linux/fsmap.h>
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_itable.h"
-#include "xfs_error.h"
 #include "xfs_fsops.h"
-#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 63d323916bba..2f120d57430e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -6,26 +6,22 @@
  */
 #include <linux/iomap.h>
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
-#include "xfs_icache.h"
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 74047bd0c1ae..2d21262c995c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -4,29 +4,21 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
 #include "xfs_inode.h"
-#include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
-#include "xfs_error.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
-#include "xfs_trans_space.h"
 #include "xfs_iomap.h"
-#include "xfs_defer.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index eef307cf90a7..a6db319b6bbd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -16,7 +15,6 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
-#include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2466b0f5b6c4..9f00f2b03a12 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -4,23 +4,17 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_log_recover.h"
-#include "xfs_inode.h"
 #include "xfs_trace.h"
-#include "xfs_fsops.h"
-#include "xfs_cksum.h"
 #include "xfs_sysfs.h"
 #include "xfs_sb.h"
 #include "xfs_health.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5e595948bc5a..a5729bfc257a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -4,16 +4,11 @@
  */
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_error.h"
-#include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
-#include "xfs_discard.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6f30a2fd6f63..53c435f3347d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
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
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_log.h"
@@ -26,7 +23,6 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_quota.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 6b736ea58d35..0b02adaea096 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -4,10 +4,8 @@
  */
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_error.h"
 #include "xfs_format.h"
-#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4e2c63649cab..30237da0e083 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -12,9 +11,6 @@
 #include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_ialloc.h"
@@ -27,7 +23,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
-#include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
 #include "xfs_rmap_btree.h"
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index bde2c9f56a46..f58d97f35939 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -7,18 +7,12 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_log.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
-#include "xfs_error.h"
 #include "xfs_iomap.h"
 #include "xfs_shared.h"
-#include "xfs_bit.h"
-#include "xfs_pnfs.h"
 
 /*
  * Ensure that we do not have any outstanding pNFS layouts that can be used by
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa6b6db3db0e..a762514839ba 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -13,19 +12,15 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_quota.h"
-#include "xfs_error.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_bmap_util.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_cksum.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 3091e4bc04ef..7635b0dcb6b6 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -4,14 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b3190890f096..a2e9813181e3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -7,22 +7,17 @@
 #include <linux/capability.h>
 
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_defer.h"
 
 STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
 STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index a7c0c657dfaf..69f8519af48b 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -11,7 +11,6 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
-#include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_qm.h"
 #include <linux/quota.h>
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fce38b56b962..06d859f0acec 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -14,7 +13,6 @@
 #include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_refcount_item.h"
 #include "xfs_log.h"
 #include "xfs_refcount.h"
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 680ae7662a78..48bbfe1178ca 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -4,28 +4,18 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
-#include "xfs_error.h"
-#include "xfs_dir2.h"
-#include "xfs_dir2_priv.h"
-#include "xfs_ioctl.h"
 #include "xfs_trace.h"
-#include "xfs_log.h"
 #include "xfs_icache.h"
-#include "xfs_pnfs.h"
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
@@ -33,11 +23,9 @@
 #include "xfs_trans_space.h"
 #include "xfs_bit.h"
 #include "xfs_alloc.h"
-#include "xfs_quota_defs.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
-#include "xfs_rmap_btree.h"
 #include "xfs_sb.h"
 #include "xfs_ag_resv.h"
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 127dc9c32a54..e87930a1a15c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -4,17 +4,14 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_shared.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_rmap_item.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ac0fcdad0c4e..52d52f12fd67 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -4,24 +4,17 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
-#include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
-#include "xfs_trace.h"
-#include "xfs_buf.h"
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 594c119824cc..831a0f62ced3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -5,24 +5,20 @@
  */
 
 #include "xfs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
-#include "xfs_error.h"
 #include "xfs_fsops.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_extfree_item.h"
 #include "xfs_mru_cache.h"
@@ -38,7 +34,6 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
-#include "xfs_defer.h"
 
 #include <linux/namei.h>
 #include <linux/dax.h>
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b2c1177c717f..ceb0ba6c34ba 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -6,29 +6,19 @@
  */
 #include "xfs.h"
 #include "xfs_shared.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
-#include "xfs_defer.h"
 #include "xfs_dir2.h"
 #include "xfs_inode.h"
-#include "xfs_ialloc.h"
-#include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_bmap_util.h"
-#include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_symlink.h"
 #include "xfs_trans.h"
-#include "xfs_log.h"
 
 /* ----- Kernel only functions below ----- */
 int
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 0cc034dfb786..c786f9d088d7 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -6,8 +6,6 @@
 #include "xfs.h"
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
-#include "xfs_error.h"
-#include "xfs_stats.h"
 
 static struct ctl_table_header *xfs_table_header;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index cabda13f3c64..2eeddb573a35 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -5,14 +5,12 @@
  */
 
 #include "xfs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_sysfs.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_stats.h"
 #include "xfs_mount.h"
 
 struct xfs_sysfs_attr {
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index cb6489c22cad..8a550b98b410 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -4,8 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -15,24 +13,17 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_itable.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
-#include "xfs_attr_leaf.h"
 #include "xfs_trans.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_quota.h"
-#include "xfs_iomap.h"
-#include "xfs_aops.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_log_recover.h"
-#include "xfs_inode_item.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_filestream.h"
 #include "xfs_fsmap.h"
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 0746b329a937..408ed39c45aa 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -5,13 +5,11 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode.h"
 #include "xfs_extent_busy.h"
 #include "xfs_quota.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d3a4e89bf4a0..237fab9b8257 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -5,7 +5,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -13,7 +12,6 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
-#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log.h"
 
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index e1c7d55b32c3..e91e325662a8 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -4,17 +4,13 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_bmap_item.h"
-#include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index a1764a1dbd99..c74ea2cdb677 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -4,17 +4,14 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
-#include "xfs_error.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ba3de1f03b98..0092f85ccc86 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -4,14 +4,12 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
-#include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 8ee7a3f8bb20..4ae5683fae75 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 542927321a61..86f5a6eec213 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -4,17 +4,13 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
-#include "xfs_trace.h"
 
 #include <linux/iversion.h>
 
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 8d734728dd1b..6de3c98b11b8 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -14,7 +13,6 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_refcount_item.h"
-#include "xfs_alloc.h"
 #include "xfs_refcount.h"
 
 /*
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 5c7936b1be13..902e6387ef59 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -4,7 +4,6 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
@@ -14,7 +13,6 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_rmap_item.h"
-#include "xfs_alloc.h"
 #include "xfs_rmap.h"
 
 /* Set the map extent flags for this reverse mapping. */
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 9a63016009a1..14fa7f0c3e47 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -7,13 +7,9 @@
 #include "xfs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_attr.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_acl.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
