Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 785C229DFC
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 07:51:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1ED69AC001
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 05:51:53 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id E9cnEHJ5bNE0IwEy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 05:51:50 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z0896-0004eE-2c
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 12:51:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: saner xfs_trans_commit interface
Date: Wed,  3 Jun 2015 14:49:55 +0200
Message-Id: <1433335796-23445-5-git-send-email-hch@lst.de>
In-Reply-To: <1433335796-23445-1-git-send-email-hch@lst.de>
References: <1433335796-23445-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The flags argument to xfs_trans_commit is not useful for most callers, as
a commit of a transaction without a permanent log reservation must pass
0 here, and all callers for a transaction with a permanent log reservation
except for xfs_trans_roll must pass XFS_TRANS_RELEASE_LOG_RES.  So remove
the flags argument from the public xfs_trans_commit interfaces, and
introduce low-level __xfs_trans_commit variant just for xfs_trans_roll
that regrants a log reservation instead of releasing it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   |  7 +++----
 fs/xfs/libxfs/xfs_bmap.c   |  5 ++---
 fs/xfs/libxfs/xfs_sb.c     |  2 +-
 fs/xfs/libxfs/xfs_shared.h |  5 -----
 fs/xfs/xfs_aops.c          |  2 +-
 fs/xfs/xfs_attr_inactive.c |  2 +-
 fs/xfs/xfs_bmap_util.c     | 11 +++++------
 fs/xfs/xfs_dquot.c         |  2 +-
 fs/xfs/xfs_file.c          |  2 +-
 fs/xfs/xfs_fsops.c         |  2 +-
 fs/xfs/xfs_inode.c         | 14 +++++++-------
 fs/xfs/xfs_ioctl.c         |  6 +++---
 fs/xfs/xfs_iomap.c         |  6 +++---
 fs/xfs/xfs_iops.c          |  6 +++---
 fs/xfs/xfs_log.h           |  2 +-
 fs/xfs/xfs_log_cil.c       |  4 ++--
 fs/xfs/xfs_log_recover.c   |  4 ++--
 fs/xfs/xfs_pnfs.c          |  2 +-
 fs/xfs/xfs_qm.c            |  2 +-
 fs/xfs/xfs_qm_syscalls.c   |  9 ++++-----
 fs/xfs/xfs_rtalloc.c       |  6 +++---
 fs/xfs/xfs_symlink.c       |  4 ++--
 fs/xfs/xfs_trans.c         | 35 +++++++++++++++++++----------------
 fs/xfs/xfs_trans.h         |  2 +-
 24 files changed, 68 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 126da7f..3349c9a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -320,8 +320,7 @@ xfs_attr_set(
 				xfs_trans_ichgtime(args.trans, dp,
 							XFS_ICHGTIME_CHG);
 			}
