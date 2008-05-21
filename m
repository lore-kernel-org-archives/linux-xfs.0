Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 23:58:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L6wEvS030100
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:58:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24197198A91
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:59:02 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id iGipZnSTkUngX6ts for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:59:02 -0700 (PDT)
Date: Wed, 21 May 2008 08:58:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] always set a/c/mtime through ->setattr
Message-ID: <20080521065849.GB27545@lst.de>
References: <20080520060838.GA6436@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520060838.GA6436@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

Currently touch_atime and file_update_time directly update a/c/mtime
in the inode and just mark the inode dirty afterwards.  This is pretty
bad for some more complex filesystems that have various different types
of dirtying an inode and/or need to store the data in another place
for example for a buffer to be logged.

This patch changes touch_atime and file_update_time to not update the
inode directly but rather call through ->setattr into the filessystem.
 
There is a new ATTR_UPDTIMES flag for these two calls so filesystems
know it's just a timestampts update.  This allows some optimizations
and also allow to kill the IS_NOCMTIME we curretly have for networked
filesystem by letting them simpliy ignore these kind of updates.

There is also a new ATTR_VERSION flag sent from file_update_time
that tells the filesystem to update i_version because this update
has the same issues as the timestamp updates.

The optimiztion to avoid redundant timestamp updates in touch_atime and
file_update_time is moved into ->setattr and made conditional on
the ATTR_UPDTIMES flag.

Also in this patch are the changes to XFS that clean up all the mess
that was caused by the previous behaviour.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-20 20:48:14.000000000 +0200
@@ -68,6 +68,26 @@ int inode_setattr(struct inode * inode, 
 	unsigned int ia_valid = attr->ia_valid;
 	int sync_it = 0;
 
+	/*
+	 * Optimize away timestamp updates that happen as side-effect
+	 * of data I/O if the new timestamp equals to the one saved
+	 * in the inode.
+	 *
+	 * This optimization is not safe for networked filesystems
+	 * that update their timestamps on the server and might not
+	 * have the right cached values in the the client inode.  But
+	 * those network filesystems also turn off client-side timestamp
+	 * updates completely, so we don't care about them here.
+	 */
+	if (ia_valid & ATTR_UPDTIMES) {
+		if (timespec_equal(&inode->i_atime, &attr->ia_atime))
+			ia_valid &= ~ATTR_ATIME;
+		if (timespec_equal(&inode->i_ctime, &attr->ia_ctime))
+			ia_valid &= ~ATTR_CTIME;
+		if (timespec_equal(&inode->i_mtime, &attr->ia_mtime))
+			ia_valid &= ~ATTR_MTIME;
+	}
+
 	if (ia_valid & ATTR_SIZE &&
 	    attr->ia_size != i_size_read(inode)) {
 		int error = vmtruncate(inode, attr->ia_size);
@@ -107,6 +127,10 @@ int inode_setattr(struct inode * inode, 
 		inode->i_mode = mode;
 		sync_it = 1;
 	}
+	if (ia_valid & ATTR_VERSION) {
+		inode_inc_iversion(inode);
+		sync_it = 1;
+	}
 
 	if (sync_it)
 		mark_inode_dirty(inode);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/inode.c	2008-05-20 20:44:38.000000000 +0200
@@ -1190,7 +1190,7 @@ EXPORT_SYMBOL(bmap);
 void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	struct timespec now;
+	struct iattr attr;
 
 	if (mnt_want_write(mnt))
 		return;
@@ -1215,12 +1215,8 @@ void touch_atime(struct vfsmount *mnt, s
 			goto out;
 	}
 
-	now = current_fs_time(inode->i_sb);
-	if (timespec_equal(&inode->i_atime, &now))
-		goto out;
-
-	inode->i_atime = now;
-	mark_inode_dirty_sync(inode);
+	attr.ia_valid = ATTR_ATIME|ATTR_UPDTIMES;
+	notify_change(dentry, &attr);
 out:
 	mnt_drop_write(mnt);
 }
@@ -1241,8 +1237,7 @@ EXPORT_SYMBOL(touch_atime);
 void file_update_time(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct timespec now;
-	int sync_it = 0;
+	struct iattr attr;
 	int err;
 
 	if (IS_NOCMTIME(inode))
@@ -1252,27 +1247,13 @@ void file_update_time(struct file *file)
 	if (err)
 		return;
 
-	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now)) {
-		inode->i_mtime = now;
-		sync_it = 1;
-	}
-
-	if (!timespec_equal(&inode->i_ctime, &now)) {
-		inode->i_ctime = now;
-		sync_it = 1;
-	}
-
-	if (IS_I_VERSION(inode)) {
-		inode_inc_iversion(inode);
-		sync_it = 1;
-	}
+	attr.ia_valid = ATTR_MTIME|ATTR_CTIME|ATTR_UPDTIMES;
+	if (IS_I_VERSION(inode))
+		attr.ia_valid |= ATTR_VERSION;
+	notify_change(file->f_path.dentry, &attr);
 
