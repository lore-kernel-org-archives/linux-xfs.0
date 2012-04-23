Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N6071D128548 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 01:00:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2KLlryndgHpE72Dt for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 23:00:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJU-0001ba-3X
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:52 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCJE-0004Ym-W9
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/37] xfs: move xfsagino_t to xfs_types.h
Date: Mon, 23 Apr 2012 15:58:58 +1000
Message-Id: <1335160747-17254-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Untangle the header file includes a bit by moving the definition of
xfs_agino_t to xfs_types.h. This removes the dependency that xfs_ag.h has on
xfs_inum.h, meaning we don't need to include xfs_inum.h everywhere we include
xfs_ag.h.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c         |    1 -
 fs/xfs/xfs_alloc_btree.c   |    1 -
 fs/xfs/xfs_aops.c          |    1 -
 fs/xfs/xfs_attr.c          |    1 -
 fs/xfs/xfs_attr_leaf.c     |    1 -
 fs/xfs/xfs_bmap_btree.c    |    1 -
 fs/xfs/xfs_btree.c         |    1 -
 fs/xfs/xfs_buf.c           |    1 -
 fs/xfs/xfs_buf_item.c      |    1 -
 fs/xfs/xfs_da_btree.c      |    1 -
 fs/xfs/xfs_dfrag.c         |    1 -
 fs/xfs/xfs_dir2_block.c    |    1 -
 fs/xfs/xfs_dir2_data.c     |    1 -
 fs/xfs/xfs_dir2_leaf.c     |    1 -
 fs/xfs/xfs_dir2_node.c     |    1 -
 fs/xfs/xfs_dir2_sf.c       |    1 -
 fs/xfs/xfs_discard.c       |    1 -
 fs/xfs/xfs_dquot.c         |    1 -
 fs/xfs/xfs_dquot_item.c    |    1 -
 fs/xfs/xfs_error.c         |    1 -
 fs/xfs/xfs_export.c        |    1 -
 fs/xfs/xfs_extfree_item.c  |    1 -
 fs/xfs/xfs_file.c          |    1 -
 fs/xfs/xfs_fsops.c         |    1 -
 fs/xfs/xfs_ialloc_btree.c  |    1 -
 fs/xfs/xfs_inode_item.c    |    1 -
 fs/xfs/xfs_inum.h          |    5 -----
 fs/xfs/xfs_ioctl.c         |    1 -
 fs/xfs/xfs_ioctl32.c       |    1 -
 fs/xfs/xfs_iomap.c         |    1 -
 fs/xfs/xfs_iops.c          |    1 -
 fs/xfs/xfs_log.c           |    1 -
 fs/xfs/xfs_log_cil.c       |    1 -
 fs/xfs/xfs_message.c       |    1 -
 fs/xfs/xfs_qm.c            |    1 -
 fs/xfs/xfs_qm_bhv.c        |    1 -
 fs/xfs/xfs_qm_syscalls.c   |    1 -
 fs/xfs/xfs_quotaops.c      |    1 -
 fs/xfs/xfs_rename.c        |    1 -
 fs/xfs/xfs_rtalloc.c       |    1 -
 fs/xfs/xfs_rw.c            |    1 -
 fs/xfs/xfs_trace.c         |    1 -
 fs/xfs/xfs_trans.c         |    1 -
 fs/xfs/xfs_trans_ail.c     |    1 -
 fs/xfs/xfs_trans_buf.c     |    1 -
 fs/xfs/xfs_trans_dquot.c   |    1 -
 fs/xfs/xfs_trans_extfree.c |    1 -
 fs/xfs/xfs_trans_inode.c   |    1 -
 fs/xfs/xfs_types.h         |    5 +++++
 fs/xfs/xfs_utils.c         |    1 -
 fs/xfs/xfs_vnodeops.c      |    1 -
 51 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0f0df27..95ee705 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index ffb3386..e23cc97 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index eff2ea8..49d0525 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 0960bb6..561fd60 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -21,7 +21,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 3cd5dc6..7d89d80 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index e2f5d59..862084a 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 1f19f03..e53e317 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 59e3916..af8480d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -35,7 +35,6 @@
 #include <linux/freezer.h>
 
 #include "xfs_sb.h"
-#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a25206c..45df2b8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index b8adc79..015b946 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 1137bbc..f39205f 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index d3b63ae..586732f 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 5bbe2a8..2046988 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 66e108f..397ffbc 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 0179a41..b0f2678 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 79d05e8..19bf0c5 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 1ad3a4b..bbbabc8 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_sb.h"
-#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7bf3855..bf27fcc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index aa6a2a6..9610e52 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 39f0633..6104560 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 558910f..2d25d19 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_types.h"
-#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2960fc1..feb36d7 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c38110d..012abc1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e9f5bc0..2635e17 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index c6a7581..2b8b7a3 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3f96a94..a8d5fdd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_inum.h b/fs/xfs/xfs_inum.h
index b253c0e..90efdaf 100644
--- a/fs/xfs/xfs_inum.h
+++ b/fs/xfs/xfs_inum.h
@@ -26,11 +26,6 @@
  * high agno_log-agblklog-inopblog bits - 0
  */
 
-typedef	__uint32_t	xfs_agino_t;	/* within allocation grp inode number */
-
-#define	NULLFSINO	((xfs_ino_t)-1)
-#define	NULLAGINO	((xfs_agino_t)-1)
-
 struct xfs_mount;
 
 #define	XFS_INO_MASK(k)			(__uint32_t)((1ULL << (k)) - 1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 828b7cb..2b55af3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 542ce93..fad5a67 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -24,7 +24,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f65fee8..d44c3dd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index efdc461..e6d6a32 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -20,7 +20,6 @@
 #include "xfs_acl.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5e2aa52..dec1458 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 566a2d5..2a4540c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log_priv.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bd672de..331cd9f 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 755a9bd..249db19 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index e6986b5..cd70529 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c4f396e..858a3b1 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -22,7 +22,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 7e76f53..fed504f 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_sb.h"
-#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index e44ef7e..30ff5f4 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7434d3f..b6ef74d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 3c2488a..7e3644f 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9010ce8..0115378 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d012dd2..f446b00 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -21,7 +21,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2c0db81..9c51448 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -20,7 +20,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index ccc6da1..7d69213 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2790997..72236b0 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index f7590f5..8d71b16 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 7a7442c..82fd520 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 65584b5..398cf68 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -57,6 +57,7 @@ typedef __uint64_t __psunsigned_t;
 #endif	/* __KERNEL__ */
 
 typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
+typedef	__uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef	__uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef	__uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef __int32_t	xfs_extnum_t;	/* # of extents in a file */
@@ -101,6 +102,7 @@ typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
+
 /*
  * Null values for the types.
  */
@@ -120,6 +122,9 @@ typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 
+#define	NULLFSINO	((xfs_ino_t)-1)
+#define	NULLAGINO	((xfs_agino_t)-1)
+
 /*
  * Max values for extlen, extnum, aextnum.
  */
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 79c05ac..0732231 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -20,7 +20,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 9b6c94e..9e82669 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -21,7 +21,6 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
