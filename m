Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:27:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QYuC006086
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062709.011126702@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:13 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
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

The final patches implement NLS support for XFS Unicode.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/Kconfig               |   17 +
 fs/xfs/Makefile              |    4 
 fs/xfs/linux-2.6/xfs_linux.h |    1 
 fs/xfs/linux-2.6/xfs_super.c |   14 +
 fs/xfs/linux-2.6/xfs_super.h |    7 
 fs/xfs/xfs_attr.c            |   24 ++
 fs/xfs/xfs_clnt.h            |    2 
 fs/xfs/xfs_da_btree.c        |   18 +
 fs/xfs/xfs_da_btree.h        |   16 -
 fs/xfs/xfs_dir2.c            |   13 -
 fs/xfs/xfs_dir2.h            |    5 
 fs/xfs/xfs_fs.h              |    1 
 fs/xfs/xfs_fsops.c           |    4 
 fs/xfs/xfs_itable.c          |    2 
 fs/xfs/xfs_mount.c           |   21 +
 fs/xfs/xfs_mount.h           |    7 
 fs/xfs/xfs_rename.c          |    9 
 fs/xfs/xfs_sb.h              |   29 ++
 fs/xfs/xfs_unicode.c         |  499 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_unicode.h         |   81 ++++++
 fs/xfs/xfs_vfsops.c          |   16 +
 fs/xfs/xfs_vnodeops.c        |   52 ++++
 22 files changed, 808 insertions(+), 34 deletions(-)

Index: kern_ci/fs/xfs/Kconfig
===================================================================
--- kern_ci.orig/fs/xfs/Kconfig
+++ kern_ci/fs/xfs/Kconfig
@@ -72,6 +72,21 @@ config XFS_POSIX_ACL
 
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
+	  If you don't require UTF-8 enforcement, say N.
+
 config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
