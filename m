Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28751ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJ3XmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5682A9FF0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D911260F95
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B86AC433D6;
        Sun, 30 Oct 2022 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173316;
        bh=cn5f4gek3HIwgTAsYYZqiBu7cMCEpI+wkFSr1F6aeE8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RTte3ShXbAutFrB/VMM5NENhyKkl1fz2EcOfC/d6sDfpVGKxu7MYl6T7VNuzHjIiS
         srzr8AQc8UTKCkksg0Dq2ZfJUON2i5wnPEKTLK1142F+LuE5vyfRBvi51bKNYY2aR4
         Z8/b5FgebBsG4W79rKd9Npmk0WeKTDlIf9oyT1WJLASze44gQ+lbp4gJCXTnKMKRd2
         j3uSpkQwoPjWehZeF2OUxRkBX4HeqnRXy+/TY/qid5I9wo2K+SbsAlGe3EJxT7LJij
         xdQw8WaGRAHJ9jRoeBIPh5EJrXNLMAV8Bh4tpwFcWTWDuQkeVCCtFET/Z6xTjhM4aw
         N61RgtBjVLl8w==
Subject: [PATCH 06/13] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:55 -0700
Message-ID: <166717331585.417886.9317355524407243436.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
 fs/xfs/libxfs/xfs_refcount.c       |  146 ++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_refcount.h       |   28 ++++++-
 fs/xfs/libxfs/xfs_refcount_btree.c |   15 +++-
 fs/xfs/libxfs/xfs_types.h          |    6 +
 fs/xfs/scrub/refcount.c            |   23 ++----
 5 files changed, 151 insertions(+), 67 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 542f749d0c6a..0f920eff34c4 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -46,13 +46,16 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
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
 
