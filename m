Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2362F7F6C
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:57:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 128B7304048
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 05:57:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CpQvk6hZHFngvlhN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 05:57:12 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 4/4] xfsprogs: OS X partial support
Date: Mon, 20 Jul 2015 14:56:58 +0200
Message-Id: <1437397018-12864-5-git-send-email-jtulak@redhat.com>
In-Reply-To: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
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

This patch introduces changes to support current OS X (10.10 Yosemite).
The previous OS X code base is about 4 years old and both OS X and
XFS changed, so there had to be done some work to make it compilable.

- xfs_repair currently has only a dummy timer implementation
- fsr and io, as tools working with a mounted XFS, are
  really not expected to work - lots of dummy functions
- Various other edits  - some API translations, some missing
  defines.

The code compiles using Apple's clang, although it throws some
warnings. Some of them are complaints about deprecated calls, some
are false-positives and there are also some incompatible type
assignments/comparisons. Fixing these looks like an ugly work,
but fortunately, incompatible assignments are only in the tools
not expected to work anyway (fsr and io).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          |   1 +
 fsr/xfs_fsr.c         |  20 +++++-
 include/bitops.h      |   2 +
 include/builddefs.in  |   6 +-
 include/darwin.h      | 168 ++++++++++++++++++++++++++++++++++++++++++++------
 io/readdir.c          |   4 ++
 libdisk/fstype.c      |   1 +
 libhandle/Makefile    |   4 ++
 libxcmd/paths.c       |   2 +-
 m4/package_libcdev.m4 |  14 +++++
 10 files changed, 198 insertions(+), 24 deletions(-)

diff --git a/configure.ac b/configure.ac
index fe991cc..8f966a6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,6 +113,7 @@ AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 AC_HAVE_READDIR
+AC_HAVE_FLS
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index efc17a8..a069bd7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -25,16 +25,22 @@
 
 #include <fcntl.h>
 #include <errno.h>
-#include <malloc.h>
-#include <mntent.h>
 #include <syslog.h>
 #include <signal.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
-#include <sys/vfs.h>
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
 
+#ifndef PLATFORM_HAS_NO_MALLOC_H
+#  include <malloc.h>
+#endif
+#ifndef PLATFORM_HAS_NO_MNTENT_H
+#  include <mntent.h>
+#endif
+#ifndef PLATFORM_HAS_NO_VFS_H
+#  include <sys/vfs.h>
+#endif
 
 #ifndef XFS_XFLAG_NODEFRAG
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
@@ -43,6 +49,14 @@
 #define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
+#ifdef USE_DUMMY_XATTR
+	/* OS X has fsetxattr with different number of arguments.
+	 * Because it won't work anyway (no fstab/mtab and so on),
+	 * hijack the call to a dummy function so it can at least
+	 * compile.
+	 */
+#  define fsetxattr(a,b,c,d,e) dummy_fsetxattr(a,b,c,d,e)
+#endif
 
 char *progname;
 
diff --git a/include/bitops.h b/include/bitops.h
index 930f64a..44599a7 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -5,6 +5,7 @@
  * fls: find last bit set.
  */
 
+#ifndef HAVE_FLS
 static inline int fls(int x)
 {
 	int r = 32;
@@ -32,6 +33,7 @@ static inline int fls(int x)
 	}
 	return r;
 }
