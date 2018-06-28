Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935604AbeF1Qgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 765AE401DEB0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61F70111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 15/24] xfs: remove xfs_bmapi_remap() dfops param
Date: Thu, 28 Jun 2018 12:36:27 -0400
Message-Id: <20180628163636.52564-16-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All xfs_bmapi_remap() callers already use ->t_dfops. Note that
deferred completion context unconditionally sets ->t_dfops if it
hasn't already been set by the caller. Remove the unnecessary
parameter and access ->t_dfops directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 ++++----
 fs/xfs/libxfs/xfs_bmap.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 25769e4f424c..2bbeccad1e90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4513,7 +4513,6 @@ xfs_bmapi_remap(
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
 	xfs_fsblock_t		startblock,
-	struct xfs_defer_ops	*dfops,
 	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -4563,7 +4562,7 @@ xfs_bmapi_remap(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = firstblock;
-		cur->bc_private.b.dfops = dfops;
+		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -4576,7 +4575,7 @@ xfs_bmapi_remap(
 		got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
-			&cur, &got, &firstblock, dfops, &logflags, flags);
+			&cur, &got, &firstblock, tp->t_dfops, &logflags, flags);
 	if (error)
 		goto error0;
 
@@ -6187,8 +6186,9 @@ xfs_bmap_finish_one(
 
 	switch (type) {
 	case XFS_BMAP_MAP:
+		ASSERT(dfops == tp->t_dfops);
 		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, dfops, 0);
+				startblock, 0);
 		*blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4ff56f55f2bb..1e2694adb9c7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -287,6 +287,6 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
-		struct xfs_defer_ops *dfops, int flags);
+		int flags);
 
 #endif	/* __XFS_BMAP_H__ */
-- 
2.17.1

