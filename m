Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B62637F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:06:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B53A304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:06:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	k61xnhKKLSoJEaCD for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:06:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007cs-J6
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003rb-IT
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/55] libxfs: fix byte swapping on constants
Date: Thu,  5 Sep 2013 08:05:10 +1000
Message-Id: <1378332359-14737-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

The kernel code uses cpu_to_beXX() on constants in switch()
statements for magic numbers in the btree code. Th ebyte swapping
infratructure isn't hooked up to the proper byte swap macros to make
this work, so fix it and then swap all the generic btree code over
to match the kernel code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/swab.h            |  6 +++---
 libxfs/xfs_alloc_btree.c  | 23 ++++++++++++++---------
 libxfs/xfs_bmap_btree.c   | 14 ++++++--------
 libxfs/xfs_ialloc_btree.c | 16 +++++++++++-----
 4 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/include/swab.h b/include/swab.h
index 3de44d8..b06346c 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -96,15 +96,15 @@
  */
 #  define __swab16(x) \
 (__builtin_constant_p((__u16)(x)) ? \
- ___swab16((x)) : \
+ ___constant_swab16((x)) : \
  __fswab16((x)))
 #  define __swab32(x) \
 (__builtin_constant_p((__u32)(x)) ? \
- ___swab32((x)) : \
+ ___constant_swab32((x)) : \
  __fswab32((x)))
 #  define __swab64(x) \
 (__builtin_constant_p((__u64)(x)) ? \
- ___swab64((x)) : \
+ ___constant_swab64((x)) : \
  __fswab64((x)))
 
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 1ee1f48..282a320 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -268,10 +268,15 @@ xfs_allocbt_verify(
 	 * During growfs operations, we can't verify the exact level or owner as
 	 * the perag is not fully initialised and hence not attached to the
 	 * buffer.  In this case, check against the maximum tree depth.
+	 *
+	 * Similarly, during log recovery we will have a perag structure
+	 * attached, but the agf information will not yet have been initialised
+	 * from the on disk AGF. Again, we can only check against maximum limits
+	 * in this case.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	switch (cpu_to_be32(block->bb_magic)) {
-	case XFS_ABTB_CRC_MAGIC:
+	switch (block->bb_magic) {
+	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
@@ -282,14 +287,14 @@ xfs_allocbt_verify(
 		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
 			return false;
 		/* fall through */
-	case XFS_ABTB_MAGIC:
-		if (pag) {
+	case cpu_to_be32(XFS_ABTB_MAGIC):
+		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_BNOi])
 				return false;
 		} else if (level >= mp->m_ag_maxlevels)
 			return false;
 		break;
-	case XFS_ABTC_CRC_MAGIC:
+	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
@@ -300,8 +305,8 @@ xfs_allocbt_verify(
 		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
 			return false;
 		/* fall through */
-	case XFS_ABTC_MAGIC:
-		if (pag) {
+	case cpu_to_be32(XFS_ABTC_MAGIC):
+		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_CNTi])
 				return false;
 		} else if (level >= mp->m_ag_maxlevels)
@@ -361,7 +366,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_allocbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -483,7 +488,7 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
 #endif
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 473db4a..bf214cf 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -708,13 +708,13 @@ xfs_bmbt_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	unsigned int		level;
 
-	switch (be32_to_cpu(block->bb_magic)) {
-	case XFS_BMAP_CRC_MAGIC:
+	switch (block->bb_magic) {
+	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid))
 			return false;
-		if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
+		if (be64_to_cpu(block->bb_u.l.bb_blkno) != bp->b_bn)
 			return false;
 		/*
 		 * XXX: need a better way of verifying the owner here. Right now
@@ -723,7 +723,7 @@ xfs_bmbt_verify(
 		if (be64_to_cpu(block->bb_u.l.bb_owner) == 0)
 			return false;
 		/* fall through */
-	case XFS_BMAP_MAGIC:
+	case cpu_to_be32(XFS_BMAP_MAGIC):
 		break;
 	default:
 		return false;
@@ -759,7 +759,6 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_bmbt_verify(bp);
 	if (!(xfs_btree_lblock_verify_crc(bp) &&
 	      xfs_bmbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -767,7 +766,6 @@ xfs_bmbt_read_verify(
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-
 }
 
 static void
@@ -791,7 +789,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -920,7 +918,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 #endif
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index ee036bf..27a5dd9 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -175,9 +175,15 @@ xfs_inobt_verify(
 	/*
 	 * During growfs operations, we can't verify the exact owner as the
 	 * perag is not fully initialised and hence not attached to the buffer.
+	 *
+	 * Similarly, during log recovery we will have a perag structure
+	 * attached, but the agi information will not yet have been initialised
+	 * from the on disk AGI. We don't currently use any of this information,
+	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
+	 * ever do.
 	 */
-	switch (be32_to_cpu(block->bb_magic)) {
-	case XFS_IBT_CRC_MAGIC:
+	switch (block->bb_magic) {
+	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
@@ -188,7 +194,7 @@ xfs_inobt_verify(
 		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
 			return false;
 		/* fall through */
-	case XFS_IBT_MAGIC:
+	case cpu_to_be32(XFS_IBT_MAGIC):
 		break;
 	default:
 		return 0;
@@ -246,7 +252,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -350,7 +356,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
