Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763551AbdDST3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 15:29:14 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d0vHt-0001jv-0M
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 19:29:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: remove unused values from xfs_exntst_t
Date: Wed, 19 Apr 2017 21:29:03 +0200
Message-Id: <20170419192904.22203-3-hch@lst.de>
In-Reply-To: <20170419192904.22203-1-hch@lst.de>
References: <20170419192904.22203-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only ever use the normal and unwritten states.  And the actual
ondisk format (this enum isn't despite being in xfs_format.h) only
has space for the unwritten bit anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d114ed80a076..8425884668a8 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1588,7 +1588,6 @@ typedef enum {
  */
 typedef enum {
 	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
 } xfs_exntst_t;
 
 /*
-- 
2.11.0

