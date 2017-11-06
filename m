Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:15 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUc-00025V-HR
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:14 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] xfs: remove unreachable error injection code in xfs_qm_dqget
Date: Mon,  6 Nov 2017 15:34:53 +0100
Message-Id: <20171106143456.13567-6-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8338b894d54f..d57c2db64e59 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -53,13 +53,6 @@
  * otherwise by the lowest id first, see xfs_dqlock2.
  */
 
-#ifdef DEBUG
-xfs_buftarg_t *xfs_dqerror_target;
-int xfs_do_dqerror;
-int xfs_dqreq_num;
-int xfs_dqerror_mod = 33;
-#endif
-
 struct kmem_zone		*xfs_qm_dqtrxzone;
 static struct kmem_zone		*xfs_qm_dqzone;
 
@@ -770,15 +763,6 @@ xfs_qm_dqget(
 		return -ESRCH;
 	}
 
-#ifdef DEBUG
-	if (xfs_do_dqerror) {
-		if ((xfs_dqerror_target == mp->m_ddev_targp) &&
-		    (xfs_dqreq_num++ % xfs_dqerror_mod) == 0) {
-			xfs_debug(mp, "Returning error in dqget");
-			return -EIO;
-		}
-	}
-
 	ASSERT(type == XFS_DQ_USER ||
 	       type == XFS_DQ_PROJ ||
 	       type == XFS_DQ_GROUP);
@@ -786,7 +770,6 @@ xfs_qm_dqget(
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT(xfs_inode_dquot(ip, type) == NULL);
 	}
-#endif
 
 restart:
 	mutex_lock(&qi->qi_tree_lock);
-- 
2.14.2

