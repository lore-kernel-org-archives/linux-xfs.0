Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D63CD7F37
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 11:04:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B4FE58F804C
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 09:04:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2bIRiFlOdCzYxUCK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2015 09:04:18 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 12/14 v2] xfsprogs: make fsr use mntinfo when there is no
	mntent
Date: Tue, 29 Sep 2015 18:04:13 +0200
Message-Id: <1443542653-10525-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-13-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-13-git-send-email-jtulak@redhat.com>
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

UPDATE:
- refactor ifdefs to platform_ functions

For what fsr needs, mntinfo can be used instead of mntent on some
platforms. Exctract the platform-specific code to platform headers.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/Makefile          |   8 ++++
 fsr/xfs_fsr.c         | 127 +++++++++++++++++++++++++++++++-------------------
 include/darwin.h      |  64 +++++++++++++++++++++++++
 include/freebsd.h     |  32 +++++++++++++
 include/gnukfreebsd.h |  31 ++++++++++++
 include/irix.h        |  32 +++++++++++++
 include/linux.h       |  31 ++++++++++++
 7 files changed, 276 insertions(+), 49 deletions(-)

diff --git a/fsr/Makefile b/fsr/Makefile
index a9d1bf6..d3521b2 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -9,6 +9,14 @@ LTCOMMAND = xfs_fsr
 CFILES = xfs_fsr.c
 LLDLIBS = $(LIBHANDLE)
 
+ifeq ($(HAVE_GETMNTENT),yes)
+LCFLAGS += -DHAVE_GETMNTENT
+endif
+
+ifeq ($(HAVE_GETMNTINFO),yes)
+LCFLAGS += -DHAVE_GETMNTINFO
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index c8ef18f..d7087d4 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -32,10 +32,6 @@
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
 
-#ifdef HAVE_MNTENT
-#  include <mntent.h>
-#endif
-
 #ifndef XFS_XFLAG_NODEFRAG
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
 #endif
@@ -174,60 +170,69 @@ aborter(int unused)
 	exit(1);
 }
 
+
+
 /*
  * Check if the argument is either the device name or mountpoint of an XFS
  * filesystem.  Note that we do not care about bind mounted regular files
  * here - the code that handles defragmentation of invidual files takes care
  * of that.
  */
+
 static char *
