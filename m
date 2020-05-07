Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6FAC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41BA2083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vpn3hNWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgEGMUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEGMUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3158CC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bL/OV6fVuD4Xldqibc+MPdC91txoZrpW89LYx7gZGJ8=; b=Vpn3hNWQj34jp+aR2Apfc5tuXM
        h/t9LrumUPmhhJVdMxIMakBcl3nG38PyaciyQYrCHx3/LkEIzi1+gKsxsIUUl9gmxD7HleYEzrS61
        CzNYY897UGzUCrLE1In+e7cCReM2yxfw26P8V7E4KX8j0gfA4SUC+9QimZcV6Lt1RJ/3eeu8Kdy9h
        FRVArmT+Fk3Q5caYn17xVYEDc6+lPMy8myqUy8EqWvnkesM9MZymTA6DrT2K+wkDsXYi4TKtrt/BA
        StoGnvZo8m6xRmtH+Pbg82M3goEzDneZBrK4c0KxFW8juaKrmryq1CqdRF5eS29lLwOEZU0vYebhm
        16ju44BQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVv-0007gb-FD; Thu, 07 May 2020 12:20:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 40/58] xfs: convert btree cursor ag-private member name
Date:   Thu,  7 May 2020 14:18:33 +0200
Message-Id: <20200507121851.304002-41-hch@lst.de>
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

Source kernel commit: 576af7322807601d5ef366597645a69471570e10

bc_private.a -> bc_ag conversion via script:

`sed -i 's/bc_private\.a/bc_ag/g' fs/xfs/*[ch] fs/xfs/*/*[ch]`

