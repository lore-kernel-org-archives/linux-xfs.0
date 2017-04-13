Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33127 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753802AbdDMNva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 09:51:30 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyf9h-0003uM-Me
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 13:51:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mkfs: remove leftover blkid include
Date: Thu, 13 Apr 2017 15:51:22 +0200
Message-Id: <20170413135122.16730-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All topology handling moved to libxcmd a while ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6fedc05c..23e3e330 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -18,9 +18,6 @@
 
 #include "libxfs.h"
 #include <ctype.h>
-#ifdef ENABLE_BLKID
-#  include <blkid/blkid.h>
-#endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 
-- 
2.11.0

