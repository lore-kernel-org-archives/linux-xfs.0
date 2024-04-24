Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1ED8627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929373; cv=none; b=RO4IbQh6L6a1CGZnmS1CrW9HuikOLsw92QZN4DY/SxvlwUhSlwaBP5wEQdcpbQrsdsbAuLIc4E3dc5ei4qAdDXl5TmH+bENrG+U6sG0R4wL2Tor6ETZVmiykVp5WmMsT+ges+K7ldxresZ8rmtkx5XUNGO02cU2xShvYHsITa2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929373; c=relaxed/simple;
	bh=CmuO/tybfY5D8ePB5oTLTs08AyFin1v4Nq/R2+iy32E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6PHQcn8GMzBRR8nn1ISnuESgPbqJpwxzaT6I43Tqc5AodrqzVXAtp+wX+NCI5TU9paLnzz7XXqW2xi+JCpGAqiyVsHj+z+IrW55fQ5SYMBcKT2fQioZS+4eUm8yStxFFz93Tt7V443c1rAUs525ZnW5hyGaA9nel65grTeObXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AliAtrpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AliAtrpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA82C116B1;
	Wed, 24 Apr 2024 03:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929373;
	bh=CmuO/tybfY5D8ePB5oTLTs08AyFin1v4Nq/R2+iy32E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AliAtrpPrHWvaxhHSk+S1vm+LHnquyEdBCvFbBDwJvemmrEL/fWTPId5kRrevuf+a
	 zYmPF4+R4SpXxzpYi4oHJAuWF9JJ4ffk5Aexd1wLaoGMZRWeoSAEKIakXSQ4wIHxwl
	 ob0rIJ2knBomqCraNiQeyWEZTCvfqMP3pBvtUs1cZLV4o39kYjI8ip6nBR6/k2Jr9W
	 cQ/x+VdzqNabH3DSR6mavizMCGgqK0XX8MnRE+ya4Ai4YKtgBrJ1DpArRqxylHncNI
	 zVEhe/SjeAfdMDhRSbNcmkzVwfh7APVlo/6CuGZvpXTcm2MLG4tIu8o8Mv/gwAv0Jp
	 z88lwTChlRNXQ==
Date: Tue, 23 Apr 2024 20:29:32 -0700
Subject: [PATCH 3/4] xfs: exchange-range for repairs is no longer dynamic
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786447.1907482.5418367725948531163.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
References: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
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

