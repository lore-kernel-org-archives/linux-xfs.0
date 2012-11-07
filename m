Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7DG1XF152677 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 07:16:02 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WnBFVkpZkgEO3ugd for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 05:17:58 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TW5Vz-0001bn-GB
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 00:17:55 +1100
Date: Thu, 8 Nov 2012 00:17:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/22] xfs: buffer type changes in xfs_da_root_join
Message-ID: <20121107131755.GD6434@dastard>
References: <1352178813-17216-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352178813-17216-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs: buffer type changes in xfs_da_root_join

From: Dave Chinner <dchinner@redhat.com>

When a root join occurs, a node format tree can be turne dback into
a leaf format tree by copying the last remaining leaf block into the
root block. At this point, the root block changes from a xfs_da_node
to a xfs_attr_leaf, and the magic number changes. However,
xfs_da_root_join treats this block as a xfs_da_node and sets the
verifier up as such. This is the wrong verifier when a leaf block
is moved into the root.

Fix this by copying the verifier from the buffer being copied into
the root block. This ensures that the leaf verifier is moved with
the leaf data, and avoids verifier failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

I posted this as separate patch rather than going back an
integrating it and then rebasing all the other patches on top it
afterwards. Simpler, faster, and the buf being fixed is more obvious
and easier to review, too. Found from debugging occassional 070 and
117 failures when run in a tight loop for a couple of hours..

 fs/xfs/xfs_da_btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 43db040..eecdf55 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -835,7 +835,15 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr,
 					be16_to_cpu(oldroot->hdr.level));
 
+	/*
+	 * This could be copying a leaf back into the root block in the case of
+	 * there only being a single leaf block left in the tree. Hence we have
+	 * to update the buf ops pointer as well to match the buffer type change
+	 * that could occur.
+	 */
 	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
+	root_blk->bp->b_ops = bp->b_ops;
+
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
 	return(error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
