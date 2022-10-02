Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE8FC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJBSjQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiJBSjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:39:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793853C8DC
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1534060F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731E5C433D6;
        Sun,  2 Oct 2022 18:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735953;
        bh=KTCGqMJffL34imX1wE8UOn5kjDh9Gd/W0GZLYcuj5NM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JH6BgCTwOUCJaSGdlJ7nGadV5jDkleXrB6t4QDZx3v+yHTFbLF+tSv0pBgG1+npDn
         SERwh9NCDAB71oW7reAnsF+n49Hrn0rf3l0aRXyfJd5/n9RpbqxswORy2W2v/opeL3
         hHkOzlqXsKU/i6Yw1d4buwnOZlYRjX3Yx8kysSJdiy/mRv4JOqy04kQkAFg4AHx14O
         9pQLPkth7RJVJ2eUrrTpnMxt8SlTNuOgSe6nDc8wR49BIP+Xjh5chBrNLVk4jxNVWX
         64Y6OOeWreVbUzLM5wHP1FU6alkyxXhyQkDZpd6pQh2bxCwmKXXcuNm3K6TXeU9SCY
         8K4W//AQ91XpQ==
Subject: [PATCH 4/4] xfs: cross-reference rmap records with refcount btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:48 -0700
Message-ID: <166473484807.1085478.17187451099901012156.stgit@magnolia>
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
OWN_REFCBT reverse mappings against the refcount btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index fcda958ce1af..c63db6595e5d 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -19,6 +19,7 @@
 #include "xfs_alloc.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_refcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -58,6 +59,7 @@ struct xchk_rmap {
 	struct xbitmap		log_owned;
 	struct xbitmap		ag_owned;
 	struct xbitmap		inobt_owned;
+	struct xbitmap		refcbt_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -252,6 +254,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_INOBT:
 		bmp = &cr->inobt_owned;
 		break;
+	case XFS_RMAP_OWN_REFC:
+		bmp = &cr->refcbt_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -495,6 +500,20 @@ xchk_rmapbt_walk_ag_metadata(
 			goto out;
 	}
 
+	/* OWN_REFC: refcountbt */
+	if (xfs_has_reflink(sc->mp)) {
+		cur = sc->sa.refc_cur;
+		if (!cur)
+			cur = xfs_refcountbt_init_cursor(sc->mp, sc->tp,
+					sc->sa.agf_bp, sc->sa.pag);
+		error = xfs_btree_visit_blocks(cur, xchk_rmapbt_visit_btblock,
+				XFS_BTREE_VISIT_ALL, &cr->refcbt_owned);
+		if (cur != sc->sa.refc_cur)
+			xfs_btree_del_cursor(cur, error);
+		if (error)
+			goto out;
+	}
+
 out:
 	/*
 	 * If there's an error, set XFAIL and disable the bitmap
@@ -542,6 +561,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xbitmap_hweight(&cr->inobt_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xbitmap_hweight(&cr->refcbt_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -560,6 +582,7 @@ xchk_rmapbt(
 	xbitmap_init(&cr->log_owned);
 	xbitmap_init(&cr->ag_owned);
 	xbitmap_init(&cr->inobt_owned);
+	xbitmap_init(&cr->refcbt_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -573,6 +596,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xbitmap_destroy(&cr->refcbt_owned);
 	xbitmap_destroy(&cr->inobt_owned);
 	xbitmap_destroy(&cr->ag_owned);
 	xbitmap_destroy(&cr->log_owned);

