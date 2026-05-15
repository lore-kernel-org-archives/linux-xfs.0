Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF20334EF1C
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853087; cv=none; b=rS0WbCjT9Kkh35HKv9KtpdOCjz7taU1PhEX7nWMv7r05HS/ua6z6bIgzZ3amkkxKvcxJIUZwHSHIVwq80iEosT9sbNaM+vthqgwtpLzqW+HKUoi3MGcRHFnrh0lFVQ5Ahns4igSiBBiL2ds9mH9FaETKDI9cJRM6wiDFefszoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853087; c=relaxed/simple;
	bh=iQnLu/08hbMM1Vc6F/30V1ivZ5sDp6H3OeZJQs33AMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViARYTCdGpfJbAoL7I3Yt3nI15peWV0XFDZ3mjTpWrOsfcOghpF+EsWB3UliHk1r05/OgOWztDZPr1MoxXyTVfc2YD6JFTRXDrbEZMIk0j3u0kHF3a6s5ID2IO8L2M2PEkvHMS4k65WG3LfDNxLsdMR5wbq7n05lqGGe1UAGMkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bsX3KG3r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bsX3KG3r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sQxod4KAq+H9n++kNZ1Z2EihhcBxtyd9CgFwfQF5Pv0=; b=bsX3KG3rxUJ3weY6wIeLDWuRLy
	1u3i4ozLzA789K/gRyiZBzToQyU5rcLI75i7nNu+b10/F1+IOSqFjVe5DSr4OJ+fJlROHbHpau2nA
	pdJNZHcMCWUmk+mq1Q3kwSRdZ7pbURH1M4vKeWg18lPFEnKNrfUd5tKOlUMwHlOhGOSbigKwmaMTl
	0WXYpbtX4S7OBnW1Ndh+25JR4K2pySwdlyPBRY92EdDPvy6rktqDOMMYgGdidNA7CUY6SNLApQxO+
	YnHeRwOEzgrOIuG3A7QLFhqQ1qLi7aLhml8DqhdK0xyHzDCWyIiveKAai7qpfqR3Mef2KTHc823m5
	xgZHAyMw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswi-00000008UXS-13ba;
	Fri, 15 May 2026 13:51:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: add a xfs_rmap_inode_bmbt_owner
Date: Fri, 15 May 2026 15:50:25 +0200
Message-ID: <20260515135103.4042407-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a small wrapper for initializing the bmbt owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
 fs/xfs/libxfs/xfs_btree.c      | 4 ++--
 fs/xfs/libxfs/xfs_rmap.h       | 2 ++
 fs/xfs/scrub/bmap.c            | 2 +-
 fs/xfs/scrub/bmap_repair.c     | 4 ++--
 fs/xfs/scrub/newbt.c           | 2 +-
 fs/xfs/scrub/reap.c            | 2 +-
 fs/xfs/scrub/rtrefcount.c      | 2 +-
 fs/xfs/scrub/rtrmap.c          | 3 +--
 10 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a11a8aee5b79..066d13e97ec9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -602,7 +602,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
 			XFS_AG_RESV_NONE, 0);
 	if (error)
@@ -676,7 +676,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, whichfork);
 
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1c7165df483a..8683574566e2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -217,7 +217,7 @@ xfs_bmbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, cur->bc_ino.ip,
 			cur->bc_ino.whichfork);
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_flags & XFS_BTREE_BMBT_WASDEL;
@@ -280,7 +280,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 	int			error;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
 			XFS_AG_RESV_NONE, 0);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 71d65f2fa005..ea85c5fbe531 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5607,7 +5607,7 @@ xfs_btree_alloc_metafile_block(
 
 	ASSERT(xfs_is_metadir_inode(ip));
 
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&args.oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_alloc_vextent_start_ag(&args, XFS_INODE_TO_FSB(ip));
 	if (error)
 		return error;
@@ -5639,7 +5639,7 @@ xfs_btree_free_metafile_block(
 
 	ASSERT(xfs_is_metadir_inode(ip));
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(tp, fsbno, 1, &oinfo, XFS_AG_RESV_METAFILE,
 			0);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 5f39f6e53cd1..7188459f61cf 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -21,6 +21,8 @@ xfs_rmap_ino_bmbt_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_bmbt_owner(oi, ip, whichfork) \
+	xfs_rmap_ino_bmbt_owner(oi, (ip)->i_ino, whichfork)
 
 static inline void
 xfs_rmap_ino_owner(
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d40534bf9ef9..2ad223f0bc8a 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -600,7 +600,7 @@ xchk_bmap_btree(
 
 	/* Check the btree structure. */
 	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, ip, whichfork);
 	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
 	xfs_btree_del_cursor(cur, error);
 out:
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 822a4af43833..f5791ad21e41 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -760,7 +760,7 @@ xrep_bmap_build_new_fork(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
 	error = xrep_newbt_init_inode(&rb->new_bmapbt, sc, rb->whichfork,
 			&oinfo);
 	if (error)
@@ -833,7 +833,7 @@ xrep_bmap_remove_old_tree(
 	struct xfs_owner_info	oinfo;
 
 	/* Free the old bmbt blocks if they're not in use. */
-	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
 	return xrep_reap_fsblocks(sc, &rb->old_bmbt_blocks, &oinfo);
 }
 
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 6ab0eff7d2ea..c82f4631fd9c 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -145,7 +145,7 @@ xrep_newbt_init_metadir_inode(
 
 	ASSERT(xfs_is_metadir_inode(sc->ip));
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 
 	ifp = kmem_cache_zalloc(xfs_ifork_cache, XCHK_GFP_FLAGS);
 	if (!ifp)
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index fff23932828b..cd90ecae3ffb 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1205,7 +1205,7 @@ xrep_reap_metadir_fsblocks(
 	ASSERT(xfs_is_metadir_inode(sc->ip));
 
 	xreap_configure_agextent_limits(&rs);
-	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 4951cc271788..0d10ce2910c2 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -555,7 +555,7 @@ xchk_rtrefcountbt(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	xfs_rmap_ino_bmbt_owner(&btree_oinfo, rtg_refcount(sc->sr.rtg)->i_ino,
+	xfs_rmap_inode_bmbt_owner(&btree_oinfo, rtg_refcount(sc->sr.rtg),
 			XFS_DATA_FORK);
 	error = xchk_btree(sc, sc->sr.refc_cur, xchk_rtrefcountbt_rec,
 			&btree_oinfo, &rrc);
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 8b1a8389d32f..043be93c7148 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -244,7 +244,6 @@ int
 xchk_rtrmapbt(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_inode	*ip = rtg_rmap(sc->sr.rtg);
 	struct xfs_owner_info	oinfo;
 	struct xchk_rtrmap	cr = { };
 	int			error;
@@ -253,7 +252,7 @@ xchk_rtrmapbt(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, rtg_rmap(sc->sr.rtg), XFS_DATA_FORK);
 	return xchk_btree(sc, sc->sr.rmap_cur, xchk_rtrmapbt_rec, &oinfo, &cr);
 }
 
-- 
2.53.0

