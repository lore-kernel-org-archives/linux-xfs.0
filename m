Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71D5F7CAB
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:52:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1E97AC010
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:52:49 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id dTkhMqWIprF1o602 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:52:43 -0800 (PST)
Received: from 212095007014.public.telering.at ([212.95.7.14] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aVxqk-0003HK-Al
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 08:52:42 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: better xfs_trans_alloc interface
Date: Wed, 17 Feb 2016 09:52:38 +0100
Message-Id: <1455699159-20906-2-git-send-email-hch@lst.de>
In-Reply-To: <1455699159-20906-1-git-send-email-hch@lst.de>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
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

Merge xfs_trans_reserve and xfs_trans_alloc into a single function call
that returns a transaction with all the required log and block reservations,
and which allows passing transaction flags directly to avoid the cumbersome
_xfs_trans_alloc interface.

While we're at it we also get rid of the transaction type argument that has
been superflous since we stopped supporting the non-CIL logging mode.  The
guts of it will be removed in another patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   | 58 +++++++-----------------------
 fs/xfs/libxfs/xfs_bmap.c   | 22 +++++-------
 fs/xfs/libxfs/xfs_sb.c     |  8 ++---
 fs/xfs/libxfs/xfs_shared.h |  5 +--
 fs/xfs/xfs_aops.c          | 19 ++++------
 fs/xfs/xfs_attr_inactive.c | 16 ++-------
 fs/xfs/xfs_bmap_util.c     | 45 +++++++-----------------
 fs/xfs/xfs_dquot.c         |  7 ++--
 fs/xfs/xfs_file.c          |  8 ++---
 fs/xfs/xfs_fsops.c         | 10 ++----
 fs/xfs/xfs_inode.c         | 60 ++++++++++++-------------------
 fs/xfs/xfs_ioctl.c         | 13 +++----
 fs/xfs/xfs_iomap.c         | 53 +++++++++-------------------
 fs/xfs/xfs_iops.c          | 22 +++++-------
 fs/xfs/xfs_log_recover.c   | 10 +++---
 fs/xfs/xfs_pnfs.c          |  7 ++--
 fs/xfs/xfs_qm.c            |  9 ++---
 fs/xfs/xfs_qm_syscalls.c   | 26 ++++----------
 fs/xfs/xfs_rtalloc.c       | 21 +++++------
 fs/xfs/xfs_symlink.c       | 16 ++++-----
 fs/xfs/xfs_trans.c         | 88 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_trans.h         |  8 ++---
 22 files changed, 188 insertions(+), 343 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fa3b948..4e126f4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -242,37 +242,21 @@ xfs_attr_set(
 			return error;
 	}
 
-	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_SET);
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-
-	if (rsvd)
-		args.trans->t_flags |= XFS_TRANS_RESERVE;
-
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
-	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
-	if (error) {
-		xfs_trans_cancel(args.trans);
+	error = xfs_trans_alloc(mp, &tres, args.total, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	if (error)
 		return error;
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
 				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 				       XFS_QMOPT_RES_REGBLKS);
@@ -429,31 +413,15 @@ xfs_attr_remove(
 		return error;
 
 	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	args.trans = xfs_trans_alloc(mp, XFS_TRANS_ATTR_RM);
-
-	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-
-	if (flags & ATTR_ROOT)
-		args.trans->t_flags |= XFS_TRANS_RESERVE;
-
-	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
-				  XFS_ATTRRM_SPACE_RES(mp), 0);
-	if (error) {
-		xfs_trans_cancel(args.trans);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
+			XFS_ATTRRM_SPACE_RES(mp), 0,
+			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			&args.trans);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	/*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cb58d72..2bc7e49 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1124,15 +1124,14 @@ xfs_bmap_add_attrfork(
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
+
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
-	if (rsvd)
-		tp->t_flags |= XFS_TRANS_RESERVE;
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
+	if (error)
 		return error;
-	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
@@ -5958,13 +5957,10 @@ xfs_bmap_split_extent(
 	xfs_fsblock_t           firstfsb;
 	int                     error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8a53eaa..12ca867 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -838,12 +838,10 @@ xfs_sync_sb(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0,
+			XFS_TRANS_NO_WRITECOUNT, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_log_sb(tp);
 	if (wait)
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 81ac870..7d4ab64 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -181,8 +181,9 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
-					   count in superblock */
+#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_NOFS		0x80	/* pass KM_NOFS to kmem_alloc */
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7a467b3..5d48aca 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -120,13 +120,9 @@ xfs_setfilesize_trans_alloc(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	ioend->io_append_trans = tp;
 
@@ -1386,13 +1382,10 @@ xfs_end_io_direct_write(
 
 		trace_xfs_end_io_direct_write_append(ip, offset, size);
 
-		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
-		if (error) {
-			xfs_trans_cancel(tp);
-			return error;
-		}
-		error = xfs_setfilesize(ip, tp, offset, size);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0,
+				&tp);
+		if (!error)
+			error = xfs_setfilesize(ip, tp, offset, size);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 2bb959a..55d2149 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -405,21 +405,11 @@ xfs_attr_inactive(
 		goto out_destroy_fork;
 	xfs_iunlock(dp, lock_mode);
 
-	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
 	lock_mode = 0;
-	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
-	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans);
 	if (error)
-		goto out_cancel;
+		goto out_destroy_fork;
 
 	lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(dp, lock_mode);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fd7f51c..d641569 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -899,19 +899,15 @@ xfs_free_eofblocks(
 		 * Free them up now by truncating the file to
 		 * its current size.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-
 		if (need_iolock) {
-			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-				xfs_trans_cancel(tp);
+			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 				return -EAGAIN;
-			}
 		}
 
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
+				&tp);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp);
 			if (need_iolock)
 				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
