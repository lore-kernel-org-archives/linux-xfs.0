Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 194FD7F53
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88008F8039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ubmhkn31ytvvBYNi for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:26 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006LU-LG
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002Bm-KT
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/16] xfs: decouple log and transaction headers
Date: Mon, 30 Sep 2013 13:07:01 +1000
Message-Id: <1380510433-8353-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

xfs_trans.h has a dependency on xfs_log.h for a couple of
structures. Most code that does transactions doesn't need to know
anything about the log, bu this dependency means that they have to
include xfs_log.h. Decouple the xfs_trans.h and xfs_log.h header
files and clean up the includes to be in dependency order.

In doing this, remove the direct include of xfs_trans_reserve.h from
xfs_trans.h so that we remove the dependency between xfs_trans.h and
xfs_mount.h. Hence the xfs_trans.h include can be moved to the
indicate the actual dependencies oher header files have on it.

Note that these are kernel only header files, so this does not
translate to any userspace changes at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c          |  6 ++++--
 fs/xfs/xfs_alloc_btree.c    |  6 +++---
 fs/xfs/xfs_aops.c           |  7 ++++---
 fs/xfs/xfs_attr.c           |  8 ++++----
 fs/xfs/xfs_attr_inactive.c  |  8 ++++----
 fs/xfs/xfs_attr_leaf.c      |  7 +++----
 fs/xfs/xfs_attr_list.c      |  6 +++---
 fs/xfs/xfs_attr_remote.c    |  7 +++----
 fs/xfs/xfs_bit.c            |  5 +----
 fs/xfs/xfs_bmap.c           |  7 ++++---
 fs/xfs/xfs_bmap_btree.c     |  5 +++--
 fs/xfs/xfs_bmap_util.c      |  9 +++++----
 fs/xfs/xfs_btree.c          |  5 +++--
 fs/xfs/xfs_buf.c            |  4 ++--
 fs/xfs/xfs_buf_item.c       |  7 ++++---
 fs/xfs/xfs_da_btree.c       |  7 ++++---
 fs/xfs/xfs_dir2.c           |  6 +++---
 fs/xfs/xfs_dir2_block.c     |  6 +++---
 fs/xfs/xfs_dir2_data.c      |  6 +++---
 fs/xfs/xfs_dir2_leaf.c      |  6 +++---
 fs/xfs/xfs_dir2_node.c      |  6 +++---
 fs/xfs/xfs_dir2_readdir.c   |  6 +++---
 fs/xfs/xfs_dir2_sf.c        |  6 +++---
 fs/xfs/xfs_discard.c        |  5 +++--
 fs/xfs/xfs_dquot.c          | 10 ++++++----
 fs/xfs/xfs_dquot_buf.c      |  5 +++--
 fs/xfs/xfs_dquot_item.c     |  6 ++++--
 fs/xfs/xfs_error.c          |  5 ++---
 fs/xfs/xfs_export.c         |  7 ++++---
 fs/xfs/xfs_extent_busy.c    |  6 ++++--
 fs/xfs/xfs_extfree_item.c   |  8 ++++----
 fs/xfs/xfs_file.c           |  6 ++++--
 fs/xfs/xfs_filestream.c     | 10 +++++-----
 fs/xfs/xfs_fsops.c          |  9 +++++----
 fs/xfs/xfs_ialloc.c         |  7 ++++---
 fs/xfs/xfs_ialloc_btree.c   |  6 +++---
 fs/xfs/xfs_icache.c         |  9 ++++-----
 fs/xfs/xfs_icreate_item.c   |  5 +++--
 fs/xfs/xfs_inode.c          | 12 +++++++-----
 fs/xfs/xfs_inode_buf.c      |  7 ++++---
 fs/xfs/xfs_inode_fork.c     |  6 +++---
 fs/xfs/xfs_inode_item.c     |  8 ++++----
 fs/xfs/xfs_ioctl.c          |  7 ++++---
 fs/xfs/xfs_ioctl32.c        |  4 ++--
 fs/xfs/xfs_iomap.c          | 11 ++++++-----
 fs/xfs/xfs_iops.c           | 13 +++++++------
 fs/xfs/xfs_itable.c         |  4 ++--
 fs/xfs/xfs_log.c            |  8 +++++---
 fs/xfs/xfs_log.h            | 18 ++----------------
 fs/xfs/xfs_log_cil.c        | 10 ++++++----
 fs/xfs/xfs_log_priv.h       |  7 ++++---
 fs/xfs/xfs_log_recover.c    | 13 +++++--------
 fs/xfs/xfs_log_rlimit.c     |  4 ++--
 fs/xfs/xfs_message.c        |  5 ++---
 fs/xfs/xfs_mount.c          | 10 ++++++----
 fs/xfs/xfs_qm.c             |  9 +++++----
 fs/xfs/xfs_qm_bhv.c         |  5 +++--
 fs/xfs/xfs_qm_syscalls.c    |  7 ++++---
 fs/xfs/xfs_quotaops.c       |  2 +-
 fs/xfs/xfs_rtalloc.c        |  7 ++++---
 fs/xfs/xfs_sb.c             |  7 ++++---
 fs/xfs/xfs_super.c          |  8 +++++---
 fs/xfs/xfs_symlink.c        |  8 +++++---
 fs/xfs/xfs_symlink_remote.c |  5 +++--
 fs/xfs/xfs_trace.c          |  8 +++++---
 fs/xfs/xfs_trans.c          | 10 ++++++----
 fs/xfs/xfs_trans.h          | 19 ++++++++++++++-----
 fs/xfs/xfs_trans_ail.c      |  7 ++++---
 fs/xfs/xfs_trans_buf.c      |  5 +++--
 fs/xfs/xfs_trans_dquot.c    |  7 ++++---
 fs/xfs/xfs_trans_extfree.c  |  5 +++--
 fs/xfs/xfs_trans_inode.c    |  5 +++--
 fs/xfs/xfs_trans_priv.h     |  1 -
 fs/xfs/xfs_trans_resv.c     |  6 +++---
 fs/xfs/xfs_xattr.c          |  3 +--
 75 files changed, 284 insertions(+), 247 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 2bfca06..999db7a 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -18,10 +18,10 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -36,7 +36,9 @@
 #include "xfs_error.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index cafc902..0bd33bf 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -17,9 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -34,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_trans.h"
 
 
 STATIC struct xfs_btree_cur *
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b5db88a..e94be74 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -16,16 +16,17 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index dd0f48f..ce6f9e0 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -17,12 +17,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -33,6 +32,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 60b60c0..45480f5 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -18,11 +18,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -36,6 +36,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
@@ -43,7 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
-#include "xfs_trans_priv.h"
 
 /*
  * Look at all the extents for this logical region,
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 94838fe..c10c70c 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -18,11 +18,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -37,6 +35,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 8ba8e4b..a319eb4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -18,10 +18,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -36,6 +35,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 578f21b..1407191 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -18,11 +18,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -33,6 +31,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_bit.c b/fs/xfs/xfs_bit.c
index 4822884..16ce44a 100644
--- a/fs/xfs/xfs_bit.c
+++ b/fs/xfs/xfs_bit.c
@@ -16,10 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_buf_item.h"
+#include "xfs_log_format.h"
 
 /*
  * XFS bit manipulation routines, used in non-realtime code.
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index c7eed87..91c2a2a 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -17,12 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -37,6 +37,7 @@
 #include "xfs_btree.h"
 #include "xfs_mount.h"
 #include "xfs_itable.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index bb8de8e..89ef4e6 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -18,9 +18,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -29,6 +29,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ecec201..c1ad76d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -18,12 +18,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -34,6 +33,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_trans.h"
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
@@ -44,6 +44,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /* Kernel only BMAP related definitions and functions */
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 1a297e2..0836511 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -18,9 +18,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -29,6 +29,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 956685f..5a8e986 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -34,12 +34,12 @@
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
 
