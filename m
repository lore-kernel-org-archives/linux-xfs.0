Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G7qJg031846 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:07:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 088C3164F1F7
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:07:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mjS26WKDOZhmpU2b for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:07:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xm1-0007eb-0g
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:53 +0000
Message-Id: <20081202160652.907502000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 22/22] use inode_change_ok for setattr permission checking
Content-Disposition: inline; filename=xfs-setattr-use-inode_change_ok
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

Instead of implementing our own checks use inode_change_ok to check for
necessary permission in setattr.  There is a slight change in behaviour
as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
without superuser privilegues while the old XFS code just stripped away
those bits from the file mode.

(First sent on Semptember 29th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_vnodeops.c	2008-12-02 14:00:52.000000000 +0100
+++ xfs-master/fs/xfs/xfs_vnodeops.c	2008-12-02 14:00:52.000000000 +0100
@@ -70,7 +70,6 @@ xfs_setattr(
 	gid_t			gid=0, igid=0;
 	int			timeflags = 0;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
-	int			file_owner;
 	int			need_iolock = 1;
 
 	xfs_itrace_entry(ip);
@@ -81,6 +80,10 @@ xfs_setattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	code = -inode_change_ok(inode, iattr);
+	if (code)
+		return code;
+
 	olddquot1 = olddquot2 = NULL;
 	udqp = gdqp = NULL;
 
@@ -158,56 +161,6 @@ xfs_setattr(
 
 	xfs_ilock(ip, lock_flags);
 
-	/* boolean: are we the file owner? */
-	file_owner = (current_fsuid() == ip->i_d.di_uid);
-
-	/*
-	 * Change various properties of a file.
-	 * Only the owner or users with CAP_FOWNER
-	 * capability may do these things.
-	 */
-	if (mask & (ATTR_MODE|ATTR_UID|ATTR_GID)) {
-		/*
-		 * CAP_FOWNER overrides the following restrictions:
-		 *
-		 * The user ID of the calling process must be equal
-		 * to the file owner ID, except in cases where the
-		 * CAP_FSETID capability is applicable.
-		 */
-		if (!file_owner && !capable(CAP_FOWNER)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The effective user ID of the calling process shall match
-		 * the file owner when setting the set-user-ID and
-		 * set-group-ID bits on that file.
-		 *
-		 * The effective group ID or one of the supplementary group
-		 * IDs of the calling process shall match the group owner of
-		 * the file when setting the set-group-ID bit on that file
-		 */
-		if (mask & ATTR_MODE) {
-			mode_t m = 0;
-
-			if ((iattr->ia_mode & S_ISUID) && !file_owner)
-				m |= S_ISUID;
-			if ((iattr->ia_mode & S_ISGID) &&
-			    !in_group_p((gid_t)ip->i_d.di_gid))
-				m |= S_ISGID;
-#if 0
-			/* Linux allows this, Irix doesn't. */
-			if ((iattr->ia_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
-				m |= S_ISVTX;
-#endif
-			if (m && !capable(CAP_FSETID))
-				iattr->ia_mode &= ~m;
-		}
-	}
-
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
@@ -224,22 +177,6 @@ xfs_setattr(
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
 		/*
-		 * CAP_CHOWN overrides the following restrictions:
-		 *
-		 * If _POSIX_CHOWN_RESTRICTED is defined, this capability
-		 * shall override the restriction that a process cannot
-		 * change the user ID of a file it owns and the restriction
-		 * that the group ID supplied to the chown() function
-		 * shall be equal to either the group ID or one of the
-		 * supplementary group IDs of the calling process.
-		 */
-		if ((iuid != uid ||
-		     (igid != gid && !in_group_p((gid_t)gid))) &&
-		    !capable(CAP_CHOWN)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-		/*
 		 * Do a quota reservation only if uid/gid is actually
 		 * going to change.
 		 */
@@ -276,36 +213,22 @@ xfs_setattr(
 			code = XFS_ERROR(EINVAL);
 			goto error_return;
 		}
+
 		/*
 		 * Make sure that the dquots are attached to the inode.
 		 */
-		if ((code = XFS_QM_DQATTACH(mp, ip, XFS_QMOPT_ILOCKED)))
+		code = XFS_QM_DQATTACH(mp, ip, XFS_QMOPT_ILOCKED);
+		if (code)
 			goto error_return;
-	}
-
-	/*
-	 * Change file access or modified times.
-	 */
-	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
-		if (!file_owner) {
-			if ((mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)) &&
-			    !capable(CAP_FOWNER)) {
-				code = XFS_ERROR(EPERM);
-				goto error_return;
-			}
-		}
-	}
 
-	/*
-	 * Now we can make the changes.  Before we join the inode
-	 * to the transaction, if ATTR_SIZE is set then take care of
-	 * the part of the truncation that must be done without the
-	 * inode lock.  This needs to be done before joining the inode
-	 * to the transaction, because the inode cannot be unlocked
-	 * once it is a part of the transaction.
-	 */
-	if (mask & ATTR_SIZE) {
-		code = 0;
+		/*
+		 * Now we can make the changes.  Before we join the inode
+		 * to the transaction, if ATTR_SIZE is set then take care of
+		 * the part of the truncation that must be done without the
+		 * inode lock.  This needs to be done before joining the inode
+		 * to the transaction, because the inode cannot be unlocked
+		 * once it is a part of the transaction.
+		 */
 		if (iattr->ia_size > ip->i_size) {
 			/*
 			 * Do the first part of growing a file: zero any data
@@ -360,17 +283,10 @@ xfs_setattr(
 		}
 		commit_flags = XFS_TRANS_RELEASE_LOG_RES;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-	}
 
-	if (tp) {
 		xfs_trans_ijoin(tp, ip, lock_flags);
 		xfs_trans_ihold(tp, ip);
-	}
 
-	/*
-	 * Truncate file.  Must have write permission and not be a directory.
-	 */
-	if (mask & ATTR_SIZE) {
 		/*
 		 * Only change the c/mtime if we are changing the size
 		 * or we are explicitly asked to change it. This handles
@@ -410,20 +326,9 @@ xfs_setattr(
 			 */
 			xfs_iflags_set(ip, XFS_ITRUNCATED);
 		}
-	}
-
-	/*
-	 * Change file access modes.
-	 */
-	if (mask & ATTR_MODE) {
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= iattr->ia_mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= iattr->ia_mode & ~S_IFMT;
-
-		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
-		timeflags |= XFS_ICHGTIME_CHG;
+	} else if (tp) {
+		xfs_trans_ijoin(tp, ip, lock_flags);
+		xfs_trans_ihold(tp, ip);
 	}
 
 	/*
@@ -471,6 +376,24 @@ xfs_setattr(
 		timeflags |= XFS_ICHGTIME_CHG;
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+
+		ip->i_d.di_mode &= S_IFMT;
+		ip->i_d.di_mode |= mode & ~S_IFMT;
+
+		inode->i_mode &= S_IFMT;
+		inode->i_mode |= mode & ~S_IFMT;
+
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		timeflags |= XFS_ICHGTIME_CHG;
+	}
 
 	/*
 	 * Change file access or modified times.

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
