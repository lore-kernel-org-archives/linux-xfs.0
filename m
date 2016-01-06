Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BA3B7F47
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:32:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BDB678F8059
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 15:32:36 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0LSP2jc6xRLAQPn4 for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 15:32:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aGxY9-0000Ck-T2
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aGxY9-0003dD-Rx
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: bmapbt checking on debug kernels too expensive
Date: Thu,  7 Jan 2016 10:31:27 +1100
Message-Id: <1452123087-13892-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1452123087-13892-1-git-send-email-david@fromorbit.com>
References: <1452123087-13892-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_bmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7388495..bc7e7d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -325,9 +325,11 @@ xfs_check_block(
 
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
@@ -352,6 +354,10 @@ xfs_bmap_check_leaf_extents(
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
