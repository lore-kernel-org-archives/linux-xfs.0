Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8AGBTi2226113 for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 11:11:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E023143F33D
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 09:12:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qAaLUv4WTuBOrFDY for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2009 09:12:30 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MlmD3-0005dZ-G6
	for xfs@oss.sgi.com; Thu, 10 Sep 2009 16:09:21 +0000
Date: Thu, 10 Sep 2009 12:09:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: implement ->dirty_inode to fix timestamp handling
Message-ID: <20090910160921.GB21031@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

This is picking up on Felix's repost of Dave's patch to implement a
.dirty_inode method.  We really need this notification because
the VFS keeps writing directly into the inode structure instead
of going through methods to update this state.  In addition to
the long-known atime issue we now also have a caller in VM code
that updates c/mtime that way for shared writeable mmaps.  And
I found another one that no one has noticed in practice in the FIFO
code.

So implement ->dirty_inode to set i_update_core whenever the
inode gets externally dirties, and switch the c/mtime handling to
the same scheme we already use for atime (always picking up
the value from the Linux inode).

Note that this patch also removes the xfs_synchronize_atime call
in xfs_reclaim it was superflous as we already synchronize the time
when writing the inode via the log (xfs_inode_item_format) or the
normal buffers (xfs_iflush_int).

In addition also remove the I_CLEAR check before copying the Linux
timestamps - now that we always have the Linux inode available
we can always use the timestampts in it.

Also switch to just using file_update_time for regular reads/writes -
that will get us all optimization done to it for free and make
sure we notice early when it breaks.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Felix Blyakher <felixb@sgi.com>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-09-09 21:01:45.220253759 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-09-09 21:04:03.145006265 -0300
@@ -58,19 +58,22 @@
 #include <linux/fiemap.h>
 
 /*
- * Bring the atime in the XFS inode uptodate.
- * Used before logging the inode to disk or when the Linux inode goes away.
+ * Bring the timestamps in the XFS inode uptodate.
+ *
+ * Used before writing the inode to disk.
  */
 void
