Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf4uj194381 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29439141F77C
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Q7brBGzC0pB76Cb5 for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:35 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/19] xfs: check for not fully initialized inodes in
	xfs_ireclaim
Date: Fri, 12 Mar 2010 09:42:04 +1100
Message-Id: <1268347337-7160-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

>From b44b1126279b60597f96bbe77507b1650f88a969
Date: Tue, 1 Dec 2009 18:12:29 +0000
Add an assert for inodes not added to the inode cache in xfs_ireclaim,
to make sure we're not going to introduce something like the
famous nfsd inode cache bug again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_iget.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 80e5264..40e8775 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -511,17 +511,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	if (!radix_tree_delete(&pag->pag_ici_root, agino))
+		ASSERT(0);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
