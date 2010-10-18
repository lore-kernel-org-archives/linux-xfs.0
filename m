Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IGeAQn256449 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 11:40:11 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3474304051
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 09:41:19 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.4/8.14.2) with ESMTP id o9IGfJ0l008257
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 11:41:19 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.4/8.14.4/Submit) id o9IGfJV0008255
	for xfs@oss.sgi.com; Mon, 18 Oct 2010 11:41:19 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010181641.o9IGfJV0008255@stout.americas.sgi.com>
Date: Mon, 18 Oct 2010 11:41:18 -0500
Subject: [PATCH] xfs: drop duplicate function resulting from merge
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

The XFS development master branch somehow diverged from Linus'
master branch in such a way that merging the former into the latter
caused __xfs_inode_clear_reclaim_tag() to appear twice in the file
"fs/xfs/linux-2.6/xfs_sync.c".

I'm resolving this by re-basing the XFS branch against linus/master.
This commit (on top of that rebase) deletes the extra copy of the
function.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 574fb71..37d3325 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -667,17 +667,6 @@ xfs_reclaim_inode_grab(
 	return 0;
 }
 
-void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_inode_clear_reclaim(pag, ip);
-}
-
 /*
  * Inodes in different states need to be treated differently, and the return
  * value of xfs_iflush is not sufficient to get this right. The following table
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
