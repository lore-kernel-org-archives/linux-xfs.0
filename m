Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA73C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKICHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00C268687
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB5161808
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67EEC433C1;
        Wed,  9 Nov 2022 02:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959626;
        bh=Y7RBzALXikoH3Q6b+Z+F4HjC7yU5G8xloiq2poNWUTU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LbS1QKKo70cctXr+mD8+vlRw2QxO6nsEmzYZvxPk2X43iDrhfT7eqZEPGxYBJ3yzm
         Qhjt32ovzN5Chz2CZKDHrztuH6AqIHSvHdStXK7hBqbpvAM1858f8uDw033WfxFJ+J
         8ep+xZZekyQAfyHLUkDLusxYIN77N0kecnsxzuj7wT/D5cF1Gsj9TBwJNpq7LKHYFj
         1oNJr2KN/UOZl4RarGrSCVs9XOCHmOH371tgHJUl3ydE+qDc0xfFvZveOkK31RlRm6
         meOdqFfwi47u/tIRpUMzy7V8h43qeqssRKHI2e0fae/kT5tK1BV5Ilbema5JAWaq0j
         xN6nDfY4gTt1A==
Subject: [PATCH 15/24] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:06 -0800
Message-ID: <166795962631.3761583.16845808206856458930.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 0c1c2c41f40453ff9fa24cbbd3d3784dff67fe81

Just prior to committing the reflink code into upstream, the xfs
maintainer at the time requested that I find a way to shard the refcount
records into two domains -- one for records tracking shared extents, and
a second for tracking CoW staging extents.  The idea here was to
minimize mount time CoW reclamation by pushing all the CoW records to
the right edge of the keyspace, and it was accomplished by setting the
upper bit in rc_startblock.  We don't allow AGs to have more than 2^31
blocks, so the bit was free.

Unfortunately, this was a very late addition to the codebase, so most of
the refcount record processing code still treats rc_startblock as a u32
and pays no attention to whether or not the upper bit (the cow flag) is
set.  This is a weakness is theoretically exploitable, since we're not
fully validating the incoming metadata records.

Fuzzing demonstrates practical exploits of this weakness.  If the cow
flag of a node block key record is corrupted, a lookup operation can go
to the wrong record block and start returning records from the wrong
cow/shared domain.  This causes the math to go all wrong (since cow
domain is still implicit in the upper bit of rc_startblock) and we can
crash the kernel by tricking xfs into jumping into a nonexistent AG and
tripping over xfs_perag_get(mp, <nonexistent AG>) returning NULL.

To fix this, start tracking the domain as an explicit part of struct
xfs_refcount_irec, adjust all refcount functions to check the domain
of a returned record, and alter the function definitions to accept them
where necessary.

