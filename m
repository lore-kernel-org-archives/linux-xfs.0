Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39593 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753847AbdJSOVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:21:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/18] fs/xfs: Use %pS printk format for direct addresses
Date: Thu, 19 Oct 2017 16:21:09 +0200
Message-Id: <20171019142123.18109-5-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Helge Deller <deller@gmx.de>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Helge Deller <deller@gmx.de>

commit e150dcd459e1b441eaf08f341a986f04e61bf3b8 upstream.

Use the %pS instead of the %pF printk format specifier for printing symbols
from direct addresses. This is needed for the ia64, ppc64 and parisc64
architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2f4feb959bfb..028e50a36f95 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -344,7 +344,7 @@ xfs_verifier_error(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
-	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
+	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  __return_address, bp->b_ops->name, bp->b_bn);
 
-- 
2.14.2

