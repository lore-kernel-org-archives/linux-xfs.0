Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:27:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QXnX006082
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:37 -0700
Message-Id: <20080402062708.071715758@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:10 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 2/7] XFS: ASCII case-insensitive support
Content-Disposition: inline; filename=ascii_ci.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Implement ASCII case-insensitive support. It's primary purpose 
is for supporting existing filesystems that already use this
case-insensitive mode migrated from IRIX. But, if you only need
ASCII-only case-insensitive support (ie. English only) and will
never use another language, then this mode is perfectly adequate.

ASCII-CI is implemented by generating hashes based on lower-case
letters and doing lower-case compares. It implements a new
xfs_nameops vector for doing the hashes and comparisons for
all filename operations.

It also overrides the Linux dentry cache operations with its
own hash and compare functions (the same as used in the xfs_nameops
vector).

To create a filesystem with this CI mode, use:
# mkfs.xfs -n version=ci <device>

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/linux-2.6/xfs_iops.c  |   46 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_linux.h |    1
 fs/xfs/linux-2.6/xfs_super.c |    4 +++
 fs/xfs/xfs_dir2.c            |   52 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fs.h              |    1
 fs/xfs/linux-2.6/xfs_iops.c  |   46 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_linux.h |    1 
 fs/xfs/linux-2.6/xfs_super.c |    4 +++
 fs/xfs/xfs_dir2.c            |   52 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fs.h              |    1 
 fs/xfs/xfs_fsops.c           |    4 ++-
 fs/xfs/xfs_sb.h              |   10 +++++++-
 7 files changed, 114 insertions(+), 4 deletions(-)

Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -47,6 +47,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_da_btree.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -54,6 +55,8 @@
 #include <linux/security.h>
 #include <linux/falloc.h>
 
+struct dentry_operations xfs_ci_dentry_operations;
+
 /*
  * Bring the atime in the XFS inode uptodate.
  * Used before logging the inode to disk or when the Linux inode goes away.
@@ -372,10 +375,15 @@ xfs_vn_lookup(
 {
 	struct xfs_inode *cip;
 	int		error;
+	struct xfs_mount *mp = XFS_I(dir)->i_mount;
+	struct dentry	*result;
 
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
+	if (xfs_sb_version_hasoldci(&mp->m_sb))
+		dentry->d_op = &xfs_ci_dentry_operations;
+
 	error = xfs_lookup(XFS_I(dir), dentry, &cip);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
@@ -384,7 +392,10 @@ xfs_vn_lookup(
 		return NULL;
 	}
 
-	return d_splice_alias(cip->i_vnode, dentry);
+	result = d_splice_alias(cip->i_vnode, dentry);
+	if (result)
+		result->d_op = dentry->d_op;
+	return result;
 }
 
 STATIC int
@@ -887,3 +898,36 @@ const struct inode_operations xfs_symlin
 	.listxattr		= xfs_vn_listxattr,
 	.removexattr		= xfs_vn_removexattr,
 };
+
+STATIC int
+xfs_ci_dentry_hash(
+	struct dentry	*dir,
+	struct qstr	*this)
+{
+	this->hash = xfs_dir_hashname(XFS_I(dir->d_inode),
+				this->name, this->len);
+	return 0;
+}
+
+STATIC int
+xfs_ci_dentry_compare(
+	struct dentry	*dir,
+	struct qstr	*a,
+	struct qstr	*b)
+{
+	int	result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
+					b->name, b->len) == XFS_CMP_DIFFERENT;
+	/*
+	 * result == 0 if a match is found, and if so, copy the name in "b"
+	 * to "a" to cope with negative dentries getting the correct name.
+	 */
+	if (result == 0)
+		memcpy((unsigned char *)a->name, b->name, a->len);
+	return result;
+}
+
+struct dentry_operations xfs_ci_dentry_operations =
+{
+	.d_hash = xfs_ci_dentry_hash,
+	.d_compare = xfs_ci_dentry_compare,
+};
Index: kern_ci/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_linux.h
@@ -75,6 +75,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/spinlock.h>
+#include <linux/ctype.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
@@ -67,6 +67,8 @@ static kmem_zone_t *xfs_vnode_zone;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
+extern struct dentry_operations xfs_ci_dentry_operations;
+
 STATIC struct xfs_mount_args *
 xfs_args_allocate(
 	struct super_block	*sb,
@@ -1359,6 +1361,8 @@ xfs_fs_fill_super(
 		error = ENOMEM;
 		goto fail_vnrele;
 	}
+	if (xfs_sb_version_hasoldci(&mp->m_sb))
+		sb->s_root->d_op = &xfs_ci_dentry_operations;
 
 	mp->m_sync_work.w_syncer = xfs_sync_worker;
 	mp->m_sync_work.w_mount = mp;
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -45,6 +45,55 @@
 #include "xfs_vnodeops.h"
 
 
+/*
+ * V1/OLDCI case-insensitive support for directories
+ *
+ * This is ASCII only case support, ie. A-Z.
+ */
+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	const uchar_t	*name,
+	int		namelen)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i = 0, hash = 0; i < namelen; i++)
+		hash = tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static xfs_dacmp_t
+xfs_ascii_ci_compname(
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	xfs_dacmp_t	result;
+	int		i;
+
+	if (len1 != len2)
+		return XFS_CMP_DIFFERENT;
+
+	result = XFS_CMP_EXACT;
+	for (i = 0; i < len1; i++) {
+		if (name1[i] == name2[i])
+			continue;
+		if (tolower(name1[i]) != tolower(name2[i]))
+			return XFS_CMP_DIFFERENT;
+		result = XFS_CMP_CASE;
+	}
+
+	return result;
+}
+
+static struct xfs_nameops xfs_ascii_ci_nameops = {
+	.hashname	= xfs_ascii_ci_hashname,
+	.compname	= xfs_ascii_ci_compname,
+};
+
 void
 xfs_dir_mount(
 	xfs_mount_t	*mp)
