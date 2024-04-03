Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EF86AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121507; cv=none; b=WtBxOE6xVi9uBetPhjPy0IwlbClk+GWPssQg0onyFdNhn7xnd12eEbyC5Tmh/MkXdIdaLQC699gU0FFqJnMGql11hRLZOh278OnOE2yRp1MrNDyEQOTalU44sqUuqCNMmxhwY1Llfn5jJeNR/eKwKYN7Gpq/V6TNUZlvJhOPOR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121507; c=relaxed/simple;
	bh=hYme5Yaghg5KXbz/JEAjSTp503ad/MXaI1cNYjStvic=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RenbHR9BqSnV8eRAbPZHR9YcdHErgQu7oBFeHPVf4fW1/SUPjV0Tw5qbIWn3Ta1YJD+7/KWgnwCAlMc0ctfBK69EUDnDGzKE4kGbCkDzZoh/nZ7NMM06WHVBpGvU6oNPQ5qQN4NmXhOJFDzl0Dx2c4TUvBHo/v5VM8bgTmnw0Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m04lx0l9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m04lx0l9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC96CC433F1;
	Wed,  3 Apr 2024 05:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121506;
	bh=hYme5Yaghg5KXbz/JEAjSTp503ad/MXaI1cNYjStvic=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=m04lx0l9137z6S5D2UIMyJojFhA7DFtGQCPxQlKPXQ8vUDa0S2iBAvzVeJP9ly0pv
	 C/3w1nBxA0fcA+nZwwlM7R6prqiLoPUCKvSJzYIb4SAAOy7m5fPujbWHr+PXV2So1V
	 3ATFlUDTGZoEWX27dHcR090UD3xHZegBYwENfSFATArKpIZZkeLctC4I/lp6x62eXo
	 LPjyiyDBuQ6sT4tzfo9Ie2VpsreGt8o11ik4MOVBsyYYcTV3Kha9HuuntAaj8KnG2l
	 DaomWUfaTF8kTc1OWyWRLopGdEhqiq+i3qVueUuN7fhsyIOxxWZ1qFT+S4ubVKXx2l
	 Nh48wmzOXB6VA==
