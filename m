Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbeDCDAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 23:00:49 -0400
Date: Mon, 2 Apr 2018 20:00:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/2] xfs: skip scrub xref if corruption already noted
Message-ID: <20180403030046.GF13552@magnolia>
References: <152269892987.16253.3900560313483881560.stgit@magnolia>
 <152269893600.16253.2058199896357918178.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269893600.16253.2058199896357918178.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother looking for cross-referencing problems if the metadata is
already corrupt or we've already found a cross-referencing problem.
Since we added a helper function for flags testing, convert existing
users to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add helper function instead of open coding
---
 fs/xfs/scrub/alloc.c    |    2 +-
 fs/xfs/scrub/common.c   |    4 ++++
 fs/xfs/scrub/common.h   |    6 ++++++
 fs/xfs/scrub/ialloc.c   |    2 +-
 fs/xfs/scrub/refcount.c |    4 ++--
 fs/xfs/scrub/rmap.c     |    4 ++--
 fs/xfs/scrub/rtbitmap.c |    3 +++
 fs/xfs/scrub/scrub.c    |    3 +--
 8 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 517c079..f5c6993 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -172,7 +172,7 @@ xfs_scrub_xref_is_used_space(
 	bool				is_freesp;
 	int				error;
 
-	if (!sc->sa.bno_cur)
+	if (!sc->sa.bno_cur || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fe3a2b1..51d2a59 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -727,6 +727,10 @@ xfs_scrub_should_check_xref(
 	int				*error,
 	struct xfs_btree_cur		**curpp)
 {
+	/* No point in xref if we already know we're corrupt. */
+	if (xfs_scrub_found_corruption(sc->sm))
+		return false;
+
 	if (*error == 0)
 		return true;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index deaf604..30e9039 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -157,4 +157,10 @@ int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
 				   struct xfs_inode *ip, unsigned int resblks);
 void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
 
+static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT);
+}
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 106ca4b..05e6191 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -496,7 +496,7 @@ xfs_scrub_xref_inode_check(
 	bool				has_inodes;
 	int				error;
 
-	if (!(*icur))
+	if (!(*icur) || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 400f156..823bda3 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -460,7 +460,7 @@ xfs_scrub_xref_is_cow_staging(
 	int				has_refcount;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	/* Find the CoW staging extent. */
@@ -504,7 +504,7 @@ xfs_scrub_xref_is_not_shared(
 	bool				shared;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8f2a7c3..9ca92e4 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -207,7 +207,7 @@ xfs_scrub_xref_check_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
@@ -250,7 +250,7 @@ xfs_scrub_xref_has_no_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur || xfs_scrub_found_corruption(sc->sm))
 		return;
 
 	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 39c41dfe..c8672f7 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -110,6 +110,9 @@ xfs_scrub_xref_is_used_rt_space(
 	bool				is_free;
 	int				error;
 
+	if (xfs_scrub_found_corruption(sc->sm))
+		return;
+
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
 			&is_free);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 26c7596..cb1e727 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -446,8 +446,7 @@ xfs_scrub_metadata(
 	} else if (error)
 		goto out_teardown;
 
-	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-			       XFS_SCRUB_OFLAG_XCORRUPT))
+	if (xfs_scrub_found_corruption(sc.sm))
 		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
 
 out_teardown:
