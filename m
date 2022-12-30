Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DD2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiLaBzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiLaBzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:55:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F751DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEE5BB81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29C5C433D2;
        Sat, 31 Dec 2022 01:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451733;
        bh=xVdRo37W1K9A07RrNOkmsHTdmOZqhJ9RRl47ndgk8e4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d8+640svzhLooir49NVODfYFRxDG7P6JJ8BTviT2tSlOTOu2uxo1xrjJDOFygIiIT
         OAK9RgbsLf9VPlbbH13Ex8XGYioNnuNPua/DYFnOW9pVZaOt0rhuCnUReo5qlfXO4n
         IeMieomKUBVeG4QF7SR3A0RceE78VpYVLsvWOawp4MYkBjQlnGqQb0NzTrRQxLVVOx
         k17+0PFl64xE7QtAK1YBquPNUf40+ffcJQxRIlUB7jniTqaEGRWyAnPTKF19LUSU11
         WWwPd4UrH4I4Cgw7N/ory/5FKxb759r04jzwTIMP1c7GTqdNHsMcJgvvrCMrGmx2Eq
         Z9io6NSaAcDqA==
Subject: [PATCH 29/42] xfs: scrub the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871308.717073.691655306599152783.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add code to scrub realtime refcount btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_fs.h     |    3 
 fs/xfs/scrub/bmap.c        |    1 
 fs/xfs/scrub/bmap_repair.c |    1 
 fs/xfs/scrub/common.c      |   40 +++-
 fs/xfs/scrub/common.h      |    5 
 fs/xfs/scrub/health.c      |    1 
 fs/xfs/scrub/inode.c       |    1 
 fs/xfs/scrub/rtrefcount.c  |  495 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    7 +
 fs/xfs/scrub/scrub.h       |    3 
 fs/xfs/scrub/trace.h       |    4 
 12 files changed, 548 insertions(+), 14 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrefcount.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9cc30333c089..cb1074c67dc5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -182,6 +182,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper.o \
 				   rtbitmap.o \
+				   rtrefcount.o \
 				   rtrmap.o \
 				   rtsummary.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5819576a51a1..453b08612256 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -746,9 +746,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
 #define XFS_SCRUB_TYPE_RTRMAPBT	30	/* rtgroup reverse mapping btree */
+#define XFS_SCRUB_TYPE_RTREFCBT	31	/* realtime reference count btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 8ce279ae9c95..f18b22bc2548 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -909,6 +909,7 @@ xchk_bmap(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		/* No mappings to check. */
 		if (whichfork == XFS_COW_FORK)
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index b8cdcba984f3..5dca4680657f 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -807,6 +807,7 @@ xrep_bmap_check_inputs(
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		return -ECANCELED;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c2c379aae770..a632d56f255f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -37,6 +37,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_bmap_util.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -856,6 +857,10 @@ xchk_rtgroup_init(
 		sr->rmap_cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp,
 				sr->rtg, sr->rtg->rtg_rmapip);
 
+	if (xfs_has_rtreflink(sc->mp) && (rtglock_flags & XFS_RTGLOCK_REFCOUNT))
+		sr->refc_cur = xfs_rtrefcountbt_init_cursor(sc->mp, sc->tp,
+				sr->rtg, sr->rtg->rtg_refcountip);
+
 	return 0;
 }
 
@@ -870,7 +875,10 @@ xchk_rtgroup_btcur_free(
 {
 	if (sr->rmap_cur)
 		xfs_btree_del_cursor(sr->rmap_cur, XFS_BTREE_ERROR);
+	if (sr->refc_cur)
+		xfs_btree_del_cursor(sr->refc_cur, XFS_BTREE_ERROR);
 
+	sr->refc_cur = NULL;
 	sr->rmap_cur = NULL;
 }
 
@@ -1556,16 +1564,26 @@ xchk_inode_count_blocks(
 		}
 		cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, sc->sr.rtg,
 				sc->ip);
-		error = xfs_btree_count_blocks(cur, &btblocks);
-		xfs_btree_del_cursor(cur, error);
-		if (error)
-			return error;
-
-		*nextents = 0;
-		*count = btblocks - 1;
-		return 0;
-	default:
-		return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork,
-				nextents, count);
+		goto meta_btree;
+	case XFS_DINODE_FMT_REFCOUNT:
+		if (!sc->sr.rtg) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+		cur = xfs_rtrefcountbt_init_cursor(sc->mp, sc->tp, sc->sr.rtg,
+				sc->ip);
+		goto meta_btree;
 	}
