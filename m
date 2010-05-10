Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AE6CLc005138 for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:06:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A567BC7CDEB
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:08:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rIKxfopqJkU0PNNN for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 07:08:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OBTeh-0004Jg-Ve
	for xfs@oss.sgi.com; Mon, 10 May 2010 14:08:24 +0000
Date: Mon, 10 May 2010 10:08:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: drop dmapi hooks
Message-ID: <20100510140823.GA16540@infradead.org>
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

Dmapi support was never merged upstream, but we still have a lot of hooks
bloating XFS for it, all over the fast pathes of the filesystem.

This patch drops over 700 lines of dmapi overhead.  If we'll ever get HSM
support in mainline at least the namespace events can be done much saner
in the VFS instead of the individual filesystem, so it's not like this
is much help for future work.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-05-06 22:40:46.199253324 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-05-10 15:34:12.994263312 +0200
@@ -24,7 +24,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_trans.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
@@ -275,20 +274,6 @@ xfs_file_aio_read(
 		mutex_lock(&inode->i_mutex);
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
-		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
-		int iolock = XFS_IOLOCK_SHARED;
-
-		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, iocb->ki_pos, size,
-					dmflags, &iolock);
-		if (ret) {
-			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-			if (unlikely(ioflags & IO_ISDIRECT))
-				mutex_unlock(&inode->i_mutex);
-			return ret;
-		}
-	}
-
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		if (inode->i_mapping->nrpages) {
 			ret = -xfs_flushinval_pages(ip,
@@ -321,7 +306,6 @@ xfs_file_splice_read(
 	unsigned int		flags)
 {
 	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
 	int			ioflags = 0;
 	ssize_t			ret;
 
@@ -335,18 +319,6 @@ xfs_file_splice_read(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
-		int iolock = XFS_IOLOCK_SHARED;
-		int error;
-
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, *ppos, count,
-					FILP_DELAY_FLAG(infilp), &iolock);
-		if (error) {
-			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-			return -error;
-		}
-	}
-
 	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
 
 	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
@@ -367,7 +339,6 @@ xfs_file_splice_write(
 {
 	struct inode		*inode = outfilp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsize_t		isize, new_size;
 	int			ioflags = 0;
 	ssize_t			ret;
@@ -382,18 +353,6 @@ xfs_file_splice_write(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) && !(ioflags & IO_INVIS)) {
-		int iolock = XFS_IOLOCK_EXCL;
-		int error;
-
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, *ppos, count,
-					FILP_DELAY_FLAG(outfilp), &iolock);
-		if (error) {
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return -error;
-		}
-	}
-
 	new_size = *ppos + count;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -627,7 +586,6 @@ xfs_file_aio_write(
 	int			ioflags = 0;
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
-	int			eventsent = 0;
 	size_t			ocount = 0, count;
 	int			need_i_mutex;
 
@@ -673,33 +631,6 @@ start:
 		goto out_unlock_mutex;
 	}
 
-	if ((DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) &&
-	    !(ioflags & IO_INVIS) && !eventsent)) {
-		int		dmflags = FILP_DELAY_FLAG(file);
-
-		if (need_i_mutex)
-			dmflags |= DM_FLAGS_IMUX;
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		error = XFS_SEND_DATA(ip->i_mount, DM_EVENT_WRITE, ip,
-				      pos, count, dmflags, &iolock);
-		if (error) {
-			goto out_unlock_internal;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		eventsent = 1;
-
-		/*
-		 * The iolock was dropped and reacquired in XFS_SEND_DATA
-		 * so we have to recheck the size when appending.
-		 * We will only "goto start;" once, since having sent the
-		 * event prevents another call to XFS_SEND_DATA, which is
-		 * what allows the size to change in the first place.
-		 */
-		if ((file->f_flags & O_APPEND) && pos != ip->i_size)
-			goto start;
-	}
-
 	if (ioflags & IO_ISDIRECT) {
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
@@ -830,22 +761,6 @@ write_retry:
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if (ret == -ENOSPC &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
-		xfs_iunlock(ip, iolock);
-		if (need_i_mutex)
-			mutex_unlock(&inode->i_mutex);
-		error = XFS_SEND_NAMESP(ip->i_mount, DM_EVENT_NOSPACE, ip,
-				DM_RIGHT_NULL, ip, DM_RIGHT_NULL, NULL, NULL,
-				0, 0, 0); /* Delay flag intentionally  unused */
-		if (need_i_mutex)
-			mutex_lock(&inode->i_mutex);
-		xfs_ilock(ip, iolock);
-		if (error)
-			goto out_unlock_internal;
-		goto start;
-	}
-
 	error = -ret;
 	if (ret <= 0)
 		goto out_unlock_internal;
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-05-10 15:34:13.003253883 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
@@ -1116,16 +1115,7 @@ xfs_ioctl_setattr(
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 
-	if (code)
-		return code;
-
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
-				NULL, DM_RIGHT_NULL, NULL, NULL, 0, 0,
-				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
-	}
-
-	return 0;
+	return code;
 
  error_return:
 	xfs_qm_dqrele(udqp);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-05-10 15:32:31.849003430 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-05-10 15:34:13.033254372 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
@@ -169,8 +168,7 @@ suffix_strtoul(char *s, char **endp, uns
 STATIC int
 xfs_parseargs(
 	struct xfs_mount	*mp,
-	char			*options,
-	char			**mtpt)
+	char			*options)
 {
 	struct super_block	*sb = mp->m_super;
 	char			*this_char, *value, *eov;
@@ -240,15 +238,10 @@ xfs_parseargs(
 			if (!mp->m_logname)
 				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			*mtpt = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
-			if (!*mtpt)
-				return ENOMEM;
+			cmn_err(CE_WARN,
+				"XFS: %s option not allowed on this system",
+				this_char);
+			return EINVAL;
 		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -420,12 +413,6 @@ xfs_parseargs(
 		return EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_DMAPI) && (!*mtpt || *mtpt[0] == '\0')) {
-		printk("XFS: %s option needs the mount point option as well\n",
-			MNTOPT_DMAPI);
-		return EINVAL;
-	}
-
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
 		cmn_err(CE_WARN,
 			"XFS: sunit and swidth must be specified together");
@@ -1195,8 +1182,6 @@ xfs_fs_put_super(
 		xfs_sync_attr(mp, 0);
 	}
 
-	XFS_SEND_PREUNMOUNT(mp);
-
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
@@ -1206,14 +1191,11 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
-	XFS_SEND_UNMOUNT(mp);
-
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_inode_shrinker_unregister(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
-	xfs_dmops_put(mp);
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1531,7 +1513,6 @@ xfs_fs_fill_super(
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
 	int			flags = 0, error = ENOMEM;
-	char			*mtpt = NULL;
 
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
@@ -1547,7 +1528,7 @@ xfs_fs_fill_super(
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
-	error = xfs_parseargs(mp, (char *)data, &mtpt);
+	error = xfs_parseargs(mp, (char *)data);
 	if (error)
 		goto out_free_fsname;
 
@@ -1559,16 +1540,12 @@ xfs_fs_fill_super(
 #endif
 	sb->s_op = &xfs_super_operations;
 
-	error = xfs_dmops_get(mp);
-	if (error)
-		goto out_free_fsname;
-
 	if (silent)
 		flags |= XFS_MFSI_QUIET;
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_put_dmops;
+		goto out_free_fsname;
 
 	if (xfs_icsb_init_counters(mp))
 		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
@@ -1596,8 +1573,6 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_filestream_unmount;
 
-	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
-
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
@@ -1626,7 +1601,6 @@ xfs_fs_fill_super(
 
 	xfs_inode_shrinker_register(mp);
 
-	kfree(mtpt);
 	return 0;
 
  out_filestream_unmount:
@@ -1636,11 +1610,8 @@ xfs_fs_fill_super(
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
- out_put_dmops:
-	xfs_dmops_put(mp);
  out_free_fsname:
 	xfs_free_fsname(mp);
-	kfree(mtpt);
 	kfree(mp);
  out:
 	return -error;
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-10 13:47:55.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-10 15:34:13.398004616 +0200
@@ -34,7 +34,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
@@ -5605,28 +5604,6 @@ xfs_getbmap(
 		prealloced = 0;
 		fixlen = 1LL << 32;
 	} else {
-		/*
-		 * If the BMV_IF_NO_DMAPI_READ interface bit specified, do
-		 * not generate a DMAPI read event.  Otherwise, if the
-		 * DM_EVENT_READ bit is set for the file, generate a read
-		 * event in order that the DMAPI application may do its thing
-		 * before we return the extents.  Usually this means restoring
-		 * user file data to regions of the file that look like holes.
-		 *
-		 * The "old behavior" (from XFS_IOC_GETBMAP) is to not specify
-		 * BMV_IF_NO_DMAPI_READ so that read events are generated.
-		 * If this were not true, callers of ioctl(XFS_IOC_GETBMAP)
-		 * could misinterpret holes in a DMAPI file as true holes,
-		 * when in fact they may represent offline user data.
-		 */
-		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
-		    !(iflags & BMV_IF_NO_DMAPI_READ)) {
-			error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip,
-					      0, 0, 0, NULL);
-			if (error)
-				return XFS_ERROR(error);
-		}
-
 		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2010-05-06 22:40:46.374253953 +0200
+++ xfs/fs/xfs/xfs_rename.c	2010-05-10 15:34:13.319011950 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
@@ -119,18 +118,6 @@ xfs_rename(
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
 
-	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
-	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
-					src_dp, DM_RIGHT_NULL,
-					target_dp, DM_RIGHT_NULL,
-					src_name->name, target_name->name,
-					0, 0, 0);
-		if (error)
-			return error;
-	}
-	/* Return through std_return after this point. */
-
 	new_parent = (src_dp != target_dp);
 	src_is_directory = ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR);
 
@@ -369,26 +356,13 @@ xfs_rename(
 	 * trans_commit will unlock src_ip, target_ip & decrement
 	 * the vnode references.
 	 */
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-
-	/* Fall through to std_return with error = 0 or errno from
-	 * xfs_trans_commit	 */
-std_return:
-	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_POSTRENAME) ||
-	    DM_EVENT_ENABLED(target_dp, DM_EVENT_POSTRENAME)) {
-		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
-					src_dp, DM_RIGHT_NULL,
-					target_dp, DM_RIGHT_NULL,
-					src_name->name, target_name->name,
-					0, error, 0);
-	}
-	return error;
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 
  abort_return:
 	cancel_flags |= XFS_TRANS_ABORT;
-	/* FALLTHROUGH */
  error_return:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp, cancel_flags);
-	goto std_return;
+ std_return:
+	return error;
 }
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-05-06 22:40:46.394254232 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-05-10 15:34:13.389003988 +0200
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
@@ -143,16 +142,6 @@ xfs_setattr(
 			goto error_return;
 		}
 	} else {
-		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
-		    !(flags & XFS_ATTR_DMI)) {
-			int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
-			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, ip,
-				iattr->ia_size, 0, dmflags, NULL);
-			if (code) {
-				lock_flags = 0;
-				goto error_return;
-			}
-		}
 		if (need_iolock)
 			lock_flags |= XFS_IOLOCK_EXCL;
 	}
@@ -470,17 +459,10 @@ xfs_setattr(
 			return XFS_ERROR(code);
 	}
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
-	    !(flags & XFS_ATTR_DMI)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL, NULL, NULL,
-					0, 0, AT_DELAY_FLAG(flags));
-	}
 	return 0;
 
  abort_return:
 	commit_flags |= XFS_TRANS_ABORT;
-	/* FALLTHROUGH */
  error_return:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -1060,9 +1042,6 @@ xfs_inactive(
 
 	mp = ip->i_mount;
 
-	if (ip->i_d.di_nlink == 0 && DM_EVENT_ENABLED(ip, DM_EVENT_DESTROY))
-		XFS_SEND_DESTROY(mp, ip, DM_RIGHT_NULL);
-
 	error = 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
@@ -1314,16 +1293,6 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
-				dp, DM_RIGHT_NULL, NULL,
-				DM_RIGHT_NULL, name->name, NULL,
-				mode, 0, 0);
-
-		if (error)
-			return error;
-	}
-
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
 	else
@@ -1487,16 +1456,7 @@ xfs_create(
 	xfs_qm_dqrele(gdqp);
 
 	*ipp = ip;
-
-	/* Fallthrough to std_return with error = 0  */
- std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE, dp, DM_RIGHT_NULL,
-				ip, DM_RIGHT_NULL, name->name, NULL, mode,
-				error, 0);
-	}
-
-	return error;
+	return 0;
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
@@ -1510,8 +1470,8 @@ xfs_create(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-	goto std_return;
+ std_return:
+	return error;
 
  out_abort_rele:
 	/*
@@ -1732,14 +1692,6 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL, name->name, NULL,
-					ip->i_d.di_mode, 0, 0);
-		if (error)
-			return error;
-	}
-
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
 		goto std_return;
@@ -1877,21 +1829,15 @@ xfs_remove(
 	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
- std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE, dp, DM_RIGHT_NULL,
-				NULL, DM_RIGHT_NULL, name->name, NULL,
-				ip->i_d.di_mode, error, 0);
-	}
-
-	return error;
+	return 0;
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
-	goto std_return;
+ std_return:
+	return error;
 }
 
 int
@@ -1917,17 +1863,6 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
-					tdp, DM_RIGHT_NULL,
-					sip, DM_RIGHT_NULL,
-					target_name->name, NULL, 0, 0, 0);
-		if (error)
-			return error;
-	}
-
-	/* Return through std_return after this point. */
-
 	error = xfs_qm_dqattach(sip, 0);
 	if (error)
 		goto std_return;
@@ -2014,27 +1949,14 @@ xfs_link(
 		goto abort_return;
 	}
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (error)
-		goto std_return;
-
-	/* Fall through to std_return with error = 0. */
-std_return:
-	if (DM_EVENT_ENABLED(sip, DM_EVENT_POSTLINK)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
-				tdp, DM_RIGHT_NULL,
-				sip, DM_RIGHT_NULL,
-				target_name->name, NULL, 0, error, 0);
-	}
-	return error;
+	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 
  abort_return:
 	cancel_flags |= XFS_TRANS_ABORT;
-	/* FALLTHROUGH */
-
  error_return:
 	xfs_trans_cancel(tp, cancel_flags);
-	goto std_return;
+ std_return:
+	return error;
 }
 
 int
@@ -2086,17 +2008,6 @@ xfs_symlink(
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
 		return XFS_ERROR(ENAMETOOLONG);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
-					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					link_name->name,
-					(unsigned char *)target_path, 0, 0, 0);
-		if (error)
-			return error;
-	}
-
-	/* Return through std_return after this point. */
-
 	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
@@ -2278,21 +2189,8 @@ xfs_symlink(
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 
-	/* Fall through to std_return with error = 0 or errno from
-	 * xfs_trans_commit	*/
-std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTSYMLINK)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
-					dp, DM_RIGHT_NULL,
-					error ? NULL : ip,
-					DM_RIGHT_NULL, link_name->name,
-					(unsigned char *)target_path,
-					0, error, 0);
-	}
-
-	if (!error)
-		*ipp = ip;
-	return error;
+	*ipp = ip;
+	return 0;
 
  error2:
 	IRELE(ip);
@@ -2306,8 +2204,8 @@ std_return:
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-	goto std_return;
+ std_return:
+	return error;
 }
 
 int
@@ -2412,25 +2310,9 @@ xfs_alloc_file_space(
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
 
-	/*	Generate a DMAPI event if needed.	*/
-	if (alloc_type != 0 && offset < ip->i_size &&
-			(attr_flags & XFS_ATTR_DMI) == 0  &&
-			DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
-		xfs_off_t           end_dmi_offset;
-
-		end_dmi_offset = offset+len;
-		if (end_dmi_offset > ip->i_size)
-			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, offset,
-				      end_dmi_offset - offset, 0, NULL);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * Allocate file space until done or until there is an error
 	 */
-retry:
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 
@@ -2527,17 +2409,6 @@ retry:
 		startoffset_fsb += allocated_fsb;
 		allocatesize_fsb -= allocated_fsb;
 	}
-dmapi_enospc_check:
-	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
-				ip, DM_RIGHT_NULL,
-				ip, DM_RIGHT_NULL,
-				NULL, NULL, 0, 0, 0); /* Delay flag intentionally unused */
-		if (error == 0)
-			goto retry;	/* Maybe DMAPI app. has made space */
-		/* else fall through with error from XFS_SEND_DATA */
-	}
 
 	return error;
 
@@ -2548,7 +2419,7 @@ error0:	/* Cancel bmap, unlock inode, un
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	goto dmapi_enospc_check;
+	return error;
 }
 
 /*
@@ -2661,7 +2532,6 @@ xfs_free_file_space(
 {
 	int			committed;
 	int			done;
-	xfs_off_t		end_dmi_offset;
 	xfs_fileoff_t		endoffset_fsb;
 	int			error;
 	xfs_fsblock_t		firstfsb;
@@ -2691,19 +2561,7 @@ xfs_free_file_space(
 		return error;
 	rt = XFS_IS_REALTIME_INODE(ip);
 	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
-	end_dmi_offset = offset + len;
-	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
-
-	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
-		if (end_dmi_offset > ip->i_size)
-			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip,
-				offset, end_dmi_offset - offset,
-				AT_DELAY_FLAG(attr_flags), NULL);
-		if (error)
-			return error;
-	}
+	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
 	if (attr_flags & XFS_ATTR_NOLOCK)
 		need_iolock = 0;
Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/Makefile	2010-05-10 15:33:07.823033810 +0200
@@ -89,8 +89,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_trans_item.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
-				   xfs_rw.o \
-				   xfs_dmops.o
+				   xfs_rw.o
 
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
 
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-05-07 11:52:53.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-05-10 15:34:12.985261845 +0200
@@ -23,7 +23,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_trans.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-05-10 15:33:07.836006432 +0200
@@ -38,7 +38,6 @@
 #include "xfs_sb.h"
 #include "xfs_inum.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2010-05-10 15:33:07.844255280 +0200
@@ -23,7 +23,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
 #include "xfs_vnodeops.h"
Index: xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2010-05-06 22:40:46.201254372 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2010-05-10 15:33:07.850003569 +0200
@@ -21,10 +21,6 @@
 #include "xfs_inode.h"
 #include "xfs_trace.h"
 
-int  fs_noerr(void) { return 0; }
-int  fs_nosys(void) { return ENOSYS; }
-void fs_noval(void) { return; }
-
 /*
  * note: all filemap functions return negative error codes. These
  * need to be inverted before returning to the xfs core functions.
Index: xfs/fs/xfs/linux-2.6/xfs_fs_subr.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.h	2010-05-06 22:40:46.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,25 +0,0 @@
-/*
- * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef	__XFS_FS_SUBR_H__
-#define __XFS_FS_SUBR_H__
-
-extern int  fs_noerr(void);
-extern int  fs_nosys(void);
-extern void fs_noval(void);
-
-#endif	/* __XFS_FS_SUBR_H__ */
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-05-10 15:34:13.016254162 +0200
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-05-10 15:34:13.025254372 +0200
@@ -26,7 +26,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2010-05-10 15:33:07.864275255 +0200
@@ -87,7 +87,6 @@
 #include <xfs_aops.h>
 #include <xfs_super.h>
 #include <xfs_globals.h>
