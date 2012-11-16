Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG7Nm4c070731 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 01:23:48 -0600
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id gWRjj9q7pQjRxfvE for
	<xfs@oss.sgi.com>; Thu, 15 Nov 2012 23:25:53 -0800 (PST)
Date: Fri, 16 Nov 2012 15:25:36 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [xfs:for-next 70/70] fs/xfs/xfs_da_btree.c:153:26: sparse: symbol
	'xfs_da_node_buf_ops' was not declared. Should it be static?
Message-ID: <50a5ea70.Lft3JDA+/WxpLnoh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_50a5ea70.XwlPtqR5v3w4o20M3hvxNd68efGBq8YepGX+cuanK1bBbb8A"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.

--=_50a5ea70.XwlPtqR5v3w4o20M3hvxNd68efGBq8YepGX+cuanK1bBbb8A
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://oss.sgi.com/xfs/xfs for-next
head:   1813dd64057490e7a0678a885c4fe6d02f78bdc1
commit: 1813dd64057490e7a0678a885c4fe6d02f78bdc1 [70/70] xfs: convert buffer verifiers to an ops structure.


sparse warnings:

+ fs/xfs/xfs_da_btree.c:153:26: sparse: symbol 'xfs_da_node_buf_ops' was not declared. Should it be static?
--
+ fs/xfs/xfs_dir2_leaf.c:82:1: sparse: symbol 'xfs_dir2_leafn_read_verify' was not declared. Should it be static?
+ fs/xfs/xfs_dir2_leaf.c:89:1: sparse: symbol 'xfs_dir2_leafn_write_verify' was not declared. Should it be static?
--
fs/xfs/xfs_dquot.c:55:15: sparse: symbol 'xfs_dqerror_target' was not declared. Should it be static?
fs/xfs/xfs_dquot.c:56:5: sparse: symbol 'xfs_do_dqerror' was not declared. Should it be static?
fs/xfs/xfs_dquot.c:57:5: sparse: symbol 'xfs_dqreq_num' was not declared. Should it be static?
fs/xfs/xfs_dquot.c:58:5: sparse: symbol 'xfs_dqerror_mod' was not declared. Should it be static?
+ fs/xfs/xfs_dquot.c:294:1: sparse: symbol 'xfs_dquot_buf_write_verify' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50a5ea70.XwlPtqR5v3w4o20M3hvxNd68efGBq8YepGX+cuanK1bBbb8A
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-1813dd6.diff"

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 0e92d12..3216738 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4180,7 +4180,7 @@ error0:
 /*
  * Add bmap trace insert entries for all the contents of the extent records.
  */
-void
+static void
 xfs_bmap_trace_exlist(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	cnt,		/* count of entries in the list */
@@ -4767,7 +4767,7 @@ xfs_bmapi_allocate_worker(
  * them off to a worker thread so there is lots of stack to use. Otherwise just
  * call directly to avoid the context switch overhead here.
  */
-int
+static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*args)
 {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 26673a0..7dcff98 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1503,7 +1503,7 @@ restart:
 	spin_unlock(&btp->bt_lru_lock);
 }
 
-int
+static int
 xfs_buftarg_shrink(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 4d7696a..adf1482 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -150,7 +150,7 @@ xfs_da_node_read_verify(
 	}
 }
 
-const struct xfs_buf_ops xfs_da_node_buf_ops = {
+static const struct xfs_buf_ops xfs_da_node_buf_ops = {
 	.verify_read = xfs_da_node_read_verify,
 	.verify_write = xfs_da_node_write_verify,
 };
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 60cd2fa..6789e06 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -78,14 +78,14 @@ xfs_dir2_leaf1_write_verify(
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 }
 
-void
+static void
 xfs_dir2_leafn_read_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 }
 
-void
+static void
 xfs_dir2_leafn_write_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 5980f9b..025f91f 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -330,7 +330,7 @@ xfs_dir2_leafn_add(
 /*
  * Check internal consistency of a leafn block.
  */
-void
+static void
 xfs_dir2_leafn_check(
 	struct xfs_inode *dp,
 	struct xfs_buf	*bp)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9e1bf52..e4ab229 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -52,10 +52,10 @@
  */
 
 #ifdef DEBUG
-xfs_buftarg_t *xfs_dqerror_target;
-int xfs_do_dqerror;
-int xfs_dqreq_num;
-int xfs_dqerror_mod = 33;
+static xfs_buftarg_t *xfs_dqerror_target;
+static int xfs_do_dqerror;
+static int xfs_dqreq_num;
+static int xfs_dqerror_mod = 33;
 #endif
 
 struct kmem_zone		*xfs_qm_dqtrxzone;
@@ -290,7 +290,7 @@ xfs_dquot_buf_read_verify(
 	xfs_dquot_buf_verify(bp);
 }
 
-void
+static void
 xfs_dquot_buf_write_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index bec344b..cf52893 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -182,7 +182,7 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
-void
+static void
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
 {
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 4fc17d4..7fc6c42 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -233,10 +233,10 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 }
 
 #ifdef DEBUG
-xfs_buftarg_t *xfs_error_target;
-int	xfs_do_error;
-int	xfs_req_num;
-int	xfs_error_mod = 33;
+static xfs_buftarg_t *xfs_error_target;
+static int	xfs_do_error;
+static int	xfs_req_num;
+static int	xfs_error_mod = 33;
 #endif
 
 /*

--=_50a5ea70.XwlPtqR5v3w4o20M3hvxNd68efGBq8YepGX+cuanK1bBbb8A
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=_50a5ea70.XwlPtqR5v3w4o20M3hvxNd68efGBq8YepGX+cuanK1bBbb8A--
