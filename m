Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdGMLdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 07:33:23 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcMv-0001oV-Dc
        for linux-xfs@vger.kernel.org; Thu, 13 Jul 2017 11:33:17 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: assert locking precondition in xfs_readlink_bmap_ilocked
Date: Thu, 13 Jul 2017 13:33:03 +0200
Message-Id: <20170713113304.8079-4-hch@lst.de>
In-Reply-To: <20170713113304.8079-1-hch@lst.de>
References: <20170713113304.8079-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 12cd9cf7de41..23a50d7aa46a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -61,6 +61,8 @@ xfs_readlink_bmap_ilocked(
 	int			fsblocks = 0;
 	int			offset;
 
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
 	fsblocks = xfs_symlink_blocks(mp, pathlen);
 	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
 	if (error)
-- 
2.11.0

