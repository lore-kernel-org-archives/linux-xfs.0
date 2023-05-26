Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E07C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjEZAoU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjEZAoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8590012E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C5B963A6B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8560FC433EF;
        Fri, 26 May 2023 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061857;
        bh=VPYlxp2OwhsreJ/5RuUutByrmdgRfdeIpMRtwnQ7c4I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=nUY7SHKXTjtGUcLEEIMJlGCsgO7Uf5I7zPSXxOIkv90Ew+SlX5I3rxVZuR6iOyY6v
         cPiDNXixLS8II8yJUukiwnC8P0ILtkmz7ljqy+epziI1VxZLY2Wkqqj8Ce0ZLvCShw
         KAwfRTZdLU/WWAlfmkTOSBMkQTp0rInZ8ki/24coqPW+Xao1KyG6msAK934KPLhqfX
         FoNR4pKVOP9MaMo9EyQ051d0AunyVbBs4S3q4YmTKSXd8CMuK9B5V9WD+7MITvTeiv
         U8L5giLRRNFMG8qLsHjKGUef5jzp7LF5hst4pX6uOz8I6+Sq4Z8TnOA7mWrACPtJWL
         bVF+4Y7JrIIXQ==
Date:   Thu, 25 May 2023 17:44:17 -0700
Subject: [PATCH 5/9] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055689.3728180.5922242663769047903.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/reap.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index bc180171d0cb..e9839f3905e7 100644
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
@@ -207,13 +212,22 @@ xrep_reap_block(
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
+		__xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo, true);
+		rs->deferred++;
+		need_roll = rs->deferred > 100;
 	}
-	if (error)
+	if (error || !need_roll)
 		return error;
 
+	rs->deferred = 0;
 	return xrep_roll_ag_trans(sc);
 }
 
@@ -230,8 +244,13 @@ xrep_reap_extents(
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

