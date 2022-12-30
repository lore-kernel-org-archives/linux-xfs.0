Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90183C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiLaBpP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiLaBpO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:45:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD34113DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F73BB81DDA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45FAC433EF;
        Sat, 31 Dec 2022 01:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451111;
        bh=9b1x5bNhXEv2NOM3znWKwHKu+jSC3MWyRcXHH5B992U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aybQE2FWLOAdzqwfJKsgNYu6ihJE3pKA/XtZhAXj7YT6CWskM27jaFDVwS9YvFtin
         c2MG6AyEYz36HvkFl+fsJWYC05SHLvTeGtNQsSfmqwArvcFxSmGbsFH3rWEoAmEmD8
         Cak4t/diTsLehvu4RMD37vY9mrYfPXzge41QlqZU0797vdDJRLoMRV+w6oV+iM/9NZ
         BU6ttEKpCGLi9tY/nCZmC6zwLFXbEwDsXhsMuduylviLtskKX8ZetqjV8qYrVf94UH
         s4Y+BgiqL8aOybbz5bKYLMtNsZ43w1tkydd8hSDc0L3vggrBaeBJ7UMwOySmmrmNpz
         JQk3AK7duz+ug==
Subject: [PATCH 32/38] xfs: online repair of realtime file bmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870059.715303.6185832700825166013.stgit@magnolia>
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
index ca7df344581d..77d601afbcfb 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -25,10 +25,12 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_quota.h"
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -313,6 +315,116 @@ xrep_bmap_scan_ag(
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
@@ -362,9 +474,20 @@ xrep_bmap_find_mappings(
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
+			xfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	for_each_perag(sc->mp, agno, pag) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -705,10 +828,6 @@ xrep_bmap_check_inputs(
 		return -EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return -EOPNOTSUPP;
-
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fa8e0064c41d..18763d136ef5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -760,7 +760,7 @@ xchk_rt_unlock(
 
 #ifdef CONFIG_XFS_RT
 /* Lock all the rt group metadata inode ILOCKs and wait for intents. */
-static int
+int
 xchk_rtgroup_lock(
 	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr,
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9ca2fbaac72c..e135f792cfcc 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -181,10 +181,13 @@ int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+int xchk_rtgroup_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
+		unsigned int rtglock_flags);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr, lockflags)	(-ENOSYS)
 # define xchk_rtgroup_btcur_free(sr)			((void)0)
 # define xchk_rtgroup_free(sc, sr)			((void)0)
+# define xchk_rtgroup_lock(sc, sr, lockflags)		(-ENOSYS)
 #endif /* CONFIG_XFS_RT */
 
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index eb0dda2df7af..18ce73dcdf3b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -35,6 +35,9 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_dir2.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -937,6 +940,73 @@ xrep_ag_init(
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
+	/* Grab our own reference to the rtgroup structure. */
+	sr->rtg = xfs_rtgroup_bump(rtg);
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
+	startrtx = xfs_rtb_to_rtxt(mp, rtbno);
+	endrtx = xfs_rtb_to_rtxt(mp, rtbno + len - 1);
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
@@ -1261,3 +1331,26 @@ xrep_dotdot_lookup(
 
 	return ino;
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
index 292e252efae3..c75081185c24 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -100,6 +100,17 @@ int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *resblks);
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
 

