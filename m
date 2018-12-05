Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbeLEVI5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:08:57 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2931C307CDC1
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:08:56 +0000 (UTC)
Subject: [PATCH 07/10] xfs: change all verifiers to return booleans
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <3c547a9e-d95d-c3f2-01d3-220bb5d08390@redhat.com>
Date: Wed, 5 Dec 2018 15:08:52 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Switch verifiers back to returning booleans (true for verified) to
be consistent with the crc checkers.  Failure address information is
now stored in the xfs verifier context vc->fa which is passed to
error handling functions such as xfs_verifier_error() on failure.

The actual switch to boolean return is done in the 
XFS_VERIFIED_RETURN/XFS_CORRUPTED_RETURN macros.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 29 +++++++----------
 fs/xfs/libxfs/xfs_alloc_btree.c    | 27 ++++++----------
 fs/xfs/libxfs/xfs_attr_leaf.c      | 16 ++++------
 fs/xfs/libxfs/xfs_attr_leaf.h      |  2 +-
 fs/xfs/libxfs/xfs_attr_remote.c    | 15 ++++-----
 fs/xfs/libxfs/xfs_bmap.c           |  8 ++---
 fs/xfs/libxfs/xfs_bmap.h           |  4 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     | 22 ++++---------
 fs/xfs/libxfs/xfs_btree.c          | 34 ++++++++++----------
 fs/xfs/libxfs/xfs_btree.h          | 16 +++++-----
 fs/xfs/libxfs/xfs_da_btree.c       | 16 ++++------
 fs/xfs/libxfs/xfs_dir2_block.c     | 14 +++-----
 fs/xfs/libxfs/xfs_dir2_data.c      | 51 +++++++++++-------------------
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 28 +++++++---------
 fs/xfs/libxfs/xfs_dir2_node.c      | 30 +++++++-----------
 fs/xfs/libxfs/xfs_dir2_priv.h      |  6 ++--
 fs/xfs/libxfs/xfs_dir2_sf.c        |  2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      | 18 +++++------
 fs/xfs/libxfs/xfs_ialloc.c         | 15 ++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 22 ++++---------
 fs/xfs/libxfs/xfs_inode_buf.c      | 46 +++++++++++----------------
 fs/xfs/libxfs/xfs_inode_buf.h      |  6 ++--
 fs/xfs/libxfs/xfs_inode_fork.c     | 13 ++++----
 fs/xfs/libxfs/xfs_inode_fork.h     |  6 ++--
 fs/xfs/libxfs/xfs_quota_defs.h     |  4 +--
 fs/xfs/libxfs/xfs_refcount_btree.c | 22 ++++---------
 fs/xfs/libxfs/xfs_rmap_btree.c     | 22 ++++---------
 fs/xfs/libxfs/xfs_shared.h         |  2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c | 16 ++++------
 fs/xfs/libxfs/xfs_types.h          |  4 +--
 fs/xfs/scrub/btree.c               | 23 ++++++++------
 fs/xfs/scrub/common.c              |  6 ++--
 fs/xfs/scrub/dabtree.c             |  2 +-
 fs/xfs/scrub/inode.c               | 12 +++----
 fs/xfs/xfs_buf.h                   |  2 +-
 fs/xfs/xfs_dquot.c                 |  6 ++--
 fs/xfs/xfs_inode.c                 | 11 +++----
 fs/xfs/xfs_log_recover.c           | 16 +++-------
 fs/xfs/xfs_qm.c                    |  4 +--
 39 files changed, 236 insertions(+), 362 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 36073ac260af..b9e3c69490eb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -551,7 +551,7 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
-static xfs_failaddr_t
+static bool
 xfs_agfl_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
@@ -599,7 +599,6 @@ xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
 
 	/*
 	 * There is no verification of non-crc AGFLs because mkfs does not
@@ -613,9 +612,8 @@ xfs_agfl_read_verify(
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_AGFL_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_agfl_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_agfl_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -626,15 +624,13 @@ xfs_agfl_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	fa = xfs_agfl_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_agfl_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -2576,7 +2572,7 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
-static xfs_failaddr_t
+static bool
 xfs_agf_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -2638,15 +2634,14 @@ xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_agf_verify(vc, bp);
-		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
+				   mp, XFS_ERRTAG_ALLOC_READ_AGF))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -2657,11 +2652,9 @@ xfs_agf_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_agf_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_agf_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index e8c4d142c419..87d96e66d4ca 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -288,7 +288,7 @@ xfs_cntbt_diff_two_keys(
 		be32_to_cpu(k2->alloc.ar_startblock);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_allocbt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -296,7 +296,6 @@ xfs_allocbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
-	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -314,9 +313,8 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
-		if (fa)
-			return fa;
+		if (!xfs_btree_sblock_v5hdr_verify(vc, bp))
+			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTB_MAGIC):
 		if (pag && pag->pagf_init) {
@@ -326,9 +324,8 @@ xfs_allocbt_verify(
 			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
-		if (fa)
-			return fa;
+		if (!xfs_btree_sblock_v5hdr_verify(vc, bp))
+			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTC_MAGIC):
 		if (pag && pag->pagf_init) {
@@ -349,14 +346,11 @@ xfs_allocbt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_allocbt_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_allocbt_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 
 	if (bp->b_error)
@@ -368,12 +362,9 @@ xfs_allocbt_write_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
-	fa = xfs_allocbt_verify(vc, bp);
-	if (fa) {
+	if (!xfs_allocbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index cf09952a3939..724b13f61da6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -235,7 +235,7 @@ xfs_attr3_leaf_hdr_to_disk(
 	}
 }
 
-static xfs_failaddr_t
+static bool
 xfs_attr3_leaf_verify(
 	struct xfs_vc			*vc,
 	struct xfs_buf			*bp)
@@ -329,11 +329,9 @@ xfs_attr3_leaf_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_attr3_leaf_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_attr3_leaf_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -358,15 +356,13 @@ xfs_attr3_leaf_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_ATTR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_attr3_leaf_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_attr3_leaf_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -906,7 +902,7 @@ xfs_attr_shortform_allfit(
 }
 
 /* Verify the consistency of an inline attribute fork. */
