Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6XDUa102672 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:33:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	knJvaPMDd6g0zd23 for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1q-0000B4-MC
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1g-00055T-IS
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/25] xfs: add write verifiers to log recovery
Date: Thu, 25 Oct 2012 17:34:14 +1100
Message-Id: <1351146854-19343-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1351146854-19343-1-git-send-email-david@fromorbit.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
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

Log recovery reads metadata, modifies it and rewrites it to disk.
It is only practical to add write verifiers to metadata buffers
because we do not know the type of the buffer prior to reading it
from disk. Further, if it is an new bufer, the contents might not
contain anything we can verify. Hence we only attempt to verify
after the buffer changes have been replayed and we can peek at the
buffer to find out what it contains to attached the correct
verifier.  This ensures that we don't introduce gross corruptions as
a result of replaying transactions in the log.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c       |    2 +-
 fs/xfs/xfs_alloc.h       |    1 +
 fs/xfs/xfs_alloc_btree.c |   15 ++++---
 fs/xfs/xfs_da_btree.h    |    1 +
 fs/xfs/xfs_dir2_leaf.c   |    2 +-
 fs/xfs/xfs_dir2_node.c   |    2 +-
 fs/xfs/xfs_dir2_priv.h   |    3 ++
 fs/xfs/xfs_dquot.c       |   17 +++++++-
 fs/xfs/xfs_dquot.h       |    2 +
 fs/xfs/xfs_log_recover.c |  104 +++++++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 138 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index f9231b2..9e30796 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -479,7 +479,7 @@ xfs_agfl_read_verify(
 	xfs_agfl_verify(bp);
 }
 
-static const struct xfs_buf_ops xfs_agfl_buf_ops = {
+const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 };
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index aaf7ff1..99d0a61 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -232,5 +232,6 @@ xfs_alloc_get_rec(
 	int			*stat);	/* output: success/failure */
 
 extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index b14ff21..5e12e7b 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -33,6 +33,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_log_priv.h"
 
 
 STATIC struct xfs_btree_cur *
@@ -279,17 +280,22 @@ xfs_allocbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
-	unsigned int		level;
+	unsigned int		level = 0;
 	int			sblock_ok; /* block passes checks */
 
-	/* magic number and level verification */
+	/*
+	 * magic number and level verification. For recovery, the pag has not
+	 * been initialised fully yet, so the pagf_level checks cannot be done.
+	 */
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_MAGIC):
-		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_BNOi];
+		sblock_ok = (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY) ||
+			    level < pag->pagf_levels[XFS_BTNUM_BNOi];
 		break;
 	case cpu_to_be32(XFS_ABTC_MAGIC):
-		sblock_ok = level < pag->pagf_levels[XFS_BTNUM_CNTi];
+		sblock_ok = (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY) ||
+			    level < pag->pagf_levels[XFS_BTNUM_CNTi];
 		break;
 	default:
 		sblock_ok = 0;
@@ -335,7 +341,6 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 	.verify_write = xfs_allocbt_write_verify,
 };
 
