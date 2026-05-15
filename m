Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C75322DB7
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853094; cv=none; b=CBXda3jeVAcFiaz99cQOjJT2axUD32eb/dj//LC3B7u44zn5H/bq4xotCyXECQH7p2ezmSLaflnupD2MQwss7SvNMagp3VjPOSRDF6jlkSzMxYclywliU7/J2dl2MM36gGcZyT7NHcBnMTrDjXgwkrFeX0fRSrfzhAORSp8VOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853094; c=relaxed/simple;
	bh=0cGcgvVfuKaZSSsBoFlQJgiPF3U8yWSQkvjuDjKdF4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcu9weVrU3DibR9+Nnj/ocWqFBGTQTfewe3r7N8fXuGJFZBG8JcpkWMWu7F1a2YPA6CIkJXyAoM6ly8jmNZeTOfSjdgoBk1/1xe2+NXoClvA8tbFO214f3vRJD5Yi3ye1IP3YXtN8LwkXl36vWVENr2GqOkNmCLBh4ppgNBcsy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kvK8eRux; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kvK8eRux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cEshiF9Pyug1R15304OihFtP+aOVKg3miuQ3dOyqI+0=; b=kvK8eRuxHp60x4uvJtL/SIAqsw
	q8b+zzJi1D13u/ZTjcmMtyGeiXvaMUJehlBI0M7hcL67UCcnTnmWqbK5ypO6pZnmRv7EUixrzgdw9
	/oP1rX4mdvXZp54vvnJzlzjJV35lz8CKguv5l1suU00sogx5Nf7sl3tKMt7sdkyUP4rlEpb3lSKPG
	4ykA35eldBswqEqBhIFHuox6V0e/Ge7yR5hjANfHf9DS5nwQ05vUcBSxYTnW1MQKpXvRR2fypokTk
	t4flwU+E7Rsomjfao1fdwsAr6t0jHe8ZQp4VUUV+FIyagehAebS/ZHOtpwq3ScyJtIgYEscO50Lxh
	khRbKp0w==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswo-00000008UaQ-185b;
	Fri, 15 May 2026 13:51:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: add a xchk_ip_set_corrupt helper
Date: Fri, 15 May 2026 15:50:27 +0200
Message-ID: <20260515135103.4042407-7-hch@lst.de>
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

Add a smaller wrapper to set a inode corrupted by the xfs_inode
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c      |  8 ++++----
 fs/xfs/scrub/common.c    | 10 +++++-----
 fs/xfs/scrub/common.h    |  2 ++
 fs/xfs/scrub/dir.c       |  2 +-
 fs/xfs/scrub/dirtree.c   |  4 ++--
 fs/xfs/scrub/metapath.c  |  6 +++---
 fs/xfs/scrub/nlinks.c    | 12 ++++++------
 fs/xfs/scrub/parent.c    |  6 +++---
 fs/xfs/scrub/rtbitmap.c  | 12 ++++++------
 fs/xfs/scrub/rtsummary.c | 12 ++++++------
 10 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 67861102cdb9..6dc1f6eea45e 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1040,7 +1040,7 @@ xchk_bmap(
 	case XFS_COW_FORK:
 		/* No CoW forks filesystem doesn't support out of place writes */
 		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 			return 0;
 		}
 		break;