@@ -64,7 +113,8 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
-	mp->m_dirnameops = &xfs_default_nameops;
+	mp->m_dirnameops = xfs_sb_version_hasoldci(&mp->m_sb) ?
+		&xfs_ascii_ci_nameops : &xfs_default_nameops;
 }
 
 /*
Index: kern_ci/fs/xfs/xfs_fs.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_fs.h
+++ kern_ci/fs/xfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 
 
Index: kern_ci/fs/xfs/xfs_fsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_fsops.c
+++ kern_ci/fs/xfs/xfs_fsops.c
@@ -95,6 +95,8 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_DIRV2 : 0) |
 			(xfs_sb_version_hassector(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
+			(xfs_sb_version_hasoldci(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_DIRV2CI : 0) |
 			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
 			(xfs_sb_version_hasattr2(&mp->m_sb) ?
@@ -629,7 +631,7 @@ xfs_fs_goingdown(
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 			thaw_bdev(sb->s_bdev, sb);
 		}
-	
+
 		break;
 	}
 	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
Index: kern_ci/fs/xfs/xfs_sb.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_sb.h
+++ kern_ci/fs/xfs/xfs_sb.h
@@ -46,10 +46,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION_SECTORBIT	0x0800
 #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
 #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define XFS_SB_VERSION_OLDCIBIT		0x4000	/* ASCII only case-insens. */
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 #define	XFS_SB_VERSION_OKSASHFBITS	\
 	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_OLDCIBIT)
 #define	XFS_SB_VERSION_OKREALFBITS	\
 	(XFS_SB_VERSION_ATTRBIT | \
 	 XFS_SB_VERSION_NLINKBIT | \
@@ -436,6 +438,12 @@ static inline int xfs_sb_version_hassect
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
+static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);
+}
+
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \

-- 
