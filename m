Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SBJT244688 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E876147031B
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	GlFzec7k2cMMTeaN for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:07 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39223383-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:06 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfc-0001Cp-L9
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:04 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfH-0006Z9-At
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/34] xfs: convert pag_ici_lock to a spin lock
Date: Tue, 21 Dec 2010 18:29:06 +1100
Message-Id: <1292916570-25015-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

now that we are using RCU protection for the inode cache lookups,
the lock is only needed on the modification side. Hence it is not
necessary for the lock to be a rwlock as there are no read side
holders anymore. Convert it to a spin lock to reflect it's exclusive
nature.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_sync.c |    8 ++++----
 fs/xfs/xfs_ag.h             |    2 +-
 fs/xfs/xfs_iget.c           |   10 +++++-----
 fs/xfs/xfs_mount.c          |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index fd38682..a02480d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -620,12 +620,12 @@ xfs_inode_set_reclaim_tag(
 	struct xfs_perag *pag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	__xfs_inode_set_reclaim_tag(pag, ip);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 }
 
@@ -833,12 +833,12 @@ reclaim:
 	 * added to the tree assert that it's been there before to catch
 	 * problems with the inode life time early on.
 	 */
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
 		ASSERT(0);
 	__xfs_inode_clear_reclaim(pag, ip);
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 
 	/*
 	 * Here we do an (almost) spurious inode lock in order to coordinate
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 63c7a1a..58632cc 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -227,7 +227,7 @@ typedef struct xfs_perag {
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
-	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 04ed09b..3ecad00 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -260,7 +260,7 @@ xfs_iget_cache_hit(
 			goto out_error;
 		}
 
-		write_lock(&pag->pag_ici_lock);
+		spin_lock(&pag->pag_ici_lock);
 		spin_lock(&ip->i_flags_lock);
 		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
 		ip->i_flags |= XFS_INEW;
@@ -273,7 +273,7 @@ xfs_iget_cache_hit(
 				&xfs_iolock_active, "xfs_iolock_active");
 
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
+		spin_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -351,7 +351,7 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 
 	/* insert the new inode */
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
@@ -366,14 +366,14 @@ xfs_iget_cache_miss(
 	ip->i_udquot = ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 
 	*ipp = ip;
 	return 0;
 
 out_preload_end:
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f1b094d..312c5ce 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -598,7 +598,7 @@ xfs_initialize_perag(
 			goto out_unwind;
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
-		rwlock_init(&pag->pag_ici_lock);
+		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		spin_lock_init(&pag->pag_buf_lock);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
