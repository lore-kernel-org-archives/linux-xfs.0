Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74029BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9WcrRa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E125DC433C8;
	Sun, 31 Dec 2023 21:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058792;
	bh=4Y3RjqnT63jn9C3rnGbNJHdNCC3WM5jGO+C4mF3aUA4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E9WcrRa2LIzh5KIZGhv/8jOvktAWIwBJYRWRppKiAJpkPpYTDqnzgEigeTZQNraxE
	 9wzotwF+HMlRixTdDI90kB159nnKFqEC4feAfP6s8vbCFrGM8Uvh4jjEe8asTgIx29
	 QbSapTwuhSUt4w/ABsUKTFli96my1dowiavcN0zrji5Yktv6oHrZX1UsR6dA3+CciM
	 7sdxwgZiTxsSIYfqiRxvHMph3HJygl38YTXgSad+OxP/4s8Jg02S6LS0b1Il0rj/w1
	 KcMJZ75meGimbr4uYdp5C7tMdBO0Gja3J6gOWBZUm2lalgSRaEd0Omm2FNBi+VS6Yt
	 l1xSk9WWre7rw==
Date: Sun, 31 Dec 2023 13:39:52 -0800
Subject: [PATCH 31/39] xfs: online repair of realtime file bmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850399.1764998.13883768550246417804.stgit@frogsfrogsfrogs>
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

Repair the block mappings of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |  127 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.c      |    2 -
 fs/xfs/scrub/common.h      |    3 +
 fs/xfs/scrub/repair.c      |   93 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |   11 ++++
 5 files changed, 231 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 9dddc5997b4fc..25c52caae58a4 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -25,11 +25,13 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_quota.h"
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
 #include "xfs_reflink.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -361,6 +363,116 @@ xrep_bmap_scan_ag(
 	return error;
 }
 
