Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440C261B71;
	Fri, 10 Jul 2026 05:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660918; cv=none; b=AXhnroxw9VbNErBXlnPziGd+7eyR517TuArxD+h5PBv68yXaqoeN9jFGIT4/6rfv93W3Sbr0rZzVh7CyYj8ivRq9kSw8V+gwNenJ2hP1ZWFb/O14VaBz70JQ7UGo7uRqFrMttkuCJK5msX/qjwbg2mlxgMKCE40jP5tQFXuNO4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660918; c=relaxed/simple;
	bh=7V0bvB5PhgiJjUanTQvp8bgChHK9B49iIrdHOThJbJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xq8Pw3ixb2Ig+2yVgBMO4pcfAzXgO4SklDM76WaL9JsIQ79Mr9bdCB2mgvHzCtcQgRJu30BHicoCaC9Mg/4D4HK4NZaBWLxzUMXJ1RYzzS6NREspLqhFxCJeTruOzGaQRGt29k+z/SiaL2aaxsFlbtXRmAESduXkElJhbJlTKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9IQ2aXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9IQ2aXo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 036E61F000E9;
	Fri, 10 Jul 2026 05:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660917;
	bh=LFiYAeQd3tMCIfa/5XeNz0gg66Aocj3ZZqlMaRjDk5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=C9IQ2aXoqLiqjRXDd7PHg9jhYGxwLMe7rcClRFpnNQS4jqqJzbMZOxM3laLmR17kJ
	 hvgDXZ9Zn/FOaoHTkbUDPTCVzrcmxxahD3RRGXNIwuqQWK0gRUX0iYyTkQf/1DlGCl
	 sfKexwLRLdZDZogv+k6ly8O35Y0YDu2gnpg2ElGp5T3ZnCfZkf52iADkutenC1uX5o
	 RQ/D3IL2PIpKoka1rPL1OZSJHJwoV05lG9MtowPI6D9y/P0nrnP8DRbx259cFixFHo
	 mzkePml78dXWOcz08726Bq6ML+/+0/Fl/mLuVDNZRboDtdYQwSMA/oJfpSWpyYNaIP
	 yDGVTJjPjtc2A==
Date: Thu, 09 Jul 2026 22:21:56 -0700
Subject: [PATCH 1/8] xfs: don't replace the wrong part of the cow fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178366081014.1173468.1923355584342845630.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xfs_iext_lookup_extent can return a @got where
got->br_startoff < startoff.  In this case, xrep_cow_replace_range
replaces the entire mapping instead of just the part that had been
marked bad in the bitmap, but advances the bitmap cursor in
xrep_cow_replace by the amount replaced.  As a result, we fail to
replace the end of the bad range, and replace part of the good range.

Fix this by rewriting the replace method to handle replacing the middle
of a cow fork mapping.  This we do by returning both the current mapping
as @got, and the subset of the mapping that we want to replace as @rep,
using @rep to store the results of the new allocation, and comparing
@rep to @got to figure out the exact transformations needed.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: dbbdbd0086320a ("xfs: repair problems in CoW forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/trace.h      |   28 ++++--
 fs/xfs/scrub/cow_repair.c |  203 +++++++++++++++++++++++++++++----------------
 2 files changed, 148 insertions(+), 83 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1b7d9e07a27d3d..d48a6db5b5f308 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2672,9 +2672,9 @@ TRACE_EVENT(xrep_cow_mark_file_range,
 );
 
 TRACE_EVENT(xrep_cow_replace_mapping,
-	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *irec,
-		 xfs_fsblock_t new_startblock, xfs_extlen_t new_blockcount),
-	TP_ARGS(ip, irec, new_startblock, new_blockcount),
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *got,
+		 const struct xfs_bmbt_irec *rep),
+	TP_ARGS(ip, got, rep),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -2682,28 +2682,34 @@ TRACE_EVENT(xrep_cow_replace_mapping,
 		__field(xfs_fileoff_t, startoff)
 		__field(xfs_filblks_t, blockcount)
 		__field(xfs_exntst_t, state)
+		__field(xfs_fileoff_t, new_startoff)
 		__field(xfs_fsblock_t, new_startblock)
 		__field(xfs_extlen_t, new_blockcount)
+		__field(xfs_exntst_t, new_state)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = I_INO(ip);
-		__entry->startoff = irec->br_startoff;
-		__entry->startblock = irec->br_startblock;
-		__entry->blockcount = irec->br_blockcount;
-		__entry->state = irec->br_state;
-		__entry->new_startblock = new_startblock;
-		__entry->new_blockcount = new_blockcount;
+		__entry->startoff = got->br_startoff;
+		__entry->startblock = got->br_startblock;
+		__entry->blockcount = got->br_blockcount;
+		__entry->state = got->br_state;
+		__entry->new_startoff = rep->br_startoff;
+		__entry->new_startblock = rep->br_startblock;
+		__entry->new_blockcount = rep->br_blockcount;
+		__entry->new_state = rep->br_state;
 	),
