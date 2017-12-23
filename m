Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756938AbdLWAow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0ipqK063631
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:51 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd8007-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iokW031713
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:51 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0iomu001676
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:50 GMT
Subject: [PATCH 19/21] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:44:49 -0800
Message-ID: <151398988926.18741.14757152372859283463.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   14 ++++++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |   79 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/ialloc.c   |    1 +
 fs/xfs/scrub/inode.c    |    1 +
 fs/xfs/scrub/refcount.c |   67 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rmap.c     |   40 ++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    6 ++++
 8 files changed, 209 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index c3d244d..e36ea25 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -125,6 +125,7 @@ xfs_scrub_superblock_xref(
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -550,6 +551,16 @@ xfs_scrub_agf_xref(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
 	xfs_scrub_agf_xref_btreeblks(sc);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, 1);
+
+	/* Check agf_refcount_blocks against tree size */
+	pcur = &sc->sa.refc_cur;
+	if (*pcur) {
+		error = xfs_btree_count_blocks(*pcur, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, pcur) &&
+		    blocks != be32_to_cpu(agf->agf_refcount_blocks))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+	}
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -660,6 +671,7 @@ xfs_scrub_agfl_block_xref(
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -719,6 +731,7 @@ xfs_scrub_agfl_xref(
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -830,6 +843,7 @@ xfs_scrub_agi_xref(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index a4046c1..d1dd9b7 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -98,6 +98,7 @@ xfs_scrub_allocbt_xref(
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
 	xfs_scrub_xref_no_rmap(sc, &sc->sa.rmap_cur, bno, len);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f032aa7..79c7767 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_alloc.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -200,6 +201,73 @@ xfs_scrub_bmap_xref_rmap(
 				irec->br_startoff);
 }
 
+/* Make sure the refcount records match this data fork extent. */
+STATIC void
+xfs_scrub_bmap_xref_refcount_data(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_scrub_ag		*sa,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	if (!sa->refc_cur)
+		return;
+
+	/* If this is shared, the inode flag must be set. */
+	error = xfs_refcount_find_shared(sa->refc_cur, bno,
+			irec->br_blockcount, &fbno, &flen, false);
+	if (!xfs_scrub_should_xref(info->sc, &error, &sa->refc_cur))
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
+	struct xfs_scrub_ag		*sa,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	if (!sa->refc_cur)
+		return;
+
+	/* No shared attr fork extents */
+	error = xfs_refcount_find_shared(sa->refc_cur, bno,
+			irec->br_blockcount, &fbno, &flen, false);
+	if (!xfs_scrub_should_xref(info->sc, &error, &sa->refc_cur))
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
+	struct xfs_scrub_ag		*sa,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	if (!sa->refc_cur)
+		return;
+
+	xfs_scrub_xref_has_cow_staging(info->sc, &sa->refc_cur, bno,
+			irec->br_blockcount);
+}
+
 /* Cross-reference a single rtdev extent record. */
 STATIC void
 xfs_scrub_bmap_rt_extent_xref(
@@ -238,6 +306,17 @@ xfs_scrub_bmap_extent_xref(
 	xfs_scrub_xref_not_inodes(info->sc, &sa.ino_cur, agbno, len);
 	xfs_scrub_xref_not_inodes(info->sc, &sa.fino_cur, agbno, len);
 	xfs_scrub_bmap_xref_rmap(info, &sa, irec, agbno);
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
+		xfs_scrub_bmap_xref_refcount_data(info, &sa, irec, agbno);
+		break;
+	case XFS_ATTR_FORK:
+		xfs_scrub_bmap_xref_refcount_attr(info, &sa, irec, agbno);
+		break;
+	case XFS_COW_FORK:
+		xfs_scrub_bmap_xref_refcount_cow(info, &sa, irec, agbno);
+		break;
+	}
 
 	xfs_scrub_ag_free(info->sc, &sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index accec93..8df1695 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -94,6 +94,7 @@ xfs_scrub_iallocbt_chunk_xref(
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, bno, len, &oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, bno, len);
 }
 
 /* Is this chunk worth checking? */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 8fb2aac..b32a01d 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -603,6 +603,7 @@ xfs_scrub_inode_xref(
 	xfs_scrub_xref_are_inodes(sc, &sc->sa.fino_cur, agbno, 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, agbno, 1, &oinfo);
+	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, agbno, 1);
 
 	xfs_scrub_ag_free(sc, &sa);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index b9764f5..afc85b4 100644
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
@@ -429,3 +430,69 @@ xfs_scrub_refcountbt(
 
 	return error;
 }
+
+/* xref check that a cow staging extent is marked in the refcountbt. */
+void
+xfs_scrub_xref_has_cow_staging(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	struct xfs_refcount_irec	rc;
+	bool				has_cowflag;
+	int				has_refcount;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	/* Find the CoW staging extent. */
+	error = xfs_refcount_lookup_le(*pcur, bno + XFS_REFC_COW_START,
+			&has_refcount);
+	if (!xfs_scrub_should_xref(sc, &error, pcur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		return;
+	}
+
+	error = xfs_refcount_get_rec(*pcur, &rc, &has_refcount);
+	if (!xfs_scrub_should_xref(sc, &error, pcur))
+		return;
+	if (!has_refcount) {
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		return;
+	}
+
+	/* CoW flag must be set, refcount must be 1. */
+	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
+	if (!has_cowflag || rc.rc_refcount != 1)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+
+	/* Must be at least as long as what was passed in */
+	if (rc.rc_blockcount < len)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
+
+/*
+ * xref check that the extent is not shared.  Only file data blocks
+ * can have multiple owners.
+ */
+void
+xfs_scrub_xref_not_shared(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				shared;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	error = xfs_refcount_has_record(*pcur, bno, len, &shared);
+	if (xfs_scrub_should_xref(sc, &error, pcur) && shared)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 7970e73..fee31e9 100644
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
@@ -51,6 +52,43 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xfs_scrub_rmapbt_xref_refc(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
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
+	if (!(*pcur))
+		return;
+
+	if (irec->rm_owner == XFS_RMAP_OWN_COW) {
+		xfs_scrub_xref_has_cow_staging(sc, pcur, irec->rm_startblock,
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
+	error = xfs_refcount_find_shared(*pcur, irec->rm_startblock,
+			irec->rm_blockcount, &fbno, &flen, false);
+	if (xfs_scrub_should_xref(sc, &error, pcur) &&
+	    flen != 0 && (non_inode || is_attr || is_bmbt || is_unwritten))
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_rmapbt_xref(
@@ -67,6 +105,8 @@ xfs_scrub_rmapbt_xref(
 		xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
 		xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
 	}
+
+	xfs_scrub_rmapbt_xref_refc(sc, &sc->sa.refc_cur, irec);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 4789dba..83cdcd8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -142,5 +142,11 @@ void xfs_scrub_xref_not_owned_by(struct xfs_scrub_context *sc,
 void xfs_scrub_xref_no_rmap(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
 		xfs_extlen_t len);
+void xfs_scrub_xref_has_cow_staging(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
+void xfs_scrub_xref_not_shared(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

