Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 419997F52
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:32:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1202B304059
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 03:32:48 -0800 (PST)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id j27HNdQrpJ1jxUEP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 03:32:46 -0800 (PST)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Mon, 25 Nov 2013 04:32:45 -0700
Received: from b03cxnp07027.gho.boulder.ibm.com
	(b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 71E9A3E40026
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:43 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07027.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id rAP9UgZu59506742
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 10:30:42 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP
	id rAPBWhrj032455
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:32:43 -0700
From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [RFC PATCH 1/4] xfs: adjust the interface of xfs_qm_vop_dqalloc()
Date: Mon, 25 Nov 2013 19:32:31 +0800
Message-Id: <1385379154-3802-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

There isn't a parent inode or a name for O_TMPFILE support, but will pass
a struct xfs_mount to xfs_qm_vop_dqalloc(). So its interface need to be
adjusted in order that O_TMPFILE creation function can also use it.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c   |    2 +-
 fs/xfs/xfs_ioctl.c   |    2 +-
 fs/xfs/xfs_iops.c    |    3 ++-
 fs/xfs/xfs_qm.c      |   50 +++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_quota.h   |    6 ++++--
 fs/xfs/xfs_symlink.c |    2 +-
 6 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..1c23bdf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1177,7 +1177,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
+	error = xfs_qm_vop_dqalloc(dp, mp, xfs_kuid_to_uid(current_fsuid()),
 					xfs_kgid_to_gid(current_fsgid()), prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4d61340..61abe32 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1089,7 +1089,7 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
+		code = xfs_qm_vop_dqalloc(ip, ip->i_mount, ip->i_d.di_uid,
 					 ip->i_d.di_gid, fa->fsx_projid,
 					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 27e0e54..eb55be5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -540,7 +540,8 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
+		error = xfs_qm_vop_dqalloc(ip, ip->i_mount,
+					   xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
 					   xfs_get_projid(ip),
 					   qflags, &udqp, &gdqp, NULL);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..1f13e82 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1765,6 +1765,7 @@ xfs_qm_write_sb_changes(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
+	struct xfs_mount	*mp,
 	xfs_dqid_t		uid,
 	xfs_dqid_t		gid,
 	prid_t			prid,
@@ -1773,7 +1774,6 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_gdqpp,
 	struct xfs_dquot	**O_pdqpp)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1783,17 +1783,19 @@ xfs_qm_vop_dqalloc(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	lockflags = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, lockflags);
+	if (ip) {
+		lockflags = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lockflags);
 
-	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
+			gid = ip->i_d.di_gid;
+	}
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
 	 * if necessary. The dquot(s) will not be locked.
 	 */
-	if (XFS_NOT_DQATTACHED(mp, ip)) {
+	if (ip && XFS_NOT_DQATTACHED(mp, ip)) {
 		error = xfs_qm_dqattach_locked(ip, XFS_QMOPT_DQALLOC);
 		if (error) {
 			xfs_iunlock(ip, lockflags);
@@ -1802,7 +1804,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (ip || (ip->i_d.di_uid != uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1812,7 +1814,8 @@ xfs_qm_vop_dqalloc(
 			 * we'll deadlock by doing trans_reserve while
 			 * holding ilock.
 			 */
-			xfs_iunlock(ip, lockflags);
+			if (ip)
+				xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, uid,
 						 XFS_DQ_USER,
 						 XFS_QMOPT_DQALLOC |
@@ -1826,8 +1829,10 @@ xfs_qm_vop_dqalloc(
 			 * Get the ilock in the right order.
 			 */
 			xfs_dqunlock(uq);
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
+			if (ip) {
+				lockflags = XFS_ILOCK_SHARED;
+				xfs_ilock(ip, lockflags);
+			}
 		} else {
 			/*
 			 * Take an extra reference, because we'll return
@@ -1838,8 +1843,9 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
-			xfs_iunlock(ip, lockflags);
+		if (ip && (ip->i_d.di_gid != gid)) {
+			if (ip)
+				xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, gid,
 						 XFS_DQ_GROUP,
 						 XFS_QMOPT_DQALLOC |
@@ -1850,16 +1856,19 @@ xfs_qm_vop_dqalloc(
 				goto error_rele;
 			}
 			xfs_dqunlock(gq);
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
+			if (ip) {
+				lockflags = XFS_ILOCK_SHARED;
+				xfs_ilock(ip, lockflags);
+			}
 		} else {
 			ASSERT(ip->i_gdquot);
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (xfs_get_projid(ip) != prid) {
-			xfs_iunlock(ip, lockflags);
+		if (ip || (xfs_get_projid(ip) != prid)) {
+			if (ip)
+				xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
 						 XFS_QMOPT_DQALLOC |
@@ -1870,8 +1879,10 @@ xfs_qm_vop_dqalloc(
 				goto error_rele;
 			}
 			xfs_dqunlock(pq);
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
+			if (ip) {
+				lockflags = XFS_ILOCK_SHARED;
+				xfs_ilock(ip, lockflags);
+			}
 		} else {
 			ASSERT(ip->i_pdquot);
 			pq = xfs_qm_dqhold(ip->i_pdquot);
@@ -1880,7 +1891,8 @@ xfs_qm_vop_dqalloc(
 	if (uq)
 		trace_xfs_dquot_dqalloc(ip);
 
-	xfs_iunlock(ip, lockflags);
+	if (ip)
+		xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
 		*O_udqpp = uq;
 	else if (uq)
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5376dd4..c898ad2 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -80,7 +80,8 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, long, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, struct xfs_mount *,
+		xfs_dqid_t, xfs_dqid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
 		struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
@@ -103,7 +104,8 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, struct xfs_mount *mp,
+		xfs_dqid_t uid, xfs_dqid_t gid,
 		prid_t prid, uint flags, struct xfs_dquot **udqp,
 		struct xfs_dquot **gdqp, struct xfs_dquot **pdqp)
 {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 14e58f2..dcb26692 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -216,7 +216,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp,
+	error = xfs_qm_vop_dqalloc(dp, mp,
 			xfs_kuid_to_uid(current_fsuid()),
 			xfs_kgid_to_gid(current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
