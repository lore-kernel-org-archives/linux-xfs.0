Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B80E7F7E
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:08:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEF5FAC003
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:08:25 -0700 (PDT)
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 2/7] xfs: convert kuid_t to/from uid_t in ACLs
Date: Thu, 15 Aug 2013 14:07:59 -0400
Message-Id: <1376590084-12888-3-git-send-email-dwight.engen@oracle.com>
In-Reply-To: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
References: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>

Change permission check for setting ACL to use inode_owner_or_capable()
which will additionally allow a CAP_FOWNER user in a user namespace to
be able to set an ACL on an inode covered by the user namespace mapping.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_acl.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 2f77db8..6951896 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -70,14 +70,15 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
+			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			break;
 		case ACL_GROUP:
-			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			acl_e->e_id = ACL_UNDEFINED_ID;
 			break;
 		default:
 			goto fail;
@@ -103,7 +104,18 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		acl_e = &acl->a_entries[i];
 
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
-		ace->ae_id = cpu_to_be32(acl_e->e_id);
+		switch (acl_e->e_tag) {
+		case ACL_USER:
+			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			break;
+		case ACL_GROUP:
+			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			break;
+		default:
+			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
+			break;
+		}
+
 		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
 	}
 }
@@ -362,7 +374,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		return -EINVAL;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (!value)
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
