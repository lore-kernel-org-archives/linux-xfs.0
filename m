Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25287 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdAUIEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:04:13 -0500
Subject: [PATCH 35/55] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:04:10 -0800
Message-ID: <148498585019.15323.3694054602205136620.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Ensure that none of the AG btree records overlap the AG sb/agf/agfl/agi
headers except for the XFS_RMAP_OWN_FS rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   27 +++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |    4 ++++
 fs/xfs/scrub/bmap.c     |    5 +++++
 fs/xfs/scrub/common.h   |    2 ++
 fs/xfs/scrub/ialloc.c   |    4 ++++
 fs/xfs/scrub/refcount.c |    4 ++++
 fs/xfs/scrub/rmap.c     |    5 +++++
 7 files changed, 51 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index d05a403..e5af267 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -115,6 +115,30 @@ xfs_scrub_walk_agfl(
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
@@ -485,6 +509,9 @@ xfs_scrub_agfl_block(
 	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
 	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_AGFL_XCHECK(!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 	/* Cross-reference with the bnobt. */
 	if (sc->sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 770e82c..af5565e 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -91,6 +91,10 @@ xfs_scrub_allocbt_helper(
 	if (error)
 		goto out;
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_BTREC_XCHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/*
 	 * Ensure there's a corresponding cntbt/bnobt record matching
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0f860ea..ac27852 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -147,6 +147,11 @@ xfs_scrub_bmap_extent(
 		XFS_SCRUB_BMAP_OP_ERROR_XGOTO(out);
 	}
 
+	/* Cross-reference with the AG headers. */
+	if (!info->is_rt)
+		XFS_SCRUB_BMAP_XCHECK(!xfs_scrub_extent_covers_ag_head(mp,
+				bno, irec->br_blockcount));
+
 	/* Cross-reference with the bnobt. */
 	if (sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sa.bno_cur, bno,
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 4704b38..11c04d5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -256,6 +256,8 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
 				  void *),
 			void *priv);
+bool xfs_scrub_extent_covers_ag_head(struct xfs_mount *mp, xfs_agblock_t agbno,
+				     xfs_extlen_t len);
 
 /* Setup functions */
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 69d9e77..e96e500 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -108,6 +108,10 @@ xfs_scrub_iallocbt_chunk(
 		goto out;
 	}
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_BTREC_XCHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index b371a58..76b1e22 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -76,6 +76,10 @@ xfs_scrub_refcountbt_helper(
 	if (error)
 		goto out;
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_BTREC_XCHECK(bs, !xfs_scrub_extent_covers_ag_head(mp,
+			irec.rc_startblock, irec.rc_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index f92ddad..d536704 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -106,6 +106,11 @@ xfs_scrub_rmapbt_helper(
 	if (error)
 		goto out;
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_BTREC_XCHECK(bs, irec.rm_owner == XFS_RMAP_OWN_FS ||
+			!xfs_scrub_extent_covers_ag_head(mp, irec.rm_startblock,
+				irec.rm_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {

