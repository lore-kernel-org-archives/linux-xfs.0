Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B32E7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 11:52:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D101AAC00E
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:52:49 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EaKvMg6QHCGC2VJH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:52:48 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aJPbD-0003NR-1g
	for xfs@oss.sgi.com; Wed, 13 Jan 2016 17:52:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: handle errors from ->free_blocks in
	xfs_btree_kill_iroot
Date: Wed, 13 Jan 2016 18:50:52 +0100
Message-Id: <1452707454-15229-2-git-send-email-hch@lst.de>
In-Reply-To: <1452707454-15229-1-git-send-email-hch@lst.de>
References: <1452707454-15229-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a0eb18c..3143577 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
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
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
