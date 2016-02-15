Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 877387CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:32:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5032E304059
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:32:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bs8nhOqerszAH83V for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:32:33 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs_fs.h: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
	promotion
Date: Mon, 15 Feb 2016 16:32:24 +1100
Message-Id: <1455514346-15481-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1455514346-15481-1-git-send-email-david@fromorbit.com>
References: <1455514346-15481-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

The kernel commit to make this ioctl promotion (bb99e06ddf) moved
the definitions for the XFS ioctl to uapi/linux/fs.h for the
following reason:

    Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API
    from fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that
    the ioctls can be used by all filesystems, not just XFS. This
    enables (initially) ext4 to use the ioctl to set project IDs on
    inodes.

This means we now need to handle this change in userspace as the
uapi/linux/fs.h file may not contain the definitions (i.e. new
xfsprogs/ old linux uapi files) xfsprogs needs to build. Hence we
need to massage the definition in xfs_fs.h to take the values from
the system header if it exists, otherwise keep the old definitions
for compatibility and platforms other than linux.

To this extent, we add the FS* definitions to the platform headers
so the FS* versions are available on all platforms, and add trivial
defines to xfs_fs.h to present the XFS* versions for backwards
compatibility with existing code. New code should always use the FS*
versions, and as such we also convert all the users of XFS* in
xfsprogs to use the FS* definitions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fsr/xfs_fsr.c       | 16 ++++++----------
 include/darwin.h    | 34 +++++++++++++++++++++++++++++++++
 include/freebsd.h   | 34 +++++++++++++++++++++++++++++++++
 include/irix.h      | 37 +++++++++++++++++++++++++++++++++---
 include/linux.h     | 38 +++++++++++++++++++++++++++++++++++++
 io/attr.c           | 40 +++++++++++++++++++--------------------
 io/bmap.c           | 16 ++++++++--------
 io/open.c           | 32 +++++++++++++++----------------
 libxcmd/projects.c  |  8 ++++----
 libxfs/xfs_format.h |  2 --
 libxfs/xfs_fs.h     | 54 +++++++++++++++++++++--------------------------------
 quota/free.c        |  6 +++---
 quota/project.c     | 16 ++++++++--------
 repair/dinode.c     |  4 ++--
 rtcp/xfs_rtcp.c     | 12 ++++++------
 15 files changed, 234 insertions(+), 115 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 19838ed..d75990a 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -33,10 +33,6 @@
 #include <sys/xattr.h>
 #include <paths.h>
 
-#ifndef XFS_XFLAG_NODEFRAG
-#define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
-#endif
-
 #define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
@@ -962,22 +958,22 @@ fsrfile_common(
 		return 1;
 	}
 
