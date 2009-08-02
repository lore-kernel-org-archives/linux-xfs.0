Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n72BEA0j018408 for <xfs@oss.sgi.com>; Sun, 2 Aug 2009 06:14:10 -0500
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6278C39D9CC
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2009 04:14:57 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.149])
	by cuda.sgi.com with ESMTP id zyBG2i9ZGfoLvkYs for
	<xfs@oss.sgi.com>; Sun, 02 Aug 2009 04:14:57 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 3so726434eyh.32
	for <xfs@oss.sgi.com>; Sun, 02 Aug 2009 04:14:56 -0700 (PDT)
Message-ID: <4A7575EF.8070404@gmail.com>
Date: Sun, 02 Aug 2009 13:18:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] SGI-PV: Read buffer overflow
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: felixb@sgi.com, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

Check whether index is within bounds before grabbing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 9ff6e57..ef1d275 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1414,8 +1414,9 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 	ASSERT(args != NULL);
 	ASSERT(path != NULL);
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
-	level = (path->active-1) - 1;	/* skip bottom layer in path */
-	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
+	/* skip bottom layer in path */
+	for (level = (path->active-1) - 1; level >= 0; blk--, level--) {
+		blk = &path->blk[level];
 		ASSERT(blk->bp != NULL);
 		node = blk->bp->data;
 		ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
