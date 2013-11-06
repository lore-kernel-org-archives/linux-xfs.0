Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB4F329E64
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BED388F808E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	L4NLF1h3SCo4iMmH for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003OB-6X
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008Ux-5p
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/37] xfs: fix node forward in xfs_node_toosmall
Date: Wed,  6 Nov 2013 12:06:59 +1100
Message-Id: <1383700043-32305-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

When a node is considered for a merge with a sibling, it overwrites the
sibling pointers of the original incore nodehdr with the sibling's
pointers.  This leads to loop considering the original node as a merge
candidate with itself in the second pass, and so it incorrectly
determines a merge should occur.)

Ported from equivalent kernel commit 997def25.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_da_btree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f106e06..53414f5 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1201,6 +1201,7 @@ xfs_da3_node_toosmall(
 	/* start with smaller blk num */
 	forward = nodehdr.forw < nodehdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
+		struct xfs_da3_icnode_hdr thdr;
 		if (forward)
 			blkno = nodehdr.forw;
 		else
@@ -1213,10 +1214,10 @@ xfs_da3_node_toosmall(
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
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