-
 #ifdef DEBUG
 STATIC int
 xfs_allocbt_keys_inorder(
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index ee5170c..eae66b0 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -246,5 +246,6 @@ void xfs_da_state_free(xfs_da_state_t *state);
 
 extern struct kmem_zone *xfs_da_state_zone;
 extern const struct xfs_nameops xfs_default_nameops;
+extern const struct xfs_buf_ops xfs_da_node_buf_ops;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 60cd2fa..88a27a1 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -92,7 +92,7 @@ xfs_dir2_leafn_write_verify(
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 }
 
-static const struct xfs_buf_ops xfs_dir2_leaf1_buf_ops = {
+const struct xfs_buf_ops xfs_dir2_leaf1_buf_ops = {
 	.verify_read = xfs_dir2_leaf1_read_verify,
 	.verify_write = xfs_dir2_leaf1_write_verify,
 };
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 5980f9b..90d71d2 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -85,7 +85,7 @@ xfs_dir2_free_write_verify(
 	xfs_dir2_free_verify(bp);
 }
 
-static const struct xfs_buf_ops xfs_dir2_free_buf_ops = {
+const struct xfs_buf_ops xfs_dir2_free_buf_ops = {
 	.verify_read = xfs_dir2_free_read_verify,
 	.verify_write = xfs_dir2_free_write_verify,
 };
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index b9a033b..40ff241 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -77,6 +77,7 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
+extern const struct xfs_buf_ops xfs_dir2_leaf1_buf_ops;
 extern const struct xfs_buf_ops xfs_dir2_leafn_buf_ops;
 
 extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
@@ -110,6 +111,8 @@ xfs_dir2_leaf_find_entry(struct xfs_dir2_leaf *leaf, int index, int compact,
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
 /* xfs_dir2_node.c */
+extern const struct xfs_buf_ops xfs_dir2_free_buf_ops;
+
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_buf *bp, int *count);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 14d4088..0b690a2 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -37,6 +37,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_log_priv.h"
 
 /*
  * Lock order:
@@ -257,16 +258,28 @@ xfs_dquot_buf_verify(
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
 	struct xfs_disk_dquot	*ddq;
 	xfs_dqid_t		id = 0;
+	int			dquots_per_buf;
 	int			i;
 
 	/*
+	 * during log recovery, we don't have a quotainfo structure to
+	 * pull the number of dquots per buffer out of, so we have to calculate
+	 * it directly.
+	 */
+	if (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY) {
+		dquots_per_buf = BBTOB(bp->b_length);
+		do_div(dquots_per_buf, sizeof(xfs_dqblk_t));
+	} else
+		dquots_per_buf = mp->m_quotainfo->qi_dqperchunk;
+
+	/*
 	 * On the first read of the buffer, verify that each dquot is valid.
 	 * We don't know what the id of the dquot is supposed to be, just that
 	 * they should be increasing monotonically within the buffer. If the
 	 * first id is corrupt, then it will fail on the second dquot in the
 	 * buffer so corruptions could point to the wrong dquot in this case.
 	 */
-	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
+	for (i = 0; i < dquots_per_buf; i++) {
 		int	error;
 
 		ddq = &d[i].dd_diskdq;
@@ -298,7 +311,7 @@ xfs_dquot_buf_write_verify(
 	xfs_dquot_buf_verify(bp);
 }
 
-static const struct xfs_buf_ops xfs_dquot_buf_ops = {
+const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 7d20af2..c694a84 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -161,4 +161,6 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d63d0ca..e445550 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -43,6 +43,12 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 STATIC int
 xlog_find_zeroed(
@@ -1786,6 +1792,8 @@ xlog_recover_do_inode_buffer(
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
 
+	bp->b_ops = &xfs_inode_buf_ops;
+
 	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
@@ -1856,6 +1864,97 @@ xlog_recover_do_inode_buffer(
 	return 0;
 }
 
+
+/*
+ * If we don't know what the type of buffer is, work it out now
+ * and attached the appropriate write verifier. This is needed to ensure
+ * recovery hasn't corrupted the contents of the buffer, and to
+ * calculate CRC so that the buffer is correct on disk after recovery.
+ *
+ * There is no easy way to do this except for trying a bunch of magic
+ * number matches....
+ */
+static void
+xlog_buf_attach_ops(
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_blkinfo	*dablk;
+	struct xfs_mount	*mp;
+	xfs_agnumber_t		agno;
+	__be32			*magic32;
+
+	/*
+	 * dquot buffers are already marked here, and inode buffers never get to
+	 * this function, so we can ignore them too.
+	 */
+	if (bp->b_ops)
+		return;
+
+	/* try all the buffers that have a magic number in the first 32 bits */
+	magic32 = bp->b_addr;
+	switch (be32_to_cpu(*magic32)) {
+	case XFS_SB_MAGIC:
+		bp->b_ops = &xfs_sb_buf_ops;
+		return;
+	case XFS_AGF_MAGIC:
+		bp->b_ops = &xfs_agf_buf_ops;
+		return;
+	case XFS_AGI_MAGIC:
+		bp->b_ops = &xfs_agi_buf_ops;
+		return;
+	case XFS_ABTB_MAGIC:
+	case XFS_ABTC_MAGIC:
+		bp->b_ops = &xfs_allocbt_buf_ops;
+		return;
+	case XFS_BMAP_MAGIC:
+		bp->b_ops = &xfs_bmbt_buf_ops;
+		return;
+	case XFS_IBT_MAGIC:
+		bp->b_ops = &xfs_inobt_buf_ops;
+		return;
+	case XFS_DIR2_BLOCK_MAGIC:
+		bp->b_ops = &xfs_dir2_block_buf_ops;
+		return;
+	case XFS_DIR2_DATA_MAGIC:
+		bp->b_ops = &xfs_dir2_data_buf_ops;
+		return;
+	case XFS_DIR2_FREE_MAGIC:
+		bp->b_ops = &xfs_dir2_free_buf_ops;
+		return;
+	default:
+		break;
+	}
+
+	/* Now check for dablk types with 16 bit magic numbers */
+	dablk = bp->b_addr;
+	switch (be16_to_cpu(dablk->magic)) {
+	case XFS_DA_NODE_MAGIC:
+		bp->b_ops = &xfs_da_node_buf_ops;
+		return;
+	case XFS_ATTR_LEAF_MAGIC:
+		bp->b_ops = &xfs_attr_leaf_buf_ops;
+		return;
+	case XFS_DIR2_LEAF1_MAGIC:
+		bp->b_ops = &xfs_dir2_leaf1_buf_ops;
+		return;
+	case XFS_DIR2_LEAFN_MAGIC:
+		bp->b_ops = &xfs_dir2_leafn_buf_ops;
+		return;
+	default:
+		break;
+	}
+
+	/*
+	 * AGFL has no magic number. Detect by finding the AG daddr of the
+	 * buffer and matching it to the XFS_AGFL_DADDR.
+	 */
+	mp = bp->b_target->bt_mount;
+	agno = xfs_daddr_to_agno(mp, bp->b_bn);
+	if (bp->b_bn == XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)))
+		bp->b_ops = &xfs_agfl_buf_ops;
+
+}
+
 /*
  * Perform a 'normal' buffer recovery.  Each logged region of the
  * buffer should be copied over the corresponding region in the
@@ -1928,6 +2027,8 @@ xlog_recover_do_reg_buffer(
 
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
+
+	xlog_buf_attach_ops(bp);
 }
 
 /*
@@ -2089,6 +2190,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return;
 
+	bp->b_ops = &xfs_dquot_buf_ops;
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 }
 
@@ -2238,7 +2340,7 @@ xlog_recover_inode_pass2(
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0,
-			  NULL);
+			  &xfs_inode_buf_ops);
 	if (!bp) {
 		error = ENOMEM;
 		goto error;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