-	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startblock 0x%llx new_fsbcount 0x%x",
+	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startoff 0x%llx new_startblock 0x%llx new_fsbcount 0x%x new_state 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->startoff,
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->state,
+		  __entry->new_startoff,
 		  __entry->new_startblock,
-		  __entry->new_blockcount)
+		  __entry->new_blockcount,
+		  __entry->new_state)
 );
 
 TRACE_EVENT(xrep_cow_free_staging,
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 0075b6d5a1b5ff..ca3405a26b641c 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -80,12 +80,6 @@ struct xrep_cow {
 	unsigned int		next_bno;
 };
 
-/* CoW staging extent. */
-struct xrep_cow_extent {
-	xfs_fsblock_t		fsbno;
-	xfs_extlen_t		len;
-};
-
 /*
  * Mark the part of the file range that corresponds to the given physical
  * space.  Caller must ensure that the physical range is within xc->irec.
@@ -401,22 +395,21 @@ xrep_cow_find_bad_rt(
 STATIC int
 xrep_cow_alloc(
 	struct xfs_scrub	*sc,
-	xfs_extlen_t		maxlen,
-	struct xrep_cow_extent	*repl)
+	struct xfs_bmbt_irec	*del)
 {
 	struct xfs_alloc_arg	args = {
 		.tp		= sc->tp,
 		.mp		= sc->mp,
 		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
 		.minlen		= 1,
-		.maxlen		= maxlen,
+		.maxlen		= del->br_blockcount,
 		.prod		= 1,
 		.resv		= XFS_AG_RESV_NONE,
 		.datatype	= XFS_ALLOC_USERDATA,
 	};
 	int			error;
 
-	error = xfs_trans_reserve_more(sc->tp, maxlen, 0);
+	error = xfs_trans_reserve_more(sc->tp, del->br_blockcount, 0);
 	if (error)
 		return error;
 
@@ -428,8 +421,8 @@ xrep_cow_alloc(
 
 	xfs_refcount_alloc_cow_extent(sc->tp, false, args.fsbno, args.len);
 
-	repl->fsbno = args.fsbno;
-	repl->len = args.len;
+	del->br_startblock = args.fsbno;
+	del->br_blockcount = args.len;
 	return 0;
 }
 
@@ -440,10 +433,12 @@ xrep_cow_alloc(
 STATIC int
 xrep_cow_alloc_rt(
 	struct xfs_scrub	*sc,
-	xfs_extlen_t		maxlen,
-	struct xrep_cow_extent	*repl)
+	struct xfs_bmbt_irec	*del)
 {
-	xfs_rtxlen_t		maxrtx = xfs_rtb_to_rtx(sc->mp, maxlen);
+	xfs_fsblock_t		fsbno;
+	xfs_rtxlen_t		maxrtx =
+		min(U32_MAX, xfs_blen_to_rtbxlen(sc->mp, del->br_blockcount));
+	xfs_extlen_t		len;
 	int			error;
 
 	error = xfs_trans_reserve_more(sc->tp, 0, maxrtx);
@@ -451,11 +446,14 @@ xrep_cow_alloc_rt(
 		return error;
 
 	error = xfs_rtallocate_rtgs(sc->tp, NULLRTBLOCK, 1, maxrtx, 1, false,
-			false, &repl->fsbno, &repl->len);
+			false, &fsbno, &len);
 	if (error)
 		return error;
 
-	xfs_refcount_alloc_cow_extent(sc->tp, true, repl->fsbno, repl->len);
+	xfs_refcount_alloc_cow_extent(sc->tp, true, fsbno, len);
+
+	del->br_startblock = fsbno;
+	del->br_blockcount = len;
 	return 0;
 }
 
@@ -469,19 +467,19 @@ static inline int
 xrep_cow_find_mapping(
 	struct xrep_cow		*xc,
 	struct xfs_iext_cursor	*icur,
-	xfs_fileoff_t		startoff,
-	struct xfs_bmbt_irec	*got)
+	xfs_fileoff_t		badoff,
+	xfs_extlen_t		badlen,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_bmbt_irec	*rep)
 {
 	struct xfs_inode	*ip = xc->sc->ip;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 
-	if (!xfs_iext_lookup_extent(ip, ifp, startoff, icur, got))
+	if (!xfs_iext_lookup_extent(ip, ifp, badoff, icur, got))
 		goto bad;
+	memcpy(rep, got, sizeof(*rep));
 
-	if (got->br_startoff > startoff)
-		goto bad;
-
-	if (got->br_blockcount == 0)
+	if (got->br_startoff > badoff)
 		goto bad;
 
 	if (isnullstartblock(got->br_startblock))
@@ -490,6 +488,24 @@ xrep_cow_find_mapping(
 	if (xfs_bmap_is_written_extent(got))
 		goto bad;
 
+	if (got->br_startoff < badoff) {
+		const int64_t	delta = badoff - got->br_startoff;
+
+		rep->br_blockcount -= delta;
+		rep->br_startoff += delta;
+		rep->br_startblock += delta;
+	}
+
+	if (got->br_startoff + got->br_blockcount > badoff + badlen) {
+		const int64_t	delta = (got->br_startoff + got->br_blockcount) -
+					(badoff + badlen);
+
+		rep->br_blockcount -= delta;
+	}
+
+	if (got->br_blockcount == 0)
+		goto bad;
+
 	return 0;
 bad:
 	ASSERT(0);
@@ -500,46 +516,92 @@ xrep_cow_find_mapping(
 #define REPLACE_RIGHT_SIDE	(1U << 1)
 
 /*
- * Given a CoW fork mapping @got and a replacement mapping @repl, remap the
- * beginning of @got with the space described by @rep.
+ * Given a CoW fork mapping @got and a replacement mapping @rep, map the space
+ * described by @rep into the cow fork, pushing aside @got as necessary.  @icur
+ * must point to iext tree leaf containing @got.
  */
 static inline void
 xrep_cow_replace_mapping(
-	struct xfs_inode		*ip,
-	struct xfs_iext_cursor		*icur,
-	const struct xfs_bmbt_irec	*got,
-	const struct xrep_cow_extent	*repl)
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*icur,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_bmbt_irec	*rep)
 {
-	struct xfs_bmbt_irec		new = *got; /* struct copy */
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
+	xfs_fileoff_t		rep_endoff =
+			rep->br_startoff + rep->br_blockcount;
+	xfs_fileoff_t		got_endoff =
+			got->br_startoff + got->br_blockcount;
+	uint32_t		state = BMAP_COWFORK;
 
-	ASSERT(repl->len > 0);
+	ASSERT(rep->br_blockcount > 0);
 	ASSERT(!isnullstartblock(got->br_startblock));
+	ASSERT(got->br_startoff <= rep->br_startoff);
+	ASSERT(got_endoff >= rep_endoff);
 
-	trace_xrep_cow_replace_mapping(ip, got, repl->fsbno, repl->len);
+	trace_xrep_cow_replace_mapping(ip, got, rep);
 
-	if (got->br_blockcount == repl->len) {
+	if (got->br_startoff == rep->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (got_endoff == rep_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
+	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
+		/*
+		 * Replacement matches the whole mapping, update the record.
+		 */
+		xfs_iext_update_extent(ip, state, icur, rep);
+		break;
+	case BMAP_LEFT_FILLING:
+		/*
+		 * Replace the first part of the mapping: Update the cursor
+		 * position with the new mapping, then add a record with the
+		 * tail of the old mapping.
+		 */
+		got->br_startoff = rep_endoff;
+		got->br_blockcount -= rep->br_blockcount;
+		got->br_startblock += rep->br_blockcount;
+
+		xfs_iext_update_extent(ip, state, icur, rep);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, got, state);
+		break;
+	case BMAP_RIGHT_FILLING:
 		/*
-		 * The new extent is a complete replacement for the existing
-		 * extent.  Update the COW fork record.
+		 * Replacing the last part of the mapping.  Shorten the current
+		 * mapping then add a record with the new mapping.
 		 */
-		new.br_startblock = repl->fsbno;
-		xfs_iext_update_extent(ip, BMAP_COWFORK, icur, &new);
-		return;
+		got->br_blockcount -= rep->br_blockcount;
+
+		xfs_iext_update_extent(ip, state, icur, got);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, rep, state);
+		break;
+	case 0:
+		/*
+		 * Replacing the middle of the extent.  Shorten the current
+		 * mapping, add a new record with the new mapping, and add a
+		 * second new record with the tail of the old mapping.
+		 */
+		got->br_blockcount = rep->br_startoff - got->br_startoff;
+
+		struct xfs_bmbt_irec	new = {
+			.br_startoff	= rep_endoff,
+			.br_blockcount	= got_endoff - rep_endoff,
+			.br_state	= got->br_state,
+			.br_startblock	= got->br_startblock +
+						rep->br_blockcount +
+						got->br_blockcount,
+		};
+
+		xfs_iext_update_extent(ip, state, icur, got);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, rep, state);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, &new, state);
+		break;
 	}
