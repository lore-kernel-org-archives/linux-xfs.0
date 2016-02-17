Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77A127CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2DA7AC001
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:14 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7Gxh5KxFeuUbRog7 for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:12 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lt-NG
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00013t-Lx
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/15] xfs: handle errors from ->free_blocks in
	xfs_btree_kill_iroot
Date: Wed, 17 Feb 2016 18:20:39 +1100
Message-Id: <1455693652-3899-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit 196328ec973a74ee52cc282824e72c3824dc1cf5

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_btree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index efcad26..14d8bf3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3209,6 +3209,7 @@ xfs_btree_kill_iroot(
 	int			level;
 	int			index;
 	int			numrecs;
+	int			error;
 #ifdef DEBUG
 	union xfs_btree_ptr	ptr;
 	int			i;
@@ -3272,8 +3273,6 @@ xfs_btree_kill_iroot(
 	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 #ifdef DEBUG
 	for (i = 0; i < numrecs; i++) {
-		int		error;
-
 		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
 		if (error) {
 			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
@@ -3283,7 +3282,11 @@ xfs_btree_kill_iroot(
 #endif
 	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
 
-	cur->bc_ops->free_block(cur, cbp);
+	error = cur->bc_ops->free_block(cur, cbp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
 	XFS_BTREE_STATS_INC(cur, free);
 
 	cur->bc_bufs[level - 1] = NULL;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
