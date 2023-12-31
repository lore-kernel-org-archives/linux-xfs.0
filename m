Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A0BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/6Kifk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881B5C433C8;
	Sun, 31 Dec 2023 21:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058730;
	bh=aVaFy32h38MRsmD4OUjtLCoIg8kyU1wx9vIp1kySICk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G/6Kifk26qUsALhwRbekXAm+PaqTYp5eCnYAAn1UPd50dfKuVaRaIOsrOjjH0PWbB
	 Ra6qHIbdtn9X62U02jQrbQzUs4RqsLF8BojPeWKMsPQaJkd25fTeDrORYRivVFfoMF
	 shvPO0k4YIfPO57j3eAcgV6kDVwWi4/FeBNgrYobm0uAawtesROEsK+a8oK0rtIvOv
	 7mBWKl9PuKYlYf5P3BPfMfHs+CM+Hd9dtpZrxBvoL5VGEo3RHXCZLw6z1mZj1QLIVQ
	 mfrpAEudsGVzpitSqb8xYoo8/VzvbPdDI7qVvQ/Z7m0zCT24b5i5g4CnSVgV6Oql7v
	 NZ2PoasOvq3Eg==
Date: Sun, 31 Dec 2023 13:38:50 -0800
Subject: [PATCH 27/39] xfs: cross-reference the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850335.1764998.14778110195238361933.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Teach the data fork and realtime bitmap scrubbers to cross-reference
information with the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c     |   72 ++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/scrub/rtbitmap.c |   58 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtbitmap.h |    3 ++
 fs/xfs/scrub/rtrmap.c   |   65 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    9 ++++++
 5 files changed, 190 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 8fa51350facc4..604c4df2fdb34 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -20,6 +20,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -142,15 +143,22 @@ static inline bool
 xchk_bmap_get_rmap(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec,
-	xfs_agblock_t		agbno,
+	xfs_agblock_t		bno,
 	uint64_t		owner,
 	struct xfs_rmap_irec	*rmap)
 {
+	struct xfs_btree_cur	**curp = &info->sc->sa.rmap_cur;
 	xfs_fileoff_t		offset;
 	unsigned int		rflags = 0;
 	int			has_rmap;
 	int			error;
 
+	if (xfs_ifork_is_realtime(info->sc->ip, info->whichfork))
+		curp = &info->sc->sr.rmap_cur;
+
+	if (*curp == NULL)
+		return false;
+
 	if (info->whichfork == XFS_ATTR_FORK)
 		rflags |= XFS_RMAP_ATTR_FORK;
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
@@ -171,13 +179,13 @@ xchk_bmap_get_rmap(
 	 * range rmap lookup to make sure we get the correct owner/offset.
 	 */
 	if (info->is_shared) {
-		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, agbno,
-				owner, offset, rflags, rmap, &has_rmap);
+		error = xfs_rmap_lookup_le_range(*curp, bno, owner, offset,
+				rflags, rmap, &has_rmap);
 	} else {
-		error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, agbno,
-				owner, offset, rflags, rmap, &has_rmap);
+		error = xfs_rmap_lookup_le(*curp, bno, owner, offset,
+				rflags, rmap, &has_rmap);
 	}
-	if (!xchk_should_check_xref(info->sc, &error, &info->sc->sa.rmap_cur))
+	if (!xchk_should_check_xref(info->sc, &error, curp))
 		return false;
 
 	if (!has_rmap)
