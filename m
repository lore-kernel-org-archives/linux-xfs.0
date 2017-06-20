Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbdFTJCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 05:02:55 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: remove a whitespace-only line from xfs_fs_get_nextdqblk
Date: Tue, 20 Jun 2017 11:02:44 +0200
Message-Id: <20170620090244.30876-3-hch@lst.de>
In-Reply-To: <20170620090244.30876-1-hch@lst.de>
References: <20170620090244.30876-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: agruenba@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_quotaops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index f82d79a8c694..de9493253edf 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -269,7 +269,6 @@ xfs_fs_get_nextdqblk(
 	/* ID may be different, so convert back what we got */
 	*qid = make_kqid(current_user_ns(), qid->type, id);
 	return 0;
-	
 }
 
 STATIC int
-- 
2.11.0

