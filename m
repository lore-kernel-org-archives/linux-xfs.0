Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 161828016
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A522DAC006
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TTc5uamMEoGw8z2k for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001C9-PF
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006nS-JF
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/22] libxfs: ensure btree root split sets blkno correctly
Date: Wed, 12 Jun 2013 20:36:25 +1000
Message-Id: <1371033394-26006-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

For CRC enabled filesystems, the BMBT is rooted in an inode, so it
passes through a difference code path on root splits to the
freespace and inode btrees. The inode based btree root has a
corruption problem on split - it's the same problem we saw in the
directory/attr code where headers are memcpy()d from one block to
another without updating the self describing metadata.

Simple fix - when copying the header out of the root block, make
sure the block number is updated correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_btree.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index b11131c..3ac3330 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2487,7 +2487,17 @@ xfs_btree_new_iroot(
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