+#endif /* HAVE_FLS */
 
 static inline int fls64(__u64 x)
 {
diff --git a/include/builddefs.in b/include/builddefs.in
index 7e9f53d..9feb096 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -104,6 +104,7 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
+HAVE_FLS = @have_fls@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -119,7 +120,7 @@ ifeq ($(PKG_PLATFORM),gnukfreebsd)
 PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 endif
 ifeq ($(PKG_PLATFORM),darwin)
-PCFLAGS = -traditional-cpp $(GCCFLAGS)
+PCFLAGS = $(GCCFLAGS)
 DEPENDFLAGS = -D__APPLE__
 endif
 ifeq ($(PKG_PLATFORM),irix)
@@ -131,6 +132,9 @@ PLDLIBS = -L/usr/local/lib -lintl
 PCFLAGS = -I/usr/local/include $(GCCFLAGS)
 DEPENDFLAGS = -D__FreeBSD__
 endif
+ifeq ($(HAVE_FLS),yes)
+LCFLAGS+= -DHAVE_FLS
+endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/include/darwin.h b/include/darwin.h
index 30f0052..0d82872 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -18,17 +18,26 @@
 #ifndef __XFS_DARWIN_H__
 #define __XFS_DARWIN_H__
 
+#define PLATFORM_HAS_NO_MALLOC_H
+#define PLATFORM_HAS_NO_MNTENT_H
+#define PLATFORM_HAS_NO_VFS_H
+
 #include <uuid/uuid.h>
 #include <libgen.h>
 #include <sys/vm.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
+#include <sys/types.h>
+#include <ftw.h>
+#include <mach/mach_time.h>
+#include <inttypes.h>
+#include <stdio.h>
 
 #include <machine/endian.h>
-#define __BYTE_ORDER	BYTE_ORDER
-#define __BIG_ENDIAN	BIG_ENDIAN
-#define __LITTLE_ENDIAN	LITTLE_ENDIAN
+#define __BYTE_ORDER   BYTE_ORDER
+#define __BIG_ENDIAN   BIG_ENDIAN
+#define __LITTLE_ENDIAN        LITTLE_ENDIAN
 
 #include <sys/syscall.h>
 # ifndef SYS_fsctl
@@ -68,45 +77,37 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	return uuid_compare(uu1, uu2, NULL);
+	return uuid_compare((const unsigned char *) uu1, (const unsigned char*) uu2);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	uint32_t status;
-	char *s;
-	uuid_to_string(uu, &s, &status);
-	if (status == uuid_s_ok)
-		strcpy(buffer, s);
-	else buffer[0] = '\0';
-	free(s);
+	uuid_unparse(*uu, buffer);
 }
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	uint32_t status;
-	uuid_from_string(buffer, uu, &status);
-	return (status == uuid_s_ok);
+	return uuid_parse(buffer, *uu);
 }
 
 static __inline__ int platform_uuid_is_null(uuid_t *uu)
 {
-	return uuid_is_nil(uu, NULL);
+	return uuid_is_null(*uu);
 }
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	uuid_create(uu, NULL);
+	uuid_generate(*uu);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	uuid_create_nil(uu, NULL);
+	uuid_clear(*uu);
 }
 
 static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 {
-	memcpy(dst, src, sizeof(uuid_t));
+	uuid_copy(*dst, *src);
 }
 
 #define __int8_t	int8_t
@@ -142,11 +143,13 @@ typedef int64_t		xfs_daddr_t;
 #define O_SYNC          0
 #endif
 
-#define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
 
+#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
+#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */
+
 #define HAVE_FID	1
 
 static __inline__ int
@@ -155,4 +158,131 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+
+/*
+ * Dummy POSIX timer replacement
+ */
+#define CLOCK_REALTIME 1
+typedef uint64_t timer_t;
+typedef double   timer_c;
+typedef clock_id_t clockid_t;
+struct itimerspec
+  {
+    struct timespec it_interval;
+    struct timespec it_value;
+  };
+
+static inline int timer_create (clockid_t __clock_id,
+                         struct sigevent *__restrict __evp,
+                         timer_t *__restrict __timerid)
+{
+	return 0;
+}
+
+static inline int timer_settime (timer_t __timerid, int __flags,
+                          const struct itimerspec *__restrict __value,
+                          struct itimerspec *__restrict __ovalue)
+{
+	return 0;
+}
+
+static inline int timer_delete (timer_t __timerid)
+{
+	return 0;
+}
+
+static inline int timer_gettime (timer_t __timerid, struct itimerspec *__value)
+{
+	return 0;
+}
+
+static inline int nftw64(const char *path, int (*fn)(const char *, const struct stat *ptr, int flag, struct FTW *), int depth,
+         int flags)
+{
+	return nftw(path, fn, depth, flags);
+}
+
+#define MREMAP_FIXED 1
+#define MREMAP_MAYMOVE 2
+static inline void *mremap(void *old_address, size_t old_size,
+                    size_t new_size, int flags, ... /* void *new_address */)
+{
+	return NULL;
+}
+
+/* FSR */
+
+#define		_PATH_MOUNTED   "/etc/mtab"
+#define		USE_DUMMY_XATTR
+
+typedef int __fsblkcnt_t;
+typedef int __fsfilcnt_t;
+typedef long long int __fsblkcnt64_t;
+typedef long long int __fsfilcnt64_t;
+
+struct statvfs64
+{
+	unsigned long int f_bsize;
+	unsigned long int f_frsize;
+	__fsblkcnt64_t f_blocks;
+	__fsblkcnt64_t f_bfree;
+	__fsblkcnt64_t f_bavail;
+	__fsfilcnt64_t f_files;
+	__fsfilcnt64_t f_ffree;
+	__fsfilcnt64_t f_favail;
+	unsigned long int f_fsid;
+	int __f_unused;
+	unsigned long int f_flag;
+	unsigned long int f_namemax;
+	int __f_spare[6];
+};
+
+struct mntent
+{
+	char *mnt_fsname;		/* Device or server for filesystem.  */
+	char *mnt_dir;		/* Directory mounted on.  */
+	char *mnt_type;		/* Type of filesystem: ufs, nfs, etc.  */
+	char *mnt_opts;		/* Comma-separated options for fs.  */
+	int mnt_freq;		/* Dump frequency (in days).  */
+	int mnt_passno;		/* Pass number for `fsck'.  */
+};
+
+static inline FILE *setmntent(const char *filename, const char *type)
+{
+	return NULL;
+}
+
+static inline int endmntent(FILE *fp)
+{
+	return 0;
+}
+
+static inline struct mntent *getmntent(FILE *fp)
+{
+	return NULL;
+}
+
+static inline int addmntent(FILE *fp, const struct mntent *mnt)
+{
+	return 0;
+}
+
+static inline char *hasmntopt(const struct mntent *mnt, const char *opt)
+{
+	return NULL;
+}
+
+static inline int statvfs64 (const char *__restrict __file, 
+							 struct statvfs64 *__restrict __buf)
+{
+	return 0;
+}
+
+static inline int dummy_fsetxattr (int filedes, const char *name,
+                       const void *value, size_t size, int flags)
+{
+	return 0;
+}
+
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/io/readdir.c b/io/readdir.c
index 20b8898..ed8f04d 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -104,12 +104,16 @@ read_directory(
 		if (!dirent)
 			break;
 
+#ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
+#endif
 		count++;
 
 		if (dump) {
 			dump_dirent(offset, dirent);
+#ifdef _DIRENT_HAVE_D_OFF
 			offset = dirent->d_off;
+#endif
 		}
 	}
 
diff --git a/libdisk/fstype.c b/libdisk/fstype.c
index 548f297..c8bde34 100644
--- a/libdisk/fstype.c
+++ b/libdisk/fstype.c
@@ -22,6 +22,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include "fstype.h"
 
 /*
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 865ca22..0b5e1ad 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -10,7 +10,11 @@ LT_CURRENT = 1
 LT_REVISION = 3
 LT_AGE = 0
 
+ifeq ($(PKG_PLATFORM),darwin)
+LTLDFLAGS += -Wl,libhandle.sym
+else
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
+endif
 
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index c0b1ddb..b360617 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -364,7 +364,7 @@ fs_table_initialise_mounts(
 			continue;
 		if (!realpath(stats[i].f_mntfromname, rmntfromname))
 			continue;
-		if (!realpath(stats[i].f_mntonname, rmnttomname)))
+		if (!realpath(stats[i].f_mntonname, rmntonname))
 			continue;
 
 		if (path &&
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 919ae0a..d7f37ca 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -202,3 +202,17 @@ AC_DEFUN([AC_HAVE_READDIR],
     AC_SUBST(have_readdir)
   ])
 
+#
+# Check if we have a flc call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FLS],
+  [ AC_MSG_CHECKING([for fls])
+    AC_TRY_LINK([
+#include <string.h>
+    ], [
+         fls(0);
+    ], have_fls=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fls)
+  ])
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
