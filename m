Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E772C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 454062083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nWB01rfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgEGMUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgEGMUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FEAC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zra7xqRU36Gwcm+WInfZMJvFTyDIlJr8TWLdnaKpqmk=; b=nWB01rfphSGlNt8pISE5Jcqa31
        lh8mrB54pkM6e0AL3F1GvzAcH+vBcUeMQIhU68QEHGFS7OVCnCNSZ1WxGY7b3RxmxcXobFVrOMAQT
        gVG4nOfjDkWDwBoQqBIORcLopJg8owgRlH9VJBrJOzeV0hvE63DG917sIVQ4/MMDbJzGGKiZXgvp4
        Lntne4+qjH48lYlz8XA50+iavmEqia+SN5jd4MgluTALpY/4yuUOU/4+T47yWemDjb7Ad5VBkI2bF
        oeABFaMVOkOG+d9NWhBaenfgwWENKnIl7H7TC9ox2cP/YNzchgVKzmI0rjYnKUKtDlrtKd1310L2g
        olTTwAqQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVy-0007hR-2R; Thu, 07 May 2020 12:20:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 41/58] xfs: convert btree cursor inode-private member names
Date:   Thu,  7 May 2020 14:18:34 +0200
Message-Id: <20200507121851.304002-42-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 92219c292af8ddfb64d75bdffcbdd9baf80ac0aa

bc_private.b -> bc_ino conversion via script:

$ sed -i 's/bc_private\.b/bc_ino/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

And then revert the change to the bc_ino #define in
fs/xfs/libxfs/xfs_btree.h manually.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: tweak the subject line slightly]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c       | 44 ++++++++++++++++++------------------
 libxfs/xfs_bmap_btree.c | 50 ++++++++++++++++++++---------------------
 libxfs/xfs_btree.c      | 50 ++++++++++++++++++++---------------------
 3 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d28c41ca..efa85597 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -683,7 +683,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -720,7 +720,7 @@ xfs_bmap_extents_to_btree(
 	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
 	tp->t_firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
+	cur->bc_ino.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
@@ -946,7 +946,7 @@ xfs_bmap_add_attrfork_btree(
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 			return -ENOSPC;
 		}
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	}
 	return 0;
@@ -973,7 +973,7 @@ xfs_bmap_add_attrfork_extents(
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
 					  XFS_DATA_FORK);
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -1171,13 +1171,13 @@ xfs_iread_bmbt_block(
 {
 	struct xfs_iread_state	*ir = priv;
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
 	struct xfs_bmbt_rec	*frp;
 	xfs_extnum_t		num_recs;
 	xfs_extnum_t		j;
-	int			whichfork = cur->bc_private.b.whichfork;
+	int			whichfork = cur->bc_ino.whichfork;
 
 	block = xfs_btree_get_block(cur, level, &bp);
 
@@ -1521,7 +1521,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
-	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	       (bma->cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -1811,7 +1811,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+			(bma->cur ? bma->cur->bc_ino.allocated : 0));
 
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
@@ -1897,7 +1897,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+			(bma->cur ? bma->cur->bc_ino.allocated : 0));
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
@@ -2018,8 +2018,8 @@ xfs_bmap_add_extent_delay_real(
 		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
-		da_new += bma->cur->bc_private.b.allocated;
-		bma->cur->bc_private.b.allocated = 0;
+		da_new += bma->cur->bc_ino.allocated;
+		bma->cur->bc_ino.allocated = 0;
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
@@ -2566,7 +2566,7 @@ xfs_bmap_add_extent_unwritten_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		*curp = cur;
 	}
 
@@ -2745,7 +2745,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2948,7 +2948,7 @@ xfs_bmap_add_extent_hole_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur)
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 
 	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
