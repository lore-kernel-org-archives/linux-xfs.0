Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34881A6816
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 06:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784873; cv=none; b=g4ngTfFpNHK0rNqMlrj1k/WgVIbq1spUd/JGEOUrmLUa9pB9WwFbk8k1ghLqZ/358X7uTmGwRhpxHJF/cWLiEjXlMyJq0q0830J9iFuL+67YWtpVs3SILO+YDISPLpylfbph+7fx8+YvhWh6VjlscVlerr/x8/ZDigSiALC2tLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784873; c=relaxed/simple;
	bh=8+rQEcrhWndfwCNC8ccv0B/MzhtIplADopxV8f7K3kw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6lpI4f0Jm+hiylZUi0xs4oVEwrdxWtN5UnbL2lKKVZgOIennLivlK0g29J8F9s3OcYJCRuusKSPaQpUz/IAj2Xve/fr9bSUDUZzzBQBbbayBGJrJY+FqVvPxMkn4qF6RYiizLqukgMB6WSM1q8HoR+RtU2ZFHwjA+txQ40jfOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GM8xieN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GM8xieN1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A97221F0089B;
	Mon, 12 Oct 2026 06:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784872;
	bh=DCtcJQNYyccMgylvvpCiEw5zZ2Wyo3F1LHNjrM8hV4k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GM8xieN1MDvaq3Bj77LDWbsY7dx51L+UnocaOv3n3AK6Bcd7awDqwT8qZgx/+vM/c
	 k7OYb8ecpEZ5zf1VFAGzCdfB8b39p2i2okEriljDFTxt/LjjkoX4Mt5ILVvsl5nP74
	 2rbkxRtlWRZtFrEHyDMMtT3HU0JaupapsLNKj9Sfu8bBZ4zh+o5RlSqfrAmglqjDuN
	 3gxqFvlBFE8jDMfmrWQSpnr1yXa2BGDlBQEjGQlcemNO7nSnn2AA5xkBhq+2Oh6prM
	 6P/mVEylTV1BR4cA6zM6tICouzdmcbrGpeg/Fk0FPKz2jyL6Bc/i8faW/SEFYttjmt
	 LIQyK37TxaIfQ==
Date: Sun, 11 Oct 2026 23:01:12 -0700
Subject: [PATCH 09/12] xfs: drop unnecessary sr parameter from xrep_rtgroup
 init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179178065991.1058822.9052075441979843165.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Similar to the last patch, drop this unnecessary sr parameter instead of
dealing with pointer aliasing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/repair.h            |    6 +++---
 fs/xfs/scrub/bmap_repair.c       |    7 +++----
 fs/xfs/scrub/cow_repair.c        |    4 ++--
 fs/xfs/scrub/inode_repair.c      |    2 +-
 fs/xfs/scrub/repair.c            |    9 +++++----
 fs/xfs/scrub/rtbitmap_repair.c   |    2 +-
 fs/xfs/scrub/rtrefcount_repair.c |    2 +-
 fs/xfs/scrub/rtrmap_repair.c     |    2 +-
 8 files changed, 17 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a32fd9fb59bdae..421b48de7667d5 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -104,13 +104,13 @@ void xrep_ag_btcur_init(struct xfs_scrub *sc);
 int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag);
 #ifdef CONFIG_XFS_RT
 int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
-		struct xchk_rt *sr, unsigned int rtglock_flags);
-void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
+		unsigned int rtglock_flags);
+void xrep_rtgroup_btcur_init(struct xfs_scrub *sc);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_filblks_t len);
 xfs_extlen_t xrep_calc_rtgroup_resblks(struct xfs_scrub *sc);
 #else
