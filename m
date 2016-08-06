Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E03B7CDA
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F6A6304048
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:48 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id fh9xzU0hbFqHHCqw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:45 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id A15FC20A85
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:44 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQS1RVZz104W
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:44 +0200 (CEST)
Message-Id: <672b1929c1d96977bf5755fbbc541d530f31198b.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:43 +0200
Subject: [PATCH xfsprogs 03/14] replace fstat64 by equivalent fstat
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c      |  2 +-
 fsr/xfs_fsr.c        |  4 ++--
 include/darwin.h     |  1 -
 include/freebsd.h    |  1 -
 io/copy_file_range.c |  4 ++--
 io/open.c            | 12 ++++++------
 io/sendfile.c        |  4 ++--
 libxfs/darwin.c      |  2 +-
 libxfs/init.c        |  2 +-
 libxfs/irix.c        |  2 +-
 libxfs/linux.c       |  4 ++--
 mkfs/proto.c         |  2 +-
 repair/xfs_repair.c  |  2 +-
 13 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3c8998c..6dcc51a 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -641,7 +641,7 @@ main(int argc, char **argv)
 		die_perror();
 	}
 
-	if (fstat64(source_fd, &statbuf) < 0)  {
+	if (fstat(source_fd, &statbuf) < 0)  {
 		do_log(_("%s:  couldn't stat source \"%s\"\n"),
 			progname, source_name);
 		die_perror();
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index d75990a..2eaf1e7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -514,7 +514,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 		if ( (fd = open(leftofffile, O_RDONLY)) == -1 ) {
 			fsrprintf(_("%s: open failed\n"), leftofffile);
 		}
-		else if ( fstat64(fd, &sb2) == 0) {
+		else if ( fstat(fd, &sb2) == 0) {
 			/*
 			 * Verify that lstat & fstat point to the
 			 * same regular file (no links/no quick spoofs)
@@ -1054,7 +1054,7 @@ fsr_setup_attr_fork(
 
 	/* attr2 w/ fork offsets */
 
-	if (fstat64(tfd, &tstatbuf) < 0) {
+	if (fstat(tfd, &tstatbuf) < 0) {
 		fsrprintf(_("unable to stat temp file: %s\n"),
 					strerror(errno));
 		return -1;
diff --git a/include/darwin.h b/include/darwin.h
index 45e0c03..1666294 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -142,7 +142,6 @@ typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
 #define stat64		stat
-#define fstat64		fstat
 #define lseek64		lseek
 #define pread64		pread
 #define pwrite64	pwrite
diff --git a/include/freebsd.h b/include/freebsd.h
index 6e77427..d6e75f4 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -34,7 +34,6 @@
 #define __LITTLE_ENDIAN	LITTLE_ENDIAN
 
 /* FreeBSD file API is 64-bit aware */
-#define fstat64		fstat
 #define ftruncate64	ftruncate
 #define lseek64		lseek
 #define stat64		stat
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index eddc634..a354fab 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -62,8 +62,8 @@ copy_src_filesize(int fd)
 {
 	struct stat64 st;
 
-	if (fstat64(fd, &st) < 0) {
-		perror("fstat64");
+	if (fstat(fd, &st) < 0) {
+		perror("fstat");
 		return -1;
 	};
 	return st.st_size;
diff --git a/io/open.c b/io/open.c
index 2303527..766ac48 100644
--- a/io/open.c
+++ b/io/open.c
@@ -54,8 +54,8 @@ filesize(void)
 {
 	struct stat64	st;
 
-	if (fstat64(file->fd, &st) < 0) {
-		perror("fstat64");
+	if (fstat(file->fd, &st) < 0) {
+		perror("fstat");
 		return -1;
 	}
 	return st.st_size;
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
@@ -576,8 +576,8 @@ set_extsize(const char *path, int fd, long extsz)
 	struct fsxattr	fsx;
 	struct stat64	stat;
 
-	if (fstat64(fd, &stat) < 0) {
-		perror("fstat64");
+	if (fstat(fd, &stat) < 0) {
+		perror("fstat");
 		return 0;
 	}
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
diff --git a/io/sendfile.c b/io/sendfile.c
index 21ab444..0dc6154 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -135,8 +135,8 @@ sendfile_f(
 	} else {
 		struct stat64	stat;
 
-		if (fstat64(fd, &stat) < 0) {
-			perror("fstat64");
+		if (fstat(fd, &stat) < 0) {
+			perror("fstat");
 			goto done;
 		}
 		count = stat.st_size;
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index 017e190..3923473 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -71,7 +71,7 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 	__uint64_t	size;
 	struct stat64	st;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr,
 			_("%s: cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/libxfs/init.c b/libxfs/init.c
index e04b6e0..919a510 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -124,7 +124,7 @@ retry:
 		exit(1);
 	}
 
-	if (fstat64(fd, &statb) < 0) {
+	if (fstat(fd, &statb) < 0) {
 		fprintf(stderr, _("%s: cannot stat %s: %s\n"),
 			progname, path, strerror(errno));
 		exit(1);
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 65aaa7e..532ea34 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -53,7 +53,7 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	struct stat64		st;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr,
 			_("%s: cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/libxfs/linux.c b/libxfs/linux.c
index c9f2baf..175156d 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -129,7 +129,7 @@ platform_flush_device(int fd, dev_t device)
 	if (major(device) == RAMDISK_MAJOR)
 		return;
 
-	if (fstat64(fd, &st) < 0)
+	if (fstat(fd, &st) < 0)
 		return;
 
 	if (S_ISREG(st.st_mode))
@@ -145,7 +145,7 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 	__uint64_t	size;
 	int		error;
 
-	if (fstat64(fd, &st) < 0) {
+	if (fstat(fd, &st) < 0) {
 		fprintf(stderr, _("%s: "
 			"cannot stat the device file \"%s\": %s\n"),
 			progname, path, strerror(errno));
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5f7f0b4..a008801 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -784,7 +784,7 @@ filesize(
 {
 	struct stat64	stb;
 
-	if (fstat64(fd, &stb) < 0)
+	if (fstat(fd, &stb) < 0)
 		return -1;
 	return (long)stb.st_size;
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 50a1ac9..4986cc5 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -670,7 +670,7 @@ main(int argc, char **argv)
 		int		fd = libxfs_device_to_fd(x.ddev);
 		struct stat64	statbuf;
 
-		if (fstat64(fd, &statbuf) < 0)
+		if (fstat(fd, &statbuf) < 0)
 			do_warn(_("%s: couldn't stat \"%s\"\n"),
 				progname, fs_name);
 		else if (S_ISREG(statbuf.st_mode))
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
