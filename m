Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88t4Vd089587 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC3061DA9DA0
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	w4wGXKFOYQoAOmTs for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:29 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45461318-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:28 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWS-0001Co-P7
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVk-0004nd-UL
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/16] xfs: convert pag_ici_lock to a spin lock
Date: Mon,  8 Nov 2010 19:55:11 +1100
Message-Id: <1289206519-18377-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/linux-2.6/xfs_sync.c |   14 +++++++-------
 fs/xfs/xfs_ag.h             |    2 +-
 fs/xfs/xfs_iget.c           |   10 +++++-----
 fs/xfs/xfs_mount.c          |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 9a53cc9..0b3d367 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -596,12 +596,12 @@ xfs_inode_set_reclaim_tag(
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
 
@@ -802,12 +802,12 @@ reclaim:
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
@@ -871,14 +871,14 @@ restart:
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 			int	i;
 
-			write_lock(&pag->pag_ici_lock);
+			spin_lock(&pag->pag_ici_lock);
 			nr_found = radix_tree_gang_lookup_tag(
 					&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH,
 					XFS_ICI_RECLAIM_TAG);
 			if (!nr_found) {
-				write_unlock(&pag->pag_ici_lock);
+				spin_unlock(&pag->pag_ici_lock);
 				break;
 			}
 
@@ -905,7 +905,7 @@ restart:
 			}
 
 			/* unlock now we've grabbed the inodes. */
-			write_unlock(&pag->pag_ici_lock);
+			spin_unlock(&pag->pag_ici_lock);
 
 			for (i = 0; i < nr_found; i++) {
 				if (!batch[i])
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
index edeb918..e00d88c 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -237,14 +237,14 @@ xfs_iget_cache_hit(
 			goto out_error;
 		}
 
-		write_lock(&pag->pag_ici_lock);
+		spin_lock(&pag->pag_ici_lock);
 		spin_lock(&ip->i_flags_lock);
 		ip->i_flags &= ~(XFS_IRECLAIMABLE | XFS_IRECLAIM);
 		ip->i_flags |= XFS_INEW;
 		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		inode->i_state = I_NEW;
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
+		spin_unlock(&pag->pag_ici_lock);
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -322,7 +322,7 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 
 	/* insert the new inode */
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
@@ -337,14 +337,14 @@ xfs_iget_cache_miss(
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
index 0d9a030..7544258 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -564,7 +564,7 @@ xfs_initialize_perag(
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
