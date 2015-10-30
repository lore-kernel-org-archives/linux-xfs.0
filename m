Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 539577F52
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 10:05:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5EF3AC004
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t7N4Idf1L6WlfXO8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 08:05:24 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 4/5] xfs: Add namespace parameter to the xfs kuid/kgid <=>
	uid/gid wrappers
Date: Fri, 30 Oct 2015 16:05:07 +0100
Message-Id: <1446217508-22157-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c     |  8 ++++----
 fs/xfs/xfs_inode.c   | 14 +++++++-------
 fs/xfs/xfs_iops.c    | 12 ++++++------
 fs/xfs/xfs_linux.h   | 21 ++++++++++-----------
 fs/xfs/xfs_symlink.c |  4 ++--
 5 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index c094165..40fce17 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -71,10 +71,10 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			acl_e->e_uid = xfs_uid_to_kuid(&init_user_ns, be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_GROUP:
-			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
+			acl_e->e_gid = xfs_gid_to_kgid(&init_user_ns, be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
@@ -107,10 +107,10 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(&init_user_ns, acl_e->e_uid));
 			break;
 		case ACL_GROUP:
-			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(&init_user_ns, acl_e->e_gid));
 			break;
 		default:
 			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dc40a6d..d849b15 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -795,8 +795,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	ip->i_d.di_uid = xfs_kuid_to_uid(&init_user_ns, current_fsuid());
+	ip->i_d.di_gid = xfs_kgid_to_gid(&init_user_ns, current_fsgid());
 	xfs_set_projid(ip, prid);
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
@@ -814,7 +814,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid)))) {
+	    (!in_group_p(xfs_gid_to_kgid(&init_user_ns, ip->i_d.di_gid)))) {
 		ip->i_d.di_mode &= ~S_ISGID;
 	}
 
@@ -1161,8 +1161,8 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-					xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(&init_user_ns, current_fsuid()),
+					xfs_kgid_to_gid(&init_user_ns, current_fsgid()), prid,
 					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 					&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1340,8 +1340,8 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
-				xfs_kgid_to_gid(current_fsgid()), prid,
+	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(&init_user_ns, current_fsuid()),
+				xfs_kgid_to_gid(&init_user_ns, current_fsgid()), prid,
 				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 				&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8294132..f25d2c7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -598,8 +598,8 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
+		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(&init_user_ns, uid),
+					   xfs_kgid_to_gid(&init_user_ns, gid),
 					   xfs_get_projid(ip),
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
@@ -671,7 +671,7 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
+			ip->i_d.di_uid = xfs_kuid_to_uid(&init_user_ns, uid);
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
@@ -683,7 +683,7 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
+			ip->i_d.di_gid = xfs_kgid_to_gid(&init_user_ns, gid);
 			inode->i_gid = gid;
 		}
 	}
@@ -1230,8 +1230,8 @@ xfs_setup_inode(
 
 	inode->i_mode	= ip->i_d.di_mode;
 	set_nlink(inode, ip->i_d.di_nlink);
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
+	inode->i_uid    = xfs_uid_to_kuid(&init_user_ns, ip->i_d.di_uid);
+	inode->i_gid    = xfs_gid_to_kgid(&init_user_ns, ip->i_d.di_gid);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 85f883d..1bf92ec 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -173,28 +173,27 @@ struct xfs_kobj {
 
 /* Kernel uid/gid conversion. These are used to convert to/from the on disk
  * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
- * The conversion here is type only, the value will remain the same since we
- * are converting to the init_user_ns. The uid is later mapped to a particular
- * user namespace value when crossing the kernel/user boundary.
+ * The uid is later mapped to a particular user namespace value when crossing
+ * the kernel/user boundary.
  */
-static inline __uint32_t xfs_kuid_to_uid(kuid_t uid)
+static inline __uint32_t xfs_kuid_to_uid(struct user_namespace *ns, kuid_t uid)
 {
-	return from_kuid(&init_user_ns, uid);
+	return from_kuid(ns, uid);
 }
 
-static inline kuid_t xfs_uid_to_kuid(__uint32_t uid)
+static inline kuid_t xfs_uid_to_kuid(struct user_namespace *ns, __uint32_t uid)
 {
-	return make_kuid(&init_user_ns, uid);
+	return make_kuid(ns, uid);
 }
 
-static inline __uint32_t xfs_kgid_to_gid(kgid_t gid)
+static inline __uint32_t xfs_kgid_to_gid(struct user_namespace *ns, kgid_t gid)
 {
-	return from_kgid(&init_user_ns, gid);
+	return from_kgid(ns, gid);
 }
 
-static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
+static inline kgid_t xfs_gid_to_kgid(struct user_namespace *ns, __uint32_t gid)
 {
-	return make_kgid(&init_user_ns, gid);
+	return make_kgid(ns, gid);
 }
 
 /*
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 996481e..a0c42a9 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -215,8 +215,8 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp,
-			xfs_kuid_to_uid(current_fsuid()),
-			xfs_kgid_to_gid(current_fsgid()), prid,
+			xfs_kuid_to_uid(&init_user_ns, current_fsuid()),
+			xfs_kgid_to_gid(&init_user_ns, current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
