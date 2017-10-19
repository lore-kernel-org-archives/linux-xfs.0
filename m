Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36289 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdJSHAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:02 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54oC-0004Ft-Nu
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/15] xfs: remove post-bmap tracing in xfs_bmap_local_to_extents
Date: Thu, 19 Oct 2017 08:59:30 +0200
Message-Id: <20171019065942.18813-4-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that we use xfs_iext_insert this is already covered by the tracing
in that function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 06a9ac7dcdab..8c2e5d6bced2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -920,8 +920,6 @@ xfs_bmap_local_to_extents(
 	rec.br_state = XFS_EXT_NORM;
 	xfs_iext_insert(ip, 0, 1, &rec, 0);
 
-	trace_xfs_bmap_post_update(ip, 0, xfs_bmap_fork_to_state(whichfork),
-			_THIS_IP_);
 	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 	ip->i_d.di_nblocks = 1;
 	xfs_trans_mod_dquot_byino(tp, ip,
-- 
2.14.1

