Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 23:09:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9369XaG000380
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 23:09:35 -0700
Date: Tue, 3 Oct 2006 16:08:45 +1000
From: David Chinner <dgc@sgi.com>
Subject: [RFC 1/3] Convert inode hash to radix tree
Message-ID: <20061003060845.GW3024@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com


Convert the inode cache hash to a radix tree.

A radix tree has been chosen to replace the hash because of a
neat alignment of XFS inode structures and the kernel radix tree
fanout. XFS allocates inodes in clusters of 64 inodes and the
radix tree keeps 64 sequential entries per node. That means all
fo the inodes in a cluster will always sit in the same node of
the radix tree.

A single radix tree with a read/write lock does not provide enough
parallelism to prevent performance regressions on multi-processor
machines, so we hash the inode clusters into different radix trees
each with their own read/write lock.  The default is to create
(2*ncpus)-1 radix trees up to a maximum of 15. The ihashsize mount
option is still present, but it's mostly irrelevant now.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_iget.c  |  260 ++++++++++++++++++++---------------------------------
 fs/xfs/xfs_inode.c |    5 -
 fs/xfs/xfs_inode.h |    8 -
 fs/xfs/xfsidbg.c   |    6 -
 4 files changed, 105 insertions(+), 174 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2006-09-14 12:51:10.204651011 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2006-09-18 12:02:31.027726925 +1000
