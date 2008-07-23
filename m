Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:46:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NKjwUO021933
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:45:58 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3DF631C396
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:46:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id xwp8iLKMvCFsiZa4 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:46:47 -0700 (PDT)
Date: Wed, 23 Jul 2008 16:46:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] XFS: remove the mount inode list
Message-ID: <20080723204645.GA8421@infradead.org>
References: <1216773673-3620-1-git-send-email-david@fromorbit.com> <1216773673-3620-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216773673-3620-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:41:13AM +1000, Dave Chinner wrote:
> Now we've removed all users of the mount inode list,
> we can kill it. This reduces the size of the xfs_inode
> by 2 pointers.

With this m_ilock can also become a spinlock.  Might not be worth
depending on how soon you want to kill m_del_inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 15:18:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 15:19:28.000000000 +0200
@@ -1554,7 +1554,7 @@ xfs_fs_fill_super(
 		goto out;
 
 	spin_lock_init(&mp->m_sb_lock);
-	mutex_init(&mp->m_ilock);
+	spin_lock_init(&mp->m_ilock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_LIST_HEAD(&mp->m_sync_list);
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-07-23 15:18:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-07-23 15:19:28.000000000 +0200
@@ -144,9 +144,9 @@ again:
 			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 			read_unlock(&pag->pag_ici_lock);
 
-			XFS_MOUNT_ILOCK(mp);
+			spin_lock(&mp->m_ilock);
 			list_del_init(&ip->i_reclaim);
-			XFS_MOUNT_IUNLOCK(mp);
+			spin_unlock(&mp->m_ilock);
 
 			goto finish_inode;
 
@@ -484,10 +484,10 @@ xfs_iextract(
 	xfs_put_perag(mp, pag);
 
 	/* Deal with the deleted inodes list */
-	XFS_MOUNT_ILOCK(mp);
+	spin_lock(&mp->m_ilock);
 	list_del_init(&ip->i_reclaim);
 	mp->m_ireclaims++;
-	XFS_MOUNT_IUNLOCK(mp);
+	spin_unlock(&mp->m_ilock);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-23 15:18:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-23 15:19:28.000000000 +0200
@@ -142,7 +142,7 @@ xfs_mount_free(
 
 	spinlock_destroy(&mp->m_ail_lock);
 	spinlock_destroy(&mp->m_sb_lock);
-	mutex_destroy(&mp->m_ilock);
+	spinlock_destroy(&mp->m_ilock);
 	mutex_destroy(&mp->m_growlock);
 	if (mp->m_quotainfo)
 		XFS_QM_DONE(mp);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-07-23 15:18:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-07-23 15:19:28.000000000 +0200
@@ -248,7 +248,7 @@ typedef struct xfs_mount {
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
 	struct list_head	m_del_inodes;	/* inodes to reclaim */
-	mutex_t			m_ilock;	/* inode list mutex */
+	spinlock_t		m_ilock;	/* synchronize m_del_inodes */
 	uint			m_ireclaims;	/* count of calls to reclaim*/
 	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_readio_blocks; /* min read size blocks */
@@ -509,9 +509,6 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
-#define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
-#define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
-
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern int	xfs_mountfs(xfs_mount_t *mp, int);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-23 15:18:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-23 15:19:28.000000000 +0200
@@ -2834,14 +2834,14 @@ xfs_reclaim(
 		xfs_mount_t	*mp = ip->i_mount;
 
 		/* Protect sync and unpin from us */
-		XFS_MOUNT_ILOCK(mp);
+		spin_lock(&mp->m_ilock);
 		spin_lock(&ip->i_flags_lock);
 		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		vn_to_inode(vp)->i_private = NULL;
 		ip->i_vnode = NULL;
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
-		XFS_MOUNT_IUNLOCK(mp);
+		spin_unlock(&mp->m_ilock);
 	}
 	return 0;
 }
@@ -2922,7 +2922,7 @@ xfs_finish_reclaim_all(
 	xfs_inode_t	*ip, *n;
 
 restart:
-	XFS_MOUNT_ILOCK(mp);
+	spin_lock(&mp->m_ilock);
 	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
 		if (noblock) {
 			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
@@ -2933,12 +2933,12 @@ restart:
 				continue;
 			}
 		}
-		XFS_MOUNT_IUNLOCK(mp);
+		spin_unlock(&mp->m_ilock);
 		if (xfs_finish_reclaim(ip, noblock, mode))
 			delay(1);
 		goto restart;
 	}
-	XFS_MOUNT_IUNLOCK(mp);
+	spin_unlock(&mp->m_ilock);
 	return 0;
 }
 
