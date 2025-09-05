Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79E131D743
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087770; cv=none; b=Mx8XyUW2R0ElUk4lXzgiu9THOpp2VyxzEiLv7IcQmnxL6rCCm2GKR4wslSSGHJ+UodBykK/o7J1TNg9x11onF2l2aldq+g+EsnG+qsARHJL+Ke0AFonSCcIJeXxzxv0gIAEKEzL0oBcPldOOHDgEcpYK6/xQJpq2ry80w5hE8Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087770; c=relaxed/simple;
	bh=uh72VuR5gqphjOzhBlThul08bdvrjrf4d2qD1l61X18=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxN7HdPanwpXFLw1BCx3rplScNhsSyzeez0fd+yKlwWRTqc3iczTK4FMvs9yDr3Yw/k6Nk3Gl0cKfiBG9hVJGtrGPS9uCM9cANawjC7kWS+fu1xjWN7lENQmpiNgbFTo8mMSwo6nReGzh3fxEj43SA57ehtEHuYRmm5CO8xT7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJCzSZmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJCzSZmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A292C4CEF1;
	Fri,  5 Sep 2025 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087769;
	bh=uh72VuR5gqphjOzhBlThul08bdvrjrf4d2qD1l61X18=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kJCzSZmXo3OBx3ISf/dHRJqGav1wEKvw8CmIFYszFo6TILuL00oOZ+dIwi2SjjrWq
	 m8JgEFECkQOv8fy4axUJJ1xM+HUzm6AWNTjuyQkiXtVIfdNXOGtE9o0i93DwnZ+djP
	 hN2nzXDE0phhC773usetgyd0ECSilf/L3zp1FBVi/Un5/Ml8gsPA/brDtb/TB5KxI0
	 dcFJEt+JwL0AuQjsZeKogLOOuDLS44Z+sxpP/f61CEAdUqt9Ih7Jf5lcoiJblkrQfA
	 1t14jBFSqNXAsY1swiIYYlRCQl1qnCm0pmrb5OPHMqBS0KTt0PABYwZNLF6HFR9B+7
	 lqAugAkTLPHPg==
