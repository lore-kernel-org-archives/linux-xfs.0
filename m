Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BE04915BE
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871843; cv=none; b=u3ulKSLnuW6BswBOBzI9adUPM6vahb33dp2ta+8IYB3I7V3qW6Vm+NRFxPjWDyVyy3JZ00PTT5PHrxFUOWp3BupamK7xx3BJj0gAtcHII15D+5MS72ieuM8ZQ/vwpvcED6VZVVANKmHjlGepwwftpLeOis6qQXO0/2WKf/RF9pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871843; c=relaxed/simple;
	bh=NTiA/Y0SX8+iQusdGKhvsjI0SPMmGrKlkRdc4t9/WaU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AML7aQwikgRi4EcfuksqxBoi6taZTT7aorv6MYasqJxHq94kyfhdcE2G4dTm/OmD6GjTJDo2xQMTffWR1xS+UCrKQGZ96q6vhHIJ/WBuTjh3kKH6Q7teqlvqLWkEk8lkJR/0/HCGR3Hs7Dmw4CaCY6CMgEAVv7q2CHqvbInqBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNkHqKQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNkHqKQC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 616DF1F000FF;
	Tue, 13 Oct 2026 06:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871841;
	bh=S/ciriF7VrZTD0r+RLbcXjBXXHiSrEguo6uvTuE0vfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oNkHqKQCtt9wV3WUwNCmB+hSZixorjoXrtqVPJSKKk3bwKMxkLL25LDFwU/zji8dV
	 Sl12Vt+LecouPru9f9U4+lCxV9aEushKGIMkCbdBn3JCK/LciegNlEiurQsg8mTTGS
	 SDVMN2wqot/uiVM2+H8ZdgT+C84Dd9oY9xZffI0n/GlmBKER5S9miX4UnnrKCWW7QB
	 Cg+t0drCBi9SrgTTY9cQoBFq7zkSbqlpiecMA6sC77prQ3iJsXwGOZng0Xi/TA5fCR
	 iXQWOPeYkHXMFZOK+uYfcYh2H//DuIVds8AU5coIDwRQxGqmMtFYSI5OmD9YT0hEOx
	 w4rRVyjPVLpVw==
Date: Mon, 12 Oct 2026 23:10:40 -0700
Subject: [PATCH 09/12] xfs: drop unnecessary sr parameter from xrep_rtgroup
 init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186108038.1898896.16661318971863250619.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

