Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E7495AE5
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871877; cv=none; b=JSyYEW5agcAH+3ODOObrehKzRqKHIxfTQPM7zdHccMjiUkwrcqwd6lyIy2b/GoJ9T4UXpNepaGSYAmTcmz26kfxkhhytfGTouRhIior3J5OreAkqpY87Uz0Q5M9RoRHaLJ7vjYqs7qdeH2rwUxfBo0z7w0rRR6OiIsavMGTQtHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871877; c=relaxed/simple;
	bh=AAOaQsGdnuTp9npB94/ETtx41OsAvW1bhDVNhrwa8Cg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOkCYC2m8vmTJjK40RzXt4mVf2dOanElOCNkl+JEPT534i6tc2Onmqr/9INSz5woZa3YWkT3Ijh5JpycVaHkfKdq+qdGUnYH+eQb4Vd9kRex7me26onR1FW/cQHIZ2rOOyp3PdLYmKLUrfl/Lo3vYabnPVnFTCVTioGG/Y2L0RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxlHYjJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxlHYjJA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFC131F00893;
	Tue, 13 Oct 2026 06:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871872;
	bh=lup636Z2xi5vTxbSLNcHTm9lHcwxsEZ3SYBNOyYpK0g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AxlHYjJAhPVUY47bNiLf+38kMRoqPTZhVwV3WjoWcPWrpOnLE0t9b8+6imuAyDAsy
	 JQ6UMY0nmmm4ncq86E2FJ2W5JNg7oG4CfKZ5aLPewnkMr0pi3ExV3sw9cqPiieAuGn
	 WgHwqmNpC4a2P2queuy0QCt5HbpzQ2Yuvz8A2zUXJrDhqDQNjMtpz/j8pEezTurh14
	 hgQ87NVs9QphJW5oPxOyyNMBpX4DCTG8AsK24uIfqAPrHS4TvLD+WEVkI9izJlVH6q
	 4g2BXzmRvv9jJItPXQETnVYqKWloTBgQH7FCIm+Ub+0qoMgt8Ea9jjmN4+LUAVvq3U
	 q6So5cy1WkqNg==
Date: Mon, 12 Oct 2026 23:11:12 -0700
Subject: [PATCH 11/12] xfs: drop unnecessary sr parameter from xchk_rtgroup
 init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186108084.1898896.11891990362054361084.stgit@frogsfrogsfrogs>
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

Drop the sr parameter from the scrub rtgroup functions because the value
is always the same.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h            |   29 +++++++++++++----------------
 fs/xfs/scrub/bmap.c              |    9 ++++-----
 fs/xfs/scrub/bmap_repair.c       |    4 ++--
 fs/xfs/scrub/common.c            |   22 ++++++++++++++--------
 fs/xfs/scrub/cow_repair.c        |    4 ++--
 fs/xfs/scrub/inode_repair.c      |    4 ++--
 fs/xfs/scrub/repair.c            |    2 +-
 fs/xfs/scrub/rgsuper.c           |    4 ++--
 fs/xfs/scrub/rtbitmap.c          |    4 ++--
 fs/xfs/scrub/rtbitmap_repair.c   |    2 +-
 fs/xfs/scrub/rtrefcount.c        |    4 ++--
 fs/xfs/scrub/rtrefcount_repair.c |    2 +-
 fs/xfs/scrub/rtrmap.c            |    4 ++--
 fs/xfs/scrub/rtrmap_repair.c     |    6 +++---
 fs/xfs/scrub/rtsummary.c         |    4 ++--
 fs/xfs/scrub/scrub.c             |    4 ++--
 16 files changed, 55 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8478f3a9bed33d..181028f0c65526 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -135,32 +135,29 @@ xchk_ag_init_existing(
 				 XFS_RTGLOCK_RMAP | \
 				 XFS_RTGLOCK_REFCOUNT)
 
-int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
-		struct xchk_rt *sr);
+int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno);
 
 static inline int
 xchk_rtgroup_init_existing(
 	struct xfs_scrub	*sc,
-	xfs_rgnumber_t		rgno,
-	struct xchk_rt		*sr)
+	xfs_rgnumber_t		rgno)
 {
-	int			error = xchk_rtgroup_init(sc, rgno, sr);
+	int			error = xchk_rtgroup_init(sc, rgno);
 
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
-int xchk_rtgroup_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
-		unsigned int rtglock_flags);
-void xchk_rtgroup_unlock(struct xchk_rt *sr);
-void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
-void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+int xchk_rtgroup_lock(struct xfs_scrub *sc, unsigned int rtglock_flags);
+void xchk_rtgroup_unlock(struct xfs_scrub *sc);
+void xchk_rtgroup_btcur_free(struct xfs_scrub *sc);
+void xchk_rtgroup_free(struct xfs_scrub *sc);
 #else
