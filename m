Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 16:11:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78NBkbm012697
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 16:11:48 -0700
Date: Thu, 9 Aug 2007 09:11:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 3 of 4] Remove the cluster hash lists
Message-ID: <20070808231143.GR12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Remove the cluster hash lists and replace with lookups into
the new radix tree. This removes scalability limitations inherent
in the cluster hash sizing algorithms.

We can do this due to the fact that all inodes in a cluster have
sequential numbers and have a defined alignment. This means we can mask
out the inode number within the cluster to give us the cluster address
that the inode belongs to.

We can then do a gang lookup on the radix tree to find out if there is
already an existing cached inode in the cluster. if there is, then
we can obtain the cluster object from the existing cached inode.
If there isn't we simply allocate a new one and attach it to the
inode we are inserting into the radix tree.

Signed-off-by: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_ksyms.c |    2 
 fs/xfs/xfs_iget.c            |  201 +++++++++++++------------------------------
 fs/xfs/xfs_inode.c           |   11 +-
 fs/xfs/xfs_inode.h           |   32 ++----
 fs/xfs/xfs_mount.c           |    4 
 fs/xfs/xfs_vfsops.c          |    8 -
 fs/xfs/xfsidbg.c             |   96 --------------------
 7 files changed, 84 insertions(+), 270 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-07-23 11:11:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-07-23 11:13:19.414234814 +1000
@@ -80,40 +80,6 @@ xfs_ihash_free(xfs_mount_t *mp)
 }
 
 /*
- * Initialize the inode cluster hash table for the newly mounted file system.
- * Its size is derived from the ihash table size.
- */
-void
-xfs_chash_init(xfs_mount_t *mp)
-{
-	uint	i;
-
-	mp->m_chsize = mp->m_ihsize * 2049;
-	mp->m_chash = (xfs_chash_t *)kmem_zalloc(mp->m_chsize
-						 * sizeof(xfs_chash_t),
-						 KM_SLEEP | KM_LARGE);
-	for (i = 0; i < mp->m_chsize; i++) {
-		spinlock_init(&mp->m_chash[i].ch_lock,"xfshash");
-	}
-}
-
-/*
- * Free up structures allocated by xfs_chash_init, at unmount time.
- */
-void
-xfs_chash_free(xfs_mount_t *mp)
-{
-	int	i;
-
-	for (i = 0; i < mp->m_chsize; i++) {
-		spinlock_destroy(&mp->m_chash[i].ch_lock);
-	}
-
-	kmem_free(mp->m_chash, mp->m_chsize*sizeof(xfs_chash_t));
-	mp->m_chash = NULL;
-}
-
-/*
  * Look up an inode by number in the given file system.
  * The inode is looked up in the hash table for the file system
  * represented by the mount point parameter mp.  Each bucket of
@@ -161,10 +127,8 @@ xfs_iget_core(
 	bhv_vnode_t	*inode_vp;
 	ulong		version;
 	int		error;
-	/* REFERENCED */
-	xfs_chash_t	*ch;
-	xfs_chashlist_t	*chl, *chlnew;
-	SPLDECL(s);
+	xfs_icluster_t	*icl, *new_icl = NULL;
+	unsigned long	first_index, mask;
 
 
 	ih = XFS_IHASH(mp, ino);
@@ -325,15 +289,31 @@ finish_inode:
 	}
 
 	/*
-	 * Put ip on its hash chain, unless someone else hashed a duplicate
-	 * after we released the hash lock.
+	 * This is a bit messy - we preallocate everything we _might_
+	 * need before we pick up the hash lock. That way we donnn't have to
+	 * juggle locks and go all the way back to the start.
 	 */
+	new_icl = (xfs_icluster_t *)kmem_zone_alloc(xfs_icluster_zone, KM_SLEEP);
 	if (radix_tree_preload(GFP_KERNEL)) {
 		delay(1);
 		goto again;
 	}
+	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
+	first_index = ino & mask;
 	write_lock(&ih->ih_lock);
 
