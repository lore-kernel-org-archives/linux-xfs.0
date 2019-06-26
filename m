Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfFZCh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:27 -0400
Subject: [PATCH 05/10] libfrog: refactor open-coded bulkstat calls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:37:21 -0700
Message-ID: <156151664147.2286979.16845898252353306717.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the BULKSTAT_SINGLE and BULKSTAT ioctl callsites into helper
functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |  104 ++++++++++++++++++++++------------------------------
 include/xfrog.h    |    7 ++++
 io/open.c          |   70 ++++++++++++++++++-----------------
 io/swapext.c       |   19 ++--------
 libfrog/Makefile   |    1 +
 libfrog/bulkstat.c |   44 ++++++++++++++++++++++
 quota/quot.c       |   29 +++++++--------
 scrub/inodes.c     |   28 ++++----------
 8 files changed, 155 insertions(+), 147 deletions(-)
 create mode 100644 libfrog/bulkstat.c


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 0bfecf37..7a5dfe8e 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -102,31 +102,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
 				 * of extents */
 static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
 
-static int
-xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
-{
-    xfs_fsop_bulkreq_t  bulkreq;
-
-    bulkreq.lastip = (__u64 *)lastip;
-    bulkreq.icount = 1;
-    bulkreq.ubuffer = ubuffer;
-    bulkreq.ocount = NULL;
-    return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
-}
-
-static int
-xfs_bulkstat(int fd, xfs_ino_t *lastip, int icount,
-                    xfs_bstat_t *ubuffer, __s32 *ocount)
-{
-    xfs_fsop_bulkreq_t  bulkreq;
-
-    bulkreq.lastip = (__u64 *)lastip;
-    bulkreq.icount = icount;
-    bulkreq.ubuffer = ubuffer;
-    bulkreq.ocount = ocount;
-    return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
-}
-
 static int
 xfs_swapext(int fd, xfs_swapext_t *sx)
 {
@@ -596,11 +571,11 @@ fsrall_cleanup(int timeout)
 static int
 fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 {
-
-	int	fsfd, fd;
+	struct xfs_fd	fsxfd = XFS_FD_INIT_EMPTY;
+	int	fd;
 	int	count = 0;
 	int	ret;
-	__s32	buflenout;
+	uint32_t buflenout;
 	xfs_bstat_t buf[GRABSZ];
 	char	fname[64];
 	char	*tname;
@@ -617,25 +592,27 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	if ((fsfd = open(mntdir, O_RDONLY)) < 0) {
+	if ((fsxfd.fd = open(mntdir, O_RDONLY)) < 0) {
 		fsrprintf(_("unable to open: %s: %s\n"),
 		          mntdir, strerror( errno ));
 		free(fshandlep);
 		return -1;
 	}
 
-	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
+	ret = xfrog_prepare_geometry(&fsxfd);
+	if (ret) {
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
-		close(fsfd);
+		xfrog_close(&fsxfd);
 		free(fshandlep);
 		return -1;
 	}
+	memcpy(&fsgeom, &fsxfd.fsgeom, sizeof(fsgeom));
 
 	tmp_init(mntdir);
 
-	while ((ret = xfs_bulkstat(fsfd,
-				&lastino, GRABSZ, &buf[0], &buflenout)) == 0) {
+	while ((ret = xfrog_bulkstat(&fsxfd, &lastino, GRABSZ, &buf[0],
+				&buflenout)) == 0) {
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 
@@ -684,16 +661,16 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		}
 		if (endtime && endtime < time(NULL)) {
 			tmp_close(mntdir);
-			close(fsfd);
+			xfrog_close(&fsxfd);
 			fsrall_cleanup(1);
 			exit(1);
 		}
 	}
 	if (ret < 0)
-		fsrprintf(_("%s: xfs_bulkstat: %s\n"), progname, strerror(errno));
+		fsrprintf(_("%s: xfrog_bulkstat: %s\n"), progname, strerror(errno));
 out0:
 	tmp_close(mntdir);
-	close(fsfd);
+	xfrog_close(&fsxfd);
 	free(fshandlep);
 	return 0;
 }
@@ -726,13 +703,16 @@ fsrdir(char *dirname)
  * an open on the file and passes this all to fsrfile_common.
  */
 static int
-fsrfile(char *fname, xfs_ino_t ino)
+fsrfile(
+	char			*fname,
+	xfs_ino_t		ino)
 {
-	xfs_bstat_t	statbuf;
-	jdm_fshandle_t	*fshandlep;
-	int	fd = -1, fsfd = -1;
-	int	error = -1;
-	char	*tname;
+	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
+	struct xfs_bstat	statbuf;
+	jdm_fshandle_t		*fshandlep;
+	int			fd = -1;
+	int			error = -1;
+	char			*tname;
 
 	fshandlep = jdm_getfshandle(getparent (fname) );
 	if (!fshandlep) {
@@ -745,14 +725,21 @@ fsrfile(char *fname, xfs_ino_t ino)
 	 * Need to open something on the same filesystem as the
 	 * file.  Open the parent.
 	 */
-	fsfd = open(getparent(fname), O_RDONLY);
-	if (fsfd < 0) {
+	fsxfd.fd = open(getparent(fname), O_RDONLY);
+	if (fsxfd.fd < 0) {
 		fsrprintf(_("unable to open sys handle for %s: %s\n"),
 			fname, strerror(errno));
 		goto out;
 	}
 
-	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
+	error = xfrog_prepare_geometry(&fsxfd);
+	if (error) {
+		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
+		goto out;
+	}
+
+	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
+	if (error < 0) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(errno));
 		goto out;
@@ -765,11 +752,8 @@ fsrfile(char *fname, xfs_ino_t ino)
 		goto out;
 	}
 
-	/* Get the fs geometry */
-	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
-		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
-		goto out;
-	}
+	/* Stash the fs geometry for general use. */
+	memcpy(&fsgeom, &fsxfd.fsgeom, sizeof(fsgeom));
 
 	tname = gettmpname(fname);
 
@@ -777,8 +761,7 @@ fsrfile(char *fname, xfs_ino_t ino)
 		error = fsrfile_common(fname, tname, NULL, fd, &statbuf);
 
 out:
-	if (fsfd >= 0)
-		close(fsfd);
+	xfrog_close(&fsxfd);
 	if (fd >= 0)
 		close(fd);
 	free(fshandlep);
@@ -945,6 +928,7 @@ fsr_setup_attr_fork(
 	xfs_bstat_t	*bstatp)
 {
 #ifdef HAVE_FSETXATTR
+	struct xfs_fd	txfd = XFS_FD_INIT(tfd);
 	struct stat	tstatbuf;
 	int		i;
 	int		diff = 0;
@@ -962,7 +946,7 @@ fsr_setup_attr_fork(
 	if (!(fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ATTR2) ||
 	    bstatp->bs_forkoff == 0) {
 		/* attr1 */
-		ret = fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE);
+		ret = fsetxattr(txfd.fd, "user.X", "X", 1, XATTR_CREATE);
 		if (ret) {
 			fsrprintf(_("could not set ATTR\n"));
 			return -1;
@@ -972,7 +956,7 @@ fsr_setup_attr_fork(
 
 	/* attr2 w/ fork offsets */
 
-	if (fstat(tfd, &tstatbuf) < 0) {
+	if (fstat(txfd.fd, &tstatbuf) < 0) {
 		fsrprintf(_("unable to stat temp file: %s\n"),
 					strerror(errno));
 		return -1;
@@ -981,16 +965,16 @@ fsr_setup_attr_fork(
 	i = 0;
 	do {
 		xfs_bstat_t	tbstat;
-		xfs_ino_t	ino;
 		char		name[64];
+		int		ret;
 
 		/*
 		 * bulkstat the temp inode to see what the forkoff is.  Use
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ino = tstatbuf.st_ino;
-		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
+		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
+		if (ret < 0) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(errno));
 			return -1;
@@ -1012,7 +996,7 @@ fsr_setup_attr_fork(
 		 */
 		if (!tbstat.bs_forkoff) {
 			ASSERT(i == 0);
-			ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
+			ret = fsetxattr(txfd.fd, name, "XX", 2, XATTR_CREATE);
 			if (ret) {
 				fsrprintf(_("could not set ATTR\n"));
 				return -1;
@@ -1048,7 +1032,7 @@ fsr_setup_attr_fork(
 			if (diff < 0) {
 				char val[2048];
 				memset(val, 'X', 2048);
-				if (fsetxattr(tfd, name, val, 2048, 0)) {
+				if (fsetxattr(txfd.fd, name, val, 2048, 0)) {
 					fsrprintf(_("big ATTR set failed\n"));
 					return -1;
 				}
@@ -1092,7 +1076,7 @@ fsr_setup_attr_fork(
 		}
 
 		/* we need to grow the attr fork, so create another attr */
-		ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
+		ret = fsetxattr(txfd.fd, name, "XX", 2, XATTR_CREATE);
 		if (ret) {
 			fsrprintf(_("could not set ATTR\n"));
 			return -1;
diff --git a/include/xfrog.h b/include/xfrog.h
index 87bf4a2f..a76b00ec 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -100,4 +100,11 @@ xfrog_b_to_fsbt(
 	return bytes >> xfd->blocklog;
 }
 
+/* Bulkstat wrappers */
+struct xfs_bstat;
+int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
+		struct xfs_bstat *ubuffer);
+int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
+		struct xfs_bstat *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFROG_H__ */
diff --git a/io/open.c b/io/open.c
index e70c8cb0..67976f7f 100644
--- a/io/open.c
+++ b/io/open.c
@@ -713,19 +713,18 @@ get_last_inode(void)
 
 static int
 inode_f(
-	  int			argc,
-	  char			**argv)
+	int			argc,
+	char			**argv)
 {
-	__s32			count = 0;
-	__u64			result_ino = 0;
-	__u64			userino = NULLFSINO;
+	struct xfs_bstat	bstat;
+	uint32_t		count = 0;
+	uint64_t		result_ino = 0;
+	uint64_t		userino = NULLFSINO;
 	char			*p;
 	int			c;
 	int			verbose = 0;
 	int			ret_next = 0;
-	int			cmd = 0;
-	struct xfs_fsop_bulkreq	bulkreq;
-	struct xfs_bstat	bstat;
+	int			ret;
 
 	while ((c = getopt(argc, argv, "nv")) != EOF) {
 		switch (c) {
@@ -767,35 +766,36 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		}
+	} else if (ret_next) {
+		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
+
+		/* get next inode */
+		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);
+		if (ret) {
+			perror("xfsctl");
+			exitcode = 1;
+			return 0;
+		}
+
+		/* The next inode in use, or 0 if none */
+		if (count)
+			result_ino = bstat.bs_ino;
+		else
+			result_ino = 0;
 	} else {
-		if (ret_next)	/* get next inode */
-			cmd = XFS_IOC_FSBULKSTAT;
-		else		/* get this inode */
-			cmd = XFS_IOC_FSBULKSTAT_SINGLE;
-
-		bulkreq.lastip = &userino;
-		bulkreq.icount = 1;
-		bulkreq.ubuffer = &bstat;
-		bulkreq.ocount = &count;
-
-		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
-			if (!ret_next && errno == EINVAL) {
-				/* Not in use */
-				result_ino = 0;
-			} else {
-				perror("xfsctl");
-				exitcode = 1;
-				return 0;
-			}
-		} else if (ret_next) {
-			/* The next inode in use, or 0 if none */
-			if (*bulkreq.ocount)
-				result_ino = bstat.bs_ino;
-			else
-				result_ino = 0;
+		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
+
+		/* get this inode */
+		ret = xfrog_bulkstat_single(&xfd, userino, &bstat);
+		if (ret && errno == EINVAL) {
+			/* Not in use */
+			result_ino = 0;
+		} else if (ret) {
+			perror("bulkstat_single");
+			exitcode = 1;
+			return 0;
 		} else {
-			/* The inode we asked about */
-			result_ino = userino;
+			result_ino = bstat.bs_ino;
 		}
 	}
 
diff --git a/io/swapext.c b/io/swapext.c
index d360c221..e8432e7d 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "xfrog.h"
 
 static cmdinfo_t swapext_cmd;
 
@@ -20,26 +21,12 @@ swapext_help(void)
 "\n"));
 }
 
-static int
-xfs_bulkstat_single(
-	int			fd,
-	xfs_ino_t		*lastip,
-	struct xfs_bstat	*ubuffer)
-{
-	struct xfs_fsop_bulkreq	bulkreq;
-
-	bulkreq.lastip = (__u64 *)lastip;
-	bulkreq.icount = 1;
-	bulkreq.ubuffer = ubuffer;
-	bulkreq.ocount = NULL;
-	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
-}
-
 static int
 swapext_f(
 	int			argc,
 	char			**argv)
 {
+	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
 	int			fd;
 	int			error;
 	struct xfs_swapext	sx;
@@ -60,7 +47,7 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfs_bulkstat_single(file->fd, &stat.st_ino, &sx.sx_stat);
+	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
 	if (error) {
 		perror("bulkstat");
 		goto out;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index f5a0539b..05c6f701 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -13,6 +13,7 @@ LT_AGE = 0
 CFILES = \
 avl64.c \
 bitmap.c \
+bulkstat.c \
 convert.c \
 crc32.c \
 fsgeom.c \
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
new file mode 100644
index 00000000..5db34eba
--- /dev/null
+++ b/libfrog/bulkstat.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfrog.h"
+
+/* Bulkstat a single inode. */
+int
+xfrog_bulkstat_single(
+	struct xfs_fd		*xfd,
+	uint64_t		ino,
+	struct xfs_bstat	*ubuffer)
+{
+	__u64			i = ino;
+	struct xfs_fsop_bulkreq	bulkreq = {
+		.lastip		= &i,
+		.icount		= 1,
+		.ubuffer	= ubuffer,
+		.ocount		= NULL,
+	};
+
+	return ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+}
+
+/* Bulkstat a bunch of inodes. */
+int
+xfrog_bulkstat(
+	struct xfs_fd		*xfd,
+	uint64_t		*lastino,
+	uint32_t		icount,
+	struct xfs_bstat	*ubuffer,
+	uint32_t		*ocount)
+{
+	struct xfs_fsop_bulkreq	bulkreq = {
+		.lastip		= (__u64 *)lastino,
+		.icount		= icount,
+		.ubuffer	= ubuffer,
+		.ocount		= (__s32 *)ocount,
+	};
+
+	return ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+}
diff --git a/quota/quot.c b/quota/quot.c
index d60cf4a8..3520bd5b 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -11,6 +11,7 @@
 #include <grp.h>
 #include "init.h"
 #include "quota.h"
+#include "xfrog.h"
 
 typedef struct du {
 	struct du	*next;
@@ -124,13 +125,13 @@ quot_bulkstat_add(
 static void
 quot_bulkstat_mount(
 	char			*fsdir,
-	uint			flags)
+	unsigned int		flags)
 {
-	xfs_fsop_bulkreq_t	bulkreq;
-	xfs_bstat_t		*buf;
-	__u64			last = 0;
-	__s32			count;
-	int			i, sts, fsfd;
+	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
+	struct xfs_bstat	*buf;
+	uint64_t		last = 0;
+	uint32_t		count;
+	int			i, sts;
 	du_t			**dp;
 
 	/*
@@ -145,8 +146,8 @@ quot_bulkstat_mount(
 			*dp = NULL;
 	ndu[0] = ndu[1] = ndu[2] = 0;
 
-	fsfd = open(fsdir, O_RDONLY);
-	if (fsfd < 0) {
+	fsxfd.fd = open(fsdir, O_RDONLY);
+	if (fsxfd.fd < 0) {
 		perror(fsdir);
 		return;
 	}
@@ -154,16 +155,12 @@ quot_bulkstat_mount(
 	buf = (xfs_bstat_t *)calloc(NBSTAT, sizeof(xfs_bstat_t));
 	if (!buf) {
 		perror("calloc");
-		close(fsfd);
+		xfrog_close(&fsxfd);
 		return;
 	}
 
-	bulkreq.lastip = &last;
-	bulkreq.icount = NBSTAT;
-	bulkreq.ubuffer = buf;
-	bulkreq.ocount = &count;
-
-	while ((sts = xfsctl(fsdir, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
+	while ((sts = xfrog_bulkstat(&fsxfd, &last, NBSTAT, buf,
+				&count)) == 0) {
 		if (count == 0)
 			break;
 		for (i = 0; i < count; i++)
@@ -172,7 +169,7 @@ quot_bulkstat_mount(
 	if (sts < 0)
 		perror("XFS_IOC_FSBULKSTAT"),
 	free(buf);
-	close(fsfd);
+	xfrog_close(&fsxfd);
 }
 
 static int
diff --git a/scrub/inodes.c b/scrub/inodes.c
index a9000218..09dd0055 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -17,6 +17,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
+#include "xfrog.h"
 
 /*
  * Iterate a range of inodes.
@@ -50,17 +51,10 @@ xfs_iterate_inodes_range_check(
 	struct xfs_inogrp	*inogrp,
 	struct xfs_bstat	*bstat)
 {
-	struct xfs_fsop_bulkreq	onereq = {NULL};
 	struct xfs_bstat	*bs;
-	__u64			oneino;
-	__s32			onelen = 0;
 	int			i;
 	int			error;
 
-	onereq.lastip  = &oneino;
-	onereq.icount  = 1;
-	onereq.ocount  = &onelen;
-
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
 		if (!(inogrp->xi_allocmask & (1ULL << i)))
 			continue;
@@ -70,10 +64,8 @@ xfs_iterate_inodes_range_check(
 		}
 
 		/* Load the one inode. */
-		oneino = inogrp->xi_startino + i;
-		onereq.ubuffer = bs;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT_SINGLE,
-				&onereq);
+		error = xfrog_bulkstat_single(&ctx->mnt,
+				inogrp->xi_startino + i, bs);
 		if (error || bs->bs_ino != inogrp->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bstat));
 			bs->bs_ino = inogrp->xi_startino + i;
@@ -99,7 +91,6 @@ xfs_iterate_inodes_range(
 	void			*arg)
 {
 	struct xfs_fsop_bulkreq	igrpreq = {NULL};
-	struct xfs_fsop_bulkreq	bulkreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
@@ -107,8 +98,8 @@ xfs_iterate_inodes_range(
 	char			buf[DESCR_BUFSZ];
 	struct xfs_bstat	*bs;
 	__u64			igrp_ino;
-	__u64			ino;
-	__s32			bulklen = 0;
+	uint64_t		ino;
+	uint32_t		bulklen = 0;
 	__s32			igrplen = 0;
 	bool			moveon = true;
 	int			i;
@@ -117,10 +108,6 @@ xfs_iterate_inodes_range(
 
 
 	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
-	bulkreq.lastip  = &ino;
-	bulkreq.icount  = XFS_INODES_PER_CHUNK;
-	bulkreq.ubuffer = &bstat;
-	bulkreq.ocount  = &bulklen;
 
 	igrpreq.lastip  = &igrp_ino;
 	igrpreq.icount  = 1;
@@ -138,14 +125,15 @@ xfs_iterate_inodes_range(
 	while (!error && igrplen) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
-		bulkreq.icount = inogrp.xi_alloccount;
+
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.
 		 */
 		if (inogrp.xi_alloccount == 0)
 			goto igrp_retry;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		error = xfrog_bulkstat(&ctx->mnt, &ino, inogrp.xi_alloccount,
+				bstat, &bulklen);
 		if (error)
 			str_info(ctx, descr, "%s", strerror_r(errno,
 						buf, DESCR_BUFSZ));
