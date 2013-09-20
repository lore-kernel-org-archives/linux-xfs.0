Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7904F7F37
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 17:06:03 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09559AC003
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 15:05:59 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r8KM5wND004469
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 17:05:58 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130920220519.585903357@sgi.com>
Date: Fri, 20 Sep 2013 17:05:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix node forward in xfs_node_toosmall 
Content-Disposition: inline; filename=xfs-fix-xfs_da3_node_toosmall-test.patch
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
 fs/xfs/xfs_da_btree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_da_btree.c
===================================================================
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1163,6 +1163,7 @@ xfs_da3_node_toosmall(
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
 	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da3_icnode_hdr firstnhdr;
 	int			count;
 	int			forward;
 	int			error;
@@ -1221,13 +1222,14 @@ xfs_da3_node_toosmall(
 	count -= state->node_ents >> 2;
 	count -= nodehdr.count;
 
+	firstnhdr = nodehdr;
 	/* start with smaller blk num */
 	forward = nodehdr.forw < nodehdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
 		if (forward)
-			blkno = nodehdr.forw;
+			blkno = firstnhdr.forw;
 		else
-			blkno = nodehdr.back;
+			blkno = firstnhdr.back;
 		if (blkno == 0)
 			continue;
 		error = xfs_da3_node_read(state->args->trans, state->args->dp,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