Found by fuzzing keys[2].cowflag = add in xfs/464.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c       |  146 +++++++++++++++++++++++++++++--------------
 libxfs/xfs_refcount.h       |   28 +++++++-
 libxfs/xfs_refcount_btree.c |   15 ++++
 libxfs/xfs_types.h          |    6 ++
 repair/rmap.c               |   18 ++++-
 5 files changed, 155 insertions(+), 58 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 5ba8241998..7094a27dce 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -45,13 +45,16 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 int
 xfs_refcount_lookup_le(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
+	cur->bc_rec.rc.rc_domain = domain;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
@@ -62,13 +65,16 @@ xfs_refcount_lookup_le(
 int
 xfs_refcount_lookup_ge(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
+	cur->bc_rec.rc.rc_domain = domain;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
@@ -79,13 +85,16 @@ xfs_refcount_lookup_ge(
 int
 xfs_refcount_lookup_eq(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
+	cur->bc_rec.rc.rc_domain = domain;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
 }
 
@@ -95,7 +104,17 @@ xfs_refcount_btrec_to_irec(
 	const union xfs_btree_rec	*rec,
 	struct xfs_refcount_irec	*irec)
 {
-	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+	uint32_t			start;
+
+	start = be32_to_cpu(rec->refc.rc_startblock);
+	if (start & XFS_REFC_COW_START) {
+		start &= ~XFS_REFC_COW_START;
+		irec->rc_domain = XFS_REFC_DOMAIN_COW;
+	} else {
+		irec->rc_domain = XFS_REFC_DOMAIN_SHARED;
+	}
+
+	irec->rc_startblock = start;
 	irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
 	irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
 }
@@ -113,7 +132,6 @@ xfs_refcount_get_rec(
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 	union xfs_btree_rec		*rec;
 	int				error;
-	xfs_agblock_t			realstart;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
@@ -123,18 +141,14 @@ xfs_refcount_get_rec(
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
-	/* handle special COW-staging state */
-	realstart = irec->rc_startblock;
-	if (realstart & XFS_REFC_COW_START) {
-		if (irec->rc_refcount != 1)
-			goto out_bad_rec;
-		realstart &= ~XFS_REFC_COW_START;
-	} else if (irec->rc_refcount < 2) {
+	/* handle special COW-staging domain */
+	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
+		goto out_bad_rec;
+	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
 		goto out_bad_rec;
-	}
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbext(pag, realstart, irec->rc_blockcount))
+	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		goto out_bad_rec;
 
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
@@ -164,12 +178,17 @@ xfs_refcount_update(
 	struct xfs_refcount_irec	*irec)
 {
 	union xfs_btree_rec	rec;
+	uint32_t		start;
 	int			error;
 
 	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
-	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
+
+	start = xfs_refcount_encode_startblock(irec->rc_startblock,
+			irec->rc_domain);
+	rec.refc.rc_startblock = cpu_to_be32(start);
 	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
 	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
+
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_refcount_update_error(cur->bc_mp,
@@ -191,9 +210,12 @@ xfs_refcount_insert(
 	int				error;
 
 	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
+	cur->bc_rec.rc.rc_domain = irec->rc_domain;
+
 	error = xfs_btree_insert(cur, i);
 	if (error)
 		goto out_error;
@@ -239,7 +261,8 @@ xfs_refcount_delete(
 	}
 	if (error)
 		goto out_error;
-	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
+			&found_rec);
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
@@ -338,6 +361,7 @@ xfs_refc_next(
 STATIC int
 xfs_refcount_split_extent(
 	struct xfs_btree_cur		*cur,
+	enum xfs_refc_domain		domain,
 	xfs_agblock_t			agbno,
 	bool				*shape_changed)
 {
@@ -346,7 +370,7 @@ xfs_refcount_split_extent(
 	int				error;
 
 	*shape_changed = false;
-	error = xfs_refcount_lookup_le(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -418,8 +442,8 @@ xfs_refcount_merge_center_extents(
 	 * call removes the center and the second one removes the right
 	 * extent.
 	 */
-	error = xfs_refcount_lookup_ge(cur, center->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_ge(cur, center->rc_domain,
+			center->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -446,8 +470,8 @@ xfs_refcount_merge_center_extents(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -488,8 +512,8 @@ xfs_refcount_merge_left_extent(
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
-		error = xfs_refcount_lookup_le(cur, cleft->rc_startblock,
-				&found_rec);
+		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
+				cleft->rc_startblock, &found_rec);
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -507,8 +531,8 @@ xfs_refcount_merge_left_extent(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -552,8 +576,8 @@ xfs_refcount_merge_right_extent(
 	 * remove it.
 	 */
 	if (cright->rc_refcount > 1) {
-		error = xfs_refcount_lookup_le(cur, cright->rc_startblock,
-			&found_rec);
+		error = xfs_refcount_lookup_le(cur, cright->rc_domain,
+				cright->rc_startblock, &found_rec);
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -571,8 +595,8 @@ xfs_refcount_merge_right_extent(
 	}
 
 	/* Enlarge the right extent. */
-	error = xfs_refcount_lookup_le(cur, right->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, right->rc_domain,
+			right->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -611,11 +635,17 @@ xfs_refcount_find_left_extents(
 	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
+	enum xfs_refc_domain		domain;
 	int				error;
 	int				found_rec;
 
+	if (flags & XFS_FIND_RCEXT_SHARED)
+		domain = XFS_REFC_DOMAIN_SHARED;
+	else
+		domain = XFS_REFC_DOMAIN_COW;
+
 	left->rc_startblock = cleft->rc_startblock = NULLAGBLOCK;
-	error = xfs_refcount_lookup_le(cur, agbno - 1, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno - 1, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -666,6 +696,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_blockcount = min(aglen,
 					tmp.rc_startblock - agbno);
 			cleft->rc_refcount = 1;
+			cleft->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -675,6 +706,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_startblock = agbno;
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
+		cleft->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			left, cleft, agbno);
@@ -700,11 +732,17 @@ xfs_refcount_find_right_extents(
 	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
+	enum xfs_refc_domain		domain;
 	int				error;
 	int				found_rec;
 
+	if (flags & XFS_FIND_RCEXT_SHARED)
+		domain = XFS_REFC_DOMAIN_SHARED;
+	else
+		domain = XFS_REFC_DOMAIN_COW;
+
 	right->rc_startblock = cright->rc_startblock = NULLAGBLOCK;
-	error = xfs_refcount_lookup_ge(cur, agbno + aglen, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, domain, agbno + aglen, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -755,6 +793,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_blockcount = right->rc_startblock -
 					cright->rc_startblock;
 			cright->rc_refcount = 1;
+			cright->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -764,6 +803,7 @@ xfs_refcount_find_right_extents(
 		cright->rc_startblock = agbno;
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
+		cright->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			cright, right, agbno + aglen);
@@ -928,7 +968,8 @@ xfs_refcount_adjust_extents(
 	if (*aglen == 0)
 		return 0;
 
-	error = xfs_refcount_lookup_ge(cur, *agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_REFC_DOMAIN_SHARED, *agbno,
+			&found_rec);
 	if (error)
 		goto out_error;
 
@@ -940,6 +981,7 @@ xfs_refcount_adjust_extents(
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
+			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
 		}
 
 		/*
@@ -952,6 +994,8 @@ xfs_refcount_adjust_extents(
 			tmp.rc_blockcount = min(*aglen,
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
+			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -986,7 +1030,8 @@ xfs_refcount_adjust_extents(
 				break;
 
 			/* Move the cursor to the start of ext. */
-			error = xfs_refcount_lookup_ge(cur, *agbno,
+			error = xfs_refcount_lookup_ge(cur,
+					XFS_REFC_DOMAIN_SHARED, *agbno,
 					&found_rec);
 			if (error)
 				goto out_error;
@@ -1079,13 +1124,15 @@ xfs_refcount_adjust(
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
 	 */
-	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_SHARED,
+			agbno, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
 		shape_changes++;
 
-	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_SHARED,
+			agbno + aglen, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1350,7 +1397,8 @@ xfs_refcount_find_shared(
 	*flen = 0;
 
 	/* Try to find a refcount extent that crosses the start */
-	error = xfs_refcount_lookup_le(cur, agbno, &have);
+	error = xfs_refcount_lookup_le(cur, XFS_REFC_DOMAIN_SHARED, agbno,
+			&have);
 	if (error)
 		goto out_error;
 	if (!have) {
@@ -1498,17 +1546,18 @@ xfs_refcount_adjust_cow_extents(
 		return 0;
 
 	/* Find any overlapping refcount records */
-	error = xfs_refcount_lookup_ge(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_REFC_DOMAIN_COW, agbno,
+			&found_rec);
 	if (error)
 		goto out_error;
 	error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks +
-				XFS_REFC_COW_START;
+		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
+		ext.rc_domain = XFS_REFC_DOMAIN_COW;
 	}
 
 	switch (adj) {
@@ -1523,6 +1572,8 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_startblock = agbno;
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
+		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
+
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -1585,16 +1636,16 @@ xfs_refcount_adjust_cow(
 	bool			shape_changed;
 	int			error;
 
-	agbno += XFS_REFC_COW_START;
-
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
 	 */
-	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_COW,
+			agbno, &shape_changed);
 	if (error)
 		goto out_error;
 
-	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_COW,
+			agbno + aglen, &shape_changed);
 	if (error)
 		goto out_error;
 
@@ -1730,7 +1781,6 @@ xfs_refcount_recover_cow_leftovers(
 	union xfs_btree_irec		low;
 	union xfs_btree_irec		high;
 	xfs_fsblock_t			fsb;
-	xfs_agblock_t			agbno;
 	int				error;
 
 	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
@@ -1760,7 +1810,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
 	memset(&high, 0, sizeof(high));
-	low.rc.rc_startblock = XFS_REFC_COW_START;
+	low.rc.rc_domain = high.rc.rc_domain = XFS_REFC_DOMAIN_COW;
 	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
@@ -1781,8 +1831,8 @@ xfs_refcount_recover_cow_leftovers(
 				&rr->rr_rrec);
 
 		/* Free the orphan record */
-		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
+		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
+				rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
@@ -1813,6 +1863,7 @@ xfs_refcount_recover_cow_leftovers(
 int
 xfs_refcount_has_record(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	bool			*exists)
@@ -1824,6 +1875,7 @@ xfs_refcount_has_record(
 	low.rc.rc_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
+	low.rc.rc_domain = high.rc.rc_domain = domain;
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index e8b322de7f..3beb5a30a9 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -14,14 +14,33 @@ struct xfs_bmbt_irec;
 struct xfs_refcount_irec;
 
 extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_refc_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_refc_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_eq(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_refc_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+static inline uint32_t
+xfs_refcount_encode_startblock(
+	xfs_agblock_t		startblock,
+	enum xfs_refc_domain	domain)
+{
+	uint32_t		start;
+
+	/*
+	 * low level btree operations need to handle the generic btree range
+	 * query functions (which set rc_domain == -1U), so we check that the
+	 * domain is /not/ shared.
+	 */
+	start = startblock & ~XFS_REFC_COW_START;
+	if (domain != XFS_REFC_DOMAIN_SHARED)
+		start |= XFS_REFC_COW_START;
+
+	return start;
+}
+
 enum xfs_refcount_intent_type {
 	XFS_REFCOUNT_INCREASE = 1,
 	XFS_REFCOUNT_DECREASE,
@@ -79,7 +98,8 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 #define XFS_REFCOUNT_ITEM_OVERHEAD	32
 
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+		enum xfs_refc_domain domain, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 0707cbc024..983d4276d1 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -13,6 +13,7 @@
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
@@ -159,7 +160,12 @@ xfs_refcountbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
 {
-	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
+	const struct xfs_refcount_irec *irec = &cur->bc_rec.rc;
+	uint32_t		start;
+
+	start = xfs_refcount_encode_startblock(irec->rc_startblock,
+			irec->rc_domain);
+	rec->refc.rc_startblock = cpu_to_be32(start);
 	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
 	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
 }
@@ -181,10 +187,13 @@ xfs_refcountbt_key_diff(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
 	const struct xfs_refcount_key	*kp = &key->refc;
+	const struct xfs_refcount_irec	*irec = &cur->bc_rec.rc;
+	uint32_t			start;
 
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
+	start = xfs_refcount_encode_startblock(irec->rc_startblock,
+			irec->rc_domain);
+	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
 STATIC int64_t
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 2d9ebc7338..eb9a98338b 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -166,10 +166,16 @@ typedef struct xfs_bmbt_irec
 	xfs_exntst_t	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
+enum xfs_refc_domain {
+	XFS_REFC_DOMAIN_SHARED = 0,
+	XFS_REFC_DOMAIN_COW,
+};
+
 struct xfs_refcount_irec {
 	xfs_agblock_t	rc_startblock;	/* starting block number */
 	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
 	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+	enum xfs_refc_domain	rc_domain; /* shared or cow staging extent? */
 };
 
 #define XFS_RMAP_ATTR_FORK		(1 << 0)
diff --git a/repair/rmap.c b/repair/rmap.c
index a7c4b25b1f..2c809fd4f2 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -734,6 +734,8 @@ refcount_emit(
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
 	rlrec.rc_refcount = REFCOUNT_CLAMP(nr_rmaps);
+	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
 	error = slab_add(rlslab, &rlrec);
 	if (error)
 		do_error(
@@ -1393,7 +1395,8 @@ check_refcounts(
 	while (rl_rec) {
 		/* Look for a refcount record in the btree */
 		error = -libxfs_refcount_lookup_le(bt_cur,
-				rl_rec->rc_startblock, &have);
+				XFS_REFC_DOMAIN_SHARED, rl_rec->rc_startblock,
+				&have);
 		if (error) {
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
@@ -1424,14 +1427,21 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 		}
 
 		/* Compare each refcount observation against the btree's */
-		if (tmp.rc_startblock != rl_rec->rc_startblock ||
+		if (tmp.rc_domain != rl_rec->rc_domain ||
+		    tmp.rc_startblock != rl_rec->rc_startblock ||
 		    tmp.rc_blockcount != rl_rec->rc_blockcount ||
-		    tmp.rc_refcount != rl_rec->rc_refcount)
+		    tmp.rc_refcount != rl_rec->rc_refcount) {
+			unsigned int	start;
+
+			start = xfs_refcount_encode_startblock(
+					tmp.rc_startblock, tmp.rc_domain);
+
 			do_warn(
 _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) len %u nlinks %u\n"),
-				agno, tmp.rc_startblock, tmp.rc_blockcount,
+				agno, start, tmp.rc_blockcount,
 				tmp.rc_refcount, agno, rl_rec->rc_startblock,
 				rl_rec->rc_blockcount, rl_rec->rc_refcount);
+		}
 next_loop:
 		rl_rec = pop_slab_cursor(rl_cur);
 	}

