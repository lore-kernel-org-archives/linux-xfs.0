Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B4127F59
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:11:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B1C5304075
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:11:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EblIFQu0yhgL1f9v (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 08:11:28 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:11:25 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 4/6] convert kuid_t to/from uid_t for xfs internal structures
Message-ID: <20130628111125.38302feb@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

Use uint32 from init_user_ns for xfs internal uid/gid
representation in xfs_icdinode, xfs_dqid_t.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_inode.c    |  6 +++---
 fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_qm.c       | 10 +++++-----
 fs/xfs/xfs_quota.h    |  9 +++++----
 fs/xfs/xfs_symlink.c  |  4 +++-
 fs/xfs/xfs_vnodeops.c |  4 +++-
 6 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9ecfe1e..e9acd2d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1288,8 +1288,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid();
-	ip->i_d.di_gid = current_fsgid();
+	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
+	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	xfs_set_projid(ip, prid);
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
@@ -1328,7 +1328,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
+	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid)))) {
 		ip->i_d.di_mode &= ~S_ISGID;
 	}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c69bbc4..6f6fb17 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -420,8 +420,8 @@ xfs_vn_getattr(
 	stat->dev = inode->i_sb->s_dev;
 	stat->mode = ip->i_d.di_mode;
 	stat->nlink = ip->i_d.di_nlink;
-	stat->uid = ip->i_d.di_uid;
-	stat->gid = ip->i_d.di_gid;
+	stat->uid = inode->i_uid;
+	stat->gid = inode->i_gid;
 	stat->ino = ip->i_ino;
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
@@ -488,8 +488,8 @@ xfs_setattr_nonsize(
 	int			mask = iattr->ia_valid;
 	xfs_trans_t		*tp;
 	int			error;
-	uid_t			uid = 0, iuid = 0;
-	gid_t			gid = 0, igid = 0;
+	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
+	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
 	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
 
@@ -522,13 +522,13 @@ xfs_setattr_nonsize(
 			uid = iattr->ia_uid;
 			qflags |= XFS_QMOPT_UQUOTA;
 		} else {
-			uid = ip->i_d.di_uid;
+			uid = inode->i_uid;
 		}
 		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
 			gid = iattr->ia_gid;
 			qflags |= XFS_QMOPT_GQUOTA;
 		}  else {
-			gid = ip->i_d.di_gid;
+			gid = inode->i_gid;
 		}
 
 		/*
@@ -538,8 +538,10 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
+		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
+					   xfs_kgid_to_gid(gid),
+					   xfs_get_projid(ip),
+					   qflags, &udqp, &gdqp);
 		if (error)
 			return error;
 	}
@@ -561,8 +563,8 @@ xfs_setattr_nonsize(
 		 * while we didn't have the inode locked, inode's dquot(s)
 		 * would have changed also.
 		 */
-		iuid = ip->i_d.di_uid;
-		igid = ip->i_d.di_gid;
+		iuid = inode->i_uid;
+		igid = inode->i_gid;
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
@@ -571,8 +573,8 @@ xfs_setattr_nonsize(
 		 * going to change.
 		 */
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
-		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
-		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
+		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
+		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
 			ASSERT(tp);
 			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -602,17 +604,17 @@ xfs_setattr_nonsize(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (iuid != uid) {
+		if (!uid_eq(iuid, uid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
 				ASSERT(mask & ATTR_UID);
 				ASSERT(udqp);
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = uid;
+			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
 		}
-		if (igid != gid) {
+		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
 				ASSERT(!XFS_IS_PQUOTA_ON(mp));
 				ASSERT(mask & ATTR_GID);
@@ -620,7 +622,7 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = gid;
+			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
@@ -1173,8 +1175,8 @@ xfs_setup_inode(
 
 	inode->i_mode	= ip->i_d.di_mode;
 	set_nlink(inode, ip->i_d.di_nlink);
-	inode->i_uid	= ip->i_d.di_uid;
-	inode->i_gid	= ip->i_d.di_gid;
+	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
+	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b75c9bb..57e2c18 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1651,8 +1651,8 @@ xfs_qm_write_sb_changes(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
-	uid_t			uid,
-	gid_t			gid,
+	xfs_dqid_t		uid,
+	xfs_dqid_t		gid,
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
@@ -1697,7 +1697,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
+			if ((error = xfs_qm_dqget(mp, NULL, uid,
 						 XFS_DQ_USER,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
@@ -1723,7 +1723,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
+			if ((error = xfs_qm_dqget(mp, NULL, gid,
 						 XFS_DQ_GROUP,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
@@ -1842,7 +1842,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
+	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
 		delblksudq = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c38068f..5f0bfe8 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -320,8 +320,8 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, long, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
-		struct xfs_dquot **, struct xfs_dquot **);
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
+		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 		struct xfs_dquot *, struct xfs_dquot *);
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
@@ -341,8 +341,9 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
-		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
+		prid_t prid, uint flags, struct xfs_dquot **udqp,
+		struct xfs_dquot **gdqp)
 {
 	*udqp = NULL;
 	*gdqp = NULL;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 738c04b..75bb3ea 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -384,7 +384,9 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			xfs_kuid_to_uid(current_fsuid()),
+			xfs_kgid_to_gid(current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 42c0ef2..0262e1d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -506,7 +506,9 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			xfs_kuid_to_uid(current_fsuid()),
+			xfs_kgid_to_gid(current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		return error;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
