Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBD8C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiL3XVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:21:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF131D0DD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF98261C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AFAC433EF;
        Fri, 30 Dec 2022 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442480;
        bh=fRRJdKVRrf5Cl5xCe9Lh+C3O+5rjyZaSYs7OBt0Ra5M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LkzFCcRHP9xh9Na4zuVENuS8vYY2yLrgE8Us5hoa/5/70iI1Pc/FIkwzwpLGunStz
         7JptjCyQ9p4wEAScSQ5v71e/bl2P7wQSuK6grBKJv9by4c6TylaApiOv0A9FsxXcmD
         t4bSmxayUcfOgt+r5jSKeS1j6CR2p6LkSN8STe+xN8s60LMi/PCVYNkOtaV6HQiuG+
         O8EyIGeJbr/N1/UAzayiDCJw2i8zoUU8xLIcUvLrNmx4Tzj8AgcMJqgFe70q+T3gge
         5kw4UJoME8599FMPgk8EuoS25OqniQESd6EfQ5fux9SH1gjBXVMNBmrd8+9+PAEkDZ
         AIL7n70xJUfiQ==
Subject: [PATCH 5/9] xfs: use deferred frees to reap old btree blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834753.691918.8535327985097574384.stgit@magnolia>
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
index c57388c47dc4..74c150f38a33 100644
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

