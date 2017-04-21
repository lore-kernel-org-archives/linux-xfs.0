Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162229AbdDURGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 13:06:49 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNK-0005V0-RJ
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: use NULL instead of 0 to initialize a pointer in xfs_ioc_getfsmap
Date: Fri, 21 Apr 2017 17:21:19 +0200
Message-Id: <20170421152123.11316-3-hch@lst.de>
In-Reply-To: <20170421152123.11316-1-hch@lst.de>
References: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Found by sparse.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fee6b4a3a83d..0f8bed9a7e4c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1640,7 +1640,7 @@ xfs_ioc_getfsmap(
 	struct xfs_inode	*ip,
 	void			__user *arg)
 {
-	struct getfsmap_info	info = {0};
+	struct getfsmap_info	info = { NULL };
 	struct xfs_fsmap_head	xhead = {0};
 	struct fsmap_head	head;
 	bool			aborted = false;
-- 
2.11.0

