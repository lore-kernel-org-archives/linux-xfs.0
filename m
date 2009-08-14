Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7ED2Q5e104565 for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 08:02:42 -0500
Received: from intranet.easterngraphics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E4F71B6DA0E
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 06:03:07 -0700 (PDT)
Received: from intranet.easterngraphics.com (intranet.easterngraphics.com
	[62.80.28.49]) by cuda.sgi.com with ESMTP id puXzDBfh8fyLEQ8f
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 06:03:07 -0700 (PDT)
From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: xfs crash, kernel 2.6.29
Date: Fri, 14 Aug 2009 15:02:30 +0200
References: <200908110921.50752.Christian.Fischer@easterngraphics.com>
	<20090811142029.GB30913@infradead.org>
In-Reply-To: <20090811142029.GB30913@infradead.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mBWhK9/P10gJ6AO"
Message-Id: <200908141502.30887.Christian.Fischer@easterngraphics.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Lyon <andrew.lyon@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--Boundary-00=_mBWhK9/P10gJ6AO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 11 August 2009, Christoph Hellwig wrote:
> On Tue, Aug 11, 2009 at 09:21:50AM +0200, Christian Fischer wrote:
> > We had a new crash yesterday, server uptime maybe 20 hours.
> >
> > This is 2.6.29-xen-r4 from
> > http://code.google.com/p/gentoo-xen-kernel/downloads/list
> >
> > @Eric/Andrew: do we have a xfs or a xen patches problem?
>
> It's a known bug that we just fixed in 2.6.31-rc.  Can you check if this
> patch
>
> 	http://bugzilla.kernel.org/attachment.cgi?id=22590
>
> applies to 2.6.29 (I produced it against 2.6.30)
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Well, attached the patch.


--Boundary-00=_mBWhK9/P10gJ6AO
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="xfs_mine.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs_mine.diff"

diff -Nurp linux-2.6.29-xen-r4.orig/fs/exportfs/Makefile linux-2.6.29-xen-r4/fs/exportfs/Makefile
--- linux-2.6.29-xen-r4.orig/fs/exportfs/Makefile	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/exportfs/Makefile	2009-08-14 10:36:22.572098064 +0200
@@ -1,6 +1,8 @@
 #
 # Makefile for the filesystem export support routines.
 
+EXTRA_CFLAGS += -I$(src)/../../fs/xfs -I$(src)/../../fs/xfs/linux-2.6
+
 obj-$(CONFIG_EXPORTFS) += exportfs.o
 
 exportfs-objs := expfs.o
diff -Nurp linux-2.6.29-xen-r4.orig/fs/exportfs/expfs.c linux-2.6.29-xen-r4/fs/exportfs/expfs.c
--- linux-2.6.29-xen-r4.orig/fs/exportfs/expfs.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/exportfs/expfs.c	2009-08-14 10:39:58.917630424 +0200
@@ -15,6 +15,11 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
+#include "xfs.h"
+#include "xfs_inum.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
 
 #define dprintk(fmt, args...) do{}while(0)
 
