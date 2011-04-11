Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3B2Ux11062686 for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 21:31:00 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A7D415BC18B
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 19:34:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZABErdEOI0uqczy4 for <xfs@oss.sgi.com>;
	Sun, 10 Apr 2011 19:34:18 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q96xD-0005aK-DD
	for xfs@oss.sgi.com; Mon, 11 Apr 2011 12:34:15 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q96x9-0000Oz-Vt
	for xfs@oss.sgi.com; Mon, 11 Apr 2011 12:34:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix bmbt block allocation failures
Date: Mon, 11 Apr 2011 12:34:11 +1000
Message-Id: <1302489251-1512-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When a multilevel bmbt split occurs, we can be asked to allocate
blocks from an AG that has no space left available. In the case of
an extent just being allocated, the first bmbt block allocation sees
the firstblock parameter is set and does not set a minleft parameter
for the allocation. The allocation also does not set the total
number of blocks required by the allocation, either.

If the extent allocation used all the free space in the AG, the lack
of a total allocation size results in a block being reserved for the
AG freespace btree manipulations being used incorrectly.

Secondly, the allocation is only allowed to be allocated in the
current AG (NEAR_BNO) because the low space algorithm has not been
activated. As a result of this, the second block allocation in the
split fails to find sufficient space in the current AG and fails,
resulting in a dirty transaction cancellation and a filesytem
shutdown.

There are two problems here - both pointed out by Lachlan McIlroy
when we were first discussing a proposed fix for the problem (See
http://oss.sgi.com/archives/xfs/2010-09/msg00438.html).  Firstly,
the missing args->total was causing the initial block to be
allocated from the freespace reserve. Secondly that the NEAR_BNO
allocation should probably be a START_BNO allocation to allow blocks
to be taken from a higher numbered AG.

With these changes, the allocation failure goes away, but we trigger
asserts in xfs_bmapi() that try to ensure that bmbt block
allocations only occur in the same AG as the extent allocated,
except if the low space algorithm is active. In this case, we don't
need to activate the low space algorithm - if a START_BNO allocation
fails with minleft = 0, then there is no space we can allocate at
all, and hence the low space algorithm is no help. Therefore the
asserts need modification reflect the new state of affairs.

This commit fixes the problem demonstrated by the test case in
xfstests 250.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c       |    8 ++------
 fs/xfs/xfs_bmap_btree.c |    7 ++-----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index fa00788..50eed97 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4917,13 +4917,9 @@ error0:
 	if (cur) {
 		if (!error) {
 			ASSERT(*firstblock == NULLFSBLOCK ||
-			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
+			       XFS_FSB_TO_AGNO(mp, *firstblock) <=
 			       XFS_FSB_TO_AGNO(mp,
-				       cur->bc_private.b.firstblock) ||
-			       (flist->xbf_low &&
-				XFS_FSB_TO_AGNO(mp, *firstblock) <
-				XFS_FSB_TO_AGNO(mp,
-					cur->bc_private.b.firstblock)));
+				       cur->bc_private.b.firstblock));
 			*firstblock = cur->bc_private.b.firstblock;
 		}
 		xfs_btree_del_cursor(cur,
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 87d3c10..b2cdbfe 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -518,10 +518,11 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	args.total = 1;
+	args.type = XFS_ALLOCTYPE_START_BNO;
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
-		args.type = XFS_ALLOCTYPE_START_BNO;
 		/*
 		 * Make sure there is sufficient room left in the AG to
 		 * complete a full tree split for an extent insert.  If
@@ -534,10 +535,6 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = xfs_trans_get_block_res(args.tp);
-	} else if (cur->bc_private.b.flist->xbf_low) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