-#include "xfs_sb.h"
 #include "xfs_trans_resv.h"
-#include "xfs_log.h"
+#include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f1d85cf..b6d20c5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -17,17 +17,18 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 4ec68c3..3770111 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -18,11 +18,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -33,6 +33,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index f46777f..cef1661 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -17,10 +17,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -30,6 +29,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 5f17273..6c7cd3c 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -18,9 +18,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -29,6 +28,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 8cf8034..3f7eddd 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -18,9 +18,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -32,6 +31,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index d5937da..44fe4b8 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -18,10 +18,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -35,6 +34,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 6d12a9a..8854cb44 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -18,9 +18,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -34,6 +33,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 6b1ffb3..048d582 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,10 +18,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -35,6 +34,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include "xfs_trans.h"
 
 /*
  * Directory file type support functions
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 8d92596..ac3bb58 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -17,9 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -28,6 +27,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_error.h"
 #include "xfs_dir2.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 45560ee..d38f34c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -17,8 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -33,6 +33,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_discard.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 STATIC int
 xfs_trim_extents(
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f85a893..47a815d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -18,29 +18,31 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_alloc.h"
+#include "xfs_quota.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 /*
  * Lock order:
diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
index ad2c18f..3e84b3a 100644
--- a/fs/xfs/xfs_dquot_buf.c
+++ b/fs/xfs/xfs_dquot_buf.c
@@ -19,15 +19,16 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_quota.h"
+#include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_error.h"
 #include "xfs_cksum.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index e838d84..f8a47f7 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -18,8 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -32,9 +32,11 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
+#include "xfs_log.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 1123d93f..7e24dc41 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -17,9 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 96be1d6..8502aee 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -16,9 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -27,9 +26,11 @@
 #include "xfs_export.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 74828a7..de46264 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -20,9 +20,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -31,6 +31,8 @@
 #include "xfs_inode.h"
 #include "xfs_extent_busy.h"
 #include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_log.h"
 
 void
 xfs_extent_busy_insert(
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index dc53e8f..3680d04 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -17,14 +17,14 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_buf_item.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
 
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f3ee034..bbf387d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_log.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
@@ -28,6 +28,7 @@
 #include "xfs_alloc.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
@@ -36,6 +37,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 #include <linux/aio.h>
 #include <linux/dcache.h>
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index ce78e65..7f2c3c1 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -16,15 +16,15 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_log.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_ag.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inum.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_ag.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_mount.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d9cfe55..da0291a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -17,11 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -30,6 +29,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_error.h"
@@ -41,6 +41,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 /*
  * File system operations
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 8530cab..c973ff8 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -17,12 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -38,6 +38,7 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_cksum.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 5448eb6..2a0b615 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -17,10 +17,9 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -35,6 +34,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_trans.h"
 
 
 STATIC int
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 474807a..4fcf658 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -18,12 +18,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_log_priv.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -32,6 +29,8 @@
 #include "xfs_dinode.h"
 #include "xfs_error.h"
 #include "xfs_filestream.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index df8baf3..d2eaccf 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -18,12 +18,13 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 #include "xfs_icreate_item.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9d98b6b..60928fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -19,13 +19,11 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_space.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -39,6 +37,8 @@
 #include "xfs_attr.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans_space.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
@@ -53,6 +53,8 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
 
 kmem_zone_t *xfs_inode_zone;
 
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 65fa56e..c0f974b 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -32,6 +32,7 @@
 #include "xfs_cksum.h"
 #include "xfs_icache.h"
 #include "xfs_ialloc.h"
+#include "xfs_trans.h"
 
 /*
  * Check that none of the inode's in the buffer have a next
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 02f1083..8af3821 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -20,10 +20,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_log.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -33,6 +32,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3780811..9f8e85e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -17,19 +17,19 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_trans_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_trans_priv.h"
 
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bde3847..8484f40 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -35,6 +35,7 @@
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_fsops.h"
 #include "xfs_discard.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index f671f7e..1be3333 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -22,8 +22,8 @@
 #include <asm/uaccess.h>
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 41ef15e..a5c549c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -17,21 +17,22 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
+#include "xfs_alloc.h"
+#include "xfs_quota.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5f39e63..44fdfe8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -17,15 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_acl.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_bmap_btree.h"
@@ -33,10 +30,14 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_acl.h"
+#include "xfs_alloc.h"
+#include "xfs_quota.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4f50e63..964b1ca 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -18,9 +18,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7506e6d..e7f5c9a8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -18,19 +18,21 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_log_recover.h"
-#include "xfs_trans_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1c45848..ee883a8 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -33,16 +33,6 @@ struct xfs_log_vec {
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
- * Structure used to pass callback function and the function's argument
- * to the log manager.
- */
-typedef struct xfs_log_callback {
-	struct xfs_log_callback	*cb_next;
-	void			(*cb_func)(void *, int);
-	void			*cb_arg;
-} xfs_log_callback_t;
-
-/*
  * By comparing each component, we don't have to worry about extra
  * endian issues in treating two 32 bit numbers as one 64 bit number
  */
