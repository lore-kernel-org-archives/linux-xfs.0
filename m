Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D95C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiLaBo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbiLaBo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:44:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D411813F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95940B81A16
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3FFC433D2;
        Sat, 31 Dec 2022 01:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451064;
        bh=Dr2/UOyjflVKUhrZy/m7E9v3S1q6V4PYZ6vHN5qtU/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MjsoTZCOjLUzpoHvOjrha5XqucwaI4wVANoOiGTv49af59ueZOCBbGl3rbWQHcADA
         /apBGpfH9JnuEbCfT5z/UbEHxnQoCCI5nawx2sIk2IhIiQU3Hnr/xNDrvzO/V9aSgx
         s6SLHPe/4zuszBFhUbox2uOxtmF4eeiM9ok9VR/1xpWVbMoDkOPEjUJApTkApkvRHI
         LTj9t0Of/VLjd4rJRLdyq/opMuUZry8xbc8+Ipn7sxwR/2DNx5D7ZB6U2gTMpSmFBQ
         iILYRtVJ8Ujsr0pjfjgtWoLj5ji1RQPeyT+RVCyWYGfmpwQxIIchJto65bYnaT/Y8t
         wQkUd+xkTrr6g==
Subject: [PATCH 29/38] xfs: cross-reference the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870016.715303.9787144291938755463.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the data fork and realtime bitmap scrubbers to cross-reference
information with the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c     |   67 +++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/rtbitmap.c |   80 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/rtrmap.c   |   65 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    9 +++++
 4 files changed, 202 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0c79185daedf..49fffe85dde6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -19,6 +19,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -127,15 +128,22 @@ static inline bool
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
@@ -156,13 +164,13 @@ xchk_bmap_get_rmap(
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
@@ -218,13 +226,13 @@ STATIC void
 xchk_bmap_xref_rmap(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec,
-	xfs_agblock_t		agbno)
+	xfs_agblock_t		bno)
 {
 	struct xfs_rmap_irec	rmap;
 	unsigned long long	rmap_end;
 	uint64_t		owner;
 
-	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
+	if (xchk_skip_xref(info->sc->sm))
 		return;
 
 	if (info->whichfork == XFS_COW_FORK)
@@ -233,13 +241,12 @@ xchk_bmap_xref_rmap(
 		owner = info->sc->ip->i_ino;
 
 	/* Find the rmap record for this irec. */
-	if (!xchk_bmap_get_rmap(info, irec, agbno, owner, &rmap))
+	if (!xchk_bmap_get_rmap(info, irec, bno, owner, &rmap))
 		return;
 
 	/* Check the rmap. */
 	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
-	if (rmap.rm_startblock > agbno ||
-	    agbno + irec->br_blockcount > rmap_end)
+	if (rmap.rm_startblock > bno || bno + irec->br_blockcount > rmap_end)
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -288,7 +295,7 @@ xchk_bmap_xref_rmap(
 	 * Skip this for CoW fork extents because the refcount btree (and not
 	 * the inode) is the ondisk owner for those extents.
 	 */
-	if (info->whichfork != XFS_COW_FORK && rmap.rm_startblock < agbno &&
+	if (info->whichfork != XFS_COW_FORK && rmap.rm_startblock < bno &&
 	    !xchk_bmap_has_prev(info, irec)) {
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
@@ -303,7 +310,7 @@ xchk_bmap_xref_rmap(
 	 */
 	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
 	if (info->whichfork != XFS_COW_FORK &&
-	    rmap_end > agbno + irec->br_blockcount &&
+	    rmap_end > bno + irec->br_blockcount &&
 	    !xchk_bmap_has_next(info, irec)) {
 		xchk_fblock_xref_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
@@ -318,10 +325,40 @@ xchk_bmap_rt_iextent_xref(
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
index a034f2d392f5..eb150c40d33c 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -9,15 +9,19 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_btree.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
+#include "scrub/btree.h"
 
 /* Set us up with the realtime group metadata locked. */
 int
@@ -77,6 +81,43 @@ xchk_setup_rtbitmap(
 
 /* Realtime bitmap. */
 
+struct xchk_rtbitmap {
+	struct xfs_scrub	*sc;
+
+	/* The next free rt block that we expect to see. */
+	xfs_rtblock_t		next_free_rtblock;
+};
+
+/* Cross-reference rtbitmap entries with other metadata. */
+STATIC void
+xchk_rtbitmap_xref(
+	struct xchk_rtbitmap	*rtb,
+	xfs_rtblock_t		startblock,
+	xfs_rtblock_t		blockcount)
+{
+	struct xfs_scrub	*sc = rtb->sc;
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
+	if (rtb->next_free_rtblock < startblock) {
+		xfs_rgblock_t	next_rgbno;
+
+		next_rgbno = xfs_rtb_to_rgbno(sc->mp, rtb->next_free_rtblock,
+				&rgno);
+		xchk_xref_has_rt_owner(sc, next_rgbno, rgbno - next_rgbno);
+	}
+
+	rtb->next_free_rtblock = startblock + blockcount;
+}
+
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xchk_rtbitmap_rec(
@@ -85,8 +126,9 @@ xchk_rtbitmap_rec(
 	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
 {
-	struct xfs_scrub	*sc = priv;
-	xfs_rtxnum_t		startblock;
+	struct xchk_rtbitmap	*rtb = priv;
+	struct xfs_scrub	*sc = rtb->sc;
+	xfs_rtblock_t		startblock;
 	xfs_filblks_t		blockcount;
 
 	startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
@@ -94,6 +136,12 @@ xchk_rtbitmap_rec(
 
 	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	xchk_rtbitmap_xref(rtb, startblock, blockcount);
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -ECANCELED;
+
 	return 0;
 }
 
@@ -138,8 +186,12 @@ xchk_rgbitmap(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_rtalloc_rec	keys[2];
+	struct xchk_rtbitmap	rtb = {
+		.sc		= sc,
+	};
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	xfs_rtblock_t		rtbno;
+	xfs_rtblock_t		last_rtbno;
 	xfs_rgblock_t		last_rgbno = rtg->rtg_blockcount - 1;
 	int			error;
 
@@ -155,6 +207,7 @@ xchk_rgbitmap(
 	 * realtime group.
 	 */
 	rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, 0);
+	rtb.next_free_rtblock = rtbno;
 	keys[0].ar_startext = xfs_rtb_to_rtxt(sc->mp, rtbno);
 
 	rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, last_rgbno);
@@ -162,10 +215,26 @@ xchk_rgbitmap(
 	keys[0].ar_extcount = keys[1].ar_extcount = 0;
 
 	error = xfs_rtalloc_query_range(sc->mp, sc->tp, &keys[0], &keys[1],
-			xchk_rtbitmap_rec, sc);
+			xchk_rtbitmap_rec, &rtb);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
+	/*
+	 * Check that the are rmappings for all rt extents between the end of
+	 * the last free extent we saw and the last possible extent in the rt
+	 * group.
+	 */
+	last_rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, last_rgbno);
+	if (rtb.next_free_rtblock < last_rtbno) {
+		xfs_rgnumber_t	rgno;
+		xfs_rgblock_t	next_rgbno;
+
+		next_rgbno = xfs_rtb_to_rgbno(sc->mp, rtb.next_free_rtblock,
+				&rgno);
+		xchk_xref_has_rt_owner(sc, next_rgbno,
+				last_rgbno - next_rgbno);
+	}
+
 	return 0;
 }
 
@@ -174,6 +243,9 @@ int
 xchk_rtbitmap(
 	struct xfs_scrub	*sc)
 {
+	struct xchk_rtbitmap	rtb = {
+		.sc		= sc,
+	};
 	int			error;
 
 	/* Is the size of the rtbitmap correct? */
@@ -199,7 +271,7 @@ xchk_rtbitmap(
 	if (xfs_has_rtgroups(sc->mp))
 		return 0;
 
-	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtbitmap_rec, sc);
+	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtbitmap_rec, &rtb);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 72fc47cc25f0..e9ca9670f3af 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -208,3 +208,68 @@ xchk_rtrmapbt(
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
+	if (res.badno_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+	if (res.nono_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index fa75034b9051..d47db84e6b7f 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -233,8 +233,17 @@ void xchk_xref_is_not_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
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

