Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409853148AA
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391304; cv=none; b=Rx/CfTbX+f3fyPNCk12+8OPqa6Sixe6vRtvl5KLfu/wqfpx+8gRdTYD1L0JSdF+qDAwKVZ4DgtOwHPAdJe/D2v1bkVuPZeAExcCi/TrJrCWVVuseaP6jNWfWgfBxQJqBA5BqUngqW5Qya07gnK4zrX49oukpESzV+/LsFgI2/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391304; c=relaxed/simple;
	bh=X4jb4mKJwMZT/9Q2UCPw/2hKF0FK/k8m3ixVDUtSF1A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gq8V/FqXNTQDC2jh8LeMbQDQzT6T6zQ+tRCQwr5KYiEVDNKvfBxb6e9nm/de1P5f7IwoUydr7oJRLCRZo9W4RpvGECtWx9x61ymcWHoPBkfPEjFDMM1S4mP4h1UNG7nZ8W+dYbQNO5W8AOzWaexN9b6YRyuZq1DqsFsu+EYuKrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8CUqiIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8CUqiIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0719C4CEEB;
	Thu, 28 Aug 2025 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391303;
	bh=X4jb4mKJwMZT/9Q2UCPw/2hKF0FK/k8m3ixVDUtSF1A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l8CUqiIasi8wij+ovf5mdhMadZH8Fh+KEju0EoMAJQ7izeoY3A4bYpCePTHC2PSMy
	 HiEbJYqbL043qOJnTsRBP+7nQNyWZkr1ryCn8seAiArx+du+AlSrZpz41JMwznu0vg
	 DWhsY+jgYnXW/WvkR1qjDEkdeUYTmfp5vrEx+7YghgbCZwYwPcS/GU98eqrSUR1Hq7
	 aFbg3UESRRBZpM36Ri/AtZEuYU36+zM3fLnmi43X+T9T62uR7Xj8xywzdVLdF3gPX1
	 70BJmAcBsQv+Au6AwPHyOFIPu6cQ1Z/grl0zCNiCff6ss/dIWeHX3ctO5+y3cu5je3
	 Jwu4ZYdCNKVVg==
Date: Thu, 28 Aug 2025 07:28:23 -0700
Subject: [PATCH 2/9] xfs: convert the ifork reap code to use xreap_state
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126481.761138.14260878664209617843.stgit@frogsfrogsfrogs>
In-Reply-To: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/reap.c |   78 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 7877ef427990eb..db46f6cd4112f3 100644
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
@@ -964,13 +976,12 @@ xrep_reap_metadir_fsblocks(
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
@@ -984,7 +995,8 @@ xreap_bmapi_select(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag);
 
-	xfs_rmap_ino_owner(&oinfo, ip->i_ino, whichfork, imap->br_startoff);
+	xfs_rmap_ino_owner(&oinfo, rs->ip->i_ino, rs->whichfork,
+			imap->br_startoff);
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
 	if (error)
 		goto out_cur;
@@ -1047,21 +1059,19 @@ xreap_buf_loggable(
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
@@ -1088,7 +1098,7 @@ xreap_bmapi_binval(
 		struct xfs_bmbt_irec	hmap;
 		int			nhmaps = 1;
 
-		error = xfs_bmapi_read(ip, off, max_off - off, &hmap,
+		error = xfs_bmapi_read(rs->ip, off, max_off - off, &hmap,
 				&nhmaps, bmap_flags);
 		if (error)
 			return error;
@@ -1129,14 +1139,13 @@ xreap_bmapi_binval(
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
@@ -1158,12 +1167,11 @@ xreap_bmapi_binval(
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
@@ -1184,10 +1192,10 @@ xrep_reap_bmapi_iter(
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
 
@@ -1208,7 +1216,7 @@ xrep_reap_bmapi_iter(
 	 * transaction is full of logged buffer invalidations, so we need to
 	 * return early so that we can roll and retry.
 	 */
-	error = xreap_bmapi_binval(sc, ip, whichfork, imap);
+	error = xreap_bmapi_binval(rs, imap);
 	if (error || imap->br_blockcount == 0)
 		return error;
 
@@ -1217,8 +1225,8 @@ xrep_reap_bmapi_iter(
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
@@ -1231,18 +1239,17 @@ xrep_reap_bmapi_iter(
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
@@ -1257,11 +1264,11 @@ xreap_ifork_extent(
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
 
@@ -1285,6 +1292,12 @@ xrep_reap_ifork(
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
@@ -1312,13 +1325,14 @@ xrep_reap_ifork(
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

