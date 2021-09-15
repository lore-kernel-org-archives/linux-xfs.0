Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4907C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9712D610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhIOXLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhIOXLF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213D4600D4;
        Wed, 15 Sep 2021 23:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747386;
        bh=tUgNtjwH0r/tipa0kfAkbvP5A2VPNaNcxcy+BwVAwxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t9TsGCBTb64r75Y/IumjhbbPgVCitPwMtwhUOZVOF8CeSrn2hCPVYZC7JfkobS8eE
         U9pphXrnoBXpDBimqPPx9rNGpexUPJnAnbXpZ0Vzq+D9npYvwrWrN8aQ37lO+Eau30
         1XYXyRdPCB2nUr1w0Z3oJjB6ZGpEGcpmtUXnW9gpQOawN0Mz/UpEaANDoWscqm/dSd
         bChcjpJlMHJ16qZOPINJY2e+yszV1/t3Ea5e+5O2jc75g3n2BZoTO+f/vG4sThXons
         Uh1f68BjIQKbJgGJXxUgmFNkqvaiHC/nHy6W1KZHRXUSATLNfP2B7KdEaGlHniZHZH
         qFqtzPAUVer4g==
Subject: [PATCH 35/61] xfs: use perag for ialloc btree cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:45 -0700
Message-ID: <163174738586.350433.8044536776400775876.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 7b13c515518264df0cb90d84fdab907a627c0fa9

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c       |  177 +++++++++++++++++++++++----------------------
 libxfs/xfs_ialloc_btree.c |   27 +++----
 libxfs/xfs_ialloc_btree.h |    6 +-
 repair/agbtree.c          |    7 +-
 repair/agbtree.h          |    2 -
 repair/phase5.c           |    2 -
 6 files changed, 109 insertions(+), 112 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5d61be05..830001f9 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -167,18 +167,17 @@ xfs_inobt_insert(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag,
 	xfs_agino_t		newino,
 	xfs_agino_t		newlen,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_agi		*agi = agbp->b_addr;
-	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agino_t		thisino;
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, btnum);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -515,18 +514,17 @@ xfs_inobt_insert_sprec(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
+	struct xfs_perag		*pag,
 	int				btnum,
 	struct xfs_inobt_rec_incore	*nrec,	/* in/out: new/merged rec. */
 	bool				merge)	/* merge or replace */
 {
 	struct xfs_btree_cur		*cur;
-	struct xfs_agi			*agi = agbp->b_addr;
-	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	int				error;
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, btnum);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -573,14 +571,14 @@ xfs_inobt_insert_sprec(
 			goto error;
 		}
 
