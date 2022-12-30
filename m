Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9256EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiLaBn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D8613DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92018B81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369DCC433EF;
        Sat, 31 Dec 2022 01:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451033;
        bh=I2JQXZIINBapbLsEDh1XPPBAhPofVyZRlhQkDnLlgDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TdlS3Xd1cetg9GE2KCIt36jnjht30xI1MbJyVJfq521wUuByLgqODKPwNeH1XJHXj
         zpdb8PWx4E85xEMkp2UAWeW3Nw75L/+bbeDMlE4i7s41FSxrja6NIRQADQEP/pQS6K
         DBxIrhJabvxc1iMzH0n2xTewb5GFF40FGM95XYdWz37oshpGU6ZIJ9OyeOkQ2P1+qk
         jxKkwrZjC8cHmoqQwBwWrs/SLRf1wai8c5E7xS0t/RnQqoN92pt4m8F0RWYFt92Vtx
         SPUn1yIjO7gPDCEfNWHVtFV8SgCd9s6+l7jYNsq4sBaCW6mmdGHUAOmcZ7seoEyZ5T
         n21bJRM4HNctw==
Subject: [PATCH 27/38] xfs: scrub the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869986.715303.615702315094213761.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 fs/xfs/scrub/common.h       |   11 ++
 fs/xfs/scrub/health.c       |    1 
 fs/xfs/scrub/inode.c        |   10 +-
 fs/xfs/scrub/inode_repair.c |    7 +-
 fs/xfs/scrub/repair.c       |    1 
 fs/xfs/scrub/rtrmap.c       |  192 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c        |    9 ++
 fs/xfs/scrub/scrub.h        |    5 +
 fs/xfs/scrub/trace.h        |    4 +
 14 files changed, 312 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 84934538bf52..1060ea739210 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -181,6 +181,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper.o \
 				   rtbitmap.o \
+				   rtrmap.o \
 				   rtsummary.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5c557d5ff13e..8547ba85c550 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -744,9 +744,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
+#define XFS_SCRUB_TYPE_RTRMAPBT	30	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b5b081d23ca2..0c79185daedf 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -825,6 +825,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		if (whichfork == XFS_COW_FORK)
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 0ad0f27fd8ca..ca7df344581d 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -682,6 +682,7 @@ xrep_bmap_check_inputs(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_UUID:
+	case XFS_DINODE_FMT_RMAP:
 		return -ECANCELED;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bb1d9ca20374..fa8e0064c41d 100644
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
@@ -837,6 +839,8 @@ xchk_rtgroup_init(
 	struct xchk_rt		*sr,
 	unsigned int		rtglock_flags)
 {
+	int			error;
+
 	ASSERT(sr->rtg == NULL);
 	ASSERT(sr->rtlock_flags == 0);
 
@@ -844,7 +848,30 @@ xchk_rtgroup_init(
 	if (!sr->rtg)
 		return -ENOENT;
 
-	return xchk_rtgroup_lock(sc, sr, rtglock_flags);
+	error = xchk_rtgroup_lock(sc, sr, rtglock_flags);
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
@@ -932,6 +959,14 @@ xchk_setup_fs(
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
@@ -1490,3 +1525,44 @@ xchk_fshooks_enable(
 
 	sc->flags |= scrub_fshooks;
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
index e83e88b44e5b..9ca2fbaac72c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -90,6 +90,7 @@ static inline int xchk_setup_nothing(struct xfs_scrub *sc)
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
+int xchk_setup_rt(struct xfs_scrub *sc);
 int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
@@ -106,11 +107,13 @@ int xchk_setup_rtbitmap(struct xfs_scrub *sc);
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
@@ -170,14 +173,17 @@ void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
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
 
@@ -258,4 +264,7 @@ static inline bool xchk_need_fshook_drain(struct xfs_scrub *sc)
 
 void xchk_fshooks_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
+int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
+		xfs_extnum_t *nextents, xfs_filblks_t *count);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index a71d4d9087b2..061f6f73b666 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -113,6 +113,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RT_SUPER },
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= { XHG_RTGROUP, XFS_SICK_RT_RMAPBT },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 4e534ec642e2..f2c60c3515e7 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -466,6 +466,10 @@ xchk_dinode(
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
@@ -650,15 +654,13 @@ xchk_inode_xref_bmap(
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
index 1efd606bf92c..a8d19d1e76e3 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1275,8 +1275,7 @@ xrep_inode_blockcounts(
 	trace_xrep_inode_blockcounts(sc);
 
 	/* Set data fork counters from the data fork mappings. */
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+	error = xchk_inode_count_blocks(sc, XFS_DATA_FORK, &nextents, &count);
 	if (error)
 		return error;
 	if (xfs_has_reflink(sc->mp)) {
@@ -1296,8 +1295,8 @@ xrep_inode_blockcounts(
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
index 1652f633f692..eb0dda2df7af 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -56,6 +56,7 @@ xrep_attempt(
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
 
 	xchk_ag_btcur_free(&sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 000000000000..e60b454b39f3
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
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
+	    xfs_rmap_check_irec(bs->cur, &irec) != NULL) {
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
index 6066673953cb..c9b4899c8b6a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -182,6 +182,8 @@ xchk_teardown(
 	int			error)
 {
 	xchk_ag_free(sc, &sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
+
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
 			error = xfs_trans_commit(sc->tp);
@@ -423,6 +425,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
index 48114bda2f4a..fa75034b9051 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -78,6 +78,9 @@ struct xchk_rt {
 	 * if rtg != NULL.
 	 */
 	unsigned int		rtlock_flags;
+
+	/* rtgroup btrees */
+	struct xfs_btree_cur	*rmap_cur;
 };
 
 struct xfs_scrub {
@@ -190,11 +193,13 @@ int xchk_rtbitmap(struct xfs_scrub *sc);
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3ffee717062d..844f49091b1d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -77,6 +77,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -108,7 +109,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
-	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }
+	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }, \
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