And then revert the change to the bc_ag #define in
fs/xfs/libxfs/xfs_btree.h manually.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc.c          |  16 +++---
 libxfs/xfs_alloc_btree.c    |  24 ++++----
 libxfs/xfs_btree.c          |  12 ++--
 libxfs/xfs_ialloc.c         |   2 +-
 libxfs/xfs_ialloc_btree.c   |  20 +++----
 libxfs/xfs_refcount.c       | 110 ++++++++++++++++++------------------
 libxfs/xfs_refcount_btree.c |  28 ++++-----
 libxfs/xfs_rmap.c           | 110 ++++++++++++++++++------------------
 libxfs/xfs_rmap_btree.c     |  28 ++++-----
 9 files changed, 175 insertions(+), 175 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index fdd92da3..434856ea 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -147,7 +147,7 @@ xfs_alloc_lookup_eq(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_private.a.priv.abt.active = (*stat == 1);
+	cur->bc_ag.priv.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -167,7 +167,7 @@ xfs_alloc_lookup_ge(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_private.a.priv.abt.active = (*stat == 1);
+	cur->bc_ag.priv.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -186,7 +186,7 @@ xfs_alloc_lookup_le(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_private.a.priv.abt.active = (*stat == 1);
+	cur->bc_ag.priv.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -194,7 +194,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_private.a.priv.abt.active;
+	return cur && cur->bc_ag.priv.abt.active;
 }
 
 /*
@@ -226,7 +226,7 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_private.a.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -904,7 +904,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_private.a.priv.abt.active = false;
+		cur->bc_ag.priv.abt.active = false;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1348,7 +1348,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_private.a.priv.abt.active = false;
+			cur->bc_ag.priv.abt.active = false;
 
 		if (count > 0)
 			count--;
@@ -1463,7 +1463,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_private.a.priv.abt.active = true;
+			acur->cnt->bc_ag.priv.abt.active = true;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 337db214..dac354b1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -23,7 +23,7 @@ xfs_allocbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_ag.agbp, cur->bc_ag.agno,
 			cur->bc_btnum);
 }
 
@@ -33,7 +33,7 @@ xfs_allocbt_set_root(
 	union xfs_btree_ptr	*ptr,
 	int			inc)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
@@ -60,7 +60,7 @@ xfs_allocbt_alloc_block(
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
 				       &bno, 1);
 	if (error)
 		return error;
@@ -70,7 +70,7 @@ xfs_allocbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
@@ -84,7 +84,7 @@ xfs_allocbt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
@@ -111,7 +111,7 @@ xfs_allocbt_update_lastrec(
 	int			ptr,
 	int			reason)
 {
-	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag;
 	__be32			len;
@@ -160,7 +160,7 @@ xfs_allocbt_update_lastrec(
 	pag = xfs_perag_get(cur->bc_mp, seqno);
 	pag->pagf_longest = be32_to_cpu(len);
 	xfs_perag_put(pag);
-	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
 }
 
 STATIC int
@@ -224,9 +224,9 @@ xfs_allocbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
@@ -503,9 +503,9 @@ xfs_allocbt_init_cursor(
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	}
 
-	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
-	cur->bc_private.a.priv.abt.active = false;
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ag.agno = agno;
+	cur->bc_ag.priv.abt.active = false;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 51be86e4..8f9d290a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -211,7 +211,7 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
-	return xfs_verify_agbno(cur->bc_mp, cur->bc_private.a.agno, agbno);
+	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.agno, agbno);
 }
 
 /*
@@ -240,7 +240,7 @@ xfs_btree_check_ptr(
 			return 0;
 		xfs_err(cur->bc_mp,
 "AG %u: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_private.a.agno, cur->bc_btnum,
+				cur->bc_ag.agno, cur->bc_btnum,
 				level, index);
 	}
 
@@ -878,13 +878,13 @@ xfs_btree_readahead_sblock(
 
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
 				     left, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
 				     right, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
@@ -942,7 +942,7 @@ xfs_btree_ptr_to_daddr(
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
 		agbno = be32_to_cpu(ptr->s);
-		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.agno,
 				agbno);
 	}
 
@@ -1143,7 +1143,7 @@ xfs_btree_init_block_cur(
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		owner = cur->bc_private.b.ip->i_ino;
 	else
-		owner = cur->bc_private.a.agno;
+		owner = cur->bc_ag.agno;
 
 	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
 				 cur->bc_btnum, level, numrecs,
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4906e89b..616256b4 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -100,7 +100,7 @@ xfs_inobt_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_private.a.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	uint64_t			realfree;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 79c5721b..55414e17 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -33,7 +33,7 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_ag.agbp, cur->bc_ag.agno,
 			cur->bc_btnum);
 }
 
@@ -43,7 +43,7 @@ xfs_inobt_set_root(
 	union xfs_btree_ptr	*nptr,
 	int			inc)	/* level change */
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agi		*agi = agbp->b_addr;
 
 	agi->agi_root = nptr->s;
@@ -57,7 +57,7 @@ xfs_finobt_set_root(
 	union xfs_btree_ptr	*nptr,
 	int			inc)	/* level change */
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agi		*agi = agbp->b_addr;
 
 	agi->agi_free_root = nptr->s;
@@ -82,7 +82,7 @@ __xfs_inobt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
@@ -211,9 +211,9 @@ xfs_inobt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -223,9 +223,9 @@ xfs_finobt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
 }
 
@@ -432,8 +432,8 @@ xfs_inobt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ag.agno = agno;
 
 	return cur;
 }
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index b8a45b15..4d7f465a 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -45,7 +45,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -62,7 +62,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -79,7 +79,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -107,7 +107,7 @@ xfs_refcount_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_private.a.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	xfs_agblock_t			realstart;
@@ -118,7 +118,7 @@ xfs_refcount_get_rec(
 
 	xfs_refcount_btrec_to_irec(rec, irec);
 
-	agno = cur->bc_private.a.agno;
+	agno = cur->bc_ag.agno;
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
@@ -143,7 +143,7 @@ xfs_refcount_get_rec(
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
 		goto out_bad_rec;
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno, irec);
+	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.agno, irec);
 	return 0;
 
 out_bad_rec:
