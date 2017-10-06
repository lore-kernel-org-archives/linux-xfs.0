Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751484AbdJFUHm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 16:07:42 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5BF22C977C
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2017 20:07:41 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9EC760F86
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2017 20:07:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: reinit btree pointer on attr tree inactivation walk
Date: Fri,  6 Oct 2017 16:07:40 -0400
Message-Id: <20171006200740.7140-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
---

I suspect this is the cause of the NULL buf problem down in
xfs_attr_inactive(). I can manufacture an instance of that problem as
noted above. We have a customer who's hitting that problem and will
attempt to validate this fix, but there is no confirmation as of yet.
I'm posting this for review in the meantime because this seems like a
legit fix regardless of whether they are hitting this or something else.

Brian

 fs/xfs/xfs_attr_inactive.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index ebd66b1..e3a950e 100644
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
2.9.5

