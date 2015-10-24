Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A2897F6A
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:16:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 518918F8040
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VBEf6bGqbsjIK2nq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:20 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id CF3CB54
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 21:16:19 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
Date: Sat, 24 Oct 2015 23:16:08 +0200
Message-Id: <1445721369-25679-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Map uids and gids in the trusted.SGI_ACL_{FILE,DEFAULT} attributes between
the kernel and user-space namespaces.  This needs to be done in the
filesystem because the VFS is unaware of those attributes; for the standard
POSIX ACL attributes, the VFS takes care of that for us.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 0eea7ee..64ffb85 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -39,7 +39,8 @@ STATIC struct posix_acl *
 xfs_acl_from_disk(
 	const struct xfs_acl	*aclp,
 	int			len,
-	int			max_entries)
+	int			max_entries,
+	struct user_namespace	*ns)
 {
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
@@ -71,10 +72,10 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			acl_e->e_uid = make_kuid(ns, be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_GROUP:
-			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
+			acl_e->e_gid = make_kgid(ns, be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
@@ -93,7 +94,10 @@ fail:
 }
 
 STATIC void
-xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
+xfs_acl_to_disk(
+	struct xfs_acl		*aclp,
+	const struct posix_acl	*acl,
+	struct user_namespace	*ns)
 {
 	const struct posix_acl_entry *acl_e;
 	struct xfs_acl_entry *ace;
@@ -107,10 +111,10 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			ace->ae_id = cpu_to_be32(from_kuid(ns, acl_e->e_uid));
 			break;
 		case ACL_GROUP:
-			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			ace->ae_id = cpu_to_be32(from_kgid(ns, acl_e->e_gid));
 			break;
 		default:
 			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
@@ -166,7 +170,8 @@ xfs_get_acl(struct inode *inode, int type)
 		goto out;
 	}
 
-	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
+	acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount),
+				&init_user_ns);
 	if (IS_ERR(acl))
 		goto out;
 
@@ -205,7 +210,7 @@ __xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		if (!xfs_acl)
 			return -ENOMEM;
 
-		xfs_acl_to_disk(xfs_acl, acl);
+		xfs_acl_to_disk(xfs_acl, acl, &init_user_ns);
 
 		/* subtract away the unused acl entries */
 		len -= sizeof(struct xfs_acl_entry) *
@@ -325,10 +330,11 @@ xfs_xattr_acl_get(struct dentry *dentry, const char *name,
 
 	error = XFS_ACL_SIZE(acl->a_count);
 	if (value) {
+		struct user_namespace *user_ns = current_user_ns();
 		if (error > size)
 			error = -ERANGE;
 		else
-			xfs_acl_to_disk(value, acl);
+			xfs_acl_to_disk(value, acl, user_ns);
 	}
 
 	posix_acl_release(acl);
@@ -351,7 +357,10 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		return value ? -EACCES : 0;
 
 	if (value) {
-		acl = xfs_acl_from_disk(value, size, XFS_ACL_MAX_ENTRIES(ip->i_mount));
+		struct user_namespace *user_ns = current_user_ns();
+		acl = xfs_acl_from_disk(value, size,
+					XFS_ACL_MAX_ENTRIES(ip->i_mount),
+					user_ns);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
