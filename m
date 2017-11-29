Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20042 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdK2B02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:26:28 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1QRSu015509
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1QRIL014514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:27 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT1QRg7025907
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:27 GMT
Subject: [PATCH 10/16] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:26:25 -0800
Message-ID: <151191878588.8553.18116514662222900944.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
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
index 37dde37..3204158 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -136,6 +136,8 @@ xfs_scrub_superblock_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -492,6 +494,9 @@ xfs_scrub_agf_xref(
 		break;
 	}
 
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
@@ -596,6 +601,8 @@ xfs_scrub_agfl_block_xref(
 	xfs_agblock_t			bno)
 {
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -650,6 +657,8 @@ xfs_scrub_agfl_xref(
 		return;
 
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, 1);
+	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -730,7 +739,11 @@ xfs_scrub_agi_xref(
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
@@ -740,6 +753,18 @@ xfs_scrub_agi_xref(
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
index 7ce135b..a0274d3 100644
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
index 3e3b34f..687c3fd 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -575,6 +575,8 @@ xfs_scrub_inode_xref(
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
index 0cbb39f6..b1ed843 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -116,5 +116,11 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
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