@@ -168,14 +168,14 @@ xfs_refcount_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_refcount_update(cur->bc_mp, cur->bc_private.a.agno, irec);
+	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.agno, irec);
 	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
 	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
 	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_refcount_update_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -192,7 +192,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_private.a.agno, irec);
+	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.agno, irec);
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
@@ -207,7 +207,7 @@ xfs_refcount_insert(
 out_error:
 	if (error)
 		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -233,7 +233,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
+	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		error = -EFSCORRUPTED;
@@ -245,7 +245,7 @@ xfs_refcount_delete(
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -365,7 +365,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.agno,
 			&rcext, agbno);
 
 	/* Establish the right extent. */
@@ -390,7 +390,7 @@ xfs_refcount_split_extent(
 
 out_error:
 	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -410,7 +410,7 @@ xfs_refcount_merge_center_extents(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_private.a.agno, left, center, right);
+			cur->bc_ag.agno, left, center, right);
 
 	/*
 	 * Make sure the center and right extents are not in the btree.
@@ -467,7 +467,7 @@ xfs_refcount_merge_center_extents(
 
 out_error:
 	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -486,7 +486,7 @@ xfs_refcount_merge_left_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_private.a.agno, left, cleft);
+			cur->bc_ag.agno, left, cleft);
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
@@ -529,7 +529,7 @@ xfs_refcount_merge_left_extent(
 
 out_error:
 	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -547,7 +547,7 @@ xfs_refcount_merge_right_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_private.a.agno, cright, right);
+			cur->bc_ag.agno, cright, right);
 
 	/*
 	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
@@ -593,7 +593,7 @@ xfs_refcount_merge_right_extent(
 
 out_error:
 	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -678,13 +678,13 @@ xfs_refcount_find_left_extents(
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
 	}
-	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.agno,
 			left, cleft, agbno);
 	return error;
 
 out_error:
 	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -767,13 +767,13 @@ xfs_refcount_find_right_extents(
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
 	}
-	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.agno,
 			cright, right, agbno + aglen);
 	return error;
 
 out_error:
 	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -882,7 +882,7 @@ xfs_refcount_still_have_space(
 {
 	unsigned long			overhead;
 
-	overhead = cur->bc_private.a.priv.refc.shape_changes *
+	overhead = cur->bc_ag.priv.refc.shape_changes *
 			xfs_allocfree_log_count(cur->bc_mp, 1);
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -890,17 +890,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_private.a.priv.refc.nr_ops > 2 &&
+	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_private.a.priv.refc.nr_ops == 0)
+	if (cur->bc_ag.priv.refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_private.a.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -951,7 +951,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_private.a.agno, &tmp);
+					cur->bc_ag.agno, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -967,10 +967,10 @@ xfs_refcount_adjust_extents(
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
-				cur->bc_private.a.priv.refc.nr_ops++;
+				cur->bc_ag.priv.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_private.a.agno,
+						cur->bc_ag.agno,
 						tmp.rc_startblock);
 				xfs_bmap_add_free(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, oinfo);
@@ -997,12 +997,12 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_private.a.agno, &ext);
+				cur->bc_ag.agno, &ext);
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
 				goto out_error;
-			cur->bc_private.a.priv.refc.nr_ops++;
+			cur->bc_ag.priv.refc.nr_ops++;
 		} else if (ext.rc_refcount == 1) {
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
@@ -1011,11 +1011,11 @@ xfs_refcount_adjust_extents(
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
-			cur->bc_private.a.priv.refc.nr_ops++;
+			cur->bc_ag.priv.refc.nr_ops++;
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_private.a.agno,
+					cur->bc_ag.agno,
 					ext.rc_startblock);
 			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
 					  oinfo);
@@ -1034,7 +1034,7 @@ advloop:
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1056,10 +1056,10 @@ xfs_refcount_adjust(
 	*new_agbno = agbno;
 	*new_aglen = aglen;
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_private.a.agno,
+		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_ag.agno,
 				agbno, aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_private.a.agno,
+		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_ag.agno,
 				agbno, aglen);
 
 	/*
@@ -1087,7 +1087,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_private.a.priv.refc.shape_changes++;
+		cur->bc_ag.priv.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
@@ -1098,7 +1098,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1114,7 +1114,7 @@ xfs_refcount_finish_one_cleanup(
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_private.a.agbp;
+	agbp = rcur->bc_ag.agbp;
 	xfs_btree_del_cursor(rcur, error);
 	if (error)
 		xfs_trans_brelse(tp, agbp);
@@ -1164,9 +1164,9 @@ xfs_refcount_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
-		nr_ops = rcur->bc_private.a.priv.refc.nr_ops;
-		shape_changes = rcur->bc_private.a.priv.refc.shape_changes;
+	if (rcur != NULL && rcur->bc_ag.agno != agno) {
+		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
+		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1182,8 +1182,8 @@ xfs_refcount_finish_one(
 			error = -ENOMEM;
 			goto out_cur;
 		}
-		rcur->bc_private.a.priv.refc.nr_ops = nr_ops;
-		rcur->bc_private.a.priv.refc.shape_changes = shape_changes;
+		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
+		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
@@ -1302,7 +1302,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.agno,
 			agbno, aglen);
 
 	/* By default, skip the whole range */
@@ -1382,12 +1382,12 @@ xfs_refcount_find_shared(
 
 done:
 	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_private.a.agno, *fbno, *flen);
+			cur->bc_ag.agno, *fbno, *flen);
 
 out_error:
 	if (error)
 		trace_xfs_refcount_find_shared_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1484,7 +1484,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_private.a.agno, &tmp);
