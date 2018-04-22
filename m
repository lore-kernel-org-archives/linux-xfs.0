Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755002AbeDVPH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:57 -0400
Subject: [PATCH 01/10] xfs: skip scrub xref if corruption already noted
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:37 -0700
Message-ID: <152440965765.30048.15182353257682065664.stgit@magnolia>
In-Reply-To: <152440964593.30048.15577210457233332459.stgit@magnolia>
References: <152440964593.30048.15577210457233332459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother looking for cross-referencing problems if the metadata is
already corrupt or we've already found a cross-referencing problem.
Since we added a helper function for flags testing, convert existing
users to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/alloc.c    |    4 ++--
 fs/xfs/scrub/bmap.c     |    2 +-
 fs/xfs/scrub/common.c   |    4 ++++
 fs/xfs/scrub/common.h   |   10 ++++++++++
 fs/xfs/scrub/ialloc.c   |    7 ++++---
 fs/xfs/scrub/inode.c    |    5 ++++-
 fs/xfs/scrub/refcount.c |    8 ++++----
 fs/xfs/scrub/rmap.c     |    6 +++---
 fs/xfs/scrub/rtbitmap.c |    3 +++
 fs/xfs/scrub/scrub.c    |    4 ++--
 10 files changed, 37 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 517c079..941a0a5 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -70,7 +70,7 @@ xfs_scrub_allocbt_xref_other(
 		pcur = &sc->sa.cnt_cur;
 	else
 		pcur = &sc->sa.bno_cur;
-	if (!*pcur)
+	if (!*pcur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_alloc_lookup_le(*pcur, agbno, len, &has_otherrec);
@@ -172,7 +172,7 @@ xfs_scrub_xref_is_used_space(
 	bool				is_freesp;
 	int				error;
 
-	if (!sc->sa.bno_cur)
+	if (!sc->sa.bno_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 639d14b..fb91caf 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -175,7 +175,7 @@ xfs_scrub_bmap_xref_rmap(
 	unsigned long long		rmap_end;
 	uint64_t			owner;
 
-	if (!info->sc->sa.rmap_cur)
+	if (!info->sc->sa.rmap_cur || xfs_scrub_skip_xref(info->sc->sm))
 		return;
 
 	if (info->whichfork == XFS_COW_FORK)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8ed91d5..e9ca5f0 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -727,6 +727,10 @@ xfs_scrub_should_check_xref(
 	int				*error,
 	struct xfs_btree_cur		**curpp)
 {
+	/* No point in xref if we already know we're corrupt. */
+	if (xfs_scrub_skip_xref(sc->sm))
+		return false;
+
 	if (*error == 0)
 		return true;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index deaf604..80fa5a6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -157,4 +157,14 @@ int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
 				   struct xfs_inode *ip, unsigned int resblks);
 void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
 
+/*
+ * Don't bother cross-referencing if we already found corruption or cross
+ * referencing discrepancies.
+ */
+static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT);
+}
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 106ca4b..00a834d 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -387,7 +387,8 @@ xfs_scrub_iallocbt_xref_rmap_btreeblks(
 	int				error;
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
-	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur))
+	    (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->sa.fino_cur) ||
+	    xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many inobt blocks as the rmap says. */
@@ -424,7 +425,7 @@ xfs_scrub_iallocbt_xref_rmap_inodes(
 	xfs_filblks_t			blocks;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many inode blocks as the rmap knows about. */
@@ -496,7 +497,7 @@ xfs_scrub_xref_inode_check(
 	bool				has_inodes;
 	int				error;
 
-	if (!(*icur))
+	if (!(*icur) || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index df14930..8532fc7 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -449,7 +449,7 @@ xfs_scrub_inode_xref_finobt(
 	int				has_record;
 	int				error;
 
-	if (!sc->sa.fino_cur)
+	if (!sc->sa.fino_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	agino = XFS_INO_TO_AGINO(sc->mp, ino);
@@ -492,6 +492,9 @@ xfs_scrub_inode_xref_bmap(
 	xfs_filblks_t			acount;
 	int				error;
 
+	if (xfs_scrub_skip_xref(sc->sm))
+		return;
+
 	/* Walk all the extents to check nextents/naextents/nblocks. */
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
 			&nextents, &count);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 400f156..913b0a1 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -310,7 +310,7 @@ xfs_scrub_refcountbt_xref_rmap(
 	struct xfs_scrub_refcnt_frag	*n;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	/* Cross-reference with the rmapbt to confirm the refcount. */
@@ -404,7 +404,7 @@ xfs_scrub_refcount_xref_rmap(
 	xfs_filblks_t			blocks;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
@@ -460,7 +460,7 @@ xfs_scrub_xref_is_cow_staging(
 	int				has_refcount;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	/* Find the CoW staging extent. */
@@ -504,7 +504,7 @@ xfs_scrub_xref_is_not_shared(
 	bool				shared;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8f2a7c3..b376a9a 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -66,7 +66,7 @@ xfs_scrub_rmapbt_xref_refc(
 	bool				is_unwritten;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	non_inode = XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
@@ -207,7 +207,7 @@ xfs_scrub_xref_check_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
@@ -250,7 +250,7 @@ xfs_scrub_xref_has_no_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_skip_xref(sc->sm))
 		return;
 
 	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 39c41dfe..8b048f1 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -110,6 +110,9 @@ xfs_scrub_xref_is_used_rt_space(
 	bool				is_free;
 	int				error;
 
+	if (xfs_scrub_skip_xref(sc->sm))
+		return;
+
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
 			&is_free);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 26c7596..d9ecbb6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -446,8 +446,8 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
-	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-			       XFS_SCRUB_OFLAG_XCORRUPT))
+	if (sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			    XFS_SCRUB_OFLAG_XCORRUPT))
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:

