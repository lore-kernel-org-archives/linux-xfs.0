Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02C347F5D
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E538430413C
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qj6iwlVvGycAgUr9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:33 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5cW5q005894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:32 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cV1G010534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:31 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cUDh029123 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:30 GMT
Message-ID: <5195C253.8080805@oracle.com>
Date: Fri, 17 May 2013 13:38:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 4/8] xfs: efactor xfs_trans_reserve() interface
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

With the new xfs_trans_res structure has been introduced, the log
reservation size, log count as well as log flags are pre-initialized
at mount time.  So it's time to refine xfs_trans_reserve() interface
to be more neat.

Also, introduce a new inline helper m_tresp() to return a pointer
to the mp->m_reservations structure to simplify the input.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_aops.c        |    2 +-
 fs/xfs/xfs_attr.c        |   38 ++++++++++----------
 fs/xfs/xfs_bmap.c        |   16 ++++-----
 fs/xfs/xfs_dfrag.c       |    5 ++-
 fs/xfs/xfs_dquot.c       |    6 ++--
 fs/xfs/xfs_fsops.c       |    8 ++---
 fs/xfs/xfs_inode.c       |    5 +--
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iomap.c       |   18 ++++------
 fs/xfs/xfs_iops.c        |    8 ++---
 fs/xfs/xfs_log_recover.c |    5 ++-
 fs/xfs/xfs_mount.c       |    9 ++---
 fs/xfs/xfs_mount.h       |    6 ++++
 fs/xfs/xfs_qm.c          |   11 +++---
 fs/xfs/xfs_qm_syscalls.c |   13 +++----
 fs/xfs/xfs_rename.c      |    6 ++--
 fs/xfs/xfs_rtalloc.c     |   17 ++++-----
 fs/xfs/xfs_symlink.c     |   10 +++---
 fs/xfs/xfs_trans.c       |   58 +++++++++++++++---------------
 fs/xfs/xfs_trans.h       |    3 +-
 fs/xfs/xfs_utils.c       |   13 +++----
 fs/xfs/xfs_vnodeops.c    |   90 ++++++++++++++++++----------------------------
 22 files changed, 153 insertions(+), 196 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3244c98..a68d4d4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -115,7 +115,7 @@ xfs_setfilesize_trans_alloc(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_fsyncts, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 20fe3fe..a89b339 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -227,13 +227,14 @@ xfs_attr_set_int(
 	int		valuelen,
 	int		flags)
 {
-	xfs_da_args_t	args;
-	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t flist;
-	int		error, err2, committed;
-	xfs_mount_t	*mp = dp->i_mount;
-	int             rsvd = (flags & ATTR_ROOT) != 0;
-	int		local;
+	xfs_da_args_t		args;
+	xfs_fsblock_t		firstblock;
+	xfs_bmap_free_t		flist;
+	int			error, err2, committed;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans_res	tres;
+	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			local;
 
 	/*
 	 * Attach the dquots to the inode.
@@ -293,11 +294,11 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	error = xfs_trans_reserve(args.trans, args.total,
-				  XFS_ATTRSETM_LOG_RES(mp) +
-				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_ATTRSET_LOG_COUNT);
+	tres.tr_logres = m_tresp(mp)->tr_attrsetm.tr_logres +
+			 m_tresp(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
@@ -517,11 +518,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	if (flags & ATTR_ROOT)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans,
-				      XFS_ATTRRM_SPACE_RES(mp),
-				      XFS_ATTRRM_LOG_RES(mp),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRRM_LOG_COUNT))) {
+	error = xfs_trans_reserve(args.trans, &m_tresp(mp)->tr_attrrm,
+				  XFS_ATTRRM_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
@@ -791,9 +790,8 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	 * the log.
 	 */
 	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
-	if ((error = xfs_trans_reserve(trans, 0, XFS_ATTRINVAL_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRINVAL_LOG_COUNT))) {
+	error = xfs_trans_reserve(trans, &m_tresp(mp)->tr_attrinval, 0, 0);
+	if (error) {
 		xfs_trans_cancel(trans, 0);
 		return(error);
 	}
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8904284..87c2af2 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -857,8 +857,7 @@ xfs_bmap_finish(
 	xfs_efi_log_item_t	*efi;		/* extent free intention */
 	int			error;		/* error return value */
 	xfs_bmap_free_item_t	*free;		/* free extent item */
-	unsigned int		logres;		/* new log reservation */
-	unsigned int		logcount;	/* new log count */
+	struct xfs_trans_res	tres;		/* new log reservation */
 	xfs_mount_t		*mp;		/* filesystem mount structure */
 	xfs_bmap_free_item_t	*next;		/* next item on free list */
 	xfs_trans_t		*ntp;		/* new transaction pointer */
@@ -873,8 +872,9 @@ xfs_bmap_finish(
 	for (free = flist->xbf_first; free; free = free->xbfi_next)
 		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
-	logres = ntp->t_log_res;
-	logcount = ntp->t_log_count;
+	tres.tr_logres = ntp->t_log_res;
+	tres.tr_logcount = ntp->t_log_count;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	ntp = xfs_trans_dup(*tp);
 	error = xfs_trans_commit(*tp, 0);
 	*tp = ntp;
@@ -892,8 +892,8 @@ xfs_bmap_finish(
 	 */
 	xfs_log_ticket_put(ntp->t_ticket);
 
-	if ((error = xfs_trans_reserve(ntp, 0, logres, 0, XFS_TRANS_PERM_LOG_RES,
-			logcount)))
+	error = xfs_trans_reserve(ntp, &tres, 0, 0);
+	if (error)
 		return error;
 	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
@@ -1414,8 +1414,8 @@ xfs_bmap_add_attrfork(
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 	if (rsvd)
 		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_addafork, blks, 0);
+	if (error)
 		goto error0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index f852b08..362e305 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -316,9 +316,8 @@ xfs_swap_extents(
 	truncate_pagecache_range(VFS_I(ip), 0, -1);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
-	if ((error = xfs_trans_reserve(tp, 0,
-				     XFS_ICHANGE_LOG_RES(mp), 0,
-				     0, 0))) {
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 0, 0);
+	if (error) {
 		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
 		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
 		xfs_trans_cancel(tp, 0);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a41f8bf..c3fafdb 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -721,10 +721,8 @@ xfs_qm_dqread(
 
 	if (flags & XFS_QMOPT_DQALLOC) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
-					  XFS_QM_DQALLOC_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_attrsetm,
+					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
 		if (error)
 			goto error1;
 		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 87595b2..effa652 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -201,8 +201,9 @@ xfs_growfs_data_private(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
 	tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp),
-			XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_growdata,
+				  XFS_GROWFS_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
@@ -737,8 +738,7 @@ xfs_fs_log_dummy(
 	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efbe1ac..f1906bd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1549,10 +1549,7 @@ xfs_itruncate_extents(
 		 * reference that we gained in xfs_trans_dup()
 		 */
 		xfs_log_ticket_put(tp->t_ticket);
-		error = xfs_trans_reserve(tp, 0,
-					XFS_ITRUNCATE_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_ITRUNCATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
 		if (error)
 			goto out;
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5e99968..49af42b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -967,7 +967,7 @@ xfs_ioctl_setattr(
 	 * first do an error checking pass.
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	code = xfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 0, 0);
 	if (code)
 		goto error_return;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8f8aaee..2a5539d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -187,10 +187,8 @@ xfs_iomap_write_direct(
 	 * Allocate and setup the transaction
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-	error = xfs_trans_reserve(tp, resblks,
-			XFS_WRITE_LOG_RES(mp), resrtextents,
-			XFS_TRANS_PERM_LOG_RES,
-			XFS_WRITE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_write,
+				  resblks, resrtextents);
 	/*
 	 * Check for running out of space, note: need lock to return
 	 */
@@ -685,10 +683,8 @@ xfs_iomap_write_allocate(
 			tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
 			tp->t_flags |= XFS_TRANS_RESERVE;
 			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-			error = xfs_trans_reserve(tp, nres,
-					XFS_WRITE_LOG_RES(mp),
-					0, XFS_TRANS_PERM_LOG_RES,
-					XFS_WRITE_LOG_COUNT);
+			error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_write,
+						  nres, 0);
 			if (error) {
 				xfs_trans_cancel(tp, 0);
 				return XFS_ERROR(error);
@@ -851,10 +847,8 @@ xfs_iomap_write_unwritten(
 		sb_start_intwrite(mp->m_super);
 		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
 		tp->t_flags |= XFS_TRANS_RESERVE | XFS_TRANS_FREEZE_PROT;
-		error = xfs_trans_reserve(tp, resblks,
-				XFS_WRITE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_write,
+					  resblks, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			return XFS_ERROR(error);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..4f2e469 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -523,7 +523,7 @@ xfs_setattr_nonsize(
 	}
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 0, 0);
 	if (error)
 		goto out_dqrele;
 
@@ -796,9 +796,7 @@ xfs_setattr_size(
 		goto out_unlock;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				 XFS_TRANS_PERM_LOG_RES,
-				 XFS_ITRUNCATE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -915,7 +913,7 @@ xfs_vn_update_time(
 	trace_xfs_update_time(ip);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_fsyncts, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return -error;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 93f03ec..a37adeb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3167,7 +3167,7 @@ xlog_recover_process_efi(
 	}
 
 	tp = xfs_trans_alloc(mp, 0);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto abort_error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
@@ -3273,8 +3273,7 @@ xlog_recover_clear_agi_bucket(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_CLEAR_AGI_BUCKET);
-	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp),
-				  0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_clearagi, 0, 0);
 	if (error)
 		goto out_abort;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f6bfbd7..c29977c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1220,8 +1220,7 @@ xfs_mount_reset_sbqflags(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_qm_sbchange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_alert(mp, "%s: Superblock update failed!", __func__);
@@ -1694,8 +1693,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 		return 0;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
@@ -2057,8 +2055,7 @@ xfs_mount_log_sb(
 			 XFS_SB_VERSIONNUM));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00d33f6..27ae8a9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -231,6 +231,12 @@ typedef struct xfs_mount {
 	struct workqueue_struct *m_eofblocks_workqueue;
 } xfs_mount_t;
 
+static inline struct xfs_trans_reservations *
+m_tresp(struct xfs_mount *mp)
+{
+	return &mp->m_reservations;
+}
+
 /*
  * Flags for m_flags.
  */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f41702b..50fc798 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -781,11 +781,9 @@ xfs_qm_qino_alloc(
 	int		committed;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
-	if ((error = xfs_trans_reserve(tp,
-				      XFS_QM_QINOCREATE_SPACE_RES(mp),
-				      XFS_CREATE_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_CREATE_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_create,
+				  XFS_QM_QINOCREATE_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
@@ -1601,8 +1599,7 @@ xfs_qm_write_sb_changes(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_qm_sbchange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c41190c..1ffa769 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -243,9 +243,7 @@ xfs_qm_scall_trunc_qfile(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				  XFS_TRANS_PERM_LOG_RES,
-				  XFS_ITRUNCATE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
@@ -490,8 +488,7 @@ xfs_qm_scall_setqlim(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_qm_setqlim, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
@@ -640,8 +637,7 @@ xfs_qm_log_quotaoff_end(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF_END);
 
-	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_END_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_qm_equotaoff, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
@@ -674,8 +670,7 @@ xfs_qm_log_quotaoff(
 	uint			oldsbqflag=0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_qm_quotaoff, 0, 0);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 30ff5f4..791e140 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -124,12 +124,10 @@ xfs_rename(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_rename, spaceres, 0);
 	if (error == ENOSPC) {
 		spaceres = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_RENAME_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_rename, 0, 0);
 	}
 	if (error) {
 		xfs_trans_cancel(tp, 0);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 98dc670..e1d2490 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -101,10 +101,9 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		if ((error = xfs_trans_reserve(tp, resblks,
-				XFS_GROWRTALLOC_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_DEFAULT_PERM_LOG_COUNT)))
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_growdata,
+					  resblks, 0);
+		if (error)
 			goto error_cancel;
 		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
 		/*
@@ -147,8 +146,9 @@ xfs_growfs_rt_alloc(
 			/*
 			 * Reserve log for one block zeroing.
 			 */
-			if ((error = xfs_trans_reserve(tp, 0,
-					XFS_GROWRTZERO_LOG_RES(mp), 0, 0, 0)))
+			error = xfs_trans_reserve(tp,
+					  &m_tresp(mp)->tr_growrtzero, 0, 0);
+			if (error)
 				goto error_cancel;
 			/*
 			 * Lock the bitmap inode.
@@ -1958,8 +1958,9 @@ xfs_growfs_rt(
 		 * Start a transaction, get the log reservation.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_FREE);
-		if ((error = xfs_trans_reserve(tp, 0,
-				XFS_GROWRTFREE_LOG_RES(nmp), 0, 0, 0)))
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_growrtfree,
+					  0, 0);
+		if (error)
 			goto error_cancel;
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5f234389..02b4b85 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -407,12 +407,10 @@ xfs_symlink(
 	else
 		fs_blocks = XFS_B_TO_FSB(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
-	error = xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_symlink, resblks, 0);
 	if (error == ENOSPC && fs_blocks == 0) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_SYMLINK_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_symlink, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -713,8 +711,8 @@ xfs_inactive_symlink_rmt(
 	 * Put an itruncate log reservation in the new transaction
 	 * for our caller.
 	 */
-	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ITRUNCATE_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
+	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		goto error0;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f1ccb2d..bc6f8c5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -516,7 +516,8 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ * to the attibute extent length in blocks by:
+ *	ext * m_tresp(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
 xfs_calc_attrsetrt_reservation(
@@ -588,14 +589,14 @@ xfs_calc_qm_setqlim_reservation(
 
 /*
  * Allocating quota on disk if needed.
- *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
+ *	the write transaction log space: m_tresp(mp)->tr_write.tr_logres
  *	the unit of quota allocation: one system block size
  */
 STATIC uint
 xfs_calc_qm_dqalloc_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_WRITE_LOG_RES(mp) +
+	return m_tresp(mp)->tr_write.tr_logres +
 		xfs_calc_buf_res(1,
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
@@ -643,7 +644,7 @@ void
 xfs_trans_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans_reservations *resp = &mp->m_reservations;
+	struct xfs_trans_reservations *resp = m_tresp(mp);
 
 	/*
 	 * The following transactions are logged in physical format and
@@ -862,12 +863,10 @@ xfs_trans_dup(
  */
 int
 xfs_trans_reserve(
-	xfs_trans_t	*tp,
-	uint		blocks,
-	uint		logspace,
-	uint		rtextents,
-	uint		flags,
-	uint		logcount)
+	struct xfs_trans	*tp,
+	struct xfs_trans_res	*tresp,
+	uint			blocks,
+	uint			rtextents)
 {
 	int		error = 0;
 	int		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
@@ -893,13 +892,15 @@ xfs_trans_reserve(
 	/*
 	 * Reserve the log space needed for this transaction.
 	 */
-	if (logspace > 0) {
+	if (tresp->tr_logres > 0) {
 		bool	permanent = false;
 
-		ASSERT(tp->t_log_res == 0 || tp->t_log_res == logspace);
-		ASSERT(tp->t_log_count == 0 || tp->t_log_count == logcount);
+		ASSERT(tp->t_log_res == 0 ||
+		       tp->t_log_res == tresp->tr_logres);
+		ASSERT(tp->t_log_count == 0 ||
+		       tp->t_log_count == tresp->tr_logcount);
 
-		if (flags & XFS_TRANS_PERM_LOG_RES) {
+		if (tresp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
 			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
 			permanent = true;
 		} else {
@@ -908,20 +909,21 @@ xfs_trans_reserve(
 		}
 
 		if (tp->t_ticket != NULL) {
-			ASSERT(flags & XFS_TRANS_PERM_LOG_RES);
+			ASSERT(tresp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
 			error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(tp->t_mountp, logspace,
-						logcount, &tp->t_ticket,
-						XFS_TRANSACTION, permanent,
-						tp->t_type);
+			error = xfs_log_reserve(tp->t_mountp,
+						tresp->tr_logres,
+						tresp->tr_logcount,
+						&tp->t_ticket, XFS_TRANSACTION,
+						permanent, tp->t_type);
 		}
 
 		if (error)
 			goto undo_blocks;
 
-		tp->t_log_res = logspace;
-		tp->t_log_count = logcount;
+		tp->t_log_res = tresp->tr_logres;
+		tp->t_log_count = tresp->tr_logcount;
 	}
 
 	/*
@@ -946,10 +948,10 @@ xfs_trans_reserve(
 	 * reservations which have already been performed.
 	 */
 undo_log:
-	if (logspace > 0) {
+	if (tresp->tr_logres > 0) {
 		int		log_flags;
 
-		if (flags & XFS_TRANS_PERM_LOG_RES) {
+		if (tresp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
 			log_flags = XFS_LOG_REL_PERM_RESERV;
 		} else {
 			log_flags = 0;
@@ -1696,7 +1698,7 @@ xfs_trans_roll(
 	struct xfs_inode	*dp)
 {
 	struct xfs_trans	*trans;
-	unsigned int		logres, count;
+	struct xfs_trans_res	tres;
 	int			error;
 
 	/*
@@ -1708,8 +1710,8 @@ xfs_trans_roll(
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
+	tres.tr_logres = trans->t_log_res;
+	tres.tr_logcount = trans->t_log_count;
 	*tpp = xfs_trans_dup(trans);
 
 	/*
@@ -1740,8 +1742,8 @@ xfs_trans_roll(
 	 * across this call, or that anything that is locked be logged in
 	 * the prior and the next transactions.
 	 */
-	error = xfs_trans_reserve(trans, 0, logres, 0,
-				  XFS_TRANS_PERM_LOG_RES, count);
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(trans, &tres, 0, 0);
 	/*
 	 *  Ensure that the inode is in the new transaction and locked.
 	 */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6177040..8049f55 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -322,6 +322,7 @@ struct xfs_log_iovec;
 struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_trans_res;
 struct xfs_dquot_acct;
 struct xfs_busy_extent;
 
@@ -458,7 +459,7 @@ typedef struct xfs_trans {
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
 xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
-int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
+int		xfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				  uint, uint);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 0025c78..5795ced 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -66,8 +66,6 @@ xfs_dir_ialloc(
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
-	uint		log_res;
-	uint		log_count;
 	void		*dqinfo;
 	uint		tflags;
 
@@ -113,6 +111,8 @@ xfs_dir_ialloc(
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
+		struct xfs_trans_res tres;
+
 		/*
 		 * Normally, xfs_trans_commit releases all the locks.
 		 * We call bhold to hang on to the ialloc_context across
@@ -125,8 +125,8 @@ xfs_dir_ialloc(
 		 * Save the log reservation so we can use
 		 * them in the next transaction.
 		 */
-		log_res = xfs_trans_get_log_res(tp);
-		log_count = xfs_trans_get_log_count(tp);
+		tres.tr_logres = xfs_trans_get_log_res(tp);
+		tres.tr_logcount = xfs_trans_get_log_count(tp);
 
 		/*
 		 * We want the quota changes to be associated with the next
@@ -169,8 +169,9 @@ xfs_dir_ialloc(
 		 * reference that we gained in xfs_trans_dup()
 		 */
 		xfs_log_ticket_put(tp->t_ticket);
-		code = xfs_trans_reserve(tp, 0, log_res, 0,
-					 XFS_TRANS_PERM_LOG_RES, log_count);
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		code = xfs_trans_reserve(tp, &tres, 0, 0);
+
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
 		 */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1501f4f..503193c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -110,10 +110,7 @@ xfs_free_eofblocks(
 			}
 		}
 
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_ITRUNCATE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_ITRUNCATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_itruncate, 0, 0);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
@@ -255,13 +252,14 @@ int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
-	xfs_bmap_free_t	free_list;
-	xfs_fsblock_t	first_block;
-	int		committed;
-	xfs_trans_t	*tp;
-	xfs_mount_t	*mp;
-	int		error;
-	int		truncate = 0;
+	xfs_bmap_free_t		free_list;
+	xfs_fsblock_t		first_block;
+	int			committed;
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp;
+	struct xfs_trans_res	*tresp;
+	int			error;
+	int			truncate = 0;
 
 	/*
 	 * If the inode is already free, then there can be nothing
@@ -305,13 +303,10 @@ xfs_inactive(
 		return VN_INACTIVE_CACHE;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, 0,
-			(truncate || S_ISLNK(ip->i_d.di_mode)) ?
-				XFS_ITRUNCATE_LOG_RES(mp) :
-				XFS_IFREE_LOG_RES(mp),
-			0,
-			XFS_TRANS_PERM_LOG_RES,
-			XFS_ITRUNCATE_LOG_COUNT);
+	tresp = (truncate || S_ISLNK(ip->i_d.di_mode)) ?
+		&m_tresp(mp)->tr_itruncate : &m_tresp(mp)->tr_ifree;
+
+	error = xfs_trans_reserve(tp, tresp, 0, 0);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_trans_cancel(tp, 0);
@@ -365,10 +360,7 @@ xfs_inactive(
 			goto out;
 
 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_IFREE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_INACTIVE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_ifree, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			goto out;
@@ -498,9 +490,8 @@ xfs_create(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_trans_res	tres;
 	uint			resblks;
-	uint			log_res;
-	uint			log_count;
 
 	trace_xfs_create(dp, name);
 
@@ -523,13 +514,13 @@ xfs_create(
 	if (is_dir) {
 		rdev = 0;
 		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
-		log_res = XFS_MKDIR_LOG_RES(mp);
-		log_count = XFS_MKDIR_LOG_COUNT;
+		tres.tr_logres = m_tresp(mp)->tr_mkdir.tr_logres;
+		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
 	} else {
 		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
-		log_res = XFS_CREATE_LOG_RES(mp);
-		log_count = XFS_CREATE_LOG_COUNT;
+		tres.tr_logres = m_tresp(mp)->tr_create.tr_logres;
+		tres.tr_logcount = XFS_CREATE_LOG_COUNT;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	}
 
@@ -541,19 +532,17 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	error = xfs_trans_reserve(tp, resblks, log_res, 0,
-			XFS_TRANS_PERM_LOG_RES, log_count);
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(tp, &tres, resblks, 0);
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_reserve(tp, resblks, log_res, 0,
-				XFS_TRANS_PERM_LOG_RES, log_count);
+		error = xfs_trans_reserve(tp, &tres, resblks, 0);
 	}
 	if (error == ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, log_res, 0,
-				XFS_TRANS_PERM_LOG_RES, log_count);
+		error = xfs_trans_reserve(tp, &tres, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -902,12 +891,10 @@ xfs_remove(
 	 * block from the directory.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_reserve(tp, resblks, XFS_REMOVE_LOG_RES(mp), 0,
-				  XFS_TRANS_PERM_LOG_RES, log_count);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_remove, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES, log_count);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_remove, 0, 0);
 	}
 	if (error) {
 		ASSERT(error != ENOSPC);
@@ -1049,12 +1036,10 @@ xfs_link(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, resblks, XFS_LINK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_link, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_LINK_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_link, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -1136,7 +1121,7 @@ xfs_set_dmattrs(
 		return XFS_ERROR(EIO);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_DMATTRS);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES (mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_ichange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
@@ -1264,10 +1249,8 @@ xfs_alloc_file_space(
 		 * Allocate and setup the transaction.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		error = xfs_trans_reserve(tp, resblks,
-					  XFS_WRITE_LOG_RES(mp), resrtextents,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_write,
+					  resblks, resrtextents);
 		/*
 		 * Check for running out of space
 		 */
@@ -1557,13 +1540,8 @@ xfs_free_file_space(
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		tp->t_flags |= XFS_TRANS_RESERVE;
-		error = xfs_trans_reserve(tp,
-					  resblks,
-					  XFS_WRITE_LOG_RES(mp),
-					  0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
-
+		error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_write,
+					  resblks, 0);
 		/*
 		 * check for running out of space
 		 */
@@ -1837,8 +1815,8 @@ xfs_change_file_space(
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
 
-	if ((error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(mp),
-				      0, 0, 0))) {
+	error = xfs_trans_reserve(tp, &m_tresp(mp)->tr_writeid, 0, 0);
+	if (error) {
 		/* ASSERT(0); */
 		xfs_trans_cancel(tp, 0);
 		return error;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