Subject: [PATCH 1/3] xfs: pass xfs_buf lookup flags to xfs_*read_agi
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:18:26 -0700
Message-ID: <171212150618.1535150.1160220960086130932.stgit@frogsfrogsfrogs>
In-Reply-To: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow callers to pass buffer lookup flags to xfs_read_agi and
xfs_ialloc_read_agi.  This will be used in the next patch to fix a
deadlock in the online fsck inode scanner.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c           |    8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c       |   16 ++++++++++------
 fs/xfs/libxfs/xfs_ialloc.h       |    5 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 ++--
 fs/xfs/scrub/common.c            |    4 ++--
 fs/xfs/scrub/fscounters.c        |    2 +-
 fs/xfs/scrub/iscan.c             |    2 +-
 fs/xfs/scrub/repair.c            |    6 +++---
 fs/xfs/xfs_inode.c               |    8 ++++----
 fs/xfs/xfs_iwalk.c               |    4 ++--
 fs/xfs/xfs_log_recover.c         |    4 ++--
 11 files changed, 34 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index dc1873f76bffd..09fe9412eab49 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -194,7 +194,7 @@ xfs_initialize_perag_data(
 		pag = xfs_perag_get(mp, index);
 		error = xfs_alloc_read_agf(pag, NULL, 0, NULL);
 		if (!error)
-			error = xfs_ialloc_read_agi(pag, NULL, NULL);
+			error = xfs_ialloc_read_agi(pag, NULL, 0, NULL);
 		if (error) {
 			xfs_perag_put(pag);
 			return error;
@@ -931,7 +931,7 @@ xfs_ag_shrink_space(
 	int			error, err2;
 
 	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
-	error = xfs_ialloc_read_agi(pag, *tpp, &agibp);
+	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agibp);
 	if (error)
 		return error;
 
@@ -1062,7 +1062,7 @@ xfs_ag_extend_space(
 
 	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
 
-	error = xfs_ialloc_read_agi(pag, tp, &bp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &bp);
 	if (error)
 		return error;
 
@@ -1119,7 +1119,7 @@ xfs_ag_get_geometry(
 	int			error;
 
 	/* Lock the AG headers. */
-	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
+	error = xfs_ialloc_read_agi(pag, NULL, 0, &agi_bp);
 	if (error)
 		return error;
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agf_bp);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e5ac3e5430c4e..cb37f0007731f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1699,7 +1699,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
-		error = xfs_ialloc_read_agi(pag, tp, NULL);
+		error = xfs_ialloc_read_agi(pag, tp, 0, NULL);
 		if (error)
 			return false;
 	}
@@ -1768,7 +1768,7 @@ xfs_dialloc_try_ag(
 	 * Then read in the AGI buffer and recheck with the AGI buffer
 	 * lock held.
 	 */
-	error = xfs_ialloc_read_agi(pag, *tpp, &agbp);
+	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agbp);
 	if (error)
 		return error;
 
@@ -2286,7 +2286,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
 			__func__, error);
@@ -2332,7 +2332,7 @@ xfs_imap_lookup(
 	int			error;
 	int			i;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
@@ -2675,6 +2675,7 @@ int
 xfs_read_agi(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**agibpp)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -2684,7 +2685,7 @@ xfs_read_agi(
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+			XFS_FSS_TO_BB(mp, 1), flags, agibpp, &xfs_agi_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
@@ -2704,6 +2705,7 @@ int
 xfs_ialloc_read_agi(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
+	int			flags,
 	struct xfs_buf		**agibpp)
 {
 	struct xfs_buf		*agibp;
@@ -2712,7 +2714,9 @@ xfs_ialloc_read_agi(
 
 	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
 
-	error = xfs_read_agi(pag, tp, &agibp);
+	error = xfs_read_agi(pag, tp,
+			(flags & XFS_IALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
+			&agibp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index f1412183bb44b..b549627e3a615 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -63,10 +63,11 @@ xfs_ialloc_log_agi(
 	struct xfs_buf	*bp,		/* allocation group header buffer */
 	uint32_t	fields);	/* bitmask of fields to log */
 
-int xfs_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
+int xfs_read_agi(struct xfs_perag *pag, struct xfs_trans *tp, xfs_buf_flags_t flags,
 		struct xfs_buf **agibpp);
 int xfs_ialloc_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
-		struct xfs_buf **agibpp);
+		int flags, struct xfs_buf **agibpp);
+#define	XFS_IALLOC_FLAG_TRYLOCK	(1U << 0)  /* use trylock for buffer locking */
 
 /*
  * Lookup a record by ino in the btree given by cur.
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index cc661fca6ff5b..42e9fd47f6c73 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -745,7 +745,7 @@ xfs_finobt_count_blocks(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
@@ -768,7 +768,7 @@ xfs_finobt_read_blocks(
 	struct xfs_agi		*agi;
 	int			error;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 47a20cf5205f0..a27d33b6f4641 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -445,7 +445,7 @@ xchk_perag_read_headers(
 {
 	int			error;
 
-	error = xfs_ialloc_read_agi(sa->pag, sc->tp, &sa->agi_bp);
+	error = xfs_ialloc_read_agi(sa->pag, sc->tp, 0, &sa->agi_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		return error;
 
@@ -827,7 +827,7 @@ xchk_iget_agi(
 	 * in the iget cache miss path.
 	 */
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
-	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, agi_bpp);
 	xfs_perag_put(pag);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index d310737c88236..da2f6729699dd 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -85,7 +85,7 @@ xchk_fscount_warmup(
 			continue;
 
 		/* Lock both AG headers. */
-		error = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
+		error = xfs_ialloc_read_agi(pag, sc->tp, 0, &agi_bp);
 		if (error)
 			break;
 		error = xfs_alloc_read_agf(pag, sc->tp, 0, &agf_bp);
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index ec3478bc505ef..66ba0fbd059e0 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -281,7 +281,7 @@ xchk_iscan_advance(
 		if (!pag)
 			return -ECANCELED;
 
-		ret = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
+		ret = xfs_ialloc_read_agi(pag, sc->tp, 0, &agi_bp);
 		if (ret)
 			goto out_pag;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f43dce771cdd2..443e62f724818 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -290,7 +290,7 @@ xrep_calc_ag_resblks(
 		icount = pag->pagi_count;
 	} else {
 		/* Try to get the actual counters from disk. */
-		error = xfs_ialloc_read_agi(pag, NULL, &bp);
+		error = xfs_ialloc_read_agi(pag, NULL, 0, &bp);
 		if (!error) {
 			icount = pag->pagi_count;
 			xfs_buf_relse(bp);
@@ -908,7 +908,7 @@ xrep_reinit_pagi(
 	ASSERT(xfs_perag_initialised_agi(pag));
 
 	clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
-	error = xfs_ialloc_read_agi(pag, sc->tp, &bp);
+	error = xfs_ialloc_read_agi(pag, sc->tp, 0, &bp);
 	if (error)
 		return error;
 
@@ -934,7 +934,7 @@ xrep_ag_init(
 
 	ASSERT(!sa->pag);
 
-	error = xfs_ialloc_read_agi(pag, sc->tp, &sa->agi_bp);
+	error = xfs_ialloc_read_agi(pag, sc->tp, 0, &sa->agi_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea48774f6b76d..50a2d35991af4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2156,7 +2156,7 @@ xfs_iunlink(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, &agibp);
+	error = xfs_read_agi(pag, tp, 0, &agibp);
 	if (error)
 		goto out;
 
@@ -2253,7 +2253,7 @@ xfs_iunlink_remove(
 	trace_xfs_iunlink_remove(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, &agibp);
+	error = xfs_read_agi(pag, tp, 0, &agibp);
 	if (error)
 		return error;
 
@@ -3131,7 +3131,7 @@ xfs_rename(
 
 			pag = xfs_perag_get(mp,
 					XFS_INO_TO_AGNO(mp, inodes[i]->i_ino));
-			error = xfs_read_agi(pag, tp, &bp);
+			error = xfs_read_agi(pag, tp, 0, &bp);
 			xfs_perag_put(pag);
 			if (error)
 				goto out_trans_cancel;
@@ -3803,7 +3803,7 @@ xfs_inode_reload_unlinked_bucket(
 
 	/* Grab the first inode in the list */
 	pag = xfs_perag_get(mp, agno);
-	error = xfs_ialloc_read_agi(pag, tp, &agibp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agibp);
 	xfs_perag_put(pag);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 01b55f03a1026..730c8d48da282 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -268,7 +268,7 @@ xfs_iwalk_ag_start(
 
 	/* Set up a fresh cursor and empty the inobt cache. */
 	iwag->nr_recs = 0;
-	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, agi_bpp);
 	if (error)
 		return error;
 	*curpp = xfs_inobt_init_cursor(pag, tp, *agi_bpp);
@@ -386,7 +386,7 @@ xfs_iwalk_run_callbacks(
 	}
 
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_ialloc_read_agi(iwag->pag, iwag->tp, agi_bpp);
+	error = xfs_ialloc_read_agi(iwag->pag, iwag->tp, 0, agi_bpp);
 	if (error)
 		return error;
 	*curpp = xfs_inobt_init_cursor(iwag->pag, iwag->tp, *agi_bpp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13f1d2e915405..1b1f0a4cd4947 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2656,7 +2656,7 @@ xlog_recover_clear_agi_bucket(
 	if (error)
 		goto out_error;
 
-	error = xfs_read_agi(pag, tp, &agibp);
+	error = xfs_read_agi(pag, tp, 0, &agibp);
 	if (error)
 		goto out_abort;
 
@@ -2772,7 +2772,7 @@ xlog_recover_iunlink_ag(
 	int			bucket;
 	int			error;
 
-	error = xfs_read_agi(pag, NULL, &agibp);
+	error = xfs_read_agi(pag, NULL, 0, &agibp);
 	if (error) {
 		/*
 		 * AGI is b0rked. Don't process it.

