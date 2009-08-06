Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n76LnZvl088984 for <xfs@oss.sgi.com>; Thu, 6 Aug 2009 16:49:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75C1F1465AF7
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2009 14:50:25 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id hWbmnKKzIFDCUlWC for
	<xfs@oss.sgi.com>; Thu, 06 Aug 2009 14:50:25 -0700 (PDT)
Message-ID: <4A7B501F.7010307@sandeen.net>
Date: Thu, 06 Aug 2009 16:50:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: fix locking in xfs_iget_cache_hit
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141834.526088000@bombadil.infradead.org>
In-Reply-To: <20090804141834.526088000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Any chance this could be broken into 2 patches starting
with the set/clear cleanup something like:


diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index b619d6b..49c7b6f 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -708,6 +708,17 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	radix_tree_tag_set(&pag->pag_ici_root,
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_RECLAIM_TAG);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+}
+
 /*
  * We set the inode flag atomically with the radix tree tag.
  * Once we get tag lookups on the radix tree, this inode flag
@@ -722,9 +733,7 @@ xfs_inode_set_reclaim_tag(
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
-	radix_tree_tag_set(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	__xfs_inode_set_reclaim_tag(pag, ip);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
@@ -732,27 +741,12 @@ xfs_inode_set_reclaim_tag(
 
 void
 __xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
 	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-}
-
-void
-xfs_inode_clear_reclaim_tag(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
-
-	read_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			     XFS_ICI_RECLAIM_TAG);
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 2a10301..cb64d20 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,9 +48,8 @@ int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
-void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
-				struct xfs_inode *ip);
+void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 
 int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 5fcec6f..94b72d3 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -183,7 +183,7 @@ xfs_iget_cache_hit(
 		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 
 		/* clear the radix tree reclaim flag as well. */
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
+		__xfs_inode_clear_reclaim_tag(pag, ip);
 	} else if (!igrab(VFS_I(ip))) {
 		/* If the VFS inode is being torn down, pause and try again. */
 		XFS_STATS_INC(xs_ig_frecycle);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