+
+	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
+			count);
+meta_btree:
+	error = xfs_btree_count_blocks(cur, &btblocks);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	*nextents = 0;
+	*count = btblocks - 1;
+	return 0;
 }
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e135f792cfcc..dd1b838a183f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -108,12 +108,14 @@ int xchk_setup_rtsummary(struct xfs_scrub *sc);
 int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
 int xchk_setup_rgbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtrmapbt(struct xfs_scrub *sc);
+int xchk_setup_rtrefcountbt(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
 # define xchk_setup_rgsuperblock	xchk_setup_nothing
 # define xchk_setup_rgbitmap		xchk_setup_nothing
 # define xchk_setup_rtrmapbt		xchk_setup_nothing
+# define xchk_setup_rtrefcountbt	xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -174,7 +176,8 @@ void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 
 /* All the locks we need to check an rtgroup. */
 #define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP_SHARED | \
-				 XFS_RTGLOCK_RMAP)
+				 XFS_RTGLOCK_RMAP | \
+				 XFS_RTGLOCK_REFCOUNT)
 
 int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 061f6f73b666..cb3b0b221275 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -114,6 +114,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RT_SUPER },
 	[XFS_SCRUB_TYPE_RTRMAPBT]	= { XHG_RTGROUP, XFS_SICK_RT_RMAPBT },
