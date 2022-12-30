Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB288C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiL3Ww6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Ww5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:52:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E17E1AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1298B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C27C433EF;
        Fri, 30 Dec 2022 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440773;
        bh=C5Cp6ZWJSSXxS9ZdspZQqq94pSse9kvTr/nCc+qMjAc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ucwEqQTMEAalBeXejvuUiVLc06Vl0g/flOOVl0VQC6qknj21c0Z+7JAr99nQN59bN
         UKlwmCXE0A5pWTCbaKTkl6IRhs6iTPRAcLwturAFkMHvVGMEEuhUj8rc7gwEtW4x2O
         k/ZInlATgiqHJLTohZS+cD/bHpNcCW5b8qBG17LQ3LoAPlnKsPxG//dN8mCERb0l+w
         4hq6F9uBq7II3KsYmXztWDCJd774hsJ3CNYdgP26gr99zMVWnGwFZ1d85qMFYAnFCY
         kT1rCgyTghBRiIIYwvXD1tbPGozeAGH8bZjkILiGnHSGP/rtqW1sZZWryZqN1ycFtn
         EQuoDs5OPiJpw==
Subject: [PATCH 4/5] xfs: cross-reference rmap records with inode btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:54 -0800
Message-ID: <167243831432.687445.17952305002209531176.stgit@magnolia>
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
OWN_INOBT reverse mappings against the inode btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index b8e82f5b84f4..f9a05a8c3936 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -18,6 +18,7 @@
 #include "xfs_bit.h"
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -56,6 +57,7 @@ struct xchk_rmap {
 	struct xagb_bitmap	fs_owned;
 	struct xagb_bitmap	log_owned;
 	struct xagb_bitmap	ag_owned;
+	struct xagb_bitmap	inobt_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -299,6 +301,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_AG:
 		bmp = &cr->ag_owned;
 		break;
+	case XFS_RMAP_OWN_INOBT:
+		bmp = &cr->inobt_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -430,6 +435,32 @@ xchk_rmapbt_walk_ag_metadata(
 	error = xfs_agfl_walk(sc->mp, agf, agfl_bp, xchk_rmapbt_walk_agfl,
 			&cr->ag_owned);
 	xfs_trans_brelse(sc->tp, agfl_bp);
+	if (error)
+		goto out;
+
+	/* OWN_INOBT: inobt, finobt */
+	cur = sc->sa.ino_cur;
+	if (!cur)
+		cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.pag, XFS_BTNUM_INO);
+	error = xagb_bitmap_set_btblocks(&cr->inobt_owned, cur);
+	if (cur != sc->sa.ino_cur)
+		xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
+
+	if (xfs_has_finobt(sc->mp)) {
+		cur = sc->sa.fino_cur;
+		if (!cur)
+			cur = xfs_inobt_init_cursor(sc->mp, sc->tp,
+					sc->sa.agi_bp, sc->sa.pag,
+					XFS_BTNUM_FINO);
+		error = xagb_bitmap_set_btblocks(&cr->inobt_owned, cur);
+		if (cur != sc->sa.fino_cur)
+			xfs_btree_del_cursor(cur, error);
+		if (error)
+			goto out;
+	}
 
 out:
 	/*
@@ -475,6 +506,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xagb_bitmap_hweight(&cr->ag_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xagb_bitmap_hweight(&cr->inobt_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -492,6 +526,7 @@ xchk_rmapbt(
 	xagb_bitmap_init(&cr->fs_owned);
 	xagb_bitmap_init(&cr->log_owned);
 	xagb_bitmap_init(&cr->ag_owned);
+	xagb_bitmap_init(&cr->inobt_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -505,6 +540,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xagb_bitmap_destroy(&cr->inobt_owned);
 	xagb_bitmap_destroy(&cr->ag_owned);
 	xagb_bitmap_destroy(&cr->log_owned);
 	xagb_bitmap_destroy(&cr->fs_owned);