-	if ((ioctl(fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+	if ((ioctl(fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fsrprintf(_("failed to get inode attrs: %s\n"), fname);
 		return(-1);
 	}
-	if (fsx.fsx_xflags & (XFS_XFLAG_IMMUTABLE|XFS_XFLAG_APPEND)) {
+	if (fsx.fsx_xflags & (FS_XFLAG_IMMUTABLE|FS_XFLAG_APPEND)) {
 		if (vflag)
 			fsrprintf(_("%s: immutable/append, ignoring\n"), fname);
 		return(0);
 	}
-	if (fsx.fsx_xflags & XFS_XFLAG_NODEFRAG) {
+	if (fsx.fsx_xflags & FS_XFLAG_NODEFRAG) {
 		if (vflag)
 			fsrprintf(_("%s: marked as don't defrag, ignoring\n"),
 			    fname);
 		return(0);
 	}
-	if (fsx.fsx_xflags & XFS_XFLAG_REALTIME) {
+	if (fsx.fsx_xflags & FS_XFLAG_REALTIME) {
 		if (xfs_getrt(fd, &vfss) < 0) {
 			fsrprintf(_("cannot get realtime geometry for: %s\n"),
 				fname);
@@ -1038,7 +1034,7 @@ fsr_setup_attr_fork(
 	int		no_change_cnt = 0;
 	int		ret;
 
-	if (!(bstatp->bs_xflags & XFS_XFLAG_HASATTR))
+	if (!(bstatp->bs_xflags & FS_XFLAG_HASATTR))
 		return 0;
 
 	/*
@@ -1264,7 +1260,7 @@ packfile(char *fname, char *tname, int fd,
 
 	/* Setup extended inode flags, project identifier, etc */
 	if (fsxp->fsx_xflags || fsxp->fsx_projid) {
-		if (ioctl(tfd, XFS_IOC_FSSETXATTR, fsxp) < 0) {
+		if (ioctl(tfd, FS_IOC_FSSETXATTR, fsxp) < 0) {
 			fsrprintf(_("could not set inode attrs on tmp: %s\n"),
 				tname);
 			goto out;
diff --git a/include/darwin.h b/include/darwin.h
index dd6132f..2baa536 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -285,4 +285,38 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 	cursor->i = 0;
 }
 
+/* check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves */
+#ifndef HAVE_FSXATTR
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
+#define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
+
+#endif
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/include/freebsd.h b/include/freebsd.h
index 65bd60a..fe567d4 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -175,5 +175,39 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 	endmntent(cursor->mtabp);
 }
 
+/* check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves */
+#ifndef HAVE_FSXATTR
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
+#define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
+
+#endif
+
 
 #endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/irix.h b/include/irix.h
index 293f869..bdb4b6a 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -378,8 +378,6 @@ static __inline__ char * strsep(char **s, const char *ct)
 #define __XFS_FS_H__	1
 
 #define XFS_IOC_DIOINFO			F_DIOINFO
-#define XFS_IOC_FSGETXATTR		F_FSGETXATTR
-#define XFS_IOC_FSSETXATTR		F_FSSETXATTR
 #define XFS_IOC_ALLOCSP64		F_ALLOCSP64
 #define XFS_IOC_FREESP64		F_FREESP64
 #define XFS_IOC_GETBMAP			F_GETBMAP
@@ -422,7 +420,40 @@ static __inline__ char * strsep(char **s, const char *ct)
 
 #define	_AIOCB64_T_DEFINED		1
 
-#define	XFS_XFLAG_NODEFRAG		0x00002000
+/* check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves */
+#ifndef HAVE_FSXATTR
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
+#define FS_IOC_FSGETXATTR		F_FSGETXATTR
+#define FS_IOC_FSSETXATTR		F_FSSETXATTR
+
+#endif
+
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/linux.h b/include/linux.h
index 16fb707..17391c3 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -174,4 +174,42 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 	endmntent(cursor->mtabp);
 }
 
+/*
+ * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
+ * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
+ * so this is purely for supporting builds against old kernel headers.
+ */
+#ifndef FS_IOC_FSGETXATTR
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
+#define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
+
+#endif
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/io/attr.c b/io/attr.c
index 7cbcc3c..6fa08bf 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -33,20 +33,20 @@ static struct xflags {
 	char	*shortname;
 	char	*longname;
 } xflags[] = {
-	{ XFS_XFLAG_REALTIME,		"r", "realtime"		},
-	{ XFS_XFLAG_PREALLOC,		"p", "prealloc"		},
-	{ XFS_XFLAG_IMMUTABLE,		"i", "immutable"	},
-	{ XFS_XFLAG_APPEND,		"a", "append-only"	},
-	{ XFS_XFLAG_SYNC,		"s", "sync"		},
-	{ XFS_XFLAG_NOATIME,		"A", "no-atime"		},
-	{ XFS_XFLAG_NODUMP,		"d", "no-dump"		},
-	{ XFS_XFLAG_RTINHERIT,		"t", "rt-inherit"	},
-	{ XFS_XFLAG_PROJINHERIT,	"P", "proj-inherit"	},
-	{ XFS_XFLAG_NOSYMLINKS,		"n", "nosymlinks"	},
-	{ XFS_XFLAG_EXTSIZE,		"e", "extsize"		},
-	{ XFS_XFLAG_EXTSZINHERIT,	"E", "extsz-inherit"	},
-	{ XFS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
-	{ XFS_XFLAG_FILESTREAM,		"S", "filestream"	},
+	{ FS_XFLAG_REALTIME,		"r", "realtime"		},
+	{ FS_XFLAG_PREALLOC,		"p", "prealloc"		},
+	{ FS_XFLAG_IMMUTABLE,		"i", "immutable"	},
+	{ FS_XFLAG_APPEND,		"a", "append-only"	},
+	{ FS_XFLAG_SYNC,		"s", "sync"		},
+	{ FS_XFLAG_NOATIME,		"A", "no-atime"		},
+	{ FS_XFLAG_NODUMP,		"d", "no-dump"		},
+	{ FS_XFLAG_RTINHERIT,		"t", "rt-inherit"	},
+	{ FS_XFLAG_PROJINHERIT,		"P", "proj-inherit"	},
+	{ FS_XFLAG_NOSYMLINKS,		"n", "nosymlinks"	},
+	{ FS_XFLAG_EXTSIZE,		"e", "extsize"		},
+	{ FS_XFLAG_EXTSZINHERIT,	"E", "extsz-inherit"	},
+	{ FS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
+	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
 	{ 0, NULL, NULL }
 };
 #define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfS"
@@ -169,7 +169,7 @@ lsattr_callback(
 	if ((fd = open(path, O_RDONLY)) == -1)
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
-	else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0)
+	else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0)
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 	else
@@ -216,7 +216,7 @@ lsattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, lsattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if ((xfsctl(name, file->fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 	} else {
@@ -245,13 +245,13 @@ chattr_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
-	} else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &attr) < 0) {
+	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 	} else {
 		attr.fsx_xflags |= orflags;
 		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &attr) < 0)
+		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0)
 			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
 				progname, path, strerror(errno));
 	}
@@ -316,13 +316,13 @@ chattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, chattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if (xfsctl(name, file->fd, XFS_IOC_FSGETXATTR, &attr) < 0) {
+	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 	} else {
 		attr.fsx_xflags |= orflags;
 		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(name, file->fd, XFS_IOC_FSSETXATTR, &attr) < 0)
+		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0)
 			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
 				progname, name, strerror(errno));
 	}
diff --git a/io/bmap.c b/io/bmap.c
index cbeed3b..04d04c7 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -125,7 +125,7 @@ bmap_f(
 			exitcode = 1;
 			return 0;
 		}
-		c = xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTR, &fsx);
+		c = xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx);
 		if (c < 0) {
 			fprintf(stderr,
 				_("%s: cannot read attrs on \"%s\": %s\n"),
@@ -134,7 +134,7 @@ bmap_f(
 			return 0;
 		}
 
-		if (fsx.fsx_xflags == XFS_XFLAG_REALTIME) {
+		if (fsx.fsx_xflags == FS_XFLAG_REALTIME) {
 			/*
 			 * ag info not applicable to rt, continue
 			 * without ag output.
@@ -157,7 +157,7 @@ bmap_f(
  *	by nflag, or the initial guess number of extents (32).
  *
  *	If there are more extents than we guessed, use xfsctl
- *	(XFS_IOC_FSGETXATTR[A]) to get the extent count, realloc some more
+ *	(FS_IOC_FSGETXATTR[A]) to get the extent count, realloc some more
  *	space based on this count, and try again.
  *
  *	If the initial FGETBMAPX attempt returns EINVAL, this may mean
@@ -165,13 +165,13 @@ bmap_f(
  *	EINVAL, check the length with fstat() and return "no extents"
  *	if the length == 0.
  *
- *	Why not do the xfsctl(XFS_IOC_FSGETXATTR[A]) first?  Two reasons:
+ *	Why not do the xfsctl(FS_IOC_FSGETXATTR[A]) first?  Two reasons:
  *	(1)	The extent count may be wrong for a file with delayed
  *		allocation blocks.  The XFS_IOC_GETBMAPX forces the real
  *		allocation and fixes up the extent count.
  *	(2)	For XFS_IOC_GETBMAP[X] on a DMAPI file that has been moved
  *		offline by a DMAPI application (e.g., DMF) the
- *		XFS_IOC_FSGETXATTR only reflects the extents actually online.
+ *		FS_IOC_FSGETXATTR only reflects the extents actually online.
  *		Doing XFS_IOC_GETBMAPX call first forces that data blocks online
  *		and then everything proceeds normally (see PV #545725).
  *
@@ -207,13 +207,13 @@ bmap_f(
 			break;
 		if (map->bmv_entries < map->bmv_count-1)
 			break;
-		/* Get number of extents from xfsctl XFS_IOC_FSGETXATTR[A]
+		/* Get number of extents from xfsctl FS_IOC_FSGETXATTR[A]
 		 * syscall.
 		 */
 		i = xfsctl(file->name, file->fd, aflag ?
-				XFS_IOC_FSGETXATTRA : XFS_IOC_FSGETXATTR, &fsx);
+				XFS_IOC_FSGETXATTRA : FS_IOC_FSGETXATTR, &fsx);
 		if (i < 0) {
-			fprintf(stderr, "%s: xfsctl(XFS_IOC_FSGETXATTR%s) "
+			fprintf(stderr, "%s: xfsctl(FS_IOC_FSGETXATTR%s) "
 				"[\"%s\"]: %s\n", progname, aflag ? "A" : "",
 				file->name, strerror(errno));
 			free(map);
diff --git a/io/open.c b/io/open.c
index ac5a5e0..037843d 100644
--- a/io/open.c
+++ b/io/open.c
@@ -115,9 +115,9 @@ stat_f(
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTR, &fsx)) < 0 ||
+	if ((xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
 	    (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa)) < 0) {
-		perror("XFS_IOC_FSGETXATTR");
+		perror("FS_IOC_FSGETXATTR");
 	} else {
 		printf(_("fsxattr.xflags = 0x%x "), fsx.fsx_xflags);
 		printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
@@ -193,15 +193,15 @@ openfile(
 	if (!(flags & IO_READONLY) && (flags & IO_REALTIME)) {
 		struct fsxattr	attr;
 
-		if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &attr) < 0) {
-			perror("XFS_IOC_FSGETXATTR");
+		if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
+			perror("FS_IOC_FSGETXATTR");
 			close(fd);
 			return -1;
 		}
-		if (!(attr.fsx_xflags & XFS_XFLAG_REALTIME)) {
-			attr.fsx_xflags |= XFS_XFLAG_REALTIME;
-			if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &attr) < 0) {
-				perror("XFS_IOC_FSSETXATTR");
+		if (!(attr.fsx_xflags & FS_XFLAG_REALTIME)) {
+			attr.fsx_xflags |= FS_XFLAG_REALTIME;
+			if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
+				perror("FS_IOC_FSSETXATTR");
 				close(fd);
 				return -1;
 			}
@@ -559,8 +559,8 @@ get_extsize(const char *path, int fd)
 {
 	struct fsxattr	fsx;
 
-	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
-		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
 		return 0;
 	}
@@ -578,24 +578,24 @@ set_extsize(const char *path, int fd, long extsz)
 		perror("fstat64");
 		return 0;
 	}
-	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
-		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
 		return 0;
 	}
 
 	if (S_ISREG(stat.st_mode)) {
-		fsx.fsx_xflags |= XFS_XFLAG_EXTSIZE;
+		fsx.fsx_xflags |= FS_XFLAG_EXTSIZE;
 	} else if (S_ISDIR(stat.st_mode)) {
-		fsx.fsx_xflags |= XFS_XFLAG_EXTSZINHERIT;
+		fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
 	} else {
 		printf(_("invalid target file type - file %s\n"), path);
 		return 0;
 	}
 	fsx.fsx_extsize = extsz;
 
-	if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
-		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
+	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
+		printf("%s: FS_IOC_FSSETXATTR %s: %s\n",
 			progname, path, strerror(errno));
 		return 0;
 	}
diff --git a/libxcmd/projects.c b/libxcmd/projects.c
index 24ef70a..c9e863d 100644
--- a/libxcmd/projects.c
+++ b/libxcmd/projects.c
@@ -176,8 +176,8 @@ getprojid(
 {
 	struct fsxattr	fsx;
 
-	if (xfsctl(name, fd, XFS_IOC_FSGETXATTR, &fsx)) {
-		perror("XFS_IOC_FSGETXATTR");
+	if (xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) {
+		perror("FS_IOC_FSGETXATTR");
 		return -1;
 	}
 	*projid = fsx.fsx_projid;
@@ -193,9 +193,9 @@ setprojid(
 	struct fsxattr	fsx;
 	int		error;
 
-	if ((error = xfsctl(name, fd, XFS_IOC_FSGETXATTR, &fsx)) == 0) {
+	if ((error = xfsctl(name, fd, FS_IOC_FSGETXATTR, &fsx)) == 0) {
 		fsx.fsx_projid = projid;
-		error = xfsctl(name, fd, XFS_IOC_FSSETXATTR, &fsx);
+		error = xfsctl(name, fd, FS_IOC_FSSETXATTR, &fsx);
 	}
 	return error;
 }
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a35009a..967b1ef 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -984,8 +984,6 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 /*
  * Values for di_flags
- * There should be a one-to-one correspondence between these flags and the
- * XFS_XFLAG_s.
  */
 #define XFS_DIFLAG_REALTIME_BIT  0	/* file's blocks come from rt area */
 #define XFS_DIFLAG_PREALLOC_BIT  1	/* file space has been preallocated */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d8b733a..b9622ba 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -36,38 +36,28 @@ struct dioattr {
 #endif
 
 /*
- * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
+ * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
+ * These are for backwards compatibility only. New code should
+ * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
  */
-#ifndef HAVE_FSXATTR
-struct fsxattr {
-	__u32		fsx_xflags;	/* xflags field value (get/set) */
-	__u32		fsx_extsize;	/* extsize field value (get/set)*/
-	__u32		fsx_nextents;	/* nextents field value (get)	*/
-	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
-};
-#endif
-
-/*
- * Flags for the bs_xflags/fsx_xflags field
- * There should be a one-to-one correspondence between these flags and the
- * XFS_DIFLAG_s.
- */
-#define XFS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
-#define XFS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
-#define XFS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
-#define XFS_XFLAG_APPEND	0x00000010	/* all writes append */
-#define XFS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
-#define XFS_XFLAG_NOATIME	0x00000040	/* do not update access time */
-#define XFS_XFLAG_NODUMP	0x00000080	/* do not include in backups */
-#define XFS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
-#define XFS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
-#define XFS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
-#define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
-#define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
-#define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
-#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
-#define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
+#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
+#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
+#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
+#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
+#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
+#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
+#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
+#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
+#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
+#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
+#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
+#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
+#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
+#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
+
+#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
+#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
 
 /*
  * Structure for XFS_IOC_GETBMAP.
@@ -513,8 +503,6 @@ typedef struct xfs_swapext
 #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
 #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
-#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
-#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
diff --git a/quota/free.c b/quota/free.c
index dcbe8ce..e9e0319 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -143,13 +143,13 @@ projects_free_space_data(
 		return 0;
 	}
 
-	if ((xfsctl(path->fs_dir, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+	if ((xfsctl(path->fs_dir, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		exitcode = 1;
-		perror("XFS_IOC_FSGETXATTR");
+		perror("FS_IOC_FSGETXATTR");
 		close(fd);
 		return 0;
 	}
-	if (!(fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT)) {
+	if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT)) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: project quota flag not set on %s\n"),
 			progname, path->fs_dir);
diff --git a/quota/project.c b/quota/project.c
index 17a83b0..fb8b9e1 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -117,7 +117,7 @@ check_project(
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
-	} else if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
@@ -126,7 +126,7 @@ check_project(
 			printf(_("%s - project identifier is not set"
 				 " (inode=%u, tree=%u)\n"),
 				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT))
+		if (!(fsx.fsx_xflags & FS_XFLAG_PROJINHERIT))
 			printf(_("%s - project inheritance flag is not set\n"),
 				path);
 	}
@@ -163,7 +163,7 @@ clear_project(
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
 		return 0;
-	} else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx) < 0) {
+	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
@@ -172,8 +172,8 @@ clear_project(
 	}
 
 	fsx.fsx_projid = 0;
-	fsx.fsx_xflags &= ~XFS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
+	fsx.fsx_xflags &= ~FS_XFLAG_PROJINHERIT;
+	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
 			progname, path, strerror(errno));
@@ -210,7 +210,7 @@ setup_project(
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
 		return 0;
-	} else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx) < 0) {
+	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
@@ -219,8 +219,8 @@ setup_project(
 	}
 
 	fsx.fsx_projid = prid;
-	fsx.fsx_xflags |= XFS_XFLAG_PROJINHERIT;
-	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
+	fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
 			progname, path, strerror(errno));
diff --git a/repair/dinode.c b/repair/dinode.c
index df28e9e..cbd4305 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2423,7 +2423,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 						XFS_DIFLAG_NOSYMLINKS);
 			}
 		}
-		if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
+		if (flags & (XFS_DIFLAG_REALTIME | FS_XFLAG_EXTSIZE)) {
 			/* must be a file */
 			if (di_mode && !S_ISREG(di_mode)) {
 				if (!uncertain) {
@@ -2432,7 +2432,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 						lino);
 				}
 				flags &= ~(XFS_DIFLAG_REALTIME |
-						XFS_XFLAG_EXTSIZE);
+						FS_XFLAG_EXTSIZE);
 			}
 		}
 		if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f604b46..3044350 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -186,13 +186,13 @@ rtcp( char *source, char *target, int fextsize)
 		/*
 		 * mark the file as a realtime file
 		 */
-		fsxattr.fsx_xflags = XFS_XFLAG_REALTIME;
+		fsxattr.fsx_xflags = FS_XFLAG_REALTIME;
 		if (fextsize != -1 )
 			fsxattr.fsx_extsize = fextsize;
 		else
 			fsxattr.fsx_extsize = 0;
 
-		if ( xfsctl(tbuf, tofd, XFS_IOC_FSSETXATTR, &fsxattr) ) {
+		if ( xfsctl(tbuf, tofd, FS_IOC_FSSETXATTR, &fsxattr) ) {
 			fprintf(stderr,
 				_("%s: set attributes on %s failed: %s\n"),
 				progname, tbuf, strerror(errno));
@@ -210,7 +210,7 @@ rtcp( char *source, char *target, int fextsize)
 			return( -1 );
 		}
 
-		if ( xfsctl(tbuf, tofd, XFS_IOC_FSGETXATTR, &fsxattr) ) {
+		if ( xfsctl(tbuf, tofd, FS_IOC_FSGETXATTR, &fsxattr) ) {
 			fprintf(stderr,
 				_("%s: get attributes of %s failed: %s\n"),
 				progname, tbuf, strerror(errno));
@@ -221,7 +221,7 @@ rtcp( char *source, char *target, int fextsize)
 		/*
 		 * check if the existing file is already a realtime file
 		 */
-		if ( !(fsxattr.fsx_xflags & XFS_XFLAG_REALTIME) ) {
+		if ( !(fsxattr.fsx_xflags & FS_XFLAG_REALTIME) ) {
 			fprintf(stderr, _("%s: %s is not a realtime file.\n"),
 				progname, tbuf);
 			close( tofd );
@@ -255,10 +255,10 @@ rtcp( char *source, char *target, int fextsize)
 
 	fsxattr.fsx_xflags = 0;
 	fsxattr.fsx_extsize = 0;
-	if ( xfsctl(source, fromfd, XFS_IOC_FSGETXATTR, &fsxattr) ) {
+	if ( xfsctl(source, fromfd, FS_IOC_FSGETXATTR, &fsxattr) ) {
 		reopen = 1;
 	} else {
-		if (! (fsxattr.fsx_xflags & XFS_XFLAG_REALTIME) ){
+		if (! (fsxattr.fsx_xflags & FS_XFLAG_REALTIME) ){
 			fprintf(stderr, _("%s: %s is not a realtime file.\n"),
 				progname, source);
 			reopen = 1;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
