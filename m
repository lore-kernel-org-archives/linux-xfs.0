Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 00:54:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E7sV5V029057
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 00:54:35 -0700
Message-Id: <20080514075517.356633290@chook.melbourne.sgi.com>
References: <20080514075244.738514733@chook.melbourne.sgi.com>
Date: Wed, 14 May 2008 17:52:48 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 4/4] XFS: ASCII case-insensitive support
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

To create a filesystem with this CI mode, use:
# mkfs.xfs -n version=ci <device>

Signed-off-by: Barry Naujok <bnaujok@sgi.com>


---
 fs/xfs/linux-2.6/xfs_linux.h |    1 
 fs/xfs/linux-2.6/xfs_super.c |    5 +++-
 fs/xfs/xfs_dir2.c            |   51 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fs.h              |    1 
 fs/xfs/xfs_fsops.c           |    4 ++-
 fs/xfs/xfs_sb.h              |   10 +++++++-
 6 files changed, 68 insertions(+), 4 deletions(-)

Index: kern_ci/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_linux.h
@@ -76,6 +76,7 @@
 #include <linux/log2.h>
 #include <linux/spinlock.h>
 #include <linux/random.h>
+#include <linux/ctype.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
@@ -565,7 +565,10 @@ xfs_set_inodeops(
 		inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		inode->i_op = &xfs_dir_inode_operations;
+		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+			inode->i_op = &xfs_dir_ci_inode_operations;
+		else
+			inode->i_op = &xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -48,6 +48,52 @@ struct xfs_name xfs_name_dotdot = {"..",
 
 extern const struct xfs_nameops xfs_default_nameops;
 
+/*
+ * ASCII case-insensitive (ie. A-Z) support for directories that was
+ * used in IRIX.
+ */
+STATIC xfs_dahash_t
+xfs_ascii_ci_hashname(
+	struct xfs_name	*name)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i = 0, hash = 0; i < name->len; i++)
+		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+STATIC enum xfs_dacmp
+xfs_ascii_ci_compname(
+	struct xfs_da_args *args,
+	const char	*name,
+	int 		len)
+{
+	enum xfs_dacmp	result;
+	int		i;
+
+	if (args->namelen != len)
+		return XFS_CMP_DIFFERENT;
+
+	result = XFS_CMP_EXACT;
+	for (i = 0; i < len; i++) {
+		if (args->name[i] == name[i])
+			continue;
+		if (tolower(args->name[i]) != tolower(name[i]))
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
@@ -67,7 +113,10 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
-	mp->m_dirnameops = &xfs_default_nameops;
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
+		mp->m_dirnameops = &xfs_ascii_ci_nameops;
+	else
+		mp->m_dirnameops = &xfs_default_nameops;
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
+			(xfs_sb_version_hasasciici(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_DIRV2CI : 0) |
 			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
 			(xfs_sb_version_hasattr2(&mp->m_sb) ?
@@ -625,7 +627,7 @@ xfs_fs_goingdown(
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
+#define	XFS_SB_VERSION_BORGBIT		0x4000	/* ASCII only case-insens. */
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 #define	XFS_SB_VERSION_OKSASHFBITS	\
 	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_BORGBIT)
 #define	XFS_SB_VERSION_OKREALFBITS	\
 	(XFS_SB_VERSION_ATTRBIT | \
 	 XFS_SB_VERSION_NLINKBIT | \
@@ -437,6 +439,12 @@ static inline int xfs_sb_version_hassect
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
+static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
+		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
+}
+
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \

-- 
