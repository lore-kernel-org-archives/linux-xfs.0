Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 23:11:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k936BQaG000747
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 23:11:28 -0700
Date: Tue, 3 Oct 2006 16:10:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: [RFC 2/3] Add a lock per inode cluster object
Message-ID: <20061003061040.GX3024@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Per cluster-object inode chain locks.

Currently, the cluster inode chain is protected by the cluster hash
chain lock. This means that any operation on the cluster inode chain
can hold out searches of the cluster hash. it also means that the
cluster inode chain is not independent of the cluster hash and hence
cannot be cleanly separated.

Give the cluster object it's own lock so that inode chain operations
can be done independently of the cluster hash.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_iget.c  |   26 +++++++++++++++++++++-----
 fs/xfs/xfs_inode.c |   10 +++-------
 fs/xfs/xfs_inode.h |    1 +
 3 files changed, 25 insertions(+), 12 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2006-09-18 11:18:24.669029430 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2006-09-18 12:02:26.328333578 +1000
@@ -338,7 +338,9 @@ finish_inode:
 		if (chl->chl_blkno == ip->i_blkno) {
 
 			/* insert this inode into the doubly-linked list
-			 * where chl points */
+			 * where chl points. lock the chl to protect against
+			 * others traversing the chl list */
+			spin_lock(&chl->chl_lock);
 			if ((iq = chl->chl_ip)) {
 				ip->i_cprev = iq->i_cprev;
 				iq->i_cprev->i_cnext = ip;
@@ -350,6 +352,7 @@ finish_inode:
 			}
 			chl->chl_ip = ip;
 			ip->i_chash = chl;
+			spin_unlock(&chl->chl_lock);
 			break;
 		}
 	}
@@ -363,8 +366,11 @@ finish_inode:
 					kmem_zone_alloc(xfs_chashlist_zone,
 						KM_SLEEP);
 			ASSERT(chlnew != NULL);
+			spin_lock_init(&chlnew->chl_lock);
 			goto chlredo;
 		} else {
+			/* exclusive access to this chl thanks to the ch_lock
+			 * in write mode, so no lock really needed */
 			ip->i_cnext = ip;
 			ip->i_cprev = ip;
 			ip->i_chash = chlnew;
@@ -649,13 +655,21 @@ xfs_iextract(
 	 */
 	mp = ip->i_mount;
 	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
-
-	if (ip->i_cnext == ip) {
+	spin_lock(&ip->i_chash->chl_lock);
+	if (unlikely(ip->i_cnext == ip)) {
 		/* Last inode on chashlist */
 		ASSERT(ip->i_cnext == ip && ip->i_cprev == ip);
 		ASSERT(ip->i_chash != NULL);
 		chm=NULL;
+
+		spin_unlock(&ip->i_chash->chl_lock);
+		spin_lock(&ch->ch_lock);
+		spin_lock(&ip->i_chash->chl_lock);
+		if (ip->i_cnext != ip) {
+			spin_unlock(&ch->ch_lock);
+			goto delete;
+		}
+		spin_unlock(&ip->i_chash->chl_lock);
 		chl = ip->i_chash;
 		if (chl->chl_prev)
 			chl->chl_prev->chl_next = chl->chl_next;
@@ -663,20 +677,22 @@ xfs_iextract(
 			ch->ch_list = chl->chl_next;
 		if (chl->chl_next)
 			chl->chl_next->chl_prev = chl->chl_prev;
+		spin_unlock(&ch->ch_lock);
 		kmem_zone_free(xfs_chashlist_zone, chl);
 	} else {
 		/* delete one inode from a non-empty list */
+delete:
 		iq = ip->i_cnext;
 		iq->i_cprev = ip->i_cprev;
 		ip->i_cprev->i_cnext = iq;
 		if (ip->i_chash->chl_ip == ip) {
 			ip->i_chash->chl_ip = iq;
 		}
+		spin_unlock(&ip->i_chash->chl_lock);
 		ip->i_chash = __return_address;
 		ip->i_cprev = __return_address;
 		ip->i_cnext = __return_address;
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
 
 	/*
 	 * Remove from mount's inode list.
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-09-18 11:18:24.669029430 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-09-18 12:02:26.328333578 +1000
@@ -3007,7 +3007,6 @@ xfs_iflush(
 	xfs_mount_t		*mp;
 	int			error;
 	/* REFERENCED */
-	xfs_chash_t		*ch;
 	xfs_inode_t		*iq;
 	int			clcount;	/* count of inodes clustered */
 	int			bufwasdelwri;
@@ -3126,12 +3125,9 @@ xfs_iflush(
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
-
+	spin_lock(&ip->i_chash->chl_lock);
 	ip->i_chash->chl_buf = bp;
 
-	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
-
 	clcount = 0;
 	for (iq = ip->i_cnext; iq != ip; iq = iq->i_cnext) {
 		/*
@@ -3184,7 +3180,7 @@ xfs_iflush(
 			xfs_iunlock(iq, XFS_ILOCK_SHARED);
 		}
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
+	spin_unlock(&ip->i_chash->chl_lock);
 
 	if (clcount) {
 		XFS_STATS_INC(xs_icluster_flushcnt);
@@ -3221,7 +3217,7 @@ cluster_corrupt_out:
 	/* Corruption detected in the clustering loop.  Invalidate the
 	 * inode buffer and shut down the filesystem.
 	 */
-	mutex_spinunlock(&ch->ch_lock, s);
+	spin_unlock(&ip->i_chash->chl_lock);
 
 	/*
 	 * Clean up the buffer.  If it was B_DELWRI, just release it --
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2006-09-18 11:18:24.673028907 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2006-09-18 12:02:26.328333578 +1000
@@ -194,6 +194,7 @@ typedef struct xfs_chashlist {
 	xfs_daddr_t		chl_blkno;	/* starting block number of
 						 * the cluster */
 	struct xfs_buf		*chl_buf;	/* the inode buffer */
+	lock_t			chl_lock;	/* inode list lock */
 } xfs_chashlist_t;
 
 typedef struct xfs_chash {