The atomic file exchange-range functionality is now a permanent
filesystem feature instead of a dynamic log-incompat feature.  It cannot
be turned on at runtime, so we no longer need the XCHK_FSGATES flags and
whatnot that supported it.  Remove the flag and the enable function, and
move the xfs_has_exchange_range checks to the start of the repair
functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr_repair.c      |    3 +++
 fs/xfs/scrub/dir_repair.c       |    3 +++
 fs/xfs/scrub/parent_repair.c    |   10 +++++++---
 fs/xfs/scrub/rtsummary_repair.c |   10 ++++------
 fs/xfs/scrub/scrub.c            |    8 +++-----
 fs/xfs/scrub/scrub.h            |    7 -------
 fs/xfs/scrub/symlink_repair.c   |    3 +++
 fs/xfs/scrub/tempexch.h         |    1 -
 fs/xfs/scrub/tempfile.c         |   24 ++----------------------
 fs/xfs/scrub/trace.h            |    1 -
 10 files changed, 25 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index e059813b92b7..c7eb94069caf 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1630,6 +1630,9 @@ xrep_xattr(
 	/* The rmapbt is required to reap the old attr fork. */
 	if (!xfs_has_rmapbt(sc->mp))
 		return -EOPNOTSUPP;
+	/* We require atomic file exchange range to rebuild anything. */
+	if (!xfs_has_exchange_range(sc->mp))
+		return -EOPNOTSUPP;
 
 	error = xrep_xattr_setup_scan(sc, &rx);
 	if (error)
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index e968150fe0f0..6ad40f8aafb8 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1993,6 +1993,9 @@ xrep_directory(
 	/* The rmapbt is required to reap the old data fork. */
 	if (!xfs_has_rmapbt(sc->mp))
 		return -EOPNOTSUPP;
+	/* We require atomic file exchange range to rebuild anything. */
+	if (!xfs_has_exchange_range(sc->mp))
+		return -EOPNOTSUPP;
 
 	error = xrep_dir_setup_scan(rd);
 	if (error)
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index ee88ce5a12b8..7b42b7f65a0b 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1571,10 +1571,14 @@ xrep_parent(
 	/*
 	 * When the parent pointers feature is enabled, repairs are committed
 	 * by atomically committing a new xattr structure and reaping the old
-	 * attr fork.  Reaping requires rmap to be enabled.
+	 * attr fork.  Reaping requires rmap and exchange-range to be enabled.
 	 */
-	if (xfs_has_parent(sc->mp) && !xfs_has_rmapbt(sc->mp))
-		return -EOPNOTSUPP;
+	if (xfs_has_parent(sc->mp)) {
+		if (!xfs_has_rmapbt(sc->mp))
+			return -EOPNOTSUPP;
+		if (!xfs_has_exchange_range(sc->mp))
+			return -EOPNOTSUPP;
+	}
 
 	error = xrep_parent_setup_scan(rp);
 	if (error)
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index c8bb6c4f15d0..d9e971c4c79f 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -62,12 +62,7 @@ xrep_setup_rtsummary(
 		return -EOPNOTSUPP;
 
 	rts->resblks += blocks;
-
-	/*
-	 * Grab support for atomic file content exchanges before we allocate
-	 * any transactions or grab ILOCKs.
-	 */
-	return xrep_tempexch_enable(sc);
+	return 0;
 }
 
 static int
@@ -111,6 +106,9 @@ xrep_rtsummary(
 	/* We require the rmapbt to rebuild anything. */
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
+	/* We require atomic file exchange range to rebuild anything. */
+	if (!xfs_has_exchange_range(mp))
+		return -EOPNOTSUPP;
 
 	/* Walk away if we disagree on the size of the rt bitmap. */
 	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 43af5ce1f99f..c013f0ba4f36 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -154,15 +154,14 @@ xchk_probe(
 
 /* Scrub setup and teardown */
 
-#define FSGATES_MASK	(XCHK_FSGATES_ALL | XREP_FSGATES_ALL)
 static inline void
 xchk_fsgates_disable(
 	struct xfs_scrub	*sc)
 {
-	if (!(sc->flags & FSGATES_MASK))
+	if (!(sc->flags & XCHK_FSGATES_ALL))
 		return;
 
-	trace_xchk_fsgates_disable(sc, sc->flags & FSGATES_MASK);
+	trace_xchk_fsgates_disable(sc, sc->flags & XCHK_FSGATES_ALL);
 
 	if (sc->flags & XCHK_FSGATES_DRAIN)
 		xfs_drain_wait_disable();
@@ -176,9 +175,8 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_RMAP)
 		xfs_rmap_hook_disable();
 
-	sc->flags &= ~FSGATES_MASK;
+	sc->flags &= ~XCHK_FSGATES_ALL;
 }
-#undef FSGATES_MASK
 
 /* Free the resources associated with a scrub subtype. */
 void
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1da10182f7f4..1bc33f010d0e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -188,7 +188,6 @@ struct xfs_scrub {
 #define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1U << 5)  /* directory live update enabled */
 #define XCHK_FSGATES_RMAP	(1U << 6)  /* rmapbt live update enabled */
-#define XREP_FSGATES_EXCHANGE_RANGE (1U << 29) /* uses file content exchange */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -203,12 +202,6 @@ struct xfs_scrub {
 				 XCHK_FSGATES_DIRENTS | \
 				 XCHK_FSGATES_RMAP)
 
-/*
- * The sole XREP_FSGATES* flag reflects a log intent item that is protected
- * by a log-incompat feature flag.  No code patching in use here.
- */
-#define XREP_FSGATES_ALL	(XREP_FSGATES_EXCHANGE_RANGE)
-
 struct xfs_scrub_subord {
 	struct xfs_scrub	sc;
 	struct xfs_scrub	*parent_sc;
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index c8b5a5b878ac..d015a86ef460 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -490,6 +490,9 @@ xrep_symlink(
 	/* The rmapbt is required to reap the old data fork. */
 	if (!xfs_has_rmapbt(sc->mp))
 		return -EOPNOTSUPP;
+	/* We require atomic file exchange range to rebuild anything. */
+	if (!xfs_has_exchange_range(sc->mp))
+		return -EOPNOTSUPP;
 
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
 
diff --git a/fs/xfs/scrub/tempexch.h b/fs/xfs/scrub/tempexch.h
index c1dd4adec4f1..995ba187c5aa 100644
--- a/fs/xfs/scrub/tempexch.h
+++ b/fs/xfs/scrub/tempexch.h
@@ -11,7 +11,6 @@ struct xrep_tempexch {
 	struct xfs_exchmaps_req	req;
 };
 
-int xrep_tempexch_enable(struct xfs_scrub *sc);
 int xrep_tempexch_trans_reserve(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempexch *ti);
 int xrep_tempexch_trans_alloc(struct xfs_scrub *sc, int whichfork,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index ddbcccb3dba1..b747b625c5ee 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -486,23 +486,6 @@ xrep_tempfile_roll_trans(
 	return 0;
 }
 
-/* Enable file content exchanges. */
-int
-xrep_tempexch_enable(
-	struct xfs_scrub	*sc)
-{
-	if (sc->flags & XREP_FSGATES_EXCHANGE_RANGE)
-		return 0;
-
-	if (!xfs_has_exchange_range(sc->mp))
-		return -EOPNOTSUPP;
-
-	trace_xchk_fsgates_enable(sc, XREP_FSGATES_EXCHANGE_RANGE);
-
-	sc->flags |= XREP_FSGATES_EXCHANGE_RANGE;
-	return 0;
-}
-
 /*
  * Fill out the mapping exchange request in preparation for atomically
  * committing the contents of a metadata file that we've rebuilt in the temp
@@ -745,6 +728,7 @@ xrep_tempexch_trans_alloc(
 	int			error;
 
 	ASSERT(sc->tp == NULL);
+	ASSERT(xfs_has_exchange_range(sc->mp));
 
 	error = xrep_tempexch_prep_request(sc, whichfork, tx);
 	if (error)
@@ -757,10 +741,6 @@ xrep_tempexch_trans_alloc(
 	if (xfs_has_lazysbcount(sc->mp))
 		flags |= XFS_TRANS_RES_FDBLKS;
 
-	error = xrep_tempexch_enable(sc);
-	if (error)
-		return error;
-
 	error = xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
 			tx->req.resblks, 0, flags, &sc->tp);
 	if (error)
@@ -785,7 +765,7 @@ xrep_tempexch_contents(
 {
 	int			error;
 
-	ASSERT(sc->flags & XREP_FSGATES_EXCHANGE_RANGE);
+	ASSERT(xfs_has_exchange_range(sc->mp));
 
 	xfs_exchange_mappings(sc->tp, &tx->req);
 	error = xfs_defer_finish(&sc->tp);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8ce74bd8530a..4b945007ca6c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -122,7 +122,6 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
-	{ XREP_FSGATES_EXCHANGE_RANGE,		"fsgates_exchrange" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

