Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763811AbdDST3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 15:29:11 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d0vHq-0001hN-6d
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 19:29:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: remove the unused XFS_MAXLINK_1 define
Date: Wed, 19 Apr 2017 21:29:02 +0200
Message-Id: <20170419192904.22203-2-hch@lst.de>
In-Reply-To: <20170419192904.22203-1-hch@lst.de>
References: <20170419192904.22203-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6b7579e7b60a..d114ed80a076 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -930,10 +930,8 @@ static inline uint xfs_dinode_size(int version)
 /*
  * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
  * Since the pathconf interface is signed, we use 2^31 - 1 instead.
- * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
-#define	XFS_MAXLINK_1		65535U
 
 /*
  * Values for di_format
-- 
2.11.0

