Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:02:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE2MPb015216
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:02:22 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA639126BF58
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:51 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id WdFC2aLrT55ABwi9 for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:51 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVj1-0007gE-E5
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:03:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] XFS: Make use of the init-once slab optimisation.
Date: Sun, 14 Sep 2008 00:03:46 +1000
Message-Id: <1221314627-29065-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314627-29065-1-git-send-email-david@fromorbit.com>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To avoid having to initialise some fields of the XFS inode
on every allocation, we can use the slab init-once feature
to initialise them. All we have to guarantee is that when
we free the inode, all it's entries are in the initial state.
Add asserts where possible to ensure debug kernels check this
initial state before freeing and after allocation.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   38 +++++++++++++++++++++++-
 fs/xfs/xfs_iget.c            |   14 ---------
 fs/xfs/xfs_inode.c           |   66 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h           |    1 +
 fs/xfs/xfs_itable.c          |   14 ++++----
 5 files changed, 99 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 4d9b848..c789950 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -888,6 +888,42 @@ xfs_fs_inode_init_once(
 	inode_init_once((struct inode *)vnode);
 }
 
+
+/*
+ * Slab object creation initialisation for the XFS inode.
+ * This covers only the idempotent fields in the XFS inode;
+ * all other fields need to be initialised on allocation
+ * from the slab. This avoids the need to repeatedly intialise
+ * fields in the xfs inode that left in the initialise state
+ * when freeing the inode.
+ */
+void
+xfs_inode_init_once(
+	void			*inode)
+{
+	struct xfs_inode	*ip = inode;
+
+	memset(ip, 0, sizeof(struct xfs_inode));
+	atomic_set(&ip->i_iocount, 0);
+	atomic_set(&ip->i_pincount, 0);
+	spin_lock_init(&ip->i_flags_lock);
+	INIT_LIST_HEAD(&ip->i_reclaim);
+	init_waitqueue_head(&ip->i_ipin_wait);
+
+	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
+		     "xfsino", ip->i_ino);
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+
+	/*
+	 * Because we want to use a counting completion, complete
+	 * the flush completion once to allow a single access to
+	 * the flush completion without blocking.
+	 */
+	init_completion(&ip->i_flush);
+	complete(&ip->i_flush);
+
+}
+
 /*
  * Attempt to flush the inode, this will actually fail
  * if the inode is pinned, but we dirty the inode again
@@ -1841,7 +1877,7 @@ xfs_init_zones(void)
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
 					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD, NULL);
+					KM_ZONE_SPREAD, xfs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 3b6d35e..12fe37e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -165,20 +165,6 @@ xfs_iget_cache_miss(
 
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-	init_waitqueue_head(&ip->i_ipin_wait);
-	atomic_set(&ip->i_pincount, 0);
-
-	/*
-	 * Because we want to use a counting completion, complete
-	 * the flush completion once to allow a single access to
-	 * the flush completion without blocking.
-	 */
-	init_completion(&ip->i_flush);
-	complete(&ip->i_flush);
-
 	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 98361bb..7c9d0a7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -788,6 +788,49 @@ xfs_dic2xflags(
 }
 
 /*
+ * Allocate and initialise an xfs_inode.
+ */
+struct xfs_inode *
+xfs_inode_alloc(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+
+	/*
+	 * if this didn't occur in transactions, we could use
+	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
+	 * code up to do this anyway.
+	 */
+	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
+	if (!ip)
+		return NULL;
+
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(list_empty(&ip->i_reclaim));
+	ASSERT(completion_done(&ip->i_flush));
+
+	ip->i_ino = ino;
+	ip->i_mount = mp;
+	ip->i_blkno = 0;
+	ip->i_len = 0;
+	ip->i_boffset =0;
+	ip->i_afp = NULL;
+	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
+	ip->i_flags = 0;
+	ip->i_update_core = 0;
+	ip->i_update_size = 0;
+	ip->i_delayed_blks = 0;
+	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	ip->i_size = 0;
+	ip->i_new_size = 0;
+
+	return ip;
+}
+
+/*
  * Given a mount structure and an inode number, return a pointer
  * to a newly allocated in-core inode corresponding to the given
  * inode number.
@@ -809,13 +852,9 @@ xfs_iread(
 	xfs_inode_t	*ip;
 	int		error;
 
-	ASSERT(xfs_inode_zone != NULL);
-
-	ip = kmem_zone_zalloc(xfs_inode_zone, KM_SLEEP);
-	ip->i_ino = ino;
-	ip->i_mount = mp;
-	atomic_set(&ip->i_iocount, 0);
-	spin_lock_init(&ip->i_flags_lock);
+	ip = xfs_inode_alloc(mp, ino);
+	if (!ip)
+		return ENOMEM;
 
 	/*
 	 * Get pointer's to the on-disk inode and the buffer containing it.
@@ -911,8 +950,6 @@ xfs_iread(
 			XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	}
 
-	INIT_LIST_HEAD(&ip->i_reclaim);
-
 	/*
 	 * The inode format changed when we moved the link count and
 	 * made it 32 bits long.  If this is an old format inode,
@@ -2631,8 +2668,6 @@ xfs_idestroy(
 	}
 	if (ip->i_afp)
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-	mrfree(&ip->i_lock);
-	mrfree(&ip->i_iolock);
 
 #ifdef XFS_INODE_TRACE
 	ktrace_free(ip->i_trace);
@@ -2671,7 +2706,14 @@ xfs_idestroy(
 				spin_unlock(&mp->m_ail_lock);
 		}
 		xfs_inode_item_destroy(ip);
+		ip->i_itemp = NULL;
 	}
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(list_empty(&ip->i_reclaim));
+	ASSERT(completion_done(&ip->i_flush));
 	kmem_zone_free(xfs_inode_zone, ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7b50eb4..813c9b0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -504,6 +504,7 @@ int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 
+struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
 void		xfs_idestroy_fork(xfs_inode_t *, int);
 void		xfs_idestroy(xfs_inode_t *);
 void		xfs_idata_realloc(xfs_inode_t *, int, int);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cf6754a..4f4c939 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -594,21 +594,21 @@ xfs_bulkstat(
 						/*
 						 * Get the inode cluster buffer
 						 */
-						ASSERT(xfs_inode_zone != NULL);
-						ip = kmem_zone_zalloc(xfs_inode_zone,
-								      KM_SLEEP);
-						ip->i_ino = ino;
-						ip->i_mount = mp;
-						spin_lock_init(&ip->i_flags_lock);
 						if (bp)
 							xfs_buf_relse(bp);
+						ip = xfs_inode_alloc(mp, ino);
+						if (!ip) {
+							bp = NULL;
+							rval = ENOMEM;
+							break;
+						}
 						error = xfs_itobp(mp, NULL, ip,
 								&dip, &bp, bno,
 								XFS_IMAP_BULKSTAT,
 								XFS_BUF_LOCK);
 						if (!error)
 							clustidx = ip->i_boffset / mp->m_sb.sb_inodesize;
-						kmem_zone_free(xfs_inode_zone, ip);
+						xfs_idestroy(ip);
 						if (XFS_TEST_ERROR(error != 0,
 								   mp, XFS_ERRTAG_BULKSTAT_READ_CHUNK,
 								   XFS_RANDOM_BULKSTAT_READ_CHUNK)) {
-- 
1.5.6
