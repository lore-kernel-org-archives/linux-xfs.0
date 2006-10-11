Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Oct 2006 23:45:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9B6iuaG021345
	for <xfs@oss.sgi.com>; Tue, 10 Oct 2006 23:44:59 -0700
Date: Wed, 11 Oct 2006 16:43:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061011064357.GN19345@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061006032617.GC11034@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 06, 2006 at 01:26:17PM +1000, David Chinner wrote:
> I think this is a much better way of fixing the problem, but it needs
> a little tweaking. Also, it indicates that we can probably revert
> some of the previous changes made in attempting to fix this bug.
> I'll put together a new patch with this fix and as much of the
> other fixes removed as possible and run some tests on it here.
> It'l be a day or two before I have a tested patch ready....

I've run the attached patch through xfsqa but have not stress tested
it yet.

Takenori - can you give this a run through your tests to see if
it passes. I expect any races to trigger the BUG_ON statements
in xfs_iunpin().

This patch sits on top of iflags locking cleanup I posted here:

http://oss.sgi.com/archives/xfs/2006-10/msg00014.html

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_inode.c    |   59 ++++++++++++++++++--------------------------------
 fs/xfs/xfs_inode.h    |    1 
 fs/xfs/xfs_vnodeops.c |   12 +++++++++-
 3 files changed, 34 insertions(+), 38 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-11 14:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-11 14:33:59.055638165 +1000
@@ -2728,9 +2728,16 @@ xfs_ipin(
 }
 
 /*
- * Decrement the pin count of the given inode, and wake up
- * anyone in xfs_iwait_unpin() if the count goes to 0.  The
- * inode must have been previously pinned with a call to xfs_ipin().
+ * Decrement the pin count of the given inode, and wake up anyone in
+ * xfs_iunpin_wait() if the count goes to 0.  The inode must have been
+ * previously pinned with a call to xfs_ipin().
+ *
+ * Note that xfs_reclaim() _must_ wait for all transactions to complete by
+ * calling xfs_iunpin_wait() before either reclaiming the linux inode or
+ * breaking the link between the xfs_inode and the xfs_vnode to prevent races
+ * and use-after-frees here in this code due to asynchronous log I/O
+ * completion. Hence we should never see the XFS_IRECLAIM* state,
+ * a NULL vnode or a linu xinode with I_CLEAR set here.
  */
 void
 xfs_iunpin(
@@ -2739,41 +2746,19 @@ xfs_iunpin(
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
 	if (atomic_dec_and_test(&ip->i_pincount)) {
-		/*
-		 * If the inode is currently being reclaimed, the
-		 * linux inode _and_ the xfs vnode may have been
-		 * freed so we cannot reference either of them safely.
-		 * Hence we should not try to do anything to them
-		 * if the xfs inode is currently in the reclaim
-		 * path.
-		 *
-		 * However, we still need to issue the unpin wakeup
-		 * call as the inode reclaim may be blocked waiting for
-		 * the inode to become unpinned.
-		 */
-		struct inode *inode = NULL;
+		bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
+		struct inode	*inode;
+
+		BUG_ON(xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE));
+		BUG_ON(vp == NULL);
+
+		/* make sync come back and flush this inode */
+		inode = vn_to_inode(vp);
+		BUG_ON(inode->i_state & I_CLEAR);
+		if (!(inode->i_state & (I_NEW|I_FREEING)))
+			mark_inode_dirty_sync(inode);
 
-		spin_lock(&ip->i_flags_lock);
-		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
-			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
-
-			/* make sync come back and flush this inode */
-			if (vp) {
-				inode = vn_to_inode(vp);
-
-				if (!(inode->i_state &
-						(I_NEW|I_FREEING|I_CLEAR))) {
-					inode = igrab(inode);
-					if (inode)
-						mark_inode_dirty_sync(inode);
-				} else
-					inode = NULL;
-			}
-		}
-		spin_unlock(&ip->i_flags_lock);
 		wake_up(&ip->i_ipin_wait);
-		if (inode)
-			xfs_inode_iput(ip);
 	}
 }
 
@@ -2784,7 +2769,7 @@ xfs_iunpin(
  * be subsequently pinned once someone is waiting for it to be
  * unpinned.
  */
-STATIC void
+void
 xfs_iunpin_wait(
 	xfs_inode_t	*ip)
 {
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2006-10-11 14:01:46.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2006-10-11 14:18:08.307190867 +1000
@@ -3817,7 +3817,17 @@ xfs_reclaim(
 		return 0;
 	}
 
+	/*
+	 * We can't reclaim the inode until all I/O has completed, and we don't
+	 * want to break the link between the vnode and xfs_inode until all log
+	 * transactions have been written to disk.  By waiting here we provide
+	 * the guarantee to xfs_iunpin that the linux inode will always be
+	 * referencable because it won't be freed until after this wait and no
+	 * new transactions can be issued on this inode now.
+	 */
 	vn_iowait(vp);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_iunpin_wait(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
@@ -3834,12 +3844,12 @@ xfs_reclaim(
 	 * itself.
 	 */
 	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_iflock(ip);
 		return xfs_finish_reclaim(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
 
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		/* Protect sync from us */
 		XFS_MOUNT_ILOCK(mp);
 		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2006-10-11 14:01:46.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2006-10-11 14:34:57.376058950 +1000
@@ -482,6 +482,7 @@ void		xfs_iext_realloc(xfs_inode_t *, in
 void		xfs_iroot_realloc(xfs_inode_t *, int, int);
 void		xfs_ipin(xfs_inode_t *);
 void		xfs_iunpin(xfs_inode_t *);
+void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_iflush_all(struct xfs_mount *);
