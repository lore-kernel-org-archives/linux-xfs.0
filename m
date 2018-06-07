Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11803 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752602AbeFGF15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:27:57 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQnSj-0004tN-QO
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:27:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQnSj-0001qH-PV
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:27:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: move various type verifiers to common file
Date: Thu,  7 Jun 2018 15:27:49 +1000
Message-Id: <20180607052751.6541-2-david@fromorbit.com>
In-Reply-To: <20180607052751.6541-1-david@fromorbit.com>
References: <20180607052751.6541-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

New verification functions like xfs_verify_fsbno() and
xfs_verify_agino() are spread across multiple files and different
header files. They really don't fit cleanly into the places they've
been put, and have wider scope than the current header includes.

Move the type verifiers to a new file in libxfs (xfs-types.c) and
the prototypes to xfs_types.h where they will be visible to all the
code that uses the types.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile              |   1 +
 fs/xfs/libxfs/xfs_alloc.c    |  49 ----------
 fs/xfs/libxfs/xfs_alloc.h    |   4 -
 fs/xfs/libxfs/xfs_ialloc.c   |  90 ------------------
 fs/xfs/libxfs/xfs_ialloc.h   |   7 --
 fs/xfs/libxfs/xfs_rtbitmap.c |  12 ---
 fs/xfs/libxfs/xfs_types.c    | 173 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h    |  19 ++++
 fs/xfs/scrub/agheader.c      |   2 +-
 9 files changed, 194 insertions(+), 163 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_types.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 19a1f8064d8a..5333f7cbc95a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -50,6 +50,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
+				   xfs_types.o \
 				   )
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1db50cfc0212..eef466260d43 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3123,55 +3123,6 @@ xfs_alloc_query_all(
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
 }
 
-/* Find the size of the AG, in blocks. */
-xfs_agblock_t
-xfs_ag_block_count(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	ASSERT(agno < mp->m_sb.sb_agcount);
-
-	if (agno < mp->m_sb.sb_agcount - 1)
-		return mp->m_sb.sb_agblocks;
-	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
-}
-
-/*
- * Verify that an AG block number pointer neither points outside the AG
- * nor points at static metadata.
- */
-bool
-xfs_verify_agbno(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		agbno)
-{
-	xfs_agblock_t		eoag;
-
-	eoag = xfs_ag_block_count(mp, agno);
-	if (agbno >= eoag)
-		return false;
-	if (agbno <= XFS_AGFL_BLOCK(mp))
-		return false;
-	return true;
-}
-
-/*
- * Verify that an FS block number pointer neither points outside the
- * filesystem nor points at static AG metadata.
- */
-bool
-xfs_verify_fsbno(
-	struct xfs_mount	*mp,
-	xfs_fsblock_t		fsbno)
-{
-	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
-
-	if (agno >= mp->m_sb.sb_agcount)
-		return false;
-	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
-}
-
 /* Is there a record covering a given extent? */
 int
 xfs_alloc_has_record(
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 1651d924aaf1..e716c993ac4c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -242,10 +242,6 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		xfs_alloc_query_range_fn fn, void *priv);
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
-xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agblock_t agbno);
-bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 
 int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exist);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 3f551eb29157..8ec39dad62d7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2674,96 +2674,6 @@ xfs_ialloc_pagi_init(
 	return 0;
 }
 
-/* Calculate the first and last possible inode number in an AG. */
-void
-xfs_ialloc_agino_range(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		*first,
-	xfs_agino_t		*last)
-{
-	xfs_agblock_t		bno;
-	xfs_agblock_t		eoag;
-
-	eoag = xfs_ag_block_count(mp, agno);
-
-	/*
-	 * Calculate the first inode, which will be in the first
-	 * cluster-aligned block after the AGFL.
-	 */
-	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
-			xfs_ialloc_cluster_alignment(mp));
-	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);
-
-	/*
-	 * Calculate the last inode, which will be at the end of the
-	 * last (aligned) cluster that can be allocated in the AG.
-	 */
-	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
-	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;
-}
-
-/*
- * Verify that an AG inode number pointer neither points outside the AG
- * nor points at static metadata.
- */
-bool
-xfs_verify_agino(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino)
-{
-	xfs_agino_t		first;
-	xfs_agino_t		last;
-
-	xfs_ialloc_agino_range(mp, agno, &first, &last);
-	return agino >= first && agino <= last;
-}
-
-/*
- * Verify that an FS inode number pointer neither points outside the
- * filesystem nor points at static AG metadata.
- */
-bool
-xfs_verify_ino(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
-
-	if (agno >= mp->m_sb.sb_agcount)
-		return false;
-	if (XFS_AGINO_TO_INO(mp, agno, agino) != ino)
-		return false;
-	return xfs_verify_agino(mp, agno, agino);
-}
-
-/* Is this an internal inode number? */
-bool
-xfs_internal_inum(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 xfs_is_quota_inode(&mp->m_sb, ino));
-}
-
-/*
- * Verify that a directory entry's inode number doesn't point at an internal
- * inode, empty space, or static AG metadata.
- */
-bool
-xfs_verify_dir_ino(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	if (xfs_internal_inum(mp, ino))
-		return false;
-	return xfs_verify_ino(mp, ino);
-}
-
 /* Is there an inode record covering a given range of inode numbers? */
 int
 xfs_ialloc_has_inode_record(
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 144f3eac9b93..90b09c5f163b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -169,12 +169,5 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 		int *stat);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
-void xfs_ialloc_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agino_t *first, xfs_agino_t *last);
-bool xfs_verify_agino(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agino_t agino);
-bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
-bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
-bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ffc72075a44e..65fc4ed2e9a1 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1080,18 +1080,6 @@ xfs_rtalloc_query_all(
 	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
 }
 
