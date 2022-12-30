Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E9BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiL3Wwk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Wwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:52:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2628C1AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B433161C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C63BC433D2;
        Fri, 30 Dec 2022 22:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440758;
        bh=hcFQAFNQtC3AEiC6MKe8jjxFee6UzCsFhUOWArcTdVY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TwtHHBUI56Wl8CZ7jIqHlp+SLMn5gXR9cilAt2BUIWT6dHrOO+R1eHirJSwEZhfEN
         M1T7W+Ahryr+mSZTKzYF4mKCGUOAVNDo2jmYCJbIY98C+P+2vu0CLg2OlyIA2EV+VD
         K/hF0/9BIG8kN1W9R5VutnM7G3hPqWBN7/KzA+kc01xwSXjunETHlpYVN13/xWjxsC
         +V2tXLQH3oB7dLnpODHq4vX9pAHdSX2EAKumxSYnz6rziE4VA7qQmjwqJPT7WIPB8O
         pBeFYPaZ0ezvzHMzJ9x/5SpPcnogwzSDkx2VyKIyjiKEuC748PfsDgyosnGuqj4uCr
         s9gsZh7BkwC/w==
Subject: [PATCH 3/5] xfs: cross-reference rmap records with free space btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:54 -0800
Message-ID: <167243831417.687445.5403451725365535251.stgit@magnolia>
In-Reply-To: <167243831370.687445.933956691451974089.stgit@magnolia>
References: <167243831370.687445.933956691451974089.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Strengthen the rmap btree record checker a little more by comparing
OWN_AG reverse mappings against the free space btrees, the rmap btree,
and the AGFL.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.c |   33 +++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.h |    3 ++
 fs/xfs/scrub/rmap.c   |   66 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 14caff0a28ce..72fdb6cd69b4 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
@@ -262,6 +263,38 @@ xbitmap_disunion(
  * For the 300th record we just exit, with the list being [1, 4, 2, 3].
  */
 
+/* Mark a btree block to the agblock bitmap. */
+STATIC int
+xagb_bitmap_visit_btblock(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xagb_bitmap	*bitmap = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
+	agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+
+	return xagb_bitmap_set(bitmap, agbno, 1);
+}
+
+/* Mark all (per-AG) btree blocks in the agblock bitmap. */
+int
+xagb_bitmap_set_btblocks(
+	struct xagb_bitmap	*bitmap,
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_btree_visit_blocks(cur, xagb_bitmap_visit_btblock,
+			XFS_BTREE_VISIT_ALL, bitmap);
+}
+
 /*
  * Record all the buffers pointed to by the btree cursor.  Callers already
  * engaged in a btree walk should call this function to capture the list of
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 65a6c5a92c7a..ab67073f4f01 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -106,4 +106,7 @@ static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
 	return xbitmap_walk(&bitmap->agbitmap, fn, priv);
 }
 
+int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 415d8e9918da..b8e82f5b84f4 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -7,13 +7,17 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_ag.h"
 #include "xfs_bit.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -51,6 +55,7 @@ struct xchk_rmap {
 	/* Bitmaps containing all blocks for each type of AG metadata. */
 	struct xagb_bitmap	fs_owned;
 	struct xagb_bitmap	log_owned;
+	struct xagb_bitmap	ag_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -291,6 +296,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_LOG:
 		bmp = &cr->log_owned;
 		break;
+	case XFS_RMAP_OWN_AG:
+		bmp = &cr->ag_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -343,9 +351,26 @@ xchk_rmapbt_rec(
 	return xchk_rmapbt_mark_bitmap(bs, cr, &irec);
 }
 
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xchk_rmapbt_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agbno,
+	void			*priv)
+{
+	struct xagb_bitmap	*bitmap = priv;
+
+	return xagb_bitmap_set(bitmap, agbno, 1);
+}
+
 /*
  * Set up bitmaps mapping all the AG metadata to compare with the rmapbt
  * records.
+ *
+ * Grab our own btree cursors here if the scrub setup function didn't give us a
+ * btree cursor due to reports of poor health.  We need to find out if the
+ * rmapbt disagrees with primary metadata btrees to tag the rmapbt as being
+ * XCORRUPT.
  */
 STATIC int
 xchk_rmapbt_walk_ag_metadata(
@@ -353,6 +378,9 @@ xchk_rmapbt_walk_ag_metadata(
 	struct xchk_rmap	*cr)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agfl_bp;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_btree_cur	*cur;
 	int			error;
 
 	/* OWN_FS: AG headers */
@@ -370,6 +398,39 @@ xchk_rmapbt_walk_ag_metadata(
 			goto out;
 	}
 
+	/* OWN_AG: bnobt, cntbt, rmapbt, and AGFL */
+	cur = sc->sa.bno_cur;
+	if (!cur)
+		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag, XFS_BTNUM_BNO);
+	error = xagb_bitmap_set_btblocks(&cr->ag_owned, cur);
+	if (cur != sc->sa.bno_cur)
+		xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
+
+	cur = sc->sa.cnt_cur;
+	if (!cur)
+		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag, XFS_BTNUM_CNT);
+	error = xagb_bitmap_set_btblocks(&cr->ag_owned, cur);
+	if (cur != sc->sa.cnt_cur)
+		xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
+
+	error = xagb_bitmap_set_btblocks(&cr->ag_owned, sc->sa.rmap_cur);
+	if (error)
+		goto out;
+
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
+	if (error)
+		goto out;
+
+	error = xfs_agfl_walk(sc->mp, agf, agfl_bp, xchk_rmapbt_walk_agfl,
+			&cr->ag_owned);
+	xfs_trans_brelse(sc->tp, agfl_bp);
+
 out:
 	/*
 	 * If there's an error, set XFAIL and disable the bitmap
@@ -411,6 +472,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xagb_bitmap_hweight(&cr->log_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xagb_bitmap_hweight(&cr->ag_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -427,6 +491,7 @@ xchk_rmapbt(
 
 	xagb_bitmap_init(&cr->fs_owned);
 	xagb_bitmap_init(&cr->log_owned);
+	xagb_bitmap_init(&cr->ag_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -440,6 +505,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xagb_bitmap_destroy(&cr->ag_owned);
 	xagb_bitmap_destroy(&cr->log_owned);
 	xagb_bitmap_destroy(&cr->fs_owned);
 	kfree(cr);

