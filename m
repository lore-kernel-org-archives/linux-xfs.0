Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CEL3Zm249152 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 09:21:03 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4oEIVdqbFCaN4Vdn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 07:21:01 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 18/27] xfs: Convert to new freezing code
Date: Tue, 12 Jun 2012 16:20:39 +0200
Message-Id: <1339510848-16992-19-git-send-email-jack@suse.cz>
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@suse.cz, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>

Generic code now blocks all writers from standard write paths. So we add
blocking of all writers coming from ioctl (we get a protection of ioctl against
racing remount read-only as a bonus) and convert xfs_file_aio_write() to a
non-racy freeze protection. We also keep freeze protection on transaction
start to block internal filesystem writes such as removal of preallocated
blocks.

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
CC: xfs@oss.sgi.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c    |   18 ++++++++++++++++
 fs/xfs/xfs_file.c    |   10 ++++++--
 fs/xfs/xfs_ioctl.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_ioctl32.c |   12 ++++++++++
 fs/xfs/xfs_iomap.c   |    4 +-
 fs/xfs/xfs_mount.c   |    2 +-
 fs/xfs/xfs_mount.h   |    3 --
 fs/xfs/xfs_sync.c    |    2 +-
 fs/xfs/xfs_trans.c   |   17 ++++++++++++--
 fs/xfs/xfs_trans.h   |    2 +
 10 files changed, 109 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ae31c31..4a001b8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -124,6 +124,12 @@ xfs_setfilesize_trans_alloc(
 	ioend->io_append_trans = tp;
 
 	/*
+	 * We will pass freeze protection with a transaction.  So tell lockdep
+	 * we released it.
+	 */
+	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
+		      1, _THIS_IP_);
+	/*
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
@@ -199,6 +205,15 @@ xfs_end_io(
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
 	int		error = 0;
 
+	if (ioend->io_append_trans) {
+		/*
+		 * We've got freeze protection passed with the transaction.
+		 * Tell lockdep about it.
+		 */
+		rwsem_acquire_read(
+			&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
+			0, 1, _THIS_IP_);
+	}
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ioend->io_error = -EIO;
 		goto done;
@@ -1405,6 +1420,9 @@ out_trans_cancel:
 	if (ioend->io_append_trans) {
 		current_set_flags_nested(&ioend->io_append_trans->t_pflags,
 					 PF_FSTRANS);
+		rwsem_acquire_read(
+			&inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
+			0, 1, _THIS_IP_);
 		xfs_trans_cancel(ioend->io_append_trans, 0);
 	}
 out_destroy_ioend:
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..f0081f2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -781,10 +781,12 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		ret = -EIO;
+		goto out;
+	}
 
 	if (unlikely(file->f_flags & O_DIRECT))
 		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
@@ -803,6 +805,8 @@ xfs_file_aio_write(
 			ret = err;
 	}
 
+out:
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3a05a41..63624fb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -361,9 +361,15 @@ xfs_fssetdm_by_handle(
 	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	error = mnt_want_write_file(parfilp);
+	if (error)
+		return error;
+
 	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
-	if (IS_ERR(dentry))
+	if (IS_ERR(dentry)) {
+		mnt_drop_write_file(parfilp);
 		return PTR_ERR(dentry);
+	}
 
 	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
 		error = -XFS_ERROR(EPERM);
@@ -379,6 +385,7 @@ xfs_fssetdm_by_handle(
 				 fsd.fsd_dmstate);
 
  out:
+	mnt_drop_write_file(parfilp);
 	dput(dentry);
 	return error;
 }
@@ -631,7 +638,11 @@ xfs_ioc_space(
 	if (ioflags & IO_INVIS)
 		attr_flags |= XFS_ATTR_DMI;
 
+	error = mnt_want_write_file(filp);
+	if (error)
+		return error;
 	error = xfs_change_file_space(ip, cmd, bf, filp->f_pos, attr_flags);
+	mnt_drop_write_file(filp);
 	return -error;
 }
 