@@ -4180,7 +4180,7 @@ xfs_bmapi_allocate(
 	bma->nallocs++;
 
 	if (bma->cur)
-		bma->cur->bc_private.b.flags =
+		bma->cur->bc_ino.flags =
 			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
@@ -4702,7 +4702,7 @@ xfs_bmapi_remap(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	got.br_startoff = bno;
@@ -5357,7 +5357,7 @@ __xfs_bunmapi(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	} else
 		cur = NULL;
 
@@ -5613,7 +5613,7 @@ error0:
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
 		if (!error)
-			cur->bc_private.b.allocated = 0;
+			cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -5832,7 +5832,7 @@ xfs_bmap_collapse_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
@@ -5949,7 +5949,7 @@ xfs_bmap_insert_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	if (*next_fsb == NULLFSBLOCK) {
@@ -6067,7 +6067,7 @@ xfs_bmap_split_extent(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
@@ -6126,7 +6126,7 @@ xfs_bmap_split_extent(
 
 del_cursor:
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 44381686..ed7b7286 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -164,13 +164,13 @@ xfs_bmbt_dup_cursor(
 	struct xfs_btree_cur	*new;
 
 	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+			cur->bc_ino.ip, cur->bc_ino.whichfork);
 
 	/*
 	 * Copy the firstblock, dfops, and flags values,
 	 * since init cursor doesn't get them.
 	 */
-	new->bc_private.b.flags = cur->bc_private.b.flags;
+	new->bc_ino.flags = cur->bc_ino.flags;
 
 	return new;
 }
@@ -181,12 +181,12 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*dst)
 {
 	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
-	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	       (dst->bc_ino.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
 
-	dst->bc_private.b.allocated += src->bc_private.b.allocated;
+	dst->bc_ino.allocated += src->bc_ino.allocated;
 	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
 
-	src->bc_private.b.allocated = 0;
+	src->bc_ino.allocated = 0;
 }
 
 STATIC int
@@ -203,8 +203,8 @@ xfs_bmbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_tp->t_firstblock;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
-			cur->bc_private.b.whichfork);
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
+			cur->bc_ino.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -228,7 +228,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
@@ -257,10 +257,10 @@ xfs_bmbt_alloc_block(
 
 	ASSERT(args.len == 1);
 	cur->bc_tp->t_firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	xfs_trans_mod_dquot_byino(args.tp, cur->bc_private.b.ip,
+	cur->bc_ino.allocated++;
+	cur->bc_ino.ip->i_d.di_nblocks++;
+	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
+	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
 
 	new->l = cpu_to_be64(args.fsbno);
@@ -278,12 +278,12 @@ xfs_bmbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
@@ -300,8 +300,8 @@ xfs_bmbt_get_minrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0) / 2;
@@ -318,8 +318,8 @@ xfs_bmbt_get_maxrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0);
@@ -345,7 +345,7 @@ xfs_bmbt_get_dmaxrecs(
 {
 	if (level != cur->bc_nlevels - 1)
 		return cur->bc_mp->m_bmap_dmxr[level != 0];
-	return xfs_bmdr_maxrecs(cur->bc_private.b.forksize, level == 0);
+	return xfs_bmdr_maxrecs(cur->bc_ino.forksize, level == 0);
 }
 
 STATIC void
@@ -564,11 +564,11 @@ xfs_bmbt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
-	cur->bc_private.b.ip = ip;
-	cur->bc_private.b.allocated = 0;
-	cur->bc_private.b.flags = 0;
-	cur->bc_private.b.whichfork = whichfork;
+	cur->bc_ino.forksize = XFS_IFORK_SIZE(ip, whichfork);
+	cur->bc_ino.ip = ip;
+	cur->bc_ino.allocated = 0;
+	cur->bc_ino.flags = 0;
+	cur->bc_ino.whichfork = whichfork;
 
 	return cur;
 }
@@ -642,7 +642,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
-	cur->bc_private.b.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
+	cur->bc_ino.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8f9d290a..9985b85d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -231,8 +231,8 @@ xfs_btree_check_ptr(
 			return 0;
 		xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_private.b.ip->i_ino,
-				cur->bc_private.b.whichfork, cur->bc_btnum,
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork, cur->bc_btnum,
 				level, index);
 	} else {
 		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
@@ -375,7 +375,7 @@ xfs_btree_del_cursor(
 	 * allocated indirect blocks' accounting.
 	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_private.b.allocated == 0);
+	       cur->bc_ino.allocated == 0);
 	/*
 	 * Free the cursor.
 	 */
@@ -651,7 +651,7 @@ xfs_btree_get_iroot(
 {
 	struct xfs_ifork	*ifp;
 
-	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
@@ -1141,7 +1141,7 @@ xfs_btree_init_block_cur(
 	 * code.
 	 */
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		owner = cur->bc_private.b.ip->i_ino;
+		owner = cur->bc_ino.ip->i_ino;
 	else
 		owner = cur->bc_ag.agno;
 
@@ -1390,8 +1390,8 @@ xfs_btree_log_keys(
 				  xfs_btree_key_offset(cur, first),
 				  xfs_btree_key_offset(cur, last + 1) - 1);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-				xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+				xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 }
 
@@ -1433,8 +1433,8 @@ xfs_btree_log_ptrs(
 				xfs_btree_ptr_offset(cur, first, level),
 				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+			xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 
 }
@@ -1502,8 +1502,8 @@ xfs_btree_log_block(
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+			xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 }
 
@@ -1740,10 +1740,10 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
-	    !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
+	    !(cur->bc_ino.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_private.b.ip->i_ino)
+			cur->bc_ino.ip->i_ino)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */
@@ -2939,9 +2939,9 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_private.b.ip,
+	xfs_iroot_realloc(cur->bc_ino.ip,
 			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_private.b.whichfork);
+			  cur->bc_ino.whichfork);
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -2954,7 +2954,7 @@ xfs_btree_new_iroot(
 	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 
 	*logflags |=
-		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
 	*stat = 1;
 	return 0;
 error0:
@@ -3106,11 +3106,11 @@ xfs_btree_make_block_unfull(
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1) {
-		struct xfs_inode *ip = cur->bc_private.b.ip;
+		struct xfs_inode *ip = cur->bc_ino.ip;
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
+			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3456,8 +3456,8 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_private.b.whichfork;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_ino.whichfork;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
@@ -3515,8 +3515,8 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, index,
-				  cur->bc_private.b.whichfork);
+		xfs_iroot_realloc(cur->bc_ino.ip, index,
+				  cur->bc_ino.whichfork);
 		block = ifp->if_broot;
 	}
 
@@ -3545,7 +3545,7 @@ xfs_btree_kill_iroot(
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	cur->bc_nlevels--;
 out0:
 	return 0;
@@ -3713,8 +3713,8 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-					  cur->bc_private.b.whichfork);
+			xfs_iroot_realloc(cur->bc_ino.ip, -1,
+					  cur->bc_ino.whichfork);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
-- 
2.26.2

