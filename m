Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CFAC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiJBSjH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiJBSjG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:39:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915863C8D8
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46BB2B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A15C433D6;
        Sun,  2 Oct 2022 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735943;
        bh=aw9Kyb2tdl7Gjj3TY189Ky8iMAqtVUvFIJNVEtWFBsM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZzXYZ0yeR0tkkZng33pWPe+RlxboCvLcC+nv5nWdhDo1lZG7+guoZkrbpnfk0NmCn
         Q1PyNcp4raGfF2fc+f28mi+/0+JXIdJPOmMJs9naPAq6bJO6eq+zk8pSCflO6aqUUD
         egIXrOrszXMTH6jdY09SjokgPzKsvz3QI5jLXbM6xumvjXevqZ9byx7wxFgI3jH9lv
         6QaKfLFZfACGgWwGkPIA8ep5+SZGi3DdKUt0eKE+s39IBlsCl6yUozJf1pYuRTmA3O
         kakKAHWc3Rc1yWarsAB238f/ECcX4+Nc3peQ4aBl+MJF/V62JkCy6CU6nU+hfzONgZ
         Je6/+tkiOsw/g==
Subject: [PATCH 3/4] xfs: cross-reference rmap records with inode btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:47 -0700
Message-ID: <166473484793.1085478.2493682708372844356.stgit@magnolia>
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
OWN_INOBT reverse mappings against the inode btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 20a6905c2f0d..fcda958ce1af 100644
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
 	struct xbitmap		fs_owned;
 	struct xbitmap		log_owned;
 	struct xbitmap		ag_owned;
+	struct xbitmap		inobt_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -247,6 +249,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_AG:
 		bmp = &cr->ag_owned;
 		break;
+	case XFS_RMAP_OWN_INOBT:
+		bmp = &cr->inobt_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -461,6 +466,34 @@ xchk_rmapbt_walk_ag_metadata(
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
+	error = xfs_btree_visit_blocks(cur, xchk_rmapbt_visit_btblock,
+			XFS_BTREE_VISIT_ALL, &cr->inobt_owned);
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
+		error = xfs_btree_visit_blocks(cur, xchk_rmapbt_visit_btblock,
+				XFS_BTREE_VISIT_ALL, &cr->inobt_owned);
+		if (cur != sc->sa.fino_cur)
+			xfs_btree_del_cursor(cur, error);
+		if (error)
+			goto out;
+	}
 
 out:
 	/*
@@ -506,6 +539,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xbitmap_hweight(&cr->ag_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xbitmap_hweight(&cr->inobt_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -523,6 +559,7 @@ xchk_rmapbt(
 	xbitmap_init(&cr->fs_owned);
 	xbitmap_init(&cr->log_owned);
 	xbitmap_init(&cr->ag_owned);
+	xbitmap_init(&cr->inobt_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -536,6 +573,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xbitmap_destroy(&cr->inobt_owned);
 	xbitmap_destroy(&cr->ag_owned);
 	xbitmap_destroy(&cr->log_owned);
 	xbitmap_destroy(&cr->fs_owned);

