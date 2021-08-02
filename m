Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F140C432BE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8814060F4B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhHBVuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhHBVuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hc+KluJ9un4gGnyqaniSuiMDPtAucnkLocPBe/mqzx0=;
        b=Lw1TlUVZdaNDVPkrUnkr6h0rb/N9/8cu5rBuLyrCYwhs3XOkhcqc35n1t7S82i6yzoK/fZ
        +Ex5KmnorP4L6WzgAZocIvBxFG2y+5UoW8SiY0q6lteguIxXq1XAKNnsnfe4Nj+nH11V7P
        LjauksptkJUz4QK1lIqaKeO1qiGlSpQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-71yKJcIfN1a5ejshMO7NnA-1; Mon, 02 Aug 2021 17:50:33 -0400
X-MC-Unique: 71yKJcIfN1a5ejshMO7NnA-1
Received: by mail-wr1-f70.google.com with SMTP id l14-20020a5d560e0000b029013e2b4ee624so6926648wrv.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hc+KluJ9un4gGnyqaniSuiMDPtAucnkLocPBe/mqzx0=;
        b=dtv6pzHKqGa7BaNXdbRjHyUSfAOXGmiftyLlvk1uItkzQhDfPC5D9f0uOwIqU8vPWR
         qL4lQ+33F/0xmjlzlASywzuo7XB4G5wpZnPdXUO/ocxOpaUf8XpWJ5vnY9HfECDJsCv7
         FLXdg9XgEHoMLfVHVMU+wsPV8Vt082GwsUEwqHX3EWJ6Awaa1FOPk36j2uQeIYwQ4q+6
         UIlYQ345gBsekESgpa5uKofvhI6ZA8LCh2O6cDVhU5yswAj8nTpXZL4wespxc3peJXxs
         sO7EE5+xjOs2KleN1+4YPT/Ch6DzozsDXDR7Y/VhOLdOLX9ioFgeA4n9muZg1Vf3plnF
         04zg==
X-Gm-Message-State: AOAM532Yt67Vl2wSdi7dfMi3NMPSglcGe9KaOt5CMFjU9qYpfN3niFtT
        wG0J0wGtOZLE7k3XoXEMIYMXFqckQe4wQM5Ggi9mMi95mjTRI9UAjvvsD2/G/U+tE3nrSQqmXMY
        aCVY6QklAsXDeG7KSQalsDc5DzCpwgmYRWQtR/5Pf8vSsuTQozVue/hmY9mkReSnh9L1Y6iw=
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr19893376wrx.110.1627941031883;
        Mon, 02 Aug 2021 14:50:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO+HUUmMnHtt1aF2F+VsLTqFRTr9VZr+P7paNN4c9NmqkTcE7nTHKcnBT4FvGMDUR4ZcKm2Q==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr19893351wrx.110.1627941031351;
        Mon, 02 Aug 2021 14:50:31 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:31 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfsprogs: Remove platform_ prefixes in libfrog/common.h
Date:   Mon,  2 Aug 2021 23:50:23 +0200
Message-Id: <20210802215024.949616-8-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c           |  8 ++++----
 fsr/xfs_fsr.c             |  6 +++---
 include/defs.h.in         |  2 +-
 include/linux.h           | 16 ++++++++--------
 libfrog/common.h          | 24 ++++++++++++------------
 libfrog/linux.c           | 28 ++++++++++++++--------------
 libfrog/topology.c        |  6 +++---
 libxfs/init.c             | 32 ++++++++++++++++----------------
 libxfs/libxfs_io.h        |  2 +-
 libxfs/rdwr.c             |  4 ++--
 mdrestore/xfs_mdrestore.c |  4 ++--
 mkfs/xfs_mkfs.c           | 10 +++++-----
 repair/phase4.c           |  6 +++---
 repair/prefetch.c         |  2 +-
 repair/slab.c             |  2 +-
 repair/xfs_repair.c       |  6 +++---
 scrub/disk.c              |  2 +-
 17 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index f06a1557..d5561ac8 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -17,7 +17,7 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+extern int	check_ismounted(char *, char *, struct stat *, int);
 
 static char 		*logfile_name;
 static FILE		*logerr;
