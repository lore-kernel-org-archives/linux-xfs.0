Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfEQHcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:11 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLe-0000iU-HY
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/20] xfs: fix a trivial comment typo in the xfs_trans_committed_bulk
Date: Fri, 17 May 2019 09:31:00 +0200
Message-Id: <20190517073119.30178-2-hch@lst.de>
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 912b42f5fe4a..19f91312561a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -815,7 +815,7 @@ xfs_log_item_batch_insert(
  *
  * If we are called with the aborted flag set, it is because a log write during
  * a CIL checkpoint commit has failed. In this case, all the items in the
- * checkpoint have already gone through iop_commited and iop_unlock, which
+ * checkpoint have already gone through iop_committed and iop_unlock, which
  * means that checkpoint commit abort handling is treated exactly the same
  * as an iclog write error even though we haven't started any IO yet. Hence in
  * this case all we need to do is iop_committed processing, followed by an
-- 
2.20.1