@@ -187,8 +192,25 @@ reconnect_path(struct vfsmount *mnt, str
 			 */
 			if (npd == pd)
 				noprogress = 0;
-			else
+			else {
 				printk("%s: npd != pd\n", __func__);
+				if (npd->d_inode) {
+					printk("npd = 0x%p, inode = 0%p, ino = 0x%llx\n",
+						npd, npd->d_inode,
+						(unsigned long long)npd->d_inode->i_ino);
+					printk("i_state = 0x%lx, i_flags = 0x%x\n",
+						npd->d_inode->i_state,
+						XFS_I(npd->d_inode)->i_flags);
+				}
+				if (pd->d_inode) {
+					printk("pd = 0x%p, inode = 0%p, ino = 0x%llx\n",
+						pd, pd->d_inode,
+						(unsigned long long)pd->d_inode->i_ino);
+					printk("i_state = 0x%lx, i_flags = 0x%x\n",
+						pd->d_inode->i_state,
+						XFS_I(pd->d_inode)->i_flags);
+				}
+			}
 			dput(npd);
 			dput(ppd);
 			if (IS_ROOT(pd)) {
diff -Nurp linux-2.6.29-xen-r4.orig/fs/inode.c linux-2.6.29-xen-r4/fs/inode.c
--- linux-2.6.29-xen-r4.orig/fs/inode.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/inode.c	2009-08-14 14:08:17.373785137 +0200
@@ -117,7 +117,7 @@ static void wake_up_inode(struct inode *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
  */
-struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
+int inode_init_always(struct super_block *sb, struct inode *inode)
 {
 	static const struct address_space_operations empty_aops;
 	static struct inode_operations empty_iops;
@@ -147,14 +147,10 @@ struct inode *inode_init_always(struct s
 	inode->i_cdev = NULL;
 	inode->i_rdev = 0;
 	inode->dirtied_when = 0;
-	if (security_inode_alloc(inode)) {
-		if (inode->i_sb->s_op->destroy_inode)
-			inode->i_sb->s_op->destroy_inode(inode);
-		else
-			kmem_cache_free(inode_cachep, (inode));
-		return NULL;
-	}
-
+	
+	if (security_inode_alloc(inode))
+		return -ENOMEM;
+	
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -188,7 +184,7 @@ struct inode *inode_init_always(struct s
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 
-	return inode;
+	return 0;
 }
 EXPORT_SYMBOL(inode_init_always);
 
@@ -201,22 +197,34 @@ static struct inode *alloc_inode(struct 
 	else
 		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
 
-	if (inode)
-		return inode_init_always(sb, inode);
-	return NULL;
+	if (!inode)
+		return NULL;
+	
+	if (unlikely(inode_init_always(sb, inode))) {
+		if (inode->i_sb->s_op->destroy_inode)
+			inode->i_sb->s_op->destroy_inode(inode);
+		else
+			kmem_cache_free(inode_cachep, inode);
+	}
+	
+	return inode;
 }
 
-void destroy_inode(struct inode *inode) 
+void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+}
+EXPORT_SYMBOL(__destroy_inode);
+
+void destroy_inode(struct inode *inode)
+{
+	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
 		kmem_cache_free(inode_cachep, (inode));
 }
-EXPORT_SYMBOL(destroy_inode);
-
 
 /*
  * These are initializations that only need to be done
diff -Nurp linux-2.6.29-xen-r4.orig/fs/xfs/linux-2.6/xfs_sync.c linux-2.6.29-xen-r4/fs/xfs/linux-2.6/xfs_sync.c
--- linux-2.6.29-xen-r4.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/xfs/linux-2.6/xfs_sync.c	2009-08-14 09:43:47.487023831 +0200
@@ -619,6 +619,17 @@ xfs_reclaim_inode(
 	return 0;
 }
 
+void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	radix_tree_tag_set(&pag->pag_ici_root,
+		XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+		XFS_ICI_RECLAIM_TAG);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+}
+
 /*
  * We set the inode flag atomically with the radix tree tag.
  * Once we get tag lookups on the radix tree, this inode flag
@@ -633,9 +644,7 @@ xfs_inode_set_reclaim_tag(
 
 	read_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
-	radix_tree_tag_set(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	__xfs_inode_set_reclaim_tag(pag, ip);
 	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
@@ -643,27 +652,13 @@ xfs_inode_set_reclaim_tag(
 
 void
 __xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
+	ip->i_flags &= ~XFS_IRECLAIMABLE;
 	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-}
-
-void
-xfs_inode_clear_reclaim_tag(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
-
-	read_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	spin_unlock(&ip->i_flags_lock);
-	read_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(mp, pag);
+		XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+		XFS_ICI_RECLAIM_TAG);
 }
 
 
diff -Nurp linux-2.6.29-xen-r4.orig/fs/xfs/linux-2.6/xfs_sync.h linux-2.6.29-xen-r4/fs/xfs/linux-2.6/xfs_sync.h
--- linux-2.6.29-xen-r4.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/xfs/linux-2.6/xfs_sync.h	2009-08-14 10:41:10.087152772 +0200
@@ -49,7 +49,6 @@ int xfs_reclaim_inode(struct xfs_inode *
 int xfs_reclaim_inodes(struct xfs_mount *mp, int noblock, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
-void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
-void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
-				struct xfs_inode *ip);
+void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
 #endif
diff -Nurp linux-2.6.29-xen-r4.orig/fs/xfs/xfs_iget.c linux-2.6.29-xen-r4/fs/xfs/xfs_iget.c
--- linux-2.6.29-xen-r4.orig/fs/xfs/xfs_iget.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/xfs/xfs_iget.c	2009-08-14 09:36:23.472454929 +0200
@@ -64,20 +64,20 @@ xfs_inode_alloc(
 	if (!ip)
 		return NULL;
 
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
-
 	/*
 	 * initialise the VFS inode here to get failures
 	 * out of the way early.
 	 */
-	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+	if (inode_init_always(mp->m_super, VFS_I(ip))) {
 		kmem_zone_free(xfs_inode_zone, ip);
 		return NULL;
 	}
 
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(completion_done(&ip->i_flush));
+
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
@@ -114,9 +114,77 @@ xfs_inode_alloc(
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
 
+	/* prevent anyone from using this yet */
+	VFS_I(ip)->i_state = I_NEW|I_LOCK;
+
 	return ip;
 }
 
+STATIC void
+xfs_inode_free(
+	struct xfs_inode	*ip)
+{
+	switch (ip->i_d.di_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		xfs_idestroy_fork(ip, XFS_DATA_FORK);
+		break;
+	}
+	
+	if (ip->i_afp)
+		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+
+#ifdef XFS_INODE_TRACE
+	ktrace_free(ip->i_trace);
+#endif
+#ifdef XFS_BMAP_TRACE
+	ktrace_free(ip->i_xtrace);
+#endif
+#ifdef XFS_BTREE_TRACE
+	ktrace_free(ip->i_btrace);
+#endif
+#ifdef XFS_RW_TRACE
+	ktrace_free(ip->i_rwtrace);
+#endif
+#ifdef XFS_ILOCK_TRACE
+	ktrace_free(ip->i_lock_trace);
+#endif
+#ifdef XFS_DIR2_TRACE
+	ktrace_free(ip->i_dir_trace);
+#endif
+	
+	if (ip->i_itemp) {
+		/*
+		 * Only if we are shutting down the fs will we see an
+		 * inode still in the AIL. If it is there, we should remove
+		 * it to prevent a use-after-free from occurring.
+		 */
+		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+		struct xfs_ail	*ailp = lip->li_ailp;
+
+		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
+				XFS_FORCED_SHUTDOWN(ip->i_mount));
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			spin_lock(&ailp->xa_lock);
+			if (lip->li_flags & XFS_LI_IN_AIL)
+				xfs_trans_ail_delete(ailp, lip);
+			else
+				spin_unlock(&ailp->xa_lock);
+		}
+		xfs_inode_item_destroy(ip);
+		ip->i_itemp = NULL;
+	}
+	
+	/* asserts to verify all state is correct here */
+	ASSERT(atomic_read(&ip->i_iocount) == 0);
+	ASSERT(atomic_read(&ip->i_pincount) == 0);
+	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	ASSERT(completion_done(&ip->i_flush));
+	
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -127,80 +195,90 @@ xfs_iget_cache_hit(
 	int			flags,
 	int			lock_flags) __releases(pag->pag_ici_lock)
 {
+	struct inode		*inode = VFS_I(ip);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = EAGAIN;
+	int			error;
+
+	spin_lock(&ip->i_flags_lock);
 
 	/*
-	 * If INEW is set this inode is being set up
-	 * If IRECLAIM is set this inode is being torn down
-	 * Pause and try again.
+	 * This inode is being torn down, pause and try again.
 	 */
-	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
+	if (ip->i_flags & XFS_IRECLAIM) {
 		XFS_STATS_INC(xs_ig_frecycle);
+		error = EAGAIN;
 		goto out_error;
 	}
 
-	/* If IRECLAIMABLE is set, we've torn down the vfs inode part */
-	if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
-
-		/*
-		 * If lookup is racing with unlink, then we should return an
-		 * error immediately so we don't remove it from the reclaim
-		 * list and potentially leak the inode.
-		 */
-		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-			error = ENOENT;
-			goto out_error;
-		}
-
+	/*
+	 * If we are racing with another cache hit that is currently recycling
+	 * this inode out of the XFS_IRECLAIMABLE state, wait for the
+	 * initialisation to complete before continuing.
+	 */
+	if (ip->i_flags & XFS_INEW) {
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
+		XFS_STATS_INC(xs_ig_frecycle);
+		wait_on_inode(inode);
+		return EAGAIN;
+	}
+	
+	/*
+	 * If lookup is racing with unlink, then we should return an
+	 * error immediately so we don't remove it from the reclaim
+	 * list and potentially leak the inode.
+	 */
+	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
+		error = ENOENT;
+		goto out_error;
+	}
+	
+	/*
+	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
+	 * Need to carefully get it back into useable state.
+	 */
+	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 		/*
-		 * We need to re-initialise the VFS inode as it has been
-		 * 'freed' by the VFS. Do this here so we can deal with
-		 * errors cleanly, then tag it so it can be set up correctly
-		 * later.
+		 * We need to set XFS_INEW atomically with clearing the
+		 * reclaimable tag so that we do have an indicator of the
+		 * inode still being initialized.
 		 */
-		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		ip->i_flags |= XFS_INEW;
+		__xfs_inode_clear_reclaim_tag(pag, ip);
+		
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
+		
+		if (unlikely(inode_init_always(mp->m_super, inode))) {
+			/*
+			 * Re-initializing the inode failed, and we are in deep
+			 * trouble.  Try to re-add it to the reclaim list.
+			 */
+			read_lock(&pag->pag_ici_lock);
+			spin_lock(&ip->i_flags_lock);
+			
+			ip->i_flags &= ~XFS_INEW;
+			__xfs_inode_set_reclaim_tag(pag, ip);
+
 			error = ENOMEM;
 			goto out_error;
 		}
-
-		/*
-		 * We must set the XFS_INEW flag before clearing the
-		 * XFS_IRECLAIMABLE flag so that if a racing lookup does
-		 * not find the XFS_IRECLAIMABLE above but has the igrab()
-		 * below succeed we can safely check XFS_INEW to detect
-		 * that this inode is still being initialised.
-		 */
-		xfs_iflags_set(ip, XFS_INEW);
-		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-
-		/* clear the radix tree reclaim flag as well. */
-		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
-	} else if (!igrab(VFS_I(ip))) {
+		
+		inode->i_state = I_LOCK|I_NEW;
+	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
-		XFS_STATS_INC(xs_ig_frecycle);
-		goto out_error;
-	} else if (xfs_iflags_test(ip, XFS_INEW)) {
-		/*
-		 * We are racing with another cache hit that is
-		 * currently recycling this inode out of the XFS_IRECLAIMABLE
-		 * state. Wait for the initialisation to complete before
-		 * continuing.
-		 */
-		wait_on_inode(VFS_I(ip));
-	}
-
-	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
-		iput(VFS_I(ip));
-		goto out_error;
+		if (!igrab(inode)) {
+			error = EAGAIN;
+			goto out_error;
+		}
+		
+		/* We've got a live one. */
+		spin_unlock(&ip->i_flags_lock);
+		read_unlock(&pag->pag_ici_lock);
 	}
 
-	/* We've got a live one. */
-	read_unlock(&pag->pag_ici_lock);
-
 	if (lock_flags != 0)
 		xfs_ilock(ip, lock_flags);
 
@@ -210,6 +288,7 @@ xfs_iget_cache_hit(
 	return 0;
 
 out_error:
+	spin_unlock(&ip->i_flags_lock);
 	read_unlock(&pag->pag_ici_lock);
 	return error;
 }
@@ -293,7 +372,8 @@ out_preload_end:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
 out_destroy:
-	xfs_destroy_inode(ip);
+	__destroy_inode(VFS_I(ip));
+	xfs_inode_free(ip);
 	return error;
 }
 
@@ -470,17 +550,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	ASSERT(radix_tree_lookup(&pag->pag_ici_root, agino));
+	radix_tree_delete(&pag->pag_ici_root, agino);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
@@ -500,63 +584,7 @@ xfs_ireclaim(
 	 */
 	XFS_QM_DQDETACH(ip->i_mount, ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
-	switch (ip->i_d.di_mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFDIR:
-	case S_IFLNK:
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-		break;
-	}
-
-	if (ip->i_afp)
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-
-#ifdef XFS_INODE_TRACE
-	ktrace_free(ip->i_trace);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(ip->i_xtrace);
-#endif
-#ifdef XFS_BTREE_TRACE
-	ktrace_free(ip->i_btrace);
-#endif
-#ifdef XFS_RW_TRACE
-	ktrace_free(ip->i_rwtrace);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ktrace_free(ip->i_lock_trace);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(ip->i_dir_trace);
-#endif
-	if (ip->i_itemp) {
-		/*
-		 * Only if we are shutting down the fs will we see an
-		 * inode still in the AIL. If it is there, we should remove
-		 * it to prevent a use-after-free from occurring.
-		 */
-		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-		struct xfs_ail	*ailp = lip->li_ailp;
-
-		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
-				       XFS_FORCED_SHUTDOWN(ip->i_mount));
-		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&ailp->xa_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
-			else
-				spin_unlock(&ailp->xa_lock);
-		}
-		xfs_inode_item_destroy(ip);
-		ip->i_itemp = NULL;
-	}
-	/* asserts to verify all state is correct here */
-	ASSERT(atomic_read(&ip->i_iocount) == 0);
-	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
-	kmem_zone_free(xfs_inode_zone, ip);
+	xfs_inode_free(ip);
 }
 
 /*
diff -Nurp linux-2.6.29-xen-r4.orig/fs/xfs/xfs_inode.h linux-2.6.29-xen-r4/fs/xfs/xfs_inode.h
--- linux-2.6.29-xen-r4.orig/fs/xfs/xfs_inode.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/fs/xfs/xfs_inode.h	2009-08-14 10:35:44.458392694 +0200
@@ -309,23 +309,6 @@ static inline struct inode *VFS_I(struct
 }
 
 /*
- * Get rid of a partially initialized inode.
- *
- * We have to go through destroy_inode to make sure allocations
- * from init_inode_always like the security data are undone.
- *
- * We mark the inode bad so that it takes the short cut in
- * the reclaim path instead of going through the flush path
- * which doesn't make sense for an inode that has never seen the
- * light of day.
- */
-static inline void xfs_destroy_inode(struct xfs_inode *ip)
-{
-	make_bad_inode(VFS_I(ip));
-	return destroy_inode(VFS_I(ip));
-}
-
-/*
  * i_flags helper functions
  */
 static inline void
diff -Nurp linux-2.6.29-xen-r4.orig/include/linux/fs.h linux-2.6.29-xen-r4/include/linux/fs.h
--- linux-2.6.29-xen-r4.orig/include/linux/fs.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-xen-r4/include/linux/fs.h	2009-08-14 10:34:54.366761940 +0200
@@ -1905,7 +1905,7 @@ extern loff_t default_llseek(struct file
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
-extern struct inode * inode_init_always(struct super_block *, struct inode *);
+extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
@@ -1932,6 +1932,7 @@ extern void __iget(struct inode * inode)
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
+extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);

--Boundary-00=_mBWhK9/P10gJ6AO
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Boundary-00=_mBWhK9/P10gJ6AO--