@@ -1052,7 +1052,7 @@ xchk_bmap(
 		 * attr here.
 		 */
 		if (!xfs_has_attr(mp))
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		break;
 	default:
 		ASSERT(whichfork == XFS_DATA_FORK);
@@ -1137,7 +1137,7 @@ xchk_bmap_data(
 	int			error;
 
 	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTD_ZAPPED)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -1165,7 +1165,7 @@ xchk_bmap_attr(
 	 * returning immediately.
 	 */
 	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTA_ZAPPED)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 20e63069088b..5041f0c91603 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1099,7 +1099,7 @@ xchk_install_live_inode(
 	struct xfs_inode	*ip)
 {
 	if (!igrab(VFS_I(ip))) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		return -EFSCORRUPTED;
 	}
 
@@ -1428,13 +1428,13 @@ xchk_metadata_inode_forks(
 
 	/* Metadata inodes don't live on the rt device. */
 	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
 	/* They should never participate in reflink. */
 	if (xfs_is_reflink_inode(sc->ip)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -1451,7 +1451,7 @@ xchk_metadata_inode_forks(
 				&error))
 			return error;
 		if (shared)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 	/*
@@ -1460,7 +1460,7 @@ xchk_metadata_inode_forks(
 	 */
 	if (xfs_inode_hasattr(sc->ip)) {
 		if (!xfs_has_metadir(sc->mp)) {
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 			return 0;
 		}
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f2ecc68538f0..ae998501f8aa 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -30,6 +30,8 @@ void xchk_set_corrupt(struct xfs_scrub *sc);
 void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
+#define xchk_ip_set_corrupt(_sc, _ip) \
+	xchk_ino_set_corrupt((_sc), (_ip)->i_ino)
 void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
 #ifdef CONFIG_XFS_QUOTA
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e09724cd3725..c810c154d72e 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -1075,7 +1075,7 @@ xchk_directory(
 
 	/* Plausible size? */
 	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 143114718d75..124b2379d5c4 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -979,10 +979,10 @@ xchk_dirtree(
 	xchk_dirtree_evaluate(dl, &oc);
 	if (xchk_dirtree_parentless(dl)) {
 		if (oc.good || oc.bad || oc.suspect)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	} else {
 		if (oc.bad || oc.good + oc.suspect != 1)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		if (oc.suspect)
 			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 	}
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 050b86eb12d3..680a8ba1cdf1 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -314,7 +314,7 @@ xchk_metapath(
 
 	/* Parent required to do anything else. */
 	if (mpath->dp == NULL) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -329,7 +329,7 @@ xchk_metapath(
 	trace_xchk_metapath_lookup(sc, mpath->path, mpath->dp, ino);
 	if (error == -ENOENT) {
 		/* No directory entry at all */
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_ilock;
 	}
@@ -337,7 +337,7 @@ xchk_metapath(
 		goto out_ilock;
 	if (ino != sc->ip->i_ino) {
 		/* Pointing to wrong inode */
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 out_ilock:
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 1e0effdb65a6..2a214802c77c 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -718,7 +718,7 @@ xchk_nlinks_compare_inode(
 	 * count, but it will let them decrease it.
 	 */
 	if (total_links > XFS_NLINK_PINNED) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		goto out_corrupt;
 	} else if (total_links > XFS_MAXLINK) {
 		xchk_ino_set_warning(sc, ip->i_ino);
@@ -726,7 +726,7 @@ xchk_nlinks_compare_inode(
 
 	/* Link counts should match. */
 	if (total_links != actual_nlink) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		goto out_corrupt;
 	}
 
@@ -747,7 +747,7 @@ xchk_nlinks_compare_inode(
 		 * back references.
 		 */
 		if (obs.backrefs != 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 
@@ -756,7 +756,7 @@ xchk_nlinks_compare_inode(
 		 * children.
 		 */
 		if (obs.children != 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	}
@@ -769,7 +769,7 @@ xchk_nlinks_compare_inode(
 		 * the root directory.
 		 */
 		if (obs.parents != 1) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	} else if (actual_nlink > 0) {
@@ -778,7 +778,7 @@ xchk_nlinks_compare_inode(
 		 * least one parent.
 		 */
 		if (obs.parents == 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 931604fa1294..eb9ca3d75fef 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -729,10 +729,10 @@ xchk_parent_count_pptrs(
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		else if (VFS_I(sc->ip)->i_nlink > 0 &&
 			 pp->pptrs_found == 0)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	} else {
 		/*
 		 * Starting with metadir, we allow checking of parent pointers
@@ -743,7 +743,7 @@ xchk_parent_count_pptrs(
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink != pp->pptrs_found)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 	return 0;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index b3a4972d423e..10d4c11372d9 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -200,13 +200,13 @@ xchk_rtbitmap(
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rtb->rextents) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* Is sb_rextslog correct? */
 	if (mp->m_sb.sb_rextslog != rtb->rextslog) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
@@ -215,17 +215,17 @@ xchk_rtbitmap(
 	 * case can we exceed 4bn bitmap blocks since the super field is a u32.
 	 */
 	if (rtb->rbmblocks > U32_MAX) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* The bitmap file length must be aligned to an fsblock. */
 	if (rbmip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
@@ -235,7 +235,7 @@ xchk_rtbitmap(
 	 * file can be larger than sb_rbmblocks.
 	 */
 	if (rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index efce39d7a1ef..18074c1ff166 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -314,25 +314,25 @@ xchk_rtsummary(
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rts->rextents) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* Is m_rsumlevels correct? */
 	if (mp->m_rsumlevels != rts->rsumlevels) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
 	/* Is m_rsumsize correct? */
 	if (mp->m_rsumblocks != rts->rsumblocks) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
 	/* The summary file length must be aligned to an fsblock. */
 	if (rsumip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
@@ -342,7 +342,7 @@ xchk_rtsummary(
 	 * the file can be larger than rsumsize.
 	 */
 	if (rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
@@ -358,7 +358,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (error)
-- 
2.53.0

