Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E40157F9E
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64EC8AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:51:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6aWutKaMXlLvJZ6k for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:51:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004Yi-EX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00063V-Db
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 38/50] xfs: refactor
	xfs_trans_reserve() interface
Date: Mon, 12 Aug 2013 20:49:59 +1000
Message-Id: <1376304611-22994-39-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

With the new xfs_trans_res structure has been introduced, the log
reservation size, log count as well as log flags are pre-initialized
at mount time.  So it's time to refine xfs_trans_reserve() interface
to be more neat.

Also, introduce a new helper M_RES() to return a pointer to the
mp->m_resv structure to simplify the input.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_aops.c          |  2 +-
 fs/xfs/xfs_attr.c          | 33 +++++++++--------
 fs/xfs/xfs_attr_inactive.c |  5 ++-
 fs/xfs/xfs_bmap.c          |  4 +--
 fs/xfs/xfs_bmap_util.c     | 42 ++++++++--------------
 fs/xfs/xfs_dquot.c         |  6 ++--
 fs/xfs/xfs_fsops.c         |  8 ++---
 fs/xfs/xfs_inode.c         | 88 +++++++++++++++++++---------------------------
 fs/xfs/xfs_ioctl.c         |  4 +--
 fs/xfs/xfs_iomap.c         | 18 ++++------
 fs/xfs/xfs_iops.c          |  8 ++---
 fs/xfs/xfs_log_recover.c   |  5 ++-
 fs/xfs/xfs_mount.c         |  9 ++---
 fs/xfs/xfs_qm.c            | 11 +++---
 fs/xfs/xfs_qm_syscalls.c   | 13 +++----
 fs/xfs/xfs_rtalloc.c       | 17 ++++-----
 fs/xfs/xfs_symlink.c       | 10 +++---
 fs/xfs/xfs_trans.c         | 51 ++++++++++++++-------------
 fs/xfs/xfs_trans.h         |  3 +-
 fs/xfs/xfs_trans_resv.c    |  7 ++--
 fs/xfs/xfs_trans_resv.h    |  3 ++
 21 files changed, 150 insertions(+), 197 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a82c837..1269434 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -116,7 +116,7 @@ xfs_setfilesize_trans_alloc(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 046cf3d..176dbb6 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -226,13 +226,14 @@ xfs_attr_set_int(
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
@@ -292,11 +293,11 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	error = xfs_trans_reserve(args.trans, args.total,
-				  XFS_ATTRSETM_LOG_RES(mp) +
-				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
-				  0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_ATTRSET_LOG_COUNT);
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
@@ -516,11 +517,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	if (flags & ATTR_ROOT)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans,
-				      XFS_ATTRRM_SPACE_RES(mp),
-				      XFS_ATTRRM_LOG_RES(mp),
-				      0, XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRRM_LOG_COUNT))) {
+	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
+				  XFS_ATTRRM_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index ace95e7..bb24b07 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -412,9 +412,8 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	 * the log.
 	 */
 	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
-	if ((error = xfs_trans_reserve(trans, 0, XFS_ATTRINVAL_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRINVAL_LOG_COUNT))) {
+	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
+	if (error) {
 		xfs_trans_cancel(trans, 0);
 		return(error);
 	}
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 51e07e7..6c2d89e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1148,8 +1148,8 @@ xfs_bmap_add_attrfork(
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 	if (rsvd)
 		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
+	if (error)
 		goto error0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b5232d0..cc2ab9b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -78,8 +78,7 @@ xfs_bmap_finish(
 	xfs_efi_log_item_t	*efi;		/* extent free intention */
 	int			error;		/* error return value */
 	xfs_bmap_free_item_t	*free;		/* free extent item */
-	unsigned int		logres;		/* new log reservation */
-	unsigned int		logcount;	/* new log count */
+	struct xfs_trans_res	tres;		/* new log reservation */
 	xfs_mount_t		*mp;		/* filesystem mount structure */
 	xfs_bmap_free_item_t	*next;		/* next item on free list */
 	xfs_trans_t		*ntp;		/* new transaction pointer */
@@ -94,8 +93,10 @@ xfs_bmap_finish(
 	for (free = flist->xbf_first; free; free = free->xbfi_next)
 		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
-	logres = ntp->t_log_res;
-	logcount = ntp->t_log_count;
+
+	tres.tr_logres = ntp->t_log_res;
+	tres.tr_logcount = ntp->t_log_count;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	ntp = xfs_trans_dup(*tp);
 	error = xfs_trans_commit(*tp, 0);
 	*tp = ntp;
@@ -113,8 +114,8 @@ xfs_bmap_finish(
 	 */
 	xfs_log_ticket_put(ntp->t_ticket);
 
-	if ((error = xfs_trans_reserve(ntp, 0, logres, 0, XFS_TRANS_PERM_LOG_RES,
-			logcount)))
+	error = xfs_trans_reserve(ntp, &tres, 0, 0);
+	if (error)
 		return error;
 	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
@@ -929,10 +930,7 @@ xfs_free_eofblocks(
 			}
 		}
 
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_ITRUNCATE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_ITRUNCATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
@@ -1085,10 +1083,8 @@ xfs_alloc_file_space(
 		 * Allocate and setup the transaction.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-		error = xfs_trans_reserve(tp, resblks,
-					  XFS_WRITE_LOG_RES(mp), resrtextents,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  resblks, resrtextents);
 		/*
 		 * Check for running out of space
 		 */
@@ -1378,12 +1374,7 @@ xfs_free_file_space(
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		tp->t_flags |= XFS_TRANS_RESERVE;
-		error = xfs_trans_reserve(tp,
-					  resblks,
-					  XFS_WRITE_LOG_RES(mp),
-					  0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
 
 		/*
 		 * check for running out of space
@@ -1657,10 +1648,8 @@ xfs_change_file_space(
 	 * update the inode timestamp, mode, and prealloc flag bits
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
-
-	if ((error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(mp),
-				      0, 0, 0))) {
-		/* ASSERT(0); */
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
@@ -1905,9 +1894,8 @@ xfs_swap_extents(
 	truncate_pagecache_range(VFS_I(ip), 0, -1);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
-	if ((error = xfs_trans_reserve(tp, 0,
-				     XFS_ICHANGE_LOG_RES(mp), 0,
-				     0, 0))) {
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	if (error) {
 		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
 		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
 		xfs_trans_cancel(tp, 0);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e90e123..251c666 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -712,10 +712,8 @@ xfs_qm_dqread(
 
 	if (flags & XFS_QMOPT_DQALLOC) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
-					  XFS_QM_DQALLOC_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES,
-					  XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_attrsetm,
+					  XFS_QM_DQALLOC_SPACE_RES(mp), 0);
 		if (error)
 			goto error1;
 		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 614eb0c..e64ee52 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -203,8 +203,9 @@ xfs_growfs_data_private(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
 	tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp),
-			XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
+				  XFS_GROWFS_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
@@ -739,8 +740,7 @@ xfs_fs_log_dummy(
 	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e83d3af..2f41a1a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -892,8 +892,6 @@ xfs_dir_ialloc(
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
-	uint		log_res;
-	uint		log_count;
 	void		*dqinfo;
 	uint		tflags;
 
@@ -939,6 +937,8 @@ xfs_dir_ialloc(
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
+		struct xfs_trans_res tres;
+
 		/*
 		 * Normally, xfs_trans_commit releases all the locks.
 		 * We call bhold to hang on to the ialloc_context across
@@ -951,8 +951,8 @@ xfs_dir_ialloc(
 		 * Save the log reservation so we can use
 		 * them in the next transaction.
 		 */
-		log_res = xfs_trans_get_log_res(tp);
-		log_count = xfs_trans_get_log_count(tp);
+		tres.tr_logres = xfs_trans_get_log_res(tp);
+		tres.tr_logcount = xfs_trans_get_log_count(tp);
 
 		/*
 		 * We want the quota changes to be associated with the next
@@ -995,8 +995,9 @@ xfs_dir_ialloc(
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
@@ -1161,9 +1162,8 @@ xfs_create(
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	tres;
 	uint			resblks;
-	uint			log_res;
-	uint			log_count;
 
 	trace_xfs_create(dp, name);
 
@@ -1187,13 +1187,13 @@ xfs_create(
 	if (is_dir) {
 		rdev = 0;
 		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
-		log_res = XFS_MKDIR_LOG_RES(mp);
-		log_count = XFS_MKDIR_LOG_COUNT;
+		tres.tr_logres = M_RES(mp)->tr_mkdir.tr_logres;
+		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
 	} else {
 		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
-		log_res = XFS_CREATE_LOG_RES(mp);
-		log_count = XFS_CREATE_LOG_COUNT;
+		tres.tr_logres = M_RES(mp)->tr_create.tr_logres;
+		tres.tr_logcount = XFS_CREATE_LOG_COUNT;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	}
 
@@ -1205,19 +1205,17 @@ xfs_create(
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
@@ -1371,12 +1369,10 @@ xfs_link(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, resblks, XFS_LINK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_LINK_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_LINK_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -1551,10 +1547,7 @@ xfs_itruncate_extents(
 		 * reference that we gained in xfs_trans_dup()
 		 */
 		xfs_log_ticket_put(tp->t_ticket);
-		error = xfs_trans_reserve(tp, 0,
-					XFS_ITRUNCATE_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_ITRUNCATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 		if (error)
 			goto out;
 	}
@@ -1680,13 +1673,14 @@ int
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
+	struct xfs_trans_res	*resp;
+	int			error;
+	int			truncate = 0;
 
 	/*
 	 * If the inode is already free, then there can be nothing
@@ -1730,13 +1724,10 @@ xfs_inactive(
 		return VN_INACTIVE_CACHE;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, 0,
-			(truncate || S_ISLNK(ip->i_d.di_mode)) ?
-				XFS_ITRUNCATE_LOG_RES(mp) :
-				XFS_IFREE_LOG_RES(mp),
-			0,
-			XFS_TRANS_PERM_LOG_RES,
-			XFS_ITRUNCATE_LOG_COUNT);
+	resp = (truncate || S_ISLNK(ip->i_d.di_mode)) ?
+		&M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
+
+	error = xfs_trans_reserve(tp, resp, 0, 0);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_trans_cancel(tp, 0);
@@ -1781,10 +1772,7 @@ xfs_inactive(
 			goto out;
 
 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-		error = xfs_trans_reserve(tp, 0,
-					  XFS_IFREE_LOG_RES(mp),
-					  0, XFS_TRANS_PERM_LOG_RES,
-					  XFS_INACTIVE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			goto out;
@@ -2431,12 +2419,10 @@ xfs_remove(
 	 * block from the directory.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_reserve(tp, resblks, XFS_REMOVE_LOG_RES(mp), 0,
-				  XFS_TRANS_PERM_LOG_RES, log_count);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_remove, resblks, 0);
 	if (error == ENOSPC) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_REMOVE_LOG_RES(mp), 0,
-					  XFS_TRANS_PERM_LOG_RES, log_count);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_remove, 0, 0);
 	}
 	if (error) {
 		ASSERT(error != ENOSPC);
@@ -2631,12 +2617,10 @@ xfs_rename(
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_reserve(tp, spaceres, XFS_RENAME_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
 	if (error == ENOSPC) {
 		spaceres = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_RENAME_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_RENAME_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
 	}
 	if (error) {
 		xfs_trans_cancel(tp, 0);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index efb216d..e9c17e2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -367,7 +367,7 @@ xfs_set_dmattrs(
 		return XFS_ERROR(EIO);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_DMATTRS);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES (mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
@@ -1001,7 +1001,7 @@ xfs_ioctl_setattr(
 	 * first do an error checking pass.
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	code = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (code)
 		goto error_return;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index cf8f744..8d4d49b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -188,10 +188,8 @@ xfs_iomap_write_direct(
 	 * Allocate and setup the transaction
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
-	error = xfs_trans_reserve(tp, resblks,
-			XFS_WRITE_LOG_RES(mp), resrtextents,
-			XFS_TRANS_PERM_LOG_RES,
-			XFS_WRITE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				  resblks, resrtextents);
 	/*
 	 * Check for running out of space, note: need lock to return
 	 */
@@ -699,10 +697,8 @@ xfs_iomap_write_allocate(
 			tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
 			tp->t_flags |= XFS_TRANS_RESERVE;
 			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-			error = xfs_trans_reserve(tp, nres,
-					XFS_WRITE_LOG_RES(mp),
-					0, XFS_TRANS_PERM_LOG_RES,
-					XFS_WRITE_LOG_COUNT);
+			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+						  nres, 0);
 			if (error) {
 				xfs_trans_cancel(tp, 0);
 				return XFS_ERROR(error);
@@ -865,10 +861,8 @@ xfs_iomap_write_unwritten(
 		sb_start_intwrite(mp->m_super);
 		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
 		tp->t_flags |= XFS_TRANS_RESERVE | XFS_TRANS_FREEZE_PROT;
-		error = xfs_trans_reserve(tp, resblks,
-				XFS_WRITE_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_WRITE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  resblks, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			return XFS_ERROR(error);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 24be68d..82c5a5d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -546,7 +546,7 @@ xfs_setattr_nonsize(
 	}
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error)
 		goto out_dqrele;
 
@@ -808,9 +808,7 @@ xfs_setattr_size(
 		goto out_unlock;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				 XFS_TRANS_PERM_LOG_RES,
-				 XFS_ITRUNCATE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -933,7 +931,7 @@ xfs_vn_update_time(
 	trace_xfs_update_time(ip);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return -error;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 81c04eb..217e7fb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3377,7 +3377,7 @@ xlog_recover_process_efi(
 	}
 
 	tp = xfs_trans_alloc(mp, 0);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto abort_error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
@@ -3483,8 +3483,7 @@ xlog_recover_clear_agi_bucket(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_CLEAR_AGI_BUCKET);
-	error = xfs_trans_reserve(tp, 0, XFS_CLEAR_AGI_BUCKET_LOG_RES(mp),
-				  0, 0, 0);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_clearagi, 0, 0);
 	if (error)
 		goto out_abort;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7a9986d..85b6aaa 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -597,8 +597,7 @@ xfs_mount_reset_sbqflags(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_sbchange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_alert(mp, "%s: Superblock update failed!", __func__);
@@ -1071,8 +1070,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 		return 0;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
@@ -1392,8 +1390,7 @@ xfs_mount_log_sb(
 			 XFS_SB_VERSIONNUM));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
-	error = xfs_trans_reserve(tp, 0, XFS_SB_LOG_RES(mp), 0, 0,
-				  XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 35a6f56..479c933 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -865,11 +865,9 @@ xfs_qm_qino_alloc(
 	}
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
-	if ((error = xfs_trans_reserve(tp,
-				      XFS_QM_QINOCREATE_SPACE_RES(mp),
-				      XFS_CREATE_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_CREATE_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_create,
+				  XFS_QM_QINOCREATE_SPACE_RES(mp), 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
@@ -1740,8 +1738,7 @@ xfs_qm_write_sb_changes(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_sbchange, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 6fdccc3..5290af2 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -247,9 +247,7 @@ xfs_qm_scall_trunc_qfile(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
-	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-				  XFS_TRANS_PERM_LOG_RES,
-				  XFS_ITRUNCATE_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
@@ -540,8 +538,7 @@ xfs_qm_scall_setqlim(
 	xfs_dqunlock(dqp);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_setqlim, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		goto out_rele;
@@ -675,8 +672,7 @@ xfs_qm_log_quotaoff_end(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF_END);
 
-	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_END_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_equotaoff, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
@@ -709,8 +705,7 @@ xfs_qm_log_quotaoff(
 	uint			oldsbqflag=0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_quotaoff, 0, 0);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6dbcb5e..6f9e63c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -100,10 +100,9 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		if ((error = xfs_trans_reserve(tp, resblks,
-				XFS_GROWRTALLOC_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_DEFAULT_PERM_LOG_COUNT)))
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
+					  resblks, 0);
+		if (error)
 			goto error_cancel;
 		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
 		/*
@@ -146,8 +145,9 @@ xfs_growfs_rt_alloc(
 			/*
 			 * Reserve log for one block zeroing.
 			 */
-			if ((error = xfs_trans_reserve(tp, 0,
-					XFS_GROWRTZERO_LOG_RES(mp), 0, 0, 0)))
+			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtzero,
+						  0, 0);
+			if (error)
 				goto error_cancel;
 			/*
 			 * Lock the bitmap inode.
@@ -1957,8 +1957,9 @@ xfs_growfs_rt(
 		 * Start a transaction, get the log reservation.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_FREE);
-		if ((error = xfs_trans_reserve(tp, 0,
-				XFS_GROWRTFREE_LOG_RES(nmp), 0, 0, 0)))
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtfree,
+					  0, 0);
+		if (error)
 			goto error_cancel;
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e6facbf..7676fe3 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -231,12 +231,10 @@ xfs_symlink(
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
-	error = xfs_trans_reserve(tp, resblks, XFS_SYMLINK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_symlink, resblks, 0);
 	if (error == ENOSPC && fs_blocks == 0) {
 		resblks = 0;
-		error = xfs_trans_reserve(tp, 0, XFS_SYMLINK_LOG_RES(mp), 0,
-				XFS_TRANS_PERM_LOG_RES, XFS_SYMLINK_LOG_COUNT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_symlink, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
@@ -539,8 +537,8 @@ xfs_inactive_symlink_rmt(
 	 * Put an itruncate log reservation in the new transaction
 	 * for our caller.
 	 */
-	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ITRUNCATE_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		goto error0;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e0f93f9..b986400 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -56,7 +56,7 @@ void
 xfs_trans_init(
 	struct xfs_mount	*mp)
 {
-	xfs_trans_resv_calc(mp, &mp->m_resv);
+	xfs_trans_resv_calc(mp, M_RES(mp));
 }
 
 /*
@@ -180,12 +180,10 @@ xfs_trans_dup(
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
+	struct xfs_trans_res	*resp,
+	uint			blocks,
+	uint			rtextents)
 {
 	int		error = 0;
 	int		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
@@ -211,13 +209,15 @@ xfs_trans_reserve(
 	/*
 	 * Reserve the log space needed for this transaction.
 	 */
-	if (logspace > 0) {
+	if (resp->tr_logres > 0) {
 		bool	permanent = false;
 
-		ASSERT(tp->t_log_res == 0 || tp->t_log_res == logspace);
-		ASSERT(tp->t_log_count == 0 || tp->t_log_count == logcount);
+		ASSERT(tp->t_log_res == 0 ||
+		       tp->t_log_res == resp->tr_logres);
+		ASSERT(tp->t_log_count == 0 ||
+		       tp->t_log_count == resp->tr_logcount);
 
-		if (flags & XFS_TRANS_PERM_LOG_RES) {
+		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
 			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
 			permanent = true;
 		} else {
@@ -226,20 +226,21 @@ xfs_trans_reserve(
 		}
 
 		if (tp->t_ticket != NULL) {
-			ASSERT(flags & XFS_TRANS_PERM_LOG_RES);
+			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
 			error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(tp->t_mountp, logspace,
-						logcount, &tp->t_ticket,
-						XFS_TRANSACTION, permanent,
-						tp->t_type);
+			error = xfs_log_reserve(tp->t_mountp,
+						resp->tr_logres,
+						resp->tr_logcount,
+						&tp->t_ticket, XFS_TRANSACTION,
+						permanent, tp->t_type);
 		}
 
 		if (error)
 			goto undo_blocks;
 
-		tp->t_log_res = logspace;
-		tp->t_log_count = logcount;
+		tp->t_log_res = resp->tr_logres;
+		tp->t_log_count = resp->tr_logcount;
 	}
 
 	/*
@@ -264,10 +265,10 @@ xfs_trans_reserve(
 	 * reservations which have already been performed.
 	 */
 undo_log:
-	if (logspace > 0) {
+	if (resp->tr_logres > 0) {
 		int		log_flags;
 
-		if (flags & XFS_TRANS_PERM_LOG_RES) {
+		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
 			log_flags = XFS_LOG_REL_PERM_RESERV;
 		} else {
 			log_flags = 0;
@@ -1014,7 +1015,7 @@ xfs_trans_roll(
 	struct xfs_inode	*dp)
 {
 	struct xfs_trans	*trans;
-	unsigned int		logres, count;
+	struct xfs_trans_res	tres;
 	int			error;
 
 	/*
@@ -1026,8 +1027,8 @@ xfs_trans_roll(
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
-	logres = trans->t_log_res;
-	count = trans->t_log_count;
+	tres.tr_logres = trans->t_log_res;
+	tres.tr_logcount = trans->t_log_count;
 	*tpp = xfs_trans_dup(trans);
 
 	/*
@@ -1058,8 +1059,8 @@ xfs_trans_roll(
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
index b5dc61e..7eb81cc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -34,6 +34,7 @@ struct xfs_log_iovec;
 struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_trans_res;
 struct xfs_dquot_acct;
 struct xfs_busy_extent;
 
@@ -170,7 +171,7 @@ typedef struct xfs_trans {
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
 xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, xfs_km_flags_t);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
-int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
+int		xfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				  uint, uint);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index e9211ad..24110f3 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -547,7 +547,8 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ * to the attibute extent length in blocks by:
+ *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
 xfs_calc_attrsetrt_reservation(
@@ -619,14 +620,14 @@ xfs_calc_qm_setqlim_reservation(
 
 /*
  * Allocating quota on disk if needed.
- *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
+ *	the write transaction log space: M_RES(mp)->tr_write.tr_logres
  *	the unit of quota allocation: one system block size
  */
 STATIC uint
 xfs_calc_qm_dqalloc_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_WRITE_LOG_RES(mp) +
+	return M_RES(mp)->tr_write.tr_logres +
 		xfs_calc_buf_res(1,
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index b8d5666..140d3f3 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -65,6 +65,9 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
 
+/* shorthand way of accessing reservation structure */
+#define M_RES(mp)	(&(mp)->m_resv)
+
 /*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
