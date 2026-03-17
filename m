Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB1D611E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773712962; cv=none; b=K3vaStE+ls1rcDKCoBpsHnM9TS2Gihr8Av3JCUTIdkMIqbSOSiCYUPGwaGzOllRllpba0FS6szrQLz/gv2g//6XNTVvy8g9EMzOmi50OWQmAV1phHrjjO/24YzRxC5qykomF3/bXyi4UPv65Jl4raJ8VdOwi8AT/jPKchIvpamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773712962; c=relaxed/simple;
	bh=PBT5XAivGJo0lGgj5UmuXCOWGLgg2G3LNyFx7BRB044=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVVuzvZWkN5aueeZU4I0B1IK2HyHmCl0oejJBFZy3dubkNTLycbUv8XglNHwdq2tsmzmIETwAELWcZjDjcVgWLlvgGVt50zQoorrWdjUJuGD++k681Q8SbgEKhw7i9eqg4TK/nYy4vkJlDkBgRaeaB8D0gtoc+5P3It1EVXKH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=JMrVOb+1; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="JMrVOb+1"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nTR83OPIKAEw0r0Ib9cIstGS28QVcazsXYFN1ytisnU=;
	b=JMrVOb+1QRPzAPJTvlAzKqT2XJLXoOicnsr3xv4QJPCNQmmx0mDX2SbVsUei//zODR8eSWhVg
	LTFR5+XGblp1GVozqzcALEdQM2GzIH2s+aCgGTLPi9VCK4d20eh05KEAPt9FQ6TkL8HjUX43FiL
	PZcd3qILw0toF9ttlO5hsLg=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fZZp90Bgsz12LCj;
	Tue, 17 Mar 2026 09:57:05 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 32A2E2025E;
	Tue, 17 Mar 2026 10:02:37 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:02:35 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:02:34 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 4/4] xfs: close crash window in attr dabtree inactivation
Date: Tue, 17 Mar 2026 09:51:55 +0800
Message-ID: <20260317015155.589955-5-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260317015155.589955-1-leo.lilong@huawei.com>
References: <20260317015155.589955-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

When inactivating an inode with node-format extended attributes,
xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
xfs_trans_binval(), but intentionally does not remove the corresponding
entries from their parent node blocks.  The implicit assumption is that
xfs_attr_inactive() will truncate the entire attr fork to zero extents
afterwards, so log recovery will never reach the root node and follow
those stale pointers.

However, if a log shutdown occurs after the leaf/node block cancellations
commit but before the attr bmap truncation commits, this assumption
breaks.  Recovery replays the attr bmap intact (the inode still has
attr fork extents), but suppresses replay of all cancelled leaf/node
blocks, maybe leaving them as stale data on disk.  On the next mount,
xlog_recover_process_iunlinks() retries inactivation and attempts to
read the root node via the attr bmap. If the root node was not replayed,
reading the unreplayed root block triggers a metadata verification
failure immediately; if it was replayed, following its child pointers
to unreplayed child blocks triggers the same failure:

 XFS (pmem0): Metadata corruption detected at
 xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
 XFS (pmem0): Unmount and run xfs_repair
 XFS (pmem0): First 128 bytes of corrupted metadata buffer:
 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117

Fix this in two places:

In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
child block, immediately remove the entry that references it from the
parent node in the same transaction.  This eliminates the window where
the parent holds a pointer to a cancelled block.  Once all children are
removed, the now-empty root node is converted to a leaf block within the
same transaction. This node-to-leaf conversion is necessary for crash
safety. If the system shutdown after the empty node is written to the
log but before the second-phase bmap truncation commits, log recovery
will attempt to verify the root block on disk. xfs_da3_node_verify()
does not permit a node block with count == 0; such a block will fail
verification and trigger a metadata corruption shutdown. on the other
hand, leaf blocks are allowed to have this transient state.

