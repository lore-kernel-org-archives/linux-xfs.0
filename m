Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D284D7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 17:25:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C24E58F8040
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:25:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VkdK4x4eyGaNjyef (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 15:25:42 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 98D17A37F9
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 22:25:41 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-174.bos.redhat.com [10.18.41.174])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7HMPfsg032489
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 18:25:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 14/13] xfs: swap leaf buffer into path struct atomically
	during path shift
Date: Mon, 17 Aug 2015 18:25:39 -0400
Message-Id: <1439850339-19466-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439830072-61117-1-git-send-email-bfoster@redhat.com>
References: <1439830072-61117-1-git-send-email-bfoster@redhat.com>
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
---

v2:
- Removed unnecessary double pointer.
v1: http://oss.sgi.com/pipermail/xfs/2015-August/043108.html

 fs/xfs/libxfs/xfs_da_btree.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 3264d81..cd2201f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
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
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
