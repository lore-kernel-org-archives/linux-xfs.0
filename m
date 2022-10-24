Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4C5C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJXXNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiJXXNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980611CBAB4
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC3F615C2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C397C433D7;
        Mon, 24 Oct 2022 21:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647206;
        bh=kFV90WgibonBO9/hWPuuE9c0nysBjO7V+D+TtfdS02I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cs4O56hRw3O1WHb7K3esU3DEtWW4QCgjxwWTVRr2B2DQSymAlZX01Da2/iGqmXCKU
         wNrCVfcHaRKJLD+vYiSZb8XEqDCAGkvfjPY7tyM20a6ZqaTnaIKFysKmNKXyM71Q+y
         Yi3H8l+A1t/ilDjBu6LGq/yGBOc8axLXZeU8pGbfinVZwhrWR8HEXLcabEinXWM19m
         X2SG7Fw1DIldvBWTYp+e/GM7HyjlVRZ7LOWC2paJ2frlsrgqA12GeeOgeSgR/NWdzq
         1tOBtykJLwBWXHGG6+1li+McdnEzwzi4MJnw/wRk6mB2DzOVZ8cy1qXjBKEfEBuS0w
         2pTZQg1r0ZGxg==
Subject: [PATCH 3/5] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Oct 2022 14:33:25 -0700
Message-ID: <166664720593.2690245.18182994137797499438.stgit@magnolia>
In-Reply-To: <166664718897.2690245.5721183007309479393.stgit@magnolia>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_refcount.c       |  221 ++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_refcount.h       |    9 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   26 ++++
 fs/xfs/libxfs/xfs_types.h          |   10 ++
 fs/xfs/scrub/refcount.c            |   22 ++--
 fs/xfs/xfs_trace.h                 |   48 ++++++--
 6 files changed, 235 insertions(+), 101 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 64b910caafaa..fa75e785652b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -46,13 +46,16 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 int
 xfs_refcount_lookup_le(
 	struct xfs_btree_cur	*cur,
+	enum xfs_rcext_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
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
+	enum xfs_rcext_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
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
+	enum xfs_rcext_domain	domain,
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
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
+	__u32				start;
+
+	start = be32_to_cpu(rec->refc.rc_startblock);
+	if (start & XFS_REFC_COW_START) {
+		start &= ~XFS_REFC_COW_START;
+		irec->rc_domain = XFS_RCDOM_COW;
+	} else {
+		irec->rc_domain = XFS_RCDOM_SHARED;
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
@@ -124,22 +142,18 @@ xfs_refcount_get_rec(
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
+	if (irec->rc_domain == XFS_RCDOM_COW && irec->rc_refcount != 1)
+		goto out_bad_rec;
+	if (irec->rc_domain == XFS_RCDOM_SHARED && irec->rc_refcount < 2)
 		goto out_bad_rec;
-	}
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(pag, realstart))
+	if (!xfs_verify_agbno(pag, irec->rc_startblock))
 		goto out_bad_rec;
-	if (realstart > realstart + irec->rc_blockcount)
+	if (irec->rc_startblock > irec->rc_startblock + irec->rc_blockcount)
 		goto out_bad_rec;
-	if (!xfs_verify_agbno(pag, realstart + irec->rc_blockcount - 1))
+	if (!xfs_verify_agbno(pag, irec->rc_startblock + irec->rc_blockcount - 1))
 		goto out_bad_rec;
 
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
@@ -169,12 +183,19 @@ xfs_refcount_update(
 	struct xfs_refcount_irec	*irec)
 {
 	union xfs_btree_rec	rec;
+	__u32			start;
 	int			error;
 
 	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
-	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
+
+	start = irec->rc_startblock & ~XFS_REFC_COW_START;
+	if (irec->rc_domain == XFS_RCDOM_COW)
+		start |= XFS_REFC_COW_START;
+
+	rec.refc.rc_startblock = cpu_to_be32(start);
 	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
 	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
+
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_refcount_update_error(cur->bc_mp,
@@ -196,9 +217,12 @@ xfs_refcount_insert(
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
@@ -244,7 +268,8 @@ xfs_refcount_delete(
 	}
 	if (error)
 		goto out_error;
-	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
+			&found_rec);
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
@@ -343,6 +368,7 @@ xfs_refc_next(
 STATIC int
 xfs_refcount_split_extent(
 	struct xfs_btree_cur		*cur,
+	enum xfs_rcext_domain		domain,
 	xfs_agblock_t			agbno,
 	bool				*shape_changed)
 {
@@ -351,7 +377,7 @@ xfs_refcount_split_extent(
 	int				error;
 
 	*shape_changed = false;
-	error = xfs_refcount_lookup_le(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -364,6 +390,9 @@ xfs_refcount_split_extent(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+
+	if (rcext.rc_domain != domain)
+		return 0;
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -412,6 +441,9 @@ xfs_refcount_merge_center_extents(
 	int				error;
 	int				found_rec;
 
+	ASSERT(left->rc_domain == center->rc_domain);
+	ASSERT(right->rc_domain == center->rc_domain);
+
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, center, right);
 
@@ -423,8 +455,8 @@ xfs_refcount_merge_center_extents(
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
@@ -451,8 +483,8 @@ xfs_refcount_merge_center_extents(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -488,13 +520,15 @@ xfs_refcount_merge_left_extent(
 	int				error;
 	int				found_rec;
 
+	ASSERT(left->rc_domain == cleft->rc_domain);
+
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, cleft);
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
-		error = xfs_refcount_lookup_le(cur, cleft->rc_startblock,
-				&found_rec);
+		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
+				cleft->rc_startblock, &found_rec);
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -512,8 +546,8 @@ xfs_refcount_merge_left_extent(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -549,6 +583,8 @@ xfs_refcount_merge_right_extent(
 	int				error;
 	int				found_rec;
 
+	ASSERT(right->rc_domain == cright->rc_domain);
+
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, cright, right);
 
@@ -557,8 +593,8 @@ xfs_refcount_merge_right_extent(
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
@@ -576,8 +612,8 @@ xfs_refcount_merge_right_extent(
 	}
 
 	/* Enlarge the right extent. */
-	error = xfs_refcount_lookup_le(cur, right->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, right->rc_domain,
+			right->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -600,8 +636,6 @@ xfs_refcount_merge_right_extent(
 	return error;
 }
 
-#define XFS_FIND_RCEXT_SHARED	1
-#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -611,16 +645,16 @@ xfs_refcount_find_left_extents(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*left,
 	struct xfs_refcount_irec	*cleft,
+	enum xfs_rcext_domain		domain,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen,
-	int				flags)
+	xfs_extlen_t			aglen)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
 	int				found_rec;
 
 	left->rc_startblock = cleft->rc_startblock = NULLAGBLOCK;
-	error = xfs_refcount_lookup_le(cur, agbno - 1, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno - 1, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -634,11 +668,13 @@ xfs_refcount_find_left_extents(
 		goto out_error;
 	}
 
+	if (tmp.rc_domain != domain)
+		return 0;
 	if (xfs_refc_next(&tmp) != agbno)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+	if (domain == XFS_RCDOM_SHARED && tmp.rc_refcount < 2)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+	if (domain == XFS_RCDOM_COW && tmp.rc_refcount > 1)
 		return 0;
 	/* We have a left extent; retrieve (or invent) the next right one */
 	*left = tmp;
@@ -655,6 +691,9 @@ xfs_refcount_find_left_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp starts at the end of our range, just use that */
 		if (tmp.rc_startblock == agbno)
 			*cleft = tmp;
@@ -671,8 +710,10 @@ xfs_refcount_find_left_extents(
 			cleft->rc_blockcount = min(aglen,
 					tmp.rc_startblock - agbno);
 			cleft->rc_refcount = 1;
+			cleft->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -680,6 +721,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_startblock = agbno;
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
+		cleft->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			left, cleft, agbno);
@@ -700,16 +742,16 @@ xfs_refcount_find_right_extents(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*right,
 	struct xfs_refcount_irec	*cright,
+	enum xfs_rcext_domain		domain,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen,
-	int				flags)
+	xfs_extlen_t			aglen)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
 	int				found_rec;
 
 	right->rc_startblock = cright->rc_startblock = NULLAGBLOCK;
-	error = xfs_refcount_lookup_ge(cur, agbno + aglen, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, domain, agbno + aglen, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -723,11 +765,13 @@ xfs_refcount_find_right_extents(
 		goto out_error;
 	}
 
+	if (tmp.rc_domain != domain)
+		return 0;
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+	if (domain == XFS_RCDOM_SHARED && tmp.rc_refcount < 2)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+	if (domain == XFS_RCDOM_COW && tmp.rc_refcount > 1)
 		return 0;
 	/* We have a right extent; retrieve (or invent) the next left one */
 	*right = tmp;
@@ -744,6 +788,9 @@ xfs_refcount_find_right_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp ends at the end of our range, just use that */
 		if (xfs_refc_next(&tmp) == agbno + aglen)
 			*cright = tmp;
@@ -760,8 +807,10 @@ xfs_refcount_find_right_extents(
 			cright->rc_blockcount = right->rc_startblock -
 					cright->rc_startblock;
 			cright->rc_refcount = 1;
+			cright->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -769,6 +818,7 @@ xfs_refcount_find_right_extents(
 		cright->rc_startblock = agbno;
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
+		cright->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			cright, right, agbno + aglen);
@@ -794,10 +844,10 @@ xfs_refc_valid(
 STATIC int
 xfs_refcount_merge_extents(
 	struct xfs_btree_cur	*cur,
+	enum xfs_rcext_domain	domain,
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
 	enum xfs_refc_adjust_op adjust,
-	int			flags,
 	bool			*shape_changed)
 {
 	struct xfs_refcount_irec	left = {0}, cleft = {0};
@@ -812,12 +862,12 @@ xfs_refcount_merge_extents(
 	 * just below (agbno + aglen) [cright], and just above (agbno + aglen)
 	 * [right].
 	 */
-	error = xfs_refcount_find_left_extents(cur, &left, &cleft, *agbno,
-			*aglen, flags);
+	error = xfs_refcount_find_left_extents(cur, &left, &cleft, domain,
+			*agbno, *aglen);
 	if (error)
 		return error;
-	error = xfs_refcount_find_right_extents(cur, &right, &cright, *agbno,
-			*aglen, flags);
+	error = xfs_refcount_find_right_extents(cur, &right, &cright, domain,
+			*agbno, *aglen);
 	if (error)
 		return error;
 
@@ -870,7 +920,7 @@ xfs_refcount_merge_extents(
 				aglen);
 	}
 
-	return error;
+	return 0;
 }
 
 /*
@@ -933,7 +983,8 @@ xfs_refcount_adjust_extents(
 	if (*aglen == 0)
 		return 0;
 
-	error = xfs_refcount_lookup_ge(cur, *agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_RCDOM_SHARED, *agbno,
+			&found_rec);
 	if (error)
 		goto out_error;
 
@@ -941,10 +992,11 @@ xfs_refcount_adjust_extents(
 		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 		if (error)
 			goto out_error;
-		if (!found_rec) {
+		if (!found_rec || ext.rc_domain != XFS_RCDOM_SHARED) {
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
+			ext.rc_domain = XFS_RCDOM_SHARED;
 		}
 
 		/*
@@ -957,6 +1009,8 @@ xfs_refcount_adjust_extents(
 			tmp.rc_blockcount = min(*aglen,
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
+			tmp.rc_domain = XFS_RCDOM_SHARED;
+
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -986,8 +1040,8 @@ xfs_refcount_adjust_extents(
 			(*agbno) += tmp.rc_blockcount;
 			(*aglen) -= tmp.rc_blockcount;
 
-			error = xfs_refcount_lookup_ge(cur, *agbno,
-					&found_rec);
+			error = xfs_refcount_lookup_ge(cur, XFS_RCDOM_SHARED,
+					*agbno, &found_rec);
 			if (error)
 				goto out_error;
 		}
@@ -1070,13 +1124,15 @@ xfs_refcount_adjust(
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
 	 */
-	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_RCDOM_SHARED, agbno,
+			&shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
 		shape_changes++;
 
-	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_RCDOM_SHARED, agbno + aglen,
+			&shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1085,8 +1141,8 @@ xfs_refcount_adjust(
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, new_agbno, new_aglen, adj,
-			XFS_FIND_RCEXT_SHARED, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_RCDOM_SHARED, new_agbno,
+			new_aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1307,7 +1363,7 @@ xfs_refcount_find_shared(
 	*flen = 0;
 
 	/* Try to find a refcount extent that crosses the start */
-	error = xfs_refcount_lookup_le(cur, agbno, &have);
+	error = xfs_refcount_lookup_le(cur, XFS_RCDOM_SHARED, agbno, &have);
 	if (error)
 		goto out_error;
 	if (!have) {
@@ -1325,6 +1381,8 @@ xfs_refcount_find_shared(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (tmp.rc_domain != XFS_RCDOM_SHARED)
+		goto done;
 
 	/* If the extent ends before the start, look at the next one */
 	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
@@ -1340,6 +1398,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
+		if (tmp.rc_domain != XFS_RCDOM_SHARED)
+			goto done;
 	}
 
 	/* If the extent starts after the range we want, bail out */
@@ -1371,7 +1431,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		if (tmp.rc_startblock >= agbno + aglen ||
+		if (tmp.rc_domain != XFS_RCDOM_SHARED ||
+		    tmp.rc_startblock >= agbno + aglen ||
 		    tmp.rc_startblock != *fbno + *flen)
 			break;
 		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
@@ -1455,17 +1516,22 @@ xfs_refcount_adjust_cow_extents(
 		return 0;
 
 	/* Find any overlapping refcount records */
-	error = xfs_refcount_lookup_ge(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_RCDOM_COW, agbno, &found_rec);
 	if (error)
 		goto out_error;
 	error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 	if (error)
 		goto out_error;
+	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec &&
+				ext.rc_domain != XFS_RCDOM_COW)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks +
-				XFS_REFC_COW_START;
+		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
+		ext.rc_domain = XFS_RCDOM_COW;
 	}
 
 	switch (adj) {
@@ -1480,6 +1546,8 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_startblock = agbno;
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
+		tmp.rc_domain = XFS_RCDOM_COW;
+
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -1542,24 +1610,24 @@ xfs_refcount_adjust_cow(
 	bool			shape_changed;
 	int			error;
 
-	agbno += XFS_REFC_COW_START;
-
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
 	 */
-	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_RCDOM_COW, agbno,
+			&shape_changed);
 	if (error)
 		goto out_error;
 
-	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	error = xfs_refcount_split_extent(cur, XFS_RCDOM_COW, agbno + aglen,
+			&shape_changed);
 	if (error)
 		goto out_error;
 
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			XFS_FIND_RCEXT_COW, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_RCDOM_COW, &agbno, &aglen,
+			adj, &shape_changed);
 	if (error)
 		goto out_error;
 
@@ -1666,6 +1734,10 @@ xfs_refcount_recover_extent(
 			   be32_to_cpu(rec->refc.rc_refcount) != 1))
 		return -EFSCORRUPTED;
 
+	if (XFS_IS_CORRUPT(cur->bc_mp, !(rec->refc.rc_startblock &
+					 cpu_to_be32(XFS_REFC_COW_START))))
+		return -EFSCORRUPTED;
+
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 	list_add_tail(&rr->rr_list, debris);
@@ -1687,10 +1759,11 @@ xfs_refcount_recover_cow_leftovers(
 	union xfs_btree_irec		low;
 	union xfs_btree_irec		high;
 	xfs_fsblock_t			fsb;
-	xfs_agblock_t			agbno;
 	int				error;
 
-	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
+	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COW_START);
+	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
 		return -EOPNOTSUPP;
 
 	INIT_LIST_HEAD(&debris);
@@ -1717,7 +1790,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
 	memset(&high, 0, sizeof(high));
-	low.rc.rc_startblock = XFS_REFC_COW_START;
+	low.rc.rc_domain = high.rc.rc_domain = XFS_RCDOM_COW;
 	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
@@ -1738,8 +1811,8 @@ xfs_refcount_recover_cow_leftovers(
 				&rr->rr_rrec);
 
 		/* Free the orphan record */
-		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
+		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
+				rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
@@ -1770,6 +1843,7 @@ xfs_refcount_recover_cow_leftovers(
 int
 xfs_refcount_has_record(
 	struct xfs_btree_cur	*cur,
+	enum xfs_rcext_domain	domain,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	bool			*exists)
@@ -1781,6 +1855,7 @@ xfs_refcount_has_record(
 	low.rc.rc_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
+	low.rc.rc_domain = high.rc.rc_domain = domain;
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index e8b322de7f3d..35f7db1959e5 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -14,11 +14,11 @@ struct xfs_bmbt_irec;
 struct xfs_refcount_irec;
 
 extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_rcext_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_rcext_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_eq(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, int *stat);
+		enum xfs_rcext_domain domain, xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
@@ -79,7 +79,8 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 #define XFS_REFCOUNT_ITEM_OVERHEAD	32
 
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+		enum xfs_rcext_domain domain, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 316c1ec0c3c2..b0818063aa20 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -155,12 +155,31 @@ xfs_refcountbt_init_high_key_from_rec(
 	key->refc.rc_startblock = cpu_to_be32(x);
 }
 
+static inline __u32
+xfs_refcountbt_encode_startblock(
+	struct xfs_btree_cur	*cur)
+{
+	__u32			start;
+
+	/*
+	 * low level btree operations need to handle the generic btree range
+	 * query functions (which set rc_domain == -1U), so we check that the
+	 * domain is /not/ shared.
+	 */
+	start = cur->bc_rec.rc.rc_startblock & ~XFS_REFC_COW_START;
+	if (cur->bc_rec.rc.rc_domain != XFS_RCDOM_SHARED)
+		start |= XFS_REFC_COW_START;
+	return start;
+}
+
 STATIC void
 xfs_refcountbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
 {
-	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
+	__u32			start = xfs_refcountbt_encode_startblock(cur);
+
+	rec->refc.rc_startblock = cpu_to_be32(start);
 	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
 	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
 }
@@ -182,10 +201,11 @@ xfs_refcountbt_key_diff(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key)
 {
-	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
 	const struct xfs_refcount_key	*kp = &key->refc;
+	__u32				start;
 
-	return (int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
+	start = xfs_refcountbt_encode_startblock(cur);
+	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
 }
 
 STATIC int64_t
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 2d9ebc7338b1..50e610a9b89c 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -166,10 +166,20 @@ typedef struct xfs_bmbt_irec
 	xfs_exntst_t	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
+enum xfs_rcext_domain {
+	XFS_RCDOM_SHARED = 0,
+	XFS_RCDOM_COW,
+};
+
+#define XFS_RCEXT_DOM_STRINGS \
+	{ XFS_RCDOM_SHARED,	"shared" }, \
+	{ XFS_RCDOM_COW,	"cow" }
+
 struct xfs_refcount_irec {
 	xfs_agblock_t	rc_startblock;	/* starting block number */
 	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
 	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+	enum xfs_rcext_domain	rc_domain; /* shared or cow staging extent? */
 };
 
 #define XFS_RMAP_ATTR_FORK		(1 << 0)
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 8ab55e791ea8..9cf4be9cbb89 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -334,20 +334,19 @@ xchk_refcountbt_rec(
 	struct xfs_refcount_irec irec;
 	xfs_agblock_t		*cow_blocks = bs->private;
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
-	bool			has_cowflag;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
 
 	/* Only CoW records can have refcount == 1. */
-	has_cowflag = (irec.rc_startblock & XFS_REFC_COW_START);
-	if ((irec.rc_refcount == 1 && !has_cowflag) ||
-	    (irec.rc_refcount != 1 && has_cowflag))
+	if (irec.rc_domain == XFS_RCDOM_SHARED && irec.rc_refcount == 1)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	if (has_cowflag)
+	if (irec.rc_domain == XFS_RCDOM_COW) {
+		if (irec.rc_refcount != 1)
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		(*cow_blocks) += irec.rc_blockcount;
+	}
 
 	/* Check the extent. */
-	irec.rc_startblock &= ~XFS_REFC_COW_START;
 	if (irec.rc_startblock + irec.rc_blockcount <= irec.rc_startblock ||
 	    !xfs_verify_agbno(pag, irec.rc_startblock) ||
 	    !xfs_verify_agbno(pag, irec.rc_startblock + irec.rc_blockcount - 1))
@@ -420,7 +419,6 @@ xchk_xref_is_cow_staging(
 	xfs_extlen_t			len)
 {
 	struct xfs_refcount_irec	rc;
-	bool				has_cowflag;
 	int				has_refcount;
 	int				error;
 
@@ -428,8 +426,8 @@ xchk_xref_is_cow_staging(
 		return;
 
 	/* Find the CoW staging extent. */
-	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
-			agbno + XFS_REFC_COW_START, &has_refcount);
+	error = xfs_refcount_lookup_le(sc->sa.refc_cur, XFS_RCDOM_COW, agbno,
+			&has_refcount);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (!has_refcount) {
@@ -446,8 +444,7 @@ xchk_xref_is_cow_staging(
 	}
 
 	/* CoW flag must be set, refcount must be 1. */
-	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
-	if (!has_cowflag || rc.rc_refcount != 1)
+	if (rc.rc_domain != XFS_RCDOM_COW || rc.rc_refcount != 1)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */
@@ -471,7 +468,8 @@ xchk_xref_is_not_shared(
 	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
+	error = xfs_refcount_has_record(sc->sa.refc_cur, XFS_RCDOM_SHARED,
+			agbno, len, &shared);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (shared)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cb7c81ba7fa3..820da4452499 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -799,6 +799,9 @@ TRACE_DEFINE_ENUM(PE_SIZE_PTE);
 TRACE_DEFINE_ENUM(PE_SIZE_PMD);
 TRACE_DEFINE_ENUM(PE_SIZE_PUD);
 
+TRACE_DEFINE_ENUM(XFS_RCDOM_SHARED);
+TRACE_DEFINE_ENUM(XFS_RCDOM_COW);
+
 TRACE_EVENT(xfs_filemap_fault,
 	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
 		 bool write_fault),
@@ -2925,6 +2928,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_rcext_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
@@ -2932,13 +2936,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount)
@@ -2958,6 +2964,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_rcext_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
@@ -2966,14 +2973,16 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount,
@@ -2994,9 +3003,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_rcext_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_rcext_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
@@ -3004,20 +3015,24 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount)
@@ -3038,9 +3053,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_rcext_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_rcext_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
@@ -3049,21 +3066,25 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
@@ -3086,12 +3107,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_rcext_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_rcext_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
+		__field(enum xfs_rcext_domain, i3_domain)
 		__field(xfs_agblock_t, i3_startblock)
 		__field(xfs_extlen_t, i3_blockcount)
 		__field(xfs_nlink_t, i3_refcount)
@@ -3099,27 +3123,33 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
+		__entry->i3_domain = i3->rc_domain;
 		__entry->i3_startblock = i3->rc_startblock;
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
+		  __print_symbolic(__entry->i3_domain, XFS_RCEXT_DOM_STRINGS),
 		  __entry->i3_startblock,
 		  __entry->i3_blockcount,
 		  __entry->i3_refcount)

