Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 00:18:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9O7ICaG031089
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 00:18:14 -0700
Date: Tue, 24 Oct 2006 17:17:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: [REVIEW 1 of 4] Clean up i_flags handling
Message-ID: <20061024071723.GR11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: t-nagano@ah.jp.nec.com, xfs-dev@sgi.com


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Clean up new iflags locking and flags handling.
---
 fs/xfs/linux-2.6/xfs_super.c |    4 +---
 fs/xfs/xfs_iget.c            |   20 ++++++--------------
 fs/xfs/xfs_inode.c           |   17 +++++------------
 fs/xfs/xfs_inode.h           |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_vnodeops.c        |   10 ++++------
 5 files changed, 57 insertions(+), 35 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2006-10-19 10:22:12.769108692 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2006-10-19 10:25:07.330516048 +1000
@@ -227,9 +227,7 @@ xfs_initialize_vnode(
 		xfs_revalidate_inode(XFS_BHVTOM(bdp), vp, ip);
 		xfs_set_inodeops(inode);
 
-		spin_lock(&ip->i_flags_lock);
-		ip->i_flags &= ~XFS_INEW;
-		spin_unlock(&ip->i_flags_lock);
+		xfs_iflags_clear(ip, XFS_INEW);
 		barrier();
 
 		unlock_new_inode(inode);
Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2006-10-19 10:22:12.769108692 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2006-10-19 10:25:07.330516048 +1000
@@ -215,7 +215,7 @@ again:
 			 * If INEW is set this inode is being set up
 			 * we need to pause and try again.
 			 */
-			if (ip->i_flags & XFS_INEW) {
+			if (xfs_iflags_test(ip, XFS_INEW)) {
 				read_unlock(&ih->ih_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
@@ -230,7 +230,7 @@ again:
 				 * on its way out of the system,
 				 * we need to pause and try again.
 				 */
-				if (ip->i_flags & XFS_IRECLAIM) {
+				if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
 					read_unlock(&ih->ih_lock);
 					delay(1);
 					XFS_STATS_INC(xs_ig_frecycle);
@@ -243,9 +243,7 @@ again:
 
 				XFS_STATS_INC(xs_ig_found);
 
-				spin_lock(&ip->i_flags_lock);
-				ip->i_flags &= ~XFS_IRECLAIMABLE;
-				spin_unlock(&ip->i_flags_lock);
+				xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 				version = ih->ih_version;
 				read_unlock(&ih->ih_lock);
 				xfs_ihash_promote(ih, ip, version);
@@ -299,10 +297,7 @@ finish_inode:
 			if (lock_flags != 0)
 				xfs_ilock(ip, lock_flags);
 
-			spin_lock(&ip->i_flags_lock);
-			ip->i_flags &= ~XFS_ISTALE;
-			spin_unlock(&ip->i_flags_lock);
-
+			xfs_iflags_clear(ip, XFS_ISTALE);
 			vn_trace_exit(vp, "xfs_iget.found",
 						(inst_t *)__return_address);
 			goto return_ip;
@@ -371,10 +366,7 @@ finish_inode:
 	ih->ih_next = ip;
 	ip->i_udquot = ip->i_gdquot = NULL;
 	ih->ih_version++;
-	spin_lock(&ip->i_flags_lock);
-	ip->i_flags |= XFS_INEW;
-	spin_unlock(&ip->i_flags_lock);
-
+	xfs_iflags_set(ip, XFS_INEW);
 	write_unlock(&ih->ih_lock);
 
 	/*
@@ -625,7 +617,7 @@ xfs_iput_new(xfs_inode_t	*ip,
 	vn_trace_entry(vp, "xfs_iput_new", (inst_t *)__return_address);
 
 	if ((ip->i_d.di_mode == 0)) {
-		ASSERT(!(ip->i_flags & XFS_IRECLAIMABLE));
+		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
 		vn_mark_bad(vp);
 	}
 	if (inode->i_state & I_NEW)
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-19 10:22:12.769108692 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-19 10:25:07.334515530 +1000
@@ -2193,7 +2193,7 @@ xfs_ifree_cluster(
 			/* Inode not in memory or we found it already,
 			 * nothing to do
 			 */
-			if (!ip || (ip->i_flags & XFS_ISTALE)) {
+			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
 				read_unlock(&ih->ih_lock);
 				continue;
 			}
@@ -2215,10 +2215,7 @@ xfs_ifree_cluster(
 
 			if (ip == free_ip) {
 				if (xfs_iflock_nowait(ip)) {
-					spin_lock(&ip->i_flags_lock);
-					ip->i_flags |= XFS_ISTALE;
-					spin_unlock(&ip->i_flags_lock);
-
+					xfs_iflags_set(ip, XFS_ISTALE);
 					if (xfs_inode_clean(ip)) {
 						xfs_ifunlock(ip);
 					} else {
@@ -2231,9 +2228,7 @@ xfs_ifree_cluster(
 
 			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
 				if (xfs_iflock_nowait(ip)) {
-					spin_lock(&ip->i_flags_lock);
-					ip->i_flags |= XFS_ISTALE;
-					spin_unlock(&ip->i_flags_lock);
+					xfs_iflags_set(ip, XFS_ISTALE);
 
 					if (xfs_inode_clean(ip)) {
 						xfs_ifunlock(ip);
@@ -2263,9 +2258,7 @@ xfs_ifree_cluster(
 				AIL_LOCK(mp,s);
 				iip->ili_flush_lsn = iip->ili_item.li_lsn;
 				AIL_UNLOCK(mp, s);
-				spin_lock(&iip->ili_inode->i_flags_lock);
-				iip->ili_inode->i_flags |= XFS_ISTALE;
-				spin_unlock(&iip->ili_inode->i_flags_lock);
+				xfs_iflags_set(ip, XFS_ISTALE);
 				pre_flushed++;
 			}
 			lip = lip->li_bio_list;
@@ -2764,7 +2757,7 @@ xfs_iunpin(
 		struct inode *inode = NULL;
 
 		spin_lock(&ip->i_flags_lock);
-		if (!(ip->i_flags & (XFS_IRECLAIM|XFS_IRECLAIMABLE))) {
+		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
 			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 
 			/* make sync come back and flush this inode */
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2006-10-19 10:22:12.769108692 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2006-10-19 10:25:07.334515530 +1000
@@ -305,6 +305,47 @@ typedef struct xfs_inode {
 #endif
 } xfs_inode_t;
 
+
+/*
+ * i_flags helper functions
+ */
+static inline void
+__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+{
+	ip->i_flags |= flags;
+}
+
+static inline void
+xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+{
+	spin_lock(&ip->i_flags_lock);
+	__xfs_iflags_set(ip, flags);
+	spin_unlock(&ip->i_flags_lock);
+}
+
+static inline void
+xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+{
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags &= ~flags;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+static inline int
+__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+{
+	return (ip->i_flags & flags);
+}
+
+static inline int
+xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+{
+	int ret;
+	spin_lock(&ip->i_flags_lock);
+	ret = __xfs_iflags_test(ip, flags);
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
 #endif	/* __KERNEL__ */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2006-10-19 10:22:12.769108692 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2006-10-19 10:25:07.338515013 +1000
@@ -3844,9 +3844,7 @@ xfs_reclaim(
 		XFS_MOUNT_ILOCK(mp);
 		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
-		spin_lock(&ip->i_flags_lock);
-		ip->i_flags |= XFS_IRECLAIMABLE;
-		spin_unlock(&ip->i_flags_lock);
+		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		XFS_MOUNT_IUNLOCK(mp);
 	}
 	return 0;
@@ -3872,8 +3870,8 @@ xfs_finish_reclaim(
 	 */
 	write_lock(&ih->ih_lock);
 	spin_lock(&ip->i_flags_lock);
-	if ((ip->i_flags & XFS_IRECLAIM) ||
-	    (!(ip->i_flags & XFS_IRECLAIMABLE) && vp == NULL)) {
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
+	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&ih->ih_lock);
 		if (locked) {
@@ -3882,7 +3880,7 @@ xfs_finish_reclaim(
 		}
 		return 1;
 	}
-	ip->i_flags |= XFS_IRECLAIM;
+	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	write_unlock(&ih->ih_lock);
 
