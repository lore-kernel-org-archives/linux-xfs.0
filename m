Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf1jF194340 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9620E141F77A
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	2a3ZXMURwcoH9YOY for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:33 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/19] xfs: simplify inode teardown
Date: Fri, 12 Mar 2010 09:41:59 +1100
Message-Id: <1268347337-7160-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

>From 848ce8f731aed0a2d4ab5884a4f6664af73d2dd0
Date: Tue, 29 Sep 2009 13:48:56 +0000
Currently the reclaim code for the case where we don't reclaim the
final reclaim is overly complicated.  We know that the inode is clean
but instead of just directly reclaiming the clean inode we go through
the whole process of marking the inode reclaimable just to directly
reclaim it from the calling context.  Besides being overly complicated
this introduces a race where iget could recycle an inode between
marked reclaimable and actually being reclaimed leading to panics.

This patch gets rid of the existing reclaim path, and replaces it with
a simple call to xfs_ireclaim if the inode was clean.  While we're at
it we also use the slightly more lax xfs_inode_clean check we'd use
later to determine if we need to flush the inode here.

Finally get rid of xfs_reclaim function and place the remaining small
bits of reclaim code directly into xfs_fs_destroy_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Patrick Schreurs <patrick@news-service.com>
Reported-by: Tommy van Leeuwen <tommy@news-service.com>
Tested-by: Patrick Schreurs <patrick@news-service.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   34 ++++++++++++++++++++++++++++++----
 fs/xfs/linux-2.6/xfs_sync.c  |   15 ++++-----------
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 fs/xfs/xfs_vnodeops.c        |   40 ----------------------------------------
 fs/xfs/xfs_vnodeops.h        |    1 -
 5 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 18a4b8e..a82a93d 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -930,13 +930,39 @@ xfs_fs_alloc_inode(
  */
 STATIC void
 xfs_fs_destroy_inode(
-	struct inode	*inode)
+	struct inode		*inode)
 {
-	xfs_inode_t		*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	xfs_itrace_entry(ip);
 
 	XFS_STATS_INC(vn_reclaim);
-	if (xfs_reclaim(ip))
-		panic("%s: cannot reclaim 0x%p\n", __func__, inode);
+
+	/* bad inode, get out here ASAP */
+	if (is_bad_inode(inode))
+		goto out_reclaim;
+
+	xfs_ioend_wait(ip);
+
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * If we have nothing to flush with this inode then complete the
+	 * teardown now, otherwise delay the flush operation.
+	 */
+	if (!xfs_inode_clean(ip)) {
+		xfs_inode_set_reclaim_tag(ip);
+		return;
+	}
+
+out_reclaim:
+	xfs_ireclaim(ip);
 }
 
 /*
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 961df0a..d895a3a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -663,10 +663,9 @@ xfs_syncd_stop(
 	kthread_stop(mp->m_sync_task);
 }
 
-int
+STATIC int
 xfs_reclaim_inode(
 	xfs_inode_t	*ip,
-	int		locked,
 	int		sync_mode)
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
@@ -682,10 +681,6 @@ xfs_reclaim_inode(
 	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);
-		if (locked) {
-			xfs_ifunlock(ip);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
 		return -EAGAIN;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
@@ -704,10 +699,8 @@ xfs_reclaim_inode(
 	 * We get the flush lock regardless, though, just to make sure
 	 * we don't free it while it is being flushed.
 	 */
-	if (!locked) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-	}
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_iflock(ip);
 
 	/*
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
@@ -778,7 +771,7 @@ xfs_reclaim_inode_now(
 	}
 	read_unlock(&pag->pag_ici_lock);
 
-	return xfs_reclaim_inode(ip, 0, flags);
+	return xfs_reclaim_inode(ip, flags);
 }
 
 int
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 27920eb..a500b4d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -44,7 +44,6 @@ void xfs_quiesce_attr(struct xfs_mount *mp);
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
-int xfs_reclaim_inode(struct xfs_inode *ip, int locked, int sync_mode);
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index b572f7e..3fac146 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2456,46 +2456,6 @@ xfs_set_dmattrs(
 	return error;
 }
 
-int
-xfs_reclaim(
-	xfs_inode_t	*ip)
-{
-
-	xfs_itrace_entry(ip);
-
-	ASSERT(!VN_MAPPED(VFS_I(ip)));
-
-	/* bad inode, get out here ASAP */
-	if (is_bad_inode(VFS_I(ip))) {
-		xfs_ireclaim(ip);
-		return 0;
-	}
-
-	xfs_ioend_wait(ip);
-
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
-
-	/*
-	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode and the
-	 * linux inode and clean up the xfs inode later. This avoids flushing
-	 * the inode to disk during the delete operation itself.
-	 *
-	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
-	 * first to ensure that xfs_iunpin() will never see an xfs inode
-	 * that has a linux inode being reclaimed. Synchronisation is provided
-	 * by the i_flags_lock.
-	 */
-	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
-	}
-	xfs_inode_set_reclaim_tag(ip);
-	return 0;
-}
-
 /*
  * xfs_alloc_file_space()
  *      This routine allocates disk space for the given file.
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index a9e102d..167a467 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -38,7 +38,6 @@ int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, mode_t mode, struct xfs_inode **ipp,
 		cred_t *credp);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
-int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
