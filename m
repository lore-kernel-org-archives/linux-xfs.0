Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162282AbdDURHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 13:07:35 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNI-0005Uw-41
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] xfs: use NULL instead of 0 to initialize a pointer in xfs_getfsmap
Date: Fri, 21 Apr 2017 17:21:18 +0200
Message-Id: <20170421152123.11316-2-hch@lst.de>
In-Reply-To: <20170421152123.11316-1-hch@lst.de>
References: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Found by sparse.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 48ce356da9e9..3683819887a5 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -827,7 +827,7 @@ xfs_getfsmap(
 	struct xfs_trans		*tp = NULL;
 	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
 	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
-	struct xfs_getfsmap_info	info = {0};
+	struct xfs_getfsmap_info	info = { NULL };
 	int				i;
 	int				error = 0;
 
-- 
2.11.0