-		trace_xfs_irec_merge_pre(mp, agno, rec.ir_startino,
+		trace_xfs_irec_merge_pre(mp, pag->pag_agno, rec.ir_startino,
 					 rec.ir_holemask, nrec->ir_startino,
 					 nrec->ir_holemask);
 
 		/* merge to nrec to output the updated record */
 		__xfs_inobt_rec_merge(nrec, &rec);
 
-		trace_xfs_irec_merge_post(mp, agno, nrec->ir_startino,
+		trace_xfs_irec_merge_post(mp, pag->pag_agno, nrec->ir_startino,
 					  nrec->ir_holemask);
 
 		error = xfs_inobt_rec_check_count(mp, nrec);
@@ -608,21 +606,20 @@ xfs_inobt_insert_sprec(
 STATIC int
 xfs_ialloc_ag_alloc(
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp)
+	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag)
 {
 	struct xfs_agi		*agi;
 	struct xfs_alloc_arg	args;
-	xfs_agnumber_t		agno;
 	int			error;
 	xfs_agino_t		newino;		/* new first inode's number */
 	xfs_agino_t		newlen;		/* new number of inodes */
 	int			isaligned = 0;	/* inode allocation at stripe */
 						/* unit boundary */
 	/* init. to full chunk */
-	uint16_t		allocmask = (uint16_t) -1;
 	struct xfs_inobt_rec_incore rec;
-	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(tp->t_mountp);
+	uint16_t		allocmask = (uint16_t) -1;
 	int			do_sparse = 0;
 
 	memset(&args, 0, sizeof(args));
@@ -655,14 +652,13 @@ xfs_ialloc_ag_alloc(
 	 */
 	agi = agbp->b_addr;
 	newino = be32_to_cpu(agi->agi_newino);
-	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 		     igeo->ialloc_blks;
 	if (do_sparse)
 		goto sparse_alloc;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
 		args.prod = 1;
 
@@ -722,7 +718,7 @@ xfs_ialloc_ag_alloc(
 		 * For now, just allocate blocks up front.
 		 */
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
@@ -743,7 +739,7 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = igeo->cluster_align;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
@@ -759,7 +755,7 @@ xfs_ialloc_ag_alloc(
 sparse_alloc:
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
@@ -804,7 +800,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, agno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag->pag_agno,
 			args.agbno, args.len, prandom_u32());
 
 	if (error)
@@ -831,12 +827,12 @@ xfs_ialloc_ag_alloc(
 		 * if necessary. If a merge does occur, rec is updated to the
 		 * merged record.
 		 */
-		error = xfs_inobt_insert_sprec(args.mp, tp, agbp, XFS_BTNUM_INO,
-					       &rec, true);
+		error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+				XFS_BTNUM_INO, &rec, true);
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
 	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
-				  XFS_AGINO_TO_INO(args.mp, agno,
+				  XFS_AGINO_TO_INO(args.mp, pag->pag_agno,
 						   rec.ir_startino),
 				  rec.ir_holemask, rec.ir_count);
 			xfs_force_shutdown(args.mp, SHUTDOWN_CORRUPT_INCORE);
@@ -856,21 +852,20 @@ xfs_ialloc_ag_alloc(
 		 * existing record with this one.
 		 */
 		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
-			error = xfs_inobt_insert_sprec(args.mp, tp, agbp,
-						       XFS_BTNUM_FINO, &rec,
-						       false);
+			error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+				       XFS_BTNUM_FINO, &rec, false);
 			if (error)
 				return error;
 		}
 	} else {
 		/* full chunk - insert new records to both btrees */
-		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
+		error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino, newlen,
 					 XFS_BTNUM_INO);
 		if (error)
 			return error;
 
 		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
-			error = xfs_inobt_insert(args.mp, tp, agbp, newino,
+			error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino,
 						 newlen, XFS_BTNUM_FINO);
 			if (error)
 				return error;
@@ -882,7 +877,6 @@ xfs_ialloc_ag_alloc(
 	 */
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	pag = agbp->b_pag;
 	pag->pagi_freecount += newlen;
 	pag->pagi_count += newlen;
 	agi->agi_newino = cpu_to_be32(newino);
@@ -1118,15 +1112,14 @@ STATIC int
 xfs_dialloc_ag_inobt(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agbp->b_addr;
-	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
-	struct xfs_perag	*pag = agbp->b_pag;
 	struct xfs_btree_cur	*cur, *tcur;
 	struct xfs_inobt_rec_incore rec, trec;
 	xfs_ino_t		ino;
@@ -1140,7 +1133,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1155,7 +1148,7 @@ xfs_dialloc_ag_inobt(
 	/*
 	 * If in the same AG as the parent, try to get near the parent.
 	 */
-	if (pagno == agno) {
+	if (pagno == pag->pag_agno) {
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
 
@@ -1358,7 +1351,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 	error = xfs_inobt_update(cur, &rec);
@@ -1572,7 +1565,6 @@ xfs_dialloc_ag(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_agi			*agi = agbp->b_addr;
-	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
 	struct xfs_btree_cur		*cur;	/* finobt cursor */
@@ -1582,9 +1574,10 @@ xfs_dialloc_ag(
 	int				error;
 	int				offset;
 	int				i;
+	struct xfs_perag		*pag = agbp->b_pag;
 
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
-		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
+		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
 
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
@@ -1593,7 +1586,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1604,7 +1597,7 @@ xfs_dialloc_ag(
 	 * parent. If so, find the closest available inode to the parent. If
 	 * not, consider the agi hint or find the first free inode in the AG.
 	 */
-	if (agno == pagno)
+	if (pag->pag_agno == pagno)
 		error = xfs_dialloc_ag_finobt_near(pagino, &cur, &rec);
 	else
 		error = xfs_dialloc_ag_finobt_newino(agi, cur, &rec);
@@ -1616,7 +1609,7 @@ xfs_dialloc_ag(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
 
 	/*
 	 * Modify or remove the finobt record.
@@ -1636,7 +1629,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(icur, agi);
 	if (error)
@@ -1652,7 +1645,7 @@ xfs_dialloc_ag(
 	 */
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-	agbp->b_pag->pagi_freecount--;
+	pag->pagi_freecount--;
 
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 
@@ -1804,7 +1797,7 @@ xfs_dialloc_select_ag(
 		if (!okalloc)
 			goto nextag_relse_buffer;
 
-		error = xfs_ialloc_ag_alloc(*tpp, agbp);
+		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
 		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
 
@@ -1930,12 +1923,12 @@ xfs_difree_inobt(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
+	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
 	struct xfs_agi			*agi = agbp->b_addr;
-	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				ilen;
@@ -1949,7 +1942,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -2000,7 +1993,8 @@ xfs_difree_inobt(
 		struct xfs_perag	*pag = agbp->b_pag;
 
 		xic->deleted = true;
-		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
+		xic->first_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
+				rec.ir_startino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
 
 		/*
@@ -2023,7 +2017,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(tp, agno, &rec);
+		xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
 	} else {
 		xic->deleted = false;
 
@@ -2039,7 +2033,7 @@ xfs_difree_inobt(
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-		agbp->b_pag->pagi_freecount++;
+		pag->pagi_freecount++;
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
@@ -2064,18 +2058,18 @@ xfs_difree_finobt(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
+	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
 	struct xfs_agi			*agi = agbp->b_addr;
-	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2183,16 +2177,15 @@ xfs_difree(
 	xfs_agino_t		agino;	/* allocation group inode number */
 	xfs_agnumber_t		agno;	/* allocation group number */
 	int			error;	/* error return value */
-	struct xfs_mount	*mp;	/* mount structure for filesystem */
+	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inobt_rec_incore rec;/* btree record */
-
-	mp = tp->t_mountp;
+	struct xfs_perag	*pag;
 
 	/*
 	 * Break up inode number into its components.
 	 */
 	agno = XFS_INO_TO_AGNO(mp, inode);
-	if (agno >= mp->m_sb.sb_agcount)  {
+	if (agno >= mp->m_sb.sb_agcount) {
 		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
 			__func__, agno, mp->m_sb.sb_agcount);
 		ASSERT(0);
@@ -2226,7 +2219,8 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, agino, xic, &rec);
+	pag = agbp->b_pag;
+	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
 	if (error)
 		goto error0;
 
@@ -2234,7 +2228,7 @@ xfs_difree(
 	 * Fix up the free inode btree.
 	 */
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		error = xfs_difree_finobt(mp, tp, agbp, agino, &rec);
+		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
 		if (error)
 			goto error0;
 	}
@@ -2249,7 +2243,7 @@ STATIC int
 xfs_imap_lookup(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agino_t		agino,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		*chunk_agbno,
@@ -2262,11 +2256,11 @@ xfs_imap_lookup(
 	int			error;
 	int			i;
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
-			__func__, error, agno);
+			__func__, error, pag->pag_agno);
 		return error;
 	}
 
@@ -2276,7 +2270,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
@@ -2310,42 +2304,44 @@ xfs_imap_lookup(
  */
 int
 xfs_imap(
-	xfs_mount_t	 *mp,	/* file system mount structure */
-	xfs_trans_t	 *tp,	/* transaction pointer */
-	xfs_ino_t	ino,	/* inode to locate */
-	struct xfs_imap	*imap,	/* location map structure */
-	uint		flags)	/* flags for inode btree lookup */
+	struct xfs_mount	 *mp,	/* file system mount structure */
+	struct xfs_trans	 *tp,	/* transaction pointer */
+	xfs_ino_t		ino,	/* inode to locate */
+	struct xfs_imap		*imap,	/* location map structure */
+	uint			flags)	/* flags for inode btree lookup */
 {
-	xfs_agblock_t	agbno;	/* block number of inode in the alloc group */
-	xfs_agino_t	agino;	/* inode number within alloc group */
-	xfs_agnumber_t	agno;	/* allocation group number */
-	xfs_agblock_t	chunk_agbno;	/* first block in inode chunk */
-	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
-	int		error;	/* error code */
-	int		offset;	/* index of inode in its buffer */
-	xfs_agblock_t	offset_agbno;	/* blks from chunk start to inode */
+	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
+	xfs_agino_t		agino;	/* inode number within alloc group */
+	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
+	xfs_agblock_t		cluster_agbno;	/* first block in inode cluster */
+	int			error;	/* error code */
+	int			offset;	/* index of inode in its buffer */
+	xfs_agblock_t		offset_agbno;	/* blks from chunk start to inode */
+	struct xfs_perag	*pag;
 
 	ASSERT(ino != NULLFSINO);
 
 	/*
 	 * Split up the inode number into its parts.
 	 */
-	agno = XFS_INO_TO_AGNO(mp, ino);
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
-	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+	if (!pag || agbno >= mp->m_sb.sb_agblocks ||
+	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+		error = -EINVAL;
 #ifdef DEBUG
 		/*
 		 * Don't output diagnostic information for untrusted inodes
 		 * as they can be invalid without implying corruption.
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
-			return -EINVAL;
-		if (agno >= mp->m_sb.sb_agcount) {
+			goto out_drop;
+		if (!pag) {
 			xfs_alert(mp,
 				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
-				__func__, agno, mp->m_sb.sb_agcount);
+				__func__, XFS_INO_TO_AGNO(mp, ino),
+				mp->m_sb.sb_agcount);
 		}
 		if (agbno >= mp->m_sb.sb_agblocks) {
 			xfs_alert(mp,
@@ -2353,15 +2349,15 @@ xfs_imap(
 				__func__, (unsigned long long)agbno,
 				(unsigned long)mp->m_sb.sb_agblocks);
 		}
-		if (ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+		if (pag && ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 			xfs_alert(mp,
 		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
 				__func__, ino,
-				XFS_AGINO_TO_INO(mp, agno, agino));
+				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
-		return -EINVAL;
+		goto out_drop;
 	}
 
 	/*
@@ -2372,10 +2368,10 @@ xfs_imap(
 	 * in all cases where an untrusted inode number is passed.
 	 */
 	if (flags & XFS_IGET_UNTRUSTED) {
-		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			return error;
+			goto out_drop;
 		goto out_map;
 	}
 
@@ -2387,11 +2383,12 @@ xfs_imap(
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
-		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
 		imap->im_boffset = (unsigned short)(offset <<
 							mp->m_sb.sb_inodelog);
-		return 0;
+		error = 0;
+		goto out_drop;
 	}
 
 	/*
@@ -2403,10 +2400,10 @@ xfs_imap(
 		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 	} else {
-		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
+		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
-			return error;
+			goto out_drop;
 	}
 
 out_map:
@@ -2417,7 +2414,7 @@ xfs_imap(
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
 
-	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
+	imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
@@ -2434,9 +2431,13 @@ xfs_imap(
 			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return -EINVAL;
+		error = -EINVAL;
+		goto out_drop;
 	}
-	return 0;
+	error = 0;
+out_drop:
+	xfs_perag_put(pag);
+	return error;
 }
 
 /*
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 9b971453..c8a96369 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -34,8 +34,7 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno,
-			cur->bc_ag.pag, cur->bc_btnum);
+			cur->bc_ag.agbp, cur->bc_ag.pag, cur->bc_btnum);
 }
 
 STATIC void
@@ -427,7 +426,6 @@ static struct xfs_btree_cur *
 xfs_inobt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_agnumber_t		agno,		/* allocation group number */
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
@@ -450,12 +448,10 @@ xfs_inobt_init_common(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.agno = agno;
-	if (pag) {
-		/* take a reference for the cursor */
-		atomic_inc(&pag->pag_ref);
-	}
+	/* take a reference for the cursor */
+	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
+	cur->bc_ag.agno = pag->pag_agno;
 	return cur;
 }
 
@@ -465,14 +461,13 @@ xfs_inobt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno,
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = agbp->b_addr;
 
-	cur = xfs_inobt_init_common(mp, tp, agno, pag, btnum);
+	cur = xfs_inobt_init_common(mp, tp, pag, btnum);
 	if (btnum == XFS_BTNUM_INO)
 		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
 	else
@@ -486,12 +481,12 @@ struct xfs_btree_cur *
 xfs_inobt_stage_cursor(
 	struct xfs_mount	*mp,
 	struct xbtree_afakeroot	*afake,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(mp, NULL, agno, NULL, btnum);
+	cur = xfs_inobt_init_common(mp, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
@@ -663,7 +658,7 @@ int
 xfs_inobt_cur(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		which,
 	struct xfs_btree_cur	**curpp,
 	struct xfs_buf		**agi_bpp)
@@ -674,11 +669,11 @@ xfs_inobt_cur(
 	ASSERT(*agi_bpp == NULL);
 	ASSERT(*curpp == NULL);
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, agi_bpp);
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, NULL, which);
+	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, pag, which);
 	*curpp = cur;
 	return 0;
 }
@@ -695,7 +690,7 @@ xfs_inobt_count_blocks(
 	struct xfs_btree_cur	*cur = NULL;
 	int			error;
 
-	error = xfs_inobt_cur(mp, tp, pag->pag_agno, btnum, &cur, &agbp);
+	error = xfs_inobt_cur(mp, tp, pag, btnum, &cur, &agbp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 04dfa7ee..e530c82b 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -47,10 +47,10 @@ struct xfs_perag;
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *mp,
-		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
+		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag, xfs_btnum_t btnum);
 struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
@@ -69,7 +69,7 @@ int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_btnum_t btnum,
+		struct xfs_perag *pag, xfs_btnum_t btnum,
 		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
 
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 6c1ae375..be7831f9 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -438,7 +438,7 @@ get_inobt_record(
 void
 init_ino_cursors(
 	struct repair_ctx	*sc,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	unsigned int		free_space,
 	uint64_t		*num_inos,
 	uint64_t		*num_free_inos,
@@ -446,6 +446,7 @@ init_ino_cursors(
 	struct bt_rebuild	*btr_fino)
 {
 	struct ino_tree_node	*ino_rec;
+	xfs_agnumber_t		agno = pag->pag_agno;
 	unsigned int		ino_recs = 0;
 	unsigned int		fino_recs = 0;
 	bool			finobt;
@@ -487,7 +488,7 @@ init_ino_cursors(
 	}
 
 	btr_ino->cur = libxfs_inobt_stage_cursor(sc->mp, &btr_ino->newbt.afake,
-			agno, XFS_BTNUM_INO);
+			pag, XFS_BTNUM_INO);
 
 	btr_ino->bload.get_record = get_inobt_record;
 	btr_ino->bload.claim_block = rebuild_claim_block;
@@ -507,7 +508,7 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_fino);
 	btr_fino->cur = libxfs_inobt_stage_cursor(sc->mp,
-			&btr_fino->newbt.afake, agno, XFS_BTNUM_FINO);
+			&btr_fino->newbt.afake, pag, XFS_BTNUM_FINO);
 
 	btr_fino->bload.get_record = get_inobt_record;
 	btr_fino->bload.claim_block = rebuild_claim_block;
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 593ac44c..84f7083d 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -42,7 +42,7 @@ void init_freespace_cursors(struct repair_ctx *sc, struct xfs_perag *pag,
 void build_freespace_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr_bno, struct bt_rebuild *btr_cnt);
 
-void init_ino_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
+void init_ino_cursors(struct repair_ctx *sc, struct xfs_perag *pag,
 		unsigned int free_space, uint64_t *num_inos,
 		uint64_t *num_free_inos, struct bt_rebuild *btr_ino,
 		struct bt_rebuild *btr_fino);
diff --git a/repair/phase5.c b/repair/phase5.c
index 26094238..79a8dbc2 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -474,7 +474,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 			agno);
 	}
 
-	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
+	init_ino_cursors(&sc, pag, num_freeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
 	init_rmapbt_cursor(&sc, pag, num_freeblocks, &btr_rmap);

