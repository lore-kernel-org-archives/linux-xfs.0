Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADC3629DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 21:09:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E44E8F8035
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 19:09:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vQxWUSciWZhsJd0y for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 19:09:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Uk3A1-0006hw-5I
	for xfs@oss.sgi.com; Wed, 05 Jun 2013 12:09:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Uk3A1-00039p-2A
	for xfs@oss.sgi.com; Wed, 05 Jun 2013 12:09:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: increase number of ACL entries for V5 superblocks
Date: Wed,  5 Jun 2013 12:09:10 +1000
Message-Id: <1370398150-12084-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370398150-12084-1-git-send-email-david@fromorbit.com>
References: <1370398150-12084-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The limit of 25 ACL entries is arbitrary, but baked into the on-disk
format.  For version 5 superblocks, increase it to the maximum nuber
of ACLs that can fit into a single xattr.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_acl.c |   31 ++++++++++++++++++-------------
 fs/xfs/xfs_acl.h |   31 ++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 1d32f1d..306d883 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -21,6 +21,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_vnodeops.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
 #include "xfs_trace.h"
 #include <linux/slab.h>
 #include <linux/xattr.h>
@@ -34,7 +36,9 @@
  */
 
 STATIC struct posix_acl *
-xfs_acl_from_disk(struct xfs_acl *aclp)
+xfs_acl_from_disk(
+	struct xfs_acl	*aclp,
+	int		max_entries)
 {
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
@@ -42,7 +46,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
-	if (count > XFS_ACL_MAX_ENTRIES)
+	if (count > max_entries)
 		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
@@ -108,9 +112,9 @@ xfs_get_acl(struct inode *inode, int type)
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl;
 	struct xfs_acl *xfs_acl;
-	int len = sizeof(struct xfs_acl);
 	unsigned char *ea_name;
 	int error;
+	int len;
 
 	acl = get_cached_acl(inode, type);
 	if (acl != ACL_NOT_CACHED)
@@ -133,8 +137,8 @@ xfs_get_acl(struct inode *inode, int type)
 	 * If we have a cached ACLs value just return it, not need to
 	 * go out to the disk.
 	 */
-
-	xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+	len = XFS_ACL_MAX_SIZE(ip->i_mount);
+	xfs_acl = kzalloc(len, GFP_KERNEL);
 	if (!xfs_acl)
 		return ERR_PTR(-ENOMEM);
 
@@ -153,7 +157,7 @@ xfs_get_acl(struct inode *inode, int type)
 		goto out;
 	}
 
-	acl = xfs_acl_from_disk(xfs_acl);
+	acl = xfs_acl_from_disk(xfs_acl, XFS_ACL_MAX_ENTRIES(ip->i_mount));
 	if (IS_ERR(acl))
 		goto out;
 
@@ -189,16 +193,17 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 
 	if (acl) {
 		struct xfs_acl *xfs_acl;
-		int len;
+		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
 
-		xfs_acl = kzalloc(sizeof(struct xfs_acl), GFP_KERNEL);
+		xfs_acl = kzalloc(len, GFP_KERNEL);
 		if (!xfs_acl)
 			return -ENOMEM;
 
 		xfs_acl_to_disk(xfs_acl, acl);
-		len = sizeof(struct xfs_acl) -
-			(sizeof(struct xfs_acl_entry) *
-			 (XFS_ACL_MAX_ENTRIES - acl->a_count));
+
+		/* subtract away the unused acl entries */
+		len -= sizeof(struct xfs_acl_entry) *
+			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
 		error = -xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
 				len, ATTR_ROOT);
@@ -243,7 +248,7 @@ xfs_set_mode(struct inode *inode, umode_t mode)
 static int
 xfs_acl_exists(struct inode *inode, unsigned char *name)
 {
-	int len = sizeof(struct xfs_acl);
+	int len = XFS_ACL_MAX_SIZE(XFS_M(inode->i_sb));
 
 	return (xfs_attr_get(XFS_I(inode), name, NULL, &len,
 			    ATTR_ROOT|ATTR_KERNOVAL) == 0);
@@ -379,7 +384,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
 		goto out_release;
 
 	error = -EINVAL;
-	if (acl->a_count > XFS_ACL_MAX_ENTRIES)
+	if (acl->a_count > XFS_ACL_MAX_ENTRIES(XFS_M(inode->i_sb)))
 		goto out_release;
 
 	if (type == ACL_TYPE_ACCESS) {
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 39632d9..4016a56 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -22,19 +22,36 @@ struct inode;
 struct posix_acl;
 struct xfs_inode;
 
-#define XFS_ACL_MAX_ENTRIES 25
 #define XFS_ACL_NOT_PRESENT (-1)
 
 /* On-disk XFS access control list structure */
+struct xfs_acl_entry {
+	__be32	ae_tag;
+	__be32	ae_id;
+	__be16	ae_perm;
+	__be16	ae_pad;		/* fill the implicit hole in the structure */
+};
+
 struct xfs_acl {
-	__be32		acl_cnt;
-	struct xfs_acl_entry {
-		__be32	ae_tag;
-		__be32	ae_id;
-		__be16	ae_perm;
-	} acl_entry[XFS_ACL_MAX_ENTRIES];
+	__be32			acl_cnt;
+	struct xfs_acl_entry	acl_entry[0];
 };
 
+/*
+ * The number of ACL entries allowed is defined by the on-disk format.
+ * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
+ * limited only by the maximum size of the xattr that stores the information.
+ */
+#define XFS_ACL_MAX_ENTRIES(mp)	\
+	(xfs_sb_version_hascrc(&mp->m_sb) \
+		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
+						sizeof(struct xfs_acl_entry) \
+		: 25)
+
+#define XFS_ACL_MAX_SIZE(mp) \
+	(sizeof(struct xfs_acl) + \
+		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
+
 /* On-disk XFS extended attribute names */
 #define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
 #define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
