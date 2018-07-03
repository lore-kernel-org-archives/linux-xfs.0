Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934110AbeGCRXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76B3B81A6D25
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 610F71117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/25] xfs: use ->t_firstblock in xfs_bmapi_remap()
Date: Tue,  3 Jul 2018 13:23:03 -0400
Message-Id: <20180703172319.24509-10-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4ace1267fc35..05647d4b8f3e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4503,7 +4503,6 @@ xfs_bmapi_remap(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
 	struct xfs_btree_cur	*cur = NULL;
-	xfs_fsblock_t		firstblock = NULLFSBLOCK;
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
 	int			whichfork = xfs_bmapi_whichfork(flags);
@@ -4546,7 +4545,7 @@ xfs_bmapi_remap(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = firstblock;
+		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -4559,7 +4558,7 @@ xfs_bmapi_remap(
 		got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
-			&cur, &got, &firstblock, &logflags, flags);
+			&cur, &got, &tp->t_firstblock, &logflags, flags);
 	if (error)
 		goto error0;
 
-- 
2.17.1

