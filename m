Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4F227CAA
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88229AC004
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2512rhIiNzSCmsGK for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:55 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MJ-L9
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005Gy-K1
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/14] xfs: swap leaf buffer into path struct atomically
	during path shift
Date: Mon, 15 Feb 2016 17:18:22 +1100
Message-Id: <1455517105-20033-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Brian Foster <bfoster@redhat.com>

Source kernel commit 7df1c170b9a45ab3a7401c79bbefa9939bf8eafb

The node directory lookup code uses a state structure that tracks the
path of buffers used to search for the hash of a filename through the
leaf blocks. When the lookup encounters a block that ends with the
requested hash, but the entry has not yet been found, it must shift over
to the next block and continue looking for the entry (i.e., duplicate
hashes could continue over into the next block). This shift mechanism
involves walking back up and down the state structure, replacing buffers
at the appropriate btree levels as necessary.

When a buffer is replaced, the old buffer is released and the new buffer
read into the active slot in the path structure. Because the buffer is
read directly into the path slot, a buffer read failure can result in
setting a NULL buffer pointer in an active slot. This throws off the
state cleanup code in xfs_dir2_node_lookup(), which expects to release a
buffer from each active slot. Instead, a BUG occurs due to a NULL
pointer dereference:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000001e8
  IP: [<ffffffffa0585063>] xfs_trans_brelse+0x2a3/0x3c0 [xfs]
  ...
  RIP: 0010:[<ffffffffa0585063>]  [<ffffffffa0585063>] xfs_trans_brelse+0x2a3/0x3c0 [xfs]
  ...
  Call Trace:
   [<ffffffffa05250c6>] xfs_dir2_node_lookup+0xa6/0x2c0 [xfs]
   [<ffffffffa0519f7c>] xfs_dir_lookup+0x1ac/0x1c0 [xfs]
   [<ffffffffa055d0e1>] xfs_lookup+0x91/0x290 [xfs]
   [<ffffffffa05580b3>] xfs_vn_lookup+0x73/0xb0 [xfs]
   [<ffffffff8122de8d>] lookup_real+0x1d/0x50
   [<ffffffff8123330e>] path_openat+0x91e/0x1490
   [<ffffffff81235079>] do_filp_open+0x89/0x100
   ...

This has been reproduced via a parallel fsstress and filesystem shutdown
workload in a loop. The shutdown triggers the read error in the
aforementioned codepath and causes the BUG in xfs_dir2_node_lookup().

Update xfs_da3_path_shift() to update the active path slot atomically
with respect to the caller when a buffer is replaced. This ensures that
the caller always sees the old or new buffer in the slot and prevents
the NULL pointer dereference.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_da_btree.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 25072c7..f3c04ab 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1822,6 +1822,7 @@ xfs_da3_path_shift(
 	struct xfs_da_args	*args;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_buf		*bp;
 	xfs_dablk_t		blkno = 0;
 	int			level;
 	int			error;
@@ -1866,20 +1867,24 @@ xfs_da3_path_shift(
 	 */
 	for (blk++, level++; level < path->active; blk++, level++) {
 		/*
-		 * Release the old block.
-		 * (if it's dirty, trans won't actually let go)
+		 * Read the next child block into a local buffer.
 		 */
-		if (release)
-			xfs_trans_brelse(args->trans, blk->bp);
+		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
+					  args->whichfork);
+		if (error)
+			return error;
 
 		/*
-		 * Read the next child block.
+		 * Release the old block (if it's dirty, the trans doesn't
+		 * actually let go) and swap the local buffer into the path
+		 * structure. This ensures failure of the above read doesn't set
+		 * a NULL buffer in an active slot in the path.
 		 */
+		if (release)
+			xfs_trans_brelse(args->trans, blk->bp);
 		blk->blkno = blkno;
-		error = xfs_da3_node_read(args->trans, dp, blkno, -1,
-					&blk->bp, args->whichfork);
-		if (error)
-			return error;
+		blk->bp = bp;
+
 		info = blk->bp->b_addr;
 		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
