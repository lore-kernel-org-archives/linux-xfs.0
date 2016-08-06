Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DAE47CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22A9FAC002
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:35 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id 5TgPS9lgydrLE2Zj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:31 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id D517320449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:29 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTD86rrKz1048
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:28 +0200 (CEST)
Resent-Message-ID: <20160813172432.GB3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <cc6dba8dc1c5e2110aba511739dde78b0049063c.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:43 +0200
Subject: [PATCHv2 xfsprogs 04/14] replace [fl]stat64 by equivalent [fl]stat
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3794373344813975276=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3794373344813975276==
Content-Type: text/plain

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c           |  8 ++++----
 fsr/xfs_fsr.c             | 34 +++++++++++++++++-----------------
 include/darwin.h          |  5 +----
 include/freebsd.h         |  2 --
 io/copy_file_range.c      |  6 +++---
 io/open.c                 | 18 +++++++++---------
 io/sendfile.c             |  6 +++---
 libxcmd/paths.c           |  4 ++--
 libxfs/darwin.c           |  8 ++++----
 libxfs/freebsd.c          |  8 ++++----
 libxfs/init.c             | 12 ++++++------
 libxfs/init.h             |  6 +++---
 libxfs/irix.c             |  8 ++++----
 libxfs/linux.c            | 20 ++++++++++----------
 mdrestore/xfs_mdrestore.c |  6 +++---
 mkfs/proto.c              |  4 ++--
 mkfs/xfs_mkfs.c           |  4 ++--
 po/de.po                  |  8 ++++----
 po/pl.po                  |  8 ++++----
 repair/xfs_repair.c       |  4 ++--
 rtcp/xfs_rtcp.c           | 18 +++++++++---------
 21 files changed, 96 insertions(+), 101 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3c8998c..55a9e2c 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -28,7 +28,7 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
 
-extern int	platform_check_ismounted(char *, char *, struct stat64 *, int);
+extern int	platform_check_ismounted(char *, char *, struct stat *, int);
 
 int		logfd;
 char 		*logfile_name;
@@ -560,7 +560,7 @@ main(int argc, char **argv)
 	extern int	optind;
 	libxfs_init_t	xargs;
 	thread_args	*tcarg;
-	struct stat64	statbuf;
+	struct stat	statbuf;
 
 	progname = basename(argv[0]);
 
@@ -641,7 +641,7 @@ main(int argc, char **argv)
 		die_perror();
 	}
 