-			err2 = xfs_trans_commit(args.trans,
-						 XFS_TRANS_RELEASE_LOG_RES);
+			err2 = xfs_trans_commit(args.trans);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 			return error ? error : err2;
@@ -383,7 +382,7 @@ xfs_attr_set(
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 	return error;
@@ -499,7 +498,7 @@ xfs_attr_remove(
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 	return error;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eacf0e9..a334633 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1215,7 +1215,7 @@ xfs_bmap_add_attrfork(
 	error = xfs_bmap_finish(&tp, &flist, &committed);
 	if (error)
 		goto bmap_cancel;
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
@@ -5941,8 +5941,7 @@ xfs_bmap_split_extent(
 	if (error)
 		goto out;
 
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-
+	return xfs_trans_commit(tp);
 
 out:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e1b3286..df9851c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -825,5 +825,5 @@ xfs_sync_sb(
 	xfs_log_sb(tp);
 	if (wait)
 		xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp, 0);
+	return xfs_trans_commit(tp);
 }
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 930cc7d..5be5297 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -182,11 +182,6 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
 					   count in superblock */
 /*
- * Values for call flags parameter.
- */
-#define	XFS_TRANS_RELEASE_LOG_RES	0x4
-
-/*
  * Field values for xfs_trans_mod_sb.
  */
 #define	XFS_TRANS_SB_ICOUNT		0x00000001
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3890a38..7246a39 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -155,7 +155,7 @@ xfs_setfilesize(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	return xfs_trans_commit(tp, 0);
+	return xfs_trans_commit(tp);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index cd09fa5..69a154c 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -447,7 +447,7 @@ xfs_attr_inactive(
 	/* Reset the attribute fork - this also destroys the in-core fork */
 	xfs_attr_fork_remove(dp, trans);
 
-	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(trans);
 	xfs_iunlock(dp, lock_mode);
 	return error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7e795cf..1f0215d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -893,8 +893,7 @@ xfs_free_eofblocks(
 			 */
 			xfs_trans_cancel(tp);
 		} else {
-			error = xfs_trans_commit(tp,
-						XFS_TRANS_RELEASE_LOG_RES);
+			error = xfs_trans_commit(tp);
 			if (!error)
 				xfs_inode_clear_eofblocks_tag(ip);
 		}
@@ -1034,7 +1033,7 @@ xfs_alloc_file_space(
 			goto error0;
 		}
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error) {
 			break;
@@ -1301,7 +1300,7 @@ xfs_free_file_space(
 			goto error0;
 		}
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
@@ -1473,7 +1472,7 @@ xfs_shift_file_space(
 		if (error)
 			goto out;
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 	}
 
 	return error;
@@ -1882,7 +1881,7 @@ xfs_swap_extents(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
 
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ab0ae1f..4143dc7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -666,7 +666,7 @@ xfs_qm_dqread(
 	xfs_trans_brelse(tp, bp);
 
 	if (tp) {
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 		if (error)
 			goto error0;
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ac8d532..aa0d190 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -160,7 +160,7 @@ xfs_update_prealloc_flags(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	if (flags & XFS_PREALLOC_SYNC)
 		xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp, 0);
+	return xfs_trans_commit(tp);
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e988f0f..9b3438a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -491,7 +491,7 @@ xfs_growfs_data_private(
 	if (dpct)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
 	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8639398..112ebfb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1230,7 +1230,7 @@ xfs_create(
 	if (error)
 		goto out_bmap_cancel;
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_release_inode;
 
@@ -1339,7 +1339,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_release_inode;
 
@@ -1465,7 +1465,7 @@ xfs_link(
 		goto error_return;
 	}
 
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	return xfs_trans_commit(tp);
 
  error_return:
 	xfs_trans_cancel(tp);
@@ -1702,7 +1702,7 @@ xfs_inactive_truncate(
 
 	ASSERT(ip->i_d.di_nextents == 0);
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto error_unlock;
 
@@ -1799,7 +1799,7 @@ xfs_inactive_ifree(
 	if (error)
 		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
 			__func__, error);
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
 			__func__, error);
@@ -2577,7 +2577,7 @@ xfs_remove(
 	if (error)
 		goto out_bmap_cancel;
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto std_return;
 
@@ -2667,7 +2667,7 @@ xfs_finish_rename(
 		return error;
 	}
 
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	return xfs_trans_commit(tp);
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3abd3c4..ea7d85a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -346,7 +346,7 @@ xfs_set_dmattrs(
 	ip->i_d.di_dmstate  = state;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 
 	return error;
 }
@@ -1253,7 +1253,7 @@ xfs_ioctl_setattr(
 	else
 		ip->i_d.di_extsize = 0;
 
-	code = xfs_trans_commit(tp, 0);
+	code = xfs_trans_commit(tp);
 
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
@@ -1342,7 +1342,7 @@ xfs_ioc_setxflags(
 		goto out_drop_write;
 	}
 
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 out_drop_write:
 	mnt_drop_write_file(filp);
 	return error;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6ca842a..1f86033 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -213,7 +213,7 @@ xfs_iomap_write_direct(
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto out_bmap_cancel;
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_unlock;
 
@@ -760,7 +760,7 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
-			error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+			error = xfs_trans_commit(tp);
 			if (error)
 				goto error0;
 
@@ -890,7 +890,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8bd71f1..e440aed 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -702,7 +702,7 @@ xfs_setattr_nonsize(
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -926,7 +926,7 @@ xfs_setattr_size(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 out_unlock:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
@@ -1002,7 +1002,7 @@ xfs_vn_update_time(
 	}
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
-	return xfs_trans_commit(tp, 0);
+	return xfs_trans_commit(tp);
 }
 
 #define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 84e0deb..4040c47 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -183,7 +183,7 @@ struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
 void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_lsn_t *commit_lsn, int flags);
+				xfs_lsn_t *commit_lsn, bool regrant);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 7e0e63e..d6f26d7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -773,13 +773,13 @@ xfs_log_commit_cil(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_lsn_t		*commit_lsn,
-	int			flags)
+	bool			regrant)
 {
 	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
 	int			log_flags = 0;
 
-	if (flags & XFS_TRANS_RELEASE_LOG_RES)
+	if (!regrant)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
 	/* lock out background commit */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7e4fdcbd..299fbaf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3761,7 +3761,7 @@ xlog_recover_process_efi(
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
@@ -3867,7 +3867,7 @@ xlog_recover_clear_agi_bucket(
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_error;
 	return;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 3bb6097..ab4a606 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -321,7 +321,7 @@ xfs_fs_commit_blocks(
 	}
 
 	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 
 out_drop_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c4ba36d..eac9549 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -795,7 +795,7 @@ xfs_qm_qino_alloc(
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 92ad24f..3640c6e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -259,7 +259,7 @@ xfs_qm_scall_trunc_qfile(
 	ASSERT(ip->i_d.di_nextents == 0);
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
@@ -547,7 +547,7 @@ xfs_qm_scall_setqlim(
 	dqp->dq_flags |= XFS_DQ_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
 
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 
 out_rele:
 	xfs_qm_dqrele(dqp);
@@ -584,8 +584,7 @@ xfs_qm_log_quotaoff_end(
 	 * We don't care about quotoff's performance.
 	 */
 	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-	return error;
+	return xfs_trans_commit(tp);
 }
 
 
@@ -623,7 +622,7 @@ xfs_qm_log_quotaoff(
 	 * We don't care about quotoff's performance.
 	 */
 	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ff5af66..f4e8c06 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -815,7 +815,7 @@ xfs_growfs_rt_alloc(
 		error = xfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
 			goto error_cancel;
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		error = xfs_trans_commit(tp);
 		if (error)
 			goto error;
 		/*
@@ -855,7 +855,7 @@ error_cancel:
 			/*
 			 * Commit the transaction.
 			 */
-			error = xfs_trans_commit(tp, 0);
+			error = xfs_trans_commit(tp);
 			if (error)
 				goto error;
 		}
@@ -1070,7 +1070,7 @@ error_cancel:
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
 
-		error = xfs_trans_commit(tp, 0);
+		error = xfs_trans_commit(tp);
 		if (error)
 			break;
 	}
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b5573bf..2d90452 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -390,7 +390,7 @@ xfs_symlink(
 	if (error)
 		goto out_bmap_cancel;
 
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_release_inode;
 
@@ -528,7 +528,7 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Commit the transaction containing extent freeing and EFDs.
 	 */
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		goto error_unlock;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6cca996..fb1bd17 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -892,27 +892,17 @@ xfs_trans_committed_bulk(
  * have already been unlocked as if the commit had succeeded.
  * Do not reference the transaction structure after this call.
  */
-int
-xfs_trans_commit(
+static int
+__xfs_trans_commit(
 	struct xfs_trans	*tp,
-	uint			flags)
+	bool			regrant)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_lsn_t		commit_lsn = -1;
 	int			error = 0;
-	int			log_flags = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
 	/*
-	 * Determine whether this commit is releasing a permanent
-	 * log reservation or not.
-	 */
-	if (flags & XFS_TRANS_RELEASE_LOG_RES) {
-		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-		log_flags = XFS_LOG_REL_PERM_RESERV;
-	}
-
-	/*
 	 * If there is nothing to be logged by the transaction,
 	 * then unlock all of the items associated with the
 	 * transaction and free the transaction structure.
@@ -936,7 +926,7 @@ xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
+	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free(tp);
@@ -964,6 +954,12 @@ out_unreserve:
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
+		int			log_flags = 0;
+
+		if (regrant)
+			ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+		else
+			log_flags = XFS_LOG_REL_PERM_RESERV;
 		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 		if (commit_lsn == -1 && !error)
 			error = -EIO;
@@ -976,6 +972,13 @@ out_unreserve:
 	return error;
 }
 
+int
+xfs_trans_commit(
+	struct xfs_trans	*tp)
+{
+	return __xfs_trans_commit(tp, false);
+}
+
 /*
  * Unlock all of the transaction's items and free the transaction.
  * The transaction must not have modified any of its items, because
@@ -1029,7 +1032,7 @@ xfs_trans_cancel(
 /*
  * Roll from one trans in the sequence of PERMANENT transactions to
  * the next: permanent transactions are only flushed out when
- * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
+ * committed with xfs_trans_commit(), but we still want as soon
  * as possible to let chunks of it go to the log. So we commit the
  * chunk we've been working on and get a new transaction to continue.
  */
@@ -1063,7 +1066,7 @@ xfs_trans_roll(
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
-	error = xfs_trans_commit(trans, 0);
+	error = __xfs_trans_commit(trans, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ca95b92..3b21b4e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -225,7 +225,7 @@ void		xfs_trans_log_efd_extent(xfs_trans_t *,
 					 struct xfs_efd_log_item *,
 					 xfs_fsblock_t,
 					 xfs_extlen_t);
-int		xfs_trans_commit(xfs_trans_t *, uint flags);
+int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
