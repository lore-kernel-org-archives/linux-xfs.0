Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38553 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753938AbdJSOWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:22:07 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/18] xfs: reinit btree pointer on attr tree inactivation walk
Date: Thu, 19 Oct 2017 16:21:19 +0200
Message-Id: <20171019142123.18109-15-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit f35c5e10c6ed6ba52a8dd8573924a80b6a02f03f upstream.

xfs_attr3_root_inactive() walks the attr fork tree to invalidate the
associated blocks. xfs_attr3_node_inactive() recursively descends
from internal blocks to leaf blocks, caching block address values
along the way to revisit parent blocks, locate the next entry and
descend down that branch of the tree.

The code that attempts to reread the parent block is unsafe because
it assumes that the local xfs_da_node_entry pointer remains valid
after an xfs_trans_brelse() and re-read of the parent buffer. Under
heavy memory pressure, it is possible that the buffer has been
reclaimed and reallocated by the time the parent block is reread.
This means that 'btree' can point to an invalid memory address, lead
to a random/garbage value for child_fsb and cause the subsequent
read of the attr fork to go off the rails and return a NULL buffer
for an attr fork offset that is most likely not allocated.

Note that this problem can be manufactured by setting
XFS_ATTR_BTREE_REF to 0 to prevent LRU caching of attr buffers,
creating a file with a multi-level attr fork and removing it to
trigger inactivation.

To address this problem, reinit the node/btree pointers to the
parent buffer after it has been re-read. This ensures btree points
to a valid record and allows the walk to proceed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_attr_inactive.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index be0b79d8900f..c6643004e583 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -302,6 +302,8 @@ xfs_attr3_node_inactive(
 						 &bp, XFS_ATTR_FORK);
 			if (error)
 				return error;
+			node = bp->b_addr;
+			btree = dp->d_ops->node_tree_p(node);
 			child_fsb = be32_to_cpu(btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
 		}
-- 
2.14.2

