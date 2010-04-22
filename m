Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPfw3227491 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:41 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7F261AE628C
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:41 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id 418YhAWLmhUhhlHc for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:41 -0700 (PDT)
Message-Id: <20100422190909.113628274@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:50 -0700
From: Greg KH <gregkh@suse.de>
Subject: [019/197] xfs: Avoid inodes in reclaim when flushing from inode cache
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 018027be90a6946e8cf3f9b17b5582384f7ed117 upstream

The reclaim code will handle flushing of dirty inodes before reclaim
occurs, so avoid them when determining whether an inode is a
candidate for flushing to disk when walking the radix trees.  This
is based on a test patch from Christoph Hellwig.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -179,26 +179,31 @@ xfs_sync_inode_valid(
 	struct xfs_perag	*pag)
 {
 	struct inode		*inode = VFS_I(ip);
+	int			error = EFSCORRUPTED;
 
 	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		read_unlock(&pag->pag_ici_lock);
-		return EFSCORRUPTED;
-	}
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		goto out_unlock;
 
-	/* If we can't get a reference on the inode, it must be in reclaim. */
-	if (!igrab(inode)) {
-		read_unlock(&pag->pag_ici_lock);
-		return ENOENT;
-	}
-	read_unlock(&pag->pag_ici_lock);
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	error = ENOENT;
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock;
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		goto out_unlock;
+
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
-		return ENOENT;
+		goto out_unlock;
 	}
 
-	return 0;
+	/* inode is valid */
+	error = 0;
+out_unlock:
+	read_unlock(&pag->pag_ici_lock);
+	return error;
 }
 
 STATIC int


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
