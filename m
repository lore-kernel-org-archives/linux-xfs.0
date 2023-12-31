Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE34BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+XFUVXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228F8C433C7;
	Sun, 31 Dec 2023 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058699;
	bh=v+LeyTURGzLj78qHwJXO8g6UGxreVcP+NO8zZZIza0M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j+XFUVXQLtAm44liuM4guwQZgGgh9rLNpdEKHioE1CSoZ3NWXINDb/2+7ynLqbfIg
	 N3sFlb840Zeon33GIRy20CoQy6/fub6IngZgoQtM/lnHMTJVnCqn0S1NIX8f/puju2
	 7kJPh1jzOrpFg8gqePywQ5LuWXBBxNGuU0VAXTG3/CulIbjtgNHsNDXjezhQwIFBPN
	 de37xTB1IdYOLz6Os05sv3wrvpmoEgozU5f6+stLTcAa24oVh1ma8vs7y+HrPrAps0
	 QJRl6ATtMxrdqsz4QaKXmGKhPw5sDRb96dGK0xva02IDqC+9/CP13X5s5jxudFXuie
	 iRRAqJmoptOHA==
Date: Sun, 31 Dec 2023 13:38:18 -0800
Subject: [PATCH 25/39] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850302.1764998.14932806738322962852.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_fs.h      |    3 -
 fs/xfs/scrub/bmap.c         |    1 
 fs/xfs/scrub/bmap_repair.c  |    1 
 fs/xfs/scrub/common.c       |   78 +++++++++++++++++
 fs/xfs/scrub/common.h       |   10 ++
 fs/xfs/scrub/health.c       |    1 
 fs/xfs/scrub/inode.c        |   10 +-
 fs/xfs/scrub/inode_repair.c |    7 +-
 fs/xfs/scrub/repair.c       |    1 
 fs/xfs/scrub/rtrmap.c       |  193 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c        |    9 ++
 fs/xfs/scrub/scrub.h        |    5 +
 fs/xfs/scrub/stats.c        |    1 
 fs/xfs/scrub/trace.h        |    4 +
 15 files changed, 313 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 50a7929982fdd..69ca5cb7e4000 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -193,6 +193,7 @@ xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper.o \
 				   rtbitmap.o \
+				   rtrmap.o \
 				   rtsummary.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 102b927336057..dcf048aae8c17 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -737,9 +737,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	31	/* realtime group bitmap */
+#define XFS_SCRUB_TYPE_RTRMAPBT	32	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	32
+#define XFS_SCRUB_TYPE_NR	33
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b90f0d8540ba5..8fa51350facc4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -953,6 +953,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		if (whichfork == XFS_COW_FORK)
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 8a6dc7ff2f79e..9dddc5997b4fc 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -728,6 +728,7 @@ xrep_bmap_check_inputs(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_UUID:
+	case XFS_DINODE_FMT_RMAP:
 		return -ECANCELED;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index efce0dff2e937..5ea9f3f310335 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -35,6 +35,8 @@
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_bmap_util.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -866,6 +868,8 @@ xchk_rtgroup_init(
 	struct xchk_rt		*sr,
 	unsigned int		rtglock_flags)
 {
+	int			error;
+
 	ASSERT(sr->rtg == NULL);
 	ASSERT(sr->rtlock_flags == 0);
 
@@ -873,7 +877,30 @@ xchk_rtgroup_init(
 	if (!sr->rtg)
 		return -ENOENT;
 
-	return xchk_rtgroup_drain_and_lock(sc, sr, rtglock_flags);
+	error = xchk_rtgroup_drain_and_lock(sc, sr, rtglock_flags);
+	if (error)
+		return error;
+
+	if (xfs_has_rtrmapbt(sc->mp) && (rtglock_flags & XFS_RTGLOCK_RMAP))
+		sr->rmap_cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp,
+				sr->rtg, sr->rtg->rtg_rmapip);
+
+	return 0;
+}
+
+/*
+ * Free all the btree cursors and other incore data relating to the realtime
+ * group.  This has to be done /before/ committing (or cancelling) the scrub
+ * transaction.
+ */
+void
+xchk_rtgroup_btcur_free(
+	struct xchk_rt		*sr)
+{
+	if (sr->rmap_cur)
+		xfs_btree_del_cursor(sr->rmap_cur, XFS_BTREE_ERROR);
+
+	sr->rmap_cur = NULL;
 }
 
 /*
@@ -961,6 +988,14 @@ xchk_setup_fs(
 	return xchk_trans_alloc(sc, resblks);
 }
 
+/* Set us up with a transaction and an empty context to repair rt metadata. */
+int
+xchk_setup_rt(
+	struct xfs_scrub	*sc)
+{
+	return xchk_trans_alloc(sc, 0);
+}
+
 /* Set us up with AG headers and btree cursors. */
 int
 xchk_setup_ag_btree(
@@ -1696,3 +1731,44 @@ xchk_inode_is_allocated(
 	rcu_read_unlock();
 	return error;
 }
+
+/* Count the blocks used by a file, even if it's a metadata inode. */
+int
+xchk_inode_count_blocks(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	xfs_extnum_t		*nextents,
+	xfs_filblks_t		*count)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+	struct xfs_btree_cur	*cur;
+	xfs_extlen_t		btblocks;
+	int			error;
+
+	if (!ifp) {
+		*nextents = 0;
+		*count = 0;
+		return 0;
+	}
+
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_RMAP:
+		if (!sc->sr.rtg) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+		cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, sc->sr.rtg,
+				sc->ip);
+		error = xfs_btree_count_blocks(cur, &btblocks);
+		xfs_btree_del_cursor(cur, error);
+		if (error)
+			return error;
+
+		*nextents = 0;
+		*count = btblocks - 1;
+		return 0;
+	default:
+		return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork,
+				nextents, count);
+	}
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f96dd658feab9..3251f80c00e15 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -65,6 +65,7 @@ static inline int xchk_setup_nothing(struct xfs_scrub *sc)
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
+int xchk_setup_rt(struct xfs_scrub *sc);
 int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
