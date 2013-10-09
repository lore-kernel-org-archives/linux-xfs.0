Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 644087FB3
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 19:09:30 -0500 (CDT)
Date: Tue, 8 Oct 2013 19:09:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfs: fix node forward in xfs_node_toosmall
Message-ID: <20131009000926.GI10553@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Commit f5ea1100 cleans up the disk to host conversions for
node directory entries, but because a variable is reused in
xfs_node_toosmall() the next node is not correctly found.
If the original node is small enough (<= 3/8 of the node size),
this change may incorrectly cause a node collapse when it should
not. That will cause an assert in xfstest generic/319:

   Assertion failed: first <= last && last < BBTOB(bp->b_length),
   file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569

Keep the original node header to get the correct forward node.

(When a node is considered for a merge with a sibling, it overwrites the
 sibling pointers of the original incore nodehdr with the sibling's
 pointers.  This leads to loop considering the original node as a merge
 candidate with itself in the second pass, and so it incorrectly
 determines a merge should occur.)

upstream commit 997def25e4b9cee3b01609e18a52f926bca8bd2b

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

[v3: added Dave Chinner's (slightly modified) suggestion to the commit header,
	cleaned up whitespace.  -bpm]
---

Hi Stable Folk,

   Please take this commit for stable branches back to 3.10.  This fixes a bug
   in XFS directory code.

Thanks,
	Ben

 fs/xfs/xfs_da_btree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 069537c..20bf8e8 100644
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
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
