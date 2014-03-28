Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 841A67F6A
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 12:33:57 -0500 (CDT)
Message-Id: <20140328173430.622616177@sgi.com>
Date: Fri, 28 Mar 2014 12:33:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix bad hash ordering
Content-Disposition: inline; filename=xfs-fix-directory-bad-hash-order.patch
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Linux Stable <stable@vger.kernel.org>

Fix the fix directory "bad hash ordering" bug introduced in
commit f5ea1100.

Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
A C program that generates this problem can be found at:
 http://oss.sgi.com/archives/xfs/2014-03/msg00373.html

A xfstest for this bug is coming from Hannes Frederic Sowa.

 fs/xfs/xfs_da_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_da_btree.c
===================================================================
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1295,7 +1295,7 @@ xfs_da3_fixhashpath(
 		node = blk->bp->b_addr;
 		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
-		if (be32_to_cpu(btree->hashval) == lasthash)
+		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree[blk->index].hashval = cpu_to_be32(lasthash);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
