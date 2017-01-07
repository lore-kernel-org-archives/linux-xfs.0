Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51865 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032643AbdAGAir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:38:47 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070ck96023668
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070ckWd026426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:46 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v070ciQA022380
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:38:45 GMT
Subject: [PATCH 27/47] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:38:43 -0800
Message-ID: <148374952350.30431.1114335313054053583.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Ensure that none of the AG btree records overlap the AG sb/agf/agfl/agi
headers except for the XFS_RMAP_OWN_FS rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/repair/agheader.c |   27 +++++++++++++++++++++++++++
 fs/xfs/repair/alloc.c    |    4 ++++
 fs/xfs/repair/bmap.c     |    5 +++++
 fs/xfs/repair/common.h   |    2 ++
 fs/xfs/repair/ialloc.c   |    4 ++++
 fs/xfs/repair/refcount.c |    4 ++++
 fs/xfs/repair/rmap.c     |    5 +++++
 7 files changed, 51 insertions(+)


diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index b351885..3276e88 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
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
@@ -470,6 +494,9 @@ xfs_scrub_agfl_block(
 	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
 	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
 
+	/* Cross-reference with the AG headers. */
+	XFS_SCRUB_AGFL_CHECK(!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 	/* Cross-reference with the bnobt. */
 	if (sc->sa.bno_cur) {
 		err2 = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index 7cc15b8..c30e048 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -91,6 +91,10 @@ xfs_scrub_allocbt_helper(
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
index 5cb89f7..ffb0112 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -144,6 +144,11 @@ xfs_scrub_bmap_extent(
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
index bff1b2c..3c110b7 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -208,6 +208,8 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			void *priv);
 int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
+bool xfs_scrub_extent_covers_ag_head(struct xfs_mount *mp, xfs_agblock_t agbno,
+				     xfs_extlen_t len);
 
 /* Setup functions */
 
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 3c45fe6..e677167 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -108,6 +108,10 @@ xfs_scrub_iallocbt_chunk(
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
index 0cf82600..bb1d4ee 100644
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
index c04cfb6..5b26166 100644
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

