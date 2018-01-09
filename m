Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbeAIV0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:26:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09LPxHP086886
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fd5fv812x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 21:26:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09LMQgq023520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:22:26 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09LMQEX031858
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:22:26 GMT
Date: Tue, 9 Jan 2018 13:22:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 16/21] xfs: cross-reference inode btrees during scrub
Message-ID: <20180109212218.GK5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987068.18741.4829286717637372866.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398987068.18741.4829286717637372866.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   19 +++++++++++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |    1 +
 fs/xfs/scrub/ialloc.c   |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c    |   49 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/refcount.c |    1 +
 fs/xfs/scrub/rmap.c     |    4 +++
 fs/xfs/scrub/scrub.h    |    4 +++
 8 files changed, 149 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 3b66cd4..4d4ce1f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -122,6 +122,7 @@ xfs_scrub_superblock_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -501,6 +502,8 @@ xfs_scrub_agf_xref(
 	/* Cross-reference with the cntbt. */
 	xfs_scrub_agf_xref_cntbt(sc, agf);
 
+	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
@@ -605,6 +608,7 @@ xfs_scrub_agfl_block_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -659,6 +663,7 @@ xfs_scrub_agfl_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_not_inodes(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -739,7 +744,10 @@ xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 	xfs_agblock_t			agbno;
+	xfs_agino_t			icount;
+	xfs_agino_t			freecount;
 	int				error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -752,6 +760,17 @@ xfs_scrub_agi_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_xref_not_inodes(sc, agbno, 1);
+
+	/* Check agi_count/agi_freecount */
+	if (sc->sa.ino_cur) {
+		error = xfs_ialloc_count_inodes(sc->sa.ino_cur, &icount,
+				&freecount);
+		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
+		    (be32_to_cpu(agi->agi_count) != icount ||
+		     be32_to_cpu(agi->agi_freecount) != freecount))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 4101560..2a58558 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -104,6 +104,7 @@ xfs_scrub_allocbt_xref(
 		return;
 
 	xfs_scrub_allocbt_xref_other(sc, agbno, len);
+	xfs_scrub_xref_not_inodes(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7e8e239..d2b4747 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -138,6 +138,7 @@ xfs_scrub_bmap_extent_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
+	xfs_scrub_xref_not_inodes(info->sc, agbno, len);
 
 	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4526894..34c133e 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -67,10 +67,32 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
+	struct xfs_btree_cur		**pcur;
+	bool				has_irec;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+
+	/*
+	 * If we're checking the finobt, cross-reference with the inobt.
+	 * Otherwise we're checking the inobt; if there is an finobt,
+	 * make sure we have a record or not depending on freecount.
+	 */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT)
+		pcur = &sc->sa.ino_cur;
+	else
+		pcur = &sc->sa.fino_cur;
+	if (*pcur) {
+		error = xfs_ialloc_has_inode_record(*pcur,
+				agino, agino, &has_irec);
+		if (xfs_scrub_should_check_xref(sc, &error, pcur) &&
+		    ((irec->ir_freecount > 0 && !has_irec) ||
+		     (irec->ir_freecount == 0 && has_irec)))
+			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+	}
 }
 
 /* Is this chunk worth checking? */
@@ -352,3 +374,51 @@ xfs_scrub_finobt(
 {
 	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
 }
+
+/* xref check that the extent is not covered by inodes */
+void
+xfs_scrub_xref_not_inodes(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				has_inodes;
+	int				error;
+
+	if (sc->sa.ino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
+		    has_inodes)
+			xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.ino_cur, 0);
+	}
+
+	if (sc->sa.fino_cur) {
+		error = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) &&
+		    has_inodes)
+			xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur,
+					0);
+	}
+}
+
+/* xref check that the extent is covered by inodes */
+void
+xfs_scrub_xref_are_inodes(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				has_inodes;
+	int				error;
+
+	if (!sc->sa.ino_cur)
+		return;
+
+	error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur, bno,
+			len, &has_inodes);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
+	    !has_inodes)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.ino_cur, 0);
+}
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index be9cf19..b48d5fb 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -39,6 +39,7 @@
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/btree.h"
 #include "scrub/trace.h"
 
 /*
@@ -577,6 +578,53 @@ xfs_scrub_inode_map_raw(
 	return error;
 }
 
+/*
+ * Make sure the finobt doesn't think this inode is free.
+ * We don't have to check the inobt ourselves because we got the inode via
+ * IGET_UNTRUSTED, which checks the inobt for us.
+ */
+static void
+xfs_scrub_inode_xref_finobt(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino)
+{
+	struct xfs_inobt_rec_incore	rec;
+	xfs_agino_t			agino;
+	int				has_record;
+	int				error;
+
+	if (!sc->sa.fino_cur)
+		return;
+
+	agino = XFS_INO_TO_AGINO(sc->mp, ino);
+
+	/*
+	 * Try to get the finobt record.  If we can't get it, then we're
+	 * in good shape.
+	 */
+	error = xfs_inobt_lookup(sc->sa.fino_cur, agino, XFS_LOOKUP_LE,
+			&has_record);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	    !has_record)
+		return;
+
+	error = xfs_inobt_get_rec(sc->sa.fino_cur, &rec, &has_record);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) ||
+	    !has_record)
+		return;
+
+	/*
+	 * Otherwise, make sure this record either doesn't cover this inode,
+	 * or that it does but it's marked present.
+	 */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		return;
+
+	if (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino))
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur, 0);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_inode_xref(
@@ -599,6 +647,7 @@ xfs_scrub_inode_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+	xfs_scrub_inode_xref_finobt(sc, ino);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 09a04ae..700f8f1 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -62,6 +62,7 @@ xfs_scrub_refcountbt_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	xfs_scrub_xref_not_inodes(sc, agbno, len);
 }
 
 /* Scrub a refcountbt record. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 54b0eac..02704b0 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -64,6 +64,10 @@ xfs_scrub_rmapbt_xref(
 		return;
 
 	xfs_scrub_xref_is_used_space(sc, agbno, len);
+	if (irec->rm_owner == XFS_RMAP_OWN_INODES)
+		xfs_scrub_xref_are_inodes(sc, agbno, len);
+	else
+		xfs_scrub_xref_not_inodes(sc, agbno, len);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 006e396..340273f 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -126,5 +126,9 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 /* cross-referencing helpers */
 void xfs_scrub_xref_is_used_space(struct xfs_scrub_context *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_not_inodes(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
+void xfs_scrub_xref_are_inodes(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
