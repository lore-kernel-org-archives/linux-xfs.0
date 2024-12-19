Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2ED1B0F10
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636564; cv=none; b=o9O6OnZizJ3GLkzukBAlEYY8Dez1cGgGcsUN6wuQVmilIrbl3YHUoIdBPMn80LKT+1Ww/2U1fOIicD6m6g7J77vV1QmZleBOPK4fYDCTMi7c3q6yD1z9L91Zo3jbgzfucNc9WtWzlXpAdtd+exU4l2lzhgfGKLKr5Y0FK6WKcCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636564; c=relaxed/simple;
	bh=SMVva9Qokerp6XtqDy6mXW53POez9nwZsbp1/wuX+Ys=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3Jz6XpcidYYjoVA2qV6FvlMS2LX6+gtY1OkVe6drf11jURnF7JoTZ9IFeeDgqqhLvbqF5qQD6Bb0VhrnQxD2ArIjsr8QU3YjCZ0Nhf/A8Bme3XMtf3J+M5xLzIo37kghX/Wc9Rb89GPBlJMk2Ofy+gFKSgjGw6dKQiJ1VPk/+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6jzYuMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6jzYuMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FDEC4CED0;
	Thu, 19 Dec 2024 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636563;
	bh=SMVva9Qokerp6XtqDy6mXW53POez9nwZsbp1/wuX+Ys=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z6jzYuMBnQI/8Br4FfZVAhk6+iWHwz433chix9xn5U120s59R3z+IZ5ieg7awISby
	 QpUMFsdXP/IE4qvNUGPYsewvTgsRpE7PDHvYGT69wAZnl4B6a4D9v9iSfc2TbY54RX
	 bsm4jmgOdESM5ZJP+1u09UK/bNUTBnJAYE9f4N46w2jw1kFWXloHh80qVBNjOqW8Bt
	 VkPgmXx6+Byend+y5R4HoUddKwxixRhgADjXDYfdOIT6DIHSRLhErOEgY1ctDkKLRe
	 TWhU/9/dkfmbkcY+VOEEJcKwb8ps5z1P/e1dGkUkP2hzNdtoACOUQ1B+sYY5cEUGOc
	 4NXTNIaN2+rkQ==
