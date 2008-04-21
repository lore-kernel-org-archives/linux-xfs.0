Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:36:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L8a5pi025353
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:36:08 -0700
Message-Id: <20080421083645.799556386@chook.melbourne.sgi.com>
References: <20080421083103.433280025@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 18:31:07 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 4/4] XFS: Unicode case-insensitive lookup implementation
Content-Disposition: inline; filename=unicode_ci.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This is the core of the case-insensitive support - supporting and
enforcing UTF-8 (Unicode) filenames. All filename and user-level
extended attribute names are checked for UTF-8 compliance and the
hashes generated are always case-insensitive by utilising the
Unicode 5.0 standard case-folding table from:
http://www.unicode.org/Public/UNIDATA/CaseFolding.txt

As the hash is always case-insensitive, this allows the user to
mkfs.xfs the filesystem once and enable or disable (default)
case-insensitive support by a mount option "-o ci". The mount
option specifies which xfs_nameops.compname function to use.

Also, the Unicode support is a CONFIG option so users who do
not required this functionality can CONFIG it to N.

As the case-folding table is stored on disk, this allows
backwards and forwards compatibility and languages like Turkic
to support true case-insensitivity with I and i.

To create a Unicode filesystem with case-insensitive mount
support, run:
# mkfs.xfs -n utf8[=default|turkic] <device>

A following patch will implement Linux NLS support for XFS Unicode.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/Kconfig               |   20 +
 fs/xfs/Makefile              |    4 
 fs/xfs/linux-2.6/xfs_iops.c  |   48 ++-
 fs/xfs/linux-2.6/xfs_linux.h |    1 
 fs/xfs/linux-2.6/xfs_super.c |    6 
 fs/xfs/linux-2.6/xfs_super.h |    7 
 fs/xfs/xfs_attr.c            |   15 -
 fs/xfs/xfs_clnt.h            |    2 
 fs/xfs/xfs_da_btree.c        |   24 +
 fs/xfs/xfs_da_btree.h        |   14 -
 fs/xfs/xfs_dir2.c            |   32 +-
 fs/xfs/xfs_dir2_block.c      |    4 
 fs/xfs/xfs_dir2_leaf.c       |    2 
 fs/xfs/xfs_dir2_node.c       |    2 
 fs/xfs/xfs_dir2_sf.c         |    2 
 fs/xfs/xfs_fs.h              |   27 +
 fs/xfs/xfs_fsops.c           |    4 
 fs/xfs/xfs_itable.c          |    2 
 fs/xfs/xfs_mount.c           |   37 ++
 fs/xfs/xfs_mount.h           |    5 
 fs/xfs/xfs_sb.h              |   23 +
 fs/xfs/xfs_unicode.c         |  584 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_unicode.h         |   78 +++++
 fs/xfs/xfs_vfsops.c          |   15 +
 24 files changed, 886 insertions(+), 72 deletions(-)

Index: kern_ci/fs/xfs/Kconfig
===================================================================
--- kern_ci.orig/fs/xfs/Kconfig
+++ kern_ci/fs/xfs/Kconfig
@@ -60,6 +60,24 @@ config XFS_POSIX_ACL
 
 	  If you don't know what Access Control Lists are, say N.
 
+config XFS_UNICODE
+	bool "XFS Unicode support"
+	depends on XFS_FS
+	help
+	  Unicode support enforces UTF-8 filenames and user extended
+	  attribute names. This option is required for filesystems
+	  mkfs'ed with UTF-8 support. A Unicode filesystem guarantees
+	  that filenames will be the same regardless of the user's
+	  locale. For UTF-8 locales, no conversion is required.
+
+	  Unicode filesystems also allow the filesystem to be mounted with
+	  case-insensitive lookup support with the "-o ci" mount option.
+
+	  Note: Unicode UTF-8 enforcement, like case-insensitive lookup,
+	  is not POSIX compliant.
+
+	  If you don't require UTF-8 enforcement, say N.
+
 config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
@@ -95,7 +113,7 @@ config XFS_TRACE
 	bool "XFS Tracing support (EXPERIMENTAL)"
 	depends on XFS_FS && EXPERIMENTAL
 	help
-	  Say Y here to get an XFS build with activity tracing enabled.	
+	  Say Y here to get an XFS build with activity tracing enabled.
 	  Enabling this option will attach historical information to XFS
 	  inodes, buffers, certain locks, the log, the IO path, and a
 	  few other key areas within XFS.  These traces can be examined
Index: kern_ci/fs/xfs/Makefile
===================================================================
--- kern_ci.orig/fs/xfs/Makefile
+++ kern_ci/fs/xfs/Makefile
@@ -30,11 +30,11 @@ obj-$(CONFIG_XFS_DMAPI)		+= dmapi/
 
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
+xfs-$(CONFIG_XFS_UNICODE)	+= xfs_unicode.o
 xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
 xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
 
-
 xfs-y				+= xfs_alloc.o \
 				   xfs_alloc_btree.o \
 				   xfs_attr.o \
@@ -97,7 +97,7 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   xfs_lrw.o \
 				   xfs_super.o \
 				   xfs_vnode.o \
