Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEEDC0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjG0WWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjG0WWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:22:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24CF0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE42161EBC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46614C433C8;
        Thu, 27 Jul 2023 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496563;
        bh=t0hmGmkPwk5IJ2TYVvuG0sTEJzmE/A+wDMuIPKH4RWA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h3upYgUyAn+t35vFQzit1pUAgD1T2KlkYSVHrhzxq0CrWAMBprLsodxr2t+bmlRUE
         LjNggFIUbSfAtFPDglsJisGjFVgoXjwTfWBQKtnt11dmhoqiP/0UnlW9HwOmgpUBM5
         +auYrzcTm9haMuFmQcz+QwmkcQX0KBPo/SjD71pfB5PsByNfyNw0Fq6WjymsTSa7GH
         O3r6hukv4yJXLDGURnbh9mZChAUZuMIFpn6ILVpq/9aRQT5qOwbLerUM/F0Hwf1lvZ
         1pregRdtN7WKNTXhEkW/43TgCYvlORsYxuck8izKwFKcpOUQkOrnXEcd1/ymP3dIJF
         wo0a71yRajbTQ==
Date:   Thu, 27 Jul 2023 15:22:42 -0700
Subject: [PATCH 5/9] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622801.921010.8309169117326130251.stgit@frogsfrogsfrogs>
In-Reply-To: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
References: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use deferred frees (EFIs) to reap the blocks of a btree that we just
replaced.  This helps us to shrink the window in which those old blocks
could be lost due to a system crash, though we try to flush the EFIs
every few hundred blocks so that we don't also overflow the transaction
reservations during and after we commit the new btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index bc180171d0cb7..9b0373dde7ab1 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -26,6 +26,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -81,6 +82,9 @@ struct xrep_reap_state {
 	/* Reverse mapping owner and metadata reservation type. */
 	const struct xfs_owner_info	*oinfo;
 	enum xfs_ag_resv_type		resv;
+
+	/* Number of deferred reaps attached to the current transaction. */
+	unsigned int			deferred;
 };
 
 /* Put a block back on the AGFL. */
@@ -165,6 +169,7 @@ xrep_reap_block(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	bool				has_other_rmap;
+	bool				need_roll = true;
 	int				error;
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
@@ -207,13 +212,25 @@ xrep_reap_block(
 		xrep_block_reap_binval(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
 	} else {
+		/*
+		 * Use deferred frees to get rid of the old btree blocks to try
+		 * to minimize the window in which we could crash and lose the
+		 * old blocks.  However, we still need to roll the transaction
+		 * every 100 or so EFIs so that we don't exceed the log
+		 * reservation.
+		 */
 		xrep_block_reap_binval(sc, fsbno);
-		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
-				rs->resv);
+		error = __xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo,
+				rs->resv, true);
+		if (error)
+			return error;
+		rs->deferred++;
+		need_roll = rs->deferred > 100;
 	}
-	if (error)
+	if (error || !need_roll)
 		return error;
 
+	rs->deferred = 0;
 	return xrep_roll_ag_trans(sc);
 }
 
@@ -230,8 +247,13 @@ xrep_reap_extents(
 		.oinfo			= oinfo,
 		.resv			= type,
 	};
+	int				error;
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
 
-	return xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
+	error = xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
+	if (error || rs.deferred == 0)
+		return error;
+
+	return xrep_roll_ag_trans(sc);
 }

