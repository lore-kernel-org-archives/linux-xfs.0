Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148BBECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiJ0ROj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiJ0ROf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E3FFB
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76724623ED
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF4AC433D6;
        Thu, 27 Oct 2022 17:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890871;
        bh=iLAUIKkvKtlN7XC7NVZz59I/VoLy+uwLwBVL/FRwJVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c+w0Ir9yE4f5MXqM/pXq+hW9Fi+kSCvWRrFGHsNcpazOaOaAGP27TqiiYtdOhEeD3
         vdYIsSJTNXYL5RXB/lsxs8VhZUkK6l9aiqd3fNZHb/a00jAKTyeCYAe8BN9F5Pa7NX
         iXASZIgurcBrpLRAyjMMXE1iaNtnrDH4ZPn78sfBJoQM2khYHAwIYwIP4ipqEBuDil
         7ERQHHIhpwNR+vD4VRLvIOOfF8+9COXPWMj87D8Y5EPHswEIMeGc9YIOFaCqLnuFTl
         egcEOlI9Fq74mMeOm04QQSMjOk0x3YEGuuUSWGrWUdo2UVV9Cnbw2ulsT/7aXpRIwE
         JqDPd6BdqzedQ==
Subject: [PATCH 05/12] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:31 -0700
Message-ID: <166689087143.3788582.13267485725187767138.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_refcount.c       |  151 ++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_refcount.h       |   28 ++++++-
 fs/xfs/libxfs/xfs_refcount_btree.c |   15 +++-
 fs/xfs/libxfs/xfs_types.h          |    6 +
 fs/xfs/scrub/refcount.c            |   22 ++---
 5 files changed, 154 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c6aa832a8713..8d0417565b9d 100644
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
+	__u32				start;
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
+	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
+		goto out_bad_rec;
+	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
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
@@ -169,12 +183,17 @@ xfs_refcount_update(
 	struct xfs_refcount_irec	*irec)
 {
 	union xfs_btree_rec	rec;
+	__u32			start;
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
@@ -196,9 +215,12 @@ xfs_refcount_insert(
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
@@ -244,7 +266,8 @@ xfs_refcount_delete(
 	}
 	if (error)
 		goto out_error;
-	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, irec.rc_domain, irec.rc_startblock,
+			&found_rec);
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
@@ -343,6 +366,7 @@ xfs_refc_next(
 STATIC int
 xfs_refcount_split_extent(
 	struct xfs_btree_cur		*cur,
+	enum xfs_refc_domain		domain,
 	xfs_agblock_t			agbno,
 	bool				*shape_changed)
 {
@@ -351,7 +375,7 @@ xfs_refcount_split_extent(
 	int				error;
 
 	*shape_changed = false;
-	error = xfs_refcount_lookup_le(cur, agbno, &found_rec);
+	error = xfs_refcount_lookup_le(cur, domain, agbno, &found_rec);
 	if (error)
 		goto out_error;
 	if (!found_rec)
@@ -364,6 +388,7 @@ xfs_refcount_split_extent(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -423,8 +448,8 @@ xfs_refcount_merge_center_extents(
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
@@ -451,8 +476,8 @@ xfs_refcount_merge_center_extents(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -493,8 +518,8 @@ xfs_refcount_merge_left_extent(
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
-		error = xfs_refcount_lookup_le(cur, cleft->rc_startblock,
-				&found_rec);
+		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
+				cleft->rc_startblock, &found_rec);
 		if (error)
 			goto out_error;
 		if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -512,8 +537,8 @@ xfs_refcount_merge_left_extent(
 	}
 
 	/* Enlarge the left extent. */
-	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, left->rc_domain,
+			left->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -557,8 +582,8 @@ xfs_refcount_merge_right_extent(
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
@@ -576,8 +601,8 @@ xfs_refcount_merge_right_extent(
 	}
 
 	/* Enlarge the right extent. */
-	error = xfs_refcount_lookup_le(cur, right->rc_startblock,
-			&found_rec);
+	error = xfs_refcount_lookup_le(cur, right->rc_domain,
+			right->rc_startblock, &found_rec);
 	if (error)
 		goto out_error;
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
@@ -616,11 +641,17 @@ xfs_refcount_find_left_extents(
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
@@ -671,6 +702,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_blockcount = min(aglen,
 					tmp.rc_startblock - agbno);
 			cleft->rc_refcount = 1;
+			cleft->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -680,6 +712,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_startblock = agbno;
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
+		cleft->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			left, cleft, agbno);
@@ -705,11 +738,17 @@ xfs_refcount_find_right_extents(
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
@@ -760,6 +799,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_blockcount = right->rc_startblock -
 					cright->rc_startblock;
 			cright->rc_refcount = 1;
+			cright->rc_domain = domain;
 		}
 	} else {
 		/*
@@ -769,6 +809,7 @@ xfs_refcount_find_right_extents(
 		cright->rc_startblock = agbno;
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
+		cright->rc_domain = domain;
 	}
 	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			cright, right, agbno + aglen);
@@ -933,7 +974,8 @@ xfs_refcount_adjust_extents(
 	if (*aglen == 0)
 		return 0;
 
-	error = xfs_refcount_lookup_ge(cur, *agbno, &found_rec);
+	error = xfs_refcount_lookup_ge(cur, XFS_REFC_DOMAIN_SHARED, *agbno,
+			&found_rec);
 	if (error)
 		goto out_error;
 
@@ -945,6 +987,7 @@ xfs_refcount_adjust_extents(
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
+			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
 		}
 
 		/*
@@ -957,6 +1000,8 @@ xfs_refcount_adjust_extents(
 			tmp.rc_blockcount = min(*aglen,
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
+			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -991,7 +1036,8 @@ xfs_refcount_adjust_extents(
 				break;
 
 			/* Move the cursor to the start of ext. */
-			error = xfs_refcount_lookup_ge(cur, *agbno,
+			error = xfs_refcount_lookup_ge(cur,
+					XFS_REFC_DOMAIN_SHARED, *agbno,
 					&found_rec);
 			if (error)
 				goto out_error;
@@ -1084,13 +1130,15 @@ xfs_refcount_adjust(
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
@@ -1365,7 +1413,8 @@ xfs_refcount_find_shared(
 	*flen = 0;
 
 	/* Try to find a refcount extent that crosses the start */
-	error = xfs_refcount_lookup_le(cur, agbno, &have);
+	error = xfs_refcount_lookup_le(cur, XFS_REFC_DOMAIN_SHARED, agbno,
+			&have);
 	if (error)
 		goto out_error;
 	if (!have) {
@@ -1513,17 +1562,18 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1538,6 +1588,8 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_startblock = agbno;
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
+		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
+
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &tmp);
 
@@ -1600,16 +1652,16 @@ xfs_refcount_adjust_cow(
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
 
@@ -1745,7 +1797,6 @@ xfs_refcount_recover_cow_leftovers(
 	union xfs_btree_irec		low;
 	union xfs_btree_irec		high;
 	xfs_fsblock_t			fsb;
-	xfs_agblock_t			agbno;
 	int				error;
 
 	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
@@ -1775,7 +1826,7 @@ xfs_refcount_recover_cow_leftovers(
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
 	memset(&high, 0, sizeof(high));
-	low.rc.rc_startblock = XFS_REFC_COW_START;
+	low.rc.rc_domain = high.rc.rc_domain = XFS_REFC_DOMAIN_COW;
 	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
@@ -1796,8 +1847,8 @@ xfs_refcount_recover_cow_leftovers(
 				&rr->rr_rrec);
 
 		/* Free the orphan record */
-		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
+		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
+				rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
@@ -1828,6 +1879,7 @@ xfs_refcount_recover_cow_leftovers(
 int
 xfs_refcount_has_record(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	bool			*exists)
@@ -1839,6 +1891,7 @@ xfs_refcount_has_record(
 	low.rc.rc_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
+	low.rc.rc_domain = high.rc.rc_domain = domain;
 
 	return xfs_btree_has_record(cur, &low, &high, exists);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index e8b322de7f3d..ca3ffe11a452 100644
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
 
+static inline __u32
+xfs_refcount_encode_startblock(
+	xfs_agblock_t		startblock,
+	enum xfs_refc_domain	domain)
+{
+	__u32			start;
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
index 316c1ec0c3c2..c57cddfcf434 100644
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
+	__u32			start;
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
+	__u32				start;
 
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
index 8ab55e791ea8..6adc645060e7 100644
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
+	error = xfs_refcount_lookup_le(sc->sa.refc_cur, XFS_REFC_DOMAIN_COW,
+			agbno, &has_refcount);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (!has_refcount) {
@@ -446,8 +444,7 @@ xchk_xref_is_cow_staging(
 	}
 
 	/* CoW flag must be set, refcount must be 1. */
-	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
-	if (!has_cowflag || rc.rc_refcount != 1)
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW || rc.rc_refcount != 1)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */
@@ -471,7 +468,8 @@ xchk_xref_is_not_shared(
 	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
+	error = xfs_refcount_has_record(sc->sa.refc_cur, XFS_REFC_DOMAIN_SHARED,
+			agbno, len, &shared);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
 	if (shared)