@@ -191,29 +199,29 @@ STATIC void
 xchk_bmap_xref_rmap(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec,
-	xfs_agblock_t		agbno)
+	xfs_agblock_t		bno)
 {
 	struct xfs_rmap_irec	rmap;
 	unsigned long long	rmap_end;
 	uint64_t		owner = info->sc->ip->i_ino;
 
-	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
+	if (xchk_skip_xref(info->sc->sm))
 		return;
 
 	/* Find the rmap record for this irec. */
-	if (!xchk_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+	if (!xchk_bmap_get_rmap(info, irec, bno, owner, &rmap))
 		return;
 
 	/*
 	 * The rmap must be an exact match for this incore file mapping record,
 	 * which may have arisen from multiple ondisk records.
 	 */
-	if (rmap.rm_startblock != agbno)
+	if (rmap.rm_startblock != bno)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
-	if (rmap_end != agbno + irec->br_blockcount)
+	if (rmap_end != bno + irec->br_blockcount)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -258,7 +266,7 @@ STATIC void
 xchk_bmap_xref_rmap_cow(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec,
-	xfs_agblock_t		agbno)
+	xfs_agblock_t		bno)
 {
 	struct xfs_rmap_irec	rmap;
 	unsigned long long	rmap_end;
@@ -268,7 +276,7 @@ xchk_bmap_xref_rmap_cow(
 		return;
 
 	/* Find the rmap record for this irec. */
-	if (!xchk_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+	if (!xchk_bmap_get_rmap(info, irec, bno, owner, &rmap))
 		return;
 
 	/*
@@ -276,12 +284,12 @@ xchk_bmap_xref_rmap_cow(
 	 * can start before and end after the physical space allocated to this
 	 * mapping.  There are no offsets to check.
 	 */
-	if (rmap.rm_startblock > agbno)
+	if (rmap.rm_startblock > bno)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
-	if (rmap_end < agbno + irec->br_blockcount)
+	if (rmap_end < bno + irec->br_blockcount)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -314,10 +322,40 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
-	xchk_rt_init(info->sc, &info->sc->sr, XCHK_RTLOCK_BITMAP_SHARED);
+	struct xfs_owner_info	oinfo;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp)) {
+		xchk_rt_init(info->sc, &info->sc->sr,
+				XCHK_RTLOCK_BITMAP_SHARED);
+		xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
+				irec->br_blockcount);
+		xchk_rt_unlock(info->sc, &info->sc->sr);
+		return;
+	}
+
+	rgbno = xfs_rtb_to_rgbno(mp, irec->br_startblock, &rgno);
+	error = xchk_rtgroup_init(info->sc, rgno, &info->sc->sr,
+			XCHK_RTGLOCK_ALL);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		goto out_free;
+
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
-	xchk_rt_unlock(info->sc, &info->sc->sr);
+	xchk_bmap_xref_rmap(info, irec, rgbno);
+
+	xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino, info->whichfork,
+			irec->br_startoff);
+	xchk_xref_is_only_rt_owned_by(info->sc, rgbno, irec->br_blockcount,
+			&oinfo);
+
+out_free:
+	xchk_rtgroup_btcur_free(&info->sc->sr);
+	xchk_rtgroup_free(info->sc, &info->sc->sr);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 5bedb09387495..0d823eadbdba0 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -9,6 +9,7 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
@@ -16,10 +17,13 @@
 #include "xfs_bmap.h"
 #include "xfs_bit.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/rtbitmap.h"
