Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964989AbeAXSoU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0B5C5C9C6
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2B4F60BE0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 18:44:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFCv2 1/9] xfs: create agfl block free helper function
Date: Wed, 24 Jan 2018 13:44:10 -0500
Message-Id: <20180124184418.40403-2-bfoster@redhat.com>
In-Reply-To: <20180124184418.40403-1-bfoster@redhat.com>
References: <20180124184418.40403-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Refactor the AGFL block free code into a new helper such that it can
be invoked from deferred context. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 37 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_alloc.h |  2 ++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6883a7668de6..fd1699d00986 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2053,6 +2053,30 @@ xfs_alloc_space_available(
 	return true;
 }
 
+int
+xfs_free_agfl_block(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	struct xfs_buf		*agbp,
+	struct xfs_owner_info	*oinfo)
+{
+	int			error;
+	struct xfs_buf		*bp;
+
+	error = xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
+				   XFS_AG_RESV_AGFL);
+	if (error)
+		return error;
+
+	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno, 0);
+	if (!bp)
+		return -EFSCORRUPTED;
+	xfs_trans_binval(tp, bp);
+
+	return 0;
+}
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2149,21 +2173,14 @@ xfs_alloc_fix_freelist(
 	else
 		xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
-		struct xfs_buf	*bp;
-
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
-		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
-					   &targs.oinfo, XFS_AG_RESV_AGFL);
+
+		error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
+					    &targs.oinfo);
 		if (error)
 			goto out_agbp_relse;
-		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
-		if (!bp) {
-			error = -EFSCORRUPTED;
-			goto out_agbp_relse;
-		}
-		xfs_trans_binval(tp, bp);
 	}
 
 	targs.tp = tp;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 65a0cafe06e4..2afd0980dba6 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -222,6 +222,8 @@ int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, struct xfs_buf **bpp);
+int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
+			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
-- 
2.13.6

