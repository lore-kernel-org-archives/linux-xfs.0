Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C486C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiLaBzv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiLaBzv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:55:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397845F74
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CADE361C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3907EC433EF;
        Sat, 31 Dec 2022 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451749;
        bh=+cctjXtA6Jf8cHwG22lp1M6RkZ84KzGQ4nEqp1mcLfY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QzokBy2ziTU2AOAIrgGOjjQvRBYDqEEa0bydrW4HwTqqFt/hjq9Cdh0itxYsH/iA/
         HPqU78AWUngVOGsYEcYiC445q+xiyAJgx3gDr0RTKwjxsphS0fGIHVQetmv6XY6TYj
         CbShOv5hX/HfiTo+4gxrPrmEm3E+u6xxqAR6xjF6jkn12yN2kWv3IGNfBAxc4rFQ/b
         gW7qNoZCAadUNv/+u6tFpQOUQVwwCOytYu7A6F5+jS914m7obKvl8Tbs3TXqT2Yb3k
         uJF4lzJJkSTymEZgeHM7QA6LEGZQuKNSwJF8WXMPg6YHCs1chFGZAuSbFHCNHtnEfi
         RU1c+bY8k2J+A==
Subject: [PATCH 30/42] xfs: cross-reference checks with the rt refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871324.717073.10721947638785793216.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the realtime refcount btree to implement cross-reference checks in
other data structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c       |   27 ++++++++++++--
 fs/xfs/scrub/rtbitmap.c   |    2 +
 fs/xfs/scrub/rtrefcount.c |   86 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c     |   37 +++++++++++++++++++
 fs/xfs/scrub/scrub.h      |    9 +++++
 5 files changed, 156 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f18b22bc2548..8191a67598d0 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -352,11 +352,28 @@ xchk_bmap_rt_iextent_xref(
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
 	xchk_bmap_xref_rmap(info, irec, rgbno);
-
-	xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino, info->whichfork,
-			irec->br_startoff);
-	xchk_xref_is_only_rt_owned_by(info->sc, rgbno, irec->br_blockcount,
-			&oinfo);
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
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
index ca478fbd514e..9419219a534f 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -121,6 +121,8 @@ xchk_rtbitmap_xref(
 
 	rgbno = xfs_rtb_to_rgbno(sc->mp, startblock, &rgno);
 	xchk_xref_has_no_rt_owner(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_shared(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_cow_staging(sc, rgbno, blockcount);
 
 	if (rtb->next_free_rtblock < startblock) {
 		xfs_rgblock_t	next_rgbno;
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 528a056c7932..05512f8443a2 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -493,3 +493,89 @@ xchk_rtrefcountbt(
 out_unlock:
 	return error;
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
index 5442325a6982..e89d5310117a 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -21,6 +21,7 @@
 #include "xfs_inode.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -157,6 +158,37 @@ xchk_rtrmapbt_check_mergeable(
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
@@ -172,6 +204,11 @@ xchk_rtrmapbt_xref(
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
index 3a9dd26eca7d..0a3b151f9870 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -242,11 +242,20 @@ void xchk_xref_has_rt_owner(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
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

