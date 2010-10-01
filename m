Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o917gw7g041456 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 02:42:58 -0500
Received: from cmpxchg.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF49D1500830
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 00:57:13 -0700 (PDT)
Received: from cmpxchg.org (f0.cmpxchg.org [85.214.51.133]) by cuda.sgi.com
	with ESMTP id Mmnp4w9M4oNqKsZ9 for <xfs@oss.sgi.com>;
	Fri, 01 Oct 2010 00:57:13 -0700 (PDT)
Date: Fri, 1 Oct 2010 09:43:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101001074354.GF2618@cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org, stable@kernel.org

When marking an inode reclaimable, a per-AG counter is increased, the
inode is tagged reclaimable in its per-AG tree, and, when this is the
first reclaimable inode in the AG, the AG entry in the per-mount tree
is also tagged.

When an inode is finally reclaimed, however, it is only deleted from
the per-AG tree.  Neither the counter is decreased, nor is the parent
tree's AG entry untagged properly.

Since the tags in the per-mount tree are not cleared, the inode
shrinker iterates over all AGs that have had reclaimable inodes at one
point in time.

The counters on the other hand signal an increasing amount of slab
objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
per-filesystem context" this is not a real issue anymore because the
shrinker bails out after one iteration.

But the problem was observable on a machine running v2.6.34, where the
reclaimable work increased and each process going into direct reclaim
eventually got stuck on the xfs inode shrinking path, trying to scan
several million objects.

Fix this by properly unwinding the reclaimable-state tracking of an
inode when it is reclaimed.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org
---
 fs/xfs/linux-2.6/xfs_sync.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d59c4a6..81976ff 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -668,14 +668,11 @@ xfs_inode_set_reclaim_tag(
 	xfs_perag_put(pag);
 }
 
-void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
+STATIC void
+__xfs_inode_clear_reclaim(
 	xfs_perag_t	*pag,
 	xfs_inode_t	*ip)
 {
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 	pag->pag_ici_reclaimable--;
 	if (!pag->pag_ici_reclaimable) {
 		/* clear the reclaim tag from the perag radix tree */
@@ -689,6 +686,17 @@ __xfs_inode_clear_reclaim_tag(
 	}
 }
 
+void
+__xfs_inode_clear_reclaim_tag(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_inode_t	*ip)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	__xfs_inode_clear_reclaim(pag, ip);
+}
+
 /*
  * Inodes in different states need to be treated differently, and the return
  * value of xfs_iflush is not sufficient to get this right. The following table
@@ -838,6 +846,7 @@ reclaim:
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 
 	/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
