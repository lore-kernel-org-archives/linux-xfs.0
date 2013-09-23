Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E915C7F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 13:19:58 -0500 (CDT)
Message-Id: <20130923171911.273669684@sgi.com>
Date: Mon, 23 Sep 2013 12:18:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall 
References: <20130920220519.585903357@sgi.com>
Content-Disposition: inline;
	filename=v2-xfs-fix-xfs_da3_node_toosmall-test.patch
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
To: xfs@oss.sgi.com, stable@vger.kernel.org

Commit f5ea1100 cleans up the disk to host conversions for
node directory entries, but because a variable is reused in
xfs_node_toosmall() the next node is not correctly found.
If the original node is small enough (<= 3/8 of the node size),
this change may incorrectly cause a node collapse when it should
not. That will cause an assert in xfstest generic/319:

   Assertion failed: first <= last && last < BBTOB(bp->b_length),
   file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569

Keep the original node header to get the correct forward node.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 v2 -> Dave's local variable approach.
    -> send to -stable this bug is in 3.10 and 3.11

 fs/xfs/xfs_da_btree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_da_btree.c
===================================================================
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1224,6 +1224,7 @@ xfs_da3_node_toosmall(
 	/* start with smaller blk num */
 	forward = nodehdr.forw < nodehdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
+		struct xfs_da3_icnode_hdr thdr; 
 		if (forward)
 			blkno = nodehdr.forw;
 		else
@@ -1236,10 +1237,10 @@ xfs_da3_node_toosmall(
 			return(error);
 
 		node = bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		xfs_da3_node_hdr_from_disk(&thdr, node);
 		xfs_trans_brelse(state->args->trans, bp);
 
-		if (count - nodehdr.count >= 0)
+		if (count - thdr.count >= 0)
 			break;	/* fits with at least 25% to spare */
 	}
 	if (i >= 2) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
