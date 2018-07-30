Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732162AbeG3SVM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 14:21:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B4A54023444
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8043B112D179
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/15] xfs: always defer agfl block frees
Date: Mon, 30 Jul 2018 12:45:19 -0400
Message-Id: <20180730164520.36882-15-bfoster@redhat.com>
In-Reply-To: <20180730164520.36882-1-bfoster@redhat.com>
References: <20180730164520.36882-1-bfoster@redhat.com>
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