-# define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
-# define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
-# define xchk_rtgroup_lock(sc, sr, lockflags)		(-EFSCORRUPTED)
-# define xchk_rtgroup_unlock(sr)			do { } while (0)
-# define xchk_rtgroup_btcur_free(sr)			do { } while (0)
-# define xchk_rtgroup_free(sc, sr)			do { } while (0)
+# define xchk_rtgroup_init(sc, rgno)			(-EFSCORRUPTED)
+# define xchk_rtgroup_init_existing(sc, rgno)		(-EFSCORRUPTED)
+# define xchk_rtgroup_lock(sc, lockflags)		(-EFSCORRUPTED)
+# define xchk_rtgroup_unlock(sc)			do { } while (0)
+# define xchk_rtgroup_btcur_free(sc)			do { } while (0)
+# define xchk_rtgroup_free(sc)				do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 8447f711ca2c51..3c543f77cf6de5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -329,13 +329,12 @@ xchk_bmap_rt_iextent_xref(
 	int			error;
 
 	error = xchk_rtgroup_init_existing(info->sc,
-			xfs_rtb_to_rgno(ip->i_mount, irec->br_startblock),
-			&info->sc->sr);
+			xfs_rtb_to_rgno(ip->i_mount, irec->br_startblock));
 	if (!xchk_fblock_process_error(info->sc, info->whichfork,
 			irec->br_startoff, &error))
 		return;
 
-	error = xchk_rtgroup_lock(info->sc, &info->sc->sr, XCHK_RTGLOCK_ALL);
+	error = xchk_rtgroup_lock(info->sc, XCHK_RTGLOCK_ALL);
 	if (!xchk_fblock_process_error(info->sc, info->whichfork,
 			irec->br_startoff, &error))
 		goto out_free;
@@ -373,9 +372,9 @@ xchk_bmap_rt_iextent_xref(
 		break;
 	}
 out_cur:
-	xchk_rtgroup_btcur_free(&info->sc->sr);
+	xchk_rtgroup_btcur_free(info->sc);
 out_free:
-	xchk_rtgroup_free(info->sc, &info->sc->sr);
+	xchk_rtgroup_free(info->sc);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 4d9ac54d5dfc11..85e677d8a77674 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -463,8 +463,8 @@ xrep_bmap_scan_rtgroup(
 		return error;
 
 	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_bmap_walk_rtrmap, rb);
