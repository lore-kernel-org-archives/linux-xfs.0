Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6F0a5tl173204 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 19:36:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DD37159666D
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 17:39:00 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	1u2rCwAXbiy3wG6E for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 17:39:00 -0700 (PDT)
Received: from dastard (unverified [121.44.38.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19923721-1927428
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 10:08:58 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OZCTP-0002zH-PD
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:47 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OZCTC-0000Xs-8b
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: simplify and remove xfs_ireclaim
Date: Thu, 15 Jul 2010 10:38:17 +1000
Message-Id: <1279154300-2018-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1279154300-2018-1-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
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

xfs_ireclaim has to get and put te pag structure because it is only
called with the inode to reclaim. The one caller of this function
already has a reference on the pag and a pointer to is, so move the
radix tree delete to the caller and remove xfs_ireclaim completely.
This avoids a xfs_perag_get/put on every inode being reclaimed.

The overhead was noticed in a bug report at:

https://bugzilla.kernel.org/show_bug.cgi?id=16348

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   31 ++++++++++++++++++++++++-
 fs/xfs/xfs_iget.c           |   53 +------------------------------------------
 fs/xfs/xfs_inode.h          |    2 +-
 3 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 51da595..80ae18a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -855,7 +855,36 @@ out:
 reclaim:
 	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_ireclaim(ip);
+
+	XFS_STATS_INC(xs_ig_reclaims);
+	/*
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
+	 */
+	write_lock(&pag->pag_ici_lock);
+	if (!radix_tree_delete(&pag->pag_ici_root,
+				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
+		ASSERT(0);
+	write_unlock(&pag->pag_ici_lock);
+
+	/*
+	 * Here we do an (almost) spurious inode lock in order to coordinate
+	 * with inode cache radix tree lookups.  This is because the lookup
+	 * can reference the inodes in the cache without taking references.
+	 *
+	 * We make that OK here by ensuring that we wait until the inode is
+	 * unlocked after the lookup before we go ahead and free it.  We get
+	 * both the ilock and the iolock because the code may need to drop the
+	 * ilock one but will still hold the iolock.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_qm_dqdetach(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	xfs_inode_free(ip);
 	return error;
 
 }
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 9e86f21..eba5ae6 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -91,7 +91,7 @@ xfs_inode_alloc(
 	return ip;
 }
 
-STATIC void
+void
 xfs_inode_free(
 	struct xfs_inode	*ip)
 {
@@ -418,57 +418,6 @@ out_error_or_again:
 }
 
 /*
- * This is called free all the memory associated with an inode.
- * It must free the inode itself and any buffers allocated for
- * if_extents/if_data and if_broot.  It must also free the lock
- * associated with the inode.
- *
- * Note: because we don't initialise everything on reallocation out
- * of the zone, we must ensure we nullify everything correctly before
- * freeing the structure.
- */
-void
-xfs_ireclaim(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-
-	XFS_STATS_INC(xs_ig_reclaims);
-
-	/*
-	 * Remove the inode from the per-AG radix tree.
-	 *
-	 * Because radix_tree_delete won't complain even if the item was never
-	 * added to the tree assert that it's been there before to catch
-	 * problems with the inode life time early on.
-	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	write_lock(&pag->pag_ici_lock);
-	if (!radix_tree_delete(&pag->pag_ici_root, agino))
-		ASSERT(0);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_perag_put(pag);
-
-	/*
-	 * Here we do an (almost) spurious inode lock in order to coordinate
-	 * with inode cache radix tree lookups.  This is because the lookup
-	 * can reference the inodes in the cache without taking references.
-	 *
-	 * We make that OK here by ensuring that we wait until the inode is
-	 * unlocked after the lookup before we go ahead and free it.  We get
-	 * both the ilock and the iolock because the code may need to drop the
-	 * ilock one but will still hold the iolock.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	xfs_inode_free(ip);
-}
-
-/*
  * This is a wrapper routine around the xfs_ilock() routine
  * used to centralize some grungy code.  It is used in places
  * that wish to lock the inode solely for reading the extents.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index eb41559..0898c54 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -450,7 +450,7 @@ void		xfs_ilock_demote(xfs_inode_t *, uint);
 int		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
 void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
-void		xfs_ireclaim(xfs_inode_t *);
+void		xfs_inode_free(struct xfs_inode *ip);
 
 /*
  * xfs_inode.c prototypes.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