-find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
+find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 ms)
 {
-	struct mntent *t;
-	struct stat64 ms;
-	FILE *mtabp;
-	char *mntp = NULL;
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return NULL;
+		if (sb->st_ino != ms.st_ino)
+			return NULL;
+		if (sb->st_dev != ms.st_dev)
+			return NULL;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
+	} else {				/* device */
+		struct stat64 sb2;
+
+		if (stat64(t->mnt_fsname, &ms) < 0)
+			return NULL;
+		if (sb->st_rdev != ms.st_rdev)
+			return NULL;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
 
-	mtabp = setmntent(mtab, "r");
-	if (!mtabp) {
-		fprintf(stderr, _("%s: cannot read %s\n"),
-			progname, mtab);
-		exit(1);
+		/*
+			* Make sure the mountpoint given by mtab is accessible
+			* before using it.
+			*/
+		if (stat64(t->mnt_dir, &sb2) < 0)
+			return NULL;
 	}
 
-	while ((t = getmntent(mtabp))) {
-		if (S_ISDIR(sb->st_mode)) {		/* mount point */
-			if (stat64(t->mnt_dir, &ms) < 0)
-				continue;
-			if (sb->st_ino != ms.st_ino)
-				continue;
-			if (sb->st_dev != ms.st_dev)
-				continue;
-			if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
-				continue;
-		} else {				/* device */
-			struct stat64 sb2;
+	return t->mnt_dir;
 
-			if (stat64(t->mnt_fsname, &ms) < 0)
-				continue;
-			if (sb->st_rdev != ms.st_rdev)
-				continue;
-			if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
-				continue;
+}
 
-			/*
-			 * Make sure the mountpoint given by mtab is accessible
-			 * before using it.
-			 */
-			if (stat64(t->mnt_dir, &sb2) < 0)
-				continue;
-		}
+static char *
+find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
+{
+	struct mntent_cursor cursor;
+	struct stat64 ms;
+	struct mntent t = {};
+	char *mntp = NULL;
 
-		mntp = t->mnt_dir;
+	if (platform_mntent_open(&cursor, mtab) != 0){
+		fprintf(stderr, "Error: can't get mntent entries.\n");
+		exit(1);
+	}
+		
+	while (platform_mntent_next(&cursor, &t) == 0) {
+		mntp = find_mountpoint_check(sb, &t, ms);
+		if (mntp == NULL)
+			continue;
 		break;
 	}
-
-	endmntent(mtabp);
+	platform_mntent_close(&cursor);
 	return mntp;
 }
 
@@ -405,18 +410,11 @@ usage(int ret)
 static void
 initallfs(char *mtab)
 {
-	FILE *fp;
 	struct mntent *mp;
 	int mi;
 	char *cp;
 	struct stat64 sb;
 
-	fp = setmntent(mtab, "r");
-	if (fp == NULL) {
-		fsrprintf(_("could not open mtab file: %s\n"), mtab);
-		exit(1);
-	}
-
 	/* malloc a number of descriptors, increased later if needed */
 	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
 		fsrprintf(_("out of memory: %s\n"), strerror(errno));
@@ -427,7 +425,36 @@ initallfs(char *mtab)
 	/* find all rw xfs file systems */
 	mi = 0;
 	fs = fsbase;
+
+#if defined(HAVE_GETMNTENT)
+	FILE *fp;
+	fp = setmntent(mtab, "r");
+	if (fp == NULL) {
+		fsrprintf(_("could not open mtab file: %s\n"), mtab);
+		exit(1);
+	}
+
 	while ((mp = getmntent(fp))) {
+#elif defined(HAVE_GETMNTINFO)
+	struct statfs	*stats;
+	int error, i, count;
+	// because "t" is a pointer, but we don't need to use
+	// malloc for this usage
+	struct mntent mp_tmp;
+	mp = &mp_tmp;
+	error = 0;
+	if ((count = getmntinfo(&stats, 0)) < 0) {
+		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
+				progname, strerror(errno));
+		exit(1);
+	}
+
+	for (i = 0; i < count; i++) {
+		mntinfo2mntent(&stats[i], mp);
+#else
+# error "How do I extract info about mounted filesystems on this platform?"
+#endif
+
 		int rw = 0;
 
 		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
@@ -479,7 +506,9 @@ initallfs(char *mtab)
 	}
 	numfs = mi;
 	fsend = (fsbase + numfs);
+#if defined(HAVE_GETMNTENT)
 	endmntent(fp);
+#endif
 	if (numfs == 0) {
 		fsrprintf(_("no rw xfs file systems in mtab: %s\n"), mtab);
 		exit(0);
diff --git a/include/darwin.h b/include/darwin.h
index 288ad1f..fd9384d 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -33,6 +33,8 @@
 #include <mach/mach_time.h>
 #include <inttypes.h>
 #include <stdio.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
 
 #include <machine/endian.h>
 #define __BYTE_ORDER	BYTE_ORDER
@@ -218,7 +220,69 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 
 /* FSR */
 
+#  include <sys/mount.h>
+#  include <sys/param.h>
+#include <sys/ucred.h>
+#include <errno.h>
 #define statvfs64 statfs
 #define		_PATH_MOUNTED   "/etc/mtab"
 
+struct mntent
+{
+	char *mnt_fsname;
+	char *mnt_dir;
+	char *mnt_type;
+	char *mnt_opts;
+	int mnt_freq;
+	int mnt_passno;
+};
+
+static inline void mntinfo2mntent (struct statfs * stats, struct mntent * mnt) {
+	mnt->mnt_fsname = stats->f_mntfromname;
+	mnt->mnt_dir = stats->f_mntonname;
+	mnt->mnt_type = stats->f_fstypename;
+}
+
+
+
+/**
+ * Abstraction of mountpoints.
+ */
+struct mntent_cursor {
+	FILE *mtabp;
+	struct statfs *stats;
+	int count;
+	int i;
+};
+
+/**
+ * OS X uses getmntinfo, which doesn't use a mtab file. So we just ignore it.
+ */
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{	
+	if ((cursor->count = getmntinfo(&cursor->stats, 0)) < 0) {
+		fprintf(stderr, "Error: getmntinfo() failed: %s\n", strerror(errno));
+		return 1;
+	}
+	cursor->i = 0;
+	return 0;
+}
+
+static inline int platform_mntent_next(struct mntent_cursor * cursor, struct mntent * t)
+{
+	if (cursor->i >= cursor->count){
+		return 1;
+	}
+	mntinfo2mntent(&cursor->stats[cursor->i], t);
+	cursor->i++;
+	return 0;
+
+}
+
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	cursor->count = 0;
+	cursor->i = 0;
+}
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/include/freebsd.h b/include/freebsd.h
index 902b940..6bc9e61 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -26,6 +26,7 @@
 #include <libgen.h>
 #include <paths.h>
 #include <uuid.h>
+#include <mntent.h>
 
 #include <sys/endian.h>
 #define __BYTE_ORDER	BYTE_ORDER
@@ -147,4 +148,35 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+/**
+ * Abstraction of mountpoints.
+ */
+struct mntent_cursor {
+	FILE *mtabp;
+};
+
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{
+	cursor->mtabp = setmntent(mtab, "r");
+	if (!cursor->mtabp) {
+		fprintf(stderr, "Error: cannot read %s\n", mtab);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int platform_mntent_next(struct mntent_cursor * cursor, struct mntent * t)
+{
+	t = getmntent(cursor->mtabp);
+	if (t == NULL)
+		return 1;
+	return 0;
+}
+
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	endmntent(cursor->mtabp);
+}
+
+
 #endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 95c4c13..2740cae 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -31,6 +31,7 @@
 #include <ctype.h>
 #include <libgen.h>
 #include <paths.h>
+#include <mntent.h>
 
 #define constpp	char * const *
 
@@ -126,4 +127,34 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+/**
+ * Abstraction of mountpoints.
+ */
+struct mntent_cursor {
+	FILE *mtabp;
+};
+
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{
+	cursor->mtabp = setmntent(mtab, "r");
+	if (!cursor->mtabp) {
+		fprintf(stderr, "Error: cannot read %s\n", mtab);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int platform_mntent_next(struct mntent_cursor * cursor, struct mntent * t)
+{
+	t = getmntent(cursor->mtabp);
+	if (t == NULL)
+		return 1;
+	return 0;
+}
+
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	endmntent(cursor->mtabp);
+}
+
 #endif	/* __XFS_KFREEBSD_H__ */
diff --git a/include/irix.h b/include/irix.h
index 28564c8..cb9cce0 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -37,6 +37,7 @@
 #include <sys/sysmacros.h>
 #include <sys/fs/xfs_fsops.h>
 #include <sys/fs/xfs_itable.h>
+#include <mntent.h>
 
 #define __int8_t	char
 #define __int16_t	short
@@ -423,4 +424,35 @@ static __inline__ char * strsep(char **s, const char *ct)
 
 #define	XFS_XFLAG_NODEFRAG		0x00002000
 
+/**
+ * Abstraction of mountpoints.
+ */
+struct mntent_cursor {
+	FILE *mtabp;
+};
+
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{
+	cursor->mtabp = setmntent(mtab, "r");
+	if (!cursor->mtabp) {
+		fprintf(stderr, "Error: cannot read %s\n", mtab);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int platform_mntent_next(struct mntent_cursor * cursor, struct mntent * t)
+{
+	t = getmntent(cursor->mtabp);
+	if (t == NULL)
+		return 1;
+	return 0;
+}
+
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	endmntent(cursor->mtabp);
+}
+
+
 #endif	/* __XFS_IRIX_H__ */
diff --git a/include/linux.h b/include/linux.h
index 8804c2d..437970b 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -30,6 +30,7 @@
 #include <endian.h>
 #include <stdbool.h>
 #include <asm/types.h>
+#include <mntent.h>
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
@@ -145,4 +146,34 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 
+/**
+ * Abstraction of mountpoints.
+ */
+struct mntent_cursor {
+	FILE *mtabp;
+};
+
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{
+	cursor->mtabp = setmntent(mtab, "r");
+	if (!cursor->mtabp) {
+		fprintf(stderr, "Error: cannot read %s\n", mtab);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int platform_mntent_next(struct mntent_cursor * cursor, struct mntent * t)
+{
+	t = getmntent(cursor->mtabp);
+	if (t == NULL)
+		return 1;
+	return 0;
+}
+
+static inline void platform_mntent_close(struct mntent_cursor * cursor)
+{
+	endmntent(cursor->mtabp);
+}
+
 #endif	/* __XFS_LINUX_H__ */
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
