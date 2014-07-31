Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B00B77FBE
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BC78AC005
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DvC0tVje4l0Wpdjh for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gW-SV
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003yC-RS
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: kill VN_CACHED
Date: Thu, 31 Jul 2014 17:33:13 +1000
Message-Id: <1406791995-14723-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1406791995-14723-1-git-send-email-david@fromorbit.com>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
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

Only has 2 users, has outlived it's usefulness.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 fs/xfs/xfs_vnode.h     | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d32889a..8da2a6a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -809,7 +809,7 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 	 * have speculative prealloc/delalloc blocks to remove.
 	 */
 	if (VFS_I(ip)->i_size == 0 &&
-	    VN_CACHED(VFS_I(ip)) == 0 &&
+	    VFS_I(ip)->i_mapping->nrpages == 0 &&
 	    ip->i_delayed_blks == 0)
 		return false;
 
@@ -1667,7 +1667,7 @@ xfs_swap_extents(
 	truncate_pagecache_range(VFS_I(tip), 0, -1);
 
 	/* Verify O_DIRECT for ftmp */
-	if (VN_CACHED(VFS_I(tip)) != 0) {
+	if (VFS_I(tip)->i_mapping->nrpages) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
index 07b475a..bcf0c74 100644
--- a/fs/xfs/xfs_vnode.h
+++ b/fs/xfs/xfs_vnode.h
@@ -38,7 +38,6 @@ struct attrlist_cursor_kern;
  * Some useful predicates.
  */
 #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
-#define VN_CACHED(vp)	(vp->i_mapping->nrpages)
 
 
 #endif	/* __XFS_VNODE_H__ */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
