Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012FIAt019598
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp793-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:33 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012JXWw024700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:33 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012JXe5006974
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:33 GMT
Subject: [PATCH 05/22] xfs: pack inode allocation parameters into a separate
 structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:32 -0800
Message-ID: <154630917213.18437.11076220872907040413.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of open-coding new inode parameters through xfs_dir_ialloc and
xfs_Ialloc, put everything into a structure and pass that instead.  This
will make it easier to share code with xfsprogs while maintaining the
ability for xfsprogs to supply extra new inode parameters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.h |   14 +++++++++
 fs/xfs/xfs_inode.c             |   64 +++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 808e4322106e..942524b59cf6 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -43,4 +43,18 @@ xfs_get_initial_prid(struct xfs_icdinode *id)
 	return XFS_PROJID_DEFAULT;
 }
 
+/* Initial ids, link count, device number, and mode of a new inode. */
+struct xfs_ialloc_args {
+	struct xfs_inode		*pip;	/* parent inode or null */
+
+	uint32_t			uid;
+	uint32_t			gid;
+	prid_t				prid;
+
+	xfs_nlink_t			nlink;
+	dev_t				rdev;
+
+	umode_t				mode;
+};
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 79c8876e9f61..403eb8fa2f1f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -654,28 +654,25 @@ xfs_lookup(
  */
 static int
 xfs_ialloc(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	dev_t		rdev,
-	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
-	xfs_inode_t	**ipp)
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
 {
-	struct xfs_mount *mp = tp->t_mountp;
-	xfs_ino_t	ino;
-	xfs_inode_t	*ip;
-	uint		flags;
-	int		error;
-	struct timespec64 tv;
-	struct inode	*inode;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	struct inode			*inode;
+	xfs_ino_t			ino;
+	uint				flags;
+	int				error;
+	struct timespec64		tv;
 
 	/*
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
 			    ialloc_context, &ino);
 	if (error)
 		return error;
@@ -717,16 +714,16 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 1)
 		ip->i_d.di_version = 2;
 
-	inode->i_mode = mode;
-	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
-	inode->i_rdev = rdev;
-	xfs_set_projid(&ip->i_d, prid);
+	inode->i_mode = args->mode;
+	set_nlink(inode, args->nlink);
+	ip->i_d.di_uid = args->uid;
+	ip->i_d.di_gid = args->gid;
+	inode->i_rdev = args->rdev;
+	xfs_set_projid(&ip->i_d, args->prid);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
+		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
 			inode->i_mode |= S_ISGID;
 	}
 
@@ -764,7 +761,7 @@ xfs_ialloc(
 
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
@@ -778,7 +775,7 @@ xfs_ialloc(
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
 			uint		di_flags = 0;
 
-			if (S_ISDIR(mode)) {
+			if (S_ISDIR(args->mode)) {
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
@@ -787,7 +784,7 @@ xfs_ialloc(
 				}
 				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
-			} else if (S_ISREG(mode)) {
+			} else if (S_ISREG(args->mode)) {
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
@@ -882,6 +879,15 @@ xfs_dir_ialloc(
 	xfs_inode_t	**ipp)		/* pointer to inode; it will be
 					   locked. */
 {
+	struct xfs_ialloc_args	args = {
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= prid,
+		.nlink	= nlink,
+		.rdev	= rdev,
+		.mode	= mode,
+	};
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
@@ -907,8 +913,7 @@ xfs_dir_ialloc(
 	 * transaction commit so that no other process can steal
 	 * the inode(s) that we've just allocated.
 	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
-			&ip);
+	code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
 
 	/*
 	 * Return an error if we were unable to allocate a new inode.
@@ -977,8 +982,7 @@ xfs_dir_ialloc(
 		 * other allocations in this allocation group,
 		 * this call should always succeed.
 		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  &ialloc_context, &ip);
+		code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
 
 		/*
 		 * If we get an error at this point, return to the caller