+				cur->bc_ag.agno, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1512,7 +1512,7 @@ xfs_refcount_adjust_cow_extents(
 
 		ext.rc_refcount = 0;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_private.a.agno, &ext);
+				cur->bc_ag.agno, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1528,7 +1528,7 @@ xfs_refcount_adjust_cow_extents(
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_private.a.agno, error, _RET_IP_);
+			cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1574,7 +1574,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1588,7 +1588,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
+	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.agno,
 			agbno, aglen);
 
 	/* Add refcount btree reservation */
@@ -1605,7 +1605,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
+	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.agno,
 			agbno, aglen);
 
 	/* Remove refcount btree reservation */
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 75c60aac..4d925617 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -24,7 +24,7 @@ xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+			cur->bc_ag.agbp, cur->bc_ag.agno);
 }
 
 STATIC void
@@ -33,7 +33,7 @@ xfs_refcountbt_set_root(
 	union xfs_btree_ptr	*ptr,
 	int			inc)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
@@ -56,7 +56,7 @@ xfs_refcountbt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
@@ -65,7 +65,7 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
 			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
@@ -74,13 +74,13 @@ xfs_refcountbt_alloc_block(
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
 			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.agno == cur->bc_ag.agno);
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -100,12 +100,12 @@ xfs_refcountbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	int			error;
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
@@ -168,9 +168,9 @@ xfs_refcountbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -335,12 +335,12 @@ xfs_refcountbt_init_cursor(
 
 	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 
-	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.a.priv.refc.nr_ops = 0;
-	cur->bc_private.a.priv.refc.shape_changes = 0;
+	cur->bc_ag.priv.refc.nr_ops = 0;
+	cur->bc_ag.priv.refc.shape_changes = 0;
 
 	return cur;
 }
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index c485c29d..6fdaa04f 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -78,7 +78,7 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.agno,
 			irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
