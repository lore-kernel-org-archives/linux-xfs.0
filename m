Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38876 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbcKEAWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:22:05 -0400
Subject: [PATCH 28/41] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:22:02 -0700
Message-ID: <147830532268.2155.17917721244905250968.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
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
 fs/xfs/xfs_scrub.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)


diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 45504d4..2c33f76 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -953,6 +953,30 @@ xfs_scrub_btree_key(
 	return 0;
 }
 
+/* Does this AG extent cover the AG headers? */
+STATIC bool
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
 /* Check a btree pointer. */
 static int
 xfs_scrub_btree_ptr(
@@ -2017,6 +2041,9 @@ xfs_scrub_agfl_block(
 	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
 	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_AGFL_CHECK(!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 	/* Cross-reference with the bnobt. */
 	if (sc->sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
@@ -2195,6 +2222,10 @@ xfs_scrub_allocbt_helper(
 	if (error)
 		goto out;
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/*
 	 * Ensure there's a corresponding cntbt/bnobt record matching
@@ -2285,6 +2316,10 @@ xfs_scrub_iallocbt_chunk(
 		goto out;
 	}
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
@@ -2464,6 +2499,11 @@ xfs_scrub_rmapbt_helper(
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
@@ -2530,6 +2570,10 @@ xfs_scrub_refcountbt_helper(
 	if (error)
 		goto out;
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_SCRUB_BTREC_CHECK(bs, !xfs_scrub_extent_covers_ag_head(mp,
+			irec.rc_startblock, irec.rc_blockcount));
+
 	psa = &bs->sc->sa;
 	/* Cross-reference with the bnobt. */
 	if (psa->bno_cur) {
@@ -2687,6 +2731,11 @@ xfs_scrub_bmap_extent(
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

