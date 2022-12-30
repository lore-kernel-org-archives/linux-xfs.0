Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99043C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiL3XUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:20:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1751D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7D061C40
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F221C433EF;
        Fri, 30 Dec 2022 23:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442433;
        bh=6l/F8IYoigQ4kO653q0VnWsRD1DcUFBTo3Ha1wJS9HE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UrTRi6iV0Did1DwfcHUWplX3lwTzONFx3B7KPkRGCJF6DTEkGfDQoE4CM5VgnSid7
         l/xWlR1gm0Mnrg6d2QG2+YVISNBxhnhoY3YSRvzt/tIKRnaV4K6Y8RsND/5evNhz/a
         a1z4qa20cY7T57P/tvznzYRo8DyGW7Ve050glt7GZ8LNi+JDXjCinV9mkFXcvQ8Ni0
         5JKpaMvZKLmerFMXEaGI5yagF5S6sCgEEYWfy1Tt/x6kFkF/FOiHFLANN7lMWg9YLy
         d99eDrQPk3o8mBush43asmDdGR6UOI2/HrreEJbLhaHaViCPlll+5CzuPsNy7gIKhB
         mqnm8PF7WWnVg==
Subject: [PATCH 2/9] xfs: move the post-repair block reaping code to a
 separate file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834711.691918.16570492534833364751.stgit@magnolia>
In-Reply-To: <167243834673.691918.7562784486565988430.stgit@magnolia>
References: <167243834673.691918.7562784486565988430.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reaping blocks after a repair is a complicated affair involving a lot of
rmap btree lookups and figuring out if we're going to unmap or free old
metadata blocks that might be crosslinked.  Eventually, we will need to
be able to reap per-AG metadata blocks, bmbt blocks from inode forks,
garbage CoW staging extents, and (even later) blocks from btrees rooted
in inodes.  This results in a lot of reaping code, so we might as well
split that off while it's easy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/scrub/agheader_repair.c |    1 
 fs/xfs/scrub/reap.c            |  268 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h            |   13 ++
 fs/xfs/scrub/repair.c          |  232 -----------------------------------
 fs/xfs/scrub/repair.h          |    2 
 6 files changed, 283 insertions(+), 234 deletions(-)
 create mode 100644 fs/xfs/scrub/reap.c
 create mode 100644 fs/xfs/scrub/reap.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0b8dfac6d9a3..73bebce4d6f9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -171,6 +171,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   reap.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index c22dc71fdd82..53863560ab0f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -26,6 +26,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
