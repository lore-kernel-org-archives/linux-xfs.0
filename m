Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbeAIV0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:26:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09LPx8q086875
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fd5fv81jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 21:26:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09LPnK3032578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:25:49 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09LPmf0000840
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:25:48 GMT
Date: Tue, 9 Jan 2018 13:25:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 19/21] xfs: cross-reference refcount btree during scrub
Message-ID: <20180109212547.GN5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988926.18741.14757152372859283463.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398988926.18741.14757152372859283463.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   13 ++++++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |   77 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/ialloc.c   |    1 +
 fs/xfs/scrub/inode.c    |    1 +
 fs/xfs/scrub/refcount.c |   65 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rmap.c     |   38 +++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    4 ++
 8 files changed, 200 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6bc8121..808ef3c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -127,6 +127,7 @@ xfs_scrub_superblock_xref(
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -556,6 +557,15 @@ xfs_scrub_agf_xref(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
 	xfs_scrub_agf_xref_btreeblks(sc);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
+
+	/* Check agf_refcount_blocks against tree size */
+	if (sc->sa.refc_cur) {
+		error = xfs_btree_count_blocks(sc->sa.refc_cur, &blocks);
+		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur) &&
+		    blocks != be32_to_cpu(agf->agf_refcount_blocks))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+	}
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -665,6 +675,7 @@ xfs_scrub_agfl_block_xref(
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -723,6 +734,7 @@ xfs_scrub_agfl_xref(
 	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -835,6 +847,7 @@ xfs_scrub_agi_xref(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index b4defa4..3f5168f 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -106,6 +106,7 @@ xfs_scrub_allocbt_xref(
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
 	xfs_scrub_xref_not_inodes(sc, agbno, len);
 	xfs_scrub_xref_no_rmap(sc, agbno, len);
+	xfs_scrub_xref_not_shared(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index ef7b461..5c34e025 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -202,6 +203,71 @@ xfs_scrub_bmap_xref_rmap(
 				irec->br_startoff);
 }
 
+/* Make sure the refcount records match this data fork extent. */
+STATIC void
+xfs_scrub_bmap_xref_refcount_data(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	if (!info->sc->sa.refc_cur)
+		return;
+
+	/* If this is shared, the inode flag must be set. */
+	error = xfs_refcount_find_shared(info->sc->sa.refc_cur, bno,
+			irec->br_blockcount, &fbno, &flen, false);
+	if (!xfs_scrub_should_check_xref(info->sc, &error,
+			&info->sc->sa.refc_cur))
+		return;
+
+	if (flen != 0 && !xfs_is_reflink_inode(info->sc->ip))
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+}
+
+/* Make sure the refcount records match this attr fork extent. */
+STATIC void
+xfs_scrub_bmap_xref_refcount_attr(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	if (!info->sc->sa.refc_cur)
+		return;
+
+	/* No shared attr fork extents */
+	error = xfs_refcount_find_shared(info->sc->sa.refc_cur, bno,
+			irec->br_blockcount, &fbno, &flen, false);
+	if (!xfs_scrub_should_check_xref(info->sc, &error,
+			&info->sc->sa.refc_cur))
+		return;
+
+	if (flen != 0)
+		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+}
+
+/* Make sure the refcount records match this CoW fork extent. */
+STATIC void
+xfs_scrub_bmap_xref_refcount_cow(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	if (!info->sc->sa.refc_cur)
+		return;
+
+	xfs_scrub_xref_has_cow_staging(info->sc, bno, irec->br_blockcount);
+}
+
 /* Cross-reference a single rtdev extent record. */
 STATIC void
 xfs_scrub_bmap_rt_extent_xref(
@@ -243,6 +309,17 @@ xfs_scrub_bmap_extent_xref(
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
 	xfs_scrub_xref_not_inodes(info->sc, agbno, len);
 	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
+		xfs_scrub_bmap_xref_refcount_data(info, irec, agbno);
+		break;
+	case XFS_ATTR_FORK:
+		xfs_scrub_bmap_xref_refcount_attr(info, irec, agbno);
+		break;
+	case XFS_COW_FORK:
+		xfs_scrub_bmap_xref_refcount_cow(info, irec, agbno);
+		break;
+	}
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 30603b4..fb16314 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -97,6 +97,7 @@ xfs_scrub_iallocbt_chunk_xref(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, agbno, len, &oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, len);
 }
 
 /* Is this chunk worth checking? */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index fc546f2..f12586c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -652,6 +652,7 @@ xfs_scrub_inode_xref(
 	xfs_scrub_inode_xref_finobt(sc, ino);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, agbno, 1);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index df18e47..6e5b12a 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -428,3 +429,67 @@ xfs_scrub_refcountbt(
 
 	return error;
 }
+
+/* xref check that a cow staging extent is marked in the refcountbt. */
+void
+xfs_scrub_xref_has_cow_staging(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	struct xfs_refcount_irec	rc;
+	bool				has_cowflag;
+	int				has_refcount;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	/* Find the CoW staging extent. */
+	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
+			bno + XFS_REFC_COW_START, &has_refcount);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		return;
+	}
+
+	error = xfs_refcount_get_rec(sc->sa.refc_cur, &rc, &has_refcount);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		return;
+	}
+
+	/* CoW flag must be set, refcount must be 1. */
+	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
+	if (!has_cowflag || rc.rc_refcount != 1)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
+	/* Must be at least as long as what was passed in */
+	if (rc.rc_blockcount < len)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
+
+/*
+ * xref check that the extent is not shared.  Only file data blocks
+ * can have multiple owners.
+ */
+void
+xfs_scrub_xref_not_shared(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				shared;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	error = xfs_refcount_has_record(sc->sa.refc_cur, bno, len, &shared);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur) && shared)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8421c6e..e217f98 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -32,6 +32,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -51,6 +52,42 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xfs_scrub_rmapbt_xref_refc(
+	struct xfs_scrub_context	*sc,
+	struct xfs_rmap_irec		*irec)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	bool				non_inode;
+	bool				is_bmbt;
+	bool				is_attr;
+	bool				is_unwritten;
+	int				error;
+
+	if (!sc->sa.refc_cur)
+		return;
+
+	if (irec->rm_owner == XFS_RMAP_OWN_COW) {
+		xfs_scrub_xref_has_cow_staging(sc, irec->rm_startblock,
+				irec->rm_blockcount);
+		return;
+	}
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	/* If this is shared, must be a data fork extent. */
+	error = xfs_refcount_find_shared(sc->sa.refc_cur, irec->rm_startblock,
+			irec->rm_blockcount, &fbno, &flen, false);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.refc_cur) &&
+	    flen != 0 && (non_inode || is_attr || is_bmbt || is_unwritten))
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_rmapbt_xref(
@@ -68,6 +105,7 @@ xfs_scrub_rmapbt_xref(
 		xfs_scrub_xref_are_inodes(sc, agbno, len);
 	else
 		xfs_scrub_xref_not_inodes(sc, agbno, len);
+	xfs_scrub_rmapbt_xref_refc(sc, irec);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 53cc526..06c2d17 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -138,5 +138,9 @@ void xfs_scrub_xref_not_owned_by(struct xfs_scrub_context *sc,
 		struct xfs_owner_info *oinfo);
 void xfs_scrub_xref_no_rmap(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_has_cow_staging(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_not_shared(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
