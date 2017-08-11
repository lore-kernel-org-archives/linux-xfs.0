Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50543 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdHKHLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:11 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7BA3H031802
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BAXh008980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:10 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BASi020605
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:10 GMT
Subject: [PATCH 09/16] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:08 -0700
Message-ID: <150243546879.29473.4387407358618035308.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ensure that none of the AG btree records overlap the AG sb/agf/agfl/agi
headers except for the XFS_RMAP_OWN_FS rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |    4 ++++
 fs/xfs/scrub/bmap.c     |    7 +++++++
 fs/xfs/scrub/common.h   |    2 ++
 fs/xfs/scrub/ialloc.c   |    4 ++++
 fs/xfs/scrub/refcount.c |    5 +++++
 fs/xfs/scrub/rmap.c     |    6 ++++++
 7 files changed, 56 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 7e7ad5f..275271e 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -116,6 +116,30 @@ xfs_scrub_walk_agfl(
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
 
 /* Scrub the filesystem superblock. */
@@ -595,6 +619,10 @@ xfs_scrub_agfl_block(
 			agbno < sagfl->eoag &&
 			XFS_AGB_TO_DADDR(mp, agno, agbno) < sagfl->eofs);
 
+	/* Cross-reference with the AG headers. */
+	xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+			!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 	/* Cross-reference with the bnobt. */
 	if (sc->sa.bno_cur) {
 		error = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index eec27ce..0a4f4ea 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -81,6 +81,10 @@ xfs_scrub_allocbt_helper(
 			rec_end <= mp->m_sb.sb_agblocks &&
 			rec_end <= be32_to_cpu(agf->agf_length));
 
+	/* Cross-reference with the AG headers. */
+	xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/*
 	 * Ensure there's a corresponding cntbt/bnobt record matching
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0a427329..9ad08ff 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -183,6 +183,13 @@ xfs_scrub_bmap_extent(
 			goto out;
 	}
 
+	/* Cross-reference with the AG headers. */
+	if (!info->is_rt)
+		xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+				irec->br_startoff,
+				!xfs_scrub_extent_covers_ag_head(mp,
+					bno, irec->br_blockcount));
+
 	/* Cross-reference with the bnobt. */
 	if (sa.bno_cur) {
 		error = xfs_alloc_has_record(sa.bno_cur, bno,
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index c463c9b..8ef5bc4 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -158,6 +158,8 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
 				  void *),
 			void *priv);
+bool xfs_scrub_extent_covers_ag_head(struct xfs_mount *mp, xfs_agblock_t agbno,
+				     xfs_extlen_t len);
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index b1cb647..e9d7764 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -85,6 +85,10 @@ xfs_scrub_iallocbt_chunk(
 			rec_end <= mp->m_sb.sb_agblocks && rec_end <= eoag))
 		return false;
 
+	/* Cross-reference with the AG headers. */
+	xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index e0c5a24..12cfd9f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -86,6 +86,11 @@ xfs_scrub_refcountbt_helper(
 			rec_end <= eoag &&
 			irec.rc_refcount >= 1);
 
+	/* Cross-reference with the AG headers. */
+	xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+			!xfs_scrub_extent_covers_ag_head(mp,
+				irec.rc_startblock, irec.rc_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index ecb948a..2fd4aa7 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -117,6 +117,12 @@ xfs_scrub_rmapbt_helper(
 			(irec.rm_owner > XFS_RMAP_OWN_MIN &&
 			 irec.rm_owner <= XFS_RMAP_OWN_FS));
 
+	/* Cross-reference with the AG headers. */
+	xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0,
+			irec.rm_owner == XFS_RMAP_OWN_FS ||
+			!xfs_scrub_extent_covers_ag_head(mp, irec.rm_startblock,
+				irec.rm_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {

