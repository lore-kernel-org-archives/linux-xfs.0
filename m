Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 04:38:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l79BcAbm004953
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 04:38:12 -0700
Date: Thu, 9 Aug 2007 21:38:07 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 1 of 4] Convert inode hash caches to radix trees
Message-ID: <20070809113807.GD12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Convert the inode cache hash to a radix tree.

A radix tree has been chosen to replace the hash because of a
neat alignment of XFS inode structures and the kernel radix tree
fanout. XFS allocates inodes in clusters of 64 inodes and the
radix tree keeps 64 sequential entries per node. That means all
fo the inodes in a cluster will always sit in the same node of
the radix tree.

A single radix tree with a read/write lock does not provide enough
parallelism to prevent performance regressions on multi-processor
machines, so we provide a radix tree per AG.

By moving to a radix tree per AG, we can use the agino number as
the index rather than the inode number, thereby reducing the radix
tree key to 32 bits enabling this to be used for 64 bit inodes
on 32 bit machines. In doing so, we also greatly reduce the
sparseness of the radix trees because the agino is a more
compact representation of the inode location than the inode number.

It also provides inherent parallelism in the same manner as the rest
of XFS without the need for heuristics.  i.e. we parallelise
operations by keeping structures and operations within AGs. This
removes the need for the ihashsize mount parameter altogether
as the inode caches should never need size hints anymore.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_export.c |    4 
 fs/xfs/linux-2.6/xfs_ksyms.c  |    2 
 fs/xfs/xfs_ag.h               |    4 
 fs/xfs/xfs_buf_item.c         |    1 
 fs/xfs/xfs_clnt.h             |    1 
 fs/xfs/xfs_dir2_block.c       |    1 
 fs/xfs/xfs_dir2_data.c        |    1 
 fs/xfs/xfs_dir2_node.c        |    1 
 fs/xfs/xfs_dir2_sf.c          |    1 
 fs/xfs/xfs_error.c            |    1 
 fs/xfs/xfs_extfree_item.c     |    1 
 fs/xfs/xfs_iget.c             |  606 +++++++++++++++---------------------------
 fs/xfs/xfs_inode.c            |   36 --
 fs/xfs/xfs_inode.h            |   59 ----
 fs/xfs/xfs_mount.c            |   24 -
 fs/xfs/xfs_mount.h            |   22 +
 fs/xfs/xfs_rename.c           |    1 
 fs/xfs/xfs_trans_ail.c        |    1 
 fs/xfs/xfs_trans_extfree.c    |    1 
 fs/xfs/xfs_vfsops.c           |   24 -
 fs/xfs/xfs_vnodeops.c         |    9 
 fs/xfs/xfsidbg.c              |  199 -------------
 22 files changed, 307 insertions(+), 693 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-08-09 13:03:13.934083931 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-08-09 13:03:53.157036650 +1000
@@ -40,131 +40,13 @@
 #include "xfs_utils.h"
 
 /*
- * Initialize the inode hash table for the newly mounted file system.
- * Choose an initial table size based on user specified value, else
- * use a simple algorithm using the maximum number of inodes as an
- * indicator for table size, and clamp it between one and some large
- * number of pages.
- */
-void
-xfs_ihash_init(xfs_mount_t *mp)
-{
-	__uint64_t	icount;
-	uint		i;
-
-	if (!mp->m_ihsize) {
-		icount = mp->m_maxicount ? mp->m_maxicount :
-			 (mp->m_sb.sb_dblocks << mp->m_sb.sb_inopblog);
-		mp->m_ihsize = 1 << max_t(uint, 8,
-					(xfs_highbit64(icount) + 1) / 2);
-		mp->m_ihsize = min_t(uint, mp->m_ihsize,
-					(64 * NBPP) / sizeof(xfs_ihash_t));
-	}
-
-	mp->m_ihash = kmem_zalloc_greedy(&mp->m_ihsize,
-					 NBPC * sizeof(xfs_ihash_t),
-					 mp->m_ihsize * sizeof(xfs_ihash_t),
-					 KM_SLEEP | KM_MAYFAIL | KM_LARGE);
-	mp->m_ihsize /= sizeof(xfs_ihash_t);
-	for (i = 0; i < mp->m_ihsize; i++)
-		rwlock_init(&(mp->m_ihash[i].ih_lock));
-}
-
-/*
- * Free up structures allocated by xfs_ihash_init, at unmount time.
- */
-void
-xfs_ihash_free(xfs_mount_t *mp)
-{
-	kmem_free(mp->m_ihash, mp->m_ihsize * sizeof(xfs_ihash_t));
-	mp->m_ihash = NULL;
-}
-
-/*
- * Initialize the inode cluster hash table for the newly mounted file system.
- * Its size is derived from the ihash table size.
- */
-void
-xfs_chash_init(xfs_mount_t *mp)
-{
-	uint	i;
-
-	mp->m_chsize = max_t(uint, 1, mp->m_ihsize /
-			 (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog));
-	mp->m_chsize = min_t(uint, mp->m_chsize, mp->m_ihsize);
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
- * The inode is looked up in the hash table for the file system
- * represented by the mount point parameter mp.  Each bucket of
- * the hash table is guarded by an individual semaphore.
- *
- * If the inode is found in the hash table, its corresponding vnode
- * is obtained with a call to vn_get().  This call takes care of
- * coordination with the reclamation of the inode and vnode.  Note
- * that the vmap structure is filled in while holding the hash lock.
- * This gives us the state of the inode/vnode when we found it and
- * is used for coordination in vn_get().
+ * The inode is looked up in the cache held in each AG.
+ * If the inode is found in the cache, attach it to the provided
+ * vnode.
  *
- * If it is not in core, read it in from the file system's device and
- * add the inode into the hash table.
+ * If it is not in core, read it in from the file system's device,
+ * add it to the cache and attach the provided vnode.
  *
  * The inode is locked according to the value of the lock_flags parameter.
  * This flag parameter indicates how and if the inode's IO lock and inode lock
@@ -192,274 +74,251 @@ xfs_iget_core(
 	xfs_inode_t	**ipp,
 	xfs_daddr_t	bno)
 {
-	xfs_ihash_t	*ih;
 	xfs_inode_t	*ip;
 	xfs_inode_t	*iq;
 	bhv_vnode_t	*inode_vp;
-	ulong		version;
 	int		error;
-	/* REFERENCED */
-	xfs_chash_t	*ch;
-	xfs_chashlist_t	*chl, *chlnew;
-	SPLDECL(s);
+	xfs_icluster_t	*icl, *new_icl = NULL;
+	unsigned long	first_index, mask;
+	xfs_perag_t	*pag;
+	xfs_agino_t	agino;
+
+	/* the radix tree exists only in inode capable AGs */
+	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_maxagi)
+		return EINVAL;
+
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_get_perag(mp, ino);
+	if (!pag->pagi_inodeok)
+		return EINVAL;
+	ASSERT(pag->pag_ici_init);
+	agino = XFS_INO_TO_AGINO(mp, ino);
 
+again:
+	read_lock(&pag->pag_ici_lock);
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
 
-	ih = XFS_IHASH(mp, ino);
+	if (ip != NULL) {
+		/*
+		 * If INEW is set this inode is being set up
+		 * we need to pause and try again.
+		 */
+		if (xfs_iflags_test(ip, XFS_INEW)) {
+			read_unlock(&pag->pag_ici_lock);
+			delay(1);
+			XFS_STATS_INC(xs_ig_frecycle);
 
-again:
-	read_lock(&ih->ih_lock);
+			goto again;
+		}
 
-	for (ip = ih->ih_next; ip != NULL; ip = ip->i_next) {
-		if (ip->i_ino == ino) {
+		inode_vp = XFS_ITOV_NULL(ip);
+		if (inode_vp == NULL) {
 			/*
-			 * If INEW is set this inode is being set up
+			 * If IRECLAIM is set this inode is
+			 * on its way out of the system,
 			 * we need to pause and try again.
 			 */
-			if (xfs_iflags_test(ip, XFS_INEW)) {
-				read_unlock(&ih->ih_lock);
+			if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
+				read_unlock(&pag->pag_ici_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
 
 				goto again;
 			}
+			ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
 
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
-
-					goto again;
-				}
-				ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-
-				/*
-				 * If lookup is racing with unlink, then we
-				 * should return an error immediately so we
-				 * don't remove it from the reclaim list and
-				 * potentially leak the inode.
-				 */
-				if ((ip->i_d.di_mode == 0) &&
-				    !(flags & XFS_IGET_CREATE)) {
-					read_unlock(&ih->ih_lock);
-					return ENOENT;
-				}
-
-				/*
-				 * There may be transactions sitting in the
-				 * incore log buffers or being flushed to disk
-				 * at this time.  We can't clear the
-				 * XFS_IRECLAIMABLE flag until these
-				 * transactions have hit the disk, otherwise we
-				 * will void the guarantee the flag provides
-				 * xfs_iunpin()
-				 */
-				if (xfs_ipincount(ip)) {
-					read_unlock(&ih->ih_lock);
-					xfs_log_force(mp, 0,
-						XFS_LOG_FORCE|XFS_LOG_SYNC);
-					XFS_STATS_INC(xs_ig_frecycle);
-					goto again;
-				}
+			/*
+			 * If lookup is racing with unlink, then we
+			 * should return an error immediately so we
+			 * don't remove it from the reclaim list and
+			 * potentially leak the inode.
+			 */
+			if ((ip->i_d.di_mode == 0) &&
+			    !(flags & XFS_IGET_CREATE)) {
+				read_unlock(&pag->pag_ici_lock);
+				xfs_put_perag(mp, pag);
+				return ENOENT;
+			}
 
-				vn_trace_exit(vp, "xfs_iget.alloc",
-					(inst_t *)__return_address);
+			/*
+			 * There may be transactions sitting in the
+			 * incore log buffers or being flushed to disk
+			 * at this time.  We can't clear the
+			 * XFS_IRECLAIMABLE flag until these
+			 * transactions have hit the disk, otherwise we
+			 * will void the guarantee the flag provides
+			 * xfs_iunpin()
+			 */
+			if (xfs_ipincount(ip)) {
+				read_unlock(&pag->pag_ici_lock);
+				xfs_log_force(mp, 0,
+					XFS_LOG_FORCE|XFS_LOG_SYNC);
+				XFS_STATS_INC(xs_ig_frecycle);
+				goto again;
+			}
 
-				XFS_STATS_INC(xs_ig_found);
+			vn_trace_exit(vp, "xfs_iget.alloc",
+				(inst_t *)__return_address);
 
-				xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-				version = ih->ih_version;
-				read_unlock(&ih->ih_lock);
-				xfs_ihash_promote(ih, ip, version);
-
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
+			XFS_STATS_INC(xs_ig_found);
 
-					goto again;
-				}
-/* Chances are the other vnode (the one in the inode) is being torn
- * down right now, and we landed on top of it. Question is, what do
- * we do? Unhook the old inode and hook up the new one?
- */
-				cmn_err(CE_PANIC,
-			"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
-						inode_vp, vp);
-			}
+			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
+			read_unlock(&pag->pag_ici_lock);
 
-			/*
-			 * Inode cache hit: if ip is not at the front of
-			 * its hash chain, move it there now.
-			 * Do this with the lock held for update, but
-			 * do statistics after releasing the lock.
+			XFS_MOUNT_ILOCK(mp);
+			list_del_init(&ip->i_reclaim);
+			XFS_MOUNT_IUNLOCK(mp);
+
+			goto finish_inode;
+
+		} else if (vp != inode_vp) {
+			struct inode *inode = vn_to_inode(inode_vp);
+
+			/* The inode is being torn down, pause and
+			 * try again.
 			 */
-			version = ih->ih_version;
-			read_unlock(&ih->ih_lock);
-			xfs_ihash_promote(ih, ip, version);
-			XFS_STATS_INC(xs_ig_found);
+			if (inode->i_state & (I_FREEING | I_CLEAR)) {
+				read_unlock(&pag->pag_ici_lock);
+				delay(1);
+				XFS_STATS_INC(xs_ig_frecycle);
 
-finish_inode:
-			if (ip->i_d.di_mode == 0) {
-				if (!(flags & XFS_IGET_CREATE))
-					return ENOENT;
-				xfs_iocore_inode_reinit(ip);
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
 
-			if (lock_flags != 0)
-				xfs_ilock(ip, lock_flags);
+		/*
+		 * Inode cache hit
+		 */
+		read_unlock(&pag->pag_ici_lock);
+		XFS_STATS_INC(xs_ig_found);
 
-			xfs_iflags_clear(ip, XFS_ISTALE);
-			vn_trace_exit(vp, "xfs_iget.found",
-						(inst_t *)__return_address);
-			goto return_ip;
+finish_inode:
+		if (ip->i_d.di_mode == 0) {
+			if (!(flags & XFS_IGET_CREATE)) {
+				xfs_put_perag(mp, pag);
+				return ENOENT;
+			}
+			xfs_iocore_inode_reinit(ip);
 		}
+
+		if (lock_flags != 0)
+			xfs_ilock(ip, lock_flags);
+
+		xfs_iflags_clear(ip, XFS_ISTALE);
+		vn_trace_exit(vp, "xfs_iget.found",
+					(inst_t *)__return_address);
+		goto return_ip;
 	}
 
 	/*
-	 * Inode cache miss: save the hash chain version stamp and unlock
-	 * the chain, so we don't deadlock in vn_alloc.
+	 * Inode cache miss
 	 */
+	read_unlock(&pag->pag_ici_lock);
 	XFS_STATS_INC(xs_ig_missed);
 
-	version = ih->ih_version;
-
-	read_unlock(&ih->ih_lock);
-
 	/*
 	 * Read the disk inode attributes into a new inode structure and get
 	 * a new vnode for it. This should also initialize i_ino and i_mount.
 	 */
 	error = xfs_iread(mp, tp, ino, &ip, bno,
 			  (flags & XFS_IGET_BULKSTAT) ? XFS_IMAP_BULKSTAT : 0);
-	if (error)
+	if (error) {
+		xfs_put_perag(mp, pag);
 		return error;
+	}
 
 	vn_trace_exit(vp, "xfs_iget.alloc", (inst_t *)__return_address);
 
 	xfs_inode_lock_init(ip, vp);
 	xfs_iocore_inode_init(ip);
-
 	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		xfs_idestroy(ip);
+		xfs_put_perag(mp, pag);
 		return ENOENT;
 	}
 
 	/*
-	 * Put ip on its hash chain, unless someone else hashed a duplicate
-	 * after we released the hash lock.
+	 * This is a bit messy - we preallocate everything we _might_
+	 * need before we pick up the ici lock. That way we don't have to
+	 * juggle locks and go all the way back to the start.
 	 */
-	write_lock(&ih->ih_lock);
+	new_icl = (xfs_icluster_t *)kmem_zone_alloc(xfs_icluster_zone, KM_SLEEP);
+	if (radix_tree_preload(GFP_KERNEL)) {
+		delay(1);
+		goto again;
+	}
+	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
+	first_index = agino & mask;
+	write_lock(&pag->pag_ici_lock);
 
-	if (ih->ih_version != version) {
-		for (iq = ih->ih_next; iq != NULL; iq = iq->i_next) {
-			if (iq->i_ino == ino) {
-				write_unlock(&ih->ih_lock);
-				xfs_idestroy(ip);
+	/*
+	 * Find the cluster if it exists
+	 */
+	icl = NULL;
+	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
+							first_index, 1)) {
+		if ((iq->i_ino & mask) == first_index)
+			icl = iq->i_cluster;
+	}
 
-				XFS_STATS_INC(xs_ig_dup);
-				goto again;
-			}
-		}
+	/*
+	 * insert the new inode
+	 */
+	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
+	if (unlikely(error)) {
+		BUG_ON(error != -EEXIST);
+		write_unlock(&pag->pag_ici_lock);
+		radix_tree_preload_end();
+		xfs_idestroy(ip);
+		XFS_STATS_INC(xs_ig_dup);
+		goto again;
 	}
 
 	/*
 	 * These values _must_ be set before releasing ihlock!
 	 */
-	ip->i_hash = ih;
-	if ((iq = ih->ih_next)) {
-		iq->i_prevp = &ip->i_next;
-	}
-	ip->i_next = iq;
-	ip->i_prevp = &ih->ih_next;
-	ih->ih_next = ip;
 	ip->i_udquot = ip->i_gdquot = NULL;
-	ih->ih_version++;
 	xfs_iflags_set(ip, XFS_INEW);
-	write_unlock(&ih->ih_lock);
 
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
-			 * where chl points */
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
-			goto chlredo;
-		} else {
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
-	}
-
-	mutex_spinunlock(&ch->ch_lock, s);
-
+		ip->i_cnext = ip;
+		ip->i_cprev = ip;
+		ip->i_cluster = new_icl;
+		new_icl->icl_ip = ip;
+		spin_lock_init(&new_icl->icl_lock);
+		new_icl = NULL;
+	}
+	write_unlock(&pag->pag_ici_lock);
+	radix_tree_preload_end();
+	if (new_icl)
+		kmem_zone_free(xfs_icluster_zone, new_icl);
 
 	/*
 	 * Link ip to its mount and thread it on the mount's inode list.
@@ -478,6 +337,7 @@ finish_inode:
 	mp->m_inodes = ip;
 
 	XFS_MOUNT_IUNLOCK(mp);
+	xfs_put_perag(mp, pag);
 
  return_ip:
 	ASSERT(ip->i_df.if_ext_max ==
@@ -587,32 +447,19 @@ xfs_inode_incore(xfs_mount_t	*mp,
 		 xfs_ino_t	ino,
 		 xfs_trans_t	*tp)
 {
-	xfs_ihash_t	*ih;
 	xfs_inode_t	*ip;
-	ulong		version;
+	xfs_perag_t	*pag;
 
-	ih = XFS_IHASH(mp, ino);
-	read_lock(&ih->ih_lock);
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
-	read_unlock(&ih->ih_lock);
-	return (NULL);
+	pag = xfs_get_perag(mp, ino);
+	read_lock(&pag->pag_ici_lock);
+	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino));
+	read_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
+
+	/* the returned inode must match the transaction */
+	if (ip && (ip->i_transp != tp))
+		return NULL;
+	return ip;
 }
 
 /*
@@ -718,58 +565,47 @@ void
 xfs_iextract(
 	xfs_inode_t	*ip)
 {
-	xfs_ihash_t	*ih;
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
 	xfs_inode_t	*iq;
-	xfs_mount_t	*mp;
-	xfs_chash_t	*ch;
-	xfs_chashlist_t *chl, *chm;
-	SPLDECL(s);
-
-	ih = ip->i_hash;
-	write_lock(&ih->ih_lock);
-	if ((iq = ip->i_next)) {
-		iq->i_prevp = ip->i_prevp;
-	}
-	*ip->i_prevp = iq;
-	ih->ih_version++;
-	write_unlock(&ih->ih_lock);
-
-	/*
-	 * Remove from cluster hash list
-	 *   1) delete the chashlist if this is the last inode on the chashlist
-	 *   2) unchain from list of inodes
-	 *   3) point chashlist->chl_ip to 'chl_next' if to this inode.
+
+	write_lock(&pag->pag_ici_lock);
+	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
+
+	/*
+	 * Remove from cluster list
 	 */
 	mp = ip->i_mount;
-	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
-
-	if (ip->i_cnext == ip) {
-		/* Last inode on chashlist */
+	spin_lock(&ip->i_cluster->icl_lock);
+	if (unlikely(ip->i_cnext == ip)) {
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
-		chl = ip->i_chash;
-		if (chl->chl_prev)
-			chl->chl_prev->chl_next = chl->chl_next;
-		else
-			ch->ch_list = chl->chl_next;
-		if (chl->chl_next)
-			chl->chl_next->chl_prev = chl->chl_prev;
-		kmem_zone_free(xfs_chashlist_zone, chl);
+		ASSERT(ip->i_cluster != NULL);
+
+		spin_unlock(&ip->i_cluster->icl_lock);
+		kmem_zone_free(xfs_icluster_zone, ip->i_cluster);
 	} else {
 		/* delete one inode from a non-empty list */
 		iq = ip->i_cnext;
 		iq->i_cprev = ip->i_cprev;
 		ip->i_cprev->i_cnext = iq;
-		if (ip->i_chash->chl_ip == ip) {
-			ip->i_chash->chl_ip = iq;
+		if (ip->i_cluster->icl_ip == ip) {
+			ip->i_cluster->icl_ip = iq;
 		}
-		ip->i_chash = __return_address;
+		spin_unlock(&ip->i_cluster->icl_lock);
+		ip->i_cluster = __return_address;
 		ip->i_cprev = __return_address;
 		ip->i_cnext = __return_address;
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
 
 	/*
 	 * Remove from mount's inode list.
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-08-09 13:03:13.934083931 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-08-09 13:03:53.181033562 +1000
@@ -52,7 +52,7 @@
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
-kmem_zone_t *xfs_chashlist_zone;
+kmem_zone_t *xfs_icluster_zone;
 
 /*
  * Used in xfs_itruncate().  This is the maximum number of extents
@@ -2182,10 +2182,10 @@ xfs_ifree_cluster(
 	int			i, j, found, pre_flushed;
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
-	xfs_ihash_t		*ih;
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
+	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
 	SPLDECL(s);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
@@ -2220,23 +2220,20 @@ xfs_ifree_cluster(
 		 */
 		found = 0;
 		for (i = 0; i < ninodes; i++) {
-			ih = XFS_IHASH(mp, inum + i);
-			read_lock(&ih->ih_lock);
-			for (ip = ih->ih_next; ip != NULL; ip = ip->i_next) {
-				if (ip->i_ino == inum + i)
-					break;
-			}
+			read_lock(&pag->pag_ici_lock);
+			ip = radix_tree_lookup(&pag->pag_ici_root,
+					XFS_INO_TO_AGINO(mp, (inum + i)));
 
 			/* Inode not in memory or we found it already,
 			 * nothing to do
 			 */
 			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
 			if (xfs_inode_clean(ip)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
@@ -2259,7 +2256,7 @@ xfs_ifree_cluster(
 						ip_found[found++] = ip;
 					}
 				}
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
@@ -2277,8 +2274,7 @@ xfs_ifree_cluster(
 					xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				}
 			}
-
-			read_unlock(&ih->ih_lock);
+			read_unlock(&pag->pag_ici_lock);
 		}
 
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
@@ -2333,6 +2329,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found, ninodes * sizeof(xfs_inode_t *));
+	xfs_put_perag(mp, pag);
 }
 
 /*
@@ -3050,12 +3047,10 @@ xfs_iflush(
 	xfs_mount_t		*mp;
 	int			error;
 	/* REFERENCED */