@@ -140,7 +140,7 @@ check_errors(void)
 
 	for (i = 0; i < num_targets; i++)  {
 		if (target[i].state != INACTIVE) {
-			if (platform_flush_device(target[i].fd, 0)) {
+			if (flush_device(target[i].fd, 0)) {
 				target[i].error = errno;
 				target[i].state = INACTIVE;
 				target[i].err_type = 2;
@@ -698,7 +698,7 @@ main(int argc, char **argv)
 		 * check to make sure a filesystem isn't mounted
 		 * on the device
 		 */
-		if (platform_check_ismounted(source_name, NULL, &statbuf, 0))  {
+		if (check_ismounted(source_name, NULL, &statbuf, 0))  {
 			do_log(
 	_("%s:  Warning -- a filesystem is mounted on the source device.\n"),
 				progname);
@@ -842,7 +842,7 @@ main(int argc, char **argv)
 			 * check to make sure a filesystem isn't mounted
 			 * on the device
 			 */
-			if (platform_check_ismounted(target[i].name,
+			if (check_ismounted(target[i].name,
 							NULL, &statbuf, 0))  {
 				do_log(_("%s:  a filesystem is mounted "
 					"on target device \"%s\".\n"
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 25eb2e12..42f477e8 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -314,12 +314,12 @@ initallfs(char *mtab)
 	mi = 0;
 	fs = fsbase;
 
-	if (platform_mntent_open(&cursor, mtab) != 0){
+	if (mntent_open(&cursor, mtab) != 0){
 		fprintf(stderr, "Error: can't get mntent entries.\n");
 		exit(1);
 	}
 
-	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
+	while ((mnt = mntent_next(&cursor)) != NULL) {
 		int rw = 0;
 
 		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
@@ -369,7 +369,7 @@ initallfs(char *mtab)
 		mi++;
 		fs++;
 	}
-	platform_mntent_close(&cursor);
+	mntent_close(&cursor);
 
 	numfs = mi;
 	fsend = (fsbase + numfs);
diff --git a/include/defs.h.in b/include/defs.h.in
index ce0c1a0e..fcf27331 100644
--- a/include/defs.h.in
+++ b/include/defs.h.in
@@ -78,7 +78,7 @@ typedef unsigned short umode_t;
 # define ASSERT(EX)	((void) 0)
 #endif
 
-extern int	platform_nproc(void);
+extern int	libfrog_nproc(void);
 
 #define NSEC_PER_SEC	(1000000000ULL)
 #define NSEC_PER_USEC	(1000ULL)
diff --git a/include/linux.h b/include/linux.h
index a12ccee1..da74ae53 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -41,7 +41,7 @@ static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 }
 
 /*
- * platform_test_xfs_*() implies that xfsctl will succeed on the file;
+ * test_xfs_*() implies that xfsctl will succeed on the file;
  * on Linux, at least, special files don't get xfs file ops,
  * so return 0 for those
  */
@@ -85,7 +85,7 @@ static __inline__ void getoptreset(void)
 #endif
 
 static __inline__ int
-platform_discard_blocks(int fd, uint64_t start, uint64_t len)
+discard_blocks(int fd, uint64_t start, uint64_t len)
 {
 	uint64_t range[2] = { start, len };
 
@@ -111,7 +111,7 @@ struct mntent_cursor {
 	FILE *mtabp;
 };
 
-static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+static inline int mntent_open(struct mntent_cursor * cursor, char *mtab)
 {
 	cursor->mtabp = setmntent(mtab, "r");
 	if (!cursor->mtabp) {
@@ -121,19 +121,19 @@ static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab
 	return 0;
 }
 
-static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
+static inline struct mntent * mntent_next(struct mntent_cursor * cursor)
 {
 	return getmntent(cursor->mtabp);
 }
 
-static inline void platform_mntent_close(struct mntent_cursor * cursor)
+static inline void mntent_close(struct mntent_cursor * cursor)
 {
 	endmntent(cursor->mtabp);
 }
 
 #if defined(FALLOC_FL_ZERO_RANGE)
 static inline int
-platform_zero_range(
+zero_range(
 	int		fd,
 	xfs_off_t	start,
 	size_t		len)
@@ -146,7 +146,7 @@ platform_zero_range(
 	return -errno;
 }
 #else
-#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
+#define zero_range(fd, s, l)	(-EOPNOTSUPP)
 #endif
 
 /*
@@ -154,7 +154,7 @@ platform_zero_range(
  * atexit handlers.
  */
 static inline void
-platform_crash(void)
+crash(void)
 {
 	kill(getpid(), SIGKILL);
 	assert(0);
diff --git a/libfrog/common.h b/libfrog/common.h
index 0aef318a..4d1d5861 100644
--- a/libfrog/common.h
+++ b/libfrog/common.h
@@ -7,20 +7,20 @@
 #ifndef __LIBFROG_PLATFORM_H__
 #define __LIBFROG_PLATFORM_H__
 
-int platform_check_ismounted(char *path, char *block, struct stat *sptr,
+int check_ismounted(char *path, char *block, struct stat *sptr,
 		int verbose);
-int platform_check_iswritable(char *path, char *block, struct stat *sptr);
-int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
+int check_iswritable(char *path, char *block, struct stat *sptr);
+int set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
-int platform_flush_device(int fd, dev_t device);
-char *platform_findrawpath(char *path);
-char *platform_findblockpath(char *path);
-int platform_direct_blockdev(void);
-int platform_align_blockdev(void);
-unsigned long platform_physmem(void);	/* in kilobytes */
-void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
-int platform_nproc(void);
+int flush_device(int fd, dev_t device);
+char *findrawpath(char *path);
+char *findblockpath(char *path);
+int direct_blockdev(void);
+int align_blockdev(void);
+unsigned long physmem(void);	/* in kilobytes */
+void findsizes(char *path, int fd, long long *sz, int *bsz);
+int libfrog_nproc(void);
 
-void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+void findsizes(char *path, int fd, long long *sz, int *bsz);
 
 #endif /* __LIBFROG_PLATFORM_H__ */
diff --git a/libfrog/linux.c b/libfrog/linux.c
index ea69b29b..7f4e2a0d 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -40,7 +40,7 @@ static int max_block_alignment;
 #define	CHECK_MOUNT_WRITABLE	0x2
 
 static int
-platform_check_mount(char *name, char *block, struct stat *s, int flags)
+check_mount(char *name, char *block, struct stat *s, int flags)
 {
 	FILE		*f;
 	struct stat	st, mst;
@@ -108,26 +108,26 @@ _("%s: %s contains a mounted filesystem\n"),
 }
 
 int
-platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	int flags;
 
 	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
-	return platform_check_mount(name, block, s, flags);
+	return check_mount(name, block, s, flags);
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat *s)
+check_iswritable(char *name, char *block, struct stat *s)
 {
 	int flags;
 
 	/* Writable checks are always verbose */
 	flags = CHECK_MOUNT_WRITABLE | CHECK_MOUNT_VERBOSE;
-	return platform_check_mount(name, block, s, flags);
+	return check_mount(name, block, s, flags);
 }
 
 int
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
 {
 	int error = 0;
 
@@ -147,7 +147,7 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
  * success or -1 (with errno set) for failure.
  */
 int
-platform_flush_device(
+flush_device(
 	int		fd,
 	dev_t		device)
 {
@@ -172,7 +172,7 @@ platform_flush_device(
 }
 
 void
-platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	struct stat	st;
 	uint64_t	size;
@@ -232,25 +232,25 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 }
 
 char *
-platform_findrawpath(char *path)
+findrawpath(char *path)
 {
 	return path;
 }
 
 char *
-platform_findblockpath(char *path)
+findblockpath(char *path)
 {
 	return path;
 }
 
 int
-platform_direct_blockdev(void)
+direct_blockdev(void)
 {
 	return 1;
 }
 
 int
-platform_align_blockdev(void)
+align_blockdev(void)
 {
 	if (!max_block_alignment)
 		return getpagesize();
@@ -259,7 +259,7 @@ platform_align_blockdev(void)
 
 /* How many CPUs are online? */
 int
-platform_nproc(void)
+libfrog_nproc(void)
 {
 	long nproc = sysconf(_SC_NPROCESSORS_ONLN);
 
@@ -271,7 +271,7 @@ platform_nproc(void)
 }
 
 unsigned long
-platform_physmem(void)
+physmem(void)
 {
 	struct sysinfo  si;
 
diff --git a/libfrog/topology.c b/libfrog/topology.c
index b059829e..d6e3aa32 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -117,7 +117,7 @@ check_overwrite(
 	fd = open(device, O_RDONLY);
 	if (fd < 0)
 		goto out;
-	platform_findsizes((char *)device, fd, &size, &bsz);
+	findsizes((char *)device, fd, &size, &bsz);
 	close(fd);
 
 	/* nothing to overwrite on a 0-length device */
@@ -296,7 +296,7 @@ void get_topology(
 	char *dfile = xi->volname ? xi->volname : xi->dname;
 
 	/*
-	 * If our target is a regular file, use platform_findsizes
+	 * If our target is a regular file, use findsizes
 	 * to try to obtain the underlying filesystem's requirements
 	 * for direct IO; we'll set our sector size to that if possible.
 	 */
@@ -312,7 +312,7 @@ void get_topology(
 
 		fd = open(dfile, flags, 0666);
 		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			findsizes(dfile, fd, &dummy, &ft->lsectorsize);
 			close(fd);
 			ft->psectorsize = ft->lsectorsize;
 		} else
diff --git a/libxfs/init.c b/libxfs/init.c
index d1e87002..120714c9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -59,9 +59,9 @@ check_isactive(char *name, char *block, int fatal)
 		return 0;
 	if ((st.st_mode & S_IFMT) != S_IFBLK)
 		return 0;
-	if (platform_check_ismounted(name, block, &st, 0) == 0)
+	if (check_ismounted(name, block, &st, 0) == 0)
 		return 0;
-	if (platform_check_iswritable(name, block, &st))
+	if (check_iswritable(name, block, &st))
 		return fatal ? 1 : 0;
 	return 0;
 }
@@ -98,7 +98,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 
 	readonly = (xflags & LIBXFS_ISREADONLY);
 	excl = (xflags & LIBXFS_EXCLUSIVELY) && !creat;
-	dio = (xflags & LIBXFS_DIRECT) && !creat && platform_direct_blockdev();
+	dio = (xflags & LIBXFS_DIRECT) && !creat && direct_blockdev();
 
 retry:
 	flags = (readonly ? O_RDONLY : O_RDWR) | \
@@ -123,10 +123,10 @@ retry:
 	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
 		if (setblksize == 1)
 			/* use the default blocksize */
-			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
+			(void)set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
 		else {
 			/* given an explicit blocksize to use */
-			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
+			if (set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
 			    exit(1);
 		}
 	}
@@ -171,7 +171,7 @@ libxfs_device_close(dev_t dev)
 			fd = dev_map[d].fd;
 			dev_map[d].dev = dev_map[d].fd = 0;
 
-			ret = platform_flush_device(fd, dev);
+			ret = flush_device(fd, dev);
 			if (ret) {
 				ret = -errno;
 				fprintf(stderr,
@@ -200,19 +200,19 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 		perror(path);
 		return 0;
 	}
-	if (!(*rawfile = platform_findrawpath(path))) {
+	if (!(*rawfile = findrawpath(path))) {
 		fprintf(stderr, _("%s: "
 				  "can't find a character device matching %s\n"),
 			progname, path);
 		return 0;
 	}
-	if (!(*blockfile = platform_findblockpath(path))) {
+	if (!(*blockfile = findblockpath(path))) {
 		fprintf(stderr, _("%s: "
 				  "can't find a block device matching %s\n"),
 			progname, path);
 		return 0;
 	}
-	if (!readonly && !inactive && platform_check_ismounted(path, *blockfile, NULL, 1))
+	if (!readonly && !inactive && check_ismounted(path, *blockfile, NULL, 1))
 		return 0;
 
 	if (inactive && check_isactive(path, *blockfile, ((readonly|dangerously)?1:0)))
@@ -324,7 +324,7 @@ libxfs_init(libxfs_init_t *a)
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
 						    a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(dname, a->dfd, &a->dsize,
+			findsizes(dname, a->dfd, &a->dsize,
 					   &a->dbsize);
 		} else {
 			if (!check_open(dname, flags, &rawfile, &blockfile))
@@ -332,7 +332,7 @@ libxfs_init(libxfs_init_t *a)
 			a->ddev = libxfs_device_open(rawfile,
 					a->dcreat, flags, a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(rawfile, a->dfd,
+			findsizes(rawfile, a->dfd,
 					   &a->dsize, &a->dbsize);
 		}
 	} else
@@ -342,7 +342,7 @@ libxfs_init(libxfs_init_t *a)
 			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(dname, a->logfd, &a->logBBsize,
+			findsizes(dname, a->logfd, &a->logBBsize,
 					   &a->lbsize);
 		} else {
 			if (!check_open(logname, flags, &rawfile, &blockfile))
@@ -350,7 +350,7 @@ libxfs_init(libxfs_init_t *a)
 			a->logdev = libxfs_device_open(rawfile,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(rawfile, a->logfd,
+			findsizes(rawfile, a->logfd,
 					   &a->logBBsize, &a->lbsize);
 		}
 	} else
@@ -360,7 +360,7 @@ libxfs_init(libxfs_init_t *a)
 			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(dname, a->rtfd, &a->rtsize,
+			findsizes(dname, a->rtfd, &a->rtsize,
 					   &a->rtbsize);
 		} else {
 			if (!check_open(rtname, flags, &rawfile, &blockfile))
@@ -368,7 +368,7 @@ libxfs_init(libxfs_init_t *a)
 			a->rtdev = libxfs_device_open(rawfile,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(rawfile, a->rtfd,
+			findsizes(rawfile, a->rtfd,
 					   &a->rtsize, &a->rtbsize);
 		}
 	} else
@@ -1030,7 +1030,7 @@ libxfs_destroy(
 int
 libxfs_device_alignment(void)
 {
-	return platform_align_blockdev();
+	return align_blockdev();
 }
 
 void
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3cc4f4ee..a81bd659 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -46,7 +46,7 @@ xfs_buftarg_trip_write(
 	pthread_mutex_lock(&btp->lock);
 	btp->writes_left--;
 	if (!btp->writes_left)
-		platform_crash();
+		crash();
 	pthread_mutex_unlock(&btp->lock);
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f8e4cf0a..85094fe6 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -73,7 +73,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
-	error = platform_zero_range(fd, start_offset, len_bytes);
+	error = zero_range(fd, start_offset, len_bytes);
 	if (!error) {
 		xfs_buftarg_trip_write(btp);
 		return 0;
@@ -1143,7 +1143,7 @@ libxfs_blkdev_issue_flush(
 		return 0;
 
 	fd = libxfs_device_to_fd(btp->bt_bdev);
-	ret = platform_flush_device(fd, btp->bt_bdev);
+	ret = flush_device(fd, btp->bt_bdev);
 	return ret ? -errno : 0;
 }
 
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 1cd399db..4a894f3b 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -182,7 +182,7 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+extern int	check_ismounted(char *, char *, struct stat *, int);
 
 int
 main(
@@ -275,7 +275,7 @@ main(
 		/*
 		 * check to make sure a filesystem isn't mounted on the device
 		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
+		if (check_ismounted(argv[optind], NULL, &statbuf, 0))
 			fatal("a filesystem is mounted on target device \"%s\","
 				" cannot restore to a mounted filesystem.\n",
 				argv[optind]);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c6929a83..ffa79b86 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1263,7 +1263,7 @@ done:
 }
 
 static void
-discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
+mkfs_discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 {
 	int		fd;
 	uint64_t	offset = 0;
@@ -1286,7 +1286,7 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 		 * not necessary for the mkfs functionality but just an
 		 * optimization. However we should stop on error.
 		 */
-		if (platform_discard_blocks(fd, offset, tmp_step) == 0) {
+		if (discard_blocks(fd, offset, tmp_step) == 0) {
 			if (offset == 0 && !quiet) {
 				printf("Discarding blocks...");
 				fflush(stdout);
@@ -2664,11 +2664,11 @@ discard_devices(
 	 */
 
 	if (!xi->disfile)
-		discard_blocks(xi->ddev, xi->dsize, quiet);
+		mkfs_discard_blocks(xi->ddev, xi->dsize, quiet);
 	if (xi->rtdev && !xi->risfile)
-		discard_blocks(xi->rtdev, xi->rtsize, quiet);
+		mkfs_discard_blocks(xi->rtdev, xi->rtsize, quiet);
 	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
-		discard_blocks(xi->logdev, xi->logBBsize, quiet);
+		mkfs_discard_blocks(xi->logdev, xi->logBBsize, quiet);
 }
 
 static void
diff --git a/repair/phase4.c b/repair/phase4.c
index 191b4842..1d509187 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -235,7 +235,7 @@ process_rmap_data(
 	if (!rmap_needs_work(mp))
 		return;
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, libfrog_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
@@ -243,12 +243,12 @@ process_rmap_data(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return;
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, libfrog_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, compute_ag_refcounts, i, NULL);
 	destroy_work_queue(&wq);
 
-	create_work_queue(&wq, mp, platform_nproc());
+	create_work_queue(&wq, mp, libfrog_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 		queue_work(&wq, check_refcount_btrees, i, NULL);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa18..57d5e631 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1024,7 +1024,7 @@ do_inode_prefetch(
 	 */
 	if (check_cache && !libxfs_bcache_overflowed()) {
 		queue.wq_ctx = mp;
-		create_work_queue(&queue, mp, platform_nproc());
+		create_work_queue(&queue, mp, libfrog_nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
 			queue_work(&queue, func, i, NULL);
 		destroy_work_queue(&queue);
diff --git a/repair/slab.c b/repair/slab.c
index 165f97ef..996f9d80 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -234,7 +234,7 @@ qsort_slab(
 		return;
 	}
 
-	create_work_queue(&wq, NULL, platform_nproc());
+	create_work_queue(&wq, NULL, libfrog_nproc());
 	hdr = slab->s_first;
 	while (hdr) {
 		qs = malloc(sizeof(struct qsort_slab));
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index af24b356..a112b424 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -882,7 +882,7 @@ phase_end(int phase)
 
 	/* Fail if someone injected an post-phase error. */
 	if (fail_after_phase && phase == fail_after_phase)
-		platform_crash();
+		crash();
 }
 
 int
@@ -1030,7 +1030,7 @@ main(int argc, char **argv)
 	}
 
 	if (ag_stride) {
-		int max_threads = platform_nproc() * 8;
+		int max_threads = libfrog_nproc() * 8;
 
 		thread_count = (glob_agcount + ag_stride - 1) / ag_stride;
 		while (thread_count > max_threads) {
@@ -1081,7 +1081,7 @@ main(int argc, char **argv)
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
 					50000;	/* rough estimate of 50MB overhead */
 		max_mem = max_mem_specified ? max_mem_specified * 1024 :
-					      platform_physmem() * 3 / 4;
+					      physmem() * 3 / 4;
 
 		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
 					rlim.rlim_cur != RLIM_INFINITY) {
diff --git a/scrub/disk.c b/scrub/disk.c
index 8bd2a36d..f6d37b46 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -43,7 +43,7 @@ __disk_heads(
 {
 	int			iomin;
 	int			ioopt;
-	int			nproc = platform_nproc();
+	int			nproc = libfrog_nproc();
 	unsigned short		rot;
 	int			error;
 
-- 
2.31.1

