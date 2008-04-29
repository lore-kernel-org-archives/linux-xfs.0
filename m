Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 22:15:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T5EiYN019043
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 22:14:49 -0700
Message-ID: <4816AEEB.8090907@sgi.com>
Date: Tue, 29 Apr 2008 15:15:23 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: review: s/i_flags_lock/i_inner_lock/g
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi there,

As part of future plans to cache incore versions of acls
off the inode, we want to protect its modification by a spin lock.
Dave suggested that we use the i_flags_lock but rename it to
reflect its more general purpose on other fields, such as "i_inner_lock".
This patch is then basically s/i_flags_lock/i_inner_lock/g.

--Tim

xfs_inode.c    |    2 +-
xfs_inode.h    |   18 +++++++++---------
xfs_itable.c   |    2 +-
xfs_vnodeops.c |   12 ++++++------
4 files changed, 17 insertions(+), 17 deletions(-)

Index: 2.6.x-xfs-quilt/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_inode.c	2008-04-22 16:59:58.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_inode.c	2008-04-29 14:39:30.975728220 +1000
@@ -815,7 +815,7 @@ xfs_iread(
  	ip->i_ino = ino;
  	ip->i_mount = mp;
  	atomic_set(&ip->i_iocount, 0);
-	spin_lock_init(&ip->i_flags_lock);
+	spin_lock_init(&ip->i_inner_lock);

  	/*
  	 * Get pointer's to the on-disk inode and the buffer containing it.
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_inode.h	2008-04-22 16:59:58.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_inode.h	2008-04-29 15:12:12.705537185 +1000
@@ -226,7 +226,7 @@ typedef struct xfs_inode {
  	sema_t			i_flock;	/* inode flush lock */
  	atomic_t		i_pincount;	/* inode pin count */
  	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
-	spinlock_t		i_flags_lock;	/* inode i_flags lock */
+	spinlock_t		i_inner_lock;	/* an innermost inode field spinlock */
  	/* Miscellaneous state. */
  	unsigned short		i_flags;	/* see defined flags below */
  	unsigned char		i_update_core;	/* timestamps/size is dirty */
@@ -275,17 +275,17 @@ __xfs_iflags_set(xfs_inode_t *ip, unsign
  static inline void
  xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
  {
-	spin_lock(&ip->i_flags_lock);
+	spin_lock(&ip->i_inner_lock);
  	__xfs_iflags_set(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&ip->i_inner_lock);
  }

  static inline void
  xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
  {
-	spin_lock(&ip->i_flags_lock);
+	spin_lock(&ip->i_inner_lock);
  	ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&ip->i_inner_lock);
  }

  static inline int
@@ -298,9 +298,9 @@ static inline int
  xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
  {
  	int ret;
-	spin_lock(&ip->i_flags_lock);
+	spin_lock(&ip->i_inner_lock);
  	ret = __xfs_iflags_test(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&ip->i_inner_lock);
  	return ret;
  }

@@ -309,11 +309,11 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
  {
  	int ret;

-	spin_lock(&ip->i_flags_lock);
+	spin_lock(&ip->i_inner_lock);
  	ret = ip->i_flags & flags;
  	if (ret)
  		ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&ip->i_inner_lock);
  	return ret;
  }
  #endif	/* __KERNEL__ */
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_itable.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_itable.c	2008-04-22 16:59:58.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_itable.c	2008-04-29 14:39:30.999725178 +1000
@@ -601,7 +601,7 @@ xfs_bulkstat(
  								      KM_SLEEP);
  						ip->i_ino = ino;
  						ip->i_mount = mp;
-						spin_lock_init(&ip->i_flags_lock);
+						spin_lock_init(&ip->i_inner_lock);
  						if (bp)
  							xfs_buf_relse(bp);
  						error = xfs_itobp(mp, NULL, ip,
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_vnodeops.c	2008-04-22 16:59:59.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_vnodeops.c	2008-04-29 14:39:30.991726192 +1000
@@ -3240,7 +3240,7 @@ xfs_reclaim(
  	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
  	 * first to ensure that xfs_iunpin() will never see an xfs inode
  	 * that has a linux inode being reclaimed. Synchronisation is provided
-	 * by the i_flags_lock.
+	 * by the i_inner_lock.
  	 */
  	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
  		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -3251,11 +3251,11 @@ xfs_reclaim(

  		/* Protect sync and unpin from us */
  		XFS_MOUNT_ILOCK(mp);
-		spin_lock(&ip->i_flags_lock);
+		spin_lock(&ip->i_inner_lock);
  		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
  		vn_to_inode(vp)->i_private = NULL;
  		ip->i_vnode = NULL;
-		spin_unlock(&ip->i_flags_lock);
+		spin_unlock(&ip->i_inner_lock);
  		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
  		XFS_MOUNT_IUNLOCK(mp);
  	}
@@ -3281,10 +3281,10 @@ xfs_finish_reclaim(
  	 * us.
  	 */
  	write_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
+	spin_lock(&ip->i_inner_lock);
  	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
  	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
-		spin_unlock(&ip->i_flags_lock);
+		spin_unlock(&ip->i_inner_lock);
  		write_unlock(&pag->pag_ici_lock);
  		if (locked) {
  			xfs_ifunlock(ip);
@@ -3293,7 +3293,7 @@ xfs_finish_reclaim(
  		return 1;
  	}
  	__xfs_iflags_set(ip, XFS_IRECLAIM);
-	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&ip->i_inner_lock);
  	write_unlock(&pag->pag_ici_lock);
  	xfs_put_perag(ip->i_mount, pag);