@@ -49,25 +49,24 @@
 void
 xfs_ihash_init(xfs_mount_t *mp)
 {
-	__uint64_t	icount;
 	uint		i;
 
-	if (!mp->m_ihsize) {
-		icount = mp->m_maxicount ? mp->m_maxicount :
-			 (mp->m_sb.sb_dblocks << mp->m_sb.sb_inopblog);
-		mp->m_ihsize = 1 << max_t(uint, 8,
-					(xfs_highbit64(icount) + 1) / 2);
-		mp->m_ihsize = min_t(uint, mp->m_ihsize,
-					(64 * NBPP) / sizeof(xfs_ihash_t));
+	if (!mp->m_ihsize || mp->m_ihsize > 128) {
+		/* default to (2*cpus) - 1 or 15. */
+		mp->m_ihsize = (2 * num_online_cpus()) - 1;
+		mp->m_ihsize = min(15, mp->m_ihsize);
+		printk("mp->m_ihsize %d\n", mp->m_ihsize);
 	}
 
-	mp->m_ihash = kmem_zalloc_greedy(&mp->m_ihsize,
+	mp->m_ihash = kmem_zalloc_greedy((size_t *)&mp->m_ihsize,
 					 NBPC * sizeof(xfs_ihash_t),
 					 mp->m_ihsize * sizeof(xfs_ihash_t),
 					 KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	mp->m_ihsize /= sizeof(xfs_ihash_t);
-	for (i = 0; i < mp->m_ihsize; i++)
+	for (i = 0; i < mp->m_ihsize; i++) {
 		rwlock_init(&(mp->m_ihash[i].ih_lock));
+		INIT_RADIX_TREE(&(mp->m_ihash[i].ih_root), GFP_ATOMIC);
+	}
 }
 
 /*
@@ -89,9 +88,7 @@ xfs_chash_init(xfs_mount_t *mp)
 {
 	uint	i;
 
-	mp->m_chsize = max_t(uint, 1, mp->m_ihsize /
-			 (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog));
-	mp->m_chsize = min_t(uint, mp->m_chsize, mp->m_ihsize);
+	mp->m_chsize = mp->m_ihsize * 2049;
 	mp->m_chash = (xfs_chash_t *)kmem_zalloc(mp->m_chsize
 						 * sizeof(xfs_chash_t),
 						 KM_SLEEP | KM_LARGE);
@@ -117,40 +114,6 @@ xfs_chash_free(xfs_mount_t *mp)
 }
 
 /*
- * Try to move an inode to the front of its hash list if possible
- * (and if its not there already).  Called right after obtaining
- * the list version number and then dropping the read_lock on the
- * hash list in question (which is done right after looking up the
- * inode in question...).
- */
-STATIC void
-xfs_ihash_promote(
-	xfs_ihash_t	*ih,
-	xfs_inode_t	*ip,
-	ulong		version)
-{
-	xfs_inode_t	*iq;
-
-	if ((ip->i_prevp != &ih->ih_next) && write_trylock(&ih->ih_lock)) {
-		if (likely(version == ih->ih_version)) {
-			/* remove from list */
-			if ((iq = ip->i_next)) {
-				iq->i_prevp = ip->i_prevp;
-			}
-			*ip->i_prevp = iq;
-
-			/* insert at list head */
-			iq = ih->ih_next;
-			iq->i_prevp = &ip->i_next;
-			ip->i_next = iq;
-			ip->i_prevp = &ih->ih_next;
-			ih->ih_next = ip;
-		}
-		write_unlock(&ih->ih_lock);
-	}
-}
-
-/*
  * Look up an inode by number in the given file system.
  * The inode is looked up in the hash table for the file system
  * represented by the mount point parameter mp.  Each bucket of
@@ -209,110 +172,104 @@ xfs_iget_core(
 again:
 	read_lock(&ih->ih_lock);
 
-	for (ip = ih->ih_next; ip != NULL; ip = ip->i_next) {
-		if (ip->i_ino == ino) {
+	ip = (xfs_inode_t *)radix_tree_lookup(&ih->ih_root, (unsigned long)ino);
+	if (ip != NULL) {
+		/*
+		 * If INEW is set this inode is being set up
+		 * we need to pause and try again.
+		 */
+		if (xfs_iflags_test(ip, XFS_INEW)) {
+			read_unlock(&ih->ih_lock);
+			delay(1);
+			XFS_STATS_INC(xs_ig_frecycle);
+
+			goto again;
+		}
+
+		inode_vp = XFS_ITOV_NULL(ip);
+		if (inode_vp == NULL) {
 			/*
-			 * If INEW is set this inode is being set up
+			 * If IRECLAIM is set this inode is
+			 * on its way out of the system,
 			 * we need to pause and try again.
 			 */
-			if (xfs_iflags_test(ip, XFS_INEW)) {
+			if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
 				read_unlock(&ih->ih_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
 
 				goto again;
 			}
+			vn_trace_exit(vp, "xfs_iget.alloc",
+				(inst_t *)__return_address);
 
-			inode_vp = XFS_ITOV_NULL(ip);
-			if (inode_vp == NULL) {
-				/*
-				 * If IRECLAIM is set this inode is
-				 * on its way out of the system,
-				 * we need to pause and try again.
-				 */
-				if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-					read_unlock(&ih->ih_lock);
-					delay(1);
-					XFS_STATS_INC(xs_ig_frecycle);
+			XFS_STATS_INC(xs_ig_found);
 
-					goto again;
-				}
+			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
+			version = ih->ih_version;
+			read_unlock(&ih->ih_lock);
 
-				vn_trace_exit(vp, "xfs_iget.alloc",
-					(inst_t *)__return_address);
+			XFS_MOUNT_ILOCK(mp);
+			list_del_init(&ip->i_reclaim);
+			XFS_MOUNT_IUNLOCK(mp);
 
-				XFS_STATS_INC(xs_ig_found);
+			goto finish_inode;
 
-				xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-				version = ih->ih_version;
-				read_unlock(&ih->ih_lock);
-				xfs_ihash_promote(ih, ip, version);
+		} else if (vp != inode_vp) {
+			struct inode *inode = vn_to_inode(inode_vp);
 
-				XFS_MOUNT_ILOCK(mp);
-				list_del_init(&ip->i_reclaim);
-				XFS_MOUNT_IUNLOCK(mp);
-
-				goto finish_inode;
-
-			} else if (vp != inode_vp) {
-				struct inode *inode = vn_to_inode(inode_vp);
-
-				/* The inode is being torn down, pause and
-				 * try again.
-				 */
-				if (inode->i_state & (I_FREEING | I_CLEAR)) {
-					read_unlock(&ih->ih_lock);
-					delay(1);
-					XFS_STATS_INC(xs_ig_frecycle);
+			/* The inode is being torn down, pause and
+			 * try again.
+			 */
+			if (inode->i_state & (I_FREEING | I_CLEAR)) {
+				read_unlock(&ih->ih_lock);
+				delay(1);
+				XFS_STATS_INC(xs_ig_frecycle);
 
-					goto again;
-				}
-/* Chances are the other vnode (the one in the inode) is being torn
- * down right now, and we landed on top of it. Question is, what do
- * we do? Unhook the old inode and hook up the new one?
- */
-				cmn_err(CE_PANIC,
-			"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
-						inode_vp, vp);
+				goto again;
 			}
+/* Chances are the other vnode (the one in the inode) is being torn
+* down right now, and we landed on top of it. Question is, what do
+* we do? Unhook the old inode and hook up the new one?
+*/
+			cmn_err(CE_PANIC,
+		"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
+					inode_vp, vp);
+		}
 
-			/*
-			 * Inode cache hit: if ip is not at the front of
-			 * its hash chain, move it there now.
-			 * Do this with the lock held for update, but
-			 * do statistics after releasing the lock.
-			 */
-			version = ih->ih_version;
-			read_unlock(&ih->ih_lock);
-			xfs_ihash_promote(ih, ip, version);
-			XFS_STATS_INC(xs_ig_found);
+		/*
+		 * Inode cache hit: if ip is not at the front of
+		 * its hash chain, move it there now.
+		 * Do this with the lock held for update, but
+		 * do statistics after releasing the lock.
+		 */
+		version = ih->ih_version;
+		read_unlock(&ih->ih_lock);
+		XFS_STATS_INC(xs_ig_found);
 
 finish_inode:
-			if (ip->i_d.di_mode == 0) {
-				if (!(flags & XFS_IGET_CREATE))
-					return ENOENT;
-				xfs_iocore_inode_reinit(ip);
-			}
+		if (ip->i_d.di_mode == 0) {
+			if (!(flags & XFS_IGET_CREATE))
+				return ENOENT;
+			xfs_iocore_inode_reinit(ip);
+		}
 
-			if (lock_flags != 0)
-				xfs_ilock(ip, lock_flags);
+		if (lock_flags != 0)
+			xfs_ilock(ip, lock_flags);
 
-			xfs_iflags_clear(ip, XFS_ISTALE);
-			vn_trace_exit(vp, "xfs_iget.found",
-						(inst_t *)__return_address);
-			goto return_ip;
-		}
+		xfs_iflags_clear(ip, XFS_ISTALE);
+		vn_trace_exit(vp, "xfs_iget.found",
+					(inst_t *)__return_address);
+		goto return_ip;
 	}
 
 	/*
 	 * Inode cache miss: save the hash chain version stamp and unlock
 	 * the chain, so we don't deadlock in vn_alloc.
 	 */
-	XFS_STATS_INC(xs_ig_missed);
-
 	version = ih->ih_version;
-
 	read_unlock(&ih->ih_lock);
+	XFS_STATS_INC(xs_ig_missed);
 
 	/*
 	 * Read the disk inode attributes into a new inode structure and get
@@ -340,34 +297,32 @@ finish_inode:
 	 * Put ip on its hash chain, unless someone else hashed a duplicate
 	 * after we released the hash lock.
 	 */
+	if (radix_tree_preload(GFP_KERNEL)) {
+		delay(1);
+		goto again;
+	}
 	write_lock(&ih->ih_lock);
 
-	if (ih->ih_version != version) {
-		for (iq = ih->ih_next; iq != NULL; iq = iq->i_next) {
-			if (iq->i_ino == ino) {
-				write_unlock(&ih->ih_lock);
-				xfs_idestroy(ip);
-
-				XFS_STATS_INC(xs_ig_dup);
-				goto again;
-			}
-		}
+	error = radix_tree_insert(&ih->ih_root, (unsigned long)ino, (void *)ip);
+	if (unlikely(error)) {
+		BUG_ON(error != -EEXIST);
+		write_unlock(&ih->ih_lock);
+		radix_tree_preload_end();
+		xfs_idestroy(ip);
+		ASSERT(ih->ih_version != version);
+		XFS_STATS_INC(xs_ig_dup);
+		goto again;
 	}
 
 	/*
 	 * These values _must_ be set before releasing ihlock!
 	 */
 	ip->i_hash = ih;
-	if ((iq = ih->ih_next)) {
-		iq->i_prevp = &ip->i_next;
-	}
-	ip->i_next = iq;
-	ip->i_prevp = &ih->ih_next;
-	ih->ih_next = ip;
 	ip->i_udquot = ip->i_gdquot = NULL;
 	ih->ih_version++;
 	xfs_iflags_set(ip, XFS_INEW);
 	write_unlock(&ih->ih_lock);
+	radix_tree_preload_end();
 
 	/*
 	 * put ip on its cluster's hash chain
@@ -559,30 +514,16 @@ xfs_inode_incore(xfs_mount_t	*mp,
 {
 	xfs_ihash_t	*ih;
 	xfs_inode_t	*ip;
-	ulong		version;
 
 	ih = XFS_IHASH(mp, ino);
 	read_lock(&ih->ih_lock);
-	for (ip = ih->ih_next; ip != NULL; ip = ip->i_next) {
-		if (ip->i_ino == ino) {
-			/*
-			 * If we find it and tp matches, return it.
-			 * Also move it to the front of the hash list
-			 * if we find it and it is not already there.
-			 * Otherwise break from the loop and return
-			 * NULL.
-			 */
-			if (ip->i_transp == tp) {
-				version = ih->ih_version;
-				read_unlock(&ih->ih_lock);
-				xfs_ihash_promote(ih, ip, version);
-				return (ip);
-			}
-			break;
-		}
-	}
+	ip = (xfs_inode_t *) radix_tree_lookup(&ih->ih_root, (unsigned long)ino);
 	read_unlock(&ih->ih_lock);
-	return (NULL);
+
+	/* the returned inode must match the transaction */
+	if (ip && (ip->i_transp != tp))
+		return NULL;
+	return ip;
 }
 
 /*
@@ -696,10 +637,7 @@ xfs_iextract(
 
 	ih = ip->i_hash;
 	write_lock(&ih->ih_lock);
-	if ((iq = ip->i_next)) {
-		iq->i_prevp = ip->i_prevp;
-	}
-	*ip->i_prevp = iq;
+	radix_tree_delete(&ih->ih_root, ip->i_ino);
 	ih->ih_version++;
 	write_unlock(&ih->ih_lock);
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-09-14 12:49:52.546615391 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-09-18 12:02:31.027726925 +1000
@@ -2185,10 +2185,7 @@ xfs_ifree_cluster(
 		for (i = 0; i < ninodes; i++) {
 			ih = XFS_IHASH(mp, inum + i);
 			read_lock(&ih->ih_lock);
-			for (ip = ih->ih_next; ip != NULL; ip = ip->i_next) {
-				if (ip->i_ino == inum + i)
-					break;
-			}
+			ip = (xfs_inode_t *)radix_tree_lookup(&ih->ih_root, inum + i);
 
 			/* Inode not in memory or we found it already,
 			 * nothing to do
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2006-09-14 12:50:19.827087794 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2006-09-18 12:02:31.027726925 +1000
@@ -175,12 +175,12 @@ extern void xfs_iocore_inode_reinit(stru
  * file system to hash the inodes for that file system.
  */
 typedef struct xfs_ihash {
-	struct xfs_inode	*ih_next;
+	struct radix_tree_root	ih_root;
 	rwlock_t		ih_lock;
 	uint			ih_version;
 } xfs_ihash_t;
 
