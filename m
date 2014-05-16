Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F3AA7F53
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 18:01:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 567C530406B
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 16:01:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TezXZjYl6I2lPhAg for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 16:01:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WlR84-0004xS-Ti
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:01:28 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WlR84-0007z0-Sb
	for xfs@oss.sgi.com; Sat, 17 May 2014 09:01:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: remove redundant checks from xfs_da_read_buf
Date: Sat, 17 May 2014 09:01:28 +1000
Message-Id: <1400281288-30652-1-git-send-email-david@fromorbit.com>
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

All of the verification checks of magic numbers are now done by
verifiers, so ther eis no need to check them again once the buffer
has been successfully read. If the magic number is bad, it won't
even get to that code to verify it so it really serves no purpose at
all anymore. Remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c | 41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 9eec594..4db5102 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2624,47 +2624,6 @@ xfs_da_read_buf(
 		xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
 	else
 		xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
-
-	/*
-	 * This verification code will be moved to a CRC verification callback
-	 * function so just leave it here unchanged until then.
-	 */
-	{
-		xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
-		xfs_dir2_free_t		*free = bp->b_addr;
-		xfs_da_blkinfo_t	*info = bp->b_addr;
-		uint			magic, magic1;
-		struct xfs_mount	*mp = dp->i_mount;
-
-		magic = be16_to_cpu(info->magic);
-		magic1 = be32_to_cpu(hdr->magic);
-		if (unlikely(
-		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
-				   (magic != XFS_DA3_NODE_MAGIC) &&
-				   (magic != XFS_ATTR_LEAF_MAGIC) &&
-				   (magic != XFS_ATTR3_LEAF_MAGIC) &&
-				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
-				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
-				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
-				   (magic != XFS_DIR3_LEAFN_MAGIC) &&
-				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
-				   (magic1 != XFS_DIR3_BLOCK_MAGIC) &&
-				   (magic1 != XFS_DIR2_DATA_MAGIC) &&
-				   (magic1 != XFS_DIR3_DATA_MAGIC) &&
-				   (free->hdr.magic !=
-					cpu_to_be32(XFS_DIR2_FREE_MAGIC)) &&
-				   (free->hdr.magic !=
-					cpu_to_be32(XFS_DIR3_FREE_MAGIC)),
-				mp, XFS_ERRTAG_DA_READ_BUF,
-				XFS_RANDOM_DA_READ_BUF))) {
-			trace_xfs_da_btree_corrupt(bp, _RET_IP_);
-			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
-					     XFS_ERRLEVEL_LOW, mp, info);
-			error = XFS_ERROR(EFSCORRUPTED);
-			xfs_trans_brelse(trans, bp);
-			goto out_free;
-		}
-	}
 	*bpp = bp;
 out_free:
 	if (mapp != &map)
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