+	[XFS_SCRUB_TYPE_RTREFCBT]	= { XHG_RTGROUP, XFS_SICK_RT_REFCNTBT },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3b19976b6066..be9739035226 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -468,6 +468,7 @@ xchk_dinode(
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if (!S_ISREG(mode))
 			xchk_ino_set_corrupt(sc, ino);
 		break;
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
new file mode 100644
index 000000000000..528a056c7932
--- /dev/null
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -0,0 +1,495 @@
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
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_refcount.h"
+#include "xfs_inode.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+
+/* Set us up with the realtime refcount metadata locked. */
+int
+xchk_setup_rtrefcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
+	rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
+	if (!rtg)
+		return -ENOENT;
+
+	error = xchk_setup_rt(sc);
+	if (error)
+		goto out_rtg;
+
+	error = xchk_install_live_inode(sc, rtg->rtg_refcountip);
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
+/* Realtime Reference count btree scrubber. */
+
+/*
+ * Confirming Reference Counts via Reverse Mappings
+ *
+ * We want to count the reverse mappings overlapping a refcount record
+ * (bno, len, refcount), allowing for the possibility that some of the
+ * overlap may come from smaller adjoining reverse mappings, while some
+ * comes from single extents which overlap the range entirely.  The
+ * outer loop is as follows:
+ *
+ * 1. For all reverse mappings overlapping the refcount extent,
+ *    a. If a given rmap completely overlaps, mark it as seen.
+ *    b. Otherwise, record the fragment (in agbno order) for later
+ *       processing.
+ *
+ * Once we've seen all the rmaps, we know that for all blocks in the
+ * refcount record we want to find $refcount owners and we've already
+ * visited $seen extents that overlap all the blocks.  Therefore, we
+ * need to find ($refcount - $seen) owners for every block in the
+ * extent; call that quantity $target_nr.  Proceed as follows:
+ *
+ * 2. Pull the first $target_nr fragments from the list; all of them
+ *    should start at or before the start of the extent.
+ *    Call this subset of fragments the working set.
+ * 3. Until there are no more unprocessed fragments,
+ *    a. Find the shortest fragments in the set and remove them.
+ *    b. Note the block number of the end of these fragments.
+ *    c. Pull the same number of fragments from the list.  All of these
+ *       fragments should start at the block number recorded in the
+ *       previous step.
+ *    d. Put those fragments in the set.
+ * 4. Check that there are $target_nr fragments remaining in the list,
+ *    and that they all end at or beyond the end of the refcount extent.
+ *
+ * If the refcount is correct, all the check conditions in the algorithm
+ * should always hold true.  If not, the refcount is incorrect.
+ */
+struct xchk_rtrefcnt_frag {
+	struct list_head	list;
+	struct xfs_rmap_irec	rm;
+};
+
+struct xchk_rtrefcnt_check {
+	struct xfs_scrub	*sc;
+	struct list_head	fragments;
+
+	/* refcount extent we're examining */
+	xfs_rgblock_t		bno;
+	xfs_extlen_t		len;
+	xfs_nlink_t		refcount;
+
+	/* number of owners seen */
+	xfs_nlink_t		seen;
+};
+
+/*
+ * Decide if the given rmap is large enough that we can redeem it
+ * towards refcount verification now, or if it's a fragment, in
+ * which case we'll hang onto it in the hopes that we'll later
+ * discover that we've collected exactly the correct number of
+ * fragments as the rtrefcountbt says we should have.
+ */
+STATIC int
+xchk_rtrefcountbt_rmap_check(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xchk_rtrefcnt_check	*refchk = priv;
+	struct xchk_rtrefcnt_frag	*frag;
+	xfs_rgblock_t			rm_last;
+	xfs_rgblock_t			rc_last;
+	int				error = 0;
+
+	if (xchk_should_terminate(refchk->sc, &error))
+		return error;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount - 1;
+	rc_last = refchk->bno + refchk->len - 1;
+
+	/* Confirm that a single-owner refc extent is a CoW stage. */
+	if (refchk->refcount == 1 && rec->rm_owner != XFS_RMAP_OWN_COW) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
+	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
+		/*
+		 * The rmap overlaps the refcount record, so we can confirm
+		 * one refcount owner seen.
+		 */
+		refchk->seen++;
+	} else {
+		/*
+		 * This rmap covers only part of the refcount record, so
+		 * save the fragment for later processing.  If the rmapbt
+		 * is healthy each rmap_irec we see will be in agbno order
+		 * so we don't need insertion sort here.
+		 */
+		frag = kmalloc(sizeof(struct xchk_rtrefcnt_frag),
+				XCHK_GFP_FLAGS);
+		if (!frag)
+			return -ENOMEM;
+		memcpy(&frag->rm, rec, sizeof(frag->rm));
+		list_add_tail(&frag->list, &refchk->fragments);
+	}
+
+	return 0;
+}
+
+/*
+ * Given a bunch of rmap fragments, iterate through them, keeping
+ * a running tally of the refcount.  If this ever deviates from
+ * what we expect (which is the rtrefcountbt's refcount minus the
+ * number of extents that totally covered the rtrefcountbt extent),
+ * we have a rtrefcountbt error.
+ */
+STATIC void
+xchk_rtrefcountbt_process_rmap_fragments(
+	struct xchk_rtrefcnt_check	*refchk)
+{
+	struct list_head		worklist;
+	struct xchk_rtrefcnt_frag	*frag;
+	struct xchk_rtrefcnt_frag	*n;
+	xfs_rgblock_t			bno;
+	xfs_rgblock_t			rbno;
+	xfs_rgblock_t			next_rbno;
+	xfs_nlink_t			nr;
+	xfs_nlink_t			target_nr;
+
+	target_nr = refchk->refcount - refchk->seen;
+	if (target_nr == 0)
+		return;
+
+	/*
+	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
+	 * references we haven't found yet.  Pull that many off the
+	 * fragment list and figure out where the smallest rmap ends
+	 * (and therefore the next rmap should start).  All the rmaps
+	 * we pull off should start at or before the beginning of the
+	 * refcount record's range.
+	 */
+	INIT_LIST_HEAD(&worklist);
+	rbno = NULLRGBLOCK;
+
+	/* Make sure the fragments actually /are/ in bno order. */
+	bno = 0;
+	list_for_each_entry(frag, &refchk->fragments, list) {
+		if (frag->rm.rm_startblock < bno)
+			goto done;
+		bno = frag->rm.rm_startblock;
+	}
+
+	/*
+	 * Find all the rmaps that start at or before the refc extent,
+	 * and put them on the worklist.
+	 */
+	nr = 0;
+	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
+			break;
+		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+		if (bno < rbno)
+			rbno = bno;
+		list_move_tail(&frag->list, &worklist);
+		nr++;
+	}
+
+	/*
+	 * We should have found exactly $target_nr rmap fragments starting
+	 * at or before the refcount extent.
+	 */
+	if (nr != target_nr)
+		goto done;
+
+	while (!list_empty(&refchk->fragments)) {
+		/* Discard any fragments ending at rbno from the worklist. */
+		nr = 0;
+		next_rbno = NULLRGBLOCK;
+		list_for_each_entry_safe(frag, n, &worklist, list) {
+			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+			if (bno != rbno) {
+				if (bno < next_rbno)
+					next_rbno = bno;
+				continue;
+			}
+			list_del(&frag->list);
+			kfree(frag);
+			nr++;
+		}
+
+		/* Try to add nr rmaps starting at rbno to the worklist. */
+		list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+			if (frag->rm.rm_startblock != rbno)
+				goto done;
+			list_move_tail(&frag->list, &worklist);
+			if (next_rbno > bno)
+				next_rbno = bno;
+			nr--;
+			if (nr == 0)
+				break;
+		}
+
+		/*
+		 * If we get here and nr > 0, this means that we added fewer
+		 * items to the worklist than we discarded because the fragment
+		 * list ran out of items.  Therefore, we cannot maintain the
+		 * required refcount.  Something is wrong, so we're done.
+		 */
+		if (nr)
+			goto done;
+
+		rbno = next_rbno;
+	}
+
+	/*
+	 * Make sure the last extent we processed ends at or beyond
+	 * the end of the refcount extent.
+	 */
+	if (rbno < refchk->bno + refchk->len)
+		goto done;
+
+	/* Actually record us having seen the remaining refcount. */
+	refchk->seen = refchk->refcount;
+done:
+	/* Delete fragments and work list. */
+	list_for_each_entry_safe(frag, n, &worklist, list) {
+		list_del(&frag->list);
+		kfree(frag);
+	}
+	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+		list_del(&frag->list);
+		kfree(frag);
+	}
+}
+
+/* Use the rmap entries covering this extent to verify the refcount. */
+STATIC void
+xchk_rtrefcountbt_xref_rmap(
+	struct xfs_scrub		*sc,
+	const struct xfs_refcount_irec	*irec)
+{
+	struct xchk_rtrefcnt_check	refchk = {
+		.sc			= sc,
+		.bno			= irec->rc_startblock,
+		.len			= irec->rc_blockcount,
+		.refcount		= irec->rc_refcount,
+		.seen			= 0,
+	};
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xchk_rtrefcnt_frag	*frag;
+	struct xchk_rtrefcnt_frag	*n;
+	int				error;
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	/* Cross-reference with the rmapbt to confirm the refcount. */
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = irec->rc_startblock;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = irec->rc_startblock + irec->rc_blockcount - 1;
+
+	INIT_LIST_HEAD(&refchk.fragments);
+	error = xfs_rmap_query_range(sc->sr.rmap_cur, &low, &high,
+			xchk_rtrefcountbt_rmap_check, &refchk);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
+		goto out_free;
+
+	xchk_rtrefcountbt_process_rmap_fragments(&refchk);
+	if (irec->rc_refcount != refchk.seen)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+
+out_free:
+	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
+		list_del(&frag->list);
+		kfree(frag);
+	}
+}
+
+/* Cross-reference with the other btrees. */
+STATIC void
+xchk_rtrefcountbt_xref(
+	struct xfs_scrub		*sc,
+	const struct xfs_refcount_irec	*irec)
+{
+	xfs_rtblock_t			rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
+			irec->rc_startblock);
+	xchk_xref_is_used_rt_space(sc, rtbno, irec->rc_blockcount);
+	xchk_rtrefcountbt_xref_rmap(sc, irec);
+}
+
+struct xchk_rtrefcbt_records {
+	/* Previous refcount record. */
+	struct xfs_refcount_irec	prev_rec;
+
+	/* Number of CoW blocks we expect. */
+	xfs_extlen_t			cow_blocks;
+};
+
+static inline bool
+xchk_rtrefcount_mergeable(
+	struct xchk_rtrefcbt_records	*rrc,
+	const struct xfs_refcount_irec	*r2)
+{
+	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
+
+	/* Ignore if prev_rec is not yet initialized. */
+	if (r1->rc_blockcount > 0)
+		return false;
+
+	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
+		return false;
+	if (r1->rc_refcount != r2->rc_refcount)
+		return false;
+	if ((unsigned long long)r1->rc_blockcount + r2->rc_blockcount >
+			XFS_REFC_LEN_MAX)
+		return false;
+
+	return true;
+}
+
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_rtrefcountbt_check_mergeable(
+	struct xchk_btree		*bs,
+	struct xchk_rtrefcbt_records	*rrc,
+	const struct xfs_refcount_irec	*irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_rtrefcount_mergeable(rrc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&rrc->prev_rec, irec, sizeof(struct xfs_refcount_irec));
+}
+
+/* Scrub a rtrefcountbt record. */
+STATIC int
+xchk_rtrefcountbt_rec(
+	struct xchk_btree		*bs,
+	const union xfs_btree_rec	*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xchk_rtrefcbt_records	*rrc = bs->private;
+	struct xfs_refcount_irec	irec;
+	u32				mod;
+
+	xfs_refcount_btrec_to_irec(rec, &irec);
+	if (xfs_refcount_check_irec(bs->cur, &irec) != NULL) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
+
+	/* We can only share full rt extents. */
+	xfs_rtb_to_rtx(mp, irec.rc_startblock, &mod);
+	if (mod)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	xfs_rtb_to_rtx(mp, irec.rc_blockcount, &mod);
+	if (mod)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (irec.rc_domain == XFS_REFC_DOMAIN_COW)
+		rrc->cow_blocks += irec.rc_blockcount;
+
+	xchk_rtrefcountbt_check_mergeable(bs, rrc, &irec);
+	xchk_rtrefcountbt_xref(bs->sc, &irec);
+
+	return 0;
+}
+
+/* Make sure we have as many refc blocks as the rmap says. */
+STATIC void
+xchk_refcount_xref_rmap(
+	struct xfs_scrub	*sc,
+	const struct xfs_owner_info *btree_oinfo,
+	xfs_extlen_t		cow_blocks)
+{
+	xfs_extlen_t		refcbt_blocks = 0;
+	xfs_filblks_t		blocks;
+	int			error;
+
+	if (!sc->sr.rmap_cur || !sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	/* Check that we saw as many refcbt blocks as the rmap knows about. */
+	error = xfs_btree_count_blocks(sc->sr.refc_cur, &refcbt_blocks);
+	if (!xchk_btree_process_error(sc, sc->sr.refc_cur, 0, &error))
+		return;
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, btree_oinfo,
+			&blocks);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (blocks != refcbt_blocks)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+
+	/* Check that we saw as many cow blocks as the rmap knows about. */
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sr.rmap_cur,
+			&XFS_RMAP_OINFO_COW, &blocks);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur))
+		return;
+	if (blocks != cow_blocks)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+}
+
+/* Scrub the refcount btree for some AG. */
+int
+xchk_rtrefcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_owner_info	btree_oinfo;
+	struct xchk_rtrefcbt_records rrc = {
+		.cow_blocks	= 0,
+	};
+	int			error;
+
+	error = xchk_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
+	xfs_rmap_ino_bmbt_owner(&btree_oinfo, sc->sr.rtg->rtg_refcountip->i_ino,
+			XFS_DATA_FORK);
+	error = xchk_btree(sc, sc->sr.refc_cur, xchk_rtrefcountbt_rec,
+			&btree_oinfo, &rrc);
+	if (error)
+		goto out_unlock;
+
+	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
+
+out_unlock:
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ab7a36efab3b..ad6f297ae6cf 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -432,6 +432,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_rtrmapbt,
 		.repair	= xrep_rtrmapbt,
 	},