@@ -83,11 +84,13 @@ int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
 int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
 int xchk_setup_rgbitmap(struct xfs_scrub *sc);
+int xchk_setup_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
 # define xchk_setup_rgsuperblock	xchk_setup_nothing
 # define xchk_setup_rgbitmap		xchk_setup_nothing
+# define xchk_setup_rtrmapbt		xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -148,14 +151,17 @@ void xchk_rt_unlock_rtbitmap(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 
 /* All the locks we need to check an rtgroup. */
-#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP_SHARED)
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_RMAP)
 
 int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
 void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
+void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr, lockflags)	(-ENOSYS)
+# define xchk_rtgroup_btcur_free(sr)			((void)0)
 # define xchk_rtgroup_free(sc, sr)			((void)0)
 #endif /* CONFIG_XFS_RT */
 
@@ -282,5 +288,7 @@ void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
 int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
+int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
+		xfs_extnum_t *nextents, xfs_filblks_t *count);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 7fccb1a03060a..0fec833057697 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -115,6 +115,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
 	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RT_SUPER },
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= { XHG_RTGROUP, XFS_SICK_RT_RMAPBT },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7357bf5156ba3..5fc10e02b9c41 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -496,6 +496,10 @@ xchk_dinode(
 		if (!S_ISREG(mode) && !S_ISDIR(mode))
 			xchk_ino_set_corrupt(sc, ino);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!S_ISREG(mode))
+			xchk_ino_set_corrupt(sc, ino);
+		break;
 	case XFS_DINODE_FMT_UUID:
 	default:
 		xchk_ino_set_corrupt(sc, ino);
