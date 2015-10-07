Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A977C29DF6
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 06:11:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 937088F8033
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 04:11:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nGlKM3Uj6ioxzd6Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 04:11:06 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 23D7A319AD1
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 11:11:06 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2] xfs: avoid dependency on Linux XATTR_SIZE_MAX
Date: Wed,  7 Oct 2015 13:11:02 +0200
Message-Id: <1444216262-6409-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1444216071-6281-1-git-send-email-jtulak@redhat.com>
References: <1444216071-6281-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Currently, we depends on Linux XATTR value for on disk
definition. Which causes trouble on other platforms and
maybe also if this value was to change.

Fix it by creating a custom definition independent from
those in Linux (although with the same values), so it is OK
with the be16 fields used for holding these attributes.

This patch reflects a change in xfsprogs.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/xfs_ioctl.c              |  4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index f38f9bd..5ab95ff 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -107,7 +107,7 @@ xfs_attr3_rmt_verify(
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)
+				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9590a06..8568de1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -60,6 +60,14 @@ struct xfs_ifork;
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 
 /*
+ * The size of a single extended attribute on disk is limited by
+ * the size of index values within the attribute entries themselves.
+ * These are be16 fields, so we can only support attribute data
+ * sizes up to 2^16 bytes in length.
+ */
+#define XFS_XATTR_SIZE_MAX (1 << 16)
+
+/*
  * Supported feature bit list is just all bits in the versionnum field because
  * we've used them all up and understand them all. Except, of course, for the
  * shared superblock bit, which nobody knows what it does and so is unsupported.
@@ -1483,7 +1491,7 @@ struct xfs_acl {
  */
 #define XFS_ACL_MAX_ENTRIES(mp)	\
 	(xfs_sb_version_hascrc(&mp->m_sb) \
-		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
+		?  (XFS_XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
 						sizeof(struct xfs_acl_entry) \
 		: 25)
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e692a6..9963f7c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -455,7 +455,7 @@ xfs_attrmulti_attr_get(
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
 
-	if (*len > XATTR_SIZE_MAX)
+	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
 	kbuf = kmem_zalloc_large(*len, KM_SLEEP);
 	if (!kbuf)
@@ -485,7 +485,7 @@ xfs_attrmulti_attr_set(
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	if (len > XATTR_SIZE_MAX)
+	if (len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
 
 	kbuf = memdup_user(ubuf, len);
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