-# define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
+# define xrep_rtgroup_init(sc, rtg, lockflags)		(-ENOSYS)
 # define xrep_calc_rtgroup_resblks(sc)			(0)
 #endif /* CONFIG_XFS_RT */
 
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 7288940b74e6c1..5b422f5e13c21c 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -456,10 +456,9 @@ xrep_bmap_scan_rtgroup(
 	if (!xfs_has_rtrmapbt(sc->mp))
 		return 0;
 
-	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
-			XFS_RTGLOCK_RMAP |
-			XFS_RTGLOCK_REFCOUNT |
-			XFS_RTGLOCK_BITMAP_SHARED);
+	error = xrep_rtgroup_init(sc, rtg, XFS_RTGLOCK_RMAP |
+					   XFS_RTGLOCK_REFCOUNT |
+					   XFS_RTGLOCK_BITMAP_SHARED);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 3d4e94757de040..f2e650c6f7afdf 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -371,8 +371,8 @@ xrep_cow_find_bad_rt(
 	if (!rtg)
 		return -EFSCORRUPTED;
 
-	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
-			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
+	error = xrep_rtgroup_init(sc, rtg, XFS_RTGLOCK_RMAP |
+					   XFS_RTGLOCK_REFCOUNT);
 	if (error)
 		goto out_rtg;
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 25e71e7d472f36..599f0f527e1a96 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -816,7 +816,7 @@ xrep_dinode_count_rtgroup_rmaps(
 	struct xfs_scrub	*sc = ri->sc;
 	int			error;
 
-	error = xrep_rtgroup_init(sc, rtg, &sc->sr, XFS_RTGLOCK_RMAP);
+	error = xrep_rtgroup_init(sc, rtg, XFS_RTGLOCK_RMAP);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 19c582223efe42..88494e79340ef8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1015,10 +1015,10 @@ xrep_ag_init(
 /* Initialize all the btree cursors for a RT repair. */
 void
 xrep_rtgroup_btcur_init(
-	struct xfs_scrub	*sc,
-	struct xchk_rt		*sr)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rt		*sr = &sc->sr;
 
 	ASSERT(sr->rtg != NULL);
 
@@ -1041,9 +1041,10 @@ int
 xrep_rtgroup_init(
 	struct xfs_scrub	*sc,
 	struct xfs_rtgroup	*rtg,
-	struct xchk_rt		*sr,
 	unsigned int		rtglock_flags)
 {
+	struct xchk_rt		*sr = &sc->sr;
+
 	ASSERT(sr->rtg == NULL);
 
 	xfs_rtgroup_lock(rtg, rtglock_flags);
@@ -1051,7 +1052,7 @@ xrep_rtgroup_init(
 
 	/* Grab our own passive reference from the caller's ref. */
 	sr->rtg = xfs_rtgroup_hold(rtg);
-	xrep_rtgroup_btcur_init(sc, sr);
+	xrep_rtgroup_btcur_init(sc);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index f63aaaff783d50..3f918da62d4ced 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -339,7 +339,7 @@ xrep_rtbitmap_find_freespace(
 	/* Prepare a buffer of ones so that we can accelerate bulk setting. */
 	memset(rtb->words, 0xFF, mp->m_sb.sb_blocksize);
 
-	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	xrep_rtgroup_btcur_init(sc);
 	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_rtbitmap_walk_rtrmap,
 			rtb);
 	if (error)
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index b307ea15197090..e7f6d71695fd68 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -453,7 +453,7 @@ xrep_rtrefc_find_refcounts(
 		}
 	}
 
-	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	xrep_rtgroup_btcur_init(sc);
 
 	/*
 	 * Set up a bag to store all the rmap records that we're tracking to
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 6b435acc2d69ff..755675460cb8a4 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -554,7 +554,7 @@ xrep_rtrmap_find_rmaps(
 	}
 
 	/* Find CoW staging extents. */
-	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	xrep_rtgroup_btcur_init(sc);
 	error = xrep_rtrmap_find_refcount_rmaps(rr);
 	xchk_rtgroup_btcur_free(&sc->sr);
 	if (error)