+#include "scrub/reap.h"
 
 /* Superblock */
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
new file mode 100644
index 000000000000..613a8b897a25
--- /dev/null
+++ b/fs/xfs/scrub/reap.c
@@ -0,0 +1,268 @@
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
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_extent_busy.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/reap.h"
+
+/*
+ * Disposal of Blocks from Old Metadata
+ *
+ * Now that we've constructed a new btree to replace the damaged one, we want
+ * to dispose of the blocks that (we think) the old btree was using.
+ * Previously, we used the rmapbt to collect the extents (bitmap) with the
+ * rmap owner corresponding to the tree we rebuilt, collected extents for any
+ * blocks with the same rmap owner that are owned by another data structure
+ * (sublist), and subtracted sublist from bitmap.  In theory the extents
+ * remaining in bitmap are the old btree's blocks.
+ *
+ * Unfortunately, it's possible that the btree was crosslinked with other
+ * blocks on disk.  The rmap data can tell us if there are multiple owners, so
+ * if the rmapbt says there is an owner of this block other than @oinfo, then
+ * the block is crosslinked.  Remove the reverse mapping and continue.
+ *
+ * If there is one rmap record, we can free the block, which removes the
+ * reverse mapping but doesn't add the block to the free space.  Our repair
+ * strategy is to hope the other metadata objects crosslinked on this block
+ * will be rebuilt (atop different blocks), thereby removing all the cross
+ * links.
+ *
+ * If there are no rmap records at all, we also free the block.  If the btree
+ * being rebuilt lives in the free space (bnobt/cntbt/rmapbt) then there isn't
+ * supposed to be a rmap record and everything is ok.  For other btrees there
+ * had to have been an rmap entry for the block to have ended up on @bitmap,
+ * so if it's gone now there's something wrong and the fs will shut down.
+ *
+ * Note: If there are multiple rmap records with only the same rmap owner as
+ * the btree we're trying to rebuild and the block is indeed owned by another
+ * data structure with the same rmap owner, then the block will be in sublist
+ * and therefore doesn't need disposal.  If there are multiple rmap records
+ * with only the same rmap owner but the block is not owned by something with
+ * the same rmap owner, the block will be freed.
+ *
+ * The caller is responsible for locking the AG headers for the entire rebuild
+ * operation so that nothing else can sneak in and change the AG state while
+ * we're not looking.  We also assume that the caller already invalidated any
+ * buffers associated with @bitmap.
+ */
+
+static int
+xrep_invalidate_block(
+	uint64_t		fsbno,
+	void			*priv)
+{
+	struct xfs_scrub	*sc = priv;
+	struct xfs_buf		*bp;
+	int			error;
+
+	/* Skip AG headers and post-EOFS blocks */
+	if (!xfs_verify_fsbno(sc->mp, fsbno))
+		return 0;
+
+	error = xfs_buf_incore(sc->mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(sc->mp, fsbno),
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
+	if (error)
+		return 0;
+
+	xfs_trans_bjoin(sc->tp, bp);
+	xfs_trans_binval(sc->tp, bp);
+	return 0;
+}
+
+/*
+ * Invalidate buffers for per-AG btree blocks we're dumping.  This function
+ * is not intended for use with file data repairs; we have bunmapi for that.
+ */
+int
+xrep_invalidate_blocks(
+	struct xfs_scrub	*sc,
+	struct xbitmap		*bitmap)
+{
+	/*
+	 * For each block in each extent, see if there's an incore buffer for
+	 * exactly that block; if so, invalidate it.  The buffer cache only
+	 * lets us look for one buffer at a time, so we have to look one block
+	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
+	 * because we never own those; and if we can't TRYLOCK the buffer we
+	 * assume it's owned by someone else.
+	 */
+	return xbitmap_walk_bits(bitmap, xrep_invalidate_block, sc);
+}
+
+/* Information about reaping extents after a repair. */
+struct xrep_reap_state {
+	struct xfs_scrub		*sc;
+
+	/* Reverse mapping owner and metadata reservation type. */
+	const struct xfs_owner_info	*oinfo;
+	enum xfs_ag_resv_type		resv;
+};
+
+/*
+ * Put a block back on the AGFL.
+ */
+STATIC int
+xrep_put_freelist(
+	struct xfs_scrub	*sc,
+	xfs_agblock_t		agbno)
+{
+	struct xfs_buf		*agfl_bp;
+	int			error;
+
+	/* Make sure there's space on the freelist. */
+	error = xrep_fix_freelist(sc, true);
+	if (error)
+		return error;
+
+	/*
+	 * Since we're "freeing" a lost block onto the AGFL, we have to
+	 * create an rmap for the block prior to merging it or else other
+	 * parts will break.
+	 */
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno, 1,
+			&XFS_RMAP_OINFO_AG);
+	if (error)
+		return error;
+
+	/* Put the block on the AGFL. */
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_put_freelist(sc->sa.pag, sc->tp, sc->sa.agf_bp,
+			agfl_bp, agbno, 0);
+	if (error)
+		return error;
+	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
+			XFS_EXTENT_BUSY_SKIP_DISCARD);
+
+	return 0;
+}
+
+/* Dispose of a single block. */
+STATIC int
+xrep_reap_block(
+	uint64_t			fsbno,
+	void				*priv)
+{
+	struct xrep_reap_state		*rs = priv;
+	struct xfs_scrub		*sc = rs->sc;
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agblock_t			agbno;
+	bool				has_other_rmap;
+	int				error;
+
+	ASSERT(sc->ip != NULL ||
+	       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
+	trace_xrep_dispose_btree_extent(sc->mp,
+			XFS_FSB_TO_AGNO(sc->mp, fsbno),
+			XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
+
+	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	ASSERT(XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
+
+	/*
+	 * If we are repairing per-inode metadata, we need to read in the AGF
+	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
+	 * the AGF buffer that the setup functions already grabbed.
+	 */
+	if (sc->ip) {
+		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
+		if (error)
+			return error;
+	} else {
+		agf_bp = sc->sa.agf_bp;
+	}
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
+
+	/* Can we find any other rmappings? */
+	error = xfs_rmap_has_other_keys(cur, agbno, 1, rs->oinfo,
+			&has_other_rmap);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_free;
+
+	/*
+	 * If there are other rmappings, this block is cross linked and must
+	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
+	 * we were the only owner of the block, so free the extent, which will
+	 * also remove the rmap.
+	 *
+	 * XXX: XFS doesn't support detecting the case where a single block
+	 * metadata structure is crosslinked with a multi-block structure
+	 * because the buffer cache doesn't detect aliasing problems, so we
+	 * can't fix 100% of crosslinking problems (yet).  The verifiers will
+	 * blow on writeout, the filesystem will shut down, and the admin gets
+	 * to run xfs_repair.
+	 */
+	if (has_other_rmap)
+		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
+					1, rs->oinfo);
+	else if (rs->resv == XFS_AG_RESV_AGFL)
+		error = xrep_put_freelist(sc, agbno);
+	else
+		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
+				rs->resv);
+	if (agf_bp != sc->sa.agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	if (error)
+		return error;
+
+	if (sc->ip)
+		return xfs_trans_roll_inode(&sc->tp, sc->ip);
+	return xrep_roll_ag_trans(sc);
+
+out_free:
+	if (agf_bp != sc->sa.agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/* Dispose of every block of every extent in the bitmap. */
+int
+xrep_reap_extents(
+	struct xfs_scrub		*sc,
+	struct xbitmap			*bitmap,
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type)
+{
+	struct xrep_reap_state		rs = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= type,
+	};
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+
+	return xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
+}
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
new file mode 100644
index 000000000000..73d098ea7b04
--- /dev/null
+++ b/fs/xfs/scrub/reap.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_REAP_H__
+#define __XFS_SCRUB_REAP_H__
+
+int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *bitmap,
+		const struct xfs_owner_info *oinfo,
+		enum xfs_ag_resv_type type);
+
+#endif /* __XFS_SCRUB_REAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c1037536ca45..762eefb6ac90 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -321,91 +321,8 @@ xrep_calc_ag_resblks(
  * sublist.  As with the other btrees we subtract sublist from bitmap, and the
  * result (since the rmapbt lives in the free space) are the blocks from the
  * old rmapbt.
- *
- * Disposal of Blocks from Old per-AG Btrees
- *
- * Now that we've constructed a new btree to replace the damaged one, we want
- * to dispose of the blocks that (we think) the old btree was using.
- * Previously, we used the rmapbt to collect the extents (bitmap) with the
- * rmap owner corresponding to the tree we rebuilt, collected extents for any
- * blocks with the same rmap owner that are owned by another data structure
- * (sublist), and subtracted sublist from bitmap.  In theory the extents
- * remaining in bitmap are the old btree's blocks.
- *
- * Unfortunately, it's possible that the btree was crosslinked with other
- * blocks on disk.  The rmap data can tell us if there are multiple owners, so
- * if the rmapbt says there is an owner of this block other than @oinfo, then
- * the block is crosslinked.  Remove the reverse mapping and continue.
- *
- * If there is one rmap record, we can free the block, which removes the
- * reverse mapping but doesn't add the block to the free space.  Our repair
- * strategy is to hope the other metadata objects crosslinked on this block
- * will be rebuilt (atop different blocks), thereby removing all the cross
- * links.
- *
- * If there are no rmap records at all, we also free the block.  If the btree
- * being rebuilt lives in the free space (bnobt/cntbt/rmapbt) then there isn't
- * supposed to be a rmap record and everything is ok.  For other btrees there
- * had to have been an rmap entry for the block to have ended up on @bitmap,
- * so if it's gone now there's something wrong and the fs will shut down.
- *
- * Note: If there are multiple rmap records with only the same rmap owner as
- * the btree we're trying to rebuild and the block is indeed owned by another
- * data structure with the same rmap owner, then the block will be in sublist
- * and therefore doesn't need disposal.  If there are multiple rmap records
- * with only the same rmap owner but the block is not owned by something with
- * the same rmap owner, the block will be freed.
- *
- * The caller is responsible for locking the AG headers for the entire rebuild
- * operation so that nothing else can sneak in and change the AG state while
- * we're not looking.  We also assume that the caller already invalidated any
- * buffers associated with @bitmap.
  */
 
-static int
-xrep_invalidate_block(
-	uint64_t		fsbno,
-	void			*priv)
-{
-	struct xfs_scrub	*sc = priv;
-	struct xfs_buf		*bp;
-	int			error;
-
-	/* Skip AG headers and post-EOFS blocks */
-	if (!xfs_verify_fsbno(sc->mp, fsbno))
-		return 0;
-
-	error = xfs_buf_incore(sc->mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
-	if (error)
-		return 0;
-
-	xfs_trans_bjoin(sc->tp, bp);
-	xfs_trans_binval(sc->tp, bp);
-	return 0;
-}
-
-/*
- * Invalidate buffers for per-AG btree blocks we're dumping.  This function
- * is not intended for use with file data repairs; we have bunmapi for that.
- */
-int
-xrep_invalidate_blocks(
-	struct xfs_scrub	*sc,
-	struct xbitmap		*bitmap)
-{
-	/*
-	 * For each block in each extent, see if there's an incore buffer for
-	 * exactly that block; if so, invalidate it.  The buffer cache only
-	 * lets us look for one buffer at a time, so we have to look one block
-	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
-	 * because we never own those; and if we can't TRYLOCK the buffer we
-	 * assume it's owned by someone else.
-	 */
-	return xbitmap_walk_bits(bitmap, xrep_invalidate_block, sc);
-}
-
 /* Ensure the freelist is the correct size. */
 int
 xrep_fix_freelist(
@@ -424,155 +341,6 @@ xrep_fix_freelist(
 			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
 }
 
-/* Information about reaping extents after a repair. */
-struct xrep_reap_state {
-	struct xfs_scrub		*sc;
-
-	/* Reverse mapping owner and metadata reservation type. */
-	const struct xfs_owner_info	*oinfo;
-	enum xfs_ag_resv_type		resv;
-};
-
-/*
- * Put a block back on the AGFL.
- */
-STATIC int
-xrep_put_freelist(
-	struct xfs_scrub	*sc,
-	xfs_agblock_t		agbno)
-{
-	struct xfs_buf		*agfl_bp;
-	int			error;
-
-	/* Make sure there's space on the freelist. */
-	error = xrep_fix_freelist(sc, true);
-	if (error)
-		return error;
-
-	/*
-	 * Since we're "freeing" a lost block onto the AGFL, we have to
-	 * create an rmap for the block prior to merging it or else other
-	 * parts will break.
-	 */
-	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno, 1,
-			&XFS_RMAP_OINFO_AG);
-	if (error)
-		return error;
-
-	/* Put the block on the AGFL. */
-	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
-	if (error)
-		return error;
-
-	error = xfs_alloc_put_freelist(sc->sa.pag, sc->tp, sc->sa.agf_bp,
-			agfl_bp, agbno, 0);
-	if (error)
-		return error;
-	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
-			XFS_EXTENT_BUSY_SKIP_DISCARD);
-
-	return 0;
-}
-
-/* Dispose of a single block. */
-STATIC int
-xrep_reap_block(
-	uint64_t			fsbno,
-	void				*priv)
-{
-	struct xrep_reap_state		*rs = priv;
-	struct xfs_scrub		*sc = rs->sc;
-	struct xfs_btree_cur		*cur;
-	struct xfs_buf			*agf_bp = NULL;
-	xfs_agblock_t			agbno;
-	bool				has_other_rmap;
-	int				error;
-
-	ASSERT(sc->ip != NULL ||
-	       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
-	trace_xrep_dispose_btree_extent(sc->mp,
-			XFS_FSB_TO_AGNO(sc->mp, fsbno),
-			XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
-
-	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-	ASSERT(XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
-
-	/*
-	 * If we are repairing per-inode metadata, we need to read in the AGF
-	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
-	 * the AGF buffer that the setup functions already grabbed.
-	 */
-	if (sc->ip) {
-		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
-		if (error)
-			return error;
-	} else {
-		agf_bp = sc->sa.agf_bp;
-	}
-	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
-
-	/* Can we find any other rmappings? */
-	error = xfs_rmap_has_other_keys(cur, agbno, 1, rs->oinfo,
-			&has_other_rmap);
-	xfs_btree_del_cursor(cur, error);
-	if (error)
-		goto out_free;
-
-	/*
-	 * If there are other rmappings, this block is cross linked and must
-	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
-	 * we were the only owner of the block, so free the extent, which will
-	 * also remove the rmap.
-	 *
-	 * XXX: XFS doesn't support detecting the case where a single block
-	 * metadata structure is crosslinked with a multi-block structure
-	 * because the buffer cache doesn't detect aliasing problems, so we
-	 * can't fix 100% of crosslinking problems (yet).  The verifiers will
-	 * blow on writeout, the filesystem will shut down, and the admin gets
-	 * to run xfs_repair.
-	 */
-	if (has_other_rmap)
-		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
-					1, rs->oinfo);
-	else if (rs->resv == XFS_AG_RESV_AGFL)
-		error = xrep_put_freelist(sc, agbno);
-	else
-		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
-				rs->resv);
-	if (agf_bp != sc->sa.agf_bp)
-		xfs_trans_brelse(sc->tp, agf_bp);
-	if (error)
-		return error;
-
-	if (sc->ip)
-		return xfs_trans_roll_inode(&sc->tp, sc->ip);
-	return xrep_roll_ag_trans(sc);
-
-out_free:
-	if (agf_bp != sc->sa.agf_bp)
-		xfs_trans_brelse(sc->tp, agf_bp);
-	return error;
-}
-
-/* Dispose of every block of every extent in the bitmap. */
-int
-xrep_reap_extents(
-	struct xfs_scrub		*sc,
-	struct xbitmap			*bitmap,
-	const struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type		type)
-{
-	struct xrep_reap_state		rs = {
-		.sc			= sc,
-		.oinfo			= oinfo,
-		.resv			= type,
-	};
-
-	ASSERT(xfs_has_rmapbt(sc->mp));
-
-	return xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
-}
-
 /*
  * Finding per-AG Btree Roots for AGF/AGI Reconstruction
  *
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a764838e969d..72ea48802848 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -29,8 +29,6 @@ struct xagb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
 int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xbitmap *btlist);
-int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *exlist,
-		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */

