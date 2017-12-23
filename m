Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757130AbdLWAod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0htkE098029
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:32 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2f1ct0r0es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:32 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iWjG014898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:32 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iVkd026923
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:32 GMT
Subject: [PATCH 16/21] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:44:30 -0800
Message-ID: <151398987068.18741.4829286717637372866.stgit@magnolia>
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

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   25 +++++++++++++++++++
 fs/xfs/scrub/alloc.c    |    3 ++
 fs/xfs/scrub/bmap.c     |    2 +
 fs/xfs/scrub/ialloc.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c    |    2 +
 fs/xfs/scrub/refcount.c |    2 +
 fs/xfs/scrub/rmap.c     |    6 ++++
 fs/xfs/scrub/scrub.h    |    6 ++++
 8 files changed, 109 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e87022f..9b78218 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -119,6 +119,8 @@ xfs_scrub_superblock_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -491,6 +493,9 @@ xfs_scrub_agf_xref(
 		break;
 	}
 
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
@@ -595,6 +600,8 @@ xfs_scrub_agfl_block_xref(
 	xfs_agblock_t			bno)
 {
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -649,6 +656,8 @@ xfs_scrub_agfl_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -729,7 +738,11 @@ xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		**pcur;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 	xfs_agblock_t			bno;
+	xfs_agino_t			icount;
+	xfs_agino_t			freecount;
 	int				error;
 
 	bno = XFS_AGI_BLOCK(mp);
@@ -739,6 +752,18 @@ xfs_scrub_agi_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+
+	/* Check agi_count/agi_freecount */
+	pcur = &sc->sa.ino_cur;
+	if (*pcur) {
+		error = xfs_ialloc_count_inodes(*pcur, &icount, &freecount);
+		if (xfs_scrub_should_xref(sc, &error, pcur) &&
+		    (be32_to_cpu(agi->agi_count) != icount ||
+		     be32_to_cpu(agi->agi_freecount) != freecount))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 9a28e3d..cd709f4 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -94,6 +94,9 @@ xfs_scrub_allocbt_xref(
 			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
 		break;
 	}
+
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a74771c..df84c58 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -134,6 +134,8 @@ xfs_scrub_bmap_extent_xref(
 		return;
 
 	xfs_scrub_xref_not_free(info->sc, &sa.bno_cur, agbno, len);
+	xfs_scrub_xref_not_inodes(info->sc, &sa.ino_cur, agbno, len);
+	xfs_scrub_xref_not_inodes(info->sc, &sa.fino_cur, agbno, len);
 
 	xfs_scrub_ag_free(info->sc, &sa);
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4c4ef17c..da07393 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -67,7 +67,29 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
 {
+	struct xfs_btree_cur		**pcur;
+	bool				has_irec;
+	int				error;
+
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
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
+		if (xfs_scrub_should_xref(sc, &error, pcur) &&
+		    ((irec->ir_freecount > 0 && !has_irec) ||
+		     (irec->ir_freecount == 0 && has_irec)))
+			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+	}
 }
 
 /* Is this chunk worth checking? */
@@ -351,3 +373,44 @@ xfs_scrub_finobt(
 {
 	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
 }
+
+static inline void
+__xfs_scrub_xref_check_inodes(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				fs_ok)
+{
+	bool				has_inodes;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	error = xfs_ialloc_has_inodes_at_extent(*pcur, bno, len, &has_inodes);
+	if (xfs_scrub_should_xref(sc, &error, pcur) && has_inodes != fs_ok)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
+
+/* xref check that the extent is not covered by inodes */
+void
+xfs_scrub_xref_not_inodes(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	__xfs_scrub_xref_check_inodes(sc, pcur, bno, len, false);
+}
+
+/* xref check that the extent is covered by inodes */
+void
+xfs_scrub_xref_are_inodes(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	__xfs_scrub_xref_check_inodes(sc, pcur, bno, len, true);
+}
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index a00d179..766d9ac 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -597,6 +597,8 @@ xfs_scrub_inode_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sa.bno_cur, agbno, 1);
+	xfs_scrub_xref_are_inodes(sc, &sc->sa.ino_cur, agbno, 1);
+	xfs_scrub_xref_are_inodes(sc, &sc->sa.fino_cur, agbno, 1);
 
 	xfs_scrub_ag_free(sc, &sa);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 19c303d..8add281 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -59,6 +59,8 @@ xfs_scrub_refcountbt_xref(
 	xfs_nlink_t			refcount)
 {
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
 }
 
 /* Scrub a refcountbt record. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 5c9646b..8d49556 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -61,6 +61,12 @@ xfs_scrub_rmapbt_xref(
 	xfs_extlen_t			len = irec->rm_blockcount;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
+	if (irec->rm_owner == XFS_RMAP_OWN_INODES) {
+		xfs_scrub_xref_are_inodes(sc, &sc->sa.ino_cur, bno, len);
+	} else {
+		xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
+		xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
+	}
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index e75ff0e..768df35 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -127,5 +127,11 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 void xfs_scrub_xref_not_free(struct xfs_scrub_context *sc,
 		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
 		xfs_extlen_t len);
+void xfs_scrub_xref_not_inodes(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
+void xfs_scrub_xref_are_inodes(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