@@ -107,7 +122,7 @@ config XFS_TRACE
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
@@ -46,6 +46,7 @@
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
+#include "xfs_unicode.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
@@ -124,6 +125,7 @@ xfs_args_allocate(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir lookup */
 #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
 #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
 #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
@@ -318,6 +320,14 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
+			args->flags2 |= XFSMNT2_CILOOKUP;
+#ifndef CONFIG_XFS_UNICODE
+			cmn_err(CE_WARN,
+				"XFS: %s option requires Unicode support",
+				this_char);
+			return EINVAL;
+#endif
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
 			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
 			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
@@ -458,6 +468,7 @@ xfs_showargs(
 		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
 		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
+		{ XFS_MOUNT_CILOOKUP,		"," MNTOPT_CILOOKUP },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ 0, NULL }
@@ -567,7 +578,8 @@ xfs_set_inodeops(
 		break;
 	case S_IFDIR:
 		inode->i_op =
-			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ?
+			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ||
+			(XFS_I(inode)->i_mount->m_flags & XFS_MOUNT_CILOOKUP) ?
 				&xfs_dir_ci_inode_operations :
 				&xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.h
@@ -36,6 +36,12 @@
 # define ENOSECURITY		EOPNOTSUPP
 #endif
 
+#ifdef CONFIG_XFS_UNICODE
+# define XFS_UNICODE_STRING	"Unicode, "
+#else
+# define XFS_UNICODE_STRING
+#endif
+
 #ifdef CONFIG_XFS_RT
 # define XFS_REALTIME_STRING	"realtime, "
 #else
@@ -66,6 +72,7 @@
 
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
@@ -175,6 +176,13 @@ xfs_attr_get(
 	if (namelen >= MAXNAMELEN)
 		return(EFAULT);		/* match IRIX behaviour */
 
+	/* Enforce UTF-8 only for user attr names */
+	if (xfs_sb_version_hasunicode(&ip->i_mount->m_sb) &&
+			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
+		error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return(EIO);
 
@@ -435,6 +443,14 @@ xfs_attr_set(
 	if (namelen >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	/* Enforce UTF-8 only for user attr names */
+	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb) &&
+			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
+		int error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
+
 	XFS_STATS_INC(xs_attr_set);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -581,6 +597,14 @@ xfs_attr_remove(
 	if (namelen >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	/* Enforce UTF-8 only for user attr names */
+	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb) &&
+			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
+		int error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
+
 	XFS_STATS_INC(xs_attr_remove);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
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
@@ -1530,16 +1530,22 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
 
-xfs_dacmp_t
-xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2, int len2)
+static xfs_dahash_t
+xfs_default_hashname(xfs_inode_t *inode, const uchar_t *name, int namelen)
 {
-	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
-			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+	return xfs_da_hashname(name, namelen);
+}
+
+static xfs_dacmp_t
+xfs_default_compname(xfs_inode_t *inode, const uchar_t *name1, int namelen1,
+		     const uchar_t *name2, int namelen2)
+{
+	return xfs_da_compname(name1, namelen1, name2, namelen2);
 }
 
 struct xfs_nameops xfs_default_nameops = {
-	.hashname	= xfs_da_hashname,
-	.compname	= xfs_da_compname
+	.hashname	= xfs_default_hashname,
+	.compname	= xfs_default_compname
 };
 
 /*
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -215,9 +215,10 @@ typedef struct xfs_da_state {
  * Name ops for directory and/or attr name operations
  */
 
-typedef xfs_dahash_t	(*xfs_hashname_t)(const uchar_t *, int);
-typedef xfs_dacmp_t	(*xfs_compname_t)(const uchar_t *, int,
-					  const uchar_t *, int);
+typedef xfs_dahash_t	(*xfs_hashname_t)(struct xfs_inode *, const uchar_t *,
+					  int);
+typedef xfs_dacmp_t	(*xfs_compname_t)(struct xfs_inode *, const uchar_t *,
+					  int, const uchar_t *, int);
 
 typedef struct xfs_nameops {
 	xfs_hashname_t		hashname;
@@ -282,8 +283,13 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
 extern struct xfs_nameops xfs_default_nameops;
 
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
-xfs_dacmp_t xfs_da_compname(const uchar_t *name1, int len1,
-			    const uchar_t *name2, int len2);
+
+static inline xfs_dacmp_t
+xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2, int len2)
+{
+	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
+			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
 
 /* returns/frees a MAXNAMELEN buffer from a zone */
 extern struct kmem_zone *xfs_da_name_zone;
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -43,7 +43,7 @@
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
-
+#include "xfs_unicode.h"
 
 /*
  * V1/OLDCI case-insensitive support for directories
@@ -52,6 +52,7 @@
  */
 static xfs_dahash_t
 xfs_ascii_ci_hashname(
+	xfs_inode_t	*inode,
 	const uchar_t	*name,
 	int		namelen)
 {
@@ -66,6 +67,7 @@ xfs_ascii_ci_hashname(
 
 static xfs_dacmp_t
 xfs_ascii_ci_compname(
+	xfs_inode_t	*inode,
 	const uchar_t	*name1,
 	int		len1,
 	const uchar_t	*name2,
@@ -113,8 +115,13 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
-	mp->m_dirnameops = xfs_sb_version_hasoldci(&mp->m_sb) ?
-		&xfs_ascii_ci_nameops : &xfs_default_nameops;
+
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_dirnameops = (mp->m_flags & XFS_MOUNT_CILOOKUP) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_dirnameops = xfs_sb_version_hasoldci(&mp->m_sb) ?
+			&xfs_ascii_ci_nameops : &xfs_default_nameops;
 }
 
 /*
Index: kern_ci/fs/xfs/xfs_dir2.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -88,10 +88,11 @@ extern int xfs_dir_canenter(struct xfs_t
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 #define xfs_dir_hashname(dp, n, l) \
-		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
+		((dp)->i_mount->m_dirnameops->hashname((dp), (n), (l)))
 
 #define xfs_dir_compname(dp, n1, l1, n2, l2) \
-		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))
+		((dp)->i_mount->m_dirnameops->compname((dp), (n1), (l1), \
+							(n2), (l2)))
 
 /*
  * Utility routines for v2 directories.
Index: kern_ci/fs/xfs/xfs_fs.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_fs.h
+++ kern_ci/fs/xfs/xfs_fs.h
@@ -241,6 +241,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
 #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_UNICODE	0x10000	/* unicode filenames */
 
 
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
 
 STATIC void	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
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
@@ -452,6 +455,7 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_cftino = be64_to_cpu(from->sb_cftino);
 }
 
 /*
@@ -1175,6 +1179,18 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Load in unicode case folding table from disk
+	 */
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_read_cft(mp);
+		if (error) {
+			cmn_err(CE_WARN,
+				"XFS: failed to read case folding table");
+			goto error4;
+		}
+	}
+
+	/*
 	 * If fs is not mounted readonly, then update the superblock changes.
 	 */
 	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY))
@@ -1229,7 +1245,8 @@ xfs_mountfs(
 	 * Free up the root inode.
 	 */
 	IRELE(rip);
- error3:
+	xfs_unicode_free_cft(mp->m_cft);
+error3:
 	xfs_log_unmount_dealloc(mp);
  error2:
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
@@ -1956,7 +1973,7 @@ xfs_mount_log_sb(
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
 	struct xfs_nameops	*m_dirnameops;	/* vector of dir name ops */
+	struct xfs_cft		*m_cft;		/* unicode case fold table */
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
@@ -403,7 +406,7 @@ typedef struct xfs_mount {
 
 /*
  * Allow large block sizes to be reported to userspace programs if the
- * "largeio" mount option is used. 
+ * "largeio" mount option is used.
  *
  * If compatibility mode is specified, simply return the basic unit of caching
  * so that we don't get inefficient read/modify/write I/O from user apps.
Index: kern_ci/fs/xfs/xfs_rename.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_rename.c
+++ kern_ci/fs/xfs/xfs_rename.c
@@ -39,6 +39,7 @@
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
+#include "xfs_unicode.h"
 
 
 /*
@@ -248,6 +249,14 @@ xfs_rename(
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(src_name, src_namelen);
+		if (error)
+			return error;
+		error = xfs_unicode_validate(target_name, target_namelen);
+		if (error)
+			return error;
+	}
 	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
 	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
Index: kern_ci/fs/xfs/xfs_sb.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_sb.h
+++ kern_ci/fs/xfs/xfs_sb.h
@@ -79,10 +79,18 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
 
-#define	XFS_SB_VERSION2_OKREALFBITS	\
+#ifdef CONFIG_XFS_UNICODE
+# define XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+	 XFS_SB_VERSION2_UNICODEBIT | \
 	 XFS_SB_VERSION2_ATTR2BIT)
+#else
+# define XFS_SB_VERSION2_OKREALFBITS	\
+	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+	 XFS_SB_VERSION2_ATTR2BIT)
+#endif
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -156,6 +164,7 @@ typedef struct xfs_sb {
 	 * it for anything else.
 	 */
 	__uint32_t	sb_bad_features2;
+	xfs_ino_t	sb_cftino;	/* unicode case folding table inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -225,7 +234,8 @@ typedef struct xfs_dsb {
 	 * for features2 bits. Easiest just to mark it bad and not use
 	 * it for anything else.
 	 */
-	__be32	sb_bad_features2;
+	__be32		sb_bad_features2;
+	__be64		sb_cftino;	/* unicode case folding table inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -246,7 +256,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CFTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -272,6 +282,7 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_CFTINO		XFS_SB_MVAL(CFTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -279,7 +290,7 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_CFTINO)
 
 
 /*
@@ -480,6 +491,16 @@ static inline void xfs_sb_version_addatt
 		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
 }
 
+#ifdef CONFIG_XFS_UNICODE
+static inline int xfs_sb_version_hasunicode(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_UNICODEBIT));
+}
+#else
+# define xfs_sb_version_hasunicode(sbp)	(0)
+#endif
+
 /*
  * end of superblock version macros
  */
Index: kern_ci/fs/xfs/xfs_unicode.c
===================================================================
--- /dev/null
+++ kern_ci/fs/xfs/xfs_unicode.c
@@ -0,0 +1,499 @@
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
+#define MAX_FOLD_CHARS	4
+
+static inline int
+xfs_casefold(
+	const xfs_cft_t *cft,
+	__uint16_t	c,
+	__uint16_t	*fc)
+{
+	__uint16_t	*table = XFS_CFT_PTR(cft, 0);
+	__uint16_t	tmp = table[c >> 8];
+	int		i;
+
+	if (!tmp) {
+		*fc = c;
+		return 1;
+	}
+	tmp = table[tmp + (c & 0xff)];
+	if ((tmp & 0xf000) != 0xe000) {
+		*fc = tmp;
+		return 1;
+	}
+	i = ((tmp >> 10) & 0x3) + 2;
+	ASSERT(i < cft->num_tables);
+	table = XFS_CFT_PTR(cft, i - 1) + ((tmp & 0x3ff) * i);
+
+	memcpy(fc, table, sizeof(__uint16_t) * i);
+
+	return i;
+}
+
+static inline int
+xfs_utf8_casefold(
+	const xfs_cft_t	*cft,
+	const uchar_t	**name,
+	int		*namelen,
+	__uint16_t	*fc)
+{
+	wchar_t		uc;
+
+	if (*namelen == 0)
+		return 0;
+
+	if (**name & 0x80) {
+		int	n = utf8_mbtowc(&uc, *name, *namelen);
+		if (n < 0) {
+			(*namelen)--;
+			*fc = *(*name)++;
+			return 1;
+		}
+		*name += n;
+		*namelen -= n;
+	} else {
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
+xfs_dahash_t
+xfs_unicode_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	xfs_dahash_t	hash = 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		nfc;
+	int		i;
+
+	while (namelen > 0) {
+		nfc = xfs_utf8_casefold(inode->i_mount->m_cft, &name, &namelen,
+				fc);
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
+static xfs_dacmp_t
+xfs_unicode_casecmp(
+	xfs_cft_t	*cft,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int		len2)
+{
+	__uint16_t	fc1[MAX_FOLD_CHARS], fc2[MAX_FOLD_CHARS];
+	__uint16_t	*pfc1, *pfc2;
+	int		nfc1, nfc2;
+
+	nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+	pfc1 = fc1;
+	nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+	pfc2 = fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*pfc1 != *pfc2)
+			return XFS_CMP_DIFFERENT;
+		if (!--nfc1) {
+			nfc1 = xfs_utf8_casefold(cft, &name1, &len1, fc1);
+			pfc1 = fc1;
+		} else
+			pfc1++;
+		if (!--nfc2) {
+			nfc2 = xfs_utf8_casefold(cft, &name2, &len2, fc2);
+			pfc2 = fc2;
+		} else
+			pfc2++;
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
+xfs_dacmp_t
+xfs_unicode_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
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
+static xfs_dacmp_t
+xfs_default_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		namelen1,
+	const uchar_t	*name2,
+	int		namelen2)
+{
+	return xfs_da_compname(name1, namelen1, name2, namelen2);
+}
+
+struct xfs_nameops xfs_unicode_nameops = {
+	.hashname	= xfs_unicode_hashname,
+	.compname	= xfs_default_compname,
+};
+
+struct xfs_nameops xfs_unicode_ci_nameops = {
+	.hashname	= xfs_unicode_hashname,
+	.compname	= xfs_unicode_compname,
+};
+
+int
+xfs_unicode_validate(
+	const uchar_t	*name,
+	int		namelen)
+{
+	wchar_t		uc;
+	int		i, nlen;
+
+	for (i = 0; i < namelen; i += nlen) {
+		if (*name >= 0xf0) {
+			cmn_err(CE_WARN, "xfs_unicode_validate: "
+					"UTF-8 char beyond U+FFFF\n");
+			return EINVAL;
+		}
+		/* utf8_mbtowc must fail on overlong sequences too */
+		nlen = utf8_mbtowc(&uc, name + i, namelen - i);
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
+	xfs_cft_t	*table;
+	int		size;
+	int		refcount;
+};
+
+static mutex_t		cft_lock;
+static int		cft_size;
+static struct cft_item	*cft_list;
+
+static xfs_cft_t *
+add_cft(
+	xfs_dcft_t	*dcft,
+	int		size)
+{
+	int		found = 0;
+	int		i, j;
+	xfs_cft_t	*cft;
+	__be16		*duc;
+	__uint16_t	*uc;
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
+			mutex_unlock(&cft_lock);
+			return cft;
+		}
+	}
+
+	cft = vmalloc(size);
+	if (!cft) {
+		mutex_unlock(&cft_lock);
+		return NULL;
+	}
+	cft->magic = be32_to_cpu(dcft->magic);
+	cft->flags = be32_to_cpu(dcft->flags);
+	cft->num_tables = be32_to_cpu(dcft->num_tables);
+	ASSERT(cft->num_tables <= MAX_FOLD_CHARS);
+	for (i = 0; i < cft->num_tables; i++)
+		cft->table_offset[i] = be32_to_cpu(dcft->table_offset[i]);
+	j = (size - cft->table_offset[0]) / sizeof(__uint16_t);
+	uc = XFS_CFT_PTR(cft, 0);
+	duc = XFS_DCFT_PTR(dcft, 0);
+	for (i = 0; i < j; i++)
+		uc[i] = be16_to_cpu(duc[i]);
+
+	cft_list = kmem_realloc(cft_list,
+			(cft_size + 1) * sizeof(struct cft_item),
+			cft_size  * sizeof(struct cft_item), KM_SLEEP);
+	cft_list[cft_size].table = cft;
+	cft_list[cft_size].size = size;
+	cft_list[cft_size].refcount = 1;
+	cft_size++;
+
+	mutex_unlock(&cft_lock);
+
+	return cft;
+}
+
+static void
+remove_cft(
+	const xfs_cft_t	*cft)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		if (cft_list[i].table == cft) {
+			ASSERT(cft_list[i].refcount > 0);
+			cft_list[i].refcount--;
+			break;
+		}
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
+	int		nfsb;
+	int             nmap;
+	xfs_bmbt_irec_t *mapp;
+	int		n;
+	int		byte_cnt;
+	xfs_buf_t	*bp;
+	char		*table;
+	xfs_dcft_t	*dcft;
+
+	if (mp->m_sb.sb_cftino == NULLFSINO || mp->m_sb.sb_cftino == 0)
+		return EINVAL;
+	error = xfs_iget(mp, NULL, mp->m_sb.sb_cftino, 0, 0, &cftip, 0);
+	if (error)
+		return error;
+	ASSERT(cftip != NULL);
+
+	size = cftip->i_d.di_size;
+	nfsb = cftip->i_d.di_nblocks;
+
+	table = vmalloc(size);
+	if (!table) {
+		xfs_iput(cftip, 0);
+		return ENOMEM;
+	}
+	dcft = (xfs_dcft_t *)table;
+
+	nmap = nfsb;
+	mapp = kmem_alloc(nfsb * sizeof(xfs_bmbt_irec_t), KM_SLEEP);
+
+	error = xfs_bmapi(NULL, cftip, 0, nfsb, 0, NULL, 0, mapp, &nmap,
+			NULL, NULL);
+	if (error)
+		goto out;
+
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
+		memcpy(table, XFS_BUF_PTR(bp), byte_cnt);
+		table += byte_cnt;
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
+	kmem_free(mapp, nfsb * sizeof(xfs_bmbt_irec_t));
+	vfree(dcft);
+
+	return error;
+}
+
+void
+xfs_unicode_free_cft(
+	const xfs_cft_t	*cft)
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
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i = 0; i < cft_size; i++) {
+		ASSERT(cft_list[i].refcount == 0);
+		vfree(cft_list[i].table);
+	}
+	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
+	cft_size = 0;
+	cft_list = NULL;
+
+	mutex_unlock(&cft_lock);
+	mutex_destroy(&cft_lock);
+}
Index: kern_ci/fs/xfs/xfs_unicode.h
===================================================================
--- /dev/null
+++ kern_ci/fs/xfs/xfs_unicode.h
@@ -0,0 +1,81 @@
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
+#define	__XFS_UNICODE_H__
+
+#define	XFS_CFT_MAGIC		0x58434654	/* 'XCFT' */
+#define XFS_CFT_FLAG_TURKIC	0x00000001
+#define XFS_CFT_FLAG_MAX	0x00000001
+
+/*
+ * Case Fold Table - on disk version. Must match the incore version below.
+ */
+typedef struct xfs_dcft {
+	__be32			magic;		/* validity check */
+	__be32			flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__be32			crc;		/* for future support */
+	__be32			num_tables;	/* single, double, etc */
+	__be32			table_offset[1];
+} xfs_dcft_t;
+
+/*
+ * Case Fold Table - in core version. Must match the ondisk version above.
+ */
+typedef struct xfs_cft {
+	__uint32_t		magic;
+	__uint32_t		flags;
+	uuid_t			uuid;		/* UUID of the filesystem */
+	__uint32_t		crc;
+	__uint32_t		num_tables;	/* single, double, etc */
+	__uint32_t		table_offset[1];/* num_tables sized */
+	/* 16-bit array tables immediately follow */
+} xfs_cft_t;
+
+#define XFS_CFT_PTR(t,n)	(__uint16_t *)(((char *)(t)) + \
+					(t)->table_offset[n])
+#define XFS_DCFT_PTR(t,n)	(__be16 *)(((char *)(t)) + \
+					be32_to_cpu((t)->table_offset[n]))
+
+#ifdef CONFIG_XFS_UNICODE
+
+extern struct xfs_nameops xfs_unicode_nameops;
+extern struct xfs_nameops xfs_unicode_ci_nameops;
+
+void xfs_unicode_init(void);
+void xfs_unicode_uninit(void);
+
+int xfs_unicode_validate(const uchar_t *name, int namelen);
+
+int xfs_unicode_read_cft(struct xfs_mount *mp);
+void xfs_unicode_free_cft(const xfs_cft_t *cft);
+
+#else
+
+#define xfs_unicode_nameops		xfs_default_nameops
+#define xfs_unicode_ci_nameops		xfs_default_nameops
+
+#define xfs_unicode_init()
+#define xfs_unicode_uninit()
+#define xfs_unicode_validate(n,l)	0
+#define xfs_unicode_read_cft(mp)	(EOPNOTSUPP)
+#define xfs_unicode_free_cft(cft)
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
@@ -82,6 +83,7 @@ xfs_init(void)
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
 	xfs_mru_cache_init();
 	xfs_filestream_init();
+	xfs_unicode_init();
 
 	/*
 	 * The size of the zone allocated buf log item is the maximum
@@ -157,6 +159,7 @@ xfs_cleanup(void)
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_acl_zone_destroy(xfs_acl_zone);
+	xfs_unicode_uninit();
 
 #ifdef XFS_DIR2_TRACE
 	ktrace_free(xfs_dir2_trace_buf);
@@ -399,6 +402,19 @@ xfs_finish_flags(
 			mp->m_qflags |= XFS_OQUOTA_ENFD;
 	}
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (ap->flags2 & XFSMNT2_CILOOKUP)
+			mp->m_flags |= XFS_MOUNT_CILOOKUP;
+	} else {
+		/*
+		 * Check for mount options which require a Unicode FS
+		 */
+		if (ap->flags2 & XFSMNT2_CILOOKUP) {
+			cmn_err(CE_WARN,
+	"XFS: can't do case-insensitive mount on non-utf8 filesystem");
+			return XFS_ERROR(EINVAL);
+		}
+	}
 	return 0;
 }
 
Index: kern_ci/fs/xfs/xfs_vnodeops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -52,6 +52,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_unicode.h"
 
 int
 xfs_open(
@@ -1777,6 +1778,12 @@ xfs_lookup(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
 
+	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb)) {
+		error = xfs_unicode_validate(d_name->name, d_name->len);
+		if (error)
+			return error;
+	}
+
 	name.name = (uchar_t *)d_name->name;
 	name.len = d_name->len;
 	rname.name = NULL;
@@ -1822,8 +1829,17 @@ xfs_create(
 	ASSERT(!*ipp);
 	xfs_itrace_entry(dp);
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
 	namelen = VNAMELEN(dentry);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
+
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 				dp, DM_RIGHT_NULL, NULL,
@@ -1835,9 +1851,6 @@ xfs_create(
 		dm_event_sent = 1;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
 	/* Return through std_return after this point. */
 
 	udqp = gdqp = NULL;
@@ -2282,7 +2295,7 @@ xfs_remove(
 	xfs_inode_t             *ip = VNAME_TO_INODE(dentry);
 	int			namelen = VNAMELEN(dentry);
 	xfs_trans_t             *tp = NULL;
-	int                     error = 0;
+	int                     error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
@@ -2295,6 +2308,12 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
+
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
@@ -2504,6 +2523,12 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(target_name, target_namelen);
+		if (error)
+			return error;
+	}
+
 	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
 					tdp, DM_RIGHT_NULL,
@@ -2661,6 +2686,12 @@ xfs_mkdir(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(dir_name, dir_namelen);
+		if (error)
+			return error;
+	}
+
 	tp = NULL;
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
@@ -2869,6 +2900,12 @@ xfs_rmdir(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(name, namelen);
+		if (error)
+			return error;
+	}
+
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
 					dp, DM_RIGHT_NULL,
@@ -3097,7 +3134,6 @@ xfs_symlink(
 	int			link_namelen;
 
 	*ipp = NULL;
-	error = 0;
 	ip = NULL;
 	tp = NULL;
 
@@ -3108,6 +3144,12 @@ xfs_symlink(
 
 	link_namelen = VNAMELEN(dentry);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_unicode_validate(link_name, link_namelen);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Check component lengths of the target path name.
 	 */

-- 