-				   xfs_ksyms.o) 
+				   xfs_ksyms.o)
 
 # Objects in support/
 xfs-y				+= $(addprefix support/, \
Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -49,6 +49,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_unicode.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -241,13 +242,18 @@ xfs_init_security(
 	return error;
 }
 
-static void
+static int
 xfs_dentry_to_name(
+	struct inode	*dir,
 	struct xfs_name	*namep,
 	struct dentry	*dentry)
 {
 	namep->name = dentry->d_name.name;
 	namep->len = dentry->d_name.len;
+
+	if (xfs_sb_version_hasunicode(&XFS_M(dir->i_sb)->m_sb))
+		return xfs_unicode_validate(namep);
+	return 0;
 }
 
 STATIC void
@@ -264,7 +270,7 @@ xfs_cleanup_inode(
 	 * xfs_init_security we must back out.
 	 * ENOSPC can hit here, among other things.
 	 */
-	xfs_dentry_to_name(&teardown, dentry);
+	xfs_dentry_to_name(dir, &teardown, dentry);
 
 	if (S_ISDIR(mode))
 		xfs_rmdir(XFS_I(dir), &teardown, XFS_I(inode));
@@ -304,7 +310,9 @@ xfs_vn_mknod(
 		}
 	}
 
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		goto out_free_acl;
 
 	if (IS_POSIXACL(dir) && !default_acl)
 		mode &= ~current->fs->umask;
@@ -390,7 +398,10 @@ xfs_vn_lookup(
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		return ERR_PTR(-error);
+
 	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
@@ -516,7 +527,10 @@ xfs_vn_ci_lookup(
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		return ERR_PTR(-error);
+
 	error = xfs_lookup(XFS_I(dir), &name, &ip, &ci_match);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
@@ -546,7 +560,9 @@ xfs_vn_link(
 	int		error;
 
 	inode = old_dentry->d_inode;
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		return -error;
 
 	igrab(inode);
 	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
@@ -571,7 +587,9 @@ xfs_vn_unlink(
 	int		error;
 
 	inode = dentry->d_inode;
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		return -error;
 
 	error = xfs_remove(XFS_I(dir), &name, XFS_I(inode));
 	if (likely(!error)) {
@@ -595,7 +613,9 @@ xfs_vn_symlink(
 
 	mode = S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		goto out;
 
 	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip, NULL);
 	if (unlikely(error))
@@ -627,7 +647,9 @@ xfs_vn_rmdir(
 	struct xfs_name	name;
 	int		error;
 
-	xfs_dentry_to_name(&name, dentry);
+	error = xfs_dentry_to_name(dir, &name, dentry);
+	if (unlikely(error))
+		return -error;
 
 	error = xfs_rmdir(XFS_I(dir), &name, XFS_I(inode));
 	if (likely(!error)) {
@@ -649,8 +671,12 @@ xfs_vn_rename(
 	struct xfs_name	nname;
 	int		error;
 
-	xfs_dentry_to_name(&oname, odentry);
-	xfs_dentry_to_name(&nname, ndentry);
+	error = xfs_dentry_to_name(odir, &oname, odentry);
+	if (unlikely(error))
+		return -error;
+	error = xfs_dentry_to_name(ndir, &nname, ndentry);
+	if (unlikely(error))
+		return -error;
 
 	error = xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			   XFS_I(ndir), &nname, new_inode ?
Index: kern_ci/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_linux.h
@@ -76,6 +76,7 @@
 #include <linux/log2.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
+#include <linux/nls.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
@@ -124,6 +124,7 @@ xfs_args_allocate(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir lookup */
 #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
 #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
 #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
@@ -318,6 +319,8 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
+			args->flags2 |= XFSMNT2_CILOOKUP;
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
 			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
 			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
@@ -458,6 +461,7 @@ xfs_showargs(
 		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
 		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_CILOOKUP,		"," MNTOPT_CILOOKUP },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ 0, NULL }
@@ -566,7 +570,7 @@ xfs_set_inodeops(
 		inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		if (xfs_sb_version_hasoldci(&XFS_M(inode->i_sb)->m_sb))
+		if (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_CILOOKUP)
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.h
@@ -30,6 +30,12 @@
 
 #define XFS_SECURITY_STRING	"security attributes, "
 
+#ifdef CONFIG_XFS_UNICODE
+# define XFS_UNICODE_STRING	"Unicode, "
+#else
+# define XFS_UNICODE_STRING
+#endif
+
 #ifdef CONFIG_XFS_RT
 # define XFS_REALTIME_STRING	"realtime, "
 #else
@@ -60,6 +66,7 @@
 
 #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
 				XFS_SECURITY_STRING \
+				XFS_UNICODE_STRING \
 				XFS_REALTIME_STRING \
 				XFS_BIGFS_STRING \
 				XFS_TRACE_STRING \
Index: kern_ci/fs/xfs/xfs_attr.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr.c
+++ kern_ci/fs/xfs/xfs_attr.c
@@ -50,6 +50,7 @@
 #include "xfs_acl.h"
 #include "xfs_rw.h"
 #include "xfs_vnodeops.h"
+#include "xfs_unicode.h"
 
 /*
  * xfs_attr.c
@@ -104,7 +105,9 @@ ktrace_t *xfs_attr_trace_buf;
 STATIC int
 xfs_attr_name_to_xname(
 	struct xfs_name	*xname,
-	const char	*aname)
+	const char	*aname,
+	xfs_inode_t	*ip,
+	int		flags)
 {
 	if (!aname)
 		return EINVAL;
@@ -113,6 +116,10 @@ xfs_attr_name_to_xname(
 	if (xname->len >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	/* only enforce unicode on user namespace attr names */
+	if (xfs_sb_version_hasunicode(&ip->i_mount->m_sb) &&
+				(flags & (ATTR_ROOT | ATTR_SECURE)) == 0)
+		return xfs_unicode_validate(xname);
 	return 0;
 }
 
@@ -186,7 +193,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return(EIO);
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_name_to_xname(&xname, name, ip, flags);
 	if (error)
 		return error;
 
@@ -449,7 +456,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_name_to_xname(&xname, name, dp, flags);
 	if (error)
 		return error;
 
@@ -596,7 +603,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
-	error = xfs_attr_name_to_xname(&xname, name);
+	error = xfs_attr_name_to_xname(&xname, name, dp, flags);
 	if (error)
 		return error;
 
Index: kern_ci/fs/xfs/xfs_clnt.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_clnt.h
+++ kern_ci/fs/xfs/xfs_clnt.h
@@ -100,5 +100,7 @@ struct xfs_mount_args {
 						 * I/O size in stat(2) */
 #define XFSMNT2_FILESTREAMS	0x00000002	/* enable the filestreams
 						 * allocator */
+#define XFSMNT2_CILOOKUP	0x00000004	/* enable case-insensitive
+						 * filename lookup */
 
 #endif	/* __XFS_CLNT_H__ */
Index: kern_ci/fs/xfs/xfs_da_btree.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.c
+++ kern_ci/fs/xfs/xfs_da_btree.c
@@ -1530,23 +1530,29 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
 
-xfs_dacmp_t
-xfs_da_compname(const char *name1, int len1, const char *name2, int len2)
-{
-	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
-					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
-}
-
-static xfs_dahash_t
+STATIC xfs_dahash_t
 xfs_default_hashname(
+	struct xfs_inode *inode,
 	struct xfs_name	*name)
 {
 	return xfs_da_hashname(name->name, name->len);
 }
 
+STATIC xfs_dacmp_t
+xfs_default_compname(
+	struct xfs_inode *inode,
+	const char	*name1,
+	int		len1,
+	const char	*name2,
+	int		len2)
+{
+	return xfs_da_compname(name1, len1, name2, len2);
+}
+
+
 const struct xfs_nameops xfs_default_nameops = {
 	.hashname	= xfs_default_hashname,
-	.compname	= xfs_da_compname
+	.compname	= xfs_default_compname
 };
 
 /*
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -215,8 +215,9 @@ typedef struct xfs_da_state {
  * Name ops for directory and/or attr name operations
  */
 struct xfs_nameops {
-	xfs_dahash_t	(*hashname)(struct xfs_name *);
-	xfs_dacmp_t	(*compname)(const char *, int, const char *, int);
+	xfs_dahash_t	(*hashname)(struct xfs_inode *, struct xfs_name *);
+	xfs_dacmp_t	(*compname)(struct xfs_inode *, const char *, int,
+							const char *, int);
 };
 
 
@@ -267,8 +268,13 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
 					  xfs_dabuf_t *dead_buf);
 
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
-xfs_dacmp_t xfs_da_compname(const char *name1, int len1,
-				const char *name2, int len2);
+
+static inline xfs_dacmp_t
+xfs_da_compname(const char *name1, int len1, const char *name2, int len2)
+{
+	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
+					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
 
 
 xfs_da_state_t *xfs_da_state_alloc(void);
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -43,12 +43,15 @@
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
+#include "xfs_unicode.h"
 
 struct xfs_name xfs_name_dotdot = {"..", 2};
 
 kmem_zone_t	*xfs_name_zone;
 
 extern const struct xfs_nameops xfs_default_nameops;
+extern const struct xfs_nameops xfs_unicode_nameops;
+extern const struct xfs_nameops xfs_unicode_ci_nameops;
 
 /*
  * V1/OLDCI case-insensitive support for directories that was used in IRIX.
@@ -57,6 +60,7 @@ extern const struct xfs_nameops xfs_defa
  */
 STATIC xfs_dahash_t
 xfs_ascii_ci_hashname(
+	struct xfs_inode *inode,
 	struct xfs_name	*name)
 {
 	xfs_dahash_t	hash;
@@ -70,6 +74,7 @@ xfs_ascii_ci_hashname(
 
 STATIC xfs_dacmp_t
 xfs_ascii_ci_compname(
+	struct xfs_inode *inode,
 	const char	*name1,
 	int		len1,
 	const char	*name2,
@@ -93,7 +98,7 @@ xfs_ascii_ci_compname(
 	return result;
 }
 
-static struct xfs_nameops xfs_ascii_ci_nameops = {
+static const struct xfs_nameops xfs_ascii_ci_nameops = {
 	.hashname	= xfs_ascii_ci_hashname,
 	.compname	= xfs_ascii_ci_compname,
 };
@@ -117,10 +122,17 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
-	if (xfs_sb_version_hasoldci(&mp->m_sb))
-		mp->m_dirnameops = &xfs_ascii_ci_nameops;
-	else
-		mp->m_dirnameops = &xfs_default_nameops;
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (mp->m_flags & XFS_MOUNT_CILOOKUP)
+			mp->m_dirnameops = &xfs_unicode_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_unicode_nameops;
+	} else {
+		if (mp->m_flags & XFS_MOUNT_CILOOKUP)
+			mp->m_dirnameops = &xfs_ascii_ci_nameops;
+		else
+			mp->m_dirnameops = &xfs_default_nameops;
+	}
 }
 
 /*
@@ -220,7 +232,7 @@ xfs_dir_createname(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(dp, name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -269,7 +281,7 @@ xfs_dir_lookup(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(dp, name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
@@ -332,7 +344,7 @@ xfs_dir_removename(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(dp, name);
 	args.inumber = ino;
 	args.dp = dp;
 	args.firstblock = first;
@@ -415,7 +427,7 @@ xfs_dir_replace(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(dp, name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -463,7 +475,7 @@ xfs_dir_canenter(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(dp, name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -709,7 +709,7 @@ xfs_dir2_block_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(dep->name, dep->namelen,
+		cmp = mp->m_dirnameops->compname(dp, dep->name, dep->namelen,
 						args->name, args->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
@@ -1211,7 +1211,7 @@ xfs_dir2_sf_to_block(
 		name.name = sfep->name;
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
-							hashname(&name));
+							hashname(dp, &name));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -1404,7 +1404,7 @@ xfs_dir2_leaf_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(dep->name, dep->namelen,
+		cmp = mp->m_dirnameops->compname(dp, dep->name, dep->namelen,
 						args->name, args->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -626,7 +626,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		 * EEXIST immediately. If it's the first case-insensitive
 		 * match, store the inode number and continue looking.
 		 */
-		cmp = mp->m_dirnameops->compname(dep->name, dep->namelen,
+		cmp = mp->m_dirnameops->compname(dp, dep->name, dep->namelen,
 						args->name, args->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -861,7 +861,7 @@ xfs_dir2_sf_lookup(
 		 * number. If it's the first case-insensitive match, store the
 		 * inode number and continue looking for an exact match.
 		 */
-		cmp = dp->i_mount->m_dirnameops->compname(
+		cmp = dp->i_mount->m_dirnameops->compname(dp,
 					sfep->name, sfep->namelen,
 					args->name, args->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
Index: kern_ci/fs/xfs/xfs_fs.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_fs.h
+++ kern_ci/fs/xfs/xfs_fs.h
@@ -228,19 +228,20 @@ typedef struct xfs_fsop_resblks {
 
 #define XFS_FSOP_GEOM_VERSION	0
 
-#define XFS_FSOP_GEOM_FLAGS_ATTR	0x0001	/* attributes in use	*/
-#define XFS_FSOP_GEOM_FLAGS_NLINK	0x0002	/* 32-bit nlink values	*/
-#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x0004	/* quotas enabled	*/
-#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x0008	/* inode alignment	*/
-#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x0010	/* large data alignment */
-#define XFS_FSOP_GEOM_FLAGS_SHARED	0x0020	/* read-only shared	*/
-#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x0040	/* special extent flag	*/
-#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x0080	/* directory version 2	*/
-#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
-#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
-#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
-#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
-#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_ATTR	0x00000001 /* attributes in use */
+#define XFS_FSOP_GEOM_FLAGS_NLINK	0x00000002 /* 32-bit nlink values */
+#define XFS_FSOP_GEOM_FLAGS_QUOTA	0x00000004 /* quotas enabled */
+#define XFS_FSOP_GEOM_FLAGS_IALIGN	0x00000008 /* inode alignment */
+#define XFS_FSOP_GEOM_FLAGS_DALIGN	0x00000010 /* large data alignment */
+#define XFS_FSOP_GEOM_FLAGS_SHARED	0x00000020 /* read-only shared */
+#define XFS_FSOP_GEOM_FLAGS_EXTFLG	0x00000040 /* special extent flag */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2	0x00000080 /* directory version 2 */
+#define XFS_FSOP_GEOM_FLAGS_LOGV2	0x00000100 /* log format version 2 */
+#define XFS_FSOP_GEOM_FLAGS_SECTOR	0x00000200 /* sector sizes >1BB */
+#define XFS_FSOP_GEOM_FLAGS_ATTR2	0x00000400 /* inline attr rework */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x00001000 /* ASCII only CI names */
+#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x00004000 /* lazy superblock cntrs */
+#define XFS_FSOP_GEOM_FLAGS_UNICODE	0x00010000 /* unicode filenames */
 
 
 /*
Index: kern_ci/fs/xfs/xfs_fsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_fsops.c
+++ kern_ci/fs/xfs/xfs_fsops.c
@@ -100,7 +100,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
 			(xfs_sb_version_hasattr2(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0);
+				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
+			(xfs_sb_version_hasunicode(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_UNICODE : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
Index: kern_ci/fs/xfs/xfs_itable.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_itable.c
+++ kern_ci/fs/xfs/xfs_itable.c
@@ -45,6 +45,8 @@ xfs_internal_inum(
 	xfs_ino_t	ino)
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
+		(xfs_sb_version_hasunicode(&mp->m_sb) &&
+		 ino == mp->m_sb.sb_cftino) ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
 		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
 }
Index: kern_ci/fs/xfs/xfs_mount.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_mount.c
+++ kern_ci/fs/xfs/xfs_mount.c
@@ -44,6 +44,7 @@
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
+#include "xfs_unicode.h"
 
 STATIC int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
@@ -121,6 +122,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_cftino),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -167,6 +169,7 @@ xfs_mount_free(
 			  sizeof(xfs_perag_t) * mp->m_sb.sb_agcount);
 	}
 
+	xfs_unicode_free_cft(mp->m_cft);
 	spinlock_destroy(&mp->m_ail_lock);
 	spinlock_destroy(&mp->m_sb_lock);
 	mutex_destroy(&mp->m_ilock);
@@ -320,7 +323,18 @@ xfs_mount_validate_sb(
 			PAGE_SIZE);
 		return XFS_ERROR(ENOSYS);
 	}
-
+#ifndef CONFIG_XFS_UNICODE
+	/*
+	 * If Unicode config is set to N, don't mount Unicode filesystems.
+	 */
+	if (xfs_sb_version_hasmorebits(sbp) &&
+			(sbp->sb_features2 & XFS_SB_VERSION2_UNICODEBIT)) {
+		xfs_fs_mount_cmn_err(flags,
+			"file system is marked as Unicode but support is "
+			"not enabled in the driver.");
+		return XFS_ERROR(ENOSYS);
+	}
+#endif
 	return 0;
 }
 
@@ -452,6 +466,7 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_cftino = be64_to_cpu(from->sb_cftino);
 }
 
 /*
@@ -1187,6 +1202,15 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Load in unicode case folding table from disk
+	 */
+	error = xfs_unicode_read_cft(mp);
+	if (error) {
+		cmn_err(CE_WARN, "XFS: failed to read case folding table");
+		goto error4;
+	}
+
+	/*
 	 * If fs is not mounted readonly, then update the superblock changes.
 	 */
 	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
@@ -1244,14 +1268,15 @@ xfs_mountfs(
 
 	return 0;
 
- error4:
+error4:
 	/*
 	 * Free up the root inode.
 	 */
 	IRELE(rip);
- error3:
+	xfs_unicode_free_cft(mp->m_cft);
+error3:
 	xfs_log_unmount_dealloc(mp);
- error2:
+error2:
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
 		if (mp->m_perag[agno].pagb_list)
 			kmem_free(mp->m_perag[agno].pagb_list,
@@ -1259,7 +1284,7 @@ xfs_mountfs(
 	kmem_free(mp->m_perag, sbp->sb_agcount * sizeof(xfs_perag_t));
 	mp->m_perag = NULL;
 	/* FALLTHROUGH */
- error1:
+error1:
 	if (uuid_mounted)
 		xfs_uuid_unmount(mp);
 	xfs_freesb(mp);
@@ -1985,7 +2010,7 @@ xfs_mount_log_sb(
  * 	3. accurate counter sync requires m_sb_lock + per cpu locks
  * 	4. modifying per-cpu counters requires holding per-cpu lock
  * 	5. modifying global counters requires holding m_sb_lock
- *	6. enabling or disabling a counter requires holding the m_sb_lock 
+ *	6. enabling or disabling a counter requires holding the m_sb_lock
  *	   and _none_ of the per-cpu locks.
  *
  * Disabled counters are only ever re-enabled by a balance operation
Index: kern_ci/fs/xfs/xfs_mount.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_mount.h
+++ kern_ci/fs/xfs/xfs_mount.h
@@ -62,6 +62,7 @@ struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
 struct xfs_nameops;
+struct xfs_cft;
 
 /*
  * Prototypes and functions for the Data Migration subsystem.
@@ -314,6 +315,7 @@ typedef struct xfs_mount {
 						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
+	struct xfs_cft		*m_cft;		/* unicode case folding table */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
@@ -379,7 +381,8 @@ typedef struct xfs_mount {
 						   counters */
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
-
+#define XFS_MOUNT_CILOOKUP	(1ULL << 25)	/* enable case-insensitive
+						   file lookup */
 
 /*
  * Default minimum read and write sizes.
Index: kern_ci/fs/xfs/xfs_sb.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_sb.h
+++ kern_ci/fs/xfs/xfs_sb.h
@@ -79,10 +79,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
-	 XFS_SB_VERSION2_ATTR2BIT)
+	 XFS_SB_VERSION2_ATTR2BIT	| \
+	 XFS_SB_VERSION2_UNICODEBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -156,6 +158,7 @@ typedef struct xfs_sb {
 	 * it for anything else.
 	 */
 	__uint32_t	sb_bad_features2;
+	xfs_ino_t	sb_cftino;	/* unicode case folding table inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -225,7 +228,8 @@ typedef struct xfs_dsb {
 	 * for features2 bits. Easiest just to mark it bad and not use
 	 * it for anything else.
 	 */
-	__be32	sb_bad_features2;
+	__be32		sb_bad_features2;
+	__be64		sb_cftino;	/* unicode case folding table inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -246,7 +250,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CFTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -272,6 +276,7 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_CFTINO		XFS_SB_MVAL(CFTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -279,7 +284,7 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_CFTINO)
 
 
 /*
@@ -481,6 +486,16 @@ static inline void xfs_sb_version_addatt
 		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
 }
 
+#ifdef CONFIG_XFS_UNICODE
+static inline int xfs_sb_version_hasunicode(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_UNICODEBIT));
+}
+#else
+static inline int xfs_sb_version_hasunicode(xfs_sb_t *sbp) { return 0; }
+#endif
+
 /*
  * end of superblock version macros
  */
Index: kern_ci/fs/xfs/xfs_unicode.c
===================================================================
--- /dev/null
+++ kern_ci/fs/xfs/xfs_unicode.c
@@ -0,0 +1,584 @@
+/*
+ * Copyright (c) 2007-2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_clnt.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_alloc.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_itable.h"
+#include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_bmap.h"
+#include "xfs_rw.h"
+#include "xfs_unicode.h"
+
+/*
+ * XFS Unicode performs case folding for hash generation for the on-disk
+ * directory information using the Unicode 5.0 standard locale independent
+ * case-folding table http://www.unicode.org/Public/UNIDATA/CaseFolding.txt
+ *
+ * More info also at http://unicode.org/reports/tr21/tr21-5.html
+ *
+ * XFS Unicode only supports the Basic Multilingual Plane (BMP) of the
+ * Unicode standard. The other planes currently are only used for
+ * ancient/obsolete languages and various symbols which aren't really
+ * appropriate for filenames (and it keeps the implementation simpler,
+ * especially as wchar_t can be only 2 bytes).
+ *
+ * As we don't need to map every character in the entire BMP, we map chunks
+ * in 256 character blobs that contain characters to be case-folded. At the
+ * moment, only 14 of these chunks have characters that are case-folded.
+ *
+ * So, the first 256 characters in table encodes the most significant byte
+ * to the folded character in the table. If it is zero, then there is no
+ * folding for that character.
+ *   -> folded char = table[table[char / 256] + char % 256]
+ *
+ * As this table uses a 1:n mapping for folding characters, and n is
+ * currently no more than 3, MAX_FOLD_CHARS is set to 4 to support minor
+ * changes to the table that may occur in future versions of unicode.
+ *
+ * As XFS Unicode only supports the BMP, UTF-16 surrogates U+D800 to U+DFFF
+ * are currently invalid, but reserved for possible support beyond the BMP.
+ * The private use area U+E000 to U+F8FF is also invalid for filenames.
+ *
+ * As U+E000 to U+F8FF will never be used for filenames, we can use the
+ * space from U+E000 to U+EFFF to refer to the 1:n mapping on-disk.
+ * So, this range on-disk is used to specify the addition multi-character
+ * case-folding conversions. Each value of "n" in the 1:n format can
+ * store up to 1024 sequences, and currently up to 4 tables. As mentioned
+ * above, only two additional tables currently exist - 1:2 and 1:3. The
+ * lower 10 bits is the index to the multi-character folding in each of
+ * these tables (byte index = (char & 0x3ff) * n * 2).
+ *
+ * So, in summary, the following Unicode ranges have special purposes:
+ *	U+D800 - U+DFFF : UTF-16 surrogates - unsupported
+ *	U+E000 - U+E3FF : index to a two character sequence
+ *	U+E400 - U+E7FF : index to a three character sequence
+ *	U+E800 - U+EBFF : index to a four character sequence (currently none)
+ *	U+EC00 - U+EFFF : index to a five character sequence (unsupported ATM)
+ *	U+F000 - U+F8FF : reserved for future use
+ *
+ * Like the other data structures in XFS, the 2-byte (UTF-16) casefolding
+ * characters are in big-endian format.
+ */
+
+#define CHARS_PER_CHUNK	256	/* table chunk size */
+
+#define MAX_FOLD_CHARS	4	/* maximum single sequence supported (1:n) */
+
+/* multi-character sequence encoding values */
+#define MC_MASK		0xf000	/* bits in character to test for MC sequence */
+#define MC_MAGIC	0xe000	/* if masked value is this, then MC sequence */
+#define MC_PER_TABLE	1024	/* max # of MC chars per sequence table */
+
+static __uint16_t *
+xfs_cft_ptr(
+	const struct xfs_cft *cft,
+	int	index)
+{
+	return (__uint16_t *)((char *)cft + cft->table_offset[index]);
+}
+
+/*
+ * xfs_casefold takes the 2-byte unicode character and converts it into a
+ * locale independent case folded character sequence. Returns the number of
+ * characters in the folded sequence.
+ */
+static int
+xfs_casefold(
+	const struct xfs_cft *cft,
+	__uint16_t	c,
+	__uint16_t	*fc)
+{
+	__uint16_t	*table = xfs_cft_ptr(cft, 0);
+	__uint16_t	tmp = table[c / CHARS_PER_CHUNK];
+	int		n;
+
+	if (!tmp) {	/* if no table index, no mapping */
+		*fc = c;
+		return 1;
+	}
+	tmp = table[tmp + c % CHARS_PER_CHUNK];
+	if ((tmp & MC_MASK) != MC_MAGIC) {
+		/* 1:1 character mapping if not U+Exxx */
+		*fc = tmp;
+		return 1;
+	}
+	/* 1:n character mapping if tmp is U+Exxx */
+	n = ((tmp & ~MC_MASK) / MC_PER_TABLE) + 2;
+	ASSERT(n < cft->num_tables);
+	table = xfs_cft_ptr(cft, n - 1) + ((tmp % MC_PER_TABLE) * n);
+
+	memcpy(fc, table, sizeof(__uint16_t) * n);
+
+	return n;
+}
+
+/*
+ * xfs_utf8_casefold converts a single UTF-8 sequence into a wide character
+ * and calls xfs_casefold to convert that character into a case-folded
+ * sequence for comparing and hash generation.
+ */
+static int
+xfs_utf8_casefold(
+	const struct xfs_cft *cft,
+	const char	**name,
+	int		*namelen,
+	__uint16_t	*fc)
+{
+	wchar_t		uc;
+
+	if (*namelen == 0)
+		return 0;
+
+	if (**name & 0x80) {
+		/* All extended UTF-8 sequences have the high-bit set */
+		int	n = utf8_mbtowc(&uc, *name, *namelen);
+		if (n < 0) {
+			(*namelen)--;
+			*fc = *(*name)++;
+			return 1;
+		}
+		*name += n;
+		*namelen -= n;
+	} else {
+		/* otherwise, standard ASCII */
+		uc = *(*name)++;
+		(*namelen)--;
+	}
+	return xfs_casefold(cft, uc, fc);
+}
+
+/*
+ * always generate a case-folded hash to allow mount-time selection of
+ * case-insensitive lookup (rather than mkfs time).
+ */
+STATIC xfs_dahash_t
+xfs_unicode_hashname(
+	xfs_inode_t	*inode,
+	struct xfs_name	*name)
+{
+	const char	*n = name->name;
+	int		len = name->len;
+	xfs_dahash_t	hash = 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		nfc;
+	int		i;
+
+	while (len > 0) {
+		nfc = xfs_utf8_casefold(inode->i_mount->m_cft, &n, &len, fc);
+		for (i = 0; i < nfc; i++)
+			hash = fc[i] ^ rol32(hash, 7);
+	}
+	return hash;
+}
+
+/*
+ * Perform a case-folding case-insensitive string comparison,
+ * returns either XFS_CMP_CASE or XFS_CMP_DIFFERENT.
+ */
+STATIC xfs_dacmp_t
+xfs_unicode_casecmp(
+	const struct xfs_cft *cft,
+	const char	*name1,
+	int		len1,
+	const char	*name2,
+	int		len2)
+{
+	__uint16_t	fc1[MAX_FOLD_CHARS], fc2[MAX_FOLD_CHARS];
+	__uint16_t	*fc1p, *fc2p;
+	int		nfc1, nfc2;
+
+	nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+	fc1p = fc1;
+	nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+	fc2p = fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*fc1p != *fc2p)
+			return XFS_CMP_DIFFERENT;
+		if (!--nfc1) {
+			nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+			fc1p = fc1;
+		} else
+			fc1p++;
+		if (!--nfc2) {
+			nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+			fc2p = fc2;
+		} else
+			fc2p++;
+	}
+	if (nfc1 != nfc2)
+		return XFS_CMP_DIFFERENT;
+	return XFS_CMP_CASE;
+
+}
+
+/*
+ * Compare two UTF-8 names to see if they are exactly the same or
+ * case-insensitive match.
+ */
+STATIC xfs_dacmp_t
+xfs_unicode_compname(
+	xfs_inode_t	*inode,
+	const char	*name1,
+	int		len1,
+	const char	*name2,
+	int		len2)
+{
+	wchar_t		uc1, uc2;
+	int		n;
+
+	/*
+	 * If the lengths are different, go straight to the case-insensitive
+	 * comparison
+	 */
+	if (len1 != len2)
+		return xfs_unicode_casecmp(inode->i_mount->m_cft,
+					name1, len1, name2, len2);
+
+	/*
+	 * Start by comparing one-to-one UTF-8 chars. If we have a mismatch,
+	 * downgrade to case-insensitive comparison on the rest of the names.
+	 * At this stage, we only need to maintain one length variable.
+	 */
+	while (len1) {
+		/*
+		 * first do a direct compare, if different, try the
+		 * case-insensitive comparison on the remainder.
+		 */
+		if (*name1 != *name2)
+			return xfs_unicode_casecmp(inode->i_mount->m_cft,
+						name1, len1, name2, len1);
+		/*
+		 * if we are working on a UTF-8 sequence, take in all
+		 * appropriate chars and then compare.
+		 */
+		if (*name1 >= 0x80) {
+			n = utf8_mbtowc(&uc1, name1, len1);
+			if (n < 0)
+				return XFS_CMP_DIFFERENT; /* invalid */
+			utf8_mbtowc(&uc2, name2, len1);
+			/*
+			 * no need to check "n" here as the first char
+			 * determines the length of a UTF-8 sequence.
+			 */
+			if (uc1 != uc2)
+				return xfs_unicode_casecmp(
+						inode->i_mount->m_cft,
+						name1, len1, name2, len1);
+		} else {
+			n = 1;
+		}
+		name1 += n;
+		name2 += n;
+		len1 -= n;
+	}
+	/*
+	 * to get here, all chars must have matched
+	 */
+	return XFS_CMP_EXACT;
+}
+
+STATIC xfs_dacmp_t
+xfs_default_compname(
+	xfs_inode_t	*inode,
+	const char	*name1,
+	int		namelen1,
+	const char	*name2,
+	int		namelen2)
+{
+	return xfs_da_compname(name1, namelen1, name2, namelen2);
+}
+
+const struct xfs_nameops xfs_unicode_nameops = {
+	.hashname	= xfs_unicode_hashname,
+	.compname	= xfs_default_compname,
+};
+
+const struct xfs_nameops xfs_unicode_ci_nameops = {
+	.hashname	= xfs_unicode_hashname,
+	.compname	= xfs_unicode_compname,
+};
+
+int
+xfs_unicode_validate(
+	const struct xfs_name	*name)
+{
+	wchar_t		uc;
+	int		i, nlen;
+
+	for (i = 0; i < name->len; i += nlen) {
+		if (name->name[i] >= 0xf0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"UTF-8 char beyond U+FFFF\n");
+			return EINVAL;
+		}
+		/* utf8_mbtowc must fail on overlong sequences too */
+		nlen = utf8_mbtowc(&uc, name->name + i, name->len - i);
+		if (nlen < 0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"invalid UTF-8 sequence\n");
+			return EILSEQ;
+		}
+		/* check for invalid/surrogate/private unicode chars */
+		if (uc >= 0xfffe || (uc >= 0xd800 && uc <= 0xf8ff)) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"unsupported UTF-8 char\n");
+			return EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Unicode Case Fold Table management
+ */
+
+struct cft_item {
+	struct xfs_cft	*table;
+	int		size;
+	int		refcount;
+};
+
+static mutex_t		cft_lock;
+static int		cft_size;
+static struct cft_item	*cft_list;
+
+STATIC struct xfs_cft *
+add_cft(
+	struct xfs_dcft	*dcft,
+	int		size)
+{
+	int		found = 0;
+	int		i, j;
+	struct xfs_cft	*cft = NULL;
+	__be16		*duc;
+	__uint16_t	*uc;
+	struct cft_item	*tmp_list;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		if (cft_list[i].size != size)
+			continue;
+		cft = cft_list[i].table;
+		if (cft->num_tables != be32_to_cpu(dcft->num_tables) ||
+				cft->flags != be32_to_cpu(dcft->flags))
+			continue;
+		found = 1;
+		for (j = 0; j < cft->num_tables; j++) {
+			if (cft->table_offset[j] !=
+					be32_to_cpu(dcft->table_offset[j])) {
+				found = 0;
+				break;
+			}
+		}
+		if (found) {
+			cft_list[i].refcount++;
+			goto out;
+		}
+	}
+
+	tmp_list = kmem_realloc(cft_list,
+			(cft_size + 1) * sizeof(struct cft_item),
+			cft_size  * sizeof(struct cft_item), KM_MAYFAIL);
+	if (!tmp_list)
+		goto out;
+	cft_list = tmp_list;
+
+	cft = vmalloc(size);
+	if (!cft)
+		goto out;
+	cft->magic = be32_to_cpu(dcft->magic);
+	cft->flags = be32_to_cpu(dcft->flags);
+	cft->num_tables = be32_to_cpu(dcft->num_tables);
+	ASSERT(cft->num_tables <= MAX_FOLD_CHARS);
+	for (i = 0; i < cft->num_tables; i++)
+		cft->table_offset[i] = be32_to_cpu(dcft->table_offset[i]);
+	j = (size - cft->table_offset[0]) / sizeof(__uint16_t);
+	uc = xfs_cft_ptr(cft, 0);
+	duc = (__be16 *)((char *)dcft + be32_to_cpu(dcft->table_offset[0]));
+	for (i = 0; i < j; i++)
+		uc[i] = be16_to_cpu(duc[i]);
+
+	cft_list[cft_size].table = cft;
+	cft_list[cft_size].size = size;
+	cft_list[cft_size].refcount = 1;
+	cft_size++;
+out:
+	mutex_unlock(&cft_lock);
+	return cft;
+}
+
+STATIC void
+remove_cft(
+	const struct xfs_cft *cft)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		if (cft_list[i].table != cft)
+			continue;
+		ASSERT(cft_list[i].refcount > 0);
+		cft_list[i].refcount--;
+		if (cft_list[i].refcount != 0)
+			break;
+		/* no more users of the table, free it */
+		vfree(cft_list[i].table);
+		cft_size--;
+		if (i < cft_size)
+			memmove(cft_list + i, cft_list + i + 1,
+				sizeof(struct cft_item) * (cft_size - i));
+		break;
+	}
+
+	mutex_unlock(&cft_lock);
+}
+
+
+int
+xfs_unicode_read_cft(
+	xfs_mount_t	*mp)
+{
+	int		error;
+	xfs_inode_t	*cftip;
+	int		size;
+	int		next;
+	int             nmap;
+	xfs_bmbt_irec_t *mapp = NULL;
+	int		n;
+	int		byte_cnt;
+	xfs_buf_t	*bp;
+	struct xfs_dcft	*dcft = NULL;
+	char		*tmp;
+
+	if (!xfs_sb_version_hasunicode(&mp->m_sb))
+		return 0;	/* not needed for this filesystem */
+
+	if (mp->m_sb.sb_cftino == NULLFSINO || mp->m_sb.sb_cftino == 0)
+		return EINVAL;
+
+	error = xfs_iget(mp, NULL, mp->m_sb.sb_cftino, 0, 0, &cftip, 0);
+	if (error)
+		return error;
+	ASSERT(cftip != NULL);
+
+	size = cftip->i_d.di_size;
+	next = cftip->i_d.di_nextents;
+
+	error = ENOMEM;
+	dcft = vmalloc(size);
+	if (!dcft)
+		goto out;
+
+	nmap = next;
+	mapp = kmem_alloc(next * sizeof(xfs_bmbt_irec_t), KM_MAYFAIL);
+	if (!mapp)
+		goto out;
+
+	error = xfs_bmapi(NULL, cftip, 0, next, 0, NULL, 0, mapp, &nmap,
+			NULL, NULL);
+	if (error)
+		goto out;
+
+	tmp = (char *)dcft;
+	for (n = 0; n < nmap; n++) {
+		byte_cnt = XFS_FSB_TO_B(mp, mapp[n].br_blockcount);
+
+		error = xfs_read_buf(mp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mapp[n].br_startblock),
+				BTOBB(byte_cnt), 0, &bp);
+		if (error)
+			goto out;
+
+		if (size < byte_cnt)
+			byte_cnt = size;
+		size -= byte_cnt;
+		memcpy(tmp, XFS_BUF_PTR(bp), byte_cnt);
+		tmp += byte_cnt;
+		xfs_buf_relse(bp);
+	}
+
+	/* verify case table read off disk */
+	if (!uuid_equal(&dcft->uuid, &mp->m_sb.sb_uuid)) {
+		error = EINVAL;
+		goto out;
+	}
+
+	/* clear UUID for in-memory copy/compare */
+	memset(&dcft->uuid, 0, sizeof(dcft->uuid));
+
+	mp->m_cft = add_cft(dcft, cftip->i_d.di_size);
+	if (mp->m_cft == NULL)
+		error = ENOMEM;
+
+out:
+	xfs_iput(cftip, 0);
+	kmem_free(mapp, next * sizeof(xfs_bmbt_irec_t));
+	vfree(dcft);
+
+	return error;
+}
+
+void
+xfs_unicode_free_cft(
+	const struct xfs_cft *cft)
+{
+	if (cft)
+		remove_cft(cft);
+}
+
+void
+xfs_unicode_init(void)
+{
+	mutex_init(&cft_lock);
+}
+
+void
+xfs_unicode_uninit(void)
+{
+	ASSERT(cft_size == 0);
+
+	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
+	cft_list = NULL;
+
+	mutex_destroy(&cft_lock);
+}
Index: kern_ci/fs/xfs/xfs_unicode.h
===================================================================
--- /dev/null
+++ kern_ci/fs/xfs/xfs_unicode.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2007-2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_UNICODE_H__
+#define __XFS_UNICODE_H__
+
+#define XFS_CFT_MAGIC		0x58434654	/* 'XCFT' */
+#define XFS_CFT_FLAG_TURKIC	0x00000001
+#define XFS_CFT_FLAG_MAX	0x00000001
+
+/*
+ * Case Fold Table - on disk version. Must match the incore version below.
+ */
+struct xfs_dcft {
+	__be32			magic;		/* validity check */
+	__be32			flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__be32			crc;		/* for future support */
+	__be32			num_tables;	/* single, double, etc */
+	__be32			table_offset[1];/* offsets to tables from
+						   start of this structure */
+};
+
+/*
+ * Case Fold Table - in core version. Must match the ondisk version above.
+ */
+struct xfs_cft {
+	__uint32_t		magic;
+	__uint32_t		flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__uint32_t		crc;
+	__uint32_t		num_tables;	/* single, double, etc */
+	__uint32_t		table_offset[1];/* offsets to tables from
+						   start of this structure */
+	/* 16-bit array tables immediately follow */
+};
+
+#ifdef CONFIG_XFS_UNICODE
+
+void xfs_unicode_init(void);
+void xfs_unicode_uninit(void);
+
+int xfs_unicode_validate(const struct xfs_name *name);
+
+int xfs_unicode_read_cft(struct xfs_mount *mp);
+void xfs_unicode_free_cft(const struct xfs_cft *cft);
+
+#else
+
+static inline void xfs_unicode_init(void) {}
+static inline void xfs_unicode_uninit(void) {}
+static inline int xfs_unicode_validate(const struct xfs_name *name)
+{
+	return 0;
+}
+static inline int xfs_unicode_read_cft(struct xfs_mount *mp)
+{
+	return EOPNOTSUPP;
+}
+static inline void xfs_unicode_free_cft(const struct xfs_cft *cft) {}
+
+#endif	/* CONFIG_XFS_UNICODE */
+
+#endif /* __XFS_UNICODE_H__ */
Index: kern_ci/fs/xfs/xfs_vfsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vfsops.c
+++ kern_ci/fs/xfs/xfs_vfsops.c
@@ -56,6 +56,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
 #include "xfs_utils.h"
+#include "xfs_unicode.h"
 
 
 int __init
@@ -84,6 +85,7 @@ xfs_init(void)
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
 	xfs_mru_cache_init();
 	xfs_filestream_init();
+	xfs_unicode_init();
 
 	/*
 	 * The size of the zone allocated buf log item is the maximum
@@ -159,6 +161,7 @@ xfs_cleanup(void)
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_acl_zone_destroy(xfs_acl_zone);
+	xfs_unicode_uninit();
 
 #ifdef XFS_DIR2_TRACE
 	ktrace_free(xfs_dir2_trace_buf);
@@ -401,6 +404,18 @@ xfs_finish_flags(
 			mp->m_qflags |= XFS_OQUOTA_ENFD;
 	}
 
+	if (xfs_sb_version_hasoldci(&mp->m_sb))
+		mp->m_flags |= XFS_MOUNT_CILOOKUP;
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (ap->flags2 & XFSMNT2_CILOOKUP)
+			mp->m_flags |= XFS_MOUNT_CILOOKUP;
+	} else {
+		if (ap->flags2 & XFSMNT2_CILOOKUP) {
+			cmn_err(CE_WARN,
+	"XFS: can't do case-insensitive mount on non-Unicode filesystem");
+			return XFS_ERROR(EINVAL);
+		}
+	}
 	return 0;
 }
 

-- 
