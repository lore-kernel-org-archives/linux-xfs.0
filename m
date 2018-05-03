Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECSGR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I1CNm087160
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2hmgxg30n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:06:16 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6F7b030610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:15 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w43I6FuQ002737
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:15 GMT
Subject: [PATCH 03/12] xfs: skip scrub xref if corruption already noted
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:13 -0700
Message-ID: <152537077375.16676.17388976569697153088.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
index 517c079d3f68..941a0a55224e 100644
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
index 639d14b51e90..fb91caf17652 100644
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
index 8ed91d5c868d..e9ca5f0802d5 100644
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
index deaf60400981..80fa5a67c265 100644
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
index 106ca4bd753f..00a834d3b56d 100644
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
index df14930e4fc5..8532fc7be838 100644
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
index 400f1561cd3d..913b0a190e68 100644
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
index 8f2a7c3ff455..b376a9a77c04 100644
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
index 39c41dfe08ee..8b048f107af2 100644
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
index 26c75967a072..d9ecbb6ad4a3 100644
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