-#define XFS_IHASH(mp,ino) ((mp)->m_ihash + (((uint)(ino)) % (mp)->m_ihsize))
+#define XFS_IHASH(mp,ino) ((mp)->m_ihash + (((uint)((ino) >> 6)) % (mp)->m_ihsize))
 
 /*
  * This is the xfs inode cluster hash.  This hash is used by xfs_iflush to
@@ -229,20 +229,16 @@ typedef struct xfs_chash {
 
 typedef struct {
 	struct xfs_ihash	*ip_hash;	/* pointer to hash header */
-	struct xfs_inode	*ip_next;	/* inode hash link forw */
 	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
 	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
-	struct xfs_inode	**ip_prevp;	/* ptr to prev i_next */
 	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
 } xfs_iptr_t;
 
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_ihash	*i_hash;	/* pointer to hash header */
-	struct xfs_inode	*i_next;	/* inode hash link forw */
 	struct xfs_inode	*i_mnext;	/* next inode in mount list */
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
-	struct xfs_inode	**i_prevp;	/* ptr to prev i_next */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
 	struct bhv_desc		i_bhv_desc;	/* inode behavior descriptor*/
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2006-09-14 12:49:52.558613839 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2006-09-18 12:02:26.328333578 +1000
@@ -6766,6 +6766,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 static void
 xfsidbg_xihash(xfs_mount_t *mp)
 {
+#if 0
 	xfs_ihash_t	*ih;
 	int		i;
 	int		j;
@@ -6826,6 +6827,7 @@ xfsidbg_xihash(xfs_mount_t *mp)
 	}
 	kdb_printf("\n");
 	kfree(hist);
+#endif
 }
 
 /*
@@ -6843,10 +6845,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		NULL
 	};
 
-	kdb_printf("hash 0x%p next 0x%p prevp 0x%p mount 0x%p\n",
+	kdb_printf("hash 0x%p mount 0x%p\n",
 		ip->i_hash,
-		ip->i_next,
-		ip->i_prevp,
 		ip->i_mount);
 	kdb_printf("mnext 0x%p mprev 0x%p vnode 0x%p \n",
 		ip->i_mnext,
