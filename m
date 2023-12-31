Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4DCC8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJpHaldM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBEBC433C7;
	Sun, 31 Dec 2023 21:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059543;
	bh=YjE6odRmo5fDdxD3+B213t3nX3TE0CXtZgR458zQWNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mJpHaldMeZ/4aJG2uEUw864vGuHWpLoxbut2cGFvYZPzkfOmDAdno0x1PbFmwK+PJ
	 miofy8xtV1r88ql7sWsT8B28kSgw/kMQAg0ZaitZjvvEvWIaWLfFS/oAG82gogNhPB
	 1Wl7LZGwVRnRbKOxcgULPJ69xmAZDhqshplRe6eOoUprC5H5x5L8+nMESEegc78okD
	 pUb7oa8iBbuCCMFVnk5ZtPsVpmQkPA+bulVoa6XuloRnPCKmUy3mPcdbWA3+eIKN52
	 xhS8eXhhbwFD2YfHFJtrkhfy87eo1YnNYqhGikOWd/auGn+Wp8gKYdo/u9CrOstg7c
	 L9UaHdoyhxFfg==
Date: Sun, 31 Dec 2023 13:52:23 -0800
Subject: [PATCH 30/44] xfs: cross-reference checks with the rt refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852065.1766284.2087369433078609917.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Use the realtime refcount btree to implement cross-reference checks in
other data structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c       |   30 +++++++++++++---
 fs/xfs/scrub/rtbitmap.c   |    2 +
 fs/xfs/scrub/rtrefcount.c |   86 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c     |   37 +++++++++++++++++++
 fs/xfs/scrub/scrub.h      |    9 +++++
 5 files changed, 158 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5531ba2295b12..41b83515b4491 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -348,12 +348,30 @@ xchk_bmap_rt_iextent_xref(
 
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
-	xchk_bmap_xref_rmap(info, irec, rgbno);
-
-	xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino, info->whichfork,
-			irec->br_startoff);
-	xchk_xref_is_only_rt_owned_by(info->sc, rgbno, irec->br_blockcount,
-			&oinfo);
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
+		xchk_bmap_xref_rmap(info, irec, rgbno);
+		if (!xfs_is_reflink_inode(info->sc->ip)) {
+			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+					info->whichfork, irec->br_startoff);
+			xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
+					irec->br_blockcount, &oinfo);
+			xchk_xref_is_not_rt_shared(info->sc, rgbno,
+					irec->br_blockcount);
+		}
+		xchk_xref_is_not_rt_cow_staging(info->sc, rgbno,
+				irec->br_blockcount);
+		break;
+	case XFS_COW_FORK:
+		xchk_bmap_xref_rmap_cow(info, irec, rgbno);
+		xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
+				irec->br_blockcount, &XFS_RMAP_OINFO_COW);
+		xchk_xref_is_rt_cow_staging(info->sc, rgbno,
+				irec->br_blockcount);
+		xchk_xref_is_not_rt_shared(info->sc, rgbno,
+				irec->br_blockcount);
+		break;
+	}
 
 out_free:
 	xchk_rtgroup_btcur_free(&info->sc->sr);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 47463ef336eed..234c9a1f224d5 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -158,6 +158,8 @@ xchk_rgbitmap_xref(
 
 	rgbno = xfs_rtb_to_rgbno(sc->mp, startblock, &rgno);
 	xchk_xref_has_no_rt_owner(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_shared(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_cow_staging(sc, rgbno, blockcount);
 
 	if (rgb->next_free_rtblock < startblock) {
 		xfs_rgblock_t	next_rgbno;
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index cc44438eece76..360b9c6a4c04d 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -495,3 +495,89 @@ xchk_rtrefcountbt(
 
 	return 0;
 }
+
+/* xref check that a cow staging extent is marked in the rtrefcountbt. */
+void
+xchk_xref_is_rt_cow_staging(
+	struct xfs_scrub		*sc,
+	xfs_rgblock_t			bno,
+	xfs_extlen_t			len)
+{
+	struct xfs_refcount_irec	rc;
+	int				has_refcount;
+	int				error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	/* Find the CoW staging extent. */
+	error = xfs_refcount_lookup_le(sc->sr.refc_cur, XFS_REFC_DOMAIN_COW,
+			bno, &has_refcount);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (!has_refcount) {
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+		return;
+	}
+
+	error = xfs_refcount_get_rec(sc->sr.refc_cur, &rc, &has_refcount);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (!has_refcount) {
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+		return;
+	}
+
+	/* CoW lookup returned a shared extent record? */
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
+	/* Must be at least as long as what was passed in */
+	if (rc.rc_blockcount < len)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
+/*
+ * xref check that the extent is not shared.  Only file data blocks
+ * can have multiple owners.
+ */
+void
+xchk_xref_is_not_rt_shared(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_has_records(sc->sr.refc_cur,
+			XFS_REFC_DOMAIN_SHARED, bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
+/* xref check that the extent is not being used for CoW staging. */
+void
+xchk_xref_is_not_rt_cow_staging(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_has_records(sc->sr.refc_cur, XFS_REFC_DOMAIN_COW,
+			bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index ce21fa95a5da7..60751c21fe52e 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -22,6 +22,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_imeta.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -158,6 +159,37 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xchk_rtrmapbt_xref_rtrefc(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xfs_rgblock_t		fbno;
+	xfs_extlen_t		flen;
+	bool			is_inode;
+	bool			is_bmbt;
+	bool			is_attr;
+	bool			is_unwritten;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	is_inode = !XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	/* If this is shared, must be a data fork extent. */
+	error = xfs_refcount_find_shared(sc->sr.refc_cur, irec->rm_startblock,
+			irec->rm_blockcount, &fbno, &flen, false);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (flen != 0 && (!is_inode || is_attr || is_bmbt || is_unwritten))
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
 /* Cross-reference with other metadata. */
 STATIC void
 xchk_rtrmapbt_xref(
@@ -173,6 +205,11 @@ xchk_rtrmapbt_xref(
 			irec->rm_startblock);
 
 	xchk_xref_is_used_rt_space(sc, rtbno, irec->rm_blockcount);
+	if (irec->rm_owner == XFS_RMAP_OWN_COW)
+		xchk_xref_is_cow_staging(sc, irec->rm_startblock,
+				irec->rm_blockcount);
+	else
+		xchk_rtrmapbt_xref_rtrefc(sc, irec);
 }
 
 /* Scrub a realtime rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 7f94f31a5236e..93a4aba096d57 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -330,11 +330,20 @@ void xchk_xref_has_rt_owner(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_extlen_t len);
 void xchk_xref_is_only_rt_owned_by(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
+void xchk_xref_is_rt_cow_staging(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_is_not_rt_shared(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_is_not_rt_cow_staging(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
 #else
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 # define xchk_xref_has_no_rt_owner(sc, rtbno, len) do { } while (0)
 # define xchk_xref_has_rt_owner(sc, rtbno, len) do { } while (0)
 # define xchk_xref_is_only_rt_owned_by(sc, bno, len, oinfo) do { } while (0)
+# define xchk_xref_is_rt_cow_staging(sc, bno, len) do { } while (0)
+# define xchk_xref_is_not_rt_shared(sc, bno, len) do { } while (0)
+# define xchk_xref_is_not_rt_cow_staging(sc, bno, len) do { } while (0)
 #endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