In xfs_attr_inactive(), split the attr fork truncation into two explicit
phases.  First, truncate all extents beyond the root block (the child
extents whose parent references have already been removed above).
Second, invalidate the root block and truncate the attr bmap to zero in
a single transaction.  The two operations in the second phase must be
atomic: as long as the attr bmap has any non-zero length, recovery can
follow it to the root block, so the root block invalidation must commit
together with the bmap-to-zero truncation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_inactive.c | 99 +++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 92331991f9fd..a5b69c0fbfd0 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -140,7 +140,7 @@ xfs_attr3_node_inactive(
 	xfs_daddr_t		parent_blkno, child_blkno;
 	struct xfs_buf		*child_bp;
 	struct xfs_da3_icnode_hdr ichdr;
-	int			error, i;
+	int			error;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
@@ -152,7 +152,7 @@ xfs_attr3_node_inactive(
 		return -EFSCORRUPTED;
 	}
 
-	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
+	xfs_da3_node_hdr_from_disk(mp, &ichdr, bp->b_addr);
 	parent_blkno = xfs_buf_daddr(bp);
 	if (!ichdr.count) {
 		xfs_trans_brelse(*trans, bp);
@@ -167,7 +167,7 @@ xfs_attr3_node_inactive(
 	 * over the leaves removing all of them.  If this is higher up
 	 * in the tree, recurse downward.
 	 */
-	for (i = 0; i < ichdr.count; i++) {
+	while (ichdr.count > 0) {
 		/*
 		 * Read the subsidiary block to see what we have to work with.
 		 * Don't do this in a transaction.  This is a depth-first
@@ -218,29 +218,32 @@ xfs_attr3_node_inactive(
 		xfs_trans_binval(*trans, child_bp);
 		child_bp = NULL;
 
-		/*
-		 * If we're not done, re-read the parent to get the next
-		 * child block number.
-		 */
-		if (i + 1 < ichdr.count) {
-			struct xfs_da3_icnode_hdr phdr;
+		error = xfs_da3_node_read_mapped(*trans, dp,
+				parent_blkno, &bp, XFS_ATTR_FORK);
+		if (error)
+			return error;
 
-			error = xfs_da3_node_read_mapped(*trans, dp,
-					parent_blkno, &bp, XFS_ATTR_FORK);
+		/*
+		 * Remove entry from parent node, prevents being indexed to.
+		 */
+		xfs_attr3_node_entry_remove(*trans, dp, bp, 0);
+
+		xfs_da3_node_hdr_from_disk(mp, &ichdr, bp->b_addr);
+		bp = NULL;
+
+		if (ichdr.count > 0) {
+			/*
+			 * If we're not done, get the next child block number.
+			 */
+			child_fsb = be32_to_cpu(ichdr.btree[0].before);
+
+			/*
+			 * Atomically commit the whole invalidate stuff.
+			 */
+			error = xfs_trans_roll_inode(trans, dp);
 			if (error)
 				return error;
-			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
-						  bp->b_addr);
-			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
-			xfs_trans_brelse(*trans, bp);
-			bp = NULL;
 		}
-		/*
-		 * Atomically commit the whole invalidate stuff.
-		 */
-		error = xfs_trans_roll_inode(trans, dp);
-		if (error)
-			return  error;
 	}
 
 	return 0;
@@ -257,10 +260,8 @@ xfs_attr3_root_inactive(
 	struct xfs_trans	**trans,
 	struct xfs_inode	*dp)
 {
-	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_blkinfo	*info;
 	struct xfs_buf		*bp;
-	xfs_daddr_t		blkno;
 	int			error;
 
 	/*
@@ -272,7 +273,6 @@ xfs_attr3_root_inactive(
 	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
 	if (error)
 		return error;
-	blkno = xfs_buf_daddr(bp);
 
 	/*
 	 * Invalidate the tree, even if the "tree" is only a single leaf block.
@@ -283,10 +283,26 @@ xfs_attr3_root_inactive(
 	case cpu_to_be16(XFS_DA_NODE_MAGIC):
 	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
 		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
+		/*
+		 * Empty root node block are not allowed, convert it to leaf.
+		 */
+		if (!error)
+			error = xfs_attr3_leaf_init(*trans, dp, 0);
+		if (!error)
+			error = xfs_trans_roll_inode(trans, dp);
 		break;
 	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
 	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
+		/*
+		 * Reinit the leaf before truncating extents so that a crash
+		 * mid-truncation leaves an empty leaf rather than one with
+		 * entries that may reference freed remote value blocks.
+		 */
+		if (!error)
+			error = xfs_attr3_leaf_init(*trans, dp, 0);
+		if (!error)
+			error = xfs_trans_roll_inode(trans, dp);
 		break;
 	default:
 		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
@@ -295,21 +311,6 @@ xfs_attr3_root_inactive(
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
-	if (error)
-		return error;
-
-	/*
-	 * Invalidate the incore copy of the root block.
-	 */
-	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
-			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
-	if (error)
-		return error;
-	xfs_trans_binval(*trans, bp);	/* remove from cache */
-	/*
-	 * Commit the invalidate and start the next transaction.
-	 */
-	error = xfs_trans_roll_inode(trans, dp);
 
 	return error;
 }
@@ -328,6 +329,7 @@ xfs_attr_inactive(
 {
 	struct xfs_trans	*trans;
 	struct xfs_mount	*mp;
+	struct xfs_buf          *bp;
 	int			lock_mode = XFS_ILOCK_SHARED;
 	int			error = 0;
 
@@ -363,10 +365,27 @@ xfs_attr_inactive(
 	 * removal below.
 	 */
 	if (dp->i_af.if_nextents > 0) {
+		/*
+		 * Invalidate and truncate all blocks but leave the root block.
+		 */
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
 
+		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK,
+				XFS_FSB_TO_B(mp, mp->m_attr_geo->fsbcount));
+		if (error)
+			goto out_cancel;
+
+		/*
+		 * Invalidate and truncate the root block and ensure that the
+		 * operation is completed within a single transaction.
+		 */
+		error = xfs_da_get_buf(trans, dp, 0, &bp, XFS_ATTR_FORK);
+		if (error)
+			goto out_cancel;
+
+		xfs_trans_binval(trans, bp);
 		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
 		if (error)
 			goto out_cancel;
-- 
2.39.2

