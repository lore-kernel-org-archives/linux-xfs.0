Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753189AbeDBTzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 15:55:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w32JrQnp166587
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:51 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2h3u2vg0br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Apr 2018 19:55:51 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w32JtaNw027252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:36 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w32JtaVi029344
        for <linux-xfs@vger.kernel.org>; Mon, 2 Apr 2018 19:55:36 GMT
Subject: [PATCH 1/2] xfs: skip scrub xref if corruption already noted
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 02 Apr 2018 12:55:36 -0700
Message-ID: <152269893600.16253.2058199896357918178.stgit@magnolia>
In-Reply-To: <152269892987.16253.3900560313483881560.stgit@magnolia>
References: <152269892987.16253.3900560313483881560.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/alloc.c    |    4 +++-
 fs/xfs/scrub/common.c   |    5 +++++
 fs/xfs/scrub/ialloc.c   |    4 +++-
 fs/xfs/scrub/refcount.c |    8 ++++++--
 fs/xfs/scrub/rmap.c     |    8 ++++++--
 fs/xfs/scrub/rtbitmap.c |    4 ++++
 6 files changed, 27 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 517c079..096bc53 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -172,7 +172,9 @@ xfs_scrub_xref_is_used_space(
 	bool				is_freesp;
 	int				error;
 
-	if (!sc->sa.bno_cur)
+	if (!sc->sa.bno_cur ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fe3a2b1..ddb0ff6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -727,6 +727,11 @@ xfs_scrub_should_check_xref(
 	int				*error,
 	struct xfs_btree_cur		**curpp)
 {
+	/* No point in xref if we already know we're corrupt. */
+	if (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				XFS_SCRUB_OFLAG_XCORRUPT))
+		return false;
+
 	if (*error == 0)
 		return true;
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 106ca4b..6e1ce25 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -496,7 +496,9 @@ xfs_scrub_xref_inode_check(
 	bool				has_inodes;
 	int				error;
 
-	if (!(*icur))
+	if (!(*icur) ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 400f156..1f9787a 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -460,7 +460,9 @@ xfs_scrub_xref_is_cow_staging(
 	int				has_refcount;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	/* Find the CoW staging extent. */
@@ -504,7 +506,9 @@ xfs_scrub_xref_is_not_shared(
 	bool				shared;
 	int				error;
 
-	if (!sc->sa.refc_cur)
+	if (!sc->sa.refc_cur ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8f2a7c3..b7c2ef4 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -207,7 +207,9 @@ xfs_scrub_xref_check_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
@@ -250,7 +252,9 @@ xfs_scrub_xref_has_no_owner(
 	bool				has_rmap;
 	int				error;
 
-	if (!sc->sa.rmap_cur)
+	if (!sc->sa.rmap_cur ||
+	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				 XFS_SCRUB_OFLAG_XCORRUPT)))
 		return;
 
 	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 39c41dfe..54255f3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -110,6 +110,10 @@ xfs_scrub_xref_is_used_rt_space(
 	bool				is_free;
 	int				error;
 
+	if (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				XFS_SCRUB_OFLAG_XCORRUPT))
+		return;
+
 	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
 			&is_free);