@@ -680,15 +684,13 @@ xchk_inode_xref_bmap(
 		return;
 
 	/* Walk all the extents to check nextents/naextents/nblocks. */
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+	error = xchk_inode_count_blocks(sc, XFS_DATA_FORK, &nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
-			&nextents, &acount);
+	error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != xfs_dfork_attr_extents(dip))
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 30be423b3716e..2b3a6cbadae71 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1446,8 +1446,7 @@ xrep_inode_blockcounts(
 	trace_xrep_inode_blockcounts(sc);
 
 	/* Set data fork counters from the data fork mappings. */
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+	error = xchk_inode_count_blocks(sc, XFS_DATA_FORK, &nextents, &count);
 	if (error)
 		return error;
 	if (xfs_is_reflink_inode(sc->ip)) {
@@ -1471,8 +1470,8 @@ xrep_inode_blockcounts(
 	/* Set attr fork counters from the attr fork mappings. */
 	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
 	if (ifp) {
-		error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
-				&nextents, &acount);
+		error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents,
+				&acount);
 		if (error)
 			return error;
 		if (count >= sc->mp->m_sb.sb_dblocks)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 24d99891a634c..cad45d5b86e2e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -61,6 +61,7 @@ xrep_attempt(
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
 
 	xchk_ag_btcur_free(&sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 0000000000000..7c7da0b232321
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtgroup.h"
+#include "xfs_imeta.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata locked. */
+int
+xchk_setup_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg;
+	int			error = 0;
+
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
+	rtg = xfs_rtgroup_get(mp, sc->sm->sm_agno);
+	if (!rtg)
+		return -ENOENT;
+
+	error = xchk_setup_rt(sc);
+	if (error)
+		goto out_rtg;
+
+	error = xchk_install_live_inode(sc, rtg->rtg_rmapip);
+	if (error)
+		goto out_rtg;
+
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		goto out_rtg;
+
+	error = xchk_rtgroup_init(sc, rtg->rtg_rgno, &sc->sr, XCHK_RTGLOCK_ALL);
+out_rtg:
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
+/* Realtime reverse mapping. */
+
+struct xchk_rtrmap {
+	/*
+	 * The furthest-reaching of the rmapbt records that we've already
+	 * processed.  This enables us to detect overlapping records for space
+	 * allocations that cannot be shared.
+	 */
+	struct xfs_rmap_irec	overlap_rec;
+
+	/*
+	 * The previous rmapbt record, so that we can check for two records
+	 * that could be one.
+	 */
+	struct xfs_rmap_irec	prev_rec;
+};
+
+/* Flag failures for records that overlap but cannot. */
+STATIC void
+xchk_rtrmapbt_check_overlapping(
+	struct xchk_btree		*bs,
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	xfs_rtblock_t			pnext, inext;
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	/* No previous record? */
+	if (cr->overlap_rec.rm_blockcount == 0)
+		goto set_prev;
+
+	/* Do overlap_rec and irec overlap? */
+	pnext = cr->overlap_rec.rm_startblock + cr->overlap_rec.rm_blockcount;
+	if (pnext <= irec->rm_startblock)
+		goto set_prev;
+
+	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	/* Save whichever rmap record extends furthest. */
+	inext = irec->rm_startblock + irec->rm_blockcount;
+	if (pnext > inext)
+		return;
+
+set_prev:
+	memcpy(&cr->overlap_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
+/* Decide if two reverse-mapping records can be merged. */
+static inline bool
+xchk_rtrmap_mergeable(
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*r2)
+{
+	const struct xfs_rmap_irec	*r1 = &cr->prev_rec;
+
+	/* Ignore if prev_rec is not yet initialized. */
+	if (cr->prev_rec.rm_blockcount == 0)
+		return false;
+
+	if (r1->rm_owner != r2->rm_owner)
+		return false;
+	if (r1->rm_startblock + r1->rm_blockcount != r2->rm_startblock)
+		return false;
+	if ((unsigned long long)r1->rm_blockcount + r2->rm_blockcount >
+	    XFS_RMAP_LEN_MAX)
+		return false;
+	if (r1->rm_flags != r2->rm_flags)
+		return false;
+	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
+}
+
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_rtrmapbt_check_mergeable(
+	struct xchk_btree		*bs,
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_rtrmap_mergeable(cr, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
+/* Scrub a realtime rmapbt record. */
+STATIC int
+xchk_rtrmapbt_rec(
+	struct xchk_btree		*bs,
+	const union xfs_btree_rec	*rec)
+{
+	struct xchk_rtrmap		*cr = bs->private;
+	struct xfs_rmap_irec		irec;
+
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
+	    xfs_rtrmap_check_irec(bs->cur->bc_ino.rtg, &irec) != NULL) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
+	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	return 0;
+}
+
+/* Scrub the realtime rmap btree. */
+int
+xchk_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_owner_info	oinfo;
+	struct xchk_rtrmap	cr = { };
+	int			error;
+
+	error = xchk_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->sr.rtg->rtg_rmapip->i_ino,
+			XFS_DATA_FORK);
+	return xchk_btree(sc, sc->sr.rmap_cur, xchk_rtrmapbt_rec, &oinfo, &cr);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 58bb52a63782e..428624d4f0c45 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -223,6 +223,8 @@ xchk_teardown(
 	int			error)
 {
 	xchk_ag_free(sc, &sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
+
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
 			error = xfs_trans_commit(sc->tp);
@@ -472,6 +474,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_rtgroups,
 		.repair = xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {	/* realtime group rmapbt */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rtrmapbt,
+		.scrub	= xchk_rtrmapbt,
+		.has	= xfs_has_rtrmapbt,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 76eca41a8995a..52bbc1fbcc560 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -122,6 +122,9 @@ struct xchk_rt {
 	 * if rtg != NULL.
 	 */
 	unsigned int		rtlock_flags;
+
+	/* rtgroup btrees */
+	struct xfs_btree_cur	*rmap_cur;
 };
 
 struct xfs_scrub {
@@ -278,11 +281,13 @@ int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
 int xchk_rgsuperblock(struct xfs_scrub *sc);
 int xchk_rgbitmap(struct xfs_scrub *sc);
+int xchk_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
 # define xchk_rgsuperblock	xchk_nothing
 # define xchk_rgbitmap		xchk_nothing
+# define xchk_rtrmapbt		xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 4bdff9a19dd6c..0da7ecabfe9d9 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -83,6 +83,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 	[XFS_SCRUB_TYPE_RGBITMAP]	= "rgbitmap",
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 822fcdfd89a4b..f02914f129605 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -86,6 +86,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -120,7 +121,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
 	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }, \
 	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
-	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }
+	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }, \
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

