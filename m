Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 341FA7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 08:10:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9BF46AC00A
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 06:10:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iH4cR5LLz6Zy9DWT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 06:10:43 -0700 (PDT)
Date: Mon, 24 Jun 2013 09:10:35 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130624091035.6274800f@oracle.com>
In-Reply-To: <20130624003316.GH29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
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

Hi Dave, all. Here is a v2 patch that I believe addresses the previous
comments, but I expect there to be more :) I think there are a few
more issues to sort out before this is ready, and I want to add some
tests to xfstests also.

I added permission checks for eofblocks in the ioctl code, but
I don't think they are enough. Just because an unprivileged
caller is in a group doesn't mean he can write to a file of that group,
and I don't know how we can check for that till we get the inode in
hand. Brian, if you or anyone else could comment on how this should work
for the regular user and write() ENOSPC cases that'd be great.

The xfs code now uses inode->i_uid where possible instead of di_uid.
The remaining uses of di_uid are where the inode is being setup,
conversion to/from disk endianess, in dealing with quotas, and bulkstat.

We do need to decide on the di_uid that comes back from bulkstat.
Right now it is returning on disk (== init_user_ns) uids. It looks to
me like xfsrestore is using the normal vfs routines (chown, fchown,
lchown) when restoring so that won't line up if the xfsrestore is run
in !init_user_ns. We could possibly convert to userns values
before returning them from the kernel, but I doubt that will work
well with the xfs quotas. Should we just require that callers of bulkstat
be in init_user_ns? Thoughts?


--

Use uint32 from init_user_ns for xfs internal uid/gid representation in
acl, xfs_icdinode, xfs_dqid_t. Conversion of kuid/gid is done for these
structures and for the eofblocks filter. Other user visible xfs specific
interfaces (bulkstat) expect uint32 init_user_ns uid/gid values.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_acl.c      | 20 ++++++++++++++++----
 fs/xfs/xfs_fs.h       |  2 +-
 fs/xfs/xfs_icache.c   |  6 +++---
 fs/xfs/xfs_inode.c    |  6 +++---
 fs/xfs/xfs_ioctl.c    | 37 ++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_linux.h    | 35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c       | 10 +++++-----
 fs/xfs/xfs_quota.h    |  9 +++++----
 fs/xfs/xfs_symlink.c  |  4 +++-
 fs/xfs/xfs_vnodeops.c |  4 +++-
 init/Kconfig          | 15 +--------------
 12 files changed, 129 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 306d883..b497ca2 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -68,14 +68,15 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
+			acl_e->e_uid = xfs_kuid_from_disk(be32_to_cpu(ace->ae_id));
+			break;
 		case ACL_GROUP:
-			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			acl_e->e_gid = xfs_kgid_from_disk(be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			acl_e->e_id = ACL_UNDEFINED_ID;
 			break;
 		default:
 			goto fail;
@@ -101,7 +102,18 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		acl_e = &acl->a_entries[i];
 
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
-		ace->ae_id = cpu_to_be32(acl_e->e_id);
+		switch(acl_e->e_tag) {
+		case ACL_USER:
+			ace->ae_id = cpu_to_be32(xfs_kuid_to_disk(acl_e->e_uid));
+			break;
+		case ACL_GROUP:
+			ace->ae_id = cpu_to_be32(xfs_kgid_to_disk(acl_e->e_gid));
+			break;
+		default:
+			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
+			break;
+		}
+
 		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
 	}
 }
