Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754436AbdKIN1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:14 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] xfs: trivial indentation fixup for xfs_iext_remove_node
Date: Thu,  9 Nov 2017 14:26:54 +0100
Message-Id: <20171109132656.1649-5-hch@lst.de>
In-Reply-To: <20171109132656.1649-1-hch@lst.de>
References: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 11b95bea23a9..3974989b0929 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -733,8 +733,7 @@ xfs_iext_remove_node(
 	node->ptrs[nr_entries] = NULL;
 
 	if (pos == 0 && nr_entries > 0) {
-		xfs_iext_update_node(ifp, offset, node->keys[0], level,
-				node);
+		xfs_iext_update_node(ifp, offset, node->keys[0], level, node);
 		offset = node->keys[0];
 	}
 
-- 
2.14.2

