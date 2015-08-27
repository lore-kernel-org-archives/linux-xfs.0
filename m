Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E77C7F37
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 01:02:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4009A8F8033
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 23:02:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mUtdgyyG9DHpDLNC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 23:02:27 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 02/11] xfsprogs: avoid dependency on linux XATTR_SIZE/LIST_MAX
Date: Thu, 27 Aug 2015 08:02:20 +0200
Message-Id: <1440655340-27550-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-2-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-2-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Currently, we depends on Linux XATTR values for on disk
definitions. Which causes trouble on other platforms and
maybe also if these values were to change.

Fix it by creating a custom definition independent from
those in Linux (although with the same values).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libhandle/handle.c       |  6 ++++--
 libhandle/jdm.c          |  6 ++++--
 libxfs/xfs_attr_remote.c |  2 +-
 libxfs/xfs_format.h      | 11 ++++++++++-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index b1c0c10..d532f44 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -21,6 +21,8 @@
 #include "xfs.h"
 #include "handle.h"
 #include "parent.h"
+#include "xfs/xfs_arch.h"
+#include "xfs/xfs_format.h"
 
 /* just pick a value we know is more than big enough */
 #define	MAXHANSIZ	64
@@ -397,8 +399,8 @@ attr_list_by_handle(
 	alhreq.buffer = buf;
 	alhreq.buflen = bufsize;
 	/* prevent needless EINVAL from the kernel */
-	if (alhreq.buflen > XATTR_LIST_MAX)
-		alhreq.buflen = XATTR_LIST_MAX;
+	if (alhreq.buflen > XFS_XATTR_LIST_MAX)
+		alhreq.buflen = XFS_XATTR_LIST_MAX;
 
 	error = xfsctl(path, fd, XFS_IOC_ATTRLIST_BY_HANDLE, &alhreq);
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index d804423..db7d1fe 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -21,6 +21,8 @@
 #include "handle.h"
 #include "jdm.h"
 #include "parent.h"
+#include "xfs/xfs_arch.h"
+#include "xfs/xfs_format.h"
 
 /* internal fshandle - typecast to a void for external use */
 #define FSHANDLE_SZ		8
@@ -168,8 +170,8 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	int rval;
 
 	/* prevent needless EINVAL from the kernel */
-	if (bufsz > XATTR_LIST_MAX)
-		bufsz = XATTR_LIST_MAX;
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
 
 	jdm_fill_filehandle( &filehandle, fshandlep, statp );
 	rval = attr_list_by_handle (( void * )&filehandle,
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5feaf55..98893e2 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -102,7 +102,7 @@ xfs_attr3_rmt_verify(
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
-				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)
+				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
 		return false;
 	if (rmt->rm_owner == 0)
 		return false;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index bb7cc04..2380084 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -60,6 +60,14 @@ struct xfs_ifork;
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 
 /*
+ * Avoid dependency on linux values of XATTR.
+ * It has to be on the beginning of this file, because we use these Values
+ * later in this header file.
+ */
+#define XFS_XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
+#define XFS_XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */
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
 
@@ -1497,4 +1505,5 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+
 #endif /* __XFS_FORMAT_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
