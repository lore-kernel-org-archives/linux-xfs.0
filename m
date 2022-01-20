Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11167C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345119AbiATAV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAE8C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A205261512
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060FAC004E1;
        Thu, 20 Jan 2022 00:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638086;
        bh=n3cPTER/3JpboojDC6GerTDphfw7lKyK69jsJB5Ua8c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OVyOZrb/87L0QwrZB5BZHwWRq5Me+IPJzIqstwSrlWiYgBczHUVj0EUFSvUFOde3s
         +33V26koGCmC/Fbqn81G1vczRGNofEgPP3nC/JLvnOzPrtBF5i43C7xXSb8RMbFS3V
         VmjhO9RLMA/KoLehI61/PkvHvPdV0dChLcQye5hv6CoD8GUpfsd5huezaJGiqMjeaP
         Zf2CKGa43BoHTuPm7eV+fDFG612e6dcvsthpDjvBCaXHW0MBj2PZ2aZlQvFnGWe/HX
         gXi7W6X+zGiQcVKyZ7OsTC6Z+J/SZ6NOkaR1+1NJIi1Hi0gFFxurs8ruDF953h/wJS
         MYg1jkEMfQ41Q==
Subject: [PATCH 44/45] xfs: convert bp->b_bn references to xfs_buf_daddr()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:21:25 -0800
Message-ID: <164263808570.860211.3046983085685727158.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 9343ee76909e3f6466d85c9ebb0e343cdf54de71

Stop directly referencing b_bn in code outside the buffer cache, as
b_bn is supposed to be used only as an internal cache index.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c               |    2 +-
 libxfs/util.c               |    4 ++--
 libxfs/xfs_ag.c             |    1 -
 libxfs/xfs_attr_leaf.c      |    4 ++--
 libxfs/xfs_attr_remote.c    |    8 ++++----
 libxfs/xfs_bmap.c           |    2 +-
 libxfs/xfs_btree.c          |   25 +++++++++++++------------
 libxfs/xfs_da_btree.c       |    8 ++++----
 libxfs/xfs_dir2_block.c     |    4 ++--
 libxfs/xfs_dir2_data.c      |    4 ++--
 libxfs/xfs_dir2_leaf.c      |    4 ++--
 libxfs/xfs_dir2_node.c      |    6 +++---
 libxfs/xfs_inode_buf.c      |    2 +-
 libxfs/xfs_sb.c             |    2 +-
 libxfs/xfs_symlink_remote.c |    4 ++--
 repair/attr_repair.c        |    8 ++++----
 repair/phase6.c             |    8 ++++----
 repair/xfs_repair.c         |    2 +-
 18 files changed, 49 insertions(+), 49 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 2c649c15..48cda88a 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -204,7 +204,7 @@ write_buf(
 			print_warning(
 			    "obfuscation corrupted block at %s bno 0x%llx/0x%x",
 				bp->b_ops->name,
-				(long long)bp->b_bn, BBTOB(bp->b_length));
+				(long long)xfs_buf_daddr(bp), BBTOB(bp->b_length));
 		}
 	}
 