-/*
- * Verify that an realtime block number pointer doesn't point off the
- * end of the realtime device.
- */
-bool
-xfs_verify_rtbno(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	return rtbno < mp->m_sb.sb_rblocks;
-}
-
 /* Is the given extent all free? */
 int
 xfs_rtalloc_extent_is_free(
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
new file mode 100644
index 000000000000..2e2a243cef2e
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2017 Oracle.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+
+/* Find the size of the AG, in blocks. */
+xfs_agblock_t
+xfs_ag_block_count(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	if (agno < mp->m_sb.sb_agcount - 1)
+		return mp->m_sb.sb_agblocks;
+	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
+}
+
+/*
+ * Verify that an AG block number pointer neither points outside the AG
+ * nor points at static metadata.
+ */
+bool
+xfs_verify_agbno(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno)
+{
+	xfs_agblock_t		eoag;
+
+	eoag = xfs_ag_block_count(mp, agno);
+	if (agbno >= eoag)
+		return false;
+	if (agbno <= XFS_AGFL_BLOCK(mp))
+		return false;
+	return true;
+}
+
+/*
+ * Verify that an FS block number pointer neither points outside the
+ * filesystem nor points at static AG metadata.
+ */
+bool
+xfs_verify_fsbno(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno)
+{
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return false;
+	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
+}
+
+/* Calculate the first and last possible inode number in an AG. */
+void
+xfs_agino_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		*first,
+	xfs_agino_t		*last)
+{
+	xfs_agblock_t		bno;
+	xfs_agblock_t		eoag;
+
+	eoag = xfs_ag_block_count(mp, agno);
+
+	/*
+	 * Calculate the first inode, which will be in the first
+	 * cluster-aligned block after the AGFL.
+	 */
+	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
+			xfs_ialloc_cluster_alignment(mp));
+	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);
+
+	/*
+	 * Calculate the last inode, which will be at the end of the
+	 * last (aligned) cluster that can be allocated in the AG.
+	 */
+	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
+	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;
+}
+
+/*
+ * Verify that an AG inode number pointer neither points outside the AG
+ * nor points at static metadata.
+ */
+bool
+xfs_verify_agino(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino)
+{
+	xfs_agino_t		first;
+	xfs_agino_t		last;
+
+	xfs_agino_range(mp, agno, &first, &last);
+	return agino >= first && agino <= last;
+}
+
+/*
+ * Verify that an FS inode number pointer neither points outside the
+ * filesystem nor points at static AG metadata.
+ */
+bool
+xfs_verify_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return false;
+	if (XFS_AGINO_TO_INO(mp, agno, agino) != ino)
+		return false;
+	return xfs_verify_agino(mp, agno, agino);
+}
+
+/* Is this an internal inode number? */
+bool
+xfs_internal_inum(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
+		(xfs_sb_version_hasquota(&mp->m_sb) &&
+		 xfs_is_quota_inode(&mp->m_sb, ino));
+}
+
+/*
+ * Verify that a directory entry's inode number doesn't point at an internal
+ * inode, empty space, or static AG metadata.
+ */
+bool
+xfs_verify_dir_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (xfs_internal_inum(mp, ino))
+		return false;
+	return xfs_verify_ino(mp, ino);
+}
+
+/*
+ * Verify that an realtime block number pointer doesn't point off the
+ * end of the realtime device.
+ */
+bool
+xfs_verify_rtbno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rtbno < mp->m_sb.sb_rblocks;
+}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b72ae343140e..4055d62f690c 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -147,4 +147,23 @@ typedef struct xfs_bmbt_irec
 	xfs_exntst_t	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
+/*
+ * Type verifier functions
+ */
+struct xfs_mount;
+
+xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
+bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno);
+bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
+
+void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agino_t *first, xfs_agino_t *last);
+bool xfs_verify_agino(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agino_t agino);
+bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fb9637ff4bde..9bb0745f1ad2 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -867,7 +867,7 @@ xfs_scrub_agi(
 	}
 
 	/* Check inode counters */
-	xfs_ialloc_agino_range(mp, agno, &first_agino, &last_agino);
+	xfs_agino_range(mp, agno, &first_agino, &last_agino);
 	icount = be32_to_cpu(agi->agi_count);
 	if (icount > last_agino - first_agino + 1 ||
 	    icount < be32_to_cpu(agi->agi_freecount))
-- 
2.17.0