-	xfs_chash_t		*ch;
 	xfs_inode_t		*iq;
 	int			clcount;	/* count of inodes clustered */
 	int			bufwasdelwri;
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
-	SPLDECL(s);
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -3169,11 +3164,8 @@ xfs_iflush(
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
-
-	ip->i_chash->chl_buf = bp;
-
-	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
+	spin_lock(&ip->i_cluster->icl_lock);
+	ip->i_cluster->icl_buf = bp;
 
 	clcount = 0;
 	for (iq = ip->i_cnext; iq != ip; iq = iq->i_cnext) {
@@ -3227,7 +3219,7 @@ xfs_iflush(
 			xfs_iunlock(iq, XFS_ILOCK_SHARED);
 		}
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
+	spin_unlock(&ip->i_cluster->icl_lock);
 
 	if (clcount) {
 		XFS_STATS_INC(xs_icluster_flushcnt);
@@ -3264,7 +3256,7 @@ cluster_corrupt_out:
 	/* Corruption detected in the clustering loop.  Invalidate the
 	 * inode buffer and shut down the filesystem.
 	 */
-	mutex_spinunlock(&ch->ch_lock, s);
+	spin_unlock(&ip->i_cluster->icl_lock);
 
 	/*
 	 * Clean up the buffer.  If it was B_DELWRI, just release it --
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-08-09 13:03:13.934083931 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-08-09 13:03:53.157036650 +1000
@@ -172,41 +172,18 @@ typedef struct xfs_iocore {
 extern void xfs_iocore_inode_init(struct xfs_inode *);
 extern void xfs_iocore_inode_reinit(struct xfs_inode *);
 
-
 /*
- * This is the type used in the xfs inode hash table.
- * An array of these is allocated for each mounted
- * file system to hash the inodes for that file system.
- */
-typedef struct xfs_ihash {
-	struct xfs_inode	*ih_next;
-	rwlock_t		ih_lock;
-	uint			ih_version;
-} xfs_ihash_t;
-
-#define XFS_IHASH(mp,ino) ((mp)->m_ihash + (((uint)(ino)) % (mp)->m_ihsize))
-
-/*
- * This is the xfs inode cluster hash.  This hash is used by xfs_iflush to
- * find inodes that share a cluster and can be flushed to disk at the same
- * time.
- */
-typedef struct xfs_chashlist {
-	struct xfs_chashlist	*chl_next;
-	struct xfs_chashlist	*chl_prev;
-	struct xfs_inode	*chl_ip;
-	xfs_daddr_t		chl_blkno;	/* starting block number of
+ * This is the xfs inode cluster structure.  This structure is used by
+ * xfs_iflush to find inodes that share a cluster and can be flushed to disk at
+ * the same time.
+ */
+typedef struct xfs_icluster {
+	struct xfs_inode	*icl_ip;
+	xfs_daddr_t		icl_blkno;	/* starting block number of
 						 * the cluster */
-	struct xfs_buf		*chl_buf;	/* the inode buffer */
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
@@ -269,21 +246,15 @@ typedef struct xfs_icdinode {
 } xfs_icdinode_t;
 
 typedef struct {
-	struct xfs_ihash	*ip_hash;	/* pointer to hash header */
-	struct xfs_inode	*ip_next;	/* inode hash link forw */
 	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
 	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
-	struct xfs_inode	**ip_prevp;	/* ptr to prev i_next */
 	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
 } xfs_iptr_t;
 
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
-	struct xfs_ihash	*i_hash;	/* pointer to hash header */
-	struct xfs_inode	*i_next;	/* inode hash link forw */
 	struct xfs_inode	*i_mnext;	/* next inode in mount list */
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
-	struct xfs_inode	**i_prevp;	/* ptr to prev i_next */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
 	struct bhv_desc		i_bhv_desc;	/* inode behavior descriptor*/
@@ -324,9 +295,9 @@ typedef struct xfs_inode {
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
@@ -521,8 +492,6 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
  */
 void		xfs_ihash_init(struct xfs_mount *);
 void		xfs_ihash_free(struct xfs_mount *);
-void		xfs_chash_init(struct xfs_mount *);
-void		xfs_chash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
 void            xfs_inode_lock_init(xfs_inode_t *, struct bhv_vnode *);
@@ -633,7 +602,7 @@ void		xfs_inobp_check(struct xfs_mount *
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern struct kmem_zone	*xfs_chashlist_zone;
+extern struct kmem_zone	*xfs_icluster_zone;
 extern struct kmem_zone	*xfs_ifork_zone;
 extern struct kmem_zone	*xfs_inode_zone;
 extern struct kmem_zone	*xfs_ili_zone;
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-08-09 13:03:13.938083417 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-08-09 13:03:53.193032018 +1000
@@ -135,8 +135,6 @@ static void	xfsidbg_xbuf(xfs_buf_t *);
 static void	xfsidbg_xbuf_real(xfs_buf_t *, int);
 static void	xfsidbg_xarg(int);
 static void	xfsidbg_xchksum(uint *);
-static void	xfsidbg_xchash(xfs_mount_t *mp);
-static void	xfsidbg_xchashlist(xfs_chashlist_t *chl);
 static void	xfsidbg_xdaargs(xfs_da_args_t *);
 static void	xfsidbg_xdabuf(xfs_dabuf_t *);
 static void	xfsidbg_xdanode(xfs_da_intnode_t *);
@@ -149,7 +147,6 @@ static void	xfsidbg_xhelp(void);
 static void	xfsidbg_xiclog(xlog_in_core_t *);
 static void	xfsidbg_xiclogall(xlog_in_core_t *);
 static void	xfsidbg_xiclogcb(xlog_in_core_t *);
-static void	xfsidbg_xihash(xfs_mount_t *mp);
 static void	xfsidbg_xinodes(xfs_mount_t *);
 static void	xfsidbg_delayed_blocks(xfs_mount_t *);
 static void	xfsidbg_xinodes_quiesce(xfs_mount_t *);
@@ -1020,46 +1017,6 @@ static int	kdbm_xfs_xchksum(
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
@@ -1280,25 +1237,6 @@ static int	kdbm_xfs_xiclogcb(
 	return 0;
 }
 
-static int	kdbm_xfs_xihash(
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
-	xfsidbg_xihash((xfs_mount_t *) addr);
-	return 0;
-}
-
 static int	kdbm_xfs_xinodes(
 	int	argc,
 	const char **argv)
@@ -2173,15 +2111,11 @@ static void	printinode(struct inode *ip)
 		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
 					ip->i_mode, ip->i_nlink,
 					kdev_t_to_nr(ip->i_rdev), ip->i_state);
-	kdb_printf(" i_hash.nxt = 0x%p i_hash.pprv = 0x%p\n",
-                                        ip->i_hash.next, ip->i_hash.prev);
 #else
 	kdb_printf(
 		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
 					ip->i_mode, ip->i_nlink,
 					ip->i_rdev, ip->i_state);
-	kdb_printf(" i_hash.nxt = 0x%p i_hash.pprv = 0x%p\n",
-                                        ip->i_hash.next, ip->i_hash.pprev);
 #endif
 	kdb_printf(" i_list.nxt = 0x%p i_list.prv = 0x%p\n",
 					ip->i_list.next, ip->i_list.prev);
@@ -2670,10 +2604,6 @@ static struct xif xfsidbg_funcs[] = {
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
@@ -2727,8 +2657,6 @@ static struct xif xfsidbg_funcs[] = {
   {  "xictrc",	kdbm_xfs_xiclogtrace,	"<xlog_in_core_t>",
 				"Dump XFS in-core log trace" },
 #endif
-  {  "xihash",	kdbm_xfs_xihash,	"<xfs_mount_t>",
-				"Dump XFS inode hash statistics"},
 #ifdef XFS_ILOCK_TRACE
   {  "xilocktrc",kdbm_xfs_xilock_trace,	"<xfs_inode_t>",
 				"Dump XFS ilock trace" },
@@ -6656,7 +6584,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		"BARRIER",	/* 0x20000 */
 		"IDELETE",	/* 0x40000 */
 		"SWALLOC",	/* 0x80000 */
-		"IHASHSIZE",	/* 0x100000 */
+		"UNUSED_100000", /* 0x100000 */
 		"DIRSYNC",	/* 0x200000 */
 		"COMPAT_IOSIZE",/* 0x400000 */
 		NULL
@@ -6688,8 +6616,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_dev : 0);
 	kdb_printf("bsize %d agfrotor %d xfs_rotorstep %d agirotor %d\n",
 		mp->m_bsize, mp->m_agfrotor, xfs_rotorstep, mp->m_agirotor);
-	kdb_printf("ihash 0x%p ihsize %zu\n",
-		mp->m_ihash, mp->m_ihsize);
 	kdb_printf("inodes 0x%p ilock 0x%p ireclaims 0x%x\n",
 		mp->m_inodes, &mp->m_ilock, mp->m_ireclaims);
 	kdb_printf("readio_log 0x%x readio_blocks 0x%x ",
@@ -6756,8 +6682,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		(xfs_dfiloff_t)mp->m_dirdatablk,
 		(xfs_dfiloff_t)mp->m_dirleafblk,
 		(xfs_dfiloff_t)mp->m_dirfreeblk);
-	kdb_printf("chsize %d chash 0x%p\n",
-		mp->m_chsize, mp->m_chash);
 	if (mp->m_fsname != NULL)
 		kdb_printf("mountpoint \"%s\"\n", mp->m_fsname);
 	else
@@ -6765,71 +6689,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 
 }
 
-static void
-xfsidbg_xihash(xfs_mount_t *mp)
-{
-	xfs_ihash_t	*ih;
-	int		i;
-	int		j;
-	int		total;
-	int		numzeros;
-	xfs_inode_t	*ip;
-	int		*hist;
-	int		hist_bytes = mp->m_ihsize * sizeof(int);
-	int		hist2[21];
-
-	hist = (int *) kmalloc(hist_bytes, GFP_KERNEL);
-
-	if (hist == NULL) {
-		kdb_printf("xfsidbg_xihash: kmalloc(%d) failed!\n",
-							hist_bytes);
-		return;
-	}
-
-	for (i = 0; i < mp->m_ihsize; i++) {
-		ih = mp->m_ihash + i;
-		j = 0;
-		for (ip = ih->ih_next; ip != NULL; ip = ip->i_next)
-			j++;
-		hist[i] = j;
-	}
-
-	numzeros = total = 0;
-
-	for (i = 0; i < 21; i++)
-		hist2[i] = 0;
-
-	for (i = 0; i < mp->m_ihsize; i++)  {
-		kdb_printf("%d ", hist[i]);
-		total += hist[i];
-		numzeros += hist[i] == 0 ? 1 : 0;
-		if (hist[i] > 20)
-			j = 20;
-		else
-			j = hist[i];
-
-		if (! (j <= 20)) {
-			kdb_printf("xfsidbg_xihash: (j > 20)/%d @ line # %d\n",
-							j, __LINE__);
-			return;
-		}
-
-		hist2[j]++;
-	}
-
-	kdb_printf("\n");
-
-	kdb_printf("total inodes = %d, average length = %zu, adjusted average = %zu\n",
-		total, total / mp->m_ihsize,
-		total / (mp->m_ihsize - numzeros));
-
-	for (i = 0; i < 21; i++)  {
-		kdb_printf("%d - %d , ", i, hist2[i]);
-	}
-	kdb_printf("\n");
-	kfree(hist);
-}
-
 /*
  * Command to print xfs inodes: kp xnode <addr>
  */
@@ -6845,12 +6704,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		NULL
 	};
 
-	kdb_printf("hash 0x%p next 0x%p prevp 0x%p mount 0x%p\n",
-		ip->i_hash,
-		ip->i_next,
-		ip->i_prevp,
-		ip->i_mount);
-	kdb_printf("mnext 0x%p mprev 0x%p vnode 0x%p \n",
+	kdb_printf("mount 0x%p mnext 0x%p mprev 0x%p vnode 0x%p \n",
+		ip->i_mount,
 		ip->i_mnext,
 		ip->i_mprev,
 		XFS_ITOV_NULL(ip));
@@ -6898,8 +6753,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
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
@@ -6917,50 +6772,6 @@ xfsidbg_xcore(xfs_iocore_t *io)
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
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-09 13:00:12.373444776 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c	2007-08-09 13:03:53.161036135 +1000
@@ -17,10 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_types.h"
-#include "xfs_dmapi.h"
+#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-09 13:01:41.757944512 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-09 13:03:42.950350085 +1000
@@ -237,7 +237,7 @@ EXPORT_SYMBOL(xfs_bulkstat);
 EXPORT_SYMBOL(xfs_bunmapi);
 EXPORT_SYMBOL(xfs_bwrite);
 EXPORT_SYMBOL(xfs_change_file_space);
-EXPORT_SYMBOL(xfs_chashlist_zone);
+EXPORT_SYMBOL(xfs_icluster_zone);
 EXPORT_SYMBOL(xfs_dev_is_read_only);
 EXPORT_SYMBOL(xfs_dir_ialloc);
 EXPORT_SYMBOL(xfs_error_report);
Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-08-09 13:00:12.357446834 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-08-09 13:03:53.157036650 +1000
@@ -197,6 +197,10 @@ typedef struct xfs_perag
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
+
+	int		pag_ici_init;	/* incore inode cache initialised */
+	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 } xfs_perag_t;
 
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
Index: 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_buf_item.c	2007-08-09 13:00:12.373444776 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c	2007-08-09 13:03:53.165035621 +1000
@@ -23,6 +23,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_buf_item.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_clnt.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_clnt.h	2007-08-09 13:00:12.381443746 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_clnt.h	2007-08-09 13:03:53.193032018 +1000
@@ -89,7 +89,6 @@ struct xfs_mount_args {
 #define XFSMNT_IDELETE		0x08000000	/* inode cluster delete */
 #define XFSMNT_SWALLOC		0x10000000	/* turn on stripe width
 						 * allocation */
-#define XFSMNT_IHASHSIZE	0x20000000	/* inode hash table size */
 #define XFSMNT_DIRSYNC		0x40000000	/* sync creat,link,unlink,rename
 						 * symlink,mkdir,rmdir,mknod */
 #define XFSMNT_FLAGS2		0x80000000	/* more flags set in flags2 */
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_block.c	2007-08-09 13:01:41.733947600 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c	2007-08-09 13:03:53.165035621 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_data.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_data.c	2007-08-09 13:00:12.373444776 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_data.c	2007-08-09 13:03:53.173034591 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_node.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_node.c	2007-08-09 13:00:12.373444776 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_node.c	2007-08-09 13:03:53.173034591 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_sf.c	2007-08-09 13:01:41.753945027 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c	2007-08-09 13:03:53.177034077 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_error.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_error.c	2007-08-09 13:00:12.377444261 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_error.c	2007-08-09 13:03:53.177034077 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_extfree_item.c	2007-08-09 13:00:12.377444261 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c	2007-08-09 13:03:53.177034077 +1000
@@ -23,6 +23,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-08-09 13:01:41.685953775 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-08-09 13:03:53.161036135 +1000
@@ -160,11 +160,6 @@ xfs_mount_free(
 	xfs_mount_t	*mp,
 	int		remove_bhv)
 {
-	if (mp->m_ihash)
-		xfs_ihash_free(mp);
-	if (mp->m_chash)
-		xfs_chash_free(mp);
-
 	if (mp->m_perag) {
 		int	agno;
 
@@ -396,12 +391,22 @@ xfs_initialize_perag(
 			pag->pagi_inodeok = 1;
 			if (index < max_metadata)
 				pag->pagf_metadata = 1;
+			if (!pag->pag_ici_init) {
+				rwlock_init(&pag->pag_ici_lock);
+				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+				pag->pag_ici_init = 1;
+			}
 		}
 	} else {
 		/* Setup default behavior for smaller filesystems */
 		for (index = 0; index < agcount; index++) {
 			pag = &mp->m_perag[index];
 			pag->pagi_inodeok = 1;
+			if (!pag->pag_ici_init) {
+				rwlock_init(&pag->pag_ici_lock);
+				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+				pag->pag_ici_init = 1;
+			}
 		}
 	}
 	return index;
@@ -1033,13 +1038,6 @@ xfs_mountfs(
 	xfs_trans_init(mp);
 
 	/*
-	 * Allocate and initialize the inode hash table for this
-	 * file system.
-	 */
-	xfs_ihash_init(mp);
-	xfs_chash_init(mp);
-
-	/*
 	 * Allocate and initialize the per-ag data.
 	 */
 	init_rwsem(&mp->m_peraglock);
@@ -1190,8 +1188,6 @@ xfs_mountfs(
  error3:
 	xfs_log_unmount_dealloc(mp);
  error2:
-	xfs_ihash_free(mp);
-	xfs_chash_free(mp);
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
 		if (mp->m_perag[agno].pagb_list)
 			kmem_free(mp->m_perag[agno].pagb_list,
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-08-09 13:01:41.701951716 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-08-09 13:03:53.161036135 +1000
@@ -57,10 +57,7 @@ struct log;
 struct bhv_vfs;
 struct bhv_vnode;
 struct xfs_mount_args;
-struct xfs_ihash;
-struct xfs_chash;
 struct xfs_inode;
-struct xfs_perag;
 struct xfs_iocore;
 struct xfs_bmbt_irec;
 struct xfs_bmap_free;
@@ -335,8 +332,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	lock_t			m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	size_t			m_ihsize;	/* size of next field */
-	struct xfs_ihash	*m_ihash;	/* fs private inode hash table*/
 	struct xfs_inode	*m_inodes;	/* active inode list */
 	struct list_head	m_del_inodes;	/* inodes to reclaim */
 	mutex_t			m_ilock;	/* inode list mutex */
@@ -458,7 +453,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_IDELETE	(1ULL << 18)	/* delete empty inode clusters*/
 #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
 						 * allocation */
-#define XFS_MOUNT_IHASHSIZE	(1ULL << 20)	/* inode hash table size */
+			     /*	(1ULL << 20)	-- currently unused */
 #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
 #define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
 						 * I/O size in stat() */
@@ -572,6 +567,21 @@ xfs_daddr_to_agbno(struct xfs_mount *mp,
 }
 
 /*
+ * perag get/put wrappers for eventual ref counting
+ */
+static inline xfs_perag_t *
+xfs_get_perag(struct xfs_mount *mp, xfs_ino_t ino)
+{
+	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
+}
+
+static inline void
+xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
+{
+	/* nothing to see here, move along */
+}
+
+/*
  * Per-cpu superblock locking functions
  */
 #ifdef HAVE_PERCPU_SB
Index: 2.6.x-xfs-new/fs/xfs/xfs_rename.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rename.c	2007-08-09 13:01:03.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rename.c	2007-08-09 13:03:53.181033562 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2007-08-09 13:00:12.381443746 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2007-08-09 13:03:53.181033562 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_extfree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_extfree.c	2007-08-09 13:00:12.381443746 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_extfree.c	2007-08-09 13:03:53.181033562 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-08-09 13:01:10.829923854 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-08-09 13:03:53.185033047 +1000
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
@@ -246,7 +246,6 @@ xfs_start_flags(
 			ap->logbufsize);
 		return XFS_ERROR(EINVAL);
 	}
-	mp->m_ihsize = ap->ihashsize;
 	mp->m_logbsize = ap->logbufsize;
 	mp->m_fsname_len = strlen(ap->fsname) + 1;
 	mp->m_fsname = kmem_alloc(mp->m_fsname_len, KM_SLEEP);
@@ -293,8 +292,6 @@ xfs_start_flags(
 		mp->m_readio_log = mp->m_writeio_log = ap->iosizelog;
 	}
 
-	if (ap->flags & XFSMNT_IHASHSIZE)
-		mp->m_flags |= XFS_MOUNT_IHASHSIZE;
 	if (ap->flags & XFSMNT_IDELETE)
 		mp->m_flags |= XFS_MOUNT_IDELETE;
 	if (ap->flags & XFSMNT_DIRSYNC)
@@ -1693,7 +1690,6 @@ xfs_vget(
 #define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
 #define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
 #define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
-#define MNTOPT_IHASHSIZE    "ihashsize"    /* size of inode hash table */
 #define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
 #define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
 					 * unwritten extent conversion */
@@ -1819,15 +1815,6 @@ xfs_parseargs(
 			iosize = suffix_strtoul(value, &eov, 10);
 			args->flags |= XFSMNT_IOSIZE;
 			args->iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_IHASHSIZE)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			args->flags |= XFSMNT_IHASHSIZE;
-			args->ihashsize = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
 			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
 			vfsp->vfs_flag |= VFS_GRPID;
@@ -1986,9 +1973,6 @@ xfs_showargs(
 			seq_puts(m, xfs_infop->str);
 	}
 
-	if (mp->m_flags & XFS_MOUNT_IHASHSIZE)
-		seq_printf(m, "," MNTOPT_IHASHSIZE "=%d", (int)mp->m_ihsize);
-
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
 				(int)(1 << mp->m_writeio_log) >> 10);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-08-09 13:01:41.781941424 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-08-09 13:03:53.185033047 +1000
@@ -3876,7 +3876,7 @@ xfs_finish_reclaim(
 	int		locked,
 	int		sync_mode)
 {
-	xfs_ihash_t	*ih = ip->i_hash;
+	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
 	bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 	int		error;
 
@@ -3888,12 +3888,12 @@ xfs_finish_reclaim(
 	 * Once we have the XFS_IRECLAIM flag set it will not touch
 	 * us.
 	 */
-	write_lock(&ih->ih_lock);
+	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
 	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&ih->ih_lock);
+		write_unlock(&pag->pag_ici_lock);
 		if (locked) {
 			xfs_ifunlock(ip);
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3902,7 +3902,8 @@ xfs_finish_reclaim(
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&ih->ih_lock);
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(ip->i_mount, pag);
 
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