Date: Thu, 19 Dec 2024 11:29:23 -0800
Subject: [PATCH 23/37] xfs: cross-reference the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580152.1571512.12035772331422051058.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c     |   52 +++++++++++++++++++++++++++-----------
 fs/xfs/scrub/rgsuper.c  |    2 +
 fs/xfs/scrub/rtbitmap.c |   55 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/rtbitmap.h |    5 ++++
 fs/xfs/scrub/rtrmap.c   |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    9 +++++++
 6 files changed, 169 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index dd99366643f832..b7f9f3b3d81a3a 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -143,15 +143,22 @@ static inline bool
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
@@ -172,13 +179,13 @@ xchk_bmap_get_rmap(
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
@@ -192,29 +199,29 @@ STATIC void
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
 
@@ -259,7 +266,7 @@ STATIC void
 xchk_bmap_xref_rmap_cow(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec,
-	xfs_agblock_t		agbno)
+	xfs_agblock_t		bno)
 {
 	struct xfs_rmap_irec	rmap;
 	unsigned long long	rmap_end;
@@ -269,7 +276,7 @@ xchk_bmap_xref_rmap_cow(
 		return;
 
 	/* Find the rmap record for this irec. */
-	if (!xchk_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+	if (!xchk_bmap_get_rmap(info, irec, bno, owner, &rmap))
 		return;
 
 	/*
@@ -277,12 +284,12 @@ xchk_bmap_xref_rmap_cow(
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
 
@@ -315,6 +322,8 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	struct xfs_owner_info	oinfo;
+	xfs_rgblock_t		rgbno;
 	int			error;
 
 	error = xchk_rtgroup_init_existing(info->sc,
@@ -332,6 +341,19 @@ xchk_bmap_rt_iextent_xref(
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
 
+	if (!xfs_has_rtrmapbt(info->sc->mp))
+		goto out_cur;
+
+	rgbno = xfs_rtb_to_rgbno(info->sc->mp, irec->br_startblock);
+	xchk_bmap_xref_rmap(info, irec, rgbno);
+
+	xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino, info->whichfork,
+			irec->br_startoff);
+	xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
+			irec->br_blockcount, &oinfo);
+
+out_cur:
+	xchk_rtgroup_btcur_free(&info->sc->sr);
 out_free:
 	xchk_rtgroup_free(info->sc, &info->sc->sr);
 }
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index e062c7d12565cd..d189732d0e24fb 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -13,6 +13,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -34,6 +35,7 @@ xchk_rgsuperblock_xref(
 		return;
 
 	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0), 1);
+	xchk_xref_is_only_rt_owned_by(sc, 0, 1, &XFS_RMAP_OINFO_FS);
 }
 
 int
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 819026ea2d741f..675f4fdd1e675f 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -9,17 +9,22 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bit.h"
+#include "xfs_rtgroup.h"
 #include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/rtbitmap.h"
+#include "scrub/btree.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -37,6 +42,7 @@ xchk_setup_rtbitmap(
 	if (!rtb)
 		return -ENOMEM;
 	sc->buf = rtb;
+	rtb->sc = sc;
 
 	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
 	if (error)
@@ -78,7 +84,30 @@ xchk_setup_rtbitmap(
 	return 0;
 }
 
-/* Realtime bitmap. */
+/* Per-rtgroup bitmap contents. */
+
+/* Cross-reference rtbitmap entries with other metadata. */
+STATIC void
+xchk_rtbitmap_xref(
+	struct xchk_rtbitmap	*rtb,
+	xfs_rtblock_t		startblock,
+	xfs_rtblock_t		blockcount)
+{
+	struct xfs_scrub	*sc = rtb->sc;
+	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(sc->mp, startblock);
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+	if (!sc->sr.rmap_cur)
+		return;
+
+	xchk_xref_has_no_rt_owner(sc, rgbno, blockcount);
+
+	if (rtb->next_free_rgbno < rgbno)
+		xchk_xref_has_rt_owner(sc, rtb->next_free_rgbno,
+				rgbno - rtb->next_free_rgbno);
+	rtb->next_free_rgbno = rgbno + blockcount;
+}
 
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
@@ -88,7 +117,8 @@ xchk_rtbitmap_rec(
 	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
 {
-	struct xfs_scrub	*sc = priv;
+	struct xchk_rtbitmap	*rtb = priv;
+	struct xfs_scrub	*sc = rtb->sc;
 	xfs_rtblock_t		startblock;
 	xfs_filblks_t		blockcount;
 
@@ -97,6 +127,12 @@ xchk_rtbitmap_rec(
 
 	if (!xfs_verify_rtbext(rtg_mount(rtg), startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	xchk_rtbitmap_xref(rtb, startblock, blockcount);
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -ECANCELED;
+
 	return 0;
 }
 
@@ -144,7 +180,7 @@ xchk_rtbitmap_check_extents(
 	return error;
 }
 
-/* Scrub the realtime bitmap. */
+/* Scrub this group's realtime bitmap. */
 int
 xchk_rtbitmap(
 	struct xfs_scrub	*sc)
@@ -153,6 +189,7 @@ xchk_rtbitmap(
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	struct xchk_rtbitmap	*rtb = sc->buf;
+	xfs_rgblock_t		last_rgbno;
 	int			error;
 
 	/* Is sb_rextents correct? */
@@ -205,10 +242,20 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtbitmap_rec, sc);
+	rtb->next_free_rgbno = 0;
+	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtbitmap_rec, rtb);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
+	/*
+	 * Check that the are rmappings for all rt extents between the end of
+	 * the last free extent we saw and the last possible extent in the rt
+	 * group.
+	 */
+	last_rgbno = rtg->rtg_extents * mp->m_sb.sb_rextsize - 1;
+	if (rtb->next_free_rgbno < last_rgbno)
+		xchk_xref_has_rt_owner(sc, rtb->next_free_rgbno,
+				last_rgbno - rtb->next_free_rgbno);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
index 85304ff019e1dc..dd5b394d9697d2 100644
--- a/fs/xfs/scrub/rtbitmap.h
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -7,10 +7,15 @@
 #define __XFS_SCRUB_RTBITMAP_H__
 
 struct xchk_rtbitmap {
+	struct xfs_scrub	*sc;
+
 	uint64_t		rextents;
 	uint64_t		rbmblocks;
 	unsigned int		rextslog;
 	unsigned int		resblks;
+
+	/* The next free rt group block number that we expect to see. */
+	xfs_rgblock_t		next_free_rgbno;
 };
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 515c2a9b02cdae..764fa296792234 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -197,3 +197,68 @@ xchk_rtrmapbt(
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, XFS_DATA_FORK);
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
index 0ad5122af486e1..cba4e89a3a627b 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -322,8 +322,17 @@ void xchk_xref_is_not_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
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

