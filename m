Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52835 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754436AbdKIN1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:12 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] xfs: remove a superflous assignment in xfs_iext_remove_node
Date: Thu,  9 Nov 2017 14:26:53 +0100
Message-Id: <20171109132656.1649-4-hch@lst.de>
In-Reply-To: <20171109132656.1649-1-hch@lst.de>
References: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index c28a24aca9c5..11b95bea23a9 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -751,7 +751,6 @@ xfs_iext_remove_node(
 
 		node = xfs_iext_rebalance_node(parent, &pos, node, nr_entries);
 		if (node) {
-			offset = node->keys[0];
 			victim = node;
 			node = parent;
 			goto again;
-- 
2.14.2