@@ -1036,9 +1032,9 @@ xfs_alloc_file_space(
 		/*
 		 * Allocate and setup the transaction.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-					  resblks, resrtextents);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
+				resrtextents, 0, &tp);
+
 		/*
 		 * Check for running out of space
 		 */
@@ -1047,7 +1043,6 @@ xfs_alloc_file_space(
 			 * Free the transaction structure.
 			 */
 			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp);
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1310,18 +1305,10 @@ xfs_free_file_space(
 		 * transaction to dip into the reserve blocks to ensure
 		 * the freeing of the space succeeds at ENOSPC.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
-
-		/*
-		 * check for running out of space
-		 */
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
+				&tp);
 		if (error) {
-			/*
-			 * Free the transaction structure.
-			 */
 			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp);
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1481,19 +1468,16 @@ xfs_shift_file_space(
 	}
 
 	while (!error && !done) {
-		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		/*
 		 * We would need to reserve permanent block for transaction.
 		 * This will come into picture when after shifting extent into
 		 * hole we found that adjacent extents can be merged which
 		 * may lead to freeing of a block during record update.
 		 */
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
-		if (error) {
-			xfs_trans_cancel(tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+		if (error)
 			break;
-		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
@@ -1746,12 +1730,9 @@ xfs_swap_extents(
 	if (error)
 		goto out_unlock;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
 		goto out_unlock;
-	}
 
 	/*
 	 * Lock and join the inodes to the tansaction so that transaction commit
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 316b2a1..23e2432 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -614,11 +614,10 @@ xfs_qm_dqread(
 	trace_xfs_dqread(dqp);
 
 	if (flags & XFS_QMOPT_DQALLOC) {
-		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_dqalloc,
-					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
+				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 		if (error)
-			goto error1;
+			goto error0;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ac0fd32..98bbd8f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -145,12 +145,10 @@ xfs_update_prealloc_flags(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
-	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_writeid, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_writeid,
+			0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ee3aaa0a..9c563d4 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -198,14 +198,10 @@ xfs_growfs_data_private(
 			return error;
 	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
-	tp->t_flags |= XFS_TRANS_RESERVE;
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
-				  XFS_GROWFS_SPACE_RES(mp), 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
+			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Write new AG headers to disk. Non-transactional, but written
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 96f606d..b82c729 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1161,11 +1161,9 @@ xfs_create(
 		rdev = 0;
 		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
-		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
 	} else {
 		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
-		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	}
 
 	/*
@@ -1174,20 +1172,19 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	error = xfs_trans_reserve(tp, tres, resblks, 0);
+	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_reserve(tp, tres, resblks, 0);
+		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	}
 	if (error == -ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
-		error = xfs_trans_reserve(tp, tres, 0, 0);
+		error = xfs_trans_alloc(mp, tres, 0, 0, 0, &tp);
 	}
 	if (error)
-		goto out_trans_cancel;
-
+		goto out_release_inode;
 
 	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
 		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
@@ -1337,17 +1334,16 @@ xfs_create_tmpfile(
 		return error;
 
 	resblks = XFS_IALLOC_SPACE_RES(mp);
-	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
-
 	tres = &M_RES(mp)->tr_create_tmpfile;
-	error = xfs_trans_reserve(tp, tres, resblks, 0);
+
+	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
-		error = xfs_trans_reserve(tp, tres, 0, 0);
+		error = xfs_trans_alloc(mp, tres, 0, 0, 0, &tp);
 	}
 	if (error)
-		goto out_trans_cancel;
+		goto out_release_inode;
 
 	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
 						pdqp, resblks, 1, 0);
@@ -1432,15 +1428,14 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
 	}
 	if (error)
-		goto error_return;
+		goto std_return;
 
 	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
@@ -1710,11 +1705,9 @@ xfs_inactive_truncate(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -1764,8 +1757,6 @@ xfs_inactive_ifree(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-
 	/*
 	 * The ifree transaction might need to allocate blocks for record
 	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
@@ -1781,9 +1772,8 @@ xfs_inactive_ifree(
 	 * now remains allocated and sits on the unlinked list until the fs is
 	 * repaired.
 	 */
-	tp->t_flags |= XFS_TRANS_RESERVE;
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
-				  XFS_IFREE_SPACE_RES(mp), 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
+			XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
 	if (error) {
 		if (error == -ENOSPC) {
 			xfs_warn_ratelimited(mp,
@@ -1792,7 +1782,6 @@ xfs_inactive_ifree(
 		} else {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		}
-		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -2525,11 +2514,6 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
-	if (is_dir)
-		tp = xfs_trans_alloc(mp, XFS_TRANS_RMDIR);
-	else
-		tp = xfs_trans_alloc(mp, XFS_TRANS_REMOVE);
-
 	/*
 	 * We try to get the real space reservation first,
 	 * allowing for directory btree deletion(s) implying
@@ -2540,14 +2524,15 @@ xfs_remove(
 	 * block from the directory.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_remove, resblks, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_remove, 0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
+				&tp);
 	}
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto out_trans_cancel;
+		goto std_return;
 	}
 
 	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
@@ -2910,15 +2895,15 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		spaceres = 0;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
+				&tp);
 	}
 	if (error)
-		goto out_trans_cancel;
+		goto out_release_wip;
 
 	/*
 	 * Attach the dquots to the inodes
@@ -3155,6 +3140,7 @@ out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_release_wip:
 	if (wip)
 		IRELE(wip);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 81d6d62..405648b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -334,12 +334,10 @@ xfs_set_dmattrs(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_DMATTRS);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
@@ -1078,10 +1076,9 @@ xfs_ioctl_setattr_get_trans(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return ERR_PTR(-EIO);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
-		goto out_cancel;
+		return ERR_PTR(error);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d81bdc0..5839135 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -132,6 +132,7 @@ xfs_iomap_write_direct(
 	int		error;
 	int		lockmode;
 	int		bmapi_flags = XFS_BMAPI_PREALLOC;
+	uint		tflags = 0;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
@@ -192,11 +193,6 @@ xfs_iomap_write_direct(
 		return error;
 
 	/*
-	 * Allocate and setup the transaction
-	 */
-	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-
-	/*
 	 * For DAX, we do not allocate unwritten extents, but instead we zero
 	 * the block before we commit the transaction.  Ideally we'd like to do
 	 * this outside the transaction context, but if we commit and then crash
@@ -209,23 +205,17 @@ xfs_iomap_write_direct(
 	 * the reserve block pool for bmbt block allocation if there is no space
 	 * left but we need to do unwritten extent conversion.
 	 */
-
 	if (IS_DAX(VFS_I(ip))) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (ISUNWRITTEN(imap)) {
-			tp->t_flags |= XFS_TRANS_RESERVE;
+			tflags |= XFS_TRANS_RESERVE;
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-				  resblks, resrtextents);
-	/*
-	 * Check for running out of space, note: need lock to return
-	 */
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
+			tflags, &tp);
+	if (error)
 		return error;
-	}
 
 	lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockmode);
@@ -726,15 +716,13 @@ xfs_iomap_write_allocate(
 
 		nimaps = 0;
 		while (nimaps == 0) {
-			tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
-			tp->t_flags |= XFS_TRANS_RESERVE;
 			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-						  nres, 0);
-			if (error) {
-				xfs_trans_cancel(tp);
+
+			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
+					0, XFS_TRANS_RESERVE, &tp);
+			if (error)
 				return error;
-			}
+
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, 0);
 
@@ -878,25 +866,18 @@ xfs_iomap_write_unwritten(
 
 	do {
 		/*
-		 * set up a transaction to convert the range of extents
+		 * Set up a transaction to convert the range of extents
 		 * from unwritten to real. Do allocations in a loop until
 		 * we have covered the range passed in.
 		 *
-		 * Note that we open code the transaction allocation here
-		 * to pass KM_NOFS--we can't risk to recursing back into
-		 * the filesystem here as we might be asked to write out
-		 * the same inode that we complete here and might deadlock
-		 * on the iolock.
+		 * Note that we can't risk to recursing back into the filesystem
+		 * here as we might be asked to write out the same inode that we
+		 * complete here and might deadlock on the iolock.
 		 */
-		sb_start_intwrite(mp->m_super);
-		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
-		tp->t_flags |= XFS_TRANS_RESERVE | XFS_TRANS_FREEZE_PROT;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
-					  resblks, 0);
-		if (error) {
-			xfs_trans_cancel(tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+				XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
+		if (error)
 			return error;
-		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0d38b1d..3d9b1c48 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -599,10 +599,9 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
-		goto out_trans_cancel;
+		goto out_dqrele;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -724,8 +723,7 @@ xfs_setattr_nonsize(
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-out_trans_cancel:
-	xfs_trans_cancel(tp);
+out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	return error;
@@ -834,7 +832,7 @@ xfs_setattr_size(
 	 * We have to do all the page cache truncate work outside the
 	 * transaction context as the "lock" order is page lock->log space
 	 * reservation as defined by extent allocation in the writeback path.
-	 * Hence a truncate can fail with ENOMEM from xfs_trans_reserve(), but
+	 * Hence a truncate can fail with ENOMEM from xfs_trans_alloc(), but
 	 * having already truncated the in-memory version of the file (i.e. made
 	 * user visible changes). There's not much we can do about this, except
 	 * to hope that the caller sees ENOMEM and retries the truncate
@@ -849,10 +847,9 @@ xfs_setattr_size(
 		return error;
 	truncate_setsize(inode, newsize);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
-		goto out_trans_cancel;
+		return error;
 
 	lock_flags |= XFS_ILOCK_EXCL;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -971,12 +968,9 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (flags & S_CTIME)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1dc0e14..27e4962 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4140,10 +4140,9 @@ xlog_recover_process_efi(
 		}
 	}
 
-	tp = xfs_trans_alloc(mp, 0);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
-		goto abort_error;
+		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
@@ -4290,10 +4289,9 @@ xlog_recover_clear_agi_bucket(
 	int		offset;
 	int		error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_CLEAR_AGI_BUCKET);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_clearagi, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
 	if (error)
-		goto out_abort;
+		goto out_error;
 
 	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ade236e..3332bae 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -308,12 +308,9 @@ xfs_fs_commit_blocks(
 			goto out_drop_iolock;
 	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
 		goto out_drop_iolock;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index be125e1..a60d9e2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -783,13 +783,10 @@ xfs_qm_qino_alloc(
 		}
 	}
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_create,
-				  XFS_QM_QINOCREATE_SPACE_RES(mp), 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	if (need_alloc) {
 		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index f4d0e0a..475a388 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -236,10 +236,8 @@ xfs_qm_scall_trunc_qfile(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
-		xfs_trans_cancel(tp);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 		goto out_put;
 	}
@@ -436,12 +434,9 @@ xfs_qm_scall_setqlim(
 	defq = xfs_get_defquota(dqp, q);
 	xfs_dqunlock(dqp);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_setqlim, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
+	if (error)
 		goto out_rele;
-	}
 
 	xfs_dqlock(dqp);
 	xfs_trans_dqjoin(tp, dqp);
@@ -569,13 +564,9 @@ xfs_qm_log_quotaoff_end(
 	int			error;
 	xfs_qoff_logitem_t	*qoffi;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF_END);
-
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_equotaoff, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
@@ -603,12 +594,9 @@ xfs_qm_log_quotaoff(
 
 	*qoffstartp = NULL;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_quotaoff, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
+	if (error)
 		goto out;
-	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index abf4443..3938b37 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -780,15 +780,14 @@ xfs_growfs_rt_alloc(
 	 * Allocate space to the file, as necessary.
 	 */
 	while (oblocks < nblocks) {
-		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
 		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtalloc,
-					  resblks, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc, resblks,
+				0, 0, &tp);
 		if (error)
-			goto out_trans_cancel;
+			return error;
 		/*
 		 * Lock the inode.
 		 */
@@ -823,14 +822,13 @@ xfs_growfs_rt_alloc(
 		for (bno = map.br_startoff, fsbno = map.br_startblock;
 		     bno < map.br_startoff + map.br_blockcount;
 		     bno++, fsbno++) {
-			tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ZERO);
 			/*
 			 * Reserve log for one block zeroing.
 			 */
-			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtzero,
-						  0, 0);
+			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero,
+					0, 0, 0, &tp);
 			if (error)
-				goto out_trans_cancel;
+				return error;
 			/*
 			 * Lock the bitmap inode.
 			 */
@@ -994,11 +992,10 @@ xfs_growfs_rt(
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_FREE);
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtfree,
-					  0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtfree, 0, 0, 0,
+				&tp);
 		if (error)
-			goto error_cancel;
+			break;
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b44284c..c3aeaa8 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -221,7 +221,6 @@ xfs_symlink(
 	if (error)
 		return error;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SYMLINK);
 	/*
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
@@ -231,13 +230,15 @@ xfs_symlink(
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_symlink, resblks, 0);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, resblks, 0, 0, &tp);
 	if (error == -ENOSPC && fs_blocks == 0) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_symlink, 0, 0);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, 0, 0, 0,
+				&tp);
 	}
 	if (error)
-		goto out_trans_cancel;
+		goto out_release_inode;
 
 	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
 		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
@@ -455,12 +456,9 @@ xfs_inactive_symlink_rmt(
 	 */
 	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error)
 		return error;
-	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 748b16a..cbbef3a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -47,47 +47,6 @@ xfs_trans_init(
 }
 
 /*
- * This routine is called to allocate a transaction structure.
- * The type parameter indicates the type of the transaction.  These
- * are enumerated in xfs_trans.h.
- *
- * Dynamically allocate the transaction structure from the transaction
- * zone, initialize it, and return it to the caller.
- */
-xfs_trans_t *
-xfs_trans_alloc(
-	xfs_mount_t	*mp,
-	uint		type)
-{
-	xfs_trans_t     *tp;
-
-	sb_start_intwrite(mp->m_super);
-	tp = _xfs_trans_alloc(mp, type, KM_SLEEP);
-	tp->t_flags |= XFS_TRANS_FREEZE_PROT;
-	return tp;
-}
-
-xfs_trans_t *
-_xfs_trans_alloc(
-	xfs_mount_t	*mp,
-	uint		type,
-	xfs_km_flags_t	memflags)
-{
-	xfs_trans_t	*tp;
-
-	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	atomic_inc(&mp->m_active_trans);
-
-	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
-	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
-	tp->t_type = type;
-	tp->t_mountp = mp;
-	INIT_LIST_HEAD(&tp->t_items);
-	INIT_LIST_HEAD(&tp->t_busy);
-	return tp;
-}
-
-/*
  * Free the transaction structure.  If there is more clean up
  * to do when the structure is freed, add it here.
  */
@@ -99,7 +58,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	atomic_dec(&tp->t_mountp->m_active_trans);
-	if (tp->t_flags & XFS_TRANS_FREEZE_PROT)
+	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
 	kmem_zone_free(xfs_trans_zone, tp);
@@ -125,7 +84,6 @@ xfs_trans_dup(
 	 * Initialize the new transaction structure.
 	 */
 	ntp->t_magic = XFS_TRANS_HEADER_MAGIC;
-	ntp->t_type = tp->t_type;
 	ntp->t_mountp = tp->t_mountp;
 	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
@@ -135,9 +93,9 @@ xfs_trans_dup(
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_FREEZE_PROT);
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
 	/* We gave our writer reference to the new transaction */
-	tp->t_flags &= ~XFS_TRANS_FREEZE_PROT;
+	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
 	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
@@ -165,7 +123,7 @@ xfs_trans_dup(
  * This does not do quota reservations. That typically is done by the
  * caller afterwards.
  */
-int
+static int
 xfs_trans_reserve(
 	struct xfs_trans	*tp,
 	struct xfs_trans_res	*resp,
@@ -219,7 +177,7 @@ xfs_trans_reserve(
 						resp->tr_logres,
 						resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
-						permanent, tp->t_type);
+						permanent, 0);
 		}
 
 		if (error)
@@ -268,6 +226,42 @@ undo_blocks:
 	return error;
 }
 
+int
+xfs_trans_alloc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resp,
+	uint			blocks,
+	uint			rtextents,
+	uint			flags,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+		sb_start_intwrite(mp->m_super);
+
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	atomic_inc(&mp->m_active_trans);
+
+	tp = kmem_zone_zalloc(xfs_trans_zone,
+		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
+	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
+	tp->t_flags = flags;
+	tp->t_mountp = mp;
+	INIT_LIST_HEAD(&tp->t_items);
+	INIT_LIST_HEAD(&tp->t_busy);
+
+	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	*tpp = tp;
+	return 0;
+}
+
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e7c49cf..9a462e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -90,7 +90,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
  */
 typedef struct xfs_trans {
 	unsigned int		t_magic;	/* magic number */
-	unsigned int		t_type;		/* transaction type */
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
 	unsigned int		t_blk_res;	/* # of blocks resvd */
@@ -148,10 +147,9 @@ typedef struct xfs_trans {
 /*
  * XFS transaction mechanism exported interfaces.
  */
-xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
-int		xfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
-				  uint, uint);
+int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
+			uint blocks, uint rtextents, uint flags,
+			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
 struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
