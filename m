Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F010229DFC
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 14:20:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8F248F8049
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 12:20:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zouBYELalv4ywIHH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 12:19:59 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YrWla-0006TV-9i
	for xfs@oss.sgi.com; Sun, 10 May 2015 19:19:59 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: remove the flags argument to xfs_trans_cancel
Date: Sun, 10 May 2015 21:18:37 +0200
Message-Id: <1431285519-7768-3-git-send-email-hch@lst.de>
In-Reply-To: <1431285519-7768-1-git-send-email-hch@lst.de>
References: <1431285519-7768-1-git-send-email-hch@lst.de>
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

xfs_trans_cancel takes two flags arguments: XFS_TRANS_RELEASE_LOG_RES and
XFS_TRANS_ABORT.  Both of them are a direct product of the transaction
state, and can be deducted:

 - any dirty transaction needs XFS_TRANS_ABORT to be properly canceled,
   and XFS_TRANS_ABORT is a noop for a transaction that is not dirty.
 - any transaction with a permanent log reservation needs
   XFS_TRANS_RELEASE_LOG_RES to be properly canceled, and passing
   XFS_TRANS_RELEASE_LOG_RES for a transaction without a permanent
   log reservation is invalid.

So just remove the flags argument and do the right thing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   | 18 ++++-----
 fs/xfs/libxfs/xfs_bmap.c   | 11 ++----
 fs/xfs/libxfs/xfs_sb.c     |  2 +-
 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_aops.c          |  4 +-
 fs/xfs/xfs_attr_inactive.c |  4 +-
 fs/xfs/xfs_bmap_util.c     | 24 ++++++------
 fs/xfs/xfs_dquot.c         |  6 +--
 fs/xfs/xfs_file.c          |  2 +-
 fs/xfs/xfs_fsops.c         |  4 +-
 fs/xfs/xfs_inode.c         | 93 ++++++++++++++++------------------------------
 fs/xfs/xfs_ioctl.c         |  8 ++--
 fs/xfs/xfs_iomap.c         | 12 +++---
 fs/xfs/xfs_iops.c          | 12 ++----
 fs/xfs/xfs_log_recover.c   |  4 +-
 fs/xfs/xfs_pnfs.c          |  2 +-
 fs/xfs/xfs_qm.c            |  5 +--
 fs/xfs/xfs_qm_syscalls.c   | 11 +++---
 fs/xfs/xfs_rtalloc.c       | 10 +----
 fs/xfs/xfs_symlink.c       | 13 ++-----
 fs/xfs/xfs_trans.c         | 27 +++++---------
 fs/xfs/xfs_trans.h         |  2 +-
 22 files changed, 104 insertions(+), 171 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0a472fb..126da7f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -266,7 +266,7 @@ xfs_attr_set(
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
-		xfs_trans_cancel(args.trans, 0);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -276,7 +276,7 @@ xfs_attr_set(
 				       XFS_QMOPT_RES_REGBLKS);
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 
@@ -389,10 +389,8 @@ xfs_attr_set(
 	return error;
 
 out:
-	if (args.trans) {
-		xfs_trans_cancel(args.trans,
-			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	}
+	if (args.trans)
+		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -462,7 +460,7 @@ xfs_attr_remove(
 	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
-		xfs_trans_cancel(args.trans, 0);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 
@@ -507,10 +505,8 @@ xfs_attr_remove(
 	return error;
 
 out:
-	if (args.trans) {
-		xfs_trans_cancel(args.trans,
-			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	}
+	if (args.trans)
+		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aeffeaa..a07055a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1112,7 +1112,6 @@ xfs_bmap_add_attrfork(
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
-	int			cancel_flags = 0;
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
 
@@ -1124,17 +1123,15 @@ xfs_bmap_add_attrfork(
 		tp->t_flags |= XFS_TRANS_RESERVE;
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto trans_cancel;
-	cancel_flags |= XFS_TRANS_ABORT;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
@@ -1225,7 +1222,7 @@ xfs_bmap_add_attrfork(
 bmap_cancel:
 	xfs_bmap_cancel(&flist);
 trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -5911,7 +5908,7 @@ xfs_bmap_split_extent(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -5933,6 +5930,6 @@ xfs_bmap_split_extent(
 
 
 out:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index dc4bfc5..3a5667d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -792,7 +792,7 @@ xfs_sync_sb(
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 8dda4b3..930cc7d 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -185,7 +185,6 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
  * Values for call flags parameter.
  */
 #define	XFS_TRANS_RELEASE_LOG_RES	0x4
-#define	XFS_TRANS_ABORT			0x8
 
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a56960d..3890a38 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -109,7 +109,7 @@ xfs_setfilesize_trans_alloc(
 
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -145,7 +145,7 @@ xfs_setfilesize(
 	isize = xfs_new_eof(ip, offset + size);
 	if (!isize) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return 0;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f9c1c64..af7fce3 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -411,7 +411,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
 	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
 	if (error) {
-		xfs_trans_cancel(trans, 0);
+		xfs_trans_cancel(trans);
 		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -444,7 +444,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	return error;
 
 out:
-	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+	xfs_trans_cancel(trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f469aad..7e795cf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -861,7 +861,7 @@ xfs_free_eofblocks(
 
 		if (need_iolock) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-				xfs_trans_cancel(tp, 0);
+				xfs_trans_cancel(tp);
 				return -EAGAIN;
 			}
 		}
@@ -869,7 +869,7 @@ xfs_free_eofblocks(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			if (need_iolock)
 				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
@@ -891,9 +891,7 @@ xfs_free_eofblocks(
 			 * If we get an error at this point we simply don't
 			 * bother truncating the file.
 			 */
-			xfs_trans_cancel(tp,
-					 (XFS_TRANS_RELEASE_LOG_RES |
-					  XFS_TRANS_ABORT));
+			xfs_trans_cancel(tp);
 		} else {
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
@@ -1009,7 +1007,7 @@ xfs_alloc_file_space(
 			 * Free the transaction structure.
 			 */
 			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1060,7 +1058,7 @@ error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 
 error1:	/* Just cancel transaction */
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -1272,7 +1270,7 @@ xfs_free_file_space(
 			 * Free the transaction structure.
 			 */
 			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1313,7 +1311,7 @@ xfs_free_file_space(
  error0:
 	xfs_bmap_cancel(&free_list);
  error1:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	goto out;
 }
@@ -1445,7 +1443,7 @@ xfs_shift_file_space(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
 		if (error) {
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			break;
 		}
 
@@ -1481,7 +1479,7 @@ xfs_shift_file_space(
 	return error;
 
 out:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -1701,7 +1699,7 @@ xfs_swap_extents(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		goto out_unlock;
 	}
 
@@ -1898,6 +1896,6 @@ out_unlock:
 	goto out;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp, 0);
+	xfs_trans_cancel(tp);
 	goto out;
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 02c01bb..ab0ae1f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -568,8 +568,6 @@ xfs_qm_dqread(
 	struct xfs_buf		*bp;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	int			cancelflags = 0;
-
 
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
@@ -617,7 +615,6 @@ xfs_qm_dqread(
 					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
 		if (error)
 			goto error1;
-		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
 	}
 
 	/*
@@ -632,7 +629,6 @@ xfs_qm_dqread(
 		 * allocate (ENOENT).
 		 */
 		trace_xfs_dqread_fail(dqp);
-		cancelflags |= XFS_TRANS_ABORT;
 		goto error1;
 	}
 
@@ -680,7 +676,7 @@ xfs_qm_dqread(
 
 error1:
 	if (tp)
-		xfs_trans_cancel(tp, cancelflags);
+		xfs_trans_cancel(tp);
 error0:
 	xfs_qm_dqdestroy(dqp);
 	*O_dqpp = NULL;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8121e75..46598b7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -138,7 +138,7 @@ xfs_update_prealloc_flags(
 	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
 	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_writeid, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cb7e8a2..0bdcdb7 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -201,7 +201,7 @@ xfs_growfs_data_private(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
 				  XFS_GROWFS_SPACE_RES(mp), 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -557,7 +557,7 @@ xfs_growfs_data_private(
 	return saved_error ? saved_error : error;
 
  error0:
-	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f39ce66..3f3f8a0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1092,7 +1092,6 @@ xfs_create(
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
-	uint			cancel_flags;
 	int			committed;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
@@ -1129,8 +1128,6 @@ xfs_create(
 		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	}
 
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1148,10 +1145,9 @@ xfs_create(
 		resblks = 0;
 		error = xfs_trans_reserve(tp, tres, 0, 0);
 	}
-	if (error) {
-		cancel_flags = 0;
+	if (error)
 		goto out_trans_cancel;
-	}
+
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1182,7 +1178,7 @@ xfs_create(
 	if (error) {
 		if (error == -ENOSPC)
 			goto out_trans_cancel;
-		goto out_trans_abort;
+		goto out_trans_cancel;
 	}
 
 	/*
@@ -1200,7 +1196,7 @@ xfs_create(
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto out_trans_abort;
+		goto out_trans_cancel;
 	}
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
@@ -1247,10 +1243,8 @@ xfs_create(
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
- out_trans_abort:
-	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
  out_release_inode:
 	/*
 	 * Wait until after the current transaction is aborted to finish the
@@ -1282,7 +1276,6 @@ xfs_create_tmpfile(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	uint			cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	prid_t                  prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1315,10 +1308,8 @@ xfs_create_tmpfile(
 		resblks = 0;
 		error = xfs_trans_reserve(tp, tres, 0, 0);
 	}
-	if (error) {
-		cancel_flags = 0;
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
 						pdqp, resblks, 1, 0);
@@ -1330,7 +1321,7 @@ xfs_create_tmpfile(
 	if (error) {
 		if (error == -ENOSPC)
 			goto out_trans_cancel;
-		goto out_trans_abort;
+		goto out_trans_cancel;
 	}
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
@@ -1346,7 +1337,7 @@ xfs_create_tmpfile(
 	ip->i_d.di_nlink--;
 	error = xfs_iunlink(tp, ip);
 	if (error)
-		goto out_trans_abort;
+		goto out_trans_cancel;
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error)
@@ -1359,10 +1350,8 @@ xfs_create_tmpfile(
 	*ipp = ip;
 	return 0;
 
- out_trans_abort:
-	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
  out_release_inode:
 	/*
 	 * Wait until after the current transaction is aborted to finish the
@@ -1392,7 +1381,6 @@ xfs_link(
 	int			error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
-	int			cancel_flags;
 	int			committed;
 	int			resblks;
 
@@ -1412,17 +1400,14 @@ xfs_link(
 		goto std_return;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
 	if (error == -ENOSPC) {
 		resblks = 0;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
 	}
-	if (error) {
-		cancel_flags = 0;
+	if (error)
 		goto error_return;
-	}
 
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
@@ -1451,19 +1436,19 @@ xfs_link(
 	if (sip->i_d.di_nlink == 0) {
 		error = xfs_iunlink_remove(tp, sip);
 		if (error)
-			goto abort_return;
+			goto error_return;
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error)
-		goto abort_return;
+		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
 	if (error)
-		goto abort_return;
+		goto error_return;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -1477,15 +1462,13 @@ xfs_link(
 	error = xfs_bmap_finish (&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
-		goto abort_return;
+		goto error_return;
 	}
 
 	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 
- abort_return:
-	cancel_flags |= XFS_TRANS_ABORT;
  error_return:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
  std_return:
 	return error;
 }
@@ -1698,7 +1681,7 @@ xfs_inactive_truncate(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -1727,7 +1710,7 @@ xfs_inactive_truncate(
 	return 0;
 
 error_trans_cancel:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 error_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
@@ -1777,7 +1760,7 @@ xfs_inactive_ifree(
 		} else {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		}
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -1797,7 +1780,7 @@ xfs_inactive_ifree(
 				__func__, error);
 			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 		}
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+		xfs_trans_cancel(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
 	}
@@ -2482,7 +2465,6 @@ xfs_remove(
 	int                     error = 0;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
-	int			cancel_flags;
 	int			committed;
 	uint			resblks;
 
@@ -2503,7 +2485,6 @@ xfs_remove(
 		tp = xfs_trans_alloc(mp, XFS_TRANS_RMDIR);
 	else
 		tp = xfs_trans_alloc(mp, XFS_TRANS_REMOVE);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 
 	/*
 	 * We try to get the real space reservation first,
@@ -2522,7 +2503,6 @@ xfs_remove(
 	}
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		cancel_flags = 0;
 		goto out_trans_cancel;
 	}
 
@@ -2534,7 +2514,6 @@ xfs_remove(
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
-	cancel_flags |= XFS_TRANS_ABORT;
 	if (is_dir) {
 		ASSERT(ip->i_d.di_nlink >= 2);
 		if (ip->i_d.di_nlink != 2) {
@@ -2602,7 +2581,7 @@ xfs_remove(
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
  out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
  std_return:
 	return error;
 }
@@ -2676,7 +2655,7 @@ xfs_finish_rename(
 	error = xfs_bmap_finish(&tp, free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(free_list);
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -2801,7 +2780,7 @@ xfs_cross_rename(
 
 out_trans_abort:
 	xfs_bmap_cancel(free_list);
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -2855,7 +2834,6 @@ xfs_rename(
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
-	int			cancel_flags = 0;
 	int			spaceres;
 	int			error;
 
@@ -2891,7 +2869,6 @@ xfs_rename(
 	}
 	if (error)
 		goto out_trans_cancel;
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 
 	/*
 	 * Attach the dquots to the inodes
@@ -2962,10 +2939,8 @@ xfs_rename(
 		error = xfs_dir_createname(tp, target_dp, target_name,
 						src_ip->i_ino, &first_block,
 						&free_list, spaceres);
-		if (error == -ENOSPC)
-			goto out_bmap_cancel;
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2973,7 +2948,7 @@ xfs_rename(
 		if (new_parent && src_is_directory) {
 			error = xfs_bumplink(tp, target_dp);
 			if (error)
-				goto out_trans_abort;
+				goto out_bmap_cancel;
 		}
 	} else { /* target_ip != NULL */
 		/*
@@ -3005,7 +2980,7 @@ xfs_rename(
 					src_ip->i_ino,
 					&first_block, &free_list, spaceres);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3016,7 +2991,7 @@ xfs_rename(
 		 */
 		error = xfs_droplink(tp, target_ip);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 
 		if (src_is_directory) {
 			/*
@@ -3024,7 +2999,7 @@ xfs_rename(
 			 */
 			error = xfs_droplink(tp, target_ip);
 			if (error)
-				goto out_trans_abort;
+				goto out_bmap_cancel;
 		}
 	} /* target_ip != NULL */
 
@@ -3041,7 +3016,7 @@ xfs_rename(
 					&first_block, &free_list, spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 	}
 
 	/*
@@ -3067,7 +3042,7 @@ xfs_rename(
 		 */
 		error = xfs_droplink(tp, src_dp);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 	}
 
 	/*
@@ -3082,7 +3057,7 @@ xfs_rename(
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   &first_block, &free_list, spaceres);
 	if (error)
-		goto out_trans_abort;
+		goto out_bmap_cancel;
 
 	/*
 	 * For whiteouts, we need to bump the link count on the whiteout inode.
@@ -3096,10 +3071,10 @@ xfs_rename(
 		ASSERT(wip->i_d.di_nlink == 0);
 		error = xfs_bumplink(tp, wip);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 		error = xfs_iunlink_remove(tp, wip);
 		if (error)
-			goto out_trans_abort;
+			goto out_bmap_cancel;
 		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
 
 		/*
@@ -3120,12 +3095,10 @@ xfs_rename(
 		IRELE(wip);
 	return error;
 
-out_trans_abort:
-	cancel_flags |= XFS_TRANS_ABORT;
 out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
 	if (wip)
 		IRELE(wip);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 87f67c6..3abd3c4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -336,7 +336,7 @@ xfs_set_dmattrs(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_DMATTRS);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1076,7 +1076,7 @@ xfs_ioctl_setattr_get_trans(
 	return tp;
 
 out_cancel:
-	xfs_trans_cancel(tp, 0);
+	xfs_trans_cancel(tp);
 	return ERR_PTR(error);
 }
 
@@ -1265,7 +1265,7 @@ xfs_ioctl_setattr(
 	return code;
 
 error_trans_cancel:
-	xfs_trans_cancel(tp, 0);
+	xfs_trans_cancel(tp);
 error_free_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(pdqp);
@@ -1338,7 +1338,7 @@ xfs_ioc_setxflags(
 
 	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		goto out_drop_write;
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 38e633b..6ca842a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -183,7 +183,7 @@ xfs_iomap_write_direct(
 	 * Check for running out of space, note: need lock to return
 	 */
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -236,7 +236,7 @@ out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 out_trans_cancel:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	goto out_unlock;
 }
 
@@ -690,7 +690,7 @@ xfs_iomap_write_allocate(
 			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 						  nres, 0);
 			if (error) {
-				xfs_trans_cancel(tp, 0);
+				xfs_trans_cancel(tp);
 				return error;
 			}
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -791,7 +791,7 @@ xfs_iomap_write_allocate(
 
 trans_cancel:
 	xfs_bmap_cancel(&free_list);
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 error0:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
@@ -853,7 +853,7 @@ xfs_iomap_write_unwritten(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 					  resblks, 0);
 		if (error) {
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			return error;
 		}
 
@@ -914,7 +914,7 @@ xfs_iomap_write_unwritten(
 
 error_on_bmapi_transaction:
 	xfs_bmap_cancel(&free_list);
-	xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f4cd720..8bd71f1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -733,7 +733,7 @@ xfs_setattr_nonsize(
 	return 0;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp, 0);
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
 	xfs_qm_dqrele(udqp);
@@ -755,7 +755,6 @@ xfs_setattr_size(
 	struct xfs_trans	*tp;
 	int			error;
 	uint			lock_flags = 0;
-	uint			commit_flags = 0;
 	bool			did_zeroing = false;
 
 	trace_xfs_setattr(ip);
@@ -861,7 +860,6 @@ xfs_setattr_size(
 	if (error)
 		goto out_trans_cancel;
 
-	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
 	lock_flags |= XFS_ILOCK_EXCL;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
@@ -901,7 +899,7 @@ xfs_setattr_size(
 	if (newsize <= oldsize) {
 		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, newsize);
 		if (error)
-			goto out_trans_abort;
+			goto out_trans_cancel;
 
 		/*
 		 * Truncated "down", so we're removing references to old data
@@ -934,10 +932,8 @@ out_unlock:
 		xfs_iunlock(ip, lock_flags);
 	return error;
 
-out_trans_abort:
-	commit_flags |= XFS_TRANS_ABORT;
 out_trans_cancel:
-	xfs_trans_cancel(tp, commit_flags);
+	xfs_trans_cancel(tp);
 	goto out_unlock;
 }
 
@@ -984,7 +980,7 @@ xfs_vn_update_time(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4f5784f..8f2923f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3755,7 +3755,7 @@ xlog_recover_process_efi(
 	return error;
 
 abort_error:
-	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -3863,7 +3863,7 @@ xlog_recover_clear_agi_bucket(
 	return;
 
 out_abort:
-	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 out_error:
 	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
 	return;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 981a657..3bb6097 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -306,7 +306,7 @@ xfs_fs_commit_blocks(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		goto out_drop_iolock;
 	}
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5538468..c4ba36d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -756,7 +756,7 @@ xfs_qm_qino_alloc(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_create,
 				  XFS_QM_QINOCREATE_SPACE_RES(mp), 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -764,8 +764,7 @@ xfs_qm_qino_alloc(
 		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
 								&committed);
 		if (error) {
-			xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-					 XFS_TRANS_ABORT);
+			xfs_trans_cancel(tp);
 			return error;
 		}
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 9a25c92..92ad24f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -239,7 +239,7 @@ xfs_qm_scall_trunc_qfile(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 		goto out_put;
 	}
@@ -252,8 +252,7 @@ xfs_qm_scall_trunc_qfile(
 
 	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
 	if (error) {
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-				     XFS_TRANS_ABORT);
+		xfs_trans_cancel(tp);
 		goto out_unlock;
 	}
 
@@ -437,7 +436,7 @@ xfs_qm_scall_setqlim(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_setqlim, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		goto out_rele;
 	}
 
@@ -571,7 +570,7 @@ xfs_qm_log_quotaoff_end(
 
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_equotaoff, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -605,7 +604,7 @@ xfs_qm_log_quotaoff(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_quotaoff, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f2079b6..ff5af66 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -780,7 +780,6 @@ xfs_growfs_rt_alloc(
 	 * Allocate space to the file, as necessary.
 	 */
 	while (oblocks < nblocks) {
-		int		cancelflags = 0;
 		xfs_trans_t	*tp;
 
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
@@ -792,7 +791,6 @@ xfs_growfs_rt_alloc(
 					  resblks, 0);
 		if (error)
 			goto error_cancel;
-		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
 		/*
 		 * Lock the inode.
 		 */
@@ -804,7 +802,6 @@ xfs_growfs_rt_alloc(
 		 * Allocate blocks to the bitmap file.
 		 */
 		nmap = 1;
-		cancelflags |= XFS_TRANS_ABORT;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, &firstblock,
 					resblks, &map, &nmap, &flist);
@@ -825,7 +822,6 @@ xfs_growfs_rt_alloc(
 		 * Now we need to clear the allocated blocks.
 		 * Do this one block per transaction, to keep it simple.
 		 */
-		cancelflags = 0;
 		for (bno = map.br_startoff, fsbno = map.br_startblock;
 		     bno < map.br_startoff + map.br_blockcount;
 		     bno++, fsbno++) {
@@ -851,7 +847,7 @@ xfs_growfs_rt_alloc(
 			if (bp == NULL) {
 				error = -EIO;
 error_cancel:
-				xfs_trans_cancel(tp, cancelflags);
+				xfs_trans_cancel(tp);
 				goto error;
 			}
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
@@ -973,7 +969,6 @@ xfs_growfs_rt(
 	     bmbno < nrbmblocks;
 	     bmbno++) {
 		xfs_trans_t	*tp;
-		int		cancelflags = 0;
 
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
@@ -1015,7 +1010,6 @@ xfs_growfs_rt(
 		mp->m_rbmip->i_d.di_size =
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-		cancelflags |= XFS_TRANS_ABORT;
 		/*
 		 * Get the summary inode into the transaction.
 		 */
@@ -1062,7 +1056,7 @@ xfs_growfs_rt(
 			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
 		if (error) {
 error_cancel:
-			xfs_trans_cancel(tp, cancelflags);
+			xfs_trans_cancel(tp);
 			break;
 		}
 		/*
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3df411e..b5573bf 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -178,7 +178,6 @@ xfs_symlink(
 	struct xfs_bmap_free	free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
-	uint			cancel_flags;
 	int			committed;
 	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
@@ -224,7 +223,6 @@ xfs_symlink(
 		return error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SYMLINK);
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	/*
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
@@ -239,10 +237,8 @@ xfs_symlink(
 		resblks = 0;
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_symlink, 0, 0);
 	}
-	if (error) {
-		cancel_flags = 0;
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -407,9 +403,8 @@ xfs_symlink(
 
 out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
 out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
 out_release_inode:
 	/*
 	 * Wait until after the current transaction is aborted to finish the
@@ -464,7 +459,7 @@ xfs_inactive_symlink_rmt(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -552,7 +547,7 @@ xfs_inactive_symlink_rmt(
 error_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 error_trans_cancel:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 error_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 42a1adf..6cca996 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -986,29 +986,22 @@ out_unreserve:
  */
 void
 xfs_trans_cancel(
-	xfs_trans_t		*tp,
-	int			flags)
+	struct xfs_trans	*tp)
 {
-	int			log_flags;
-	xfs_mount_t		*mp = tp->t_mountp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
 
 	/*
-	 * See if the caller is being too lazy to figure out if
-	 * the transaction really needs an abort.
-	 */
-	if ((flags & XFS_TRANS_ABORT) && !(tp->t_flags & XFS_TRANS_DIRTY))
-		flags &= ~XFS_TRANS_ABORT;
-	/*
 	 * See if the caller is relying on us to shut down the
 	 * filesystem.  This happens in paths where we detect
 	 * corruption and decide to give up.
 	 */
-	if ((tp->t_flags & XFS_TRANS_DIRTY) && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (dirty && !XFS_FORCED_SHUTDOWN(mp)) {
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-	if (!(flags & XFS_TRANS_ABORT) && !XFS_FORCED_SHUTDOWN(mp)) {
+	if (!dirty && !XFS_FORCED_SHUTDOWN(mp)) {
 		struct xfs_log_item_desc *lidp;
 
 		list_for_each_entry(lidp, &tp->t_items, lid_trans)
@@ -1019,19 +1012,17 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		if (flags & XFS_TRANS_RELEASE_LOG_RES) {
-			ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+		uint		log_flags = 0;
+
+		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
 			log_flags = XFS_LOG_REL_PERM_RESERV;
-		} else {
-			log_flags = 0;
-		}
 		xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	}
 
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
-	xfs_trans_free_items(tp, NULLCOMMITLSN, flags & XFS_TRANS_ABORT);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, dirty);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3bfb417..ca95b92 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -227,7 +227,7 @@ void		xfs_trans_log_efd_extent(xfs_trans_t *,
 					 xfs_extlen_t);
 int		xfs_trans_commit(xfs_trans_t *, uint flags);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
-void		xfs_trans_cancel(xfs_trans_t *, int);
+void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
