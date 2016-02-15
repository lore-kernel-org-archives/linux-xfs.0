Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2413E7CA4
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B78C9AC004
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:58 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZR4ZQCQ9vEIJbz1N for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:57 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MF-J2
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005Gd-IG
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/14] xfs: bmapbt checking on debug kernels too expensive
Date: Mon, 15 Feb 2016 17:18:18 +1100
Message-Id: <1455517105-20033-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

Source kernel commit e35438196c6a1d8b206471d51e80c380e80e047b

For large sparse or fragmented files, checking every single entry in
the bmapbt on every operation is prohibitively expensive. Especially
as such checks rarely discover problems during normal operations on
high extent coutn files. Our regression tests don't tend to exercise
files with hundreds of thousands to millions of extents, so mostly
this isn't noticed.

However, trying to run things like xfs_mdrestore of large filesystem
dumps on a debug kernel quickly becomes impossible as the CPU is
completely burnt up repeatedly walking the sparse file bmapbt that
is generated for every allocation that is made.

Hence, if the file has more than 10,000 extents, just don't bother
with walking the tree to check it exhaustively. The btree code has
checks that ensure that the newly inserted/removed/modified record
is correctly ordered, so the entrie tree walk in thses cases has
limited additional value.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 70417fc..eb19133 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -317,9 +317,11 @@ xfs_check_block(
 
 /*
  * Check that the extents for the inode ip are in the right order in all
- * btree leaves.
+ * btree leaves. THis becomes prohibitively expensive for large extent count
+ * files, so don't bother with inodes that have more than 10,000 extents in
+ * them. The btree record ordering checks will still be done, so for such large
+ * bmapbt constructs that is going to catch most corruptions.
  */
-
 STATIC void
 xfs_bmap_check_leaf_extents(
 	xfs_btree_cur_t		*cur,	/* btree cursor or null */
@@ -344,6 +346,10 @@ xfs_bmap_check_leaf_extents(
 		return;
 	}
 
+	/* skip large extent count inodes */
+	if (ip->i_d.di_nextents > 10000)
+		return;
+
 	bno = NULLFSBLOCK;
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
