Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1FD97F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:21:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 901FE304043
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:21:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xxRdvjdFZdrYQK4d for
	<xfs@oss.sgi.com>; Wed, 09 Apr 2014 12:21:54 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s39JLrJc026330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 15:21:53 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s39JLqHP009589
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 15:21:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/2] xfs: fold xfs_create_tmpfile() into xfs_create()
Date: Wed,  9 Apr 2014 15:21:51 -0400
Message-Id: <1397071311-28371-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
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

xfs_create_tmpfile() duplicates most of xfs_create() with the exception
of a couple minor differences. We use a unique transaction reservation
and place the allocated inode on the unlinked list rather than create a
directory entry for it.

Fold xfs_create_tmpfile() into xfs_create() to reduce some of this
duplication. The name parameter that represents the name of the
directory entry to create is now conditional and its existence dictates
whether a directory entry is created for the inode or not.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 185 +++++++++++++----------------------------------------
 fs/xfs/xfs_iops.c  |   8 +--
 fs/xfs/xfs_trace.h |   7 +-
 3 files changed, 54 insertions(+), 146 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 768087b..b895526 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1158,7 +1158,7 @@ xfs_create(
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	tres;
+	struct xfs_trans_res	*tres;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1181,14 +1181,21 @@ xfs_create(
 	if (is_dir) {
 		rdev = 0;
 		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
-		tres.tr_logres = M_RES(mp)->tr_mkdir.tr_logres;
-		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
+		tres = &M_RES(mp)->tr_mkdir;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_MKDIR);
-	} else {
+	} else if (name) {
 		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
-		tres.tr_logres = M_RES(mp)->tr_create.tr_logres;
-		tres.tr_logcount = XFS_CREATE_LOG_COUNT;
+		tres = &M_RES(mp)->tr_create;
 		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
+	} else {
+		/*
+		 * If we don't have a name, we're in the ->tmpfile() path. We
+		 * have a unique transaction here since we modify the unlinked
+		 * list rather than create a directory entry.
+		 */
+		resblks = XFS_IALLOC_SPACE_RES(mp);
+		tres = &M_RES(mp)->tr_create_tmpfile;
+		tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
 	}
 
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
@@ -1199,26 +1206,22 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	error = xfs_trans_reserve(tp, &tres, resblks, 0);
+	error = xfs_trans_reserve(tp, tres, resblks, 0);
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_reserve(tp, &tres, resblks, 0);
+		error = xfs_trans_reserve(tp, tres, resblks, 0);
 	}
 	if (error == ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
-		error = xfs_trans_reserve(tp, &tres, 0, 0);
+		error = xfs_trans_reserve(tp, tres, 0, 0);
 	}
 	if (error) {
 		cancel_flags = 0;
 		goto out_trans_cancel;
 	}
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
-	unlock_dp_on_error = true;
-
 	xfs_bmap_init(&free_list, &first_block);
 
 	/*
@@ -1229,9 +1232,14 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_canenter(tp, dp, name, resblks);
-	if (error)
-		goto out_trans_cancel;
+	if (name) {
+		xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+		unlock_dp_on_error = true;
+
+		error = xfs_dir_canenter(tp, dp, name, resblks);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	/*
 	 * A newly created regular or special file just has one directory
@@ -1253,27 +1261,34 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	if (name) {
+		xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+		unlock_dp_on_error = false;
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
+		error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
-	if (error) {
-		ASSERT(error != ENOSPC);
-		goto out_trans_abort;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+		if (error) {
+			ASSERT(error != ENOSPC);
+			goto out_trans_abort;
+		}
+		xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
-	if (is_dir) {
-		error = xfs_dir_init(tp, ip, dp);
-		if (error)
-			goto out_bmap_cancel;
+		if (is_dir) {
+			error = xfs_dir_init(tp, ip, dp);
+			if (error)
+				goto out_bmap_cancel;
 
-		error = xfs_bumplink(tp, dp);
+			error = xfs_bumplink(tp, dp);
+			if (error)
+				goto out_bmap_cancel;
+		}
+	} else {
+		ip->i_d.di_nlink--;
+		error = xfs_iunlink(tp, ip);
 		if (error)
-			goto out_bmap_cancel;
+			goto out_trans_abort;
 	}
 
 	/*
@@ -1331,114 +1346,6 @@ xfs_create(
 }
 
 int
-xfs_create_tmpfile(
-	struct xfs_inode	*dp,
-	struct dentry		*dentry,
-	umode_t			mode,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_inode	*ip = NULL;
-	struct xfs_trans	*tp = NULL;
-	int			error;
-	uint			cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
-	prid_t                  prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
-	uint			resblks;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	prid = xfs_get_initial_prid(dp);
-
-	/*
-	 * Make sure that we have allocated dquot(s) on disk.
-	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
-				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-				&udqp, &gdqp, &pdqp);
-	if (error)
-		return error;
-
-	resblks = XFS_IALLOC_SPACE_RES(mp);
-	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
-
-	tres = &M_RES(mp)->tr_create_tmpfile;
-	error = xfs_trans_reserve(tp, tres, resblks, 0);
-	if (error == ENOSPC) {
-		/* No space at all so try a "no-allocation" reservation */
-		resblks = 0;
-		error = xfs_trans_reserve(tp, tres, 0, 0);
-	}
-	if (error) {
-		cancel_flags = 0;
-		goto out_trans_cancel;
-	}
-
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
-	if (error)
-		goto out_trans_cancel;
-
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0,
-				prid, resblks > 0, &ip, NULL);
-	if (error) {
-		if (error == ENOSPC)
-			goto out_trans_cancel;
-		goto out_trans_abort;
-	}
-
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(tp);
-
-	/*
-	 * Attach the dquot(s) to the inodes and modify them incore.
-	 * These ids of the inode couldn't have changed since the new
-	 * inode has been locked ever since it was created.
-	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
-
-	ip->i_d.di_nlink--;
-	error = xfs_iunlink(tp, ip);
-	if (error)
-		goto out_trans_abort;
-
-	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (error)
-		goto out_release_inode;
-
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
-
-	*ipp = ip;
-	return 0;
-
- out_trans_abort:
-	cancel_flags |= XFS_TRANS_ABORT;
- out_trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
- out_release_inode:
-	/*
-	 * Wait until after the current transaction is aborted to
-	 * release the inode.  This prevents recursive transactions
-	 * and deadlocks from xfs_inactive.
-	 */
-	if (ip)
-		IRELE(ip);
-
-	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
-	xfs_qm_dqrele(pdqp);
-
-	return error;
-}
-
-int
 xfs_link(
 	xfs_inode_t		*tdp,
 	xfs_inode_t		*sip,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 301ecbf..b430eb7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -137,7 +137,7 @@ xfs_generic_create(
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
 	struct posix_acl *default_acl, *acl;
-	struct xfs_name	name;
+	struct xfs_name	name, *namep = NULL;
 	int		error;
 
 	/*
@@ -158,10 +158,10 @@ xfs_generic_create(
 
 	if (!tmpfile) {
 		xfs_dentry_to_name(&name, dentry, mode);
-		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
-	} else {
-		error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
+		namep = &name;
 	}
+
+	error = xfs_create(XFS_I(dir), namep, mode, rdev, &ip);
 	if (unlikely(error))
 		goto out_free_acl;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a4ae41c..da46c94 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -691,13 +691,14 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, dp_ino)
 		__field(int, namelen)
-		__dynamic_array(char, name, name->len)
+		__dynamic_array(char, name, name ? name->len : 0)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(dp)->i_sb->s_dev;
 		__entry->dp_ino = dp->i_ino;
-		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__entry->namelen = name ? name->len : 0;
+		if (name)
+			memcpy(__get_str(name), name->name, name->len);
 	),
 	TP_printk("dev %d:%d dp ino 0x%llx name %.*s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
