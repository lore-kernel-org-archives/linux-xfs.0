Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA42F29E0C
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 21:19:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C56918F8049
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 19:19:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QYkhFp2BSMPyhTVY for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 19:19:29 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: ensure btree root split sets blkno correctly
Date: Wed, 12 Jun 2013 12:19:08 +1000
Message-Id: <1371003548-4026-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1371003548-4026-1-git-send-email-david@fromorbit.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

For CRC enabled filesystems, the BMBT is rooted in an inode, so it
passes through a difference code path on root splits to the
freespace and inode btrees. This is much less traversed by xfstests
than the other trees. When testing on a 1k block size filesystem,
I've been seeing ASSERT failures in generic/234 like:

XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/xfs_btree.c, line: 317

which are generally preceded by a lblock check failure. I noticed
this in the bmbt stats:

$ pminfo -f xfs.btree.block_map

xfs.btree.block_map.lookup
    value 39135

xfs.btree.block_map.compare
    value 268432

xfs.btree.block_map.insrec
    value 15786

xfs.btree.block_map.delrec
    value 13884

xfs.btree.block_map.newroot
    value 2

xfs.btree.block_map.killroot
    value 0
.....

Very little coverage of root splits and merges. Indeed, on a 4k
filesystem, block_map.newroot and block_map.killroot are both zero.
i.e the code is not exercised at all, and it's the only generic
btree infrastruct operation that is not exercised by a default run
of xfstests.

Turns out that on a 1k filesystem, generic/234 accounts for one of
those two root splits, and that is somewhat of a smoking gun. In
fact, it's the same problem we saw in the directory/attr code where
headers are memcpy()d from one block to another without updating the
self describing metadata.

Simple fix - when copying the header out of the root block, make
sure the block number is updated correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_btree.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 8804b8a..0903960 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -2544,7 +2544,17 @@ xfs_btree_new_iroot(
 	if (error)
 		goto error0;
 
+	/*
+	 * we can't just memcpy() the root in for CRC enabled btree blocks.
+	 * In that case have to also ensure the blkno remains correct
+	 */
 	memcpy(cblock, block, xfs_btree_block_len(cur));
+	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+			cblock->bb_u.l.bb_blkno = cpu_to_be64(cbp->b_bn);
+		else
+			cblock->bb_u.s.bb_blkno = cpu_to_be64(cbp->b_bn);
+	}
 
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
