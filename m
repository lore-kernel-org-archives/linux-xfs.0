Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9687A7F4C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:24:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2ED01AC001
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:24:07 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:02 -0700
Message-Id: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <87boan3prc.fsf@xmission.com>
References: <87boan3prc.fsf@xmission.com>
Subject: [PATCH 01/14] xfs: Convert uids and gids in xfs acls to/from kuids
	and kgids
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
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

- When reading from disk convert on disk uids and gids to kuids and kgids
- When writing to the disk convert in memory kuids and kgids to uids and gids.
- Don't write e_id as that field only exists when user namespace
  support is disabled.
- Use uid_eq when testing to see if current_fsuid() is allowed to set the
  acls for a file.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_acl.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 1d32f1d..ca2aade 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -64,14 +64,17 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
+			acl_e->e_uid = make_kuid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
+			break;
 		case ACL_GROUP:
-			acl_e->e_id = be32_to_cpu(ace->ae_id);
+			acl_e->e_gid = make_kgid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			acl_e->e_id = ACL_UNDEFINED_ID;
 			break;
 		default:
 			goto fail;
@@ -97,8 +100,20 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		acl_e = &acl->a_entries[i];
 
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
-		ace->ae_id = cpu_to_be32(acl_e->e_id);
 		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
+		case ACL_USER:
+			ace->ae_id = cpu_to_be32(
+				from_kuid(&init_user_ns, acl_e->e_uid));
+			break;
+		case ACL_GROUP:
+			ace->ae_id = cpu_to_be32(
+				from_kgid(&init_user_ns, acl_e->e_gid));
+			break;
+		default:
+			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
+			break;
+		}
 	}
 }
 
@@ -355,7 +370,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		return -EINVAL;
 	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
 		return value ? -EACCES : 0;
-	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
+	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (!value)
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