-
-	/*
-	 * The new extent can replace the beginning of the COW fork record.
-	 * Move the left side of @got upwards, then insert the new record.
-	 */
-	new.br_startoff += repl->len;
-	new.br_startblock += repl->len;
-	new.br_blockcount -= repl->len;
-	xfs_iext_update_extent(ip, BMAP_COWFORK, icur, &new);
-
-	new.br_startoff = got->br_startoff;
-	new.br_startblock = repl->fsbno;
-	new.br_blockcount = repl->len;
-	xfs_iext_insert(ip, icur, &new, BMAP_COWFORK);
 }
 
 /*
@@ -553,33 +615,30 @@ xrep_cow_replace_range(
 	xfs_extlen_t		*blockcount)
 {
 	struct xfs_iext_cursor	icur;
-	struct xrep_cow_extent	repl;
-	struct xfs_bmbt_irec	got;
+	struct xfs_bmbt_irec	got, rep;
 	struct xfs_scrub	*sc = xc->sc;
-	xfs_fileoff_t		nextoff;
-	xfs_extlen_t		alloc_len;
+	xfs_fsblock_t		old_fsbno;
 	int			error;
 
 	/*
-	 * Put the existing CoW fork mapping in @got.  If @got ends before
-	 * @rep, truncate @rep so we only replace one extent mapping at a time.
+	 * Put the existing CoW fork mapping in @got, and put in @rep the
+	 * contents of @got trimmed to @startoff/@blockcount.  We only want
+	 * to replace the bad region, and only one mapping at a time.
 	 */
