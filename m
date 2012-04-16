Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G5Eqv8171559 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 00:14:52 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LsJ3pdgj00orvvMt for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 22:14:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SJeGe-0000mU-Ab
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:24 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SJeGe-0005NJ-76
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: clean up xfs_bit.h includes
Date: Mon, 16 Apr 2012 15:14:11 +1000
Message-Id: <1334553251-20571-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1334553251-20571-1-git-send-email-david@fromorbit.com>
References: <1334553251-20571-1-git-send-email-david@fromorbit.com>
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

With the removal of xfs_rw.h and other changes over time, xfs_bit.h
is being included in many files that don't actually need it. Clean
up the includes as necessary.

Also move the only-used-once xfs_ialloc_find_free() static inline
function out of a header file that is widely included to reduce
the number of needless dependencies on xfs_bit.h.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c |    1 -
 fs/xfs/xfs_aops.c        |    1 -
 fs/xfs/xfs_dfrag.c       |    1 -
 fs/xfs/xfs_dir2.c        |    1 -
 fs/xfs/xfs_dquot_item.c  |    1 -
 fs/xfs/xfs_file.c        |    1 -
 fs/xfs/xfs_fsops.c       |    1 -
 fs/xfs/xfs_ialloc.c      |    7 +++++++
 fs/xfs/xfs_ialloc.h      |    9 ---------
 fs/xfs/xfs_iget.c        |    1 -
 fs/xfs/xfs_inode.c       |    1 -
 fs/xfs/xfs_inode_item.c  |    1 -
 fs/xfs/xfs_ioctl.c       |    1 -
 fs/xfs/xfs_ioctl32.c     |    1 -
 fs/xfs/xfs_iomap.c       |    1 -
 fs/xfs/xfs_iops.c        |    1 -
 fs/xfs/xfs_itable.c      |    1 -
 fs/xfs/xfs_log.c         |    1 -
 fs/xfs/xfs_log_cil.c     |    1 -
 fs/xfs/xfs_qm_bhv.c      |    1 -
 fs/xfs/xfs_super.c       |    1 -
 fs/xfs/xfs_sync.c        |    1 -
 fs/xfs/xfs_trace.c       |    1 -
 fs/xfs/xfs_trans.c       |    1 -
 fs/xfs/xfs_trans_buf.c   |    1 -
 fs/xfs/xfs_trans_dquot.c |    1 -
 fs/xfs/xfs_trans_inode.c |    1 -
 fs/xfs/xfs_utils.c       |    1 -
 28 files changed, 7 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 68ebabc..f1647ca 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5584c5c..91e3ed8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index f39205f..e00de08 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index a2e2701..67a250c 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 9610e52..57aa4b0 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 762ce4e..42b522f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 537c2ae..75593d9 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index d094a23..177a21a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -609,6 +609,13 @@ xfs_ialloc_get_rec(
 /*
  * Visible inode allocation functions.
  */
+/*
+ * Find a free (set) bit in the inode bitmask.
+ */
+static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
+{
+	return xfs_lowbit64(*fp);
+}
 
 /*
  * Allocate an inode on disk.
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 666a037..65ac57c 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -47,15 +47,6 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 }
 
 /*
- * Find a free (set) bit in the inode bitmask.
- */
-static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
-{
-	return xfs_lowbit64(*fp);
-}
-
-
-/*
  * Allocate an inode on disk.
  * Mode is used to tell whether the new inode will need space, and whether
  * it is a directory.
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index ab89ca7..7f81397 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -19,7 +19,6 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_acl.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c6fb5f0..72ec1a4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -20,7 +20,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a8d5fdd..6cdbf90 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 706029f..3a05a41 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c79fa5f..c4f2da0 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -22,7 +22,6 @@
 #include <asm/uaccess.h>
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 845cea0..361f279 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e7a6660..1a25fd8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_acl.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index acc2bf2..eff577a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 97e489b..9b10a15 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0d42422..a07943b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index cd70529..6b39115 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9ec7626b..6df97d2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -17,7 +17,6 @@
  */
 
 #include "xfs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index f7f019f..67434e1 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 0115378..624bedd 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f674855..cdf896f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -19,7 +19,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 743d7a5..d250afa 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 72236b0..bcb6054 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -17,7 +17,6 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 82fd520..d2eee20 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0732231..4e5b9ad 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
-#include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