-	if (fstat64(source_fd, &statbuf) < 0)  {
+	if (fstat(source_fd, &statbuf) < 0)  {
 		do_log(_("%s:  couldn't stat source \"%s\"\n"),
 			progname, source_name);
 		die_perror();
@@ -792,7 +792,7 @@ main(int argc, char **argv)
 	for (i = 0; i < num_targets; i++)  {
 		int	write_last_block = 0;
 
-		if (stat64(target[i].name, &statbuf) < 0)  {
+		if (stat(target[i].name, &statbuf) < 0)  {
 			/* ok, assume it's a file and create it */
 
 			do_out(_("Creating file %s\n"), target[i].name);
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index d75990a..36e0705 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -174,12 +174,12 @@ aborter(int unused)
  * of that.
  */
 static char *
-find_mountpoint_check(struct stat64 *sb, struct mntent *t)
+find_mountpoint_check(struct stat *sb, struct mntent *t)
 {
-	struct stat64 ms;
+	struct stat ms;
 
 	if (S_ISDIR(sb->st_mode)) {		/* mount point */
-		if (stat64(t->mnt_dir, &ms) < 0)
+		if (stat(t->mnt_dir, &ms) < 0)
 			return NULL;
 		if (sb->st_ino != ms.st_ino)
 			return NULL;
@@ -188,7 +188,7 @@ find_mountpoint_check(struct stat64 *sb, struct mntent *t)
 		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
 			return NULL;
 	} else {				/* device */
-		if (stat64(t->mnt_fsname, &ms) < 0)
+		if (stat(t->mnt_fsname, &ms) < 0)
 			return NULL;
 		if (sb->st_rdev != ms.st_rdev)
 			return NULL;
@@ -198,7 +198,7 @@ find_mountpoint_check(struct stat64 *sb, struct mntent *t)
 		 * Make sure the mountpoint given by mtab is accessible
 		 * before using it.
 		 */
-		if (stat64(t->mnt_dir, &ms) < 0)
+		if (stat(t->mnt_dir, &ms) < 0)
 			return NULL;
 	}
 
@@ -206,7 +206,7 @@ find_mountpoint_check(struct stat64 *sb, struct mntent *t)
 }
 
 static char *
-find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
+find_mountpoint(char *mtab, char *argname, struct stat *sb)
 {
 	struct mntent_cursor cursor;
 	struct mntent *t = NULL;
@@ -230,7 +230,7 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 int
 main(int argc, char **argv)
 {
-	struct stat64 sb;
+	struct stat sb;
 	char *argname;
 	int c;
 	char *mntp;
@@ -327,7 +327,7 @@ main(int argc, char **argv)
 		for (; optind < argc; optind++) {
 			argname = argv[optind];
 
-			if (lstat64(argname, &sb) < 0) {
+			if (lstat(argname, &sb) < 0) {
 				fprintf(stderr,
 					_("%s: could not stat: %s: %s\n"),
 					progname, argname, strerror(errno));
@@ -335,9 +335,9 @@ main(int argc, char **argv)
 			}
 
 			if (S_ISLNK(sb.st_mode)) {
-				struct stat64 sb2;
+				struct stat sb2;
 
-				if (stat64(argname, &sb2) == 0 &&
+				if (stat(argname, &sb2) == 0 &&
 				    (S_ISBLK(sb2.st_mode) ||
 				     S_ISCHR(sb2.st_mode)))
 				sb = sb2;
@@ -405,7 +405,7 @@ initallfs(char *mtab)
 	struct mntent *mnt= NULL;
 	int mi;
 	char *cp;
-	struct stat64 sb;
+	struct stat sb;
 
 	/* malloc a number of descriptors, increased later if needed */
 	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
@@ -427,7 +427,7 @@ initallfs(char *mtab)
 		int rw = 0;
 
 		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
-		    stat64(mnt->mnt_fsname, &sb) == -1 ||
+		    stat(mnt->mnt_fsname, &sb) == -1 ||
 		    !S_ISBLK(sb.st_mode))
 			continue;
 
@@ -502,7 +502,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	char *ptr;
 	xfs_ino_t startino = 0;
 	fsdesc_t *fsp;
-	struct stat64 sb, sb2;
+	struct stat sb, sb2;
 
 	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
 
@@ -510,11 +510,11 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	fs = fsbase;
 
 	/* where'd we leave off last time? */
-	if (lstat64(leftofffile, &sb) == 0) {
+	if (lstat(leftofffile, &sb) == 0) {
 		if ( (fd = open(leftofffile, O_RDONLY)) == -1 ) {
 			fsrprintf(_("%s: open failed\n"), leftofffile);
 		}
-		else if ( fstat64(fd, &sb2) == 0) {
+		else if ( fstat(fd, &sb2) == 0) {
 			/*
 			 * Verify that lstat & fstat point to the
 			 * same regular file (no links/no quick spoofs)
@@ -1027,7 +1027,7 @@ fsr_setup_attr_fork(
 	xfs_bstat_t	*bstatp)
 {
 #ifdef HAVE_FSETXATTR
-	struct stat64	tstatbuf;
+	struct stat	tstatbuf;
 	int		i;
 	int		diff = 0;
 	int		last_forkoff = 0;
@@ -1054,7 +1054,7 @@ fsr_setup_attr_fork(
 
 	/* attr2 w/ fork offsets */
 
-	if (fstat64(tfd, &tstatbuf) < 0) {
+	if (fstat(tfd, &tstatbuf) < 0) {
 		fsrprintf(_("unable to stat temp file: %s\n"),
 					strerror(errno));
 		return -1;
diff --git a/include/darwin.h b/include/darwin.h
index 45e0c03..8708324 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -141,8 +141,6 @@ typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
-#define stat64		stat
-#define fstat64		fstat
 #define lseek64		lseek
 #define pread64		pread
 #define pwrite64	pwrite
@@ -222,8 +220,7 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 #  include <sys/param.h>
 #include <sys/ucred.h>
 #include <errno.h>
-#define statvfs64 statfs
-#define lstat64 lstat
+#define statvfs64	statfs
 #define		_PATH_MOUNTED   "/etc/mtab"
 
 struct mntent
diff --git a/include/freebsd.h b/include/freebsd.h
index 6e77427..f7ab8fa 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -34,10 +34,8 @@
 #define __LITTLE_ENDIAN	LITTLE_ENDIAN
 
 /* FreeBSD file API is 64-bit aware */
-#define fstat64		fstat
 #define ftruncate64	ftruncate
 #define lseek64		lseek
-#define stat64		stat
 #define pwrite64	pwrite
 #define pread64		pread
 #define fdatasync	fsync
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index eddc634..7ba42b6 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -60,10 +60,10 @@ copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
 static off64_t
 copy_src_filesize(int fd)
 {
-	struct stat64 st;
+	struct stat st;
 
-	if (fstat64(fd, &st) < 0) {
-		perror("fstat64");
+	if (fstat(fd, &st) < 0) {
+		perror("fstat");
 		return -1;
 	};
 	return st.st_size;
diff --git a/io/open.c b/io/open.c
index 2303527..d4ec13c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -52,10 +52,10 @@ static long extsize;
 off64_t
 filesize(void)
 {
-	struct stat64	st;
+	struct stat	st;
 
-	if (fstat64(file->fd, &st) < 0) {
-		perror("fstat64");
+	if (fstat(file->fd, &st) < 0) {
+		perror("fstat");
 		return -1;
 	}
 	return st.st_size;
@@ -90,7 +90,7 @@ stat_f(
 {
 	struct dioattr	dio;
 	struct fsxattr	fsx, fsxa;
-	struct stat64	st;
+	struct stat	st;
 	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
@@ -102,8 +102,8 @@ stat_f(
 		file->flags & IO_APPEND ? _(",append-only") : "",
 		file->flags & IO_NONBLOCK ? _(",non-block") : "",
 		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
-	if (fstat64(file->fd, &st) < 0) {
-		perror("fstat64");
+	if (fstat(file->fd, &st) < 0) {
+		perror("fstat");
 	} else {
 		printf(_("stat.ino = %lld\n"), (long long)st.st_ino);
 		printf(_("stat.type = %s\n"), filetype(st.st_mode));
@@ -574,10 +574,10 @@ static int
 set_extsize(const char *path, int fd, long extsz)
 {
 	struct fsxattr	fsx;
-	struct stat64	stat;
+	struct stat	stat;
 
-	if (fstat64(fd, &stat) < 0) {
-		perror("fstat64");
+	if (fstat(fd, &stat) < 0) {
+		perror("fstat");
 		return 0;
 	}
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
diff --git a/io/sendfile.c b/io/sendfile.c
index 21ab444..c082acf 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -133,10 +133,10 @@ sendfile_f(
 			goto done;
 		}
 	} else {
-		struct stat64	stat;
+		struct stat	stat;
 
-		if (fstat64(fd, &stat) < 0) {
-			perror("fstat64");
+		if (fstat(fd, &stat) < 0) {
+			perror("fstat");
 			goto done;
 		}
 		count = stat.st_size;
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 71af25f..bd91ae0 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -43,9 +43,9 @@ fs_device_number(
 	const char	*name,
 	dev_t		*devnum)
 {
-	struct stat64	sbuf;
+	struct stat	sbuf;
 
-	if (stat64(name, &sbuf) < 0)
+	if (stat(name, &sbuf) < 0)
 		return errno;
 	/*
 	 * We want to match st_rdev if the path provided is a device
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index 017e190..bc552ba 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -27,13 +27,13 @@ int platform_has_uuid = 1;
 extern char *progname;
 
 int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	return 0;
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat *s, int fatal)
 {
 	int	fd, writable;
 
@@ -69,9 +69,9 @@ void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	__uint64_t	size;
-	struct stat64	st;
+	struct stat	st;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr,
 			_("%s: cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
index 6c9f089..1f1b5b9 100644
--- a/libxfs/freebsd.c
+++ b/libxfs/freebsd.c
@@ -27,14 +27,14 @@ int platform_has_uuid = 1;
 extern char *progname;
 
 int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
-	struct stat64	st;
+	struct stat	st;
         int cnt, i;
         struct statfs *fsinfo;
 
 	if (!s) {
-		if (stat64(block, &st) < 0)
+		if (stat(block, &st) < 0)
 			return 0;
 		s = &st;
 	}
@@ -66,7 +66,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat *s, int fatal)
 {
         int cnt, i;
         struct statfs *fsinfo;
diff --git a/libxfs/init.c b/libxfs/init.c
index e04b6e0..2057320 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -65,9 +65,9 @@ static struct dev_to_fd {
 static int
 check_isactive(char *name, char *block, int fatal)
 {
-	struct stat64	st;
+	struct stat	st;
 
-	if (stat64(block, &st) < 0)
+	if (stat(block, &st) < 0)
 		return 0;
 	if ((st.st_mode & S_IFMT) != S_IFBLK)
 		return 0;
@@ -104,7 +104,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 	dev_t		dev;
 	int		fd, d, flags;
 	int		readonly, dio, excl;
-	struct stat64	statb;
+	struct stat	statb;
 
 	readonly = (xflags & LIBXFS_ISREADONLY);
 	excl = (xflags & LIBXFS_EXCLUSIVELY) && !creat;
@@ -124,7 +124,7 @@ retry:
 		exit(1);
 	}
 
-	if (fstat64(fd, &statb) < 0) {
+	if (fstat(fd, &statb) < 0) {
 		fprintf(stderr, _("%s: cannot stat %s: %s\n"),
 			progname, path, strerror(errno));
 		exit(1);
@@ -199,9 +199,9 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 	int readonly = (flags & LIBXFS_ISREADONLY);
 	int inactive = (flags & LIBXFS_ISINACTIVE);
 	int dangerously = (flags & LIBXFS_DANGEROUSLY);
-	struct stat64	stbuf;
+	struct stat	stbuf;
 
-	if (stat64(path, &stbuf) < 0) {
+	if (stat(path, &stbuf) < 0) {
 		perror(path);
 		return 0;
 	}
diff --git a/libxfs/init.h b/libxfs/init.h
index 112febb..baf2f68 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -18,12 +18,12 @@
 #ifndef LIBXFS_INIT_H
 #define LIBXFS_INIT_H
 
-struct stat64;
+struct stat;
 
 extern int platform_check_ismounted (char *path, char *block,
-					struct stat64 *sptr, int verbose);
+					struct stat *sptr, int verbose);
 extern int platform_check_iswritable (char *path, char *block,
-					struct stat64 *sptr, int fatal);
+					struct stat *sptr, int fatal);
 extern int platform_set_blocksize (int fd, char *path, dev_t device, int bsz, int fatal);
 extern void platform_flush_device (int fd, dev_t device);
 extern char *platform_findrawpath(char *path);
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 65aaa7e..a3bd832 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -25,13 +25,13 @@ extern char *progname;
 extern __int64_t findsize(char *);
 
 int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	return 0;
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat *s, int fatal)
 {
 	return 1;
 }
@@ -51,9 +51,9 @@ platform_flush_device(int fd, dev_t device)
 void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
-	struct stat64		st;
+	struct stat		st;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr,
 			_("%s: cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/libxfs/linux.c b/libxfs/linux.c
index c9f2baf..7da6dd6 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -49,14 +49,14 @@ static int max_block_alignment;
 #define PROC_MOUNTED	"/proc/mounts"
 
 int
-platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
 	struct ustat	ust[2];
-	struct stat64	st;
+	struct stat	st;
 
 	if (!s) {
-		if (stat64(block, &st) < 0)
+		if (stat(block, &st) < 0)
 			return 0;
 		if ((st.st_mode & S_IFMT) != S_IFBLK)
 			return 0;
@@ -74,11 +74,11 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
+platform_check_iswritable(char *name, char *block, struct stat *s, int fatal)
 {
 	int		sts = 0;
 	FILE		*f;
-	struct stat64	mst;
+	struct stat	mst;
 	struct mntent	*mnt;
 	char		mounts[MAXPATHLEN];
 
@@ -89,7 +89,7 @@ platform_check_iswritable(char *name, char *block, struct stat64 *s, int fatal)
 			return fatal;
 	}
 	while ((mnt = getmntent(f)) != NULL) {
-		if (stat64(mnt->mnt_fsname, &mst) < 0)
+		if (stat(mnt->mnt_fsname, &mst) < 0)
 			continue;
 		if ((mst.st_mode & S_IFMT) != S_IFBLK)
 			continue;
@@ -125,11 +125,11 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
 void
 platform_flush_device(int fd, dev_t device)
 {
-	struct stat64	st;
+	struct stat	st;
 	if (major(device) == RAMDISK_MAJOR)
 		return;
 
-	if (fstat64(fd, &st) < 0)
+	if (fstat(fd, &st) < 0)
 		return;
 
 	if (S_ISREG(st.st_mode))
@@ -141,11 +141,11 @@ platform_flush_device(int fd, dev_t device)
 void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
-	struct stat64	st;
+	struct stat	st;
 	__uint64_t	size;
 	int		error;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr, _("%s: "
 			"cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index a22efc2..26d61eb 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -197,7 +197,7 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat64 *, int);
+extern int	platform_check_ismounted(char *, char *, struct stat *, int);
 
 int
 main(
@@ -208,7 +208,7 @@ main(
 	int		dst_fd;
 	int		c;
 	int		open_flags;
-	struct stat64	statbuf;
+	struct stat	statbuf;
 	int		is_target_file;
 
 	progname = basename(argv[0]);
@@ -244,7 +244,7 @@ main(
 	/* check and open target */
 	open_flags = O_RDWR;
 	is_target_file = 0;
-	if (stat64(argv[optind], &statbuf) < 0)  {
+	if (stat(argv[optind], &statbuf) < 0)  {
 		/* ok, assume it's a file and create it */
 		open_flags |= O_CREAT;
 		is_target_file = 1;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5f7f0b4..7de0a99 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -782,9 +782,9 @@ static long
 filesize(
 	int		fd)
 {
-	struct stat64	stb;
+	struct stat	stb;
 
-	if (fstat64(fd, &stb) < 0)
+	if (fstat(fd, &stb) < 0)
 		return -1;
 	return (long)stb.st_size;
 }
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b02983..8b98a8a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -794,7 +794,7 @@ check_device_type(
 	bool		force_overwrite,
 	const char	*optname)
 {
-	struct stat64 statbuf;
+	struct stat statbuf;
 
 	if (*isfile && (no_size || no_name)) {
 		fprintf(stderr,
@@ -808,7 +808,7 @@ check_device_type(
 		usage();
 	}
 
-	if (stat64(name, &statbuf)) {
+	if (stat(name, &statbuf)) {
 		if (errno == ENOENT && *isfile) {
 			if (create)
 				*create = 1;
diff --git a/po/de.po b/po/de.po
index fc62525..61a60f3 100644
--- a/po/de.po
+++ b/po/de.po
@@ -13873,8 +13873,8 @@ msgstr "%s: Dateien zum Kopieren müssen angegeben werden\n"
 
 #: .././rtcp/xfs_rtcp.c:86
 #, c-format
-msgid "%s: stat64 of %s failed\n"
-msgstr "%s: stat64 von %s fehlgeschlagen\n"
+msgid "%s: stat of %s failed\n"
+msgstr "%s: stat von %s fehlgeschlagen\n"
 
 #: .././rtcp/xfs_rtcp.c:93
 #, c-format
@@ -13883,8 +13883,8 @@ msgstr "%s: letztes Argument ist kein Verzeichnis\n"
 
 #: .././rtcp/xfs_rtcp.c:140
 #, c-format
-msgid "%s: failed stat64 on %s: %s\n"
-msgstr "%s: stat64 auf %s fehlgeschlagen: %s\n"
+msgid "%s: failed stat on %s: %s\n"
+msgstr "%s: stat auf %s fehlgeschlagen: %s\n"
 
 #: .././rtcp/xfs_rtcp.c:161
 #, c-format
diff --git a/po/pl.po b/po/pl.po
index a950f77..9d5128f 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -13005,8 +13005,8 @@ msgstr "%s: trzeba podać pliki do skopiowania\n"
 
 #: .././rtcp/xfs_rtcp.c:84
 #, c-format
-msgid "%s: stat64 of %s failed\n"
-msgstr "%s: stat64 na %s nie powiodło się\n"
+msgid "%s: stat of %s failed\n"
+msgstr "%s: stat na %s nie powiodło się\n"
 
 #: .././rtcp/xfs_rtcp.c:91
 #, c-format
@@ -13015,8 +13015,8 @@ msgstr "%s: ostatni argument nie jest katalogiem\n"
 
 #: .././rtcp/xfs_rtcp.c:138
 #, c-format
-msgid "%s: failed stat64 on %s: %s\n"
-msgstr "%s: nie udało się wykonać stat64 na %s: %s\n"
+msgid "%s: failed stat on %s: %s\n"
+msgstr "%s: nie udało się wykonać stat na %s: %s\n"
 
 #: .././rtcp/xfs_rtcp.c:159
 #, c-format
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 50a1ac9..361bace 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -668,9 +668,9 @@ main(int argc, char **argv)
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
 		int		fd = libxfs_device_to_fd(x.ddev);
-		struct stat64	statbuf;
+		struct stat	statbuf;
 
-		if (fstat64(fd, &statbuf) < 0)
+		if (fstat(fd, &statbuf) < 0)
 			do_warn(_("%s: couldn't stat \"%s\"\n"),
 				progname, fs_name);
 		else if (S_ISREG(statbuf.st_mode))
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index 3044350..705e958 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -35,7 +35,7 @@ int
 main(int argc, char **argv)
 {
 	int	c, i, r, errflg = 0;
-	struct stat64	s2;
+	struct stat	s2;
 	int		extsize = - 1;
 
 	progname = basename(argv[0]);
@@ -80,8 +80,8 @@ main(int argc, char **argv)
 	 * which really exists.
 	 */
 	if (argc > 2) {
-		if (stat64(argv[argc-1], &s2) < 0) {
-			fprintf(stderr, _("%s: stat64 of %s failed\n"),
+		if (stat(argv[argc-1], &s2) < 0) {
+			fprintf(stderr, _("%s: stat of %s failed\n"),
 				progname, argv[argc-1]);
 			exit(2);
 		}
@@ -115,7 +115,7 @@ rtcp( char *source, char *target, int fextsize)
 	int		remove = 0, rtextsize;
 	char		*sp, *fbuf, *ptr;
 	char		tbuf[ PATH_MAX ];
-	struct stat64	s1, s2;
+	struct stat	s1, s2;
 	struct fsxattr	fsxattr;
 	struct dioattr	dioattr;
 
@@ -134,8 +134,8 @@ rtcp( char *source, char *target, int fextsize)
 			*sp = '\0';
 	}
 
-	if ( stat64(source, &s1) ) {
-		fprintf(stderr, _("%s: failed stat64 on %s: %s\n"),
+	if ( stat(source, &s1) ) {
+		fprintf(stderr, _("%s: failed stat on %s: %s\n"),
 			progname, source, strerror(errno));
 		return( -1);
 	}
@@ -144,7 +144,7 @@ rtcp( char *source, char *target, int fextsize)
 	 * check for a realtime partition
 	 */
 	snprintf(tbuf, sizeof(tbuf), "%s", target);
-	if ( stat64(target, &s2) ) {
+	if ( stat(target, &s2) ) {
 		if (!S_ISDIR(s2.st_mode)) {
 			/* take out target file name */
 			if ((ptr = strrchr(tbuf, '/')) != NULL)
@@ -165,14 +165,14 @@ rtcp( char *source, char *target, int fextsize)
 	 * check if target is a directory
 	 */
 	snprintf(tbuf, sizeof(tbuf), "%s", target);
-	if ( !stat64(target, &s2) ) {
+	if ( !stat(target, &s2) ) {
 		if (S_ISDIR(s2.st_mode)) {
 			snprintf(tbuf, sizeof(tbuf), "%s/%s", target,
 				basename(source));
 		}
 	}
 
-	if ( stat64(tbuf, &s2) ) {
+	if ( stat(tbuf, &s2) ) {
 		/*
 		 * create the file if it does not exist
 		 */
-- 
2.7.3


--===============3794373344813975276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3794373344813975276==--
