Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934287AbeGCRXW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA95234703
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1D8E1117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 21/25] xfs: replace no-op firstblock init with ->t_firstblock
Date: Tue,  3 Jul 2018 13:23:15 -0400
Message-Id: <20180703172319.24509-22-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_refcount_recover_cow_leftovers() has no need for a firstblock
variable and so passes an unrelated xfs_fsblock_t to
xfs_defer_init() to avoid declaring one. Replace this no-op
initialization with ->t_firstblock. This will be optimized away by
the removal of the xfs_defer_init() firstblock param.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8dc380574cd8..d81c17aac710 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1691,7 +1691,7 @@ xfs_refcount_recover_cow_leftovers(
 		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
 
 		/* Free the orphan record */
-		xfs_defer_init(tp, &dfops, &fsb);
+		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
 		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
 		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
-- 
2.17.1

