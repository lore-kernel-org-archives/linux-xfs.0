Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdH3OyD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:54:03 -0400
Received: from 80-109-164-210.cable.dynamic.surfer.at ([80.109.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dn4NW-0006ka-Ty
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 14:54:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: remove experimental tag for reflinks
Date: Wed, 30 Aug 2017 16:54:00 +0200
Message-Id: <20170830145400.3681-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

But reject reflink + DAX file systems for now until the code to
support reflinks on DAX is actually implemented.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacdbb8b3..92521032468e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1634,7 +1634,9 @@ xfs_fs_fill_super(
 		}
 		if (xfs_sb_version_hasreflink(&mp->m_sb))
 			xfs_alert(mp,
-		"DAX and reflink have not been tested together!");
+		"DAX and reflink can not be used together!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
 	}
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
@@ -1648,10 +1650,6 @@ xfs_fs_fill_super(
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		xfs_alert(mp,
-	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
-
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.11.0