@@ -90,7 +90,7 @@ xfs_rmap_update(
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -106,7 +106,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -132,7 +132,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				rcur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -148,7 +148,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -169,7 +169,7 @@ xfs_rmap_delete(
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				rcur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -196,7 +196,7 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_private.a.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -259,7 +259,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			cur->bc_ag.agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -311,7 +311,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			cur->bc_ag.agno, bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -319,7 +319,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				cur->bc_ag.agno, irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -335,7 +335,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			cur->bc_ag.agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -384,14 +384,14 @@ xfs_rmap_lookup_le_range(
 	info.stat = stat;
 
 	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			cur->bc_ag.agno, bno, 0, owner, offset, flags);
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_lookup_le_range_helper, &info);
 	if (error == -ECANCELED)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				cur->bc_ag.agno, irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -497,7 +497,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -521,7 +521,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, ltrec.rm_startblock,
+			cur->bc_ag.agno, ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -587,7 +587,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -665,7 +665,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -677,11 +677,11 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.agno,
 				error, _RET_IP_);
 	return error;
 }
@@ -772,7 +772,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
@@ -794,7 +794,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, ltrec.rm_startblock,
+				cur->bc_ag.agno, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -830,7 +830,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			cur->bc_ag.agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -869,7 +869,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+			trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -920,7 +920,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -931,11 +931,11 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_map_error(mp, cur->bc_ag.agno,
 				error, _RET_IP_);
 	return error;
 }
@@ -1009,7 +1009,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1033,7 +1033,7 @@ xfs_rmap_convert(
 		goto done;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, PREV.rm_startblock,
+			cur->bc_ag.agno, PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -1075,7 +1075,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, LEFT.rm_startblock,
+				cur->bc_ag.agno, LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -1113,7 +1113,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				cur->bc_ag.agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -1131,7 +1131,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
@@ -1161,7 +1161,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1179,7 +1179,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1209,7 +1209,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1246,7 +1246,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1325,7 +1325,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1382,7 +1382,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1413,7 +1413,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1440,7 +1440,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1464,12 +1464,12 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1505,7 +1505,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1572,7 +1572,7 @@ xfs_rmap_convert_shared(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				cur->bc_ag.agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1588,7 +1588,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
 			_RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1879,12 +1879,12 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1922,7 +1922,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -2071,12 +2071,12 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -2111,7 +2111,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -2137,7 +2137,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			cur->bc_ag.agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -2230,12 +2230,12 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				cur->bc_ag.agno, error, _RET_IP_);
 	return error;
 }
 
@@ -2335,7 +2335,7 @@ xfs_rmap_finish_one_cleanup(
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_private.a.agbp;
+	agbp = rcur->bc_ag.agbp;
 	xfs_btree_del_cursor(rcur, error);
 	if (error)
 		xfs_trans_brelse(tp, agbp);
@@ -2385,7 +2385,7 @@ xfs_rmap_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
+	if (rcur != NULL && rcur->bc_ag.agno != agno) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 87503247..7d91619e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -49,7 +49,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+			cur->bc_ag.agbp, cur->bc_ag.agno);
 }
 
 STATIC void
@@ -58,7 +58,7 @@ xfs_rmapbt_set_root(
 	union xfs_btree_ptr	*ptr,
 	int			inc)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
@@ -81,25 +81,25 @@ xfs_rmapbt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	int			error;
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_ag.agbp,
 				       &bno, 1);
 	if (error)
 		return error;
 
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
 			bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1,
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1,
 			false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
@@ -107,7 +107,7 @@ xfs_rmapbt_alloc_block(
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 
-	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_private.a.agno);
+	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_ag.agno);
 
 	*stat = 1;
 	return 0;
@@ -118,13 +118,13 @@ xfs_rmapbt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_ag.agno,
 			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
@@ -136,7 +136,7 @@ xfs_rmapbt_free_block(
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 
-	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_private.a.agno);
+	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_ag.agno);
 
 	return 0;
 }
@@ -213,9 +213,9 @@ xfs_rmapbt_init_ptr_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr)
 {
-	struct xfs_agf		*agf = cur->bc_private.a.agbp->b_addr;
+	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
@@ -470,8 +470,8 @@ xfs_rmapbt_init_cursor(
 	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
-	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
+	cur->bc_ag.agbp = agbp;
+	cur->bc_ag.agno = agno;
 
 	return cur;
 }
-- 
2.26.2

