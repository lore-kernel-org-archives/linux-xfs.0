Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAB3C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AFB861090
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhD0DDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhD0DDP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Apr 2021 23:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49E061164;
        Tue, 27 Apr 2021 03:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619492552;
        bh=RDvSyYC46hHGSvBEhw0b9F3vk1ciCUE0G/iVT+m8J1c=;
        h=Date:From:To:Cc:Subject:From;
        b=DyqFWPzUpjmoh4HA7AMM+i3NGbnCsKnr+IcCGbfJ176xOZkPrfvapX4aB6DQcxwQp
         TFgS/e8+zp0JIc9f8jLMVgrPjWdL5thOZhKwhy9DZ15W3wUxfVrqzF8rBPOm+xa7C5
         Fvh0SpIg3JbvD0+yrmk4SI0R9Oi9O+6BhaKPguRv7OwI2AhRmnvQuh8/JHqhyYS5D9
         /IzCvTHZ9cMoTAvD5LuphBLT9RnR2qZB0W5G4c4WrBV2ARU4VPoCYZC2PyipfR5Aio
         E+vPMrU2KSWp/sP8tnlHJeVIKUBM8UAgrSF/c0h0yJcRWLiijkixgASzQlJoUp0YTW
         kIZwr5xCUykvg==
Date:   Mon, 26 Apr 2021 20:02:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: count free space btree blocks when scrubbing
 pre-lazysbcount fses
Message-ID: <20210427030232.GE3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since agf_btreeblks didn't exist before the lazysbcount feature, the fs
summary count scrubber needs to walk the free space btrees to determine
the amount of space being used by those btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
Note: I /think/ the four patches on the list right now fix all the
obvious problems with !lazysbcount filesystems, except for xfs/49[12]
which fuzz the summary counters.
---
 fs/xfs/scrub/fscounters.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 318b81c0f90d..87476a00de9d 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -13,6 +13,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
+#include "xfs_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -143,6 +144,35 @@ xchk_setup_fscounters(
 	return xchk_trans_alloc(sc, 0);
 }
 
+/* Count free space btree blocks manually for pre-lazysbcount filesystems. */
+static int
+xchk_fscount_btreeblks(
+	struct xfs_scrub	*sc,
+	struct xchk_fscounters	*fsc,
+	xfs_agnumber_t		agno)
+{
+	xfs_extlen_t		blocks;
+	int			error;
+
+	error = xchk_ag_init(sc, agno, &sc->sa);
+	if (error)
+		return error;
+
+	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
+	if (error)
+		goto out_free;
+	fsc->fdblocks += blocks - 1;
+
+	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
+	if (error)
+		goto out_free;
+	fsc->fdblocks += blocks - 1;
+
+out_free:
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
 /*
  * Calculate what the global in-core counters ought to be from the incore
  * per-AG structure.  Callers can compare this to the actual in-core counters
@@ -184,6 +214,13 @@ xchk_fscount_aggregate_agcounts(
 		fsc->fdblocks += pag->pagf_flcount;
 		if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb))
 			fsc->fdblocks += pag->pagf_btreeblks;
+		else {
+			error = xchk_fscount_btreeblks(sc, fsc, agno);
+			if (error) {
+				xfs_perag_put(pag);
+				break;
+			}
+		}
 
 		/*
 		 * Per-AG reservations are taken out of the incore counters,
