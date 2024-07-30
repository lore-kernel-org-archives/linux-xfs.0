Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA44A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299042; cv=none; b=K7zbK4Z85eoF3NhSdVPlAJhG5RlZndRwGF9olZ69raPlCwsv+9cSfWG52E2orvpbSEUM0tNHImMROg3NjCKDKZjw8SNyo56r+RrK2UmH8rO225ShgngGrnDAXoT2wnfHPFtvXPRfnCp+vQ9TaUgvxsgqOa/tam8+W7cx+zQqN0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299042; c=relaxed/simple;
	bh=IK5Z/8MqRdEwGypshnaSvpTTTYAu3aLEqqMpVvxc4iA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/GdGcqz54/VWedk7zZgmuCxWUQyl3rGDPkwlmyuADdApgwSIiv5QcKS8gDt6JNlnCZD62Lm1/IHEdn5we8LdRFVpL6R1iuoCrLEKqABRl0yJRH2lkn03rL/RUOsvba5+LdYca5nur4tkorS+nd2tOOsBO9XNgGeon+f+UPWULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6DrOjj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6DrOjj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956B1C32786;
	Tue, 30 Jul 2024 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299042;
	bh=IK5Z/8MqRdEwGypshnaSvpTTTYAu3aLEqqMpVvxc4iA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t6DrOjj0FCZYrDlIZ3TXUbEmWBAOdWAKz+m9TMRmS62PoH1G6152HZ7mOyTZdXGEO
	 jzEHzgkK/ATUibf1mbWGqabMqbtLpy6N0VilP8BqQskJEUFte2NoxK/2oHB8KOg70a
	 Edg+pDbTFgSCRCCx2nyKSKiK1Y3Aipa94rZOHGMqeKeDFFj54ydbx5nZXvekWDu3tw
	 S7RsPaPijcVP4fsvqQMHoiZy7TR5oktLnkZopA5n9Mp9k4JyeWp1j+IItqUsijCISO
	 Tdw8E0XmMlzWFjI13S53yDN5FY+OObgy55KbEIT6JZsOPUHuTWbpE4i+8fF3eYw3zp
	 FMjxLoVS1f3IQ==
Date: Mon, 29 Jul 2024 17:24:02 -0700
Subject: [PATCH 001/115] xfs: pass xfs_buf lookup flags to xfs_*read_agi
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842455.1338752.13548570121517004752.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 549d3c9a29921f388ef3bcfd1d4f669b7dd4eed2

Allow callers to pass buffer lookup flags to xfs_read_agi and
xfs_ialloc_read_agi.  This will be used in the next patch to fix a
deadlock in the online fsck inode scanner.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c              |    4 ++--
 libxfs/xfs_ag.c           |    8 ++++----
 libxfs/xfs_ialloc.c       |   16 ++++++++++------
 libxfs/xfs_ialloc.h       |    5 +++--
 libxfs/xfs_ialloc_btree.c |    4 ++--
 5 files changed, 21 insertions(+), 16 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3b..256c85560 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -117,7 +117,7 @@ dump_unlinked(
 	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 
-	error = -libxfs_ialloc_read_agi(pag, NULL, &agi_bp);
+	error = -libxfs_ialloc_read_agi(pag, NULL, 0, &agi_bp);
 	if (error) {
 		dbprintf(_("AGI %u: %s\n"), agno, strerror(errno));
 		return;
@@ -295,7 +295,7 @@ iunlink(
 	pag = libxfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = -libxfs_read_agi(pag, tp, &agibp);
+	error = -libxfs_read_agi(pag, tp, 0, &agibp);
 	if (error)
 		goto out;
 
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a9aae0990..ad721c192 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -192,7 +192,7 @@ xfs_initialize_perag_data(
 		pag = xfs_perag_get(mp, index);
 		error = xfs_alloc_read_agf(pag, NULL, 0, NULL);
 		if (!error)
-			error = xfs_ialloc_read_agi(pag, NULL, NULL);
+			error = xfs_ialloc_read_agi(pag, NULL, 0, NULL);
 		if (error) {
 			xfs_perag_put(pag);
 			return error;
@@ -929,7 +929,7 @@ xfs_ag_shrink_space(
 	int			error, err2;
 
 	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
-	error = xfs_ialloc_read_agi(pag, *tpp, &agibp);
+	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agibp);
 	if (error)
 		return error;
 
@@ -1060,7 +1060,7 @@ xfs_ag_extend_space(
 
 	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
 
-	error = xfs_ialloc_read_agi(pag, tp, &bp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &bp);
 	if (error)
 		return error;
 
@@ -1117,7 +1117,7 @@ xfs_ag_get_geometry(
 	int			error;
 
 	/* Lock the AG headers. */
-	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
+	error = xfs_ialloc_read_agi(pag, NULL, 0, &agi_bp);
 	if (error)
 		return error;
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agf_bp);
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c30e76830..992b8348a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1694,7 +1694,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
-		error = xfs_ialloc_read_agi(pag, tp, NULL);
+		error = xfs_ialloc_read_agi(pag, tp, 0, NULL);
 		if (error)
 			return false;
 	}
@@ -1763,7 +1763,7 @@ xfs_dialloc_try_ag(
 	 * Then read in the AGI buffer and recheck with the AGI buffer
 	 * lock held.
 	 */
-	error = xfs_ialloc_read_agi(pag, *tpp, &agbp);
+	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agbp);
 	if (error)
 		return error;
 
@@ -2281,7 +2281,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
 			__func__, error);
@@ -2327,7 +2327,7 @@ xfs_imap_lookup(
 	int			error;
 	int			i;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
@@ -2670,6 +2670,7 @@ int
 xfs_read_agi(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**agibpp)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -2679,7 +2680,7 @@ xfs_read_agi(
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+			XFS_FSS_TO_BB(mp, 1), flags, agibpp, &xfs_agi_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
@@ -2699,6 +2700,7 @@ int
 xfs_ialloc_read_agi(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
+	int			flags,
 	struct xfs_buf		**agibpp)
 {
 	struct xfs_buf		*agibp;
@@ -2707,7 +2709,9 @@ xfs_ialloc_read_agi(
 
 	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
 
-	error = xfs_read_agi(pag, tp, &agibp);
+	error = xfs_read_agi(pag, tp,
+			(flags & XFS_IALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
+			&agibp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index f1412183b..b549627e3 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
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
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 58c520ecb..5db9d0b33 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -744,7 +744,7 @@ xfs_finobt_count_blocks(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 
@@ -767,7 +767,7 @@ xfs_finobt_read_blocks(
 	struct xfs_agi		*agi;
 	int			error;
 
-	error = xfs_ialloc_read_agi(pag, tp, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
 	if (error)
 		return error;
 