+#include "scrub/btree.h"
 
 static inline void
 xchk_rtbitmap_compute_geometry(
@@ -123,6 +127,36 @@ xchk_setup_rtbitmap(
 
 /* Per-rtgroup bitmap contents. */
 
+/* Cross-reference rtbitmap entries with other metadata. */
+STATIC void
+xchk_rgbitmap_xref(
+	struct xchk_rgbitmap	*rgb,
+	xfs_rtblock_t		startblock,
+	xfs_rtblock_t		blockcount)
+{
+	struct xfs_scrub	*sc = rgb->sc;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+	if (!sc->sr.rmap_cur)
+		return;
+
+	rgbno = xfs_rtb_to_rgbno(sc->mp, startblock, &rgno);
+	xchk_xref_has_no_rt_owner(sc, rgbno, blockcount);
+
+	if (rgb->next_free_rtblock < startblock) {
+		xfs_rgblock_t	next_rgbno;
+
+		next_rgbno = xfs_rtb_to_rgbno(sc->mp, rgb->next_free_rtblock,
+				&rgno);
+		xchk_xref_has_rt_owner(sc, next_rgbno, rgbno - next_rgbno);
+	}
+
+	rgb->next_free_rtblock = startblock + blockcount;
+}
+
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xchk_rgbitmap_rec(
@@ -141,6 +175,12 @@ xchk_rgbitmap_rec(
 
 	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	xchk_rgbitmap_xref(rgb, startblock, blockcount);
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -ECANCELED;
+
 	return 0;
 }
 
@@ -154,6 +194,7 @@ xchk_rgbitmap(
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	struct xchk_rgbitmap	*rgb = sc->buf;
 	xfs_rtblock_t		rtbno;
+	xfs_rtblock_t		last_rtbno;
 	xfs_rgblock_t		last_rgbno = rtg->rtg_blockcount - 1;
 	int			error;
 
@@ -168,6 +209,7 @@ xchk_rgbitmap(
 	 * realtime group.
 	 */
 	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, 0);
+	rgb->next_free_rtblock = rtbno;
 	keys[0].ar_startext = xfs_rtb_to_rtx(mp, rtbno);
 
 	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, last_rgbno);
@@ -179,6 +221,22 @@ xchk_rgbitmap(
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
+	/*
+	 * Check that the are rmappings for all rt extents between the end of
+	 * the last free extent we saw and the last possible extent in the rt
+	 * group.
+	 */
+	last_rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, last_rgbno);
+	if (rgb->next_free_rtblock < last_rtbno) {
+		xfs_rgnumber_t	rgno;
+		xfs_rgblock_t	next_rgbno;
+
+		next_rgbno = xfs_rtb_to_rgbno(sc->mp, rgb->next_free_rtblock,
+				&rgno);
+		xchk_xref_has_rt_owner(sc, next_rgbno,
+				last_rgbno - next_rgbno);
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
index f659f0e76b4fa..42d50fa48a0ec 100644
--- a/fs/xfs/scrub/rtbitmap.h
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -17,6 +17,9 @@ struct xchk_rgbitmap {
 	struct xfs_scrub	*sc;
 
 	struct xchk_rtbitmap	rtb;
+
+	/* The next free rt block that we expect to see. */
+	xfs_rtblock_t		next_free_rtblock;
 };
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 6009d458605e4..c3e1cee81b6d2 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -209,3 +209,68 @@ xchk_rtrmapbt(
 			XFS_DATA_FORK);
 	return xchk_btree(sc, sc->sr.rmap_cur, xchk_rtrmapbt_rec, &oinfo, &cr);
 }
+
+/* xref check that the extent has no realtime reverse mapping at all */
+void
+xchk_xref_has_no_rt_owner(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_rmap_has_records(sc->sr.rmap_cur, bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+}
+
+/* xref check that the extent is completely mapped */
+void
+xchk_xref_has_rt_owner(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_rmap_has_records(sc->sr.rmap_cur, bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_FULL)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+}
+
+/* xref check that the extent is only owned by a given owner */
+void
+xchk_xref_is_only_rt_owned_by(
+	struct xfs_scrub		*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xfs_rmap_matches		res;
+	int				error;
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_rmap_count_owners(sc->sr.rmap_cur, bno, len, oinfo, &res);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
+		return;
+	if (res.matches != 1)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+	if (res.bad_non_owner_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+	if (res.non_owner_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 52bbc1fbcc560..38731b99625d6 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -321,8 +321,17 @@ void xchk_xref_is_not_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
 #ifdef CONFIG_XFS_RT
 void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 		xfs_extlen_t len);
+void xchk_xref_has_no_rt_owner(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_has_rt_owner(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_is_only_rt_owned_by(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
 #else
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
+# define xchk_xref_has_no_rt_owner(sc, rtbno, len) do { } while (0)
+# define xchk_xref_has_rt_owner(sc, rtbno, len) do { } while (0)
+# define xchk_xref_is_only_rt_owned_by(sc, bno, len, oinfo) do { } while (0)
 #endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

