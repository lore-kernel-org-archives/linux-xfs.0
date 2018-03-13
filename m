Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60950 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeCMOgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:11 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl2A-0004Zs-AR
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfs: don't use XFS_BMAPI_ENTRIRE in xfs_get_blocks
Date: Tue, 13 Mar 2018 15:35:55 +0100
Message-Id: <20180313143601.30028-3-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There is no reason to get a mapping bigger than what we were asked for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a0afb6411417..c79a3ca20ef8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1331,8 +1331,8 @@ xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, XFS_BMAPI_ENTIRE);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
+			&nimaps, 0);
 	if (error)
 		goto out_unlock;
 
-- 
2.14.2

