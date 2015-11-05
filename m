Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B8C77FC2
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 05:40:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15D56AC002
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 03:40:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2GHjiM6D8DTjjUag (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 03:40:25 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v14 05/22] vfs: Add permission flags for setting file
	attributes
Date: Thu,  5 Nov 2015 12:39:23 +0100
Message-Id: <1446723580-3747-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Richacls support permissions that allow to take ownership of a file,
change the file permissions, and set the file timestamps.  Support that
by introducing new permission mask flags and by checking for those mask
flags in inode_change_ok().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/attr.c          | 79 +++++++++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |  3 +++
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 328be71..85483e0 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -17,6 +17,65 @@
 #include <linux/ima.h>
 
 /**
+ * inode_extended_permission  -  permissions beyond read/write/execute
+ *
+ * Check for permissions that only richacls can currently grant.
+ */
+static int inode_extended_permission(struct inode *inode, int mask)
+{
+	if (!IS_RICHACL(inode))
+		return -EPERM;
+	return inode_permission(inode, mask);
+}
+
+static bool inode_uid_change_ok(struct inode *inode, kuid_t ia_uid)
+{
+	if (uid_eq(current_fsuid(), inode->i_uid) &&
+	    uid_eq(ia_uid, inode->i_uid))
+		return true;
+	if (uid_eq(current_fsuid(), ia_uid) &&
+	    inode_extended_permission(inode, MAY_TAKE_OWNERSHIP) == 0)
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	return false;
+}
+
+static bool inode_gid_change_ok(struct inode *inode, kgid_t ia_gid)
+{
+	int in_group = in_group_p(ia_gid);
+	if (uid_eq(current_fsuid(), inode->i_uid) &&
+	    (in_group || gid_eq(ia_gid, inode->i_gid)))
+		return true;
+	if (in_group && inode_extended_permission(inode, MAY_TAKE_OWNERSHIP) == 0)
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	return false;
+}
+
+/**
+ * inode_owner_permitted_or_capable
+ *
+ * Check for permissions implicitly granted to the owner, like MAY_CHMOD or
+ * MAY_SET_TIMES.  Equivalent to inode_owner_or_capable for file systems
+ * without support for those permissions.
+ */
+static bool inode_owner_permitted_or_capable(struct inode *inode, int mask)
+{
+	struct user_namespace *ns;
+
+	if (uid_eq(current_fsuid(), inode->i_uid))
+		return true;
+	if (inode_extended_permission(inode, mask) == 0)
+		return true;
+	ns = current_user_ns();
+	if (ns_capable(ns, CAP_FOWNER) && kuid_has_mapping(ns, inode->i_uid))
+		return true;
+	return false;
+}
+
+/**
  * inode_change_ok - check if attribute changes to an inode are allowed
  * @inode:	inode to check
  * @attr:	attributes to change
@@ -47,22 +106,18 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 		return 0;
 
 	/* Make sure a caller can chown. */
-	if ((ia_valid & ATTR_UID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
-		return -EPERM;
+	if (ia_valid & ATTR_UID)
+		if (!inode_uid_change_ok(inode, attr->ia_uid))
+			return -EPERM;
 
 	/* Make sure caller can chgrp. */
-	if ((ia_valid & ATTR_GID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
-		return -EPERM;
+	if (ia_valid & ATTR_GID)
+		if (!inode_gid_change_ok(inode, attr->ia_gid))
+			return -EPERM;
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
-		if (!inode_owner_or_capable(inode))
+		if (!inode_owner_permitted_or_capable(inode, MAY_CHMOD))
 			return -EPERM;
 		/* Also check the setgid bit! */
 		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
@@ -73,7 +128,7 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Check for setting the inode time. */
 	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)) {
-		if (!inode_owner_or_capable(inode))
+		if (!inode_owner_permitted_or_capable(inode, MAY_SET_TIMES))
 			return -EPERM;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aab32c8..ba91a89 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -86,6 +86,9 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 #define MAY_CREATE_DIR		0x00000200
 #define MAY_DELETE_CHILD	0x00000400
 #define MAY_DELETE_SELF		0x00000800
+#define MAY_TAKE_OWNERSHIP	0x00001000
+#define MAY_CHMOD		0x00002000
+#define MAY_SET_TIMES		0x00004000
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
