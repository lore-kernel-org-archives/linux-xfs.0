Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10C817EFD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D84928F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FiFCz6dALNEUpJak (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:00 -0700 (PDT)
Subject: [PATCH 07/25] xfs: create an ioctl to scrub AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:57 -0700
Message-ID: <147216845703.3108.9850206520479318952.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create an ioctl that can be used to scrub internal filesystem
metadata.  The new ioctl takes the metadata type, an (optional)
AG number, and a flags argument.  This will be used by the
upcoming XFS online scrub tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   16 ++++++++++++++++
 fs/xfs/xfs_ioctl.c     |   20 ++++++++++++++++++++
 fs/xfs/xfs_scrub.c     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_scrub.h     |    2 +-
 4 files changed, 81 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 58e14b14e..22559ab 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -524,6 +524,21 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
+/* metadata scrubbing */
+struct xfs_scrub_metadata {
+	__u32 type;		/* What to check? */
+	__u32 flags;		/* Flags; none defined right now. */
+	__u64 control;		/* AG or inode number */
+	__u64 reserved[6];	/* Must be zero. */
+};
+
+/*
+ * Metadata types and flags for scrub operation.
+ */
+#define XFS_SCRUB_TYPE_MAX	0
+
+#define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
+
 /*
  * ioctl limits
  */
@@ -567,6 +582,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 #define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct getfsmap)
+#define XFS_IOC_SCRUB_METADATA	_IOR ('X', 60, struct xfs_scrub_metadata)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 936cb45..65f0c03 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 #include "xfs_reflink.h"
 #include "xfs_btree.h"
 #include "xfs_fsmap.h"
+#include "xfs_scrub.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1686,6 +1687,22 @@ xfs_ioc_getfsmap(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_scrub_metadata(
+	struct xfs_inode		*ip,
+	void				__user *arg)
+{
+	struct xfs_scrub_metadata	scrub;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&scrub, arg, sizeof(scrub)))
+		return -EFAULT;
+
+	return xfs_scrub_metadata(ip, &scrub);
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1871,6 +1888,9 @@ xfs_file_ioctl(
 			return -EPERM;
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUB_METADATA:
+		return xfs_ioc_scrub_metadata(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 13bea55..fd24af7 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -703,3 +703,47 @@ out:
 out_badcursor:
 	return error;
 }
+
+/* Scrubbing dispatch. */
+
+struct xfs_scrub_meta_fns {
+	int	(*scrub_fn)(struct xfs_inode *, struct xfs_scrub_metadata *);
+	bool	(*has_fn)(struct xfs_sb *);
+};
+
+static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
+};
+
+/* Dispatch metadata scrubbing. */
+int
+xfs_scrub_metadata(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	const struct xfs_scrub_meta_fns	*fns;
+	int				i;
+	int				error = 0;
+
+	trace_xfs_scrub(ip, sm->type, sm->control, sm->flags, error);
+
+	error = -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(sm->reserved); i++)
+		if (sm->reserved[i])
+			goto out;
+	if (sm->type > XFS_SCRUB_TYPE_MAX)
+		goto out;
+	if (sm->flags & ~XFS_SCRUB_FLAGS_ALL)
+		goto out;
+
+	fns = &meta_scrub_fns[sm->type];
+	if (fns->has_fn && !fns->has_fn(&mp->m_sb)) {
+		error = -ENOENT;
+		goto out;
+	}
+	error = fns->scrub_fn(ip, sm);
+
+out:
+	trace_xfs_scrub_done(ip, sm->type, sm->control, sm->flags, error);
+	return error;
+}
diff --git a/fs/xfs/xfs_scrub.h b/fs/xfs/xfs_scrub.h
index 474df7e..f4bb021 100644
--- a/fs/xfs/xfs_scrub.h
+++ b/fs/xfs/xfs_scrub.h
@@ -20,6 +20,6 @@
 #ifndef __XFS_SCRUB_H__
 #define __XFS_SCRUB_H__
 
-/* Functions to come later. */
+int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
 
 #endif	/* __XFS_SCRUB_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
