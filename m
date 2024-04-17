Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904F3FBAF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395695; cv=none; b=CXs2CWFO2kiT8sBqxeyjFugci17pk95RcK8p0svcl4T/1N4luX0teuFY/9tvA3eZTEZ1YsgFe89GOepI8jOmZmPMkPVMzjtYdg8T4MYfzeXXpofCxUl7+vZAQWWXl5RFQeYhBKcDlmqrCkcD95zI7kzJ5Ah15Q7YbKyF4L0nLjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395695; c=relaxed/simple;
	bh=XWxKlW6UWOnVzLmFpTZDOU1mFv7Uuf0xAxvUHamtL+M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2/YTG9c0esw8mTpS9K2iJKsqZVILPBxrYKATB5jHxeuBjhfHrWSJJ1Qal1sflJf2+F+Z95viO/sLimyJidPMhgHgCtIPuA9zQ2a5AwJm0CccUYSakdsgDLzPmBL3aDEkxyQswrIYUsZmlyJKFAifKyUp1w6TVKcw/p9JwejJ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SD3d4xgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SD3d4xgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDADC072AA;
	Wed, 17 Apr 2024 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395695;
	bh=XWxKlW6UWOnVzLmFpTZDOU1mFv7Uuf0xAxvUHamtL+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SD3d4xgVA38FDGFyZapif/1uWwJ69jJCPh0xZHwx3x0FhQGLK1rhESTHYqrApzCjC
	 XI3I6iojzcpYKI+MbUfzD+EaoSQ4SoBy8qRsnTUv4qyx5ewwsJ+Hk6l/F7CB/ssd14
	 fjuQzuAUyS2jU2obZ6LhGTdyn0TWuKW7zVaRe9NMmVve1iF06W4wzg7YR1ZZ6GB9Fa
	 Xbv5Ucvrq79Jb8gKO4pn7e4uLZkFoYzwmbgLwn9xuFWnYbDJbLFmThQtD9a5knj6O2
	 FHbainKBnQxjh5TATCb6wtOwqwBUprwiSjSqzJ2dkRRK8F9krXBHMp4ZjNlN2kzuhO
	 g1hMnaz9xeU8g==
Date: Wed, 17 Apr 2024 16:14:54 -0700
Subject: [PATCH 3/4] xfs: exchange-range for repairs is no longer dynamic
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339556011.2000000.12744010747635397134.stgit@frogsfrogsfrogs>
In-Reply-To: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
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
index e059813b92b70..c7eb94069cafc 100644
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
index e968150fe0f06..6ad40f8aafb82 100644
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
index ee88ce5a12b83..7b42b7f65a0bd 100644
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
index c8bb6c4f15d05..d9e971c4c79fb 100644
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
index 43af5ce1f99f0..c013f0ba4f36b 100644
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
index 1da10182f7f42..1bc33f010d0e7 100644
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
index c8b5a5b878ac9..d015a86ef460f 100644
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
index c1dd4adec4f11..995ba187c5aa6 100644
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
index ddbcccb3dba13..b747b625c5ee4 100644
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
index 8ce74bd8530a6..4b945007ca6ca 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -122,7 +122,6 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
-	{ XREP_FSGATES_EXCHANGE_RANGE,		"fsgates_exchrange" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