-xfs_synchronize_atime(
+xfs_synchronize_times(
 	xfs_inode_t	*ip)
 {
 	struct inode	*inode = VFS_I(ip);
 
-	if (!(inode->i_state & I_CLEAR)) {
-		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
-	}
+	ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
+	ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
+	ip->i_d.di_ctime.t_sec = (__int32_t)inode->i_ctime.tv_sec;
+	ip->i_d.di_ctime.t_nsec = (__int32_t)inode->i_ctime.tv_nsec;
+	ip->i_d.di_mtime.t_sec = (__int32_t)inode->i_mtime.tv_sec;
+	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
 }
 
 /*
@@ -107,32 +110,20 @@ xfs_ichgtime(
 	if ((flags & XFS_ICHGTIME_MOD) &&
 	    !timespec_equal(&inode->i_mtime, &tv)) {
 		inode->i_mtime = tv;
-		ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
 		sync_it = 1;
 	}
 	if ((flags & XFS_ICHGTIME_CHG) &&
 	    !timespec_equal(&inode->i_ctime, &tv)) {
 		inode->i_ctime = tv;
-		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)tv.tv_nsec;
 		sync_it = 1;
 	}
 
 	/*
-	 * We update the i_update_core field _after_ changing
-	 * the timestamps in order to coordinate properly with
-	 * xfs_iflush() so that we don't lose timestamp updates.
-	 * This keeps us from having to hold the inode lock
-	 * while doing this.  We use the SYNCHRONIZE macro to
-	 * ensure that the compiler does not reorder the update
-	 * of i_update_core above the timestamp updates above.
+	 * Update complete - now make sure everyone knows that the inode
+	 * is dirty.
 	 */
-	if (sync_it) {
-		SYNCHRONIZE();
-		ip->i_update_core = 1;
+	if (sync_it)
 		xfs_mark_inode_dirty_sync(ip);
-	}
 }
 
 /*
@@ -515,10 +506,8 @@ xfs_vn_getattr(
 	stat->gid = ip->i_d.di_gid;
 	stat->ino = ip->i_ino;
 	stat->atime = inode->i_atime;
-	stat->mtime.tv_sec = ip->i_d.di_mtime.t_sec;
-	stat->mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
-	stat->ctime.tv_sec = ip->i_d.di_ctime.t_sec;
-	stat->ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
+	stat->mtime = inode->i_mtime;
+	stat->ctime = inode->i_ctime;
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 21:01:45.224254059 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-09-09 21:02:14.989003628 -0300
@@ -977,6 +977,28 @@ xfs_fs_inode_init_once(
 }
 
 /*
+ * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
+ * we catch unlogged VFS level updates to the inode. Care must be taken
+ * here - the transaction code calls mark_inode_dirty_sync() to mark the
+ * VFS inode dirty in a transaction and clears the i_update_core field;
+ * it must clear the field after calling mark_inode_dirty_sync() to
+ * correctly indicate that the dirty state has been propagated into the
+ * inode log item.
+ *
+ * We need the barrier() to maintain correct ordering between unlogged
+ * updates and the transaction commit code that clears the i_update_core
+ * field. This requires all updates to be completed before marking the
+ * inode dirty.
+ */
+STATIC void
+xfs_fs_dirty_inode(
+	struct inode	*inode)
+{
+	barrier();
+	XFS_I(inode)->i_update_core = 1;
+}
+
+/*
  * Attempt to flush the inode, this will actually fail
  * if the inode is pinned, but we dirty the inode again
  * at the point when it is unpinned after a log write,
@@ -1539,6 +1561,7 @@ xfs_fs_get_sb(
 static struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
+	.dirty_inode		= xfs_fs_dirty_inode,
 	.write_inode		= xfs_fs_write_inode,
 	.clear_inode		= xfs_fs_clear_inode,
 	.put_super		= xfs_fs_put_super,
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2009-09-09 21:01:45.238254098 -0300
+++ xfs/fs/xfs/xfs_inode_item.c	2009-09-09 21:02:14.990004244 -0300
@@ -232,6 +232,15 @@ xfs_inode_item_format(
 	nvecs	     = 1;
 
 	/*
+	 * Make sure the linux inode is dirty. We do this before
+	 * clearing i_update_core as the VFS will call back into
+	 * XFS here and set i_update_core, so we need to dirty the
+	 * inode first so that the ordering of i_update_core and
+	 * unlogged modifications still works as described below.
+	 */
+	xfs_mark_inode_dirty_sync(ip);
+
+	/*
 	 * Clear i_update_core if the timestamps (or any other
 	 * non-transactional modification) need flushing/logging
 	 * and we're about to log them with the rest of the core.
@@ -263,14 +272,9 @@ xfs_inode_item_format(
 	}
 
 	/*
-	 * Make sure to get the latest atime from the Linux inode.
+	 * Make sure to get the latest timestamps from the Linux inode.
 	 */
