Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19946 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758457AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 35/55] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:09 -0800
Message-ID: <148072914974.12995.14395730006723595402.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Ensure that none of the AG btree records overlap the AG sb/agf/agfl/agi
headers except for the XFS_RMAP_OWN_FS rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |   27 +++++++++++++++++++++++++++
 fs/xfs/repair/alloc.c    |    4 ++++
 fs/xfs/repair/bmap.c     |    5 +++++
 fs/xfs/repair/common.h   |    3 +++
 fs/xfs/repair/ialloc.c   |    4 ++++
 fs/xfs/repair/refcount.c |    4 ++++
 fs/xfs/repair/rmap.c     |    5 +++++
 7 files changed, 52 insertions(+)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 2bab685..c1b4b13 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -99,6 +99,30 @@ xfs_scrub_walk_agfl(
 	return 0;
 }
 
+/* Does this AG extent cover the AG headers? */
+bool
+xfs_scrub_extent_covers_ag_head(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len)
+{
+	xfs_agblock_t		bno;
+
+	bno = XFS_SB_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGF_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGFL_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGI_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	return false;
+}
+
 /* Superblock */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -452,6 +476,9 @@ xfs_scrub_agfl_block(
 	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
 	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_AGFL_CHECK(!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 	/* Cross-reference with the bnobt. */
 	if (sc->sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index 89f80f3..6369f09 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -70,6 +70,10 @@ xfs_scrub_allocbt_helper(
 	if (error)
 		goto out;
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/*
 	 * Ensure there's a corresponding cntbt/bnobt record matching
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index d81214a..b4f0abb 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -121,6 +121,11 @@ xfs_scrub_bmap_extent(
 		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
 	}
 
+	/* Make sure we don't cover the AG headers. */
+	if (!info->is_rt)
+		XFS_SCRUB_BMAP_CHECK(!xfs_scrub_extent_covers_ag_head(mp,
+				bno, irec->br_blockcount));
+
 	/* Cross-reference with the bnobt. */
 	if (sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sa.bno_cur, bno,
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index fbde19c..f638703 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -203,6 +203,9 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
 				  void *),
 			void *priv);
+bool xfs_scrub_extent_covers_ag_head(struct xfs_mount *mp, xfs_agblock_t agbno,
+				     xfs_extlen_t len);
+
 /* Metadata scrubbers */
 
 int xfs_scrub_superblock(struct xfs_scrub_context *sc);
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 70fc5fc..4f01932 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -76,6 +76,10 @@ xfs_scrub_iallocbt_chunk(
 		goto out;
 	}
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/repair/refcount.c b/fs/xfs/repair/refcount.c
index f5c0aef..527a916 100644
--- a/fs/xfs/repair/refcount.c
+++ b/fs/xfs/repair/refcount.c
@@ -76,6 +76,10 @@ xfs_scrub_refcountbt_helper(
 	if (error)
 		goto out;
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs, !xfs_scrub_extent_covers_ag_head(mp,
+			irec.rc_startblock, irec.rc_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
index ef2aea5..401580e 100644
--- a/fs/xfs/repair/rmap.c
+++ b/fs/xfs/repair/rmap.c
@@ -106,6 +106,11 @@ xfs_scrub_rmapbt_helper(
 	if (error)
 		goto out;
 
+	/* Make sure only the AG header owner maps to the AG header. */
+	XFS_SCRUB_BTREC_CHECK(bs, irec.rm_owner == XFS_RMAP_OWN_FS ||
+			!xfs_scrub_extent_covers_ag_head(mp, irec.rm_startblock,
+				irec.rm_blockcount));
+
 	psa = &bs->sc->sa;
 	/* check there's no record in freesp btrees */
 	if (psa->bno_cur) {

