Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA764vHE125694 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 00:04:57 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zrUct9OyWRkewq7Z for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 22:06:52 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TVymp-0000ma-7T
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 17:06:51 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TVymo-0007I0-TI
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 17:06:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix attr tree double split corruption
Date: Wed,  7 Nov 2012 17:06:50 +1100
Message-Id: <1352268410-27990-1-git-send-email-david@fromorbit.com>
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

In certain circumstances, a double split of an attribute tree is
needed to insert or replace an attribute. In rare situations, this
can go wrong, leaving the attribute tree corrupted. In this case,
the attr being replaced is the last attr in a leaf node, and the
replacement is larger so doesn't fit in the same leaf node.
When we have the initial condition of a node format attribute
btree with two leaves at index 1 and 2. Call them L1 and L2.  The
leaf L1 is completely full, there is not a single byte of free space
in it. L2 is mostly empty.  The attribute being replaced - call it X
- is the last attribute in L1.

The way an attribute replace is executed is that the replacement
attribute - call it Y - is first inserted into the tree, but has an
INCOMPLETE flag set on it so that list traversals ignore it. Once
this transaction is committed, a second transaction it run to
atomically mark Y as COMPLETE and X as INCOMPLETE, so that a
traversal will now find Y and skip X. Once that transaction is
committed, attribute X is then removed.

So, the initial condition is:

     +--------+     +--------+
     |   L1   |     |   L2   |
     | fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |
     | fsp: 0 |     | fsp: N |
     |--------|     |--------|
     | attr A |     | attr 1 |
     |--------|     |--------|
     | attr B |     | attr 2 |
     |--------|     |--------|
     ..........     ..........
     |--------|     |--------|
     | attr X |     | attr n |
     +--------+     +--------+


So now we go to replace X, and see that L1:fsp = 0 - it is full so
we can't insert Y in the same leaf. So we record the the location of
attribute X so we can track it for later use, then we split L1 into
L1 and L3 and reblance across the two leafs. We end with:


     +--------+     +--------+     +--------+
     |   L1   |     |   L3   |     |   L2   |
     | fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|
     | attr A |     | attr X |     | attr 1 |
     |--------|     +--------+     |--------|
     | attr B |                    | attr 2 |
     |--------|                    |--------|
     ..........                    ..........
     |--------|                    |--------|
     | attr W |                    | attr n |
     +--------+                    +--------+


And we track that the original attribute is now at L3:0.

We then try to insert Y into L1 again, and find that there isn't
enough room because the new attribute is larger than the old one.
Hence we have to split again to make room for Y. We end up with
this:


     +--------+     +--------+     +--------+     +--------+
     |   L1   |     |   L4   |     |   L3   |     |   L2   |
     | fwd: 4 |---->| fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 4 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|     |--------|
     | attr A |     | attr Y |     | attr X |     | attr 1 |
     |--------|     + INCOMP +     +--------+     |--------|
     | attr B |     +--------+                    | attr 2 |
     |--------|                                   |--------|
     ..........                                   ..........
     |--------|                                   |--------|
     | attr W |                                   | attr n |
     +--------+                                   +--------+

And now we have the new (incomplete) attribute @ L4:0, and the
original attribute at L3:0. At this point, the first transaction is
committed, and we move to the flipping of the flags.

This is where we are supposed to end up with this:

     +--------+     +--------+     +--------+     +--------+
     |   L1   |     |   L4   |     |   L3   |     |   L2   |
     | fwd: 4 |---->| fwd: 3 |---->| fwd: 2 |---->| fwd: 0 |
     | bwd: 0 |<----| bwd: 1 |<----| bwd: 4 |<----| bwd: 3 |
     | fsp: M |     | fsp: J |     | fsp: J |     | fsp: N |
     |--------|     |--------|     |--------|     |--------|
     | attr A |     | attr Y |     | attr X |     | attr 1 |
     |--------|     +--------+     + INCOMP +     |--------|
     | attr B |                    +--------+     | attr 2 |
     |--------|                                   |--------|
     ..........                                   ..........
     |--------|                                   |--------|
     | attr W |                                   | attr n |
     +--------+                                   +--------+

