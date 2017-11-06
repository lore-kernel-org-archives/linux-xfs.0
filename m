Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59519 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:12 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUZ-000254-Qf
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: remove unused debug counts for xfs_lock_inodes
Date: Mon,  6 Nov 2017 15:34:52 +0100
Message-Id: <20171106143456.13567-5-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index edd98353fbeb..d8226f7a5dde 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -385,14 +385,6 @@ xfs_isilocked(
 }
 #endif
 
-#ifdef DEBUG
-int xfs_locked_n;
-int xfs_small_retries;
-int xfs_middle_retries;
-int xfs_lots_retries;
-int xfs_lock_delays;
-#endif
-
 /*
  * xfs_lockdep_subclass_ok() is only used in an ASSERT, so is only called when
  * DEBUG or XFS_WARN is set. And MAX_LOCKDEP_SUBCLASSES is then only defined
@@ -545,24 +537,11 @@ xfs_lock_inodes(
 
 		if ((attempts % 5) == 0) {
 			delay(1); /* Don't just spin the CPU */
-#ifdef DEBUG
-			xfs_lock_delays++;
-#endif
 		}
 		i = 0;
 		try_lock = 0;
 		goto again;
 	}
-
-#ifdef DEBUG
-	if (attempts) {
-		if (attempts < 5) xfs_small_retries++;
-		else if (attempts < 100) xfs_middle_retries++;
-		else xfs_lots_retries++;
-	} else {
-		xfs_locked_n++;
-	}
-#endif
 }
 
 /*
-- 
2.14.2