-xfs_failaddr_t
+bool
 xfs_attr_shortform_verify(
 	struct xfs_vc			*vc,
 	struct xfs_inode		*ip)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index afe09eec66aa..cb8e44976514 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -41,7 +41,7 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
-xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
+bool	xfs_attr_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 2b038458f4ae..9987330424e9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -76,7 +76,7 @@ xfs_attr3_rmt_hdr_ok(
 	return true;
 }
 
-static xfs_failaddr_t
+static bool
 xfs_attr3_rmt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_mount	*mp,
@@ -133,9 +133,10 @@ __xfs_attr3_rmt_read_verify(
 			*failaddr = __this_address;
 			return -EFSBADCRC;
 		}
-		*failaddr = xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno);
-		if (*failaddr)
+		if (!xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno)) {
+			*failaddr = vc->fa;
 			return -EFSCORRUPTED;
+		}
 		len -= blksize;
 		ptr += blksize;
 		bno += BTOBB(blksize);
@@ -162,7 +163,7 @@ xfs_attr3_rmt_read_verify(
 		xfs_verifier_error(bp, error, fa);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_attr3_rmt_verify_struct(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
@@ -180,7 +181,6 @@ xfs_attr3_rmt_write_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
 	int		blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
 	int		len;
@@ -198,9 +198,8 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		fa = xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno);
-		if (fa) {
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno)) {
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 			return;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0340f9e2e0e7..d34e48d7ef8c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1250,15 +1250,13 @@ xfs_iread_extents(
 		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
 		for (j = 0; j < num_recs; j++, frp++, i++) {
 			struct xfs_vc	vc = { 0 };
-			xfs_failaddr_t	fa;
 
 			xfs_bmbt_disk_get_all(frp, &new);
-			fa = xfs_bmap_validate_extent(&vc, ip, whichfork, &new);
-			if (fa) {
+			if (!xfs_bmap_validate_extent(&vc, ip, whichfork, &new)) {
 				error = -EFSCORRUPTED;
 				xfs_inode_verifier_error(ip, error,
 						"xfs_iread_extents(2)",
-						frp, sizeof(*frp), fa);
+						frp, sizeof(*frp), vc.fa);
 				goto out_brelse;
 			}
 			xfs_iext_insert(ip, &icur, &new, state);
@@ -6100,7 +6098,7 @@ xfs_bmap_finish_one(
 }
 
 /* Check that an inode's extent does not have invalid flags or bad ranges. */
-xfs_failaddr_t
+bool
 xfs_bmap_validate_extent(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index a586568cdfb9..bbc318331e77 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -273,8 +273,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
 	}
 }
 
-xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_vc *vc, struct xfs_inode *ip, int whichfork,
-		struct xfs_bmbt_irec *irec);
+bool	xfs_bmap_validate_extent(struct xfs_vc *vc, struct xfs_inode *ip,
+		int whichfork, struct xfs_bmbt_irec *irec);
 
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 27b9056ba87a..fc4ea15ca6c1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -407,14 +407,13 @@ xfs_bmbt_diff_two_keys(
 			  be64_to_cpu(k2->bmbt.br_startoff);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_bmbt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	switch (block->bb_magic) {
@@ -423,9 +422,8 @@ xfs_bmbt_verify(
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
 		 */
-		fa = xfs_btree_lblock_v5hdr_verify(vc, bp, XFS_RMAP_OWN_UNKNOWN);
-		if (fa)
-			return fa;
+		if (!xfs_btree_lblock_v5hdr_verify(vc, bp, XFS_RMAP_OWN_UNKNOWN))
+			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_BMAP_MAGIC):
 		break;
@@ -452,14 +450,11 @@ xfs_bmbt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
 	if (!xfs_btree_lblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_bmbt_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_bmbt_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 
 	if (bp->b_error)
@@ -471,12 +466,9 @@ xfs_bmbt_write_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
-	fa = xfs_bmbt_verify(vc, bp);
-	if (fa) {
+	if (!xfs_bmbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 	xfs_btree_lblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0b88cb04a719..89c53124759c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -53,10 +53,10 @@ xfs_btree_magic(
 }
 
 /*
- * Check a long btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
+ * Check a long btree block header.  Return false for a failing check,
+ * or true if everything is ok.
  */
-xfs_failaddr_t
+bool
 __xfs_btree_check_lblock(
 	struct xfs_vc		*vc,
 	struct xfs_btree_cur	*cur,
@@ -107,11 +107,10 @@ xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = __xfs_btree_check_lblock(&vc, cur, block, level, bp);
-	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
-			XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
+	if (unlikely(XFS_TEST_ERROR(
+			!(__xfs_btree_check_lblock(&vc, cur, block, level, bp)),
+			mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
@@ -121,10 +120,10 @@ xfs_btree_check_lblock(
 }
 
 /*
- * Check a short btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
+ * Check a short btree block header.  Return false for a failing check,
+ * or true if everything is ok.
  */
-xfs_failaddr_t
+bool
 __xfs_btree_check_sblock(
 	struct xfs_vc		*vc,
 	struct xfs_btree_cur	*cur,
@@ -173,11 +172,10 @@ xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = __xfs_btree_check_sblock(&vc, cur, block, level, bp);
-	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
-			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
+	if (unlikely(XFS_TEST_ERROR(
+			!(__xfs_btree_check_sblock(&vc, cur, block, level, bp)),
+			mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
@@ -4434,7 +4432,7 @@ xfs_btree_change_owner(
 }
 
 /* Verify the v5 fields of a long-format btree block. */
-xfs_failaddr_t
+bool
 xfs_btree_lblock_v5hdr_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp,
@@ -4456,7 +4454,7 @@ xfs_btree_lblock_v5hdr_verify(
 }
 
 /* Verify a long-format btree block. */
-xfs_failaddr_t
+bool
 xfs_btree_lblock_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp,
@@ -4488,7 +4486,7 @@ xfs_btree_lblock_verify(
  * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
  * @pag_max_level: pointer to the per-ag max level field
  */
-xfs_failaddr_t
+bool
 xfs_btree_sblock_v5hdr_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -4514,7 +4512,7 @@ xfs_btree_sblock_v5hdr_verify(
  * @bp: buffer containing the btree block
  * @max_recs: maximum records allowed in this btree node
  */
-xfs_failaddr_t
+bool
 xfs_btree_sblock_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index a585293798f3..db69909b56a1 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -240,12 +240,12 @@ typedef struct xfs_btree_cur
 #define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
 
 /*
- * Internal long and short btree block checks.  They return NULL if the
- * block is ok or the address of the failed check otherwise.
+ * Internal long and short btree block checks.  They return true if the
+ * block is ok or false otherwise.
  */
-xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
+bool __xfs_btree_check_lblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
-xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
+bool __xfs_btree_check_sblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
 
 /*
@@ -457,12 +457,12 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
 #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
-xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp);
-xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
+bool xfs_btree_sblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp);
+bool xfs_btree_sblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
 		unsigned int max_recs);
-xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp,
+bool xfs_btree_lblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp,
 		uint64_t owner);
-xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
+bool xfs_btree_lblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
 		unsigned int max_recs);
 
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f7510bf5f505..0b4f084766e3 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -116,7 +116,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_zone_free(xfs_da_state_zone, state);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_da3_node_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -174,11 +174,9 @@ xfs_da3_node_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_da3_node_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_da3_node_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -203,7 +201,6 @@ xfs_da3_node_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
-	xfs_failaddr_t		fa;
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
@@ -214,9 +211,8 @@ xfs_da3_node_read_verify(
 			}
 			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			fa = xfs_da3_node_verify(vc, bp);
-			if (fa)
-				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+			if (!xfs_da3_node_verify(vc, bp))
+				xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
@@ -235,7 +231,7 @@ xfs_da3_node_read_verify(
 }
 
 /* Verify the structure of a da3 block. */
-static xfs_failaddr_t
+static bool
 xfs_da3_node_verify_struct(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 12ae8c4285b2..534d5fcf13b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -46,7 +46,7 @@ xfs_dir_startup(void)
 	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_dir3_block_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -76,15 +76,13 @@ xfs_dir3_block_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_block_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_dir3_block_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -96,11 +94,9 @@ xfs_dir3_block_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_block_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_dir3_block_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 574fe8ba7144..a215c7adb480 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -21,7 +21,7 @@
 #include "xfs_cksum.h"
 #include "xfs_log.h"
 
-static xfs_failaddr_t xfs_dir2_data_freefind_verify(
+static bool xfs_dir2_data_freefind_verify(
 		struct xfs_vc *vc,
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
 		struct xfs_dir2_data_unused *dup,
@@ -30,9 +30,9 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
- * Return NULL if the buffer is good, otherwise the address of the error.
+ * Return true if the buffer is good, otherwise false.
  */
-xfs_failaddr_t
+bool
 __xfs_dir3_data_check(
 	struct xfs_vc		*vc,		/* verifier context */
 	struct xfs_inode	*dp,		/* incore inode pointer */
@@ -142,8 +142,6 @@ __xfs_dir3_data_check(
 		 * doesn't need to be there.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			xfs_failaddr_t	fa;
-
 			if (lastfree != 0)
 				return XFS_CORRUPTED_RETURN(vc);
 			if (endp < p + be16_to_cpu(dup->length))
@@ -151,9 +149,8 @@ __xfs_dir3_data_check(
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    (char *)dup - (char *)hdr)
 				return XFS_CORRUPTED_RETURN(vc);
-			fa = xfs_dir2_data_freefind_verify(vc, hdr, bf, dup, &dfp);
-			if (fa)
-				return fa;
+			if (!xfs_dir2_data_freefind_verify(vc, hdr, bf, dup, &dfp))
+				return false;
 			if (dfp) {
 				i = (int)(dfp - bf);
 				if ((freeseen & (1 << i)) != 0)
@@ -236,19 +233,17 @@ xfs_dir3_data_check(
 	struct xfs_buf		*bp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = __xfs_dir3_data_check(&vc, dp, bp);
-	if (!fa)
+	if (__xfs_dir3_data_check(&vc, dp, bp))
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
 			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
-			fa);
+			vc.fa);
 	ASSERT(0);
 }
 #endif
 
-static xfs_failaddr_t
+static bool
 xfs_dir3_data_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -307,15 +302,13 @@ xfs_dir3_data_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_DATA_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_data_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_dir3_data_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -327,11 +320,9 @@ xfs_dir3_data_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_data_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_dir3_data_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -389,7 +380,7 @@ xfs_dir3_data_readahead(
  * Find the bestfree entry that exactly coincides with unused directory space
  * or a verifier error because the bestfree data are bad.
  */
-static xfs_failaddr_t
+static bool
 xfs_dir2_data_freefind_verify(
 	struct xfs_vc			*vc,
 	struct xfs_dir2_data_hdr	*hdr,
@@ -963,7 +954,7 @@ xfs_dir2_data_make_free(
 }
 
 /* Check our free data for obvious signs of corruption. */
-static inline xfs_failaddr_t
+static inline bool
 xfs_dir2_data_check_free(
 	struct xfs_vc			*vc,
 	struct xfs_dir2_data_hdr	*hdr,
@@ -989,7 +980,7 @@ xfs_dir2_data_check_free(
 }
 
 /* Sanity-check a new bestfree entry. */
-static inline xfs_failaddr_t
+static inline bool
 xfs_dir2_data_check_new_free(
 	struct xfs_vc			*vc,
 	struct xfs_dir2_data_hdr	*hdr,
@@ -1024,15 +1015,13 @@ xfs_dir2_data_use_free(
 	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
 	struct xfs_dir2_data_free *bf;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 	int			matchback;	/* matches end of freespace */
 	int			matchfront;	/* matches start of freespace */
 	int			needscan;	/* need to regen bestfree */
 	int			oldlen;		/* old unused entry's length */
 
 	hdr = bp->b_addr;
-	fa = xfs_dir2_data_check_free(&vc, hdr, dup, offset, len);
-	if (fa)
+	if (!xfs_dir2_data_check_free(&vc, hdr, dup, offset, len))
 		goto corrupt;
 	/*
 	 * Look up the entry in the bestfree table.
@@ -1078,8 +1067,7 @@ xfs_dir2_data_use_free(
 			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
 			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
 						       needlogp);
-			fa = xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup);
-			if (fa)
+			if (!xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup))
 				goto corrupt;
 			/*
 			 * If we got inserted at the last slot,
@@ -1106,8 +1094,7 @@ xfs_dir2_data_use_free(
 			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
 			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
 						       needlogp);
-			fa = xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup);
-			if (fa)
+			if (!xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup))
 				goto corrupt;
 			/*
 			 * If we got inserted at the last slot,
@@ -1157,7 +1144,7 @@ xfs_dir2_data_use_free(
 	return 0;
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
-			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+			hdr, sizeof(*hdr), __FILE__, __LINE__, vc.fa);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 4488b898ca97..e757e1f950e4 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -38,7 +38,7 @@ static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
  * Pop an assert if something is wrong.
  */
 #ifdef DEBUG
-static xfs_failaddr_t
+static bool
 xfs_dir3_leaf1_check(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*dp,
@@ -65,21 +65,19 @@ xfs_dir3_leaf_check(
 	struct xfs_buf		*bp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_leaf1_check(&vc, dp, bp);
-	if (!fa)
+	if (xfs_dir3_leaf1_check(&vc, dp, bp))
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
 			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
-			fa);
+			vc.fa);
 	ASSERT(0);
 }
 #else
 #define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
-xfs_failaddr_t
+bool
 xfs_dir3_leaf_check_int(
 	struct xfs_vc		*vc,
 	struct xfs_mount	*mp,
@@ -143,7 +141,7 @@ xfs_dir3_leaf_check_int(
  * kernels we don't get assertion failures in xfs_dir3_leaf_hdr_from_disk() due
  * to incorrect magic numbers.
  */
-static xfs_failaddr_t
+static bool
 xfs_dir3_leaf_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp,
@@ -184,15 +182,13 @@ __read_verify(
 	uint16_t		magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	     !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_LEAF_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_leaf_verify(vc, bp, magic);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_dir3_leaf_verify(vc, bp, magic))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -205,11 +201,9 @@ __write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_leaf_verify(vc, bp, magic);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_dir3_leaf_verify(vc, bp, magic)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -222,7 +216,7 @@ __write_verify(
 	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_dir3_leaf1_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
@@ -246,7 +240,7 @@ xfs_dir3_leaf1_write_verify(
 	__write_verify(vc, bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_dir3_leafn_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1920caa65895..8105544c44fb 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -41,7 +41,7 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
  * Check internal consistency of a leafn block.
  */
 #ifdef DEBUG
-static xfs_failaddr_t
+static bool
 xfs_dir3_leafn_check(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*dp,
@@ -68,21 +68,19 @@ xfs_dir3_leaf_check(
 	struct xfs_buf		*bp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_leafn_check(&vc, dp, bp);
-	if (!fa)
+	if (xfs_dir3_leafn_check(&vc, dp, bp))
 		return;
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
 			bp->b_addr, BBTOB(bp->b_length), __FILE__, __LINE__,
-			fa);
+			vc.fa);
 	ASSERT(0);
 }
 #else
 #define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
-static xfs_failaddr_t
+static bool
 xfs_dir3_free_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -117,15 +115,13 @@ xfs_dir3_free_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_DIR3_FREE_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_dir3_free_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_dir3_free_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -137,11 +133,9 @@ xfs_dir3_free_write_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dir3_free_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_dir3_free_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -162,7 +156,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 };
 
 /* Everything ok in the free block header? */
-static xfs_failaddr_t
+static bool
 xfs_dir3_free_header_check(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*dp,
@@ -208,7 +202,6 @@ __xfs_dir3_free_read(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
@@ -217,9 +210,8 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_free_header_check(&vc, dp, fbno, *bpp);
-	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+	if (!xfs_dir3_free_header_check(&vc, dp, fbno, *bpp)) {
+		xfs_verifier_error(*bpp, -EFSCORRUPTED, vc.fa);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index c8d5dc67e02b..53c1a77f291b 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -32,7 +32,7 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_vc *vc, struct xfs_inode *dp,
+extern bool __xfs_dir3_data_check(struct xfs_vc *vc, struct xfs_inode *dp,
 		struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
@@ -78,7 +78,7 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
-extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_vc *vc, struct xfs_mount *mp,
+extern bool xfs_dir3_leaf_check_int(struct xfs_vc *vc, struct xfs_mount *mp,
 		struct xfs_inode *dp, struct xfs_dir3_icleaf_hdr *hdr,
 		struct xfs_dir2_leaf *leaf);
 
@@ -117,7 +117,7 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
-extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_vc *vc, struct xfs_inode *ip);
+extern bool xfs_dir2_sf_verify(struct xfs_vc *vc, struct xfs_inode *ip);
 
 /* xfs_dir2_readdir.c */
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 659243991b61..3645234df4bb 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -616,7 +616,7 @@ xfs_dir2_sf_check(
 #endif	/* DEBUG */
 
 /* Verify the consistency of an inline directory. */
-xfs_failaddr_t
+bool
 xfs_dir2_sf_verify(
 	struct xfs_vc			*vc,
 	struct xfs_inode		*ip)
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 0b7c76c5f3e1..16838ac0de71 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,7 +35,7 @@ xfs_calc_dquots_per_chunk(
  * smaller xfs_disk_dquot structure available.
  */
 
-xfs_failaddr_t
+bool
 xfs_dquot_verify(
 	struct xfs_vc	 *vc,
 	struct xfs_mount *mp,
@@ -94,7 +94,7 @@ xfs_dquot_verify(
 	return XFS_VERIFIED_RETURN(vc);
 }
 
-xfs_failaddr_t
+bool
 xfs_dqblk_verify(
 	struct xfs_vc		*vc,
 	struct xfs_mount	*mp,
@@ -175,7 +175,7 @@ xfs_dquot_buf_verify_crc(
 	return true;
 }
 
-STATIC xfs_failaddr_t
+STATIC bool
 xfs_dquot_buf_verify(
 	struct xfs_vc		*vc,
 	struct xfs_mount	*mp,
@@ -183,7 +183,6 @@ xfs_dquot_buf_verify(
 	bool			readahead)
 {
 	struct xfs_dqblk	*dqb = bp->b_addr;
-	xfs_failaddr_t		fa;
 	xfs_dqid_t		id = 0;
 	int			ndquots;
 	int			i;
@@ -213,20 +212,19 @@ xfs_dquot_buf_verify(
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		fa = xfs_dqblk_verify(vc, mp, &dqb[i], id + i, 0);
-		if (fa) {
+		if (!xfs_dqblk_verify(vc, mp, &dqb[i], id + i, 0)) {
 			if (!readahead)
 				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
 					__func__, &dqb[i],
-					sizeof(struct xfs_dqblk), fa);
-			return fa;
+					sizeof(struct xfs_dqblk), vc->fa);
+			return false;
 		}
 	}
 
 	return XFS_VERIFIED_RETURN(vc);
 }
 
-static xfs_failaddr_t
+static  bool
 xfs_dquot_buf_verify_struct(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -262,7 +260,7 @@ xfs_dquot_buf_readahead_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
-	    xfs_dquot_buf_verify(vc, mp, bp, true) != NULL) {
+	    !xfs_dquot_buf_verify(vc, mp, bp, true)) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 	}
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f24abdc20d3b..32fb58c929f0 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2495,7 +2495,7 @@ xfs_ialloc_log_agi(
 	}
 }
 
-static xfs_failaddr_t
+static bool
 xfs_agi_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
@@ -2554,15 +2554,14 @@ xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(vc, bp, XFS_AGI_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_agi_verify(vc, bp);
-		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_IALLOC_READ_AGI))
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (XFS_TEST_ERROR(!xfs_agi_verify(vc, bp),
+				   mp, XFS_ERRTAG_IALLOC_READ_AGI))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -2573,11 +2572,9 @@ xfs_agi_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_agi_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_agi_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a3902165aac5..30a1fcf24767 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -254,14 +254,13 @@ xfs_inobt_diff_two_keys(
 			  be32_to_cpu(k2->inobt.ir_startino);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_inobt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -277,9 +276,8 @@ xfs_inobt_verify(
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
-		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
-		if (fa)
-			return fa;
+		if (!xfs_btree_sblock_v5hdr_verify(vc, bp))
+			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
 	case cpu_to_be32(XFS_FIBT_MAGIC):
@@ -301,14 +299,11 @@ xfs_inobt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_inobt_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_inobt_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 
 	if (bp->b_error)
@@ -320,12 +315,9 @@ xfs_inobt_write_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
-	fa = xfs_inobt_verify(vc, bp);
-	if (fa) {
+	if (!xfs_inobt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a04f75f2885f..0e3d7ed938c5 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -378,7 +378,7 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-static xfs_failaddr_t
+static bool
 xfs_dinode_verify_fork(
 	struct xfs_vc		*vc,
 	struct xfs_dinode	*dip,
@@ -420,7 +420,7 @@ xfs_dinode_verify_fork(
 	return XFS_VERIFIED_RETURN(vc);
 }
 
-static xfs_failaddr_t
+static bool
 xfs_dinode_verify_forkoff(
 	struct xfs_vc		*vc,
 	struct xfs_dinode	*dip,
@@ -446,14 +446,13 @@ xfs_dinode_verify_forkoff(
 	return XFS_VERIFIED_RETURN(vc);
 }
 
-xfs_failaddr_t
+bool
 xfs_dinode_verify(
 	struct xfs_vc		*vc,
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
-	xfs_failaddr_t		fa;
 	uint16_t		mode;
 	uint16_t		flags;
 	uint64_t		flags2;
@@ -503,9 +502,8 @@ xfs_dinode_verify(
 		return XFS_CORRUPTED_RETURN(vc);
 
 	/* check for illegal values of forkoff */
-	fa = xfs_dinode_verify_forkoff(vc, dip, mp);
-	if (fa)
-		return fa;
+	if (!xfs_dinode_verify_forkoff(vc, dip, mp))
+		return false;
 
 	/* Do we have appropriate data fork formats for the mode? */
 	switch (mode & S_IFMT) {
@@ -519,9 +517,8 @@ xfs_dinode_verify(
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		fa = xfs_dinode_verify_fork(vc, dip, mp, XFS_DATA_FORK);
-		if (fa)
-			return fa;
+		if (!xfs_dinode_verify_fork(vc, dip, mp, XFS_DATA_FORK))
+			return false;
 		break;
 	case 0:
 		/* Uninitialized inode ok. */
@@ -531,9 +528,8 @@ xfs_dinode_verify(
 	}
 
 	if (XFS_DFORK_Q(dip)) {
-		fa = xfs_dinode_verify_fork(vc, dip, mp, XFS_ATTR_FORK);
-		if (fa)
-			return fa;
+		if (!xfs_dinode_verify_fork(vc, dip, mp, XFS_ATTR_FORK))
+			return false;
 	} else {
 		/*
 		 * If there is no fork offset, this may be a freshly-made inode
@@ -553,10 +549,9 @@ xfs_dinode_verify(
 	}
 
 	/* extent size hint validation */
-	fa = xfs_inode_validate_extsize(vc, mp, be32_to_cpu(dip->di_extsize),
-			mode, flags);
-	if (fa)
-		return fa;
+	if (!xfs_inode_validate_extsize(vc, mp, be32_to_cpu(dip->di_extsize),
+			mode, flags))
+		return false;
 
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
@@ -582,10 +577,9 @@ xfs_dinode_verify(
 		return XFS_CORRUPTED_RETURN(vc);
 
 	/* COW extent size hint validation */
-	fa = xfs_inode_validate_cowextsize(vc, mp, be32_to_cpu(dip->di_cowextsize),
-			mode, flags, flags2);
-	if (fa)
-		return fa;
+	if (!xfs_inode_validate_cowextsize(vc, mp, be32_to_cpu(dip->di_cowextsize),
+			mode, flags, flags2))
+		return false;
 
 	return XFS_VERIFIED_RETURN(vc);
 }
@@ -628,7 +622,6 @@ xfs_iread(
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
 	struct xfs_vc	vc = { 0 };
-	xfs_failaddr_t	fa;
 	int		error;
 
 	/*
@@ -657,10 +650,9 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	fa = xfs_dinode_verify(&vc, mp, ip->i_ino, dip);
-	if (fa) {
+	if (!xfs_dinode_verify(&vc, mp, ip->i_ino, dip)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
-				sizeof(*dip), fa);
+				sizeof(*dip), vc.fa);
 		error = -EFSCORRUPTED;
 		goto out_brelse;
 	}
@@ -734,7 +726,7 @@ xfs_iread(
  * The rules are documented at xfs_ioctl_setattr_check_extsize().
  * These functions must be kept in sync with each other.
  */
-xfs_failaddr_t
+bool
 xfs_inode_validate_extsize(
 	struct xfs_vc			*vc,
 	struct xfs_mount		*mp,
@@ -792,7 +784,7 @@ xfs_inode_validate_extsize(
  * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
  * These functions must be kept in sync with each other.
  */
-xfs_failaddr_t
+bool
 xfs_inode_validate_cowextsize(
 	struct xfs_vc			*vc,
 	struct xfs_mount		*mp,
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index fceea886275f..7dfb09360f3e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -70,11 +70,11 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-xfs_failaddr_t xfs_dinode_verify(struct xfs_vc *vc, struct xfs_mount *mp, xfs_ino_t ino,
+bool xfs_dinode_verify(struct xfs_vc *vc, struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
-xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_vc *vc, struct xfs_mount *mp,
+bool xfs_inode_validate_extsize(struct xfs_vc *vc, struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
-xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_vc *vc, struct xfs_mount *mp,
+bool xfs_inode_validate_cowextsize(struct xfs_vc *vc, struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 78ee502d856e..14ce22222073 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -234,14 +234,12 @@ xfs_iformat_extents(
 		xfs_iext_first(ifp, &icur);
 		for (i = 0; i < nex; i++, dp++) {
 			struct xfs_vc	vc = { 0 };
-			xfs_failaddr_t	fa;
 
 			xfs_bmbt_disk_get_all(dp, &new);
-			fa = xfs_bmap_validate_extent(&vc, ip, whichfork, &new);
-			if (fa) {
+			if (!xfs_bmap_validate_extent(&vc, ip, whichfork, &new)) {
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
-						dp, sizeof(*dp), fa);
+						dp, sizeof(*dp), vc.fa);
 				return -EFSCORRUPTED;
 			}
 
@@ -556,6 +554,7 @@ xfs_iextents_copy(
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	rec;
 	int			copied = 0;
+	struct xfs_vc		vc = { 0 };
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
@@ -563,7 +562,7 @@ xfs_iextents_copy(
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
 			continue;
-		ASSERT(xfs_bmap_validate_extent(NULL, ip, whichfork, &rec) == NULL);
+		ASSERT(xfs_bmap_validate_extent(&vc, ip, whichfork, &rec));
 		xfs_bmbt_disk_set_all(dp, &rec);
 		trace_xfs_write_extent(ip, &icur, state, _RET_IP_);
 		copied += sizeof(struct xfs_bmbt_rec);
@@ -700,7 +699,7 @@ struct xfs_ifork_ops xfs_default_ifork_ops = {
 };
 
 /* Verify the inline contents of the data fork of an inode. */
-xfs_failaddr_t
+bool
 xfs_ifork_verify_data(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*ip,
@@ -722,7 +721,7 @@ xfs_ifork_verify_data(
 }
 
 /* Verify the inline contents of the attr fork of an inode. */
-xfs_failaddr_t
+bool
 xfs_ifork_verify_attr(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b2f67389304c..422cd7d59045 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -174,7 +174,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
-typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_vc *vc, struct xfs_inode *);
+typedef bool (*xfs_ifork_verifier_t)(struct xfs_vc *vc, struct xfs_inode *);
 
 struct xfs_ifork_ops {
 	xfs_ifork_verifier_t	verify_symlink;
@@ -183,9 +183,9 @@ struct xfs_ifork_ops {
 };
 extern struct xfs_ifork_ops	xfs_default_ifork_ops;
 
-xfs_failaddr_t xfs_ifork_verify_data(struct xfs_vc *vc, struct xfs_inode *ip,
+bool xfs_ifork_verify_data(struct xfs_vc *vc, struct xfs_inode *ip,
 		struct xfs_ifork_ops *ops);
-xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_vc *vc, struct xfs_inode *ip,
+bool xfs_ifork_verify_attr(struct xfs_vc *vc, struct xfs_inode *ip,
 		struct xfs_ifork_ops *ops);
 
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index d6af05e0a6f1..fa26d21820bc 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -137,9 +137,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
-extern xfs_failaddr_t xfs_dquot_verify(struct xfs_vc *vc, struct xfs_mount *mp,
+extern bool xfs_dquot_verify(struct xfs_vc *vc, struct xfs_mount *mp,
 		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
-extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_vc *vc, struct xfs_mount *mp,
+extern bool xfs_dqblk_verify(struct xfs_vc *vc, struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 409ae8c08380..4b4c80fd3d6c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -201,7 +201,7 @@ xfs_refcountbt_diff_two_keys(
 			  be32_to_cpu(k2->refc.rc_startblock);
 }
 
-STATIC xfs_failaddr_t
+STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -209,7 +209,6 @@ xfs_refcountbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
-	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
@@ -217,9 +216,8 @@ xfs_refcountbt_verify(
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return XFS_CORRUPTED_RETURN(vc);
-	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
-	if (fa)
-		return fa;
+	if (!xfs_btree_sblock_v5hdr_verify(vc, bp))
+		return false;
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
@@ -236,14 +234,11 @@ xfs_refcountbt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_refcountbt_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_refcountbt_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 
 	if (bp->b_error)
@@ -255,12 +250,9 @@ xfs_refcountbt_write_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
-	fa = xfs_refcountbt_verify(vc, bp);
-	if (fa) {
+	if (!xfs_refcountbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e9265c8c1cea..ed0022fb03f6 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -288,7 +288,7 @@ xfs_rmapbt_diff_two_keys(
 	return 0;
 }
 
-static xfs_failaddr_t
+static bool
 xfs_rmapbt_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -296,7 +296,6 @@ xfs_rmapbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
-	xfs_failaddr_t		fa;
 	unsigned int		level;
 
 	/*
@@ -316,9 +315,8 @@ xfs_rmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_CORRUPTED_RETURN(vc);
-	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
-	if (fa)
-		return fa;
+	if (!xfs_btree_sblock_v5hdr_verify(vc, bp))
+		return false;
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
@@ -335,14 +333,11 @@ xfs_rmapbt_read_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
 	if (!xfs_btree_sblock_verify_crc(vc, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_rmapbt_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_rmapbt_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 
 	if (bp->b_error)
@@ -354,12 +349,9 @@ xfs_rmapbt_write_verify(
 	struct xfs_vc	*vc,
 	struct xfs_buf	*bp)
 {
-	xfs_failaddr_t	fa;
-
-	fa = xfs_rmapbt_verify(vc, bp);
-	if (fa) {
+	if (!xfs_rmapbt_verify(vc, bp)) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 	xfs_btree_sblock_calc_crc(bp);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c10d02addaa1..984753b49639 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -132,6 +132,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
+bool xfs_symlink_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 9141a1635dac..401398d0235a 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -86,7 +86,7 @@ xfs_symlink_hdr_ok(
 	return true;
 }
 
-static xfs_failaddr_t
+static bool
 xfs_symlink_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
@@ -119,7 +119,6 @@ xfs_symlink_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -128,9 +127,8 @@ xfs_symlink_read_verify(
 	if (!xfs_buf_verify_cksum(vc, bp, XFS_SYMLINK_CRC_OFF))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
-		fa = xfs_symlink_verify(vc, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		if (!xfs_symlink_verify(vc, bp))
+			xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 	}
 }
 
@@ -141,15 +139,13 @@ xfs_symlink_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	fa = xfs_symlink_verify(vc, bp);
-	if (fa) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	if (!xfs_symlink_verify(vc, bp)) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, vc->fa);
 		return;
 	}
 
@@ -203,7 +199,7 @@ xfs_symlink_local_to_remote(
 }
 
 /* Verify the consistency of an inline symlink. */
-xfs_failaddr_t
+bool
 xfs_symlink_shortform_verify(
 	struct xfs_vc		*vc,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d39c7e28ad00..29b0d354d9b7 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -45,8 +45,8 @@ struct xfs_vc {
 	xfs_failaddr_t	fa;
 };
 
-#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; __this_address;})
-#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; NULL;})
+#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; false;})
+#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; true;})
 
 /*
  * Null values for the types.
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 8780dcb479de..a04824a992d3 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -491,7 +491,6 @@ xchk_btree_get_block(
 	struct xfs_buf		**pbp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		failed_at;
 	int			error;
 
 	*pblock = NULL;
@@ -503,16 +502,20 @@ xchk_btree_get_block(
 		return error;
 
 	xfs_btree_get_block(bs->cur, level, pbp);
-	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		failed_at = __xfs_btree_check_lblock(&vc, bs->cur, *pblock,
-				level, *pbp);
-	else
-		failed_at = __xfs_btree_check_sblock(&vc, bs->cur, *pblock,
-				 level, *pbp);
-	if (failed_at) {
-		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
-		return 0;
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (!__xfs_btree_check_lblock(&vc, bs->cur, *pblock,
+				level, *pbp)) {
+			xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+			return 0;
+		}
+	} else {
+		if (!__xfs_btree_check_sblock(&vc, bs->cur, *pblock,
+				 level, *pbp)) {
+			xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+			return 0;
+		}
 	}
+
 	if (*pbp)
 		xchk_buffer_recheck(bs->sc, *pbp);
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1571e66e657a..2796add960b0 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -792,7 +792,6 @@ xchk_buffer_recheck(
 	struct xfs_buf		*bp)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
 	if (bp->b_ops == NULL) {
 		xchk_block_set_corrupt(sc, bp);
@@ -802,11 +801,10 @@ xchk_buffer_recheck(
 		xchk_set_incomplete(sc);
 		return;
 	}
-	fa = bp->b_ops->verify_struct(&vc, bp);
-	if (!fa)
+	if (bp->b_ops->verify_struct(&vc, bp))
 		return;
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
-	trace_xchk_block_error(sc, bp->b_bn, fa);
+	trace_xchk_block_error(sc, bp->b_bn, vc.fa);
 }
 
 /*
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 4626a208d132..aacdb3b0b783 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -221,7 +221,7 @@ xchk_da_btree_write_verify(
 		return;
 	}
 }
-static void *
+static bool
 xchk_da_btree_verify(
 	struct xfs_vc		*vc,
 	struct xfs_buf		*bp)
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index f8c6869b8fc6..0159c554cb93 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -84,11 +84,9 @@ xchk_inode_extsize(
 	uint16_t		flags)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = xfs_inode_validate_extsize(&vc, sc->mp, be32_to_cpu(dip->di_extsize),
-			mode, flags);
-	if (fa)
+	if (!xfs_inode_validate_extsize(&vc, sc->mp, be32_to_cpu(dip->di_extsize),
+			mode, flags))
 		xchk_ino_set_corrupt(sc, ino);
 }
 
@@ -108,12 +106,10 @@ xchk_inode_cowextsize(
 	uint64_t		flags2)
 {
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = xfs_inode_validate_cowextsize(&vc, sc->mp,
+	if (!xfs_inode_validate_cowextsize(&vc, sc->mp,
 			be32_to_cpu(dip->di_cowextsize), mode, flags,
-			flags2);
-	if (fa)
+			flags2))
 		xchk_ino_set_corrupt(sc, ino);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e7e1e070f76e..fb85973ea7ca 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -127,7 +127,7 @@ struct xfs_buf_ops {
 	char *name;
 	void (*verify_read)(struct xfs_vc *vc, struct xfs_buf *);
 	void (*verify_write)(struct xfs_vc *vc, struct xfs_buf *);
-	xfs_failaddr_t (*verify_struct)(struct xfs_vc *vc, struct xfs_buf *bp);
+	bool (*verify_struct)(struct xfs_vc *vc, struct xfs_buf *bp);
 };
 
 typedef struct xfs_buf {
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 14b386c584b6..a780263c5616 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1075,7 +1075,6 @@ xfs_qm_dqflush(
 	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddqp;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
@@ -1123,10 +1122,9 @@ xfs_qm_dqflush(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot.
 	 */
-	fa = xfs_dqblk_verify(&vc, mp, dqb, be32_to_cpu(ddqp->d_id), 0);
-	if (fa) {
+	if (!xfs_dqblk_verify(&vc, mp, dqb, be32_to_cpu(ddqp->d_id), 0)) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(ddqp->d_id), fa);
+				be32_to_cpu(ddqp->d_id), vc.fa);
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d2fd4d4b7864..007bb1926d56 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3417,22 +3417,19 @@ xfs_inode_verify_forks(
 {
 	struct xfs_ifork	*ifp;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
-	fa = xfs_ifork_verify_data(&vc, ip, &xfs_default_ifork_ops);
-	if (fa) {
+	if (!xfs_ifork_verify_data(&vc, ip, &xfs_default_ifork_ops)) {
 		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
-				ifp->if_u1.if_data, ifp->if_bytes, fa);
+				ifp->if_u1.if_data, ifp->if_bytes, vc.fa);
 		return false;
 	}
 
-	fa = xfs_ifork_verify_attr(&vc, ip, &xfs_default_ifork_ops);
-	if (fa) {
+	if (!xfs_ifork_verify_attr(&vc, ip, &xfs_default_ifork_ops)) {
 		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
 				ifp ? ifp->if_u1.if_data : NULL,
-				ifp ? ifp->if_bytes : 0, fa);
+				ifp ? ifp->if_bytes : 0, vc.fa);
 		return false;
 	}
 	return true;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bcafd3961d20..8262b5edbfd9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2651,7 +2651,6 @@ xlog_recover_do_reg_buffer(
 	int			bit;
 	int			nbits;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2686,7 +2685,6 @@ xlog_recover_do_reg_buffer(
 		 * the first dquot in the buffer should do. XXXThis is
 		 * probably a good thing to do for other buf types also.
 		 */
-		fa = NULL;
 		if (buf_f->blf_flags &
 		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 			if (item->ri_buf[i].i_addr == NULL) {
@@ -2700,12 +2698,11 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			fa = xfs_dquot_verify(&vc, mp, item->ri_buf[i].i_addr,
-					       -1, 0);
-			if (fa) {
+			if (!xfs_dquot_verify(&vc, mp, item->ri_buf[i].i_addr,
+					       -1, 0)) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
-					fa, bp->b_bn);
+					vc.fa, bp->b_bn);
 				goto next;
 			}
 		}
@@ -3310,12 +3307,10 @@ xlog_recover_dquot_pass2(
 	xfs_buf_t		*bp;
 	struct xfs_disk_dquot	*ddq, *recddq;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 	int			error;
 	xfs_dq_logformat_t	*dq_f;
 	uint			type;
 
-
 	/*
 	 * Filesystems are required to send in quota flags at mount time.
 	 */
@@ -3353,10 +3348,9 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(&vc, mp, recddq, dq_f->qlf_id, 0);
-	if (fa) {
+	if (!xfs_dquot_verify(&vc, mp, recddq, dq_f->qlf_id, 0)) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
-				dq_f->qlf_id, fa);
+				dq_f->qlf_id, vc.fa);
 		return -EIO;
 	}
 	ASSERT(dq_f->qlf_len == 1);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 09cd6e971074..b61b21599157 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -834,7 +834,6 @@ xfs_qm_reset_dqcounts(
 	struct xfs_dqblk	*dqb;
 	int			j;
 	struct xfs_vc		vc = { 0 };
-	xfs_failaddr_t		fa;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -859,8 +858,7 @@ xfs_qm_reset_dqcounts(
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dqblk_verify(&vc, mp, &dqb[j], id + j, type);
-		if (fa)
+		if (!xfs_dqblk_verify(&vc, mp, &dqb[j], id + j, type))
 			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*
-- 
2.17.0