@@ -360,7 +372,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		return -EINVAL;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (!value)
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index d046955..6bc3da4 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -344,7 +344,7 @@ typedef struct xfs_error_injection {
  * Speculative preallocation trimming.
  */
 #define XFS_EOFBLOCKS_VERSION		1
-struct xfs_eofblocks {
+struct xfs_ueofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
 	uid_t		eof_uid;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 96e344e..2c35b13 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -617,7 +617,7 @@ restart:
 
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'background_prealloc_discard_period' tunable (5m by default).
+ * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
  */
 STATIC void
 xfs_queue_eofblocks(
@@ -1202,11 +1202,11 @@ xfs_inode_match_id(
 	struct xfs_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
-	    ip->i_d.di_uid != eofb->eof_uid)
+	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
-	    ip->i_d.di_gid != eofb->eof_gid)
+	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7f7be5f..2dc9e66 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1268,8 +1268,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid();
-	ip->i_d.di_gid = current_fsgid();
+	ip->i_d.di_uid = xfs_kuid_to_disk(current_fsuid());
+	ip->i_d.di_gid = xfs_kgid_to_disk(current_fsgid());
 	xfs_set_projid(ip, prid);
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
@@ -1308,7 +1308,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
+	    (!in_group_p(xfs_kgid_from_disk(ip->i_d.di_gid)))) {
 		ip->i_d.di_mode &= ~S_ISGID;
 	}
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5e99968..d6e64d9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -981,7 +981,7 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+	if (!inode_owner_or_capable(VFS_I(ip))) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
@@ -1610,7 +1610,8 @@ xfs_file_ioctl(
 		return -error;
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_eofblocks eofb;
+		struct xfs_ueofblocks eofb;
+		struct xfs_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
@@ -1625,7 +1626,37 @@ xfs_file_ioctl(
 		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
+		keofb.eof_version = eofb.eof_version;
+		keofb.eof_flags = eofb.eof_flags;
+		keofb.eof_prid = eofb.eof_prid;
+		keofb.eof_min_file_size = eofb.eof_min_file_size;
+
+		if (eofb.eof_flags & XFS_EOF_FLAGS_UID) {
+			keofb.eof_uid = make_kuid(current_user_ns(), eofb.eof_uid);
+			if (!uid_valid(keofb.eof_uid))
+				return -XFS_ERROR(EINVAL);
+		}
+
+		if (eofb.eof_flags & XFS_EOF_FLAGS_GID) {
+			keofb.eof_gid = make_kgid(current_user_ns(), eofb.eof_gid);
+			if (!gid_valid(keofb.eof_gid))
+				return -XFS_ERROR(EINVAL);
+		}
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			if (!(eofb.eof_flags & (XFS_EOF_FLAGS_UID | XFS_EOF_FLAGS_GID)))
+				return -XFS_ERROR(EPERM);
+
+			if ((eofb.eof_flags & XFS_EOF_FLAGS_UID) &&
+			    !uid_eq(current_fsuid(), keofb.eof_uid))
+				return -XFS_ERROR(EPERM);
+
+			if ((eofb.eof_flags & XFS_EOF_FLAGS_GID) &&
+			    !in_group_p(keofb.eof_gid))
+				return -XFS_ERROR(EPERM);
+		}
+
+		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ca9ecaa..5beabf4 100644
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
+		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_disk(uid),
+					   xfs_kgid_to_disk(gid),
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
+			ip->i_d.di_uid = xfs_kuid_to_disk(uid);
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
+			ip->i_d.di_gid = xfs_kgid_to_disk(gid);
 			inode->i_gid = gid;
 		}
 	}
@@ -1172,8 +1174,8 @@ xfs_setup_inode(
 
 	inode->i_mode	= ip->i_d.di_mode;
 	set_nlink(inode, ip->i_d.di_nlink);
-	inode->i_uid	= ip->i_d.di_uid;
-	inode->i_gid	= ip->i_d.di_gid;
+	inode->i_uid    = xfs_kuid_from_disk(ip->i_d.di_uid);
+	inode->i_gid    = xfs_kgid_from_disk(ip->i_d.di_gid);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 800f896..80326da 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -159,6 +159,41 @@
 #define MAX(a,b)	(max(a,b))
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
+/* Kernel uid/gid conversion. These are used to convert to/from the on disk
+ * uid/gid types to the kuid_t/kgid_t types that the kernel uses internally.
+ * The conversion here is type only, the value will remain the same since we
+ * are converting to the init_user_ns. The uid is later mapped to a particular
+ * user namespace value when crossing the kernel/user boundary.
+ */
+static inline __uint32_t xfs_kuid_to_disk(kuid_t uid)
+{
+	return from_kuid(&init_user_ns, uid);
+}
+
+static inline kuid_t xfs_kuid_from_disk(__uint32_t uid)
+{
+	return make_kuid(&init_user_ns, uid);
+}
+
+static inline __uint32_t xfs_kgid_to_disk(kgid_t gid)
+{
+	return from_kgid(&init_user_ns, gid);
+}
+
+static inline kgid_t xfs_kgid_from_disk(__uint32_t gid)
+{
+	return make_kgid(&init_user_ns, gid);
+}
+
+struct xfs_eofblocks {
+	__u32		eof_version;
+	__u32		eof_flags;
+	kuid_t		eof_uid;
+	kgid_t		eof_gid;
+	prid_t		eof_prid;
+	__u64		eof_min_file_size;
+};
+
 /*
  * Various platform dependent calls that don't fit anywhere else
  */
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
index 195a403..c50306e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -384,7 +384,9 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			xfs_kuid_to_disk(current_fsuid()),
+			xfs_kgid_to_disk(current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 0176bb2..94f4f9f6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -515,7 +515,9 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+	error = xfs_qm_vop_dqalloc(dp,
+			xfs_kuid_to_disk(current_fsuid()),
+			xfs_kgid_to_disk(current_fsgid()), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		return error;
diff --git a/init/Kconfig b/init/Kconfig
index 9d3a788..8083ffd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1065,7 +1065,6 @@ config IPC_NS
 
 config USER_NS
 	bool "User namespace"
-	depends on UIDGID_CONVERTED
 	select UIDGID_STRICT_TYPE_CHECKS
 
 	default n
@@ -1099,21 +1098,9 @@ config NET_NS
 
 endif # NAMESPACES
 
-config UIDGID_CONVERTED
-	# True if all of the selected software conmponents are known
-	# to have uid_t and gid_t converted to kuid_t and kgid_t
-	# where appropriate and are otherwise safe to use with
-	# the user namespace.
-	bool
-	default y
-
-	# Filesystems
-	depends on XFS_FS = n
-
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
-	depends on UIDGID_CONVERTED
-	default n
+	default y
 	help
 	 While the nececessary conversions are being added to all subsystems this option allows
 	 the code to continue to build for unconverted subsystems.
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