-	xfs_synchronize_atime(ip);
-
-	/*
-	 * make sure the linux inode is dirty
-	 */
-	xfs_mark_inode_dirty_sync(ip);
+	xfs_synchronize_times(ip);
 
 	vecp->i_addr = (xfs_caddr_t)&ip->i_d;
 	vecp->i_len  = sizeof(struct xfs_icdinode);
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-09-09 21:01:45.229253789 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2009-09-09 21:02:14.993004487 -0300
@@ -215,7 +215,6 @@ xfs_setfilesize(
 
 	if (ip->i_d.di_size < isize) {
 		ip->i_d.di_size = isize;
-		ip->i_update_core = 1;
 		xfs_mark_inode_dirty_sync(ip);
 	}
 
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2009-09-09 21:01:45.266253337 -0300
+++ xfs/fs/xfs/xfs_dfrag.c	2009-09-09 21:02:14.995003346 -0300
@@ -206,10 +206,10 @@ xfs_swap_extents(
 	 * process that the file was not changed out from
 	 * under it.
 	 */
-	if ((sbp->bs_ctime.tv_sec != ip->i_d.di_ctime.t_sec) ||
-	    (sbp->bs_ctime.tv_nsec != ip->i_d.di_ctime.t_nsec) ||
-	    (sbp->bs_mtime.tv_sec != ip->i_d.di_mtime.t_sec) ||
-	    (sbp->bs_mtime.tv_nsec != ip->i_d.di_mtime.t_nsec)) {
+	if ((sbp->bs_ctime.tv_sec != VFS_I(ip)->i_ctime.tv_sec) ||
+	    (sbp->bs_ctime.tv_nsec != VFS_I(ip)->i_ctime.tv_nsec) ||
+	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
+	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
 		error = XFS_ERROR(EBUSY);
 		goto out_unlock;
 	}
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2009-09-09 21:01:45.271254184 -0300
+++ xfs/fs/xfs/xfs_itable.c	2009-09-09 21:02:14.998004077 -0300
@@ -59,6 +59,7 @@ xfs_bulkstat_one_iget(
 {
 	xfs_icdinode_t	*dic;	/* dinode core info pointer */
 	xfs_inode_t	*ip;		/* incore inode pointer */
+	struct inode	*inode;
 	int		error;
 
 	error = xfs_iget(mp, NULL, ino,
@@ -72,6 +73,7 @@ xfs_bulkstat_one_iget(
 	ASSERT(ip->i_imap.im_blkno != 0);
 
 	dic = &ip->i_d;
+	inode = VFS_I(ip);
 
 	/* xfs_iget returns the following without needing
 	 * further change.
@@ -83,16 +85,19 @@ xfs_bulkstat_one_iget(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
+
 	/*
-	 * We are reading the atime from the Linux inode because the
-	 * dinode might not be uptodate.
+	 * We need to read the timestamps from the Linux inode because
+	 * the VFS keeps writing directly into the inode structure instead
+	 * of telling us about the updates.
 	 */
-	buf->bs_atime.tv_sec = VFS_I(ip)->i_atime.tv_sec;
-	buf->bs_atime.tv_nsec = VFS_I(ip)->i_atime.tv_nsec;
-	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
-	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
-	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
-	buf->bs_ctime.tv_nsec = dic->di_ctime.t_nsec;
+	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
+	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
+	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
+	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
+	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
+	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
+
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
 	buf->bs_extents = dic->di_nextents;
Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 21:01:45.234253728 -0300
+++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-09-09 21:02:15.001004460 -0300
@@ -667,7 +667,7 @@ start:
 		xip->i_new_size = new_size;
 
 	if (likely(!(ioflags & IO_INVIS)))
-		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		file_update_time(file);
 
 	/*
 	 * If the offset is beyond the size of the file, we have a couple
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2009-09-09 21:01:45.275254065 -0300
+++ xfs/fs/xfs/xfs_inode.c	2009-09-09 21:04:39.394255702 -0300
@@ -3068,9 +3068,9 @@ xfs_iflush_int(
 	SYNCHRONIZE();
 
 	/*
-	 * Make sure to get the latest atime from the Linux inode.
+	 * Make sure to get the latest timestamps from the Linux inode.
 	 */
-	xfs_synchronize_atime(ip);
+	xfs_synchronize_times(ip);
 
 	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC,
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2009-09-09 21:01:45.281254271 -0300
+++ xfs/fs/xfs/xfs_inode.h	2009-09-09 21:02:15.009004153 -0300
@@ -504,7 +504,7 @@ void		xfs_ichgtime(xfs_inode_t *, int);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
-void		xfs_synchronize_atime(xfs_inode_t *);
+void		xfs_synchronize_times(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 #if defined(XFS_INODE_TRACE)
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-09-09 21:02:18.472028392 -0300
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-09-09 21:06:19.814256069 -0300
@@ -2476,12 +2476,6 @@ xfs_reclaim(
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
-	 * Make sure the atime in the XFS inode is correct before freeing the
-	 * Linux inode.
-	 */
-	xfs_synchronize_atime(ip);
-
-	/*
 	 * If we have nothing to flush with this inode then complete the
 	 * teardown now, otherwise break the link between the xfs inode and the
 	 * linux inode and clean up the xfs inode later. This avoids flushing

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
