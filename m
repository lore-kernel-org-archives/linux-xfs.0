Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389216AbeHAPFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EEC0818BAFD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:54 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF4BC2026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 14/15] xfs: always defer agfl block frees
Date: Wed,  1 Aug 2018 09:19:51 -0400
Message-Id: <20180801131952.60250-15-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-1-bfoster@redhat.com>
References: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The AGFL fixup code conditionally defers block frees from the free
list based on whether the current transaction has an associated
xfs_defer_ops structure. Now that dfops is embedded in the
transaction and the internal dfops is used unconditionally, this
invariant is always true.

Remove the now dead logic to check for ->t_dfops in
xfs_alloc_fix_freelist() and unconditionally defer AGFL block frees.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6bacdc31a439..32a370665d71 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2323,15 +2323,8 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 
-		/* defer agfl frees if dfops is provided */
-		if (tp->t_dfops) {
-			xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
-		} else {
-			error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
-						    &targs.oinfo);
-			if (error)
-				goto out_agbp_relse;
-		}
+		/* defer agfl frees */
+		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
 	}
 
 	targs.tp = tp;
-- 
2.17.1