+	/*
+	 * Find the cluster if it exists
+	 */
+	icl = NULL;
+	if (radix_tree_gang_lookup(&ih->ih_root, (void**)&iq, first_index, 1)) {
+		if ((iq->i_ino & mask) == first_index)
+			icl = iq->i_cluster;
+	}
+
+	/*
+	 * insert the new inode
+	 */
 	error = radix_tree_insert(&ih->ih_root, (unsigned long)ino, (void *)ip);
 	if (unlikely(error)) {
 		BUG_ON(error != -EEXIST);
@@ -352,76 +332,36 @@ finish_inode:
 	ip->i_udquot = ip->i_gdquot = NULL;
 	ih->ih_version++;
 	xfs_iflags_set(ip, XFS_INEW);
-	write_unlock(&ih->ih_lock);
-	radix_tree_preload_end();
 
-	/*
-	 * put ip on its cluster's hash chain
-	 */
-	ASSERT(ip->i_chash == NULL && ip->i_cprev == NULL &&
+	ASSERT(ip->i_cluster == NULL && ip->i_cprev == NULL &&
 	       ip->i_cnext == NULL);
 
-	chlnew = NULL;
-	ch = XFS_CHASH(mp, ip->i_blkno);
- chlredo:
-	s = mutex_spinlock(&ch->ch_lock);
-	for (chl = ch->ch_list; chl != NULL; chl = chl->chl_next) {
-		if (chl->chl_blkno == ip->i_blkno) {
-
-			/* insert this inode into the doubly-linked list
-			 * where chl points. lock the chl to protect against
-			 * others traversing the chl list */
-			spin_lock(&chl->chl_lock);
-			if ((iq = chl->chl_ip)) {
-				ip->i_cprev = iq->i_cprev;
-				iq->i_cprev->i_cnext = ip;
-				iq->i_cprev = ip;
-				ip->i_cnext = iq;
-			} else {
-				ip->i_cnext = ip;
-				ip->i_cprev = ip;
-			}
-			chl->chl_ip = ip;
-			ip->i_chash = chl;
-			spin_unlock(&chl->chl_lock);
-			break;
-		}
-	}
-
-	/* no hash list found for this block; add a new hash list */
-	if (chl == NULL)  {
-		if (chlnew == NULL) {
-			mutex_spinunlock(&ch->ch_lock, s);
-			ASSERT(xfs_chashlist_zone != NULL);
-			chlnew = (xfs_chashlist_t *)
-					kmem_zone_alloc(xfs_chashlist_zone,
-						KM_SLEEP);
-			ASSERT(chlnew != NULL);
-			spin_lock_init(&chlnew->chl_lock);
-			goto chlredo;
-		} else {
-			/* exclusive access to this chl thanks to the ch_lock
-			 * in write mode, so no lock really needed */
-			ip->i_cnext = ip;
-			ip->i_cprev = ip;
-			ip->i_chash = chlnew;
-			chlnew->chl_ip = ip;
-			chlnew->chl_blkno = ip->i_blkno;
-			if (ch->ch_list)
-				ch->ch_list->chl_prev = chlnew;
-			chlnew->chl_next = ch->ch_list;
-			chlnew->chl_prev = NULL;
-			ch->ch_list = chlnew;
-			chlnew = NULL;
-		}
+	if (icl) {
+		/* insert this inode into the doubly-linked list
+		 * where icl points. lock the icl to protect against
+		 * others traversing the icl list */
+		spin_lock(&icl->icl_lock);
+		ASSERT(icl->icl_ip != NULL);
+		iq = icl->icl_ip;
+		ip->i_cprev = iq->i_cprev;
+		iq->i_cprev->i_cnext = ip;
+		iq->i_cprev = ip;
+		ip->i_cnext = iq;
+		icl->icl_ip = ip;
+		ip->i_cluster = icl;
+		spin_unlock(&icl->icl_lock);
 	} else {
-		if (chlnew != NULL) {
-			kmem_zone_free(xfs_chashlist_zone, chlnew);
-		}
+		ip->i_cnext = ip;
+		ip->i_cprev = ip;
+		ip->i_cluster = new_icl;
+		new_icl->icl_ip = ip;
+		spin_lock_init(&new_icl->icl_lock);
+		new_icl = NULL;
 	}
-
-	mutex_spinunlock(&ch->ch_lock, s);
-
+	write_unlock(&ih->ih_lock);
+	radix_tree_preload_end();
+	if (new_icl)
+		kmem_zone_free(xfs_icluster_zone, new_icl);
 
 	/*
 	 * Link ip to its mount and thread it on the mount's inode list.
@@ -669,9 +609,6 @@ xfs_iextract(
 	xfs_ihash_t	*ih;
 	xfs_inode_t	*iq;
 	xfs_mount_t	*mp;
-	xfs_chash_t	*ch;
-	xfs_chashlist_t *chl, *chm;
-	SPLDECL(s);
 
 	ih = ip->i_hash;
 	write_lock(&ih->ih_lock);
@@ -680,48 +617,34 @@ xfs_iextract(
 	write_unlock(&ih->ih_lock);
 
 	/*
-	 * Remove from cluster hash list
-	 *   1) delete the chashlist if this is the last inode on the chashlist
-	 *   2) unchain from list of inodes
-	 *   3) point chashlist->chl_ip to 'chl_next' if to this inode.
+	 * Remove from cluster list
 	 */
 	mp = ip->i_mount;
-	ch = XFS_CHASH(mp, ip->i_blkno);
-	spin_lock(&ip->i_chash->chl_lock);
+	spin_lock(&ip->i_cluster->icl_lock);
 	if (unlikely(ip->i_cnext == ip)) {
-		/* Last inode on chashlist */
+		/*
+		 * Last inode in cluster object.
+		 *
+		 * We've been removed from the inode radix tree, and
+		 * we are the last inode to reference the cluster.
+		 * We can simply drop our loks and free it at this point
+		 * because nothing can find us or the cluster.
+		 */
 		ASSERT(ip->i_cnext == ip && ip->i_cprev == ip);
-		ASSERT(ip->i_chash != NULL);
-		chm=NULL;
+		ASSERT(ip->i_cluster != NULL);
 
-		spin_unlock(&ip->i_chash->chl_lock);
-		spin_lock(&ch->ch_lock);
-		spin_lock(&ip->i_chash->chl_lock);
-		if (ip->i_cnext != ip) {
-			spin_unlock(&ch->ch_lock);
-			goto delete;
-		}
-		spin_unlock(&ip->i_chash->chl_lock);
-		chl = ip->i_chash;
-		if (chl->chl_prev)
-			chl->chl_prev->chl_next = chl->chl_next;
-		else
-			ch->ch_list = chl->chl_next;
-		if (chl->chl_next)
-			chl->chl_next->chl_prev = chl->chl_prev;
-		spin_unlock(&ch->ch_lock);
-		kmem_zone_free(xfs_chashlist_zone, chl);
+		spin_unlock(&ip->i_cluster->icl_lock);
+		kmem_zone_free(xfs_icluster_zone, ip->i_cluster);
 	} else {
 		/* delete one inode from a non-empty list */
-delete:
 		iq = ip->i_cnext;
 		iq->i_cprev = ip->i_cprev;
 		ip->i_cprev->i_cnext = iq;
-		if (ip->i_chash->chl_ip == ip) {
-			ip->i_chash->chl_ip = iq;
+		if (ip->i_cluster->icl_ip == ip) {
+			ip->i_cluster->icl_ip = iq;
 		}
-		spin_unlock(&ip->i_chash->chl_lock);
-		ip->i_chash = __return_address;
+		spin_unlock(&ip->i_cluster->icl_lock);
+		ip->i_cluster = __return_address;
 		ip->i_cprev = __return_address;
 		ip->i_cnext = __return_address;
 	}
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-07-23 11:11:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-07-23 11:13:19.414234814 +1000
@@ -187,23 +187,13 @@ typedef struct xfs_ihash {
  * find inodes that share a cluster and can be flushed to disk at the same
  * time.
  */
-typedef struct xfs_chashlist {
-	struct xfs_chashlist	*chl_next;
-	struct xfs_chashlist	*chl_prev;
-	struct xfs_inode	*chl_ip;
-	xfs_daddr_t		chl_blkno;	/* starting block number of
+typedef struct xfs_icluster {
+	struct xfs_inode	*icl_ip;
+	xfs_daddr_t		icl_blkno;	/* starting block number of
 						 * the cluster */
-	struct xfs_buf		*chl_buf;	/* the inode buffer */
-	lock_t			chl_lock;	/* inode list lock */
-} xfs_chashlist_t;
-
-typedef struct xfs_chash {
-	xfs_chashlist_t		*ch_list;
-	lock_t			ch_lock;
-} xfs_chash_t;
-
-#define XFS_CHASH(mp,blk) ((mp)->m_chash + (((uint)blk) % (mp)->m_chsize))
-
+	struct xfs_buf		*icl_buf;	/* the inode buffer */
+	lock_t			icl_lock;	/* inode list lock */
+} xfs_icluster_t;
 
 /*
  * This is the xfs in-core inode structure.
@@ -280,9 +270,9 @@ typedef struct xfs_inode {
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
-	xfs_chashlist_t		*i_chash;	/* cluster hash list header */
-	struct xfs_inode	*i_cnext;	/* cluster hash link forward */
-	struct xfs_inode	*i_cprev;	/* cluster hash link backward */
+	xfs_icluster_t		*i_cluster;	/* cluster list header */
+	struct xfs_inode	*i_cnext;	/* cluster link forward */
+	struct xfs_inode	*i_cprev;	/* cluster link backward */
 
 	xfs_fsize_t		i_size;		/* in-memory size */
 	/* Trace buffers per inode. */
@@ -477,8 +467,6 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
  */
 void		xfs_ihash_init(struct xfs_mount *);
 void		xfs_ihash_free(struct xfs_mount *);
-void		xfs_chash_init(struct xfs_mount *);
-void		xfs_chash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
 void            xfs_inode_lock_init(xfs_inode_t *, struct bhv_vnode *);
@@ -589,7 +577,7 @@ void		xfs_inobp_check(struct xfs_mount *
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern struct kmem_zone	*xfs_chashlist_zone;
+extern struct kmem_zone	*xfs_icluster_zone;
 extern struct kmem_zone	*xfs_ifork_zone;
 extern struct kmem_zone	*xfs_inode_zone;
 extern struct kmem_zone	*xfs_ili_zone;
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-23 11:11:02.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-23 11:13:19.426233246 +1000
@@ -233,7 +233,7 @@ EXPORT_SYMBOL(xfs_bulkstat);
 EXPORT_SYMBOL(xfs_bunmapi);
 EXPORT_SYMBOL(xfs_bwrite);
 EXPORT_SYMBOL(xfs_change_file_space);
-EXPORT_SYMBOL(xfs_chashlist_zone);
+EXPORT_SYMBOL(xfs_icluster_zone);
 EXPORT_SYMBOL(xfs_dev_is_read_only);
 EXPORT_SYMBOL(xfs_dir_getdents);
 EXPORT_SYMBOL(xfs_dir_ialloc);
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-07-23 11:11:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-07-23 11:13:19.430232723 +1000
@@ -52,7 +52,7 @@
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
-kmem_zone_t *xfs_chashlist_zone;
+kmem_zone_t *xfs_icluster_zone;
 
 /*
  * Used in xfs_itruncate().  This is the maximum number of extents
@@ -3051,7 +3051,6 @@ xfs_iflush(
 	int			clcount;	/* count of inodes clustered */
 	int			bufwasdelwri;
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
-	SPLDECL(s);
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -3165,8 +3164,8 @@ xfs_iflush(
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
-	spin_lock(&ip->i_chash->chl_lock);
-	ip->i_chash->chl_buf = bp;
+	spin_lock(&ip->i_cluster->icl_lock);
+	ip->i_cluster->icl_buf = bp;
 
 	clcount = 0;
 	for (iq = ip->i_cnext; iq != ip; iq = iq->i_cnext) {
@@ -3220,7 +3219,7 @@ xfs_iflush(
 			xfs_iunlock(iq, XFS_ILOCK_SHARED);
 		}
 	}
-	spin_unlock(&ip->i_chash->chl_lock);
+	spin_unlock(&ip->i_cluster->icl_lock);
 
 	if (clcount) {
 		XFS_STATS_INC(xs_icluster_flushcnt);
@@ -3257,7 +3256,7 @@ cluster_corrupt_out:
 	/* Corruption detected in the clustering loop.  Invalidate the
 	 * inode buffer and shut down the filesystem.
 	 */
-	spin_unlock(&ip->i_chash->chl_lock);
+	spin_unlock(&ip->i_cluster->icl_lock);
 
 	/*
 	 * Clean up the buffer.  If it was B_DELWRI, just release it --
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-07-23 11:09:52.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-07-23 11:13:19.430232723 +1000
@@ -117,8 +117,8 @@ xfs_init(void)
 	xfs_ili_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
 					KM_ZONE_SPREAD, NULL);
-	xfs_chashlist_zone =
-		kmem_zone_init_flags(sizeof(xfs_chashlist_t), "xfs_chashlist",
+	xfs_icluster_zone =
+		kmem_zone_init_flags(sizeof(xfs_icluster_t), "xfs_icluster",
 					KM_ZONE_SPREAD, NULL);
 
 	/*
@@ -163,7 +163,7 @@ xfs_cleanup(void)
 	extern kmem_zone_t	*xfs_efd_zone;
 	extern kmem_zone_t	*xfs_efi_zone;
 	extern kmem_zone_t	*xfs_buf_item_zone;
-	extern kmem_zone_t	*xfs_chashlist_zone;
+	extern kmem_zone_t	*xfs_icluster_zone;
 
 	xfs_cleanup_procfs();
 	xfs_sysctl_unregister();
@@ -199,7 +199,7 @@ xfs_cleanup(void)
 	kmem_zone_destroy(xfs_efi_zone);
 	kmem_zone_destroy(xfs_ifork_zone);
 	kmem_zone_destroy(xfs_ili_zone);
-	kmem_zone_destroy(xfs_chashlist_zone);
+	kmem_zone_destroy(xfs_icluster_zone);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-07-23 11:11:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-07-23 11:13:19.434232200 +1000
@@ -135,8 +135,6 @@ static void	xfsidbg_xbuf(xfs_buf_t *);
 static void	xfsidbg_xbuf_real(xfs_buf_t *, int);
 static void	xfsidbg_xarg(int);
 static void	xfsidbg_xchksum(uint *);
-static void	xfsidbg_xchash(xfs_mount_t *mp);
-static void	xfsidbg_xchashlist(xfs_chashlist_t *chl);
 static void	xfsidbg_xdaargs(xfs_da_args_t *);
 static void	xfsidbg_xdabuf(xfs_dabuf_t *);
 static void	xfsidbg_xdanode(xfs_da_intnode_t *);
@@ -1020,46 +1018,6 @@ static int	kdbm_xfs_xchksum(
 	return 0;
 }
 
-
-static int	kdbm_xfs_xchash(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	xfsidbg_xchash((xfs_mount_t *) addr);
-	return 0;
-}
-
-static int	kdbm_xfs_xchashlist(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	xfsidbg_xchashlist((xfs_chashlist_t *) addr);
-	return 0;
-}
-
-
 static int	kdbm_xfs_xdaargs(
 	int	argc,
 	const char **argv)
@@ -2670,10 +2628,6 @@ static struct xif xfsidbg_funcs[] = {
   {  "xbxstrc",	kdbm_xfs_xbxstrace,	"<xfs_inode_t>",
 				"Dump XFS bmap extent inode trace" },
 #endif
-  {  "xchash",	kdbm_xfs_xchash,	"<xfs_mount_t>",
-				"Dump XFS cluster hash"},
-  {  "xchlist",	kdbm_xfs_xchashlist,	"<xfs_chashlist_t>",
-				"Dump XFS cluster hash list"},
   {  "xchksum",	kdbm_xfs_xchksum,	"<addr>", "Dump chksum" },
 #ifdef XFS_DIR2_TRACE
   {  "xd2atrc",	kdbm_xfs_xdir2atrace,	"<count>",
@@ -6756,8 +6710,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		(xfs_dfiloff_t)mp->m_dirdatablk,
 		(xfs_dfiloff_t)mp->m_dirleafblk,
 		(xfs_dfiloff_t)mp->m_dirfreeblk);
-	kdb_printf("chsize %d chash 0x%p\n",
-		mp->m_chsize, mp->m_chash);
 	if (mp->m_fsname != NULL)
 		kdb_printf("mountpoint \"%s\"\n", mp->m_fsname);
 	else
@@ -6898,8 +6850,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	qprintf(" dir trace 0x%p\n", ip->i_dir_trace);
 #endif  
 	kdb_printf("\n");
-	kdb_printf("chash 0x%p cnext 0x%p cprev 0x%p\n",
-		ip->i_chash,
+	kdb_printf("icluster 0x%p cnext 0x%p cprev 0x%p\n",
+		ip->i_cluster,
 		ip->i_cnext,
 		ip->i_cprev);
 	xfs_xnode_fork("data", &ip->i_df);
@@ -6917,50 +6869,6 @@ xfsidbg_xcore(xfs_iocore_t *io)
 }
 
 /*
- * Command to print xfs inode cluster hash table: kp xchash <addr>
- */
-static void
-xfsidbg_xchash(xfs_mount_t *mp)
-{
-	int		i;
-	xfs_chash_t	*ch;
-
-	kdb_printf("m_chash 0x%p size %d\n",
-		mp->m_chash, mp->m_chsize);
-	for (i = 0; i < mp->m_chsize; i++) {
-		ch = mp->m_chash + i;
-		kdb_printf("[%3d] ch 0x%p chashlist 0x%p\n", i, ch, ch->ch_list);
-		xfsidbg_xchashlist(ch->ch_list);
-	}
-}
-
-/*
- * Command to print xfs inode cluster hash list: kp xchashlist <addr>
- */
-static void
-xfsidbg_xchashlist(xfs_chashlist_t *chl)
-{
-	xfs_inode_t	*ip;
-
-	while (chl != NULL) {
-		kdb_printf("hashlist inode 0x%p blkno %lld buf 0x%p",
-		       chl->chl_ip, (long long) chl->chl_blkno, chl->chl_buf);
-
-		kdb_printf("\n");
-
-		/* print inodes on chashlist */
-		ip = chl->chl_ip;
-		do {
-			kdb_printf("0x%p ", ip);
-			ip = ip->i_cnext;
-		} while (ip != chl->chl_ip);
-		kdb_printf("\n");
-
-		chl=chl->chl_next;
-	}
-}
-
-/*
  * Print xfs per-ag data structures for filesystem.
  */
 static void
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-07-23 11:11:02.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-07-23 11:13:19.438231678 +1000
@@ -162,8 +162,6 @@ xfs_mount_free(
 {
 	if (mp->m_ihash)
 		xfs_ihash_free(mp);
-	if (mp->m_chash)
-		xfs_chash_free(mp);
 
 	if (mp->m_perag) {
 		int	agno;
@@ -1037,7 +1035,6 @@ xfs_mountfs(
 	 * file system.
 	 */
 	xfs_ihash_init(mp);
-	xfs_chash_init(mp);
 
 	/*
 	 * Allocate and initialize the per-ag data.
@@ -1191,7 +1188,6 @@ xfs_mountfs(
 	xfs_log_unmount_dealloc(mp);
  error2:
 	xfs_ihash_free(mp);
-	xfs_chash_free(mp);
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
 		if (mp->m_perag[agno].pagb_list)
 			kmem_free(mp->m_perag[agno].pagb_list,