@@ -82,11 +72,7 @@ struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
-
-void	xfs_log_item_init(struct xfs_mount	*mp,
-			struct xfs_log_item	*item,
-			int			type,
-			const struct xfs_item_ops *ops);
+struct xfs_log_callback;
 
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_ticket *ticket,
@@ -114,7 +100,7 @@ xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
-			 xfs_log_callback_t	*callback_entry);
+			 struct xfs_log_callback *callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
 			 struct xlog_in_core	 *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 3a9c70a..8c263f7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -17,11 +17,9 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_log_priv.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -29,6 +27,10 @@
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_discard.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 /*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard to
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 136654b..ffc6cfe 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -22,6 +22,7 @@ struct xfs_buf;
 struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
+struct xfs_log_callback;
 
 /*
  * Flags for log structure
@@ -227,8 +228,8 @@ typedef struct xlog_in_core {
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
-	xfs_log_callback_t	*ic_callback;
-	xfs_log_callback_t	**ic_callback_tail;
+	struct xfs_log_callback	*ic_callback;
+	struct xfs_log_callback	**ic_callback_tail;
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
@@ -254,7 +255,7 @@ struct xfs_cil_ctx {
 	int			space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
-	xfs_log_callback_t	log_cb;		/* completion callback hook. */
+	struct xfs_log_callback	log_cb;		/* completion callback hook. */
 	struct list_head	committing;	/* ctx committing list */
 };
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e4260fa..77a3a39 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -17,12 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -34,11 +34,12 @@
 #include "xfs_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
