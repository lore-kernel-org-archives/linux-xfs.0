Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAu5ts121082 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 740CC11E4F78
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 04:08:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	H2QUw5RwVjuy6zhc for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 04:08:36 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39287317-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:26:50 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBx-0004OV-An
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:49 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBa-0000Q4-Vi
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/18] xfs: convert pag_ici_lock to a spin lock
Date: Tue, 14 Sep 2010 20:56:05 +1000
Message-Id: <1284461777-1496-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/linux-2.6/xfs_sync.c |   16 ++++++++--------
 fs/xfs/xfs_ag.h             |    2 +-
 fs/xfs/xfs_iget.c           |   10 +++++-----
 fs/xfs/xfs_mount.c          |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index e549d67..c093e91 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -100,13 +100,13 @@ restart:
 		xfs_inode_t	*ip;
 
 		if (exclusive)
-			write_lock(&pag->pag_ici_lock);
+			spin_lock(&pag->pag_ici_lock);
 		else
 			rcu_read_lock();
 		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
 		if (!ip) {
 			if (exclusive)
-				write_unlock(&pag->pag_ici_lock);
+				spin_unlock(&pag->pag_ici_lock);
 			else
 				rcu_read_unlock();
 			break;
@@ -659,12 +659,12 @@ xfs_inode_set_reclaim_tag(
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
 
@@ -757,12 +757,12 @@ xfs_reclaim_inode(
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
 		/* ignore as it is already under reclaim */
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
+		spin_unlock(&pag->pag_ici_lock);
 		return 0;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
@@ -834,11 +834,11 @@ reclaim:
 	 * added to the tree assert that it's been there before to catch
 	 * problems with the inode life time early on.
 	 */
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
 		ASSERT(0);
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 
 	/*
 	 * Here we do an (almost) spurious inode lock in order to coordinate
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 51c42c2..6de9128 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -227,7 +227,7 @@ typedef struct xfs_perag {
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
-	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index f3a46b6..c46ce03 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -234,14 +234,14 @@ xfs_iget_cache_hit(
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
@@ -319,7 +319,7 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 
 	/* insert the new inode */
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
@@ -334,14 +334,14 @@ xfs_iget_cache_miss(
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
index 14fc6e9..546eb1f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -450,7 +450,7 @@ xfs_initialize_perag(
 			goto out_unwind;
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
-		rwlock_init(&pag->pag_ici_lock);
+		spin_lock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 
 		if (radix_tree_preload(GFP_NOFS))
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