diff --git a/libxfs/util.c b/libxfs/util.c
index 9c8230cd..69cc477c 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -556,7 +556,7 @@ xfs_verifier_error(
 	xfs_alert(NULL, "Metadata %s detected at %p, %s block 0x%llx/0x%x",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  failaddr ? failaddr : __return_address,
-		  bp->b_ops->name, bp->b_bn, BBTOB(bp->b_length));
+		  bp->b_ops->name, xfs_buf_daddr(bp), BBTOB(bp->b_length));
 }
 
 /*
@@ -589,7 +589,7 @@ xfs_buf_corruption_error(
 	xfs_failaddr_t		fa)
 {
 	xfs_alert(NULL, "Metadata corruption detected at %p, %s block 0x%llx",
-		  fa, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, xfs_buf_daddr(bp));
 }
 
 /*
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 6691ca70..c95e8b26 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -313,7 +313,6 @@ xfs_get_aghdr_buf(
 	if (error)
 		return error;
 
-	bp->b_bn = blkno;
 	bp->b_maps[0].bm_bn = blkno;
 	bp->b_ops = ops;
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 308fc0f7..76a52573 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1203,7 +1203,7 @@ xfs_attr3_leaf_to_node(
 	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
 	if (xfs_has_crc(mp)) {
 		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
-		hdr3->blkno = cpu_to_be64(bp2->b_bn);
+		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp2));
 	}
 	xfs_trans_log_buf(args->trans, bp2, 0, args->geo->blksize - 1);
 
@@ -1271,7 +1271,7 @@ xfs_attr3_leaf_create(
 
 		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
 
-		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 73eb256e..afa93290 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -129,7 +129,7 @@ __xfs_attr3_rmt_read_verify(
 		return 0;
 
 	ptr = bp->b_addr;
-	bno = bp->b_bn;
+	bno = xfs_buf_daddr(bp);
 	len = BBTOB(bp->b_length);
 	ASSERT(len >= blksize);
 
@@ -194,7 +194,7 @@ xfs_attr3_rmt_write_verify(
 		return;
 
 	ptr = bp->b_addr;
-	bno = bp->b_bn;
+	bno = xfs_buf_daddr(bp);
 	len = BBTOB(bp->b_length);
 	ASSERT(len >= blksize);
 
@@ -283,7 +283,7 @@ xfs_attr_rmtval_copyout(
 	uint8_t		**dst)
 {
 	char		*src = bp->b_addr;
-	xfs_daddr_t	bno = bp->b_bn;
+	xfs_daddr_t	bno = xfs_buf_daddr(bp);
 	int		len = BBTOB(bp->b_length);
 	int		blksize = mp->m_attr_geo->blksize;
 
@@ -331,7 +331,7 @@ xfs_attr_rmtval_copyin(
 	uint8_t		**src)
 {
 	char		*dst = bp->b_addr;
-	xfs_daddr_t	bno = bp->b_bn;
+	xfs_daddr_t	bno = xfs_buf_daddr(bp);
 	int		len = BBTOB(bp->b_length);
 	int		blksize = mp->m_attr_geo->blksize;
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1edf6236..d5ccce1f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -732,7 +732,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block_int(mp, ablock, abp->b_bn,
+	xfs_btree_init_block_int(mp, ablock, xfs_buf_daddr(abp),
 				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
 				XFS_BTREE_LONG_PTRS);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2f86ab68..3d9d0dcc 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -67,7 +67,7 @@ __xfs_btree_check_lblock(
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (block->bb_u.l.bb_blkno !=
-		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
+		    cpu_to_be64(bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL))
 			return __this_address;
 		if (block->bb_u.l.bb_pad != cpu_to_be32(0))
 			return __this_address;
@@ -132,7 +132,7 @@ __xfs_btree_check_sblock(
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (block->bb_u.s.bb_blkno !=
-		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
+		    cpu_to_be64(bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL))
 			return __this_address;
 	}
 
@@ -1128,7 +1128,7 @@ xfs_btree_init_block(
 	__u16		numrecs,
 	__u64		owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
+	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), xfs_buf_daddr(bp),
 				 btnum, level, numrecs, owner, 0);
 }
 
@@ -1152,9 +1152,9 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
-				 cur->bc_btnum, level, numrecs,
-				 owner, cur->bc_flags);
+	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp),
+				xfs_buf_daddr(bp), cur->bc_btnum, level,
+				numrecs, owner, cur->bc_flags);
 }
 
 /*
@@ -2924,10 +2924,11 @@ xfs_btree_new_iroot(
 	 */
 	memcpy(cblock, block, xfs_btree_block_len(cur));
 	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
 		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-			cblock->bb_u.l.bb_blkno = cpu_to_be64(cbp->b_bn);
+			cblock->bb_u.l.bb_blkno = bno;
 		else
-			cblock->bb_u.s.bb_blkno = cpu_to_be64(cbp->b_bn);
+			cblock->bb_u.s.bb_blkno = bno;
 	}
 
 	be16_add_cpu(&block->bb_level, 1);
