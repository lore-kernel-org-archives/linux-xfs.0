Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D6AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiLaB52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbiLaB50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221671C438
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:57:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0A1EB81E0A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5D7C433D2;
        Sat, 31 Dec 2022 01:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451842;
        bh=Xuh+vrOz7S8uZilC3phCTjHHgHHjs5Dtkc8QLFfl9ls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BQxkFfkSuL1UBRsukgvVVGjLI+U06/ghhDSEDfew0g+zXWXW6MkmPhrf7td98JyjL
         /tYkQ6rF/0pKkQ4bi4GRkO/7CoE/vSNeYx/Az4y6PlI3ycdGePddS9S3LZNweW3Azt
         rKYoX0J0Zyxje1DbIH6LWOcmAlK8tDQ+RjcEm1kPYtKnG7J4K9JBsS2R0E8IBc0R8b
         r1jDgeRQRi5v5WW9J5gw0XmqqU5N7hHY4H7sn3sVxR4Tv4Wp1eRyNAsQ6o6DYhVroP
         Ia95wyAIHogW3QNDUXRdCT/3MT6a1Ya3yOf2L09IZf1B2km87zKlHrRGZySx7gJXmt
         vd3wta032unHA==
Subject: [PATCH 36/42] xfs: check new rtbitmap records against rt refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871407.717073.3930845877467547286.stgit@magnolia>
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

When we're rebuilding the realtime bitmap, check the proposed free
extents against the rt refcount btree to make sure we don't commit any
grievous errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c          |    7 +++++++
 fs/xfs/scrub/rtbitmap_repair.c |   21 +++++++++++++++++++++
 2 files changed, 28 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b76c01e9f540..3bde5ea86cf5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -40,6 +40,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -991,6 +992,12 @@ xrep_rtgroup_btcur_init(
 	    xfs_has_rtrmapbt(mp))
 		sr->rmap_cur = xfs_rtrmapbt_init_cursor(mp, sc->tp, sr->rtg,
 				sr->rtg->rtg_rmapip);
+
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_RTREFCBT &&
+	    (sr->rtlock_flags & XFS_RTGLOCK_REFCOUNT) &&
+	    xfs_has_rtreflink(mp))
+		sr->refc_cur = xfs_rtrefcountbt_init_cursor(mp, sc->tp,
+				sr->rtg, sr->rtg->rtg_refcountip);
 }
 
 /*
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 0fa8942d14e7..d099f988274e 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -22,6 +22,7 @@
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -447,6 +448,7 @@ xrep_rgbitmap_mark_free(
 	unsigned int		bufwsize;
 	xfs_extlen_t		mod;
 	xfs_rtword_t		mask;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!xfs_verify_rgbext(rtg, rb->next_rgbno, rgbno - rb->next_rgbno))
@@ -466,6 +468,25 @@ xrep_rgbitmap_mark_free(
 	if (mod != mp->m_sb.sb_rextsize - 1)
 		return -EFSCORRUPTED;
 
+	/* Must not be shared or CoW staging. */
+	if (rb->sc->sr.refc_cur) {
+		error = xfs_refcount_has_records(rb->sc->sr.refc_cur,
+				XFS_REFC_DOMAIN_SHARED, rb->next_rgbno,
+				rgbno - rb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+
+		error = xfs_refcount_has_records(rb->sc->sr.refc_cur,
+				XFS_REFC_DOMAIN_COW, rb->next_rgbno,
+				rgbno - rb->next_rgbno, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+	}
+
 	trace_xrep_rgbitmap_record_free(mp, startrtx, nextrtx - 1);
 
 	/* Set bits as needed to round startrtx up to the nearest word. */