+#ifdef CONFIG_XFS_RT
+/* Check for any obvious errors or conflicts in the file mapping. */
+STATIC int
+xrep_bmap_check_rtfork_rmap(
+	struct xfs_scrub		*sc,
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec)
+{
+	xfs_rtblock_t			rtbno;
+
+	/* xattr extents are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+		return -EFSCORRUPTED;
+
+	/* bmbt blocks are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return -EFSCORRUPTED;
+
+	/* Data extents for non-rt files are never stored on the rt device. */
+	if (!XFS_IS_REALTIME_INODE(sc->ip))
+		return -EFSCORRUPTED;
+
+	/* Check the file offsets and physical extents. */
+	if (!xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Check that this is within the rtgroup. */
+	if (!xfs_verify_rgbext(cur->bc_ino.rtg, rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	rtbno = xfs_rgbno_to_rtb(sc->mp, cur->bc_ino.rtg->rtg_rgno,
+			rec->rm_startblock);
+	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount);
+}
+
+/* Record realtime extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_bmap		*rb = priv;
+	xfs_rtblock_t			rtbno;
+	int				error = 0;
+
+	if (xchk_should_terminate(rb->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_bmap_check_rtfork_rmap(rb->sc, cur, rec);
+	if (error)
+		return error;
+
+	/*
+	 * Record all blocks allocated to this file even if the extent isn't
+	 * for the fork we're rebuilding so that we can reset di_nblocks later.
+	 */
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	rtbno = xfs_rgbno_to_rtb(cur->bc_mp, cur->bc_ino.rtg->rtg_rgno,
+			rec->rm_startblock);
+	return xrep_bmap_from_rmap(rb, rec->rm_offset, rtbno,
+			rec->rm_blockcount,
+			rec->rm_flags & XFS_RMAP_UNWRITTEN);
+}
+
+/* Scan the realtime reverse mappings to build the new extent map. */
+STATIC int
+xrep_bmap_scan_rtgroup(
+	struct xrep_bmap	*rb,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	int			error;
+
+	if (xrep_is_rtmeta_ino(sc, rtg, sc->ip->i_ino))
+		return 0;
+
+	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
+			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_BITMAP_SHARED);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sr.rmap_cur, xrep_bmap_walk_rtrmap, rb);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_free(sc, &sc->sr);
+	return error;
+}
+#else
+static inline int
+xrep_bmap_scan_rtgroup(struct xrep_bmap *rb, struct xfs_rtgroup *rtg)
+{
+	return -EFSCORRUPTED;
+}
+#endif
+
 /* Find the delalloc extents from the old incore extent tree. */
 STATIC int
 xrep_bmap_find_delalloc(
@@ -410,9 +522,20 @@ xrep_bmap_find_mappings(
 {
 	struct xfs_scrub	*sc = rb->sc;
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error = 0;
 
+	/* Iterate the rtrmaps for extents. */
+	for_each_rtgroup(sc->mp, rgno, rtg) {
+		error = xrep_bmap_scan_rtgroup(rb, rtg);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	for_each_perag(sc->mp, agno, pag) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -751,10 +874,6 @@ xrep_bmap_check_inputs(
 		return -EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return -EOPNOTSUPP;
-
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5ea9f3f310335..e16185e9ddd9b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -779,7 +779,7 @@ xchk_rt_unlock_rtbitmap(
 
 #ifdef CONFIG_XFS_RT
 /* Lock all the rt group metadata inode ILOCKs and wait for intents. */
-static int
+int
 xchk_rtgroup_drain_and_lock(
 	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr,
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 3251f80c00e15..c0b2c62d4bd82 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -159,10 +159,13 @@ int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+int xchk_rtgroup_drain_and_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
+		unsigned int rtglock_flags);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr, lockflags)	(-ENOSYS)
 # define xchk_rtgroup_btcur_free(sr)			((void)0)
 # define xchk_rtgroup_free(sc, sr)			((void)0)
+# define xchk_rtgroup_drain_and_lock(sc, sr, lockflags)	(-ENOSYS)
 #endif /* CONFIG_XFS_RT */
 
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index cad45d5b86e2e..5af1a8871de55 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -36,6 +36,9 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_dir2.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -954,6 +957,73 @@ xrep_ag_init(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
+/* Initialize all the btree cursors for a RT repair. */
+static void
+xrep_rtgroup_btcur_init(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	struct xfs_mount	*mp = sc->mp;
+
+	ASSERT(sr->rtg != NULL);
+
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_RTRMAPBT &&
+	    (sr->rtlock_flags & XFS_RTGLOCK_RMAP) &&
+	    xfs_has_rtrmapbt(mp))
+		sr->rmap_cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, sr->rtg,
+				sr->rtg->rtg_rmapip);
+}
+
+/*
+ * Given a reference to a rtgroup structure, lock rtgroup btree inodes and
+ * create btree cursors.  Must only be called to repair a regular rt file.
+ */
+int
+xrep_rtgroup_init(
+	struct xfs_scrub	*sc,
+	struct xfs_rtgroup	*rtg,
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(sr->rtg == NULL);
+
+	xfs_rtgroup_lock(NULL, rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+
+	/* Grab our own passive reference from the caller's ref. */
+	sr->rtg = xfs_rtgroup_hold(rtg);
+	xrep_rtgroup_btcur_init(sc, sr);
+	return 0;
+}
+
+/* Ensure that all rt blocks in the given range are not marked free. */
+int
+xrep_require_rtext_inuse(
+	struct xfs_scrub	*sc,
+	xfs_rtblock_t		rtbno,
+	xfs_filblks_t		len)
+{
+	struct xfs_mount	*mp = sc->mp;
+	xfs_rtxnum_t		startrtx;
+	xfs_rtxnum_t		endrtx;
+	bool			is_free = false;
+	int			error;
+
+	startrtx = xfs_rtb_to_rtx(mp, rtbno);
+	endrtx = xfs_rtb_to_rtx(mp, rtbno + len - 1);
+
+	error = xfs_rtalloc_extent_is_free(mp, sc->tp, startrtx,
+			endrtx - startrtx + 1, &is_free);
+	if (error)
+		return error;
+	if (is_free)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Reinitialize the per-AG block reservation for the AG we just fixed. */
 int
 xrep_reset_perag_resv(
@@ -1209,3 +1279,26 @@ xrep_buf_verify_struct(
 
 	return fa == NULL;
 }
+
+/* Are we looking at a realtime metadata inode? */
+bool
+xrep_is_rtmeta_ino(
+	struct xfs_scrub	*sc,
+	struct xfs_rtgroup	*rtg,
+	xfs_ino_t		ino)
+{
+	/*
+	 * All filesystems have rt bitmap and summary inodes, even if they
+	 * don't have an rt section.
+	 */
+	if (ino == sc->mp->m_rbmip->i_ino)
+		return true;
+	if (ino == sc->mp->m_rsumip->i_ino)
+		return true;
+
+	/* Newer rt metadata files are not guaranteed to exist */
+	if (rtg->rtg_rmapip && ino == rtg->rtg_rmapip->i_ino)
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 3d8ca12b2cc51..e7fe4c5d8de5d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -106,6 +106,17 @@ int xrep_setup_inode(struct xfs_scrub *sc, const struct xfs_imap *imap);
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
 		struct xchk_ag *sa);
+#ifdef CONFIG_XFS_RT
+int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
+		struct xchk_rt *sr, unsigned int rtglock_flags);
+int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
+		xfs_filblks_t len);
+#else
+# define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
+
+bool xrep_is_rtmeta_ino(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
+		xfs_ino_t ino);
 
 /* Metadata revalidators */
 