@@ -3226,7 +3227,7 @@ xfs_btree_insrec(
 
 	/* Get pointers to the btree buffer and block. */
 	block = xfs_btree_get_block(cur, level, &bp);
-	old_bn = bp ? bp->b_bn : XFS_BUF_DADDR_NULL;
+	old_bn = bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL;
 	numrecs = xfs_btree_get_numrecs(block);
 
 #ifdef DEBUG
@@ -3342,7 +3343,7 @@ xfs_btree_insrec(
 	 * some records into the new tree block), so use the regular key
 	 * update mechanism.
 	 */
-	if (bp && bp->b_bn != old_bn) {
+	if (bp && xfs_buf_daddr(bp) != old_bn) {
 		xfs_btree_get_keys(cur, block, lkey);
 	} else if (xfs_btree_needs_key_update(cur, optr)) {
 		error = xfs_btree_update_keys(cur, level);
@@ -4423,7 +4424,7 @@ xfs_btree_lblock_v5hdr_verify(
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
-	if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
+	if (block->bb_u.l.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 		return __this_address;
 	if (owner != XFS_RMAP_OWN_UNKNOWN &&
 	    be64_to_cpu(block->bb_u.l.bb_owner) != owner)
@@ -4473,7 +4474,7 @@ xfs_btree_sblock_v5hdr_verify(
 		return __this_address;
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
-	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
+	if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 		return __this_address;
 	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
 		return __this_address;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index d2dec4aa..0e504d2d 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -191,7 +191,7 @@ xfs_da3_blkinfo_verify(
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
@@ -444,7 +444,7 @@ xfs_da3_node_create(
 
 		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
-		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
+		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
 		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
@@ -708,7 +708,7 @@ xfs_da3_root_split(
 	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
 		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
 
-		node3->hdr.info.blkno = cpu_to_be64(bp->b_bn);
+		node3->hdr.info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
 	}
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
@@ -1216,7 +1216,7 @@ xfs_da3_root_join(
 	xfs_trans_buf_copy_type(root_blk->bp, bp);
 	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
 		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
-		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(root_blk->bp));
 	}
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
 			  args->geo->blksize - 1);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index f5d0f703..1b8c2521 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -53,7 +53,7 @@ xfs_dir3_block_verify(
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
@@ -171,7 +171,7 @@ xfs_dir3_block_init(
 	if (xfs_has_crc(mp)) {
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
-		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 		return;
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 85cb14d3..4e207986 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -297,7 +297,7 @@ xfs_dir3_data_verify(
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
@@ -719,7 +719,7 @@ xfs_dir3_data_init(
 
 		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
-		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 70b1f083..8827c96c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -106,7 +106,7 @@ xfs_dir3_leaf1_check(
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
-		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+		if (be64_to_cpu(leaf3->info.blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
 		return __this_address;
@@ -314,7 +314,7 @@ xfs_dir3_leaf_init(
 		leaf3->info.hdr.magic = (type == XFS_DIR2_LEAF1_MAGIC)
 					 ? cpu_to_be16(XFS_DIR3_LEAF1_MAGIC)
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
-		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
+		leaf3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		leaf3->info.owner = cpu_to_be64(owner);
 		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index e7ed4b46..c0eb335c 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -65,7 +65,7 @@ xfs_dir3_leafn_check(
 
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
-		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+		if (be64_to_cpu(leaf3->info.blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
 		return __this_address;
@@ -107,7 +107,7 @@ xfs_dir3_free_verify(
 
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
+		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
 			return __this_address;
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
 			return __this_address;
@@ -343,7 +343,7 @@ xfs_dir3_free_get_buf(
 
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
 
-		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
+		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 516dab25..68bd5f52 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -68,7 +68,7 @@ xfs_inode_buf_verify(
 #ifdef DEBUG
 			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
-				(unsigned long long)bp->b_bn, i,
+				(unsigned long long)xfs_buf_daddr(bp), i,
 				be16_to_cpu(dip->di_magic));
 #endif
 			xfs_buf_verifier_error(bp, -EFSCORRUPTED,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 680441ae..d7e3526c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -745,7 +745,7 @@ xfs_sb_read_verify(
 
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
-			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
+			if (xfs_buf_daddr(bp) == XFS_SB_DADDR ||
 			    xfs_has_crc(mp)) {
 				error = -EFSBADCRC;
 				goto out_error;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index e0a68319..a5cbb40f 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -48,7 +48,7 @@ xfs_symlink_hdr_set(
 	dsl->sl_bytes = cpu_to_be32(size);
 	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
 	dsl->sl_owner = cpu_to_be64(ino);
-	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
+	dsl->sl_blkno = cpu_to_be64(xfs_buf_daddr(bp));
 	bp->b_ops = &xfs_symlink_buf_ops;
 
 	return sizeof(struct xfs_dsymlink_hdr);
@@ -92,7 +92,7 @@ xfs_symlink_verify(
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
-	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
+	if (xfs_buf_daddr(bp) != be64_to_cpu(dsl->sl_blkno))
 		return __this_address;
 	if (be32_to_cpu(dsl->sl_offset) +
 				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index df1b519f..927dd095 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -935,14 +935,14 @@ __check_attr_header(
 		do_warn(
 _("expected owner inode %" PRIu64 ", got %llu, attr block %" PRIu64 "\n"),
 			ino, (unsigned long long)be64_to_cpu(info->owner),
-			bp->b_bn);
+			xfs_buf_daddr(bp));
 		return 1;
 	}
 	/* verify block number */
-	if (be64_to_cpu(info->blkno) != bp->b_bn) {
+	if (be64_to_cpu(info->blkno) != xfs_buf_daddr(bp)) {
 		do_warn(
 _("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
-			bp->b_bn, (unsigned long long)be64_to_cpu(info->blkno),
+			xfs_buf_daddr(bp), (unsigned long long)be64_to_cpu(info->blkno),
 			ino);
 		return 1;
 	}
@@ -950,7 +950,7 @@ _("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
 	if (platform_uuid_compare(&info->uuid, &mp->m_sb.sb_meta_uuid) != 0) {
 		do_warn(
 _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
-			ino, bp->b_bn);
+			ino, xfs_buf_daddr(bp));
 		return 1;
 	}
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 647dc1c5..9e60c87b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1905,21 +1905,21 @@ __check_dir3_header(
 	if (be64_to_cpu(owner) != ino) {
 		do_warn(
 _("expected owner inode %" PRIu64 ", got %llu, directory block %" PRIu64 "\n"),
-			ino, (unsigned long long)be64_to_cpu(owner), bp->b_bn);
+			ino, (unsigned long long)be64_to_cpu(owner), xfs_buf_daddr(bp));
 		return 1;
 	}
 	/* verify block number */
-	if (be64_to_cpu(blkno) != bp->b_bn) {
+	if (be64_to_cpu(blkno) != xfs_buf_daddr(bp)) {
 		do_warn(
 _("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
-			bp->b_bn, (unsigned long long)be64_to_cpu(blkno), ino);
+			xfs_buf_daddr(bp), (unsigned long long)be64_to_cpu(blkno), ino);
 		return 1;
 	}
 	/* verify uuid */
 	if (platform_uuid_compare(uuid, &mp->m_sb.sb_meta_uuid) != 0) {
 		do_warn(
 _("wrong FS UUID, directory inode %" PRIu64 " block %" PRIu64 "\n"),
-			ino, bp->b_bn);
+			ino, xfs_buf_daddr(bp));
 		return 1;
 	}
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bcd44cd5..4769c130 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -850,7 +850,7 @@ repair_capture_writeback(
 	 * avoid hook recursion when setting NEEDSREPAIR.  Higher level code
 	 * modifying an sb must control the flag manually.
 	 */
-	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
+	if (bp->b_ops == &xfs_sb_buf_ops || xfs_buf_daddr(bp) == XFS_SB_DADDR)
 		return;
 
 	pthread_mutex_lock(&wb_mutex);