-	if (sync_it)
-		mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
-
 EXPORT_SYMBOL(file_update_time);
 
 int inode_needs_sync(struct inode *inode)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2008-05-20 20:56:42.000000000 +0200
@@ -55,22 +55,6 @@
 #include <linux/falloc.h>
 
 /*
- * Bring the atime in the XFS inode uptodate.
- * Used before logging the inode to disk or when the Linux inode goes away.
- */
-void
-xfs_synchronize_atime(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = ip->i_vnode;
-
-	if (inode) {
-		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
-	}
-}
-
-/*
  * If the linux inode exists, mark it dirty.
  * Used when commiting a dirty inode into a transaction so that
  * the inode will get written back by the linux code
@@ -136,34 +120,43 @@ xfs_ichgtime(
 		mark_inode_dirty_sync(inode);
 }
 
-/*
- * Variant on the above which avoids querying the system clock
- * in situations where we know the Linux inode timestamps have
- * just been updated (and so we can update our inode cheaply).
- */
-void
-xfs_ichgtime_fast(
-	xfs_inode_t	*ip,
-	struct inode	*inode,
-	int		flags)
+STATIC int
+xfs_update_timestamps(
+	struct inode		*inode,
+	struct iattr		*attr)
 {
-	timespec_t	*tvp;
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		ia_valid = attr->ia_valid;
+	int			sync_it = 0;
 
-	/*
-	 * Atime updates for read() & friends are handled lazily now, and
-	 * explicit updates must go through xfs_ichgtime()
-	 */
-	ASSERT((flags & XFS_ICHGTIME_ACC) == 0);
+	ASSERT(!(ia_valid & ~(ATTR_ATIME|ATTR_CTIME|ATTR_MTIME|ATTR_UPDTIMES)));
+	ASSERT(!IS_RDONLY(inode));
 
-	if (flags & XFS_ICHGTIME_MOD) {
-		tvp = &inode->i_mtime;
-		ip->i_d.di_mtime.t_sec = (__int32_t)tvp->tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)tvp->tv_nsec;
-	}
-	if (flags & XFS_ICHGTIME_CHG) {
-		tvp = &inode->i_ctime;
-		ip->i_d.di_ctime.t_sec = (__int32_t)tvp->tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)tvp->tv_nsec;
+	if ((ia_valid & ATTR_ATIME) &&
+	    !timespec_equal(&inode->i_atime, &attr->ia_atime)) {
+		inode->i_atime = attr->ia_atime;
+		ip->i_d.di_atime.t_sec = attr->ia_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = attr->ia_atime.tv_nsec;
+	 	/*
+		 * The atime is updated lazily, so we don't mark
+		 * the inode dirty here.
+		 */
+	}
+
+	if ((ia_valid & ATTR_MTIME) &&
+	    !timespec_equal(&inode->i_mtime, &attr->ia_mtime)) {
+		inode->i_mtime = attr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = attr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = attr->ia_mtime.tv_nsec;
+		sync_it = 1;
+	}
+
+	if ((ia_valid & ATTR_CTIME) &&
+	    !timespec_equal(&inode->i_ctime, &attr->ia_ctime)) {
+		inode->i_ctime = attr->ia_ctime;
+		ip->i_d.di_ctime.t_sec = attr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = attr->ia_ctime.tv_nsec;
+		sync_it = 1;
 	}
 
 	/*
@@ -175,12 +168,14 @@ xfs_ichgtime_fast(
 	 * ensure that the compiler does not reorder the update
 	 * of i_update_core above the timestamp updates above.
 	 */
-	SYNCHRONIZE();
-	ip->i_update_core = 1;
-	if (!(inode->i_state & I_NEW))
+	if (sync_it) {
+		SYNCHRONIZE();
+		ip->i_update_core = 1;
 		mark_inode_dirty_sync(inode);
-}
+	}
 