-#include <xfs_fs_subr.h>
 #include <xfs_buf.h>
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_quotaops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_quotaops.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_quotaops.c	2010-05-10 15:33:07.868003709 +0200
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_dmapi.h"
 #include "xfs_sb.h"
 #include "xfs_inum.h"
 #include "xfs_ag.h"
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-05-10 15:34:13.044026407 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/linux-2.6/xfs_trace.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.c	2010-05-10 15:34:13.056004337 +0200
@@ -34,7 +34,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-10 15:34:13.064004267 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-10 15:34:13.072261147 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-05-10 15:34:13.080253813 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2010-05-10 15:34:13.089254931 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_stats.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm_stats.c	2010-05-10 15:34:13.097253883 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-05-10 15:34:13.109253743 +0200
@@ -28,7 +28,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-05-10 13:47:55.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-05-10 15:34:13.120254232 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/support/debug.c
===================================================================
--- xfs.orig/fs/xfs/support/debug.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/support/debug.c	2010-05-10 15:33:07.953282867 +0200
@@ -22,7 +22,6 @@
 #include "xfs_sb.h"
 #include "xfs_inum.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-05-10 15:34:13.129004686 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2010-05-10 15:34:13.138004267 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_attr.c	2010-05-10 15:34:13.149004616 +0200
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_attr_leaf.c	2010-05-10 15:34:13.157024382 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2010-05-10 15:34:13.169004267 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_btree.c	2010-05-10 15:34:13.183024941 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-10 15:33:07.984253603 +0200
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-05-10 15:34:13.406003988 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dfrag.c	2010-05-10 15:34:13.192003988 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2010-05-10 15:34:13.414004197 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2010-05-10 15:34:13.428254372 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2010-05-10 15:34:13.437276302 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2010-05-10 15:34:13.446254302 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2010-05-10 15:34:13.454275534 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2010-05-10 15:34:13.463025569 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_dmapi.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dmapi.h	2010-05-06 22:40:46.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,170 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_DMAPI_H__
-#define __XFS_DMAPI_H__
-
-/*	Values used to define the on-disk version of dm_attrname_t. All
- *	on-disk attribute names start with the 8-byte string "SGI_DMI_".
- *
- *      In the on-disk inode, DMAPI attribute names consist of the user-provided
- *      name with the DMATTR_PREFIXSTRING pre-pended.  This string must NEVER be
- *      changed.
- */
-
-#define DMATTR_PREFIXLEN	8
-#define DMATTR_PREFIXSTRING	"SGI_DMI_"
-
-typedef enum {
-	DM_EVENT_INVALID	= -1,
-	DM_EVENT_CANCEL		= 0,		/* not supported */
-	DM_EVENT_MOUNT		= 1,
-	DM_EVENT_PREUNMOUNT	= 2,
-	DM_EVENT_UNMOUNT	= 3,
-	DM_EVENT_DEBUT		= 4,		/* not supported */
-	DM_EVENT_CREATE		= 5,
-	DM_EVENT_CLOSE		= 6,		/* not supported */
-	DM_EVENT_POSTCREATE	= 7,
-	DM_EVENT_REMOVE		= 8,
-	DM_EVENT_POSTREMOVE	= 9,
-	DM_EVENT_RENAME		= 10,
-	DM_EVENT_POSTRENAME	= 11,
-	DM_EVENT_LINK		= 12,
-	DM_EVENT_POSTLINK	= 13,
-	DM_EVENT_SYMLINK	= 14,
-	DM_EVENT_POSTSYMLINK	= 15,
-	DM_EVENT_READ		= 16,
-	DM_EVENT_WRITE		= 17,
-	DM_EVENT_TRUNCATE	= 18,
-	DM_EVENT_ATTRIBUTE	= 19,
-	DM_EVENT_DESTROY	= 20,
-	DM_EVENT_NOSPACE	= 21,
-	DM_EVENT_USER		= 22,
-	DM_EVENT_MAX		= 23
-} dm_eventtype_t;
-#define HAVE_DM_EVENTTYPE_T
-
-typedef enum {
-	DM_RIGHT_NULL,
-	DM_RIGHT_SHARED,
-	DM_RIGHT_EXCL
-} dm_right_t;
-#define HAVE_DM_RIGHT_T
-
-/* Defines for determining if an event message should be sent. */
-#ifdef HAVE_DMAPI
-#define	DM_EVENT_ENABLED(ip, event) ( \
-	unlikely ((ip)->i_mount->m_flags & XFS_MOUNT_DMAPI) && \
-		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
-		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
-	)
-#else
-#define DM_EVENT_ENABLED(ip, event)	(0)
-#endif
-
-#define DM_XFS_VALID_FS_EVENTS		( \
-	(1 << DM_EVENT_PREUNMOUNT)	| \
-	(1 << DM_EVENT_UNMOUNT)		| \
-	(1 << DM_EVENT_NOSPACE)		| \
-	(1 << DM_EVENT_DEBUT)		| \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events valid in dm_set_eventlist() when called with a file handle for
-   a regular file or a symlink.  These events are persistent.
-*/
-
-#define	DM_XFS_VALID_FILE_EVENTS	( \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events valid in dm_set_eventlist() when called with a file handle for
-   a directory.  These events are persistent.
-*/
-
-#define	DM_XFS_VALID_DIRECTORY_EVENTS	( \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events supported by the XFS filesystem. */
-#define	DM_XFS_SUPPORTED_EVENTS		( \
-	(1 << DM_EVENT_MOUNT)		| \
-	(1 << DM_EVENT_PREUNMOUNT)	| \
-	(1 << DM_EVENT_UNMOUNT)		| \
-	(1 << DM_EVENT_NOSPACE)		| \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_READ)		| \
-	(1 << DM_EVENT_WRITE)		| \
-	(1 << DM_EVENT_TRUNCATE)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-
-/*
- *	Definitions used for the flags field on dm_send_*_event().
- */
-
-#define DM_FLAGS_NDELAY		0x001	/* return EAGAIN after dm_pending() */
-#define DM_FLAGS_UNWANTED	0x002	/* event not in fsys dm_eventset_t */
-#define DM_FLAGS_IMUX		0x004	/* thread holds i_mutex */
-#define DM_FLAGS_IALLOCSEM_RD	0x010	/* thread holds i_alloc_sem rd */
-#define DM_FLAGS_IALLOCSEM_WR	0x020	/* thread holds i_alloc_sem wr */
-
-/*
- *	Pull in platform specific event flags defines
- */
-#include "xfs_dmapi_priv.h"
-
-/*
- *	Macros to turn caller specified delay/block flags into
- *	dm_send_xxxx_event flag DM_FLAGS_NDELAY.
- */
-
-#define FILP_DELAY_FLAG(filp) ((filp->f_flags&(O_NDELAY|O_NONBLOCK)) ? \
-			DM_FLAGS_NDELAY : 0)
-#define AT_DELAY_FLAG(f) ((f & XFS_ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
-
-#endif  /* __XFS_DMAPI_H__ */
Index: xfs/fs/xfs/xfs_dmops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dmops.c	2010-05-06 22:40:46.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,55 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_dmapi.h"
-#include "xfs_inum.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-
-
-static struct xfs_dmops xfs_dmcore_stub = {
-	.xfs_send_data		= (xfs_send_data_t)fs_nosys,
-	.xfs_send_mmap		= (xfs_send_mmap_t)fs_noerr,
-	.xfs_send_destroy	= (xfs_send_destroy_t)fs_nosys,
-	.xfs_send_namesp	= (xfs_send_namesp_t)fs_nosys,
-	.xfs_send_mount		= (xfs_send_mount_t)fs_nosys,
-	.xfs_send_unmount	= (xfs_send_unmount_t)fs_noerr,
-};
-
-int
-xfs_dmops_get(struct xfs_mount *mp)
-{
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		cmn_err(CE_WARN,
-			"XFS: dmapi support not available in this kernel.");
-		return EINVAL;
-	}
-
-	mp->m_dm_ops = &xfs_dmcore_stub;
-	return 0;
-}
-
-void
-xfs_dmops_put(struct xfs_mount *mp)
-{
-}
Index: xfs/fs/xfs/xfs_error.c
===================================================================
--- xfs.orig/fs/xfs/xfs_error.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_error.c	2010-05-10 15:34:13.199003848 +0200
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-05-10 13:47:55.000000000 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-10 15:33:08.027255558 +0200
@@ -24,7 +24,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_filestream.c	2010-05-10 15:34:13.205004616 +0200
@@ -24,7 +24,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2010-05-10 15:34:13.216253953 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2010-05-10 15:34:13.227254302 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2010-05-10 15:34:13.236254372 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-10 15:34:13.251275115 +0200
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-10 15:34:13.260253464 +0200
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-10 15:34:13.267254093 +0200
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-05-07 11:52:53.000000000 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-05-10 15:34:13.276003848 +0200
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_itable.c	2010-05-10 15:34:13.282003778 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-05-10 15:34:13.290004058 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-05-10 15:34:13.303027245 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_bmap_btree.h"
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-05-10 15:34:13.311007270 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-05-10 15:32:31.856003989 +0200
+++ xfs/fs/xfs/xfs_mount.h	2010-05-10 15:33:08.077252765 +0200
@@ -66,65 +66,6 @@ struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
 
