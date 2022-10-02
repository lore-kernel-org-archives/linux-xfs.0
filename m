Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32641C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJBSi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJBSi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E0D3C8D2
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13E44CE0A51
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F51C433D6;
        Sun,  2 Oct 2022 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735932;
        bh=kVJjOPpmYaJktSr+5OCJvz8MGsagDkFI0ONv2tj3d3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Aglg4MHW+Hea4Ay+XhzVmdBD9T0i2vtWUd6Iv/bGG7JOa80dMXX5QnEA9JAms+Is5
         /lfpOsbiZyWWNal7YluzABi3SaXRs24ZgoalUFedJRczUo7kfxiG8LoYAUMQkZeGpL
         QEiOEtQjxrA5LNosd947mULnCslXY7h825io9hx++t8tmfANOmJn8yAfT/BgBKVJTZ
         lZvZ6kNcBhfx428uGU/tks8TSn4eJRtYBes0luLFrcPBd658BOUB6T5bMj7WvtN9sV
         P45PK9KlnyzahBpLG+5hC2mhlbAseY/gP3C12Za7T2JGEz36XaOSavfMjHTBvlTaMB
         T6onhY+AtTxWA==
Subject: [PATCH 2/4] xfs: cross-reference rmap records with free space btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:47 -0700
Message-ID: <166473484779.1085478.15948861515358988393.stgit@magnolia>
In-Reply-To: <166473484745.1085478.8596810118667983511.stgit@magnolia>
References: <166473484745.1085478.8596810118667983511.stgit@magnolia>
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
 fs/xfs/scrub/rmap.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8205086aac49..20a6905c2f0d 100644
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
 	struct xbitmap		fs_owned;
 	struct xbitmap		log_owned;
+	struct xbitmap		ag_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -239,6 +244,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_LOG:
 		bmp = &cr->log_owned;
 		break;
+	case XFS_RMAP_OWN_AG:
+		bmp = &cr->ag_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -349,9 +357,47 @@ xchk_rmapbt_rec(
 	return error;
 }
 
+/* Add a btree block to the rmap list. */
+STATIC int
+xchk_rmapbt_visit_btblock(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xbitmap		*bitmap = priv;
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
+	return xbitmap_set(bitmap, agbno, 1);
+}
+
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xchk_rmapbt_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		bno,
+	void			*priv)
+{
+	struct xbitmap		*bitmap = priv;
+
+	return xbitmap_set(bitmap, bno, 1);
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
@@ -359,6 +405,9 @@ xchk_rmapbt_walk_ag_metadata(
 	struct xchk_rmap	*cr)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agfl_bp;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_btree_cur	*cur;
 	int			error;
 
 	/* OWN_FS: AG headers */
@@ -376,6 +425,43 @@ xchk_rmapbt_walk_ag_metadata(
 			goto out;
 	}
 
+	/* OWN_AG: bnobt, cntbt, rmapbt, and AGFL */
+	cur = sc->sa.bno_cur;
+	if (!cur)
+		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag, XFS_BTNUM_BNO);
+	error = xfs_btree_visit_blocks(cur, xchk_rmapbt_visit_btblock,
+			XFS_BTREE_VISIT_ALL, &cr->ag_owned);
+	if (cur != sc->sa.bno_cur)
+		xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
+
+	cur = sc->sa.cnt_cur;
+	if (!cur)
+		cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.pag, XFS_BTNUM_CNT);
+	error = xfs_btree_visit_blocks(cur, xchk_rmapbt_visit_btblock,
+			XFS_BTREE_VISIT_ALL, &cr->ag_owned);
+	if (cur != sc->sa.cnt_cur)
+		xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
+
+	error = xfs_btree_visit_blocks(sc->sa.rmap_cur,
+			xchk_rmapbt_visit_btblock, XFS_BTREE_VISIT_ALL,
+			&cr->ag_owned);
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
@@ -417,6 +503,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xbitmap_hweight(&cr->log_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xbitmap_hweight(&cr->ag_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -433,6 +522,7 @@ xchk_rmapbt(
 
 	xbitmap_init(&cr->fs_owned);
 	xbitmap_init(&cr->log_owned);
+	xbitmap_init(&cr->ag_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -446,6 +536,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xbitmap_destroy(&cr->ag_owned);
 	xbitmap_destroy(&cr->log_owned);
 	xbitmap_destroy(&cr->fs_owned);
 	kfree(cr);

