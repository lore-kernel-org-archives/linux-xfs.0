Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4F6F7F6C
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:04:30 -0500 (CDT)
Received: from eagdhcp-232-178.americas.sgi.com
	(eagdhcp-232-178.americas.sgi.com [128.162.232.178])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 557C8304032
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:04:27 -0700 (PDT)
Received: from eagdhcp-232-178.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-178.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s37J4SaO002955
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2014 14:04:28 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-178.americas.sgi.com)
Message-Id: <20140407190101.292316075@sgi.com>
Date: Mon, 07 Apr 2014 14:00:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfsprogs: fix directory hash ordering bug
References: <20140328173430.622616177@sgi.com>
Content-Disposition: inline; filename=libxfs-fix-directory-bad-hash-order.patch
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

Commit f5ea1100 ("xfs: add CRCs to dir2/da node blocks") introduced
in 3.10 incorrectly converted the btree hash index array pointer in
xfs_da3_fixhashpath(). It resulted in the the current hash always
being compared against the first entry in the btree rather than the
current block index into the btree block's hash entry array. As a
result, it was comparing the wrong hashes, and so could misorder the
entries in the btree.

For most cases, this doesn't cause any problems as it requires hash
collisions to expose the ordering problem. However, when there are
hash collisions within a directory there is a very good probability
that the entries will be ordered incorrectly and that actually
matters when duplicate hashes are placed into or removed from the
btree block hash entry array.

This bug results in an on-disk directory corruption and that results
in directory verifier functions throwing corruption warnings into
the logs. While no data or directory entries are lost, access to
them may be compromised, and attempts to remove entries from a
directory that has suffered from this corruption may result in a
filesystem shutdown.  xfs_repair will fix the directory hash
ordering without data loss occuring.

[dchinner: wrote useful a commit message]

Ported from equivalent kernel commit c88547a8.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 libxfs/xfs_da_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/libxfs/xfs_da_btree.c
===================================================================
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1313,7 +1313,7 @@ xfs_da3_fixhashpath(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		btree = xfs_da3_node_tree_p(node);
-		if (be32_to_cpu(btree->hashval) == lasthash)
+		if (be32_to_cpu(btree[blk->index]->hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree[blk->index].hashval = cpu_to_be32(lasthash);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
