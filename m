Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 820977F67
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 06:01:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32FA8304032
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 04:01:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xZIeeBsbH1eSnlP2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2015 04:01:33 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 085F7319ADE
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2015 11:01:33 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsprogs: make fsr use mntinfo when there is no mntent
Date: Tue, 20 Oct 2015 13:01:23 +0200
Message-Id: <1445338883-7000-1-git-send-email-jtulak@redhat.com>
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

I'm resubmitting this patch from my OS X set - it wasn't included with
others, nor in the current for-next, and I didn't got any review/reply
to this last iteration.

So my guess is it fell under the sofa, forgotten... :-)

.........

UPDATE:
- refactor ifdefs to platform_ functions
- refactor also the other ifdef which I forgot to change before
- (and rebase against current for-next)

For what fsr needs, mntinfo can be used instead of mntent on some
platforms. Exctract the platform-specific code to platform headers.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/Makefile          |   8 ++++
 fsr/xfs_fsr.c         | 111 +++++++++++++++++++++++++++-----------------------
 include/darwin.h      |  62 ++++++++++++++++++++++++++++
 include/freebsd.h     |  32 +++++++++++++++
 include/gnukfreebsd.h |  31 ++++++++++++++
 include/irix.h        |  32 +++++++++++++++
 include/linux.h       |  31 ++++++++++++++
 7 files changed, 257 insertions(+), 50 deletions(-)

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
index c8ef18f..fa7f8cf 100644
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
@@ -180,54 +176,61 @@ aborter(int unused)
  * here - the code that handles defragmentation of invidual files takes care
  * of that.
  */
+
+static char *
+find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 *ms)
+{
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return NULL;
+		if (sb->st_ino != ms->st_ino)
+			return NULL;
+		if (sb->st_dev != ms->st_dev)
+			return NULL;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
+	} else {				/* device */
+		struct stat64 sb2;
+
+		if (stat64(t->mnt_fsname, &ms) < 0)
+			return NULL;
+		if (sb->st_rdev != ms->st_rdev)
+			return NULL;
+		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
+			return NULL;
+
+		/*
+			* Make sure the mountpoint given by mtab is accessible
+			* before using it.
+			*/
+		if (stat64(t->mnt_dir, &sb2) < 0)
+			return NULL;
+	}
+
+	return t->mnt_dir;
+
+}
+
 static char *
 find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 {
-	struct mntent *t;
+	struct mntent_cursor cursor;
 	struct stat64 ms;
-	FILE *mtabp;
+	struct mntent t = {};
 	char *mntp = NULL;
 
-	mtabp = setmntent(mtab, "r");
-	if (!mtabp) {
-		fprintf(stderr, _("%s: cannot read %s\n"),
-			progname, mtab);
+	if (platform_mntent_open(&cursor, mtab) != 0){
+		fprintf(stderr, "Error: can't get mntent entries.\n");
 		exit(1);
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
-
-			if (stat64(t->mnt_fsname, &ms) < 0)
-				continue;
-			if (sb->st_rdev != ms.st_rdev)
-				continue;
-			if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
-				continue;
-
-			/*
-			 * Make sure the mountpoint given by mtab is accessible
-			 * before using it.
-			 */
-			if (stat64(t->mnt_dir, &sb2) < 0)
-				continue;
-		}
-
-		mntp = t->mnt_dir;
+	while (platform_mntent_next(&cursor, &t) == 0) {
+		mntp = find_mountpoint_check(sb, &t, &ms);
+		if (mntp == NULL)
+			continue;
 		break;
 	}
-
-	endmntent(mtabp);
+	platform_mntent_close(&cursor);
 	return mntp;
 }
 
@@ -405,17 +408,13 @@ usage(int ret)
 static void
 initallfs(char *mtab)
 {
-	FILE *fp;
+	struct mntent_cursor cursor;
+	char *mntp = NULL;
 	struct mntent *mp;
 	int mi;
 	char *cp;
 	struct stat64 sb;
-
-	fp = setmntent(mtab, "r");
-	if (fp == NULL) {
-		fsrprintf(_("could not open mtab file: %s\n"), mtab);
-		exit(1);
-	}
+	struct stat64 ms;
 
 	/* malloc a number of descriptors, increased later if needed */
 	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
@@ -427,7 +426,18 @@ initallfs(char *mtab)
 	/* find all rw xfs file systems */
 	mi = 0;
 	fs = fsbase;
-	while ((mp = getmntent(fp))) {
+
+	if (platform_mntent_open(&cursor, mtab) != 0){
+		fprintf(stderr, "Error: can't get mntent entries.\n");
+		exit(1);
+	}
+
+	while (platform_mntent_next(&cursor, &mp) == 0) {
+		mntp = find_mountpoint_check(&sb, &mp, &ms);
+		if (mntp == NULL)
+			continue;
+		break;
+
 		int rw = 0;
 
 		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
@@ -477,9 +487,10 @@ initallfs(char *mtab)
 		mi++;
 		fs++;
 	}
+	platform_mntent_close(&cursor);
+
 	numfs = mi;
 	fsend = (fsbase + numfs);
-	endmntent(fp);
 	if (numfs == 0) {
 		fsrprintf(_("no rw xfs file systems in mtab: %s\n"), mtab);
 		exit(0);
diff --git a/include/darwin.h b/include/darwin.h
index 6c6e547..3eef3e3 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -219,8 +219,70 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 
 /* FSR */
 
+#  include <sys/mount.h>
+#  include <sys/param.h>
+#include <sys/ucred.h>
+#include <errno.h>
 #define statvfs64 statfs
 #define lstat64 lstat
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
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
