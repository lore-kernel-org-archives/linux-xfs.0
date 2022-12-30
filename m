Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C76AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiL3WxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3WxK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:53:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368521AA17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C72CA61AC4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3049DC433D2;
        Fri, 30 Dec 2022 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440789;
        bh=A9dqTjH3W+VitjbINZFKrNRrD8pYqBnwbiPRn825VLA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nzzcanuFw3F7FtwPXqGeHsuVOnSHBXioT/WpLUMRRzAH9S+ypIa6/YxG2MYi8KFlZ
         Fu9dbGbRpr1ETYkiRMDsFaix1O4Z+7/MVJum3/SNFM2r5szhO7GPVY/YV4eX21HFGK
         rlWl77sAI5Pc7zBZY4BTdtMAwv0ahJa1m7QLQTmOKZRoqFO9HffQ3RDG96X2mLeaUF
         mcxVG/Ahi0/INAqpYYLmQtwO51uDcHlk3SRmHPn0xdp6evLk6RK0DmGrv+cvAgNjdb
         I/4YyhRuIyHUUz8AYpw8MQ9CsEGBeoajORBmfCH3iz5i7xEl89dnZgcDvYgDOKSPkY
         Hl0K0ryPaasYg==
Subject: [PATCH 5/5] xfs: cross-reference rmap records with refcount btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:54 -0800
Message-ID: <167243831446.687445.13250082181398590134.stgit@magnolia>
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
OWN_REFCBT reverse mappings against the refcount btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index f9a05a8c3936..8f1fdae71766 100644
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
 	struct xagb_bitmap	log_owned;
 	struct xagb_bitmap	ag_owned;
 	struct xagb_bitmap	inobt_owned;
+	struct xagb_bitmap	refcbt_owned;
 
 	/* Did we complete the AG space metadata bitmaps? */
 	bool			bitmaps_complete;
@@ -304,6 +306,9 @@ xchk_rmapbt_mark_bitmap(
 	case XFS_RMAP_OWN_INOBT:
 		bmp = &cr->inobt_owned;
 		break;
+	case XFS_RMAP_OWN_REFC:
+		bmp = &cr->refcbt_owned;
+		break;
 	}
 
 	if (!bmp)
@@ -462,6 +467,19 @@ xchk_rmapbt_walk_ag_metadata(
 			goto out;
 	}
 
+	/* OWN_REFC: refcountbt */
+	if (xfs_has_reflink(sc->mp)) {
+		cur = sc->sa.refc_cur;
+		if (!cur)
+			cur = xfs_refcountbt_init_cursor(sc->mp, sc->tp,
+					sc->sa.agf_bp, sc->sa.pag);
+		error = xagb_bitmap_set_btblocks(&cr->refcbt_owned, cur);
+		if (cur != sc->sa.refc_cur)
+			xfs_btree_del_cursor(cur, error);
+		if (error)
+			goto out;
+	}
+
 out:
 	/*
 	 * If there's an error, set XFAIL and disable the bitmap
@@ -509,6 +527,9 @@ xchk_rmapbt_check_bitmaps(
 
 	if (xagb_bitmap_hweight(&cr->inobt_owned) != 0)
 		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xagb_bitmap_hweight(&cr->refcbt_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
 }
 
 /* Scrub the rmap btree for some AG. */
@@ -527,6 +548,7 @@ xchk_rmapbt(
 	xagb_bitmap_init(&cr->log_owned);
 	xagb_bitmap_init(&cr->ag_owned);
 	xagb_bitmap_init(&cr->inobt_owned);
+	xagb_bitmap_init(&cr->refcbt_owned);
 
 	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
 	if (error)
@@ -540,6 +562,7 @@ xchk_rmapbt(
 	xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
+	xagb_bitmap_destroy(&cr->refcbt_owned);
 	xagb_bitmap_destroy(&cr->inobt_owned);
 	xagb_bitmap_destroy(&cr->ag_owned);
 	xagb_bitmap_destroy(&cr->log_owned);