+	return 0;
+}
 
 /*
  * Pull the link count and size up from the xfs inode to the linux inode
@@ -668,6 +663,13 @@ xfs_vn_setattr(
 	int		flags = 0;
 	int		error;
 
+	/*
+	 * Timestamps do not need to be logged and hence do not
+	 * need to be done within a transaction.
+	 */
+	if (ia_valid & ATTR_UPDTIMES)
+		return xfs_update_timestamps(inode, attr);
+
 	if (ia_valid & ATTR_UID) {
 		vattr.va_mask |= XFS_AT_UID;
 		vattr.va_uid = attr->ia_uid;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2008-05-20 20:44:38.000000000 +0200
@@ -111,9 +111,6 @@ typedef struct bhv_vattr {
 #define XFS_AT_NBLOCKS		0x00002000
 #define XFS_AT_VCODE		0x00004000
 #define XFS_AT_MAC		0x00008000
-#define XFS_AT_UPDATIME		0x00010000
-#define XFS_AT_UPDMTIME		0x00020000
-#define XFS_AT_UPDCTIME		0x00040000
 #define XFS_AT_ACL		0x00080000
 #define XFS_AT_CAP		0x00100000
 #define XFS_AT_INF		0x00200000
@@ -139,8 +136,6 @@ typedef struct bhv_vattr {
 
 #define XFS_AT_TIMES	(XFS_AT_ATIME|XFS_AT_MTIME|XFS_AT_CTIME)
 
-#define XFS_AT_UPDTIMES	(XFS_AT_UPDATIME|XFS_AT_UPDMTIME|XFS_AT_UPDCTIME)
-
 #define XFS_AT_NOSET	(XFS_AT_NLINK|XFS_AT_RDEV|XFS_AT_FSID|XFS_AT_NODEID|\
 		XFS_AT_TYPE|XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|\
 		XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_GENCOUNT)
@@ -193,25 +188,6 @@ static inline int VN_BAD(bhv_vnode_t *vp
 }
 
 /*
- * Extracting atime values in various formats
- */
-static inline void vn_atime_to_bstime(bhv_vnode_t *vp, xfs_bstime_t *bs_atime)
-{
-	bs_atime->tv_sec = vp->i_atime.tv_sec;
-	bs_atime->tv_nsec = vp->i_atime.tv_nsec;
-}
-
-static inline void vn_atime_to_timespec(bhv_vnode_t *vp, struct timespec *ts)
-{
-	*ts = vp->i_atime;
-}
-
-static inline void vn_atime_to_time_t(bhv_vnode_t *vp, time_t *tt)
-{
-	*tt = vp->i_atime.tv_sec;
-}
-
-/*
  * Some useful predicates.
  */
 #define VN_MAPPED(vp)	mapping_mapped(vn_to_inode(vp)->i_mapping)
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2008-05-20 20:44:38.000000000 +0200
@@ -3330,11 +3330,6 @@ xfs_iflush_int(
 	ip->i_update_core = 0;
 	SYNCHRONIZE();
 
-	/*
-	 * Make sure to get the latest atime from the Linux inode.
-	 */
-	xfs_synchronize_atime(ip);
-
 	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC,
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
 		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.h	2008-05-20 20:44:38.000000000 +0200
@@ -526,7 +526,6 @@ void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 
-void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2008-05-20 20:44:38.000000000 +0200
@@ -271,11 +271,6 @@ xfs_inode_item_format(
 		ip->i_update_size = 0;
 
 	/*
-	 * Make sure to get the latest atime from the Linux inode.
-	 */
-	xfs_synchronize_atime(ip);
-
-	/*
 	 * make sure the linux inode is dirty
 	 */
 	xfs_mark_inode_dirty_sync(ip);
Index: linux-2.6/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_itable.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_itable.c	2008-05-20 20:44:38.000000000 +0200
@@ -85,7 +85,8 @@ xfs_bulkstat_one_iget(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
-	vn_atime_to_bstime(vp, &buf->bs_atime);
+	buf->bs_atime.tv_sec = dic->di_atime.t_sec;
+	buf->bs_atime.tv_nsec = dic->di_atime.t_nsec;
 	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
 	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
 	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2008-05-20 20:44:38.000000000 +0200
@@ -115,19 +115,6 @@ xfs_setattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	/*
-	 * Timestamps do not need to be logged and hence do not
-	 * need to be done within a transaction.
-	 */
-	if (mask & XFS_AT_UPDTIMES) {
-		ASSERT((mask & ~XFS_AT_UPDTIMES) == 0);
-		timeflags = ((mask & XFS_AT_UPDATIME) ? XFS_ICHGTIME_ACC : 0) |
-			    ((mask & XFS_AT_UPDCTIME) ? XFS_ICHGTIME_CHG : 0) |
-			    ((mask & XFS_AT_UPDMTIME) ? XFS_ICHGTIME_MOD : 0);
-		xfs_ichgtime(ip, timeflags);
-		return 0;
-	}
-
 	olddquot1 = olddquot2 = NULL;
 	udqp = gdqp = NULL;
 
@@ -3226,12 +3213,6 @@ xfs_reclaim(
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.h	2008-05-20 20:44:38.000000000 +0200
@@ -29,7 +29,6 @@ extern const struct file_operations xfs_
 
 struct xfs_inode;
 extern void xfs_ichgtime(struct xfs_inode *, int);
-extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
 
 #define xfs_vtoi(vp) \
 	((struct xfs_inode *)vn_to_inode(vp)->i_private)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-05-20 20:44:38.000000000 +0200
@@ -668,17 +668,8 @@ start:
 	if (new_size > xip->i_size)
 		xip->i_new_size = new_size;
 
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (likely(!(ioflags & IO_INVIS) &&
-		   !mnt_want_write(file->f_path.mnt))) {
+	if (likely(!(ioflags & IO_INVIS)))
 		file_update_time(file);
-		xfs_ichgtime_fast(xip, inode,
-				  XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-		mnt_drop_write(file->f_path.mnt);
-	}
 
 	/*
 	 * If the offset is beyond the size of the file, we have a couple
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-20 20:44:12.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-20 20:44:38.000000000 +0200
@@ -333,6 +333,9 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
 #define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
+#define ATTR_VERSION	65536	/* increment i_version */
+#define ATTR_UPDTIMES	131072	/* timestamp updates are side-effect of
+				   read/write operations */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