But that doesn't happen properly - the attribute tracking indexes
are not pointing to the right locations. What we end up with is both
the old attribute to be removed pointing at L4:0 and the new
attribute at L4:1.  On a debug kernel, this assert fails like so:

XFS: Assertion failed: args->index2 < be16_to_cpu(leaf2->hdr.count), file: fs/xfs/xfs_attr_leaf.c, line: 2725

because the new attribute location does not exist. On a production
kernel, this goes unnoticed and the code proceeds ahead merrily and
removes L4 because it thinks that is the block that is no longer
needed. This leaves the hash index node pointing to entries
L1, L4 and L2, but only blocks L1, L3 and L2 to exist. Further, the
leaf level sibling list is L1 <-> L4 <-> L2, but L4 is now free
space, and so everything is busted. This corruption is caused by the
removal of the old attribute triggering a join - it joins everything
correctly but then frees the wrong block.

xfs_repair will report something like:

bad sibling back pointer for block 4 in attribute fork for inode 131
problem with attribute contents in inode 131
would clear attr fork
bad nblocks 8 for inode 131, would reset to 3
bad anextents 4 for inode 131, would reset to 0

The problem lies in the assignment of the old/new blocks for
tracking purposes when the double leaf split occurs. The first split
tries to place the new attribute inside the current leaf (i.e.
"inleaf == true") and moves the old attribute (X) to the new block.
This sets up the old block/index to L1:X, and newly allocated
block to L3:0. It then moves attr X to the new block and tries to
insert attr Y at the old index. That fails, so it splits again.

With the second split, the rebalance ends up placing the new attr in
the second new block - L4:0 - and this is where the code goes wrong.
What is does is it sets both the new and old block index to the
second new block. Hence it inserts attr Y at the right place (L4:0)
but overwrites the current location of the attr to replace that is
held in the new block index (currently L3:0). It over writes it with
L4:1 - the index we later assert fail on.

Hopefully this table will show this in a foramt that is a bit easier
to understand:

Split		old attr index		new attr index
		vanilla	patched		vanilla	patched
before 1st	L1:26	L1:26		N/A	N/A
after 1st	L3:0	L3:0		L1:26	L1:26
after 2nd	L4:0	L3:0		L4:1	L4:0
                ^^^^			^^^^
		wrong			wrong

The fix is surprisingly simple, for all this analysis - just stop
the rebalance on the out-of leaf case from overwriting the new attr
index - it's already correct for the double split case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index d790860..39eb8c6 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1336,6 +1336,7 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	leaf2 = blk2->bp->b_addr;
 	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	ASSERT(leaf2->hdr.count == 0);
 	args = state->args;
 
 	trace_xfs_attr_leaf_rebalance(args);
@@ -1406,6 +1407,7 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		 * I assert that since all callers pass in an empty
 		 * second buffer, this code should never execute.
 		 */
+		ASSERT(0);
 
 		/*
 		 * Figure the total bytes to be added to the destination leaf.
@@ -1467,10 +1469,24 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 			args->index2 = 0;
 			args->blkno2 = blk2->blkno;
 		} else {
+			/*
+			 * On a double leaf split, the original attr location
+			 * is already stored in blkno2/index2, so don't
+			 * overwrite it overwise we corrupt the tree.
+			 */
 			blk2->index = blk1->index
 				    - be16_to_cpu(leaf1->hdr.count);
-			args->index = args->index2 = blk2->index;
-			args->blkno = args->blkno2 = blk2->blkno;
+			args->index = blk2->index;
+			args->blkno = blk2->blkno;
+			if (!state->extravalid) {
+				/*
+				 * set the new attr location to match the old
+				 * one and let the higher level split code
+				 * decide where in the leaf to place it.
+				 */
+				args->index2 = blk2->index;
+				args->blkno2 = blk2->blkno;
+			}
 		}
 	} else {
 		ASSERT(state->inleaf == 1);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