-	error = xrep_cow_find_mapping(xc, &icur, startoff, &got);
+	error = xrep_cow_find_mapping(xc, &icur, startoff, *blockcount, &got,
+			&rep);
 	if (error)
 		return error;
-	nextoff = min(startoff + *blockcount,
-		      got.br_startoff + got.br_blockcount);
+	old_fsbno = rep.br_startblock;
 
 	/*
 	 * Allocate a replacement extent.  If we don't fill all the blocks,
 	 * shorten the quantity that will be deleted in this step.
 	 */
-	alloc_len = min_t(xfs_fileoff_t, XFS_MAX_BMBT_EXTLEN,
-			  nextoff - startoff);
 	if (XFS_IS_REALTIME_INODE(sc->ip))
-		error = xrep_cow_alloc_rt(sc, alloc_len, &repl);
+		error = xrep_cow_alloc_rt(sc, &rep);
 	else
-		error = xrep_cow_alloc(sc, alloc_len, &repl);
+		error = xrep_cow_alloc(sc, &rep);
 	if (error)
 		return error;
 
@@ -587,7 +646,7 @@ xrep_cow_replace_range(
 	 * Replace the old mapping with the new one, and commit the metadata
 	 * changes made so far.
 	 */
-	xrep_cow_replace_mapping(sc->ip, &icur, &got, &repl);
+	xrep_cow_replace_mapping(sc->ip, &icur, &got, &rep);
 
 	xfs_inode_set_cowblocks_tag(sc->ip);
 	error = xfs_defer_finish(&sc->tp);
@@ -596,15 +655,15 @@ xrep_cow_replace_range(
 
 	/* Note the old CoW staging extents; we'll reap them all later. */
 	if (XFS_IS_REALTIME_INODE(sc->ip))
-		error = xrtb_bitmap_set(&xc->old_cowfork_rtblocks,
-				got.br_startblock, repl.len);
+		error = xrtb_bitmap_set(&xc->old_cowfork_rtblocks, old_fsbno,
+				rep.br_blockcount);
 	else
-		error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks,
-				got.br_startblock, repl.len);
+		error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks, old_fsbno,
+				rep.br_blockcount);
 	if (error)
 		return error;
 
-	*blockcount = repl.len;
+	*blockcount = rep.br_blockcount;
 	return 0;
 }
 