@@ -1160,6 +1171,7 @@ xfs_ioc_fssetxattr(
 {
 	struct fsxattr		fa;
 	unsigned int		mask;
+	int error;
 
 	if (copy_from_user(&fa, arg, sizeof(fa)))
 		return -EFAULT;
@@ -1168,7 +1180,12 @@ xfs_ioc_fssetxattr(
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
 		mask |= FSX_NONBLOCK;
 
-	return -xfs_ioctl_setattr(ip, &fa, mask);
+	error = mnt_want_write_file(filp);
+	if (error)
+		return error;
+	error = xfs_ioctl_setattr(ip, &fa, mask);
+	mnt_drop_write_file(filp);
+	return -error;
 }
 
 STATIC int
@@ -1193,6 +1210,7 @@ xfs_ioc_setxflags(
 	struct fsxattr		fa;
 	unsigned int		flags;
 	unsigned int		mask;
+	int error;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
@@ -1207,7 +1225,12 @@ xfs_ioc_setxflags(
 		mask |= FSX_NONBLOCK;
 	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
 
-	return -xfs_ioctl_setattr(ip, &fa, mask);
+	error = mnt_want_write_file(filp);
+	if (error)
+		return error;
+	error = xfs_ioctl_setattr(ip, &fa, mask);
+	mnt_drop_write_file(filp);
+	return -error;
 }
 
 STATIC int
@@ -1382,8 +1405,13 @@ xfs_file_ioctl(
 		if (copy_from_user(&dmi, arg, sizeof(dmi)))
 			return -XFS_ERROR(EFAULT);
 
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
+
 		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
 				dmi.fsd_dmstate);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 
@@ -1431,7 +1459,11 @@ xfs_file_ioctl(
 
 		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
 			return -XFS_ERROR(EFAULT);
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_swapext(&sxp);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 
@@ -1460,9 +1492,14 @@ xfs_file_ioctl(
 		if (copy_from_user(&inout, arg, sizeof(inout)))
 			return -XFS_ERROR(EFAULT);
 
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
+
 		/* input parameter is passed in resblks field of structure */
 		in = inout.resblks;
 		error = xfs_reserve_blocks(mp, &in, &inout);
+		mnt_drop_write_file(filp);
 		if (error)
 			return -error;
 
@@ -1493,7 +1530,11 @@ xfs_file_ioctl(
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_growfs_data(mp, &in);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 
@@ -1503,7 +1544,11 @@ xfs_file_ioctl(
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_growfs_log(mp, &in);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 
@@ -1513,7 +1558,11 @@ xfs_file_ioctl(
 		if (copy_from_user(&in, arg, sizeof(in)))
 			return -XFS_ERROR(EFAULT);
 
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_growfs_rt(mp, &in);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4f2da0..1244274 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -600,7 +600,11 @@ xfs_file_compat_ioctl(
 
 		if (xfs_compat_growfs_data_copyin(&in, arg))
 			return -XFS_ERROR(EFAULT);
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_growfs_data(mp, &in);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 	case XFS_IOC_FSGROWFSRT_32: {
@@ -608,7 +612,11 @@ xfs_file_compat_ioctl(
 
 		if (xfs_compat_growfs_rt_copyin(&in, arg))
 			return -XFS_ERROR(EFAULT);
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_growfs_rt(mp, &in);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 #endif
@@ -627,7 +635,11 @@ xfs_file_compat_ioctl(
 				   offsetof(struct xfs_swapext, sx_stat)) ||
 		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
 			return -XFS_ERROR(EFAULT);
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
 		error = xfs_swapext(&sxp);
+		mnt_drop_write_file(filp);
 		return -error;
 	}
 	case XFS_IOC_FSBULKSTAT_32:
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index aadfce6..b3b9b26 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -680,9 +680,9 @@ xfs_iomap_write_unwritten(
 		 * the same inode that we complete here and might deadlock
 		 * on the iolock.
 		 */
-		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
+		sb_start_intwrite(mp->m_super);
 		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
-		tp->t_flags |= XFS_TRANS_RESERVE;
+		tp->t_flags |= XFS_TRANS_RESERVE | XFS_TRANS_FREEZE_PROT;
 		error = xfs_trans_reserve(tp, resblks,
 				XFS_WRITE_LOG_RES(mp), 0,
 				XFS_TRANS_PERM_LOG_RES,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 536021f..b09a4a7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1544,7 +1544,7 @@ xfs_unmountfs(
 int
 xfs_fs_writable(xfs_mount_t *mp)
 {
-	return !(xfs_test_for_freeze(mp) || XFS_FORCED_SHUTDOWN(mp) ||
+	return !(mp->m_super->s_writers.frozen || XFS_FORCED_SHUTDOWN(mp) ||
 		(mp->m_flags & XFS_MOUNT_RDONLY));
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8b89c5a..401ca2e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -314,9 +314,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
 #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
-#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
-#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
-
 /*
  * Flags for xfs_mountfs
  */
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index c9d3409..9986c7a 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -392,7 +392,7 @@ xfs_sync_worker(
 	if (down_read_trylock(&mp->m_super->s_umount)) {
 		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 			/* dgc: errors ignored here */
-			if (mp->m_super->s_frozen == SB_UNFROZEN &&
+			if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
 			    xfs_log_need_covered(mp))
 				error = xfs_fs_log_dummy(mp);
 			else
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fdf3245..06ed520 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -576,8 +576,12 @@ xfs_trans_alloc(
 	xfs_mount_t	*mp,
 	uint		type)
 {
-	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type, KM_SLEEP);
+	xfs_trans_t     *tp;
+
+	sb_start_intwrite(mp->m_super);
+	tp = _xfs_trans_alloc(mp, type, KM_SLEEP);
+	tp->t_flags |= XFS_TRANS_FREEZE_PROT;
+	return tp;
 }
 
 xfs_trans_t *
@@ -588,6 +592,7 @@ _xfs_trans_alloc(
 {
 	xfs_trans_t	*tp;
 
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	atomic_inc(&mp->m_active_trans);
 
 	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
@@ -611,6 +616,8 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	atomic_dec(&tp->t_mountp->m_active_trans);
+	if (tp->t_flags & XFS_TRANS_FREEZE_PROT)
+		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
 	kmem_zone_free(xfs_trans_zone, tp);
 }
@@ -643,7 +650,11 @@ xfs_trans_dup(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(tp->t_ticket != NULL);
 
-	ntp->t_flags = XFS_TRANS_PERM_LOG_RES | (tp->t_flags & XFS_TRANS_RESERVE);
+	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
+		       (tp->t_flags & XFS_TRANS_RESERVE) |
+		       (tp->t_flags & XFS_TRANS_FREEZE_PROT);
+	/* We gave our writer reference to the new transaction */
+	tp->t_flags &= ~XFS_TRANS_FREEZE_PROT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
 	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7c37b53..19c1742 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -179,6 +179,8 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
+#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
+					   count in superblock */
 
 /*
  * Values for call flags parameter.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