-#include "xfs_buf_item.h"
 #include "xfs_log_recover.h"
 #include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
@@ -46,14 +47,10 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
-#include "xfs_icreate_item.h"
 
 /* Need all the magic numbers and buffer ops structures from these headers */
-#include "xfs_symlink.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
-#include "xfs_attr_leaf.h"
-#include "xfs_attr_remote.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index e598bb5..3749bc1 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -18,8 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9163dc1..63ca2f0 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -17,9 +17,8 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 170e729..83f7810 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -17,17 +17,19 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
 #include "xfs_dir2.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6dfb4e3..e2f6756 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -18,14 +18,12 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_alloc.h"
-#include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_ialloc_btree.h"
@@ -33,10 +31,13 @@
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
+#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
+#include "xfs_quota.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_qm.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 3af50cc..7046289 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -18,8 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -32,6 +32,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_qm.h"
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index dcf345a..ed79a72 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -20,11 +20,11 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -32,6 +32,7 @@
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 1326d81..2dd467b 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -17,8 +17,8 @@
  */
 #include "xfs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_log.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6f63de3..23c5ca2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -17,11 +17,11 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -34,6 +34,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_fsops.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index ed2b3c6..8c4307d 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -18,11 +18,10 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -44,6 +43,8 @@
 #include "xfs_fsops.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b49a891..5f93d21 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -17,11 +17,11 @@
  */
 
 #include "xfs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_inum.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -41,7 +41,9 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 73a06f9..1859049 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -17,12 +17,12 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
-#include "xfs_shared.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -41,7 +41,9 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 
 /* ----- Kernel only functions below ----- */
 STATIC int
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index 4251cd8..bf59a2b 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -19,9 +19,9 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_trans_resv.h"
 #include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
 #include "xfs_cksum.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 6ca9920..889bb42 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -38,6 +38,8 @@
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_trans.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 06000a9..8d1595f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -18,10 +18,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -38,10 +38,12 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_quota.h"
-#include "xfs_qm.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
+#include "xfs_qm.h"
 #include "xfs_inode_item.h"
+#include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 09cf40b..f75f9ee 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -18,10 +18,6 @@
 #ifndef	__XFS_TRANS_H__
 #define	__XFS_TRANS_H__
 
-struct xfs_log_item;
-
-#include "xfs_trans_resv.h"
-
 /* kernel only transaction subsystem defines */
 
 struct xfs_buf;
@@ -85,6 +81,9 @@ struct xfs_item_ops {
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
 
+void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
+			  int type, const struct xfs_item_ops *ops);
+
 /*
  * This is the type of function which can be given to xfs_trans_callback()
  * to be called upon the transaction's commit to disk.
@@ -92,6 +91,16 @@ struct xfs_item_ops {
 typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
 
 /*
+ * Structure used to pass callback function and the function's argument
+ * to the log manager.
+ */
+typedef struct xfs_log_callback {
+	struct xfs_log_callback	*cb_next;
+	void			(*cb_func)(void *, int);
+	void			*cb_arg;
+} xfs_log_callback_t;
+
+/*
  * This is the structure maintained for every active transaction.
  */
 typedef struct xfs_trans {
@@ -132,7 +141,6 @@ typedef struct xfs_trans {
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
 	struct list_head	t_items;	/* log item descriptors */
-	xfs_trans_header_t	t_header;	/* header for in-log trans */
 	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
@@ -237,6 +245,7 @@ void		xfs_trans_log_efd_extent(xfs_trans_t *,
 					 xfs_fsblock_t,
 					 xfs_extlen_t);
 int		xfs_trans_commit(xfs_trans_t *, uint flags);
+int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 21c6d7d..4b47cfe 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -18,15 +18,16 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_log.h"
 
 #ifdef DEBUG
 /*
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 0167a65..6b1b993 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -18,8 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -28,6 +28,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4d630d2..2025f6e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -17,10 +17,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_alloc.h"
@@ -33,6 +33,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
+#include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 3bfb98b..47978ba 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -18,11 +18,12 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
 
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 9ffa83f..8580127 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -18,8 +18,8 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -29,6 +29,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index c52def0..12e86af 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -27,7 +27,6 @@ struct xfs_log_vec;
 
 
 void	xfs_trans_init(struct xfs_mount *);
-int	xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index cc83612..89de046 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -18,11 +18,10 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_format.h"
 #include "xfs_shared.h"
-#include "xfs_log.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -41,6 +40,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_quota.h"
+#include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0804750..2305299 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -18,8 +18,7 @@
 
 #include "xfs.h"
 #include "xfs_log_format.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
+#include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
