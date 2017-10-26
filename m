Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:65339 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932255AbdJZIdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:41 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003Cp-Lv
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005MX-Kf
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: move various type verifiers to common file
Date: Thu, 26 Oct 2017 19:33:16 +1100
Message-Id: <20171026083322.20428-9-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
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
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_alloc.c  |  49 -------------
 fs/xfs/libxfs/xfs_alloc.h  |   4 --
 fs/xfs/libxfs/xfs_ialloc.c |  89 ------------------------
 fs/xfs/libxfs/xfs_ialloc.h |   7 --
 fs/xfs/libxfs/xfs_types.c  | 169 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h  |  23 ++++++
 fs/xfs/scrub/agheader.c    |   2 +-
 fs/xfs/xfs_rtalloc.h       |   2 -
 9 files changed, 194 insertions(+), 152 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_types.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0182fb816f6e..33d404d4a013 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -60,6 +60,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
+				   xfs_types.o \
 				   )
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b13b0db21fa1..8eb5dd1d7588 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2950,55 +2950,6 @@ xfs_alloc_query_all(
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
index 65a0cafe06e4..a31424d4a5eb 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -239,10 +239,6 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
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
index e64ae27f28b3..132b8c7af263 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2669,95 +2669,6 @@ xfs_ialloc_pagi_init(
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
 
 /* Is there an inode record covering a given range of inode numbers? */
 int
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 0085620591da..42b8c34a3878 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -182,12 +182,5 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
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
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
new file mode 100644
index 000000000000..16d2488797a1
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -0,0 +1,169 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 0220159bd463..a17070ef51b8 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -136,5 +136,28 @@ typedef uint32_t	xfs_dqid_t;
 #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
 #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
 
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
+
+#ifdef CONFIG_XFS_RT
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+#else
+#define xfs_verify_rtbno(m, r)			(false)
+#endif
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 608b44c4ced8..0f638ba311db 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -1349,7 +1349,7 @@ xfs_scrub_agi(
 	}
 
 	/* Check inode counters */
-	xfs_ialloc_agino_range(mp, agno, &first_agino, &last_agino);
+	xfs_agino_range(mp, agno, &first_agino, &last_agino);
 	icount = be32_to_cpu(agi->agi_count);
 	if (icount > last_agino - first_agino + 1 ||
 	    icount < be32_to_cpu(agi->agi_freecount))
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 540d506675cf..4aa70448d904 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -138,7 +138,6 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       xfs_rtblock_t start, xfs_rtblock_t len,
 			       bool *is_free);
@@ -150,7 +149,6 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
 # define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
-- 
2.15.0.rc0