+	[XFS_SCRUB_TYPE_RTREFCBT] = {	/* realtime refcountbt */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rtrefcountbt,
+		.scrub	= xchk_rtrefcountbt,
+		.has	= xfs_has_rtreflink,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index d47db84e6b7f..3a9dd26eca7d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -81,6 +81,7 @@ struct xchk_rt {
 
 	/* rtgroup btrees */
 	struct xfs_btree_cur	*rmap_cur;
+	struct xfs_btree_cur	*refc_cur;
 };
 
 struct xfs_scrub {
@@ -194,12 +195,14 @@ int xchk_rtsummary(struct xfs_scrub *sc);
 int xchk_rgsuperblock(struct xfs_scrub *sc);
 int xchk_rgbitmap(struct xfs_scrub *sc);
 int xchk_rtrmapbt(struct xfs_scrub *sc);
+int xchk_rtrefcountbt(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
 # define xchk_rgsuperblock	xchk_nothing
 # define xchk_rgbitmap		xchk_nothing
 # define xchk_rtrmapbt		xchk_nothing
+# define xchk_rtrefcountbt	xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8d66ab10e1fd..8070d946ae1d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -79,6 +79,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTREFCBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -111,7 +112,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
 	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }, \
-	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }, \
+	{ XFS_SCRUB_TYPE_RTREFCBT,	"rtrefcountbt" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

