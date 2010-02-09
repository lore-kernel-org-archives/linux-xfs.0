Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19AUm5m208889 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 04:30:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B26441BC9F4
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 02:32:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OqFIXf5ZqnsuQGjV for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 02:32:01 -0800 (PST)
Date: Tue, 9 Feb 2010 05:31:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100209103157.GA5197@infradead.org>
References: <4B0A8075.8080008@news-service.com>
	<20091211115932.GA20632@infradead.org>
	<4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B712166.9010701@news-service.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Tue, Feb 09, 2010 at 09:48:38AM +0100, Patrick Schreurs wrote:
> This is a clean 2.6.32.3 with the xfs-inode-reclaim-2.6.32 patch i  
> received from Dave on January 8th (see attachment).

I can't find anything interesting regarding I_RECLAIMABLE manipulation
in there.  The only thing I could think off going wrong is i_flags
and i_update_core sitting in the same word and the compiler causing
some read-modify-write cycles for it.  Can you test the patch below?
It fixes the abose issue up, and to make sure sure the assert you hit
isn't as lethal changes it into a WARN_ON, which will still print the
backtrace, but not crash the machine.


Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2010-02-09 10:38:51.771004413 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2010-02-09 10:42:02.102254796 +0100
@@ -1004,13 +1004,13 @@ xfs_fs_inode_init_once(
  * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
  * we catch unlogged VFS level updates to the inode. Care must be taken
  * here - the transaction code calls mark_inode_dirty_sync() to mark the
- * VFS inode dirty in a transaction and clears the i_update_core field;
+ * VFS inode dirty in a transaction and clears the XFS_IDIRTY_CORE flag;
  * it must clear the field after calling mark_inode_dirty_sync() to
  * correctly indicate that the dirty state has been propagated into the
  * inode log item.
  *
  * We need the barrier() to maintain correct ordering between unlogged
- * updates and the transaction commit code that clears the i_update_core
+ * updates and the transaction commit code that clears the XFS_IDIRTY_CORE
  * field. This requires all updates to be completed before marking the
  * inode dirty.
  */
@@ -1018,8 +1018,7 @@ STATIC void
 xfs_fs_dirty_inode(
 	struct inode	*inode)
 {
-	barrier();
-	XFS_I(inode)->i_update_core = 1;
+	xfs_iflags_set(XFS_I(inode), XFS_IDIRTY_CORE);
 }
 
 /*
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2010-02-09 10:38:41.343004133 +0100
+++ linux-2.6/fs/xfs/xfs_iget.c	2010-02-09 10:38:47.069003783 +0100
@@ -81,7 +81,6 @@ xfs_inode_alloc(
 	ip->i_afp = NULL;
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
-	ip->i_update_core = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 	ip->i_size = 0;
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2010-02-09 10:37:28.821254796 +0100
+++ linux-2.6/fs/xfs/xfs_inode.c	2010-02-09 10:38:33.537253468 +0100
@@ -2098,7 +2098,7 @@ xfs_ifree_cluster(
 			iip = ip->i_itemp;
 
 			if (!iip) {
-				ip->i_update_core = 0;
+				xfs_iflags_clear(ip, XFS_IDIRTY_CORE);
 				xfs_ifunlock(ip);
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				continue;
@@ -2913,7 +2913,7 @@ xfs_iflush(
 	 * to disk, because the log record didn't make it to disk!
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		ip->i_update_core = 0;
+		xfs_iflags_clear(ip, XFS_IDIRTY_CORE);
 		if (iip)
 			iip->ili_format.ilf_fields = 0;
 		xfs_ifunlock(ip);
@@ -3057,19 +3057,18 @@ xfs_iflush_int(
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	/*
-	 * Clear i_update_core before copying out the data.
+	 * Clear XFS_IDIRTY_CORE before copying out the data.
 	 * This is for coordination with our timestamp updates
 	 * that don't hold the inode lock. They will always
-	 * update the timestamps BEFORE setting i_update_core,
-	 * so if we clear i_update_core after they set it we
+	 * update the timestamps BEFORE setting XFS_IDIRTY_CORE,
+	 * so if we clear XFS_IDIRTY_CORE after they set it we
 	 * are guaranteed to see their updates to the timestamps.
 	 * I believe that this depends on strongly ordered memory
 	 * semantics, but we have that.  We use the SYNCHRONIZE
 	 * macro to make sure that the compiler does not reorder
-	 * the i_update_core access below the data copy below.
+	 * the XFS_IDIRTY_CORE access below the data copy below.
 	 */
-	ip->i_update_core = 0;
-	SYNCHRONIZE();
+	xfs_iflags_clear(ip, XFS_IDIRTY_CORE);
 
 	/*
 	 * Make sure to get the latest timestamps from the Linux inode.
@@ -3235,7 +3234,7 @@ xfs_iflush_int(
 	} else {
 		/*
 		 * We're flushing an inode which is not in the AIL and has
-		 * not been logged but has i_update_core set.  For this
+		 * not been logged but has XFS_IDIRTY_CORE set.  For this
 		 * case we can use a B_DELWRI flush and immediately drop
 		 * the inode flush lock because we can avoid the whole
 		 * AIL state thing.  It's OK to drop the flush lock now,
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-02-09 10:36:31.621003922 +0100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-02-09 10:37:23.518004062 +0100
@@ -259,8 +259,7 @@ typedef struct xfs_inode {
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
-	unsigned short		i_flags;	/* see defined flags below */
-	unsigned char		i_update_core;	/* timestamps/size is dirty */
+	unsigned int		i_flags;	/* see defined flags below */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
@@ -391,6 +390,7 @@ static inline void xfs_ifunlock(xfs_inod
 #define XFS_INEW	0x0008	/* inode has just been allocated */
 #define XFS_IFILESTREAM	0x0010	/* inode is in a filestream directory */
 #define XFS_ITRUNCATED	0x0020	/* truncated down so flush-on-close */
+#define XFS_IDIRTY_CORE 0x0040	/* non-transaction updates pending */
 
 /*
  * Flags for inode locking.
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2010-02-09 10:40:38.194253398 +0100
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2010-02-09 10:41:44.883256052 +0100
@@ -233,15 +233,15 @@ xfs_inode_item_format(
 
 	/*
 	 * Make sure the linux inode is dirty. We do this before
-	 * clearing i_update_core as the VFS will call back into
-	 * XFS here and set i_update_core, so we need to dirty the
-	 * inode first so that the ordering of i_update_core and
+	 * clearing XFS_IDIRTY_CORE as the VFS will call back into
+	 * XFS here and set XFS_IDIRTY_CORE, so we need to dirty the
+	 * inode first so that the ordering of XFS_IDIRTY_CORE and
 	 * unlogged modifications still works as described below.
 	 */
 	xfs_mark_inode_dirty_sync(ip);
 
 	/*
-	 * Clear i_update_core if the timestamps (or any other
+	 * Clear XFS_IDIRTY_CORE if the timestamps (or any other
 	 * non-transactional modification) need flushing/logging
 	 * and we're about to log them with the rest of the core.
 	 *
@@ -252,11 +252,11 @@ xfs_inode_item_format(
 	 * for the timestamps if both routines were to grab the
 	 * timestamps or not.  That would be ok.
 	 *
-	 * We clear i_update_core before copying out the data.
+	 * We clear XFS_IDIRTY_CORE before copying out the data.
 	 * This is for coordination with our timestamp updates
 	 * that don't hold the inode lock. They will always
-	 * update the timestamps BEFORE setting i_update_core,
-	 * so if we clear i_update_core after they set it we
+	 * update the timestamps BEFORE setting XFS_IDIRTY_CORE,
+	 * so if we clear XFS_IDIRTY_CORE after they set it we
 	 * are guaranteed to see their updates to the timestamps
 	 * either here.  Likewise, if they set it after we clear it
 	 * here, we'll see it either on the next commit of this
@@ -264,12 +264,9 @@ xfs_inode_item_format(
 	 * xfs_iflush().  This depends on strongly ordered memory
 	 * semantics, but we have that.  We use the SYNCHRONIZE
 	 * macro to make sure that the compiler does not reorder
-	 * the i_update_core access below the data copy below.
+	 * the XFS_IDIRTY_CORE access below the data copy below.
 	 */
-	if (ip->i_update_core)  {
-		ip->i_update_core = 0;
-		SYNCHRONIZE();
-	}
+	xfs_iflags_clear(ip, XFS_IDIRTY_CORE);
 
 	/*
 	 * Make sure to get the latest timestamps from the Linux inode.
Index: linux-2.6/fs/xfs/xfs_inode_item.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.h	2010-02-09 10:40:24.678024386 +0100
+++ linux-2.6/fs/xfs/xfs_inode_item.h	2010-02-09 10:40:35.674015377 +0100
@@ -162,7 +162,7 @@ static inline int xfs_inode_clean(xfs_in
 {
 	return (!ip->i_itemp ||
 		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
-	       !ip->i_update_core;
+		!xfs_iflags_test(ip, XFS_IDIRTY_CORE);
 }
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2010-02-09 10:39:37.171274212 +0100
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2010-02-09 10:40:13.425004481 +0100
@@ -405,7 +405,7 @@ xfs_setattr(
 			inode->i_atime = iattr->ia_atime;
 			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
 			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-			ip->i_update_core = 1;
+			xfs_iflags_set(ip, XFS_IDIRTY_CORE);
 		}
 		if (mask & ATTR_MTIME) {
 			inode->i_mtime = iattr->ia_mtime;
@@ -427,7 +427,7 @@ xfs_setattr(
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
 		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-		ip->i_update_core = 1;
+		xfs_iflags_set(ip, XFS_IDIRTY_CORE);
 		timeflags &= ~XFS_ICHGTIME_CHG;
 	}
 
@@ -633,7 +633,7 @@ xfs_fsync(
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	if (!ip->i_update_core) {
+	if (!xfs_iflags_test(ip, XFS_IDIRTY_CORE)) {
 		/*
 		 * Timestamps/size haven't changed since last inode flush or
 		 * inode transaction commit.  That means either nothing got
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-02-09 10:43:25.201003853 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2010-02-09 10:44:00.886284060 +0100
@@ -765,8 +765,8 @@ xfs_reclaim_inode_now(
 	 * XFS_IRECLAIM flag set it will not touch us.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
+	if (WARN_ON(__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) ||
+	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
 		/* ignore as it is already under reclaim */
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
