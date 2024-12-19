Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491B41B394E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636626; cv=none; b=CBTgvxNta1XC0dIGwFNHcE8dZCVWZfVq0MymhtlKUmZjsHhmZp1Rp13njQZNweZTAgcFWMa8pwpNl9BEpkEwucCpE/qNTst1NJyp4zxxp8WnHvqgyBDU5f8bHUYhr7wSOF3eY5kuwrpm//gWTj2HvlFmabtjSiXOwr7KqhY8sg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636626; c=relaxed/simple;
	bh=oUECwuUhbUZ2H3ncledvAgSN9MokcMM9j7SBjr8iQKA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j52mQZ/HlHKY9JJ5cQ53X95aiJLT93jP7122gPI7GAYHNP2sOy0DCrV1EVi1NY2NEXP0XdDjiwX/jGgMGZ0L1Q8XxYk2pXpuO3+ikMYbDkNR+P3DZjxsX1O7JPNQKKvX0xBz0It0Pt/0/l4equKlf5DoDdId6QHqj2yYnW+5ABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/eZVSLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/eZVSLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226CAC4CECE;
	Thu, 19 Dec 2024 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636626;
	bh=oUECwuUhbUZ2H3ncledvAgSN9MokcMM9j7SBjr8iQKA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F/eZVSLr8KXQfg/a8ooSZ3rLh7CY3rLI2ZEeHcNuirzmBHJ1lclOCCAQ4aBNOaV8z
	 DClgq3fVnihuG+Sa89mtCbUjEZaqxRktba93M2a0dGHJQ/xq4Yv5CYuYBlv6dbD2CZ
	 x/4FfsuLBzEgo6JrE2P3j31Ls2gc9gV/52aqE2Bwa9veo+Lin3xDM04qoCH0z5BdXj
	 j16Tz7vtIVmV0LyKfjRhXA1ZfLnVps7XN4mpLjIokQs0KYuw54Cvz3GI9T1qrFOwu5
	 nqXUBTXtU24OFeJvQFd+DLpBhuaiq4+Y/UuiM67+o6Efh99FP8dD3iiFAS4y/iV9sC
	 gLUtmFw94gJ7g==
Date: Thu, 19 Dec 2024 11:30:25 -0800
Subject: [PATCH 27/37] xfs: online repair of realtime file bmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580220.1571512.12389318349614689954.stgit@frogsfrogsfrogs>
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

Now that we have a reverse-mapping index of the realtime device, we can
rebuild the data fork forward-mappings of any realtime file.  Enhance
the existing bmbt repair code to walk the rtrmap btrees to gather this
information.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |  128 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/repair.c      |   46 ++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 +
 3 files changed, 172 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 141d36f1da9a71..fd64bdf4e13887 100644
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
@@ -359,6 +361,112 @@ xrep_bmap_scan_ag(
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
+	if (!xfs_verify_rgbext(to_rtg(cur->bc_group), rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	return xrep_require_rtext_inuse(sc, rec->rm_startblock,
+			rec->rm_blockcount);
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
+	return xrep_bmap_from_rmap(rb, rec->rm_offset,
+			xfs_rgbno_to_rtb(to_rtg(cur->bc_group),
+				rec->rm_startblock),
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
+	if (!xfs_has_rtrmapbt(sc->mp))
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
@@ -410,6 +518,22 @@ xrep_bmap_find_mappings(
 	struct xfs_perag	*pag = NULL;
 	int			error = 0;
 
+	/*
+	 * Iterate the rtrmaps for extents.  Metadata files never have content
+	 * on the realtime device, so there's no need to scan them.
+	 */
+	if (!xfs_is_metadir_inode(sc->ip)) {
+		struct xfs_rtgroup	*rtg = NULL;
+
+		while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
+			error = xrep_bmap_scan_rtgroup(rb, rtg);
+			if (error) {
+				xfs_rtgroup_rele(rtg);
+				return error;
+			}
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -754,10 +878,6 @@ xrep_bmap_check_inputs(
 		return -EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return -EOPNOTSUPP;
-
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e788e3032f8e33..18946dd46fa745 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -37,6 +37,9 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_dir2.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -955,6 +958,22 @@ xrep_ag_init(
 }
 
 #ifdef CONFIG_XFS_RT
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
+		sr->rmap_cur = xfs_rtrmapbt_init_cursor(sc->tp, sr->rtg);
+}
+
 /*
  * Given a reference to a rtgroup structure, lock rtgroup btree inodes and
  * create btree cursors.  Must only be called to repair a regular rt file.
@@ -973,6 +992,33 @@ xrep_rtgroup_init(
 
 	/* Grab our own passive reference from the caller's ref. */
 	sr->rtg = xfs_rtgroup_hold(rtg);
+	xrep_rtgroup_btcur_init(sc, sr);
+	return 0;
+}
+
+/* Ensure that all rt blocks in the given range are not marked free. */
+int
+xrep_require_rtext_inuse(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		rgbno,
+	xfs_filblks_t		len)
+{
+	struct xfs_mount	*mp = sc->mp;
+	xfs_rtxnum_t		startrtx;
+	xfs_rtxnum_t		endrtx;
+	bool			is_free = false;
+	int			error;
+
+	startrtx = xfs_rgbno_to_rtx(mp, rgbno);
+	endrtx = xfs_rgbno_to_rtx(mp, rgbno + len - 1);
+
+	error = xfs_rtalloc_extent_is_free(sc->sr.rtg, sc->tp, startrtx,
+			endrtx - startrtx + 1, &is_free);
+	if (error)
+		return error;
+	if (is_free)
+		return -EFSCORRUPTED;
+
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index b649da1a93eb8c..584135042d9aa9 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -110,6 +110,8 @@ int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
 #ifdef CONFIG_XFS_RT
 int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
+int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_filblks_t len);
 #else
 # define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
 #endif /* CONFIG_XFS_RT */

