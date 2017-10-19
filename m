Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdJSHAk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:40 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54op-0005ve-DR
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:39 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/15] xfs: update got in xfs_bmap_shift_update_extent
Date: Thu, 19 Oct 2017 08:59:39 +0200
Message-Id: <20171019065942.18813-13-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This way the caller gets the proper updated extent returned in got.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 703596caf255..2de9458903b6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5580,35 +5580,33 @@ xfs_bmap_shift_update_extent(
 	xfs_fileoff_t		startoff)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	new;
+	struct xfs_bmbt_irec	prev = *got;
 	int			error, i;
 
 	*logflags |= XFS_ILOG_CORE;
 
-	new = *got;
-	new.br_startoff = startoff;
+	got->br_startoff = startoff;
 
 	if (cur) {
-		error = xfs_bmbt_lookup_eq(cur, got, &i);
+		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
 		if (error)
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
-		error = xfs_bmbt_update(cur, &new);
+		error = xfs_bmbt_update(cur, got);
 		if (error)
 			return error;
 	} else {
 		*logflags |= XFS_ILOG_DEXT;
 	}
 
-	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx,
-			&new);
+	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx, got);
 
 	/* update reverse mapping */
-	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
+	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &prev);
 	if (error)
 		return error;
-	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
+	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, got);
 }
 
 int
-- 
2.14.1