@@ -63,13 +66,16 @@ xfs_refcount_lookup_le(
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
 
@@ -80,13 +86,16 @@ xfs_refcount_lookup_ge(
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
 
@@ -96,7 +105,17 @@ xfs_refcount_btrec_to_irec(
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
@@ -114,7 +133,6 @@ xfs_refcount_get_rec(
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 	union xfs_btree_rec		*rec;
 	int				error;
-	xfs_agblock_t			realstart;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
@@ -124,18 +142,14 @@ xfs_refcount_get_rec(
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
@@ -165,12 +179,17 @@ xfs_refcount_update(
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
@@ -192,9 +211,12 @@ xfs_refcount_insert(
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
@@ -240,7 +262,8 @@ xfs_refcount_delete(
 	}
 	if (error)
 		goto out_error;
-	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
+			&found_rec);
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
@@ -339,6 +362,7 @@ xfs_refc_next(
 STATIC int
 xfs_refcount_split_extent(
 	struct xfs_btree_cur		*cur,
+	enum xfs_refc_domain		domain,
 	xfs_agblock_t			agbno,
 	bool				*shape_changed)
 {
@@ -347,7 +371,7 @@ xfs_refcount_split_extent(
 	int				error;
 
 	*shape_changed = false;
-	error = xfs_refcount_lookup_le(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -419,8 +443,8 @@ xfs_refcount_merge_center_extents(
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
@@ -447,8 +471,8 @@ xfs_refcount_merge_center_extents(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -489,8 +513,8 @@ xfs_refcount_merge_left_extent(
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
-		error = xfs_refcount_lookup_le(cur, cleft->rc_startblock,
-				&found_rec);
+		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
+				cleft->rc_startblock, &found_rec);
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -508,8 +532,8 @@ xfs_refcount_merge_left_extent(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -553,8 +577,8 @@ xfs_refcount_merge_right_extent(
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
@@ -572,8 +596,8 @@ xfs_refcount_merge_right_extent(
 	}
 
 	/* Enlarge the right extent. */
-	error = xfs_refcount_lookup_le(cur, right->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, right->rc_domain,
+			right->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -612,11 +636,17 @@ xfs_refcount_find_left_extents(
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
@@ -667,6 +697,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_blockcount = min(aglen,
 					tmp.rc_startblock - agbno);
 			cleft->rc_refcount = 1;
+			cleft->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -676,6 +707,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_startblock = agbno;
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
+		cleft->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			left, cleft, agbno);
@@ -701,11 +733,17 @@ xfs_refcount_find_right_extents(
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
@@ -756,6 +794,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_blockcount = right->rc_startblock -
 					cright->rc_startblock;
 			cright->rc_refcount = 1;
+			cright->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -765,6 +804,7 @@ xfs_refcount_find_right_extents(
 		cright->rc_startblock = agbno;
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
+		cright->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			cright, right, agbno + aglen);
@@ -929,7 +969,8 @@ xfs_refcount_adjust_extents(
 	if (*aglen == 0)
 		return 0;
 
-	error = xfs_refcount_lookup_ge(cur, *agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_REFC_DOMAIN_SHARED, *agbno,
+			&found_rec);
 	if (error)
 		goto out_error;
 
@@ -941,6 +982,7 @@ xfs_refcount_adjust_extents(
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
+			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
 		}
 
 		/*
@@ -953,6 +995,8 @@ xfs_refcount_adjust_extents(
 			tmp.rc_blockcount = min(*aglen,
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
+			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -987,7 +1031,8 @@ xfs_refcount_adjust_extents(
 				break;
 
 			/* Move the cursor to the start of ext. */
-			error = xfs_refcount_lookup_ge(cur, *agbno,
+			error = xfs_refcount_lookup_ge(cur,
+					XFS_REFC_DOMAIN_SHARED, *agbno,
 					&found_rec);
 			if (error)
 				goto out_error;
@@ -1080,13 +1125,15 @@ xfs_refcount_adjust(
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
@@ -1351,7 +1398,8 @@ xfs_refcount_find_shared(
 	*flen = 0;
 
 	/* Try to find a refcount extent that crosses the start */
-	error = xfs_refcount_lookup_le(cur, agbno, &have);
+	error = xfs_refcount_lookup_le(cur, XFS_REFC_DOMAIN_SHARED, agbno,
+			&have);
 	if (error)
 		goto out_error;
 	if (!have) {
@@ -1499,17 +1547,18 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1524,6 +1573,8 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_startblock = agbno;
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
+		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
+
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -1586,16 +1637,16 @@ xfs_refcount_adjust_cow(
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
 
@@ -1731,7 +1782,6 @@ xfs_refcount_recover_cow_leftovers(
 	union xfs_btree_irec		low;
 	union xfs_btree_irec		high;
 	xfs_fsblock_t			fsb;
-	xfs_agblock_t			agbno;
 	int				error;
 
 	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
@@ -1761,7 +1811,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
 	memset(&high, 0, sizeof(high));
-	low.rc.rc_startblock = XFS_REFC_COW_START;
+	low.rc.rc_domain = high.rc.rc_domain = XFS_REFC_DOMAIN_COW;
 	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
@@ -1782,8 +1832,8 @@ xfs_refcount_recover_cow_leftovers(
 				&rr->rr_rrec);
 
 		/* Free the orphan record */
-		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
+		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
+				rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
@@ -1814,6 +1864,7 @@ xfs_refcount_recover_cow_leftovers(
 int
 xfs_refcount_has_record(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	bool			*exists)
@@ -1825,6 +1876,7 @@ xfs_refcount_has_record(
 	low.rc.rc_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
+	low.rc.rc_domain = high.rc.rc_domain = domain;
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index e8b322de7f3d..3beb5a30a9c9 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 316c1ec0c3c2..e1f789866683 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -13,6 +13,7 @@
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
@@ -160,7 +161,12 @@ xfs_refcountbt_init_rec_from_cur(
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
@@ -182,10 +188,13 @@ xfs_refcountbt_key_diff(
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 2d9ebc7338b1..eb9a98338bb9 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 9e6b36ac8079..af5b796ec9ec 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -334,21 +334,19 @@ xchk_refcountbt_rec(
 	struct xfs_refcount_irec irec;
 	xfs_agblock_t		*cow_blocks = bs->private;
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
-	bool			has_cowflag;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
 
 	/* Only CoW records can have refcount == 1. */
-	has_cowflag = (irec.rc_startblock & XFS_REFC_COW_START);
-	if ((irec.rc_refcount == 1 && !has_cowflag) ||
-	    (irec.rc_refcount != 1 && has_cowflag))
+	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED && irec.rc_refcount == 1)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	if (has_cowflag)
+	if (irec.rc_domain == XFS_REFC_DOMAIN_COW) {
+		if (irec.rc_refcount != 1)
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		(*cow_blocks) += irec.rc_blockcount;
+	}
 
 	/* Check the extent. */
-	irec.rc_startblock &= ~XFS_REFC_COW_START;
-
 	if (!xfs_verify_agbext(pag, irec.rc_startblock, irec.rc_blockcount))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
@@ -419,7 +417,6 @@ xchk_xref_is_cow_staging(
 	xfs_extlen_t			len)
 {
 	struct xfs_refcount_irec	rc;
-	bool				has_cowflag;
 	int				has_refcount;
 	int				error;
 
@@ -427,8 +424,8 @@ xchk_xref_is_cow_staging(
 		return;
 
 	/* Find the CoW staging extent. */
-	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
-			agbno + XFS_REFC_COW_START, &has_refcount);
+	error = xfs_refcount_lookup_le(sc->sa.refc_cur, XFS_REFC_DOMAIN_COW,
+			agbno, &has_refcount);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (!has_refcount) {
@@ -445,8 +442,7 @@ xchk_xref_is_cow_staging(
 	}
 
 	/* CoW flag must be set, refcount must be 1. */
-	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
-	if (!has_cowflag || rc.rc_refcount != 1)
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW || rc.rc_refcount != 1)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */
@@ -470,7 +466,8 @@ xchk_xref_is_not_shared(
 	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
+	error = xfs_refcount_has_record(sc->sa.refc_cur, XFS_REFC_DOMAIN_SHARED,
+			agbno, len, &shared);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (shared)

