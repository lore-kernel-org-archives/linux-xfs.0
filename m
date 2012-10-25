Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6WZqH102274 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:32:35 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9IimMrvH8rLnqNhe for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:19 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1G-00009d-1Q
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1F-00053T-Ub
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/25] xfs: invalidate allocbt blocks moved to the free list
Date: Thu, 25 Oct 2012 17:33:51 +1100
Message-Id: <1351146854-19343-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1351146854-19343-1-git-send-email-david@fromorbit.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we free a block from the alloc btree tree, we move it to the
freelist held in the AGFL and mark it busy in the busy extent tree.
This typically happens when we merge btree blocks.

Once the transaction is committed and checkpointed, the block can
remain on the free list for an indefinite amount of time.  Now, this
isn't the end of the world at this point - if the free list is
shortened, the buffer is invalidated in the transaction that moves
it back to free space. If the buffer is allocated as metadata from
the free list, then all the modifications getted logged, and we have
no issues, either. And if it gets allocated as userdata direct from
the freelist, it gets invalidated and so will never get written.

However, during the time it sits on the free list, pressure on the
log can cause the AIL to be pushed and the buffer that covers the
block gets pushed for write. IOWs, we end up writing a freed
metadata block to disk. Again, this isn't the end of the world
because we know from the above we are only writing to free space.

The problem, however, is for validation callbacks. If the block was
on old btree root block, then the level of the block is going to be
higher than the current tree root, and so will fail validation.
There may be other inconsistencies in the block as well, and
currently we don't care because the block is in free space. Shutting
down the filesystem because a freed block doesn't pass write
validation, OTOH, is rather unfriendly.

So, make sure we always invalidate buffers as they move from the
free space trees to the free list so that we guarantee they never
get written to disk while on the free list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index f1647ca..f7876c6 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -121,6 +121,8 @@ xfs_allocbt_free_block(
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
+
+	xfs_trans_binval(cur->bc_tp, bp);
 	return 0;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