-	xchk_rtgroup_btcur_free(&sc->sr);
-	xchk_rtgroup_free(sc, &sc->sr);
+	xchk_rtgroup_btcur_free(sc);
+	xchk_rtgroup_free(sc);
 	return error;
 }
 #else
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 82cda70e4169ae..cbfe5e6f779dfc 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -730,9 +730,10 @@ xchk_ag_init(
 int
 xchk_rtgroup_init(
 	struct xfs_scrub	*sc,
-	xfs_rgnumber_t		rgno,
-	struct xchk_rt		*sr)
+	xfs_rgnumber_t		rgno)
 {
+	struct xchk_rt		*sr = &sc->sr;
+
 	ASSERT(sr->rtg == NULL);
 	ASSERT(sr->rtlock_flags == 0);
 
@@ -746,9 +747,9 @@ xchk_rtgroup_init(
 int
 xchk_rtgroup_lock(
 	struct xfs_scrub	*sc,
-	struct xchk_rt		*sr,
 	unsigned int		rtglock_flags)
 {
+	struct xchk_rt		*sr = &sc->sr;
 	int			error = 0;
 
 	ASSERT(sr->rtg != NULL);
@@ -831,8 +832,10 @@ xchk_rtgroup_lock(
  */
 void
 xchk_rtgroup_btcur_free(
-	struct xchk_rt		*sr)
+	struct xfs_scrub	*sc)
 {
+	struct xchk_rt		*sr = &sc->sr;
+
 	if (sr->rmap_cur)
 		xfs_btree_del_cursor(sr->rmap_cur, XFS_BTREE_ERROR);
 	if (sr->refc_cur)
@@ -848,8 +851,10 @@ xchk_rtgroup_btcur_free(
  */
 void
 xchk_rtgroup_unlock(
-	struct xchk_rt		*sr)
+	struct xfs_scrub	*sc)
 {
+	struct xchk_rt		*sr = &sc->sr;
+
 	ASSERT(sr->rtg != NULL);
 
 	if (sr->rtlock_flags) {
@@ -864,12 +869,13 @@ xchk_rtgroup_unlock(
  */
 void
 xchk_rtgroup_free(
-	struct xfs_scrub	*sc,
-	struct xchk_rt		*sr)
+	struct xfs_scrub	*sc)
 {
+	struct xchk_rt		*sr = &sc->sr;
+
 	ASSERT(sr->rtg != NULL);
 
-	xchk_rtgroup_unlock(sr);
+	xchk_rtgroup_unlock(sc);
 
 	xfs_rtgroup_put(sr->rtg);
 	sr->rtg = NULL;
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 5a209194ba97eb..2b1d1701cb539f 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -433,8 +433,8 @@ xrep_cow_find_bad_rt(
 				xc->irec.br_blockcount);
 
 out_sr:
-	xchk_rtgroup_btcur_free(&sc->sr);
-	xchk_rtgroup_free(sc, &sc->sr);
+	xchk_rtgroup_btcur_free(sc);
+	xchk_rtgroup_free(sc);
 out_rtg:
 	xfs_rtgroup_put(rtg);
 	return error;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 599f0f527e1a96..a42ce1d014dfb3 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -822,8 +822,8 @@ xrep_dinode_count_rtgroup_rmaps(
 
 	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_dinode_walk_rtrmap,
 			ri);
-	xchk_rtgroup_btcur_free(&sc->sr);
-	xchk_rtgroup_free(sc, &sc->sr);
+	xchk_rtgroup_btcur_free(sc);
+	xchk_rtgroup_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 32bd8259cedb65..5827717f0d460f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -69,7 +69,7 @@ xrep_attempt(
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
 
 	xchk_ag_btcur_free(sc);
-	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_btcur_free(sc);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 102bd92e9003db..591c5767208e6e 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -65,7 +65,7 @@ xchk_rgsuperblock(
 	 * signal that the group no longer exists.  Take the rtbitmap in shared
 	 * mode so that the group can't change while we're doing things.
 	 */
-	error = xchk_rtgroup_init_existing(sc, rgno, &sc->sr);
+	error = xchk_rtgroup_init_existing(sc, rgno);
 	if (!xchk_xref_process_error(sc, 0, 0, &error))
 		return error;
 
@@ -74,7 +74,7 @@ xchk_rgsuperblock(
 	else
 		flags = XFS_RTGLOCK_BITMAP_SHARED;
 
-	error = xchk_rtgroup_lock(sc, &sc->sr, flags);
+	error = xchk_rtgroup_lock(sc, flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 52c24d3d4be6ce..88a53c6ed6c531 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -48,7 +48,7 @@ xchk_setup_rtbitmap(
 	sc->buf = rtb;
 	rtb->sc = sc;
 
-	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno);
 	if (error)
 		return error;
 
@@ -70,7 +70,7 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	error = xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	error = xchk_rtgroup_lock(sc, XCHK_RTGLOCK_ALL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 3f918da62d4ced..f8a86596d4bab8 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -357,7 +357,7 @@ xrep_rtbitmap_find_freespace(
 	}
 
 out:
-	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_btcur_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 824783e4f0e193..b8f5a5f9fd01d2 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -42,7 +42,7 @@ xchk_setup_rtrefcountbt(
 			return error;
 	}
 
-	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno);
 	if (error)
 		return error;
 
@@ -54,7 +54,7 @@ xchk_setup_rtrefcountbt(
 	if (error)
 		return error;
 
-	return xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	return xchk_rtgroup_lock(sc, XCHK_RTGLOCK_ALL);
 }
 
 /* Realtime Reference count btree scrubber. */
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 2e773febffd78e..817c2b8f49ab6c 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -545,7 +545,7 @@ xrep_rtrefc_find_refcounts(
 out_bag:
 	rcbag_free(&rcstack);
 out_cur:
-	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_btcur_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 564d19a97a2f8f..85cc0513d688c9 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -46,7 +46,7 @@ xchk_setup_rtrmapbt(
 			return error;
 	}
 
-	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno);
 	if (error)
 		return error;
 
@@ -58,7 +58,7 @@ xchk_setup_rtrmapbt(
 	if (error)
 		return error;
 
-	return xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	return xchk_rtgroup_lock(sc, XCHK_RTGLOCK_ALL);
 }
 
 /* Realtime reverse mapping. */
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 726ef89ab2f10b..6a10463de20021 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -556,7 +556,7 @@ xrep_rtrmap_find_rmaps(
 	/* Find CoW staging extents. */
 	xrep_rtgroup_btcur_init(sc);
 	error = xrep_rtrmap_find_refcount_rmaps(rr);
-	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_btcur_free(sc);
 	if (error)
 		return error;
 
@@ -576,7 +576,7 @@ xrep_rtrmap_find_rmaps(
 	 * do not take sb_internal.
 	 */
 	xchk_trans_cancel(sc);
-	xchk_rtgroup_unlock(&sc->sr);
+	xchk_rtgroup_unlock(sc);
 	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
@@ -600,7 +600,7 @@ xrep_rtrmap_find_rmaps(
 	error = xchk_setup_rt(sc);
 	if (error)
 		return error;
-	error = xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	error = xchk_rtgroup_lock(sc, XCHK_RTGLOCK_ALL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index fa358746beaf5c..b72c27ef45acbb 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -54,7 +54,7 @@ xchk_setup_rtsummary(
 		return -ENOMEM;
 	sc->buf = rts;
 
-	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno);
 	if (error)
 		return error;
 
@@ -85,7 +85,7 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	error = xchk_rtgroup_lock(sc, &sc->sr, XFS_RTGLOCK_BITMAP);
+	error = xchk_rtgroup_lock(sc, XFS_RTGLOCK_BITMAP);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9dbd16546e8c8b..4a2d9bdc087b5f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -230,7 +230,7 @@ xchk_teardown(
 	int			error)
 {
 	xchk_ag_free(sc);
-	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_btcur_free(sc);
 
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -240,7 +240,7 @@ xchk_teardown(
 		sc->tp = NULL;
 	}
 	if (sc->sr.rtg)
-		xchk_rtgroup_free(sc, &sc->sr);
+		xchk_rtgroup_free(sc);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);