Date: Fri, 05 Sep 2025 08:56:08 -0700
Subject: [PATCH 3/9] xfs: convert the ifork reap code to use xreap_state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765121.3402543.13720086290657517049.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
References: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert the file fork reaping code to use struct xreap_state so that we
can reuse the dynamic state tracking code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/reap.c |   78 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 16bd298330a4cc..33272729249f64 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -91,9 +91,21 @@
 struct xreap_state {
 	struct xfs_scrub		*sc;
 
-	/* Reverse mapping owner and metadata reservation type. */
-	const struct xfs_owner_info	*oinfo;
-	enum xfs_ag_resv_type		resv;
+	union {
+		struct {
+			/*
+			 * For AG blocks, this is reverse mapping owner and
+			 * metadata reservation type.
+			 */
+			const struct xfs_owner_info	*oinfo;
+			enum xfs_ag_resv_type		resv;
+		};
+		struct {
+			/* For file blocks, this is the inode and fork. */
+			struct xfs_inode		*ip;
+			int				whichfork;
+		};
+	};
 
 	/* Number of invalidated buffers logged to the current transaction. */
 	unsigned int			nr_binval;
@@ -965,13 +977,12 @@ xrep_reap_metadir_fsblocks(
  */
 STATIC int
 xreap_bmapi_select(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip,
-	int			whichfork,
+	struct xreap_state	*rs,
 	struct xfs_bmbt_irec	*imap,
 	bool			*crosslinked)
 {
 	struct xfs_owner_info	oinfo;
+	struct xfs_scrub	*sc = rs->sc;
 	struct xfs_btree_cur	*cur;
 	xfs_filblks_t		len = 1;
 	xfs_agblock_t		bno;
@@ -985,7 +996,8 @@ xreap_bmapi_select(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag);
 
-	xfs_rmap_ino_owner(&oinfo, ip->i_ino, whichfork, imap->br_startoff);
+	xfs_rmap_ino_owner(&oinfo, rs->ip->i_ino, rs->whichfork,
+			imap->br_startoff);
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
 	if (error)
 		goto out_cur;
@@ -1048,21 +1060,19 @@ xreap_buf_loggable(
  */
 STATIC int
 xreap_bmapi_binval(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip,
-	int			whichfork,
+	struct xreap_state	*rs,
 	struct xfs_bmbt_irec	*imap)
 {
+	struct xfs_scrub	*sc = rs->sc;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag = sc->sa.pag;
-	int			bmap_flags = xfs_bmapi_aflag(whichfork);
+	int			bmap_flags = xfs_bmapi_aflag(rs->whichfork);
 	xfs_fileoff_t		off;
 	xfs_fileoff_t		max_off;
 	xfs_extlen_t		scan_blocks;
 	xfs_agblock_t		bno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		agbno_next;
-	unsigned int		invalidated = 0;
 	int			error;
 
 	/*
@@ -1089,7 +1099,7 @@ xreap_bmapi_binval(
 		struct xfs_bmbt_irec	hmap;
 		int			nhmaps = 1;
 
-		error = xfs_bmapi_read(ip, off, max_off - off, &hmap,
+		error = xfs_bmapi_read(rs->ip, off, max_off - off, &hmap,
 				&nhmaps, bmap_flags);
 		if (error)
 			return error;
@@ -1130,14 +1140,13 @@ xreap_bmapi_binval(
 				xfs_buf_stale(bp);
 				xfs_buf_relse(bp);
 			}
-			invalidated++;
 
 			/*
 			 * Stop invalidating if we've hit the limit; we should
 			 * still have enough reservation left to free however
-			 * much of the mapping we've seen so far.
+			 * far we've gotten.
 			 */
-			if (invalidated > XREAP_MAX_BINVAL) {
+			if (!xreap_inc_binval(rs)) {
 				imap->br_blockcount = agbno_next - bno;
 				goto out;
 			}
@@ -1159,12 +1168,11 @@ xreap_bmapi_binval(
  */
 STATIC int
 xrep_reap_bmapi_iter(
-	struct xfs_scrub		*sc,
-	struct xfs_inode		*ip,
-	int				whichfork,
+	struct xreap_state		*rs,
 	struct xfs_bmbt_irec		*imap,
 	bool				crosslinked)
 {
+	struct xfs_scrub		*sc = rs->sc;
 	int				error;
 
 	if (crosslinked) {
@@ -1185,10 +1193,10 @@ xrep_reap_bmapi_iter(
 		 * deferred log intents in this function to control the exact
 		 * sequence of metadata updates.
 		 */
-		xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
-		xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
+		xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
+		xfs_trans_mod_dquot_byino(sc->tp, rs->ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		xfs_rmap_unmap_extent(sc->tp, ip, whichfork, imap);
+		xfs_rmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		return 0;
 	}
 
@@ -1209,7 +1217,7 @@ xrep_reap_bmapi_iter(
 	 * transaction is full of logged buffer invalidations, so we need to
 	 * return early so that we can roll and retry.
 	 */
-	error = xreap_bmapi_binval(sc, ip, whichfork, imap);
+	error = xreap_bmapi_binval(rs, imap);
 	if (error || imap->br_blockcount == 0)
 		return error;
 
@@ -1218,8 +1226,8 @@ xrep_reap_bmapi_iter(
 	 * intents in this function to control the exact sequence of metadata
 	 * updates.
 	 */
-	xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
-	xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
+	xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
+	xfs_trans_mod_dquot_byino(sc->tp, rs->ip, XFS_TRANS_DQ_BCOUNT,
 			-(int64_t)imap->br_blockcount);
 	return xfs_free_extent_later(sc->tp, imap->br_startblock,
 			imap->br_blockcount, NULL, XFS_AG_RESV_NONE,
@@ -1232,18 +1240,17 @@ xrep_reap_bmapi_iter(
  */
 STATIC int
 xreap_ifork_extent(
-	struct xfs_scrub		*sc,
-	struct xfs_inode		*ip,
-	int				whichfork,
+	struct xreap_state		*rs,
 	struct xfs_bmbt_irec		*imap)
 {
+	struct xfs_scrub		*sc = rs->sc;
 	xfs_agnumber_t			agno;
 	bool				crosslinked;
 	int				error;
 
 	ASSERT(sc->sa.pag == NULL);
 
-	trace_xreap_ifork_extent(sc, ip, whichfork, imap);
+	trace_xreap_ifork_extent(sc, rs->ip, rs->whichfork, imap);
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, imap->br_startblock);
 	sc->sa.pag = xfs_perag_get(sc->mp, agno);
@@ -1258,11 +1265,11 @@ xreap_ifork_extent(
 	 * Decide the fate of the blocks at the beginning of the mapping, then
 	 * update the mapping to use it with the unmap calls.
 	 */
-	error = xreap_bmapi_select(sc, ip, whichfork, imap, &crosslinked);
+	error = xreap_bmapi_select(rs, imap, &crosslinked);
 	if (error)
 		goto out_agf;
 
-	error = xrep_reap_bmapi_iter(sc, ip, whichfork, imap, crosslinked);
+	error = xrep_reap_bmapi_iter(rs, imap, crosslinked);
 	if (error)
 		goto out_agf;
 
@@ -1286,6 +1293,12 @@ xrep_reap_ifork(
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
+	struct xreap_state	rs = {
+		.sc		= sc,
+		.ip		= ip,
+		.whichfork	= whichfork,
+		.max_binval	= XREAP_MAX_BINVAL,
+	};
 	xfs_fileoff_t		off = 0;
 	int			bmap_flags = xfs_bmapi_aflag(whichfork);
 	int			error;
@@ -1313,13 +1326,14 @@ xrep_reap_ifork(
 		 * can in a single transaction.
 		 */
 		if (xfs_bmap_is_real_extent(&imap)) {
-			error = xreap_ifork_extent(sc, ip, whichfork, &imap);
+			error = xreap_ifork_extent(&rs, &imap);
 			if (error)
 				return error;
 
 			error = xfs_defer_finish(&sc->tp);
 			if (error)
 				return error;
+			xreap_defer_finish_reset(&rs);
 		}
 
 		off = imap.br_startoff + imap.br_blockcount;

