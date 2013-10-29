Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C64F7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 898B4304048
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:10 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	owHORgxDT7Wviriu for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DN-0000Pr-75
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DN-00088B-5Q
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/15] xfs: fix static and extern sparse warnings
Date: Tue, 29 Oct 2013 22:11:58 +1100
Message-Id: <1383045118-31107-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

The kbuild test robot indicated that there were some new sparse
warnings in fs/xfs/xfs_dquot_buf.c. Actually, there were a lot more
that is wasn't warning about, so fix them all up.

Reported-by: kbuild test robot
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c  |  1 +
 fs/xfs/xfs_attr_leaf.c    |  1 +
 fs/xfs/xfs_attr_remote.c  |  1 +
 fs/xfs/xfs_bit.c          |  1 +
 fs/xfs/xfs_bmap_btree.c   |  1 +
 fs/xfs/xfs_buf_item.c     |  2 +-
 fs/xfs/xfs_da_format.c    | 11 ++++++-----
 fs/xfs/xfs_dquot_buf.c    |  3 ++-
 fs/xfs/xfs_ialloc_btree.c |  1 +
 fs/xfs/xfs_rtbitmap.c     |  1 +
 fs/xfs/xfs_sb.c           |  1 +
 fs/xfs/xfs_super.c        |  2 +-
 12 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 698587f..1308542 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index fdf9992..7b126f4 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 2e55304..739e0a5 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_bit.c b/fs/xfs/xfs_bit.c
index 16ce44a..0e8885a 100644
--- a/fs/xfs/xfs_bit.c
+++ b/fs/xfs/xfs_bit.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_log_format.h"
+#include "xfs_bit.h"
 
 /*
  * XFS bit manipulation routines, used in non-realtime code.
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 2fb4a22..706bc3f 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b6d20c5..a64f67b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -809,7 +809,7 @@ xfs_buf_item_init(
  * Mark bytes first through last inclusive as dirty in the buf
  * item's bitmap.
  */
-void
+static void
 xfs_buf_item_log_segment(
 	struct xfs_buf_log_item	*bip,
 	uint			first,
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 5a5767c..d224441 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -706,7 +707,7 @@ xfs_dir3_free_hdr_to_disk(
 	hdr3->nused = cpu_to_be32(from->nused);
 }
 
-const struct xfs_dir_ops xfs_dir2_ops = {
+static const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
 	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
@@ -756,7 +757,7 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
-const struct xfs_dir_ops xfs_dir2_ftype_ops = {
+static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.sf_entsize = xfs_dir3_sf_entsize,
 	.sf_nextentry = xfs_dir3_sf_nextentry,
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
@@ -806,7 +807,7 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
-const struct xfs_dir_ops xfs_dir3_ops = {
+static const struct xfs_dir_ops xfs_dir3_ops = {
 	.sf_entsize = xfs_dir3_sf_entsize,
 	.sf_nextentry = xfs_dir3_sf_nextentry,
 	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
@@ -856,14 +857,14 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
 
-const struct xfs_dir_ops xfs_dir2_nondir_ops = {
+static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 };
 
-const struct xfs_dir_ops xfs_dir3_nondir_ops = {
+static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
 	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
 	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
index aaaf41b..d401457 100644
--- a/fs/xfs/xfs_dquot_buf.c
+++ b/fs/xfs/xfs_dquot_buf.c
@@ -18,6 +18,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -267,7 +268,7 @@ xfs_dquot_buf_read_verify(
  * the buffer after the update is done. This ensures that the dquot in the
  * buffer always has an up-to-date CRC value.
  */
-void
+static void
 xfs_dquot_buf_write_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 1fa142d..c8fa5bb 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_rtbitmap.c b/fs/xfs/xfs_rtbitmap.c
index e30efe8..b1f2fe8 100644
--- a/fs/xfs/xfs_rtbitmap.c
+++ b/fs/xfs/xfs_rtbitmap.c
@@ -37,6 +37,7 @@
 #include "xfs_buf.h"
 #include "xfs_icache.h"
 #include "xfs_dinode.h"
+#include "xfs_rtalloc.h"
 
 
 /*
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 05b5493..13c7834 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -17,6 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5ee4ceb..f317488 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1155,7 +1155,7 @@ xfs_restore_resvblks(struct xfs_mount *mp)
  * Note: xfs_log_quiesce() stops background log work - the callers must ensure
  * it is started again when appropriate.
  */
-void
+static void
 xfs_quiesce_attr(
 	struct xfs_mount	*mp)
 {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
