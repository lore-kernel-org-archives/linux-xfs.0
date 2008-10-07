Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:53:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lr68j005458
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:53:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D3C44C6347
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:54:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id TxjjOyay2trzBCuH for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:54:45 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKVt-00022l-Ei
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:54:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] XFS: kill deleted inodes list
Date: Wed,  8 Oct 2008 08:54:39 +1100
Message-Id: <1223416480-7701-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416480-7701-1-git-send-email-david@fromorbit.com>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that the deleted inodes list is unused, kill it. This
also removes the i_reclaim list head from the xfs_inode, shrinking
it by two pointers.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 --
 fs/xfs/linux-2.6/xfs_sync.c  |    6 ++++++
 fs/xfs/xfs_iget.c            |    8 --------
 fs/xfs/xfs_inode.c           |    4 ++--
 fs/xfs/xfs_inode.h           |    1 -
 fs/xfs/xfs_mount.c           |    1 -
 fs/xfs/xfs_mount.h           |    5 +----
 fs/xfs/xfs_vnodeops.c        |   12 +-----------
 8 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index b893f8c..f4bf7ca 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -907,7 +907,6 @@ xfs_fs_inode_init_once(
 	atomic_set(&ip->i_iocount, 0);
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
-	INIT_LIST_HEAD(&ip->i_reclaim);
 	init_waitqueue_head(&ip->i_ipin_wait);
 	/*
 	 * Because we want to use a counting completion, complete
@@ -1549,7 +1548,6 @@ xfs_fs_fill_super(
 		goto out_free_args;
 
 	spin_lock_init(&mp->m_sb_lock);
-	mutex_init(&mp->m_ilock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_LIST_HEAD(&mp->m_sync_list);
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index bbb40e2..22006b5 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -644,6 +644,11 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+/*
+ * We set the inode flag atomically with the radix tree tag.
+ * Once we get tag lookups on the radix tree, this inode flag
+ * can go away.
+ */
 void
 xfs_inode_set_reclaim_tag(
 	xfs_inode_t	*ip)
@@ -655,6 +660,7 @@ xfs_inode_set_reclaim_tag(
 	spin_lock(&ip->i_flags_lock);
 	radix_tree_tag_set(&pag->pag_ici_root,
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index a0387f1..8001338 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -95,10 +95,6 @@ xfs_iget_cache_hit(
 		/* clear the radix tree reclaim flag as well. */
 		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
 		read_unlock(&pag->pag_ici_lock);
-
-		XFS_MOUNT_ILOCK(mp);
-		list_del_init(&ip->i_reclaim);
-		XFS_MOUNT_IUNLOCK(mp);
 	} else if (!igrab(VFS_I(ip))) {
 		/* If the VFS inode is being torn down, pause and try again. */
 		error = EAGAIN;
@@ -419,11 +415,7 @@ xfs_iextract(
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
-	/* Deal with the deleted inodes list */
-	XFS_MOUNT_ILOCK(mp);
-	list_del_init(&ip->i_reclaim);
 	mp->m_ireclaims++;
-	XFS_MOUNT_IUNLOCK(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 307a63f..456941e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -810,7 +810,7 @@ xfs_inode_alloc(
 	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(list_empty(&ip->i_reclaim));
+	ASSERT(completion_done(&ip->i_flush));
 
 	/*
 	 * initialise the VFS inode here to get failures
@@ -2732,7 +2732,7 @@ xfs_idestroy(
 	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(list_empty(&ip->i_reclaim));
+	ASSERT(completion_done(&ip->i_flush));
 	kmem_zone_free(xfs_inode_zone, ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f946b13..f02535c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -236,7 +236,6 @@ typedef struct dm_attrs_s {
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct list_head	i_reclaim;	/* reclaim list */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a230d8f..794a4e2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -582,7 +582,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	INIT_LIST_HEAD(&mp->m_del_inodes);
 
 	/*
 	 * Setup for attributes, in case they get created.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7e02a86..fc70c69 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -248,8 +248,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	struct list_head	m_del_inodes;	/* inodes to reclaim */
-	mutex_t			m_ilock;	/* inode list mutex */
 	uint			m_ireclaims;	/* count of calls to reclaim*/
 	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_readio_blocks; /* min read size blocks */
@@ -312,8 +310,7 @@ typedef struct xfs_mount {
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
-	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
-						   field governed by m_ilock */
+	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes. */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index cbde288..bfb25f7 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2810,18 +2810,8 @@ xfs_reclaim(
 		xfs_iflock(ip);
 		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
-	} else {
-		xfs_mount_t	*mp = ip->i_mount;
-
-		/* Protect sync and unpin from us */
-		XFS_MOUNT_ILOCK(mp);
-		spin_lock(&ip->i_flags_lock);
-		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		spin_unlock(&ip->i_flags_lock);
-		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
-		XFS_MOUNT_IUNLOCK(mp);
-		xfs_inode_set_reclaim_tag(ip);
 	}
+	xfs_inode_set_reclaim_tag(ip);
 	return 0;
 }
 
-- 
1.5.6.5