-
-/*
- * Prototypes and functions for the Data Migration subsystem.
- */
-
-typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
-			xfs_off_t, size_t, int, int *);
-typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
-typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
-typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
-			struct xfs_inode *, dm_right_t,
-			struct xfs_inode *, dm_right_t,
-			const unsigned char *, const unsigned char *,
-			mode_t, int, int);
-typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
-			char *, char *);
-typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
-			dm_right_t, mode_t, int, int);
-
-typedef struct xfs_dmops {
-	xfs_send_data_t		xfs_send_data;
-	xfs_send_mmap_t		xfs_send_mmap;
-	xfs_send_destroy_t	xfs_send_destroy;
-	xfs_send_namesp_t	xfs_send_namesp;
-	xfs_send_mount_t	xfs_send_mount;
-	xfs_send_unmount_t	xfs_send_unmount;
-} xfs_dmops_t;
-
-#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
-	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
-
-#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
-	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
-#define XFS_SEND_MMAP(mp, vma,fl) \
-	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
-#define XFS_SEND_DESTROY(mp, ip,right) \
-	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
-#define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_MOUNT(mp,right,path,name) \
-	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_PREUNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT, mp, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
-#define XFS_SEND_UNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_unmount)(mp, (mp)->m_rootip, \
-			DM_RIGHT_NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
-
-
 #ifdef HAVE_PERCPU_SB
 
 /*
@@ -241,8 +182,6 @@ typedef struct xfs_mount {
 	uint			m_chsize;	/* size of next field */
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
-	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
-	struct xfs_qmops	*m_qm_ops;	/* vector of XQM ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
 	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
@@ -439,11 +378,6 @@ extern int	xfs_sb_validate_fsb_count(str
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
-extern int	xfs_dmops_get(struct xfs_mount *);
-extern void	xfs_dmops_put(struct xfs_mount *);
-
-extern struct xfs_dmops xfs_dmcore_xfs;
-
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_rtalloc.c	2010-05-10 15:34:13.329004337 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_rw.c	2010-05-10 15:34:13.337254302 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-10 15:34:13.345274277 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_da_btree.h"
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2010-05-10 15:33:08.092272530 +0200
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-10 15:32:31.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-10 15:34:13.355254093 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_trans_extfree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_extfree.c	2010-05-10 13:47:55.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_extfree.c	2010-05-10 15:33:08.103005733 +0200
@@ -23,7 +23,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-05-10 13:47:55.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-10 15:34:13.369004267 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2010-05-06 22:40:46.000000000 +0200
+++ xfs/fs/xfs/xfs_utils.c	2010-05-10 15:34:13.377012020 +0200
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
Index: xfs/fs/xfs/xfs_trans_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_item.c	2010-05-10 15:34:14.401255698 +0200
+++ xfs/fs/xfs/xfs_trans_item.c	2010-05-10 15:34:17.939005663 +0200
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 
 STATIC int	xfs_trans_unlock_chunk(xfs_log_item_chunk_t *,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
