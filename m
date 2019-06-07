Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbfFGTae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:30:34 -0400
Subject: [PATCH 2/6] libxfs: refactor open-coded bulkstat calls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:28:28 -0700
Message-ID: <155993570815.2343365.14008441725903148335.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
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
 fsr/xfs_fsr.c      |   37 ++++-------------------------
 include/xfrog.h    |    5 ++++
 io/open.c          |   66 ++++++++++++++++++++++++----------------------------
 io/swapext.c       |   18 ++------------
 libfrog/Makefile   |    1 +
 libfrog/bulkstat.c |   43 ++++++++++++++++++++++++++++++++++
 quota/quot.c       |   17 +++++--------
 scrub/inodes.c     |   28 ++++++----------------
 8 files changed, 101 insertions(+), 114 deletions(-)
 create mode 100644 libfrog/bulkstat.c


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 0bfecf37..f35ead90 100644
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
@@ -600,7 +575,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	int	fsfd, fd;
 	int	count = 0;
 	int	ret;
-	__s32	buflenout;
+	uint32_t buflenout;
 	xfs_bstat_t buf[GRABSZ];
 	char	fname[64];
 	char	*tname;
@@ -634,7 +609,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 
 	tmp_init(mntdir);
 
-	while ((ret = xfs_bulkstat(fsfd,
+	while ((ret = xfrog_bulkstat(fsfd,
 				&lastino, GRABSZ, &buf[0], &buflenout)) == 0) {
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
@@ -690,7 +665,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		}
 	}
 	if (ret < 0)
-		fsrprintf(_("%s: xfs_bulkstat: %s\n"), progname, strerror(errno));
+		fsrprintf(_("%s: xfrog_bulkstat: %s\n"), progname, strerror(errno));
 out0:
 	tmp_close(mntdir);
 	close(fsfd);
@@ -752,7 +727,7 @@ fsrfile(char *fname, xfs_ino_t ino)
 		goto out;
 	}
 
-	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
+	if ((xfrog_bulkstat_single(fsfd, ino, &statbuf)) < 0) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(errno));
 		goto out;
@@ -981,7 +956,6 @@ fsr_setup_attr_fork(
 	i = 0;
 	do {
 		xfs_bstat_t	tbstat;
-		xfs_ino_t	ino;
 		char		name[64];
 
 		/*
@@ -989,8 +963,7 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ino = tstatbuf.st_ino;
-		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
+		if ((xfrog_bulkstat_single(tfd, tstatbuf.st_ino, &tbstat)) < 0) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(errno));
 			return -1;
diff --git a/include/xfrog.h b/include/xfrog.h
index b683cf63..4b4e0adc 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -19,4 +19,9 @@
 struct xfs_fsop_geom;
 int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
 
+struct xfs_bstat;
+int xfrog_bulkstat_single(int fd, uint64_t ino, struct xfs_bstat *ubuffer);
+int xfrog_bulkstat(int fd, uint64_t *lastino, uint32_t icount,
+		struct xfs_bstat *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFROG_H__ */
diff --git a/io/open.c b/io/open.c
index 997df119..d97903e9 100644
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
@@ -767,35 +766,32 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		}
+	} else if (ret_next) {
+		/* get next inode */
+		ret = xfrog_bulkstat(file->fd, &userino, 1, &bstat, &count);
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
+		/* get this inode */
+		ret = xfrog_bulkstat_single(file->fd, userino, &bstat);
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
index d360c221..f5e6532f 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "xfrog.h"
 
 static cmdinfo_t swapext_cmd;
 
@@ -20,21 +21,6 @@ swapext_help(void)
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
@@ -60,7 +46,7 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfs_bulkstat_single(file->fd, &stat.st_ino, &sx.sx_stat);
+	error = xfrog_bulkstat_single(file->fd, stat.st_ino, &sx.sx_stat);
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
index 00000000..c0d3b627
--- /dev/null
+++ b/libfrog/bulkstat.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+
+/* Bulkstat a single inode. */
+int
+xfrog_bulkstat_single(
+	int			fd,
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
+	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+}
+
+/* Bulkstat a bunch of inodes. */
+int
+xfrog_bulkstat(
+	int			fd,
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
+	return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+}
diff --git a/quota/quot.c b/quota/quot.c
index d60cf4a8..4639dc5d 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -11,6 +11,7 @@
 #include <grp.h>
 #include "init.h"
 #include "quota.h"
+#include "xfrog.h"
 
 typedef struct du {
 	struct du	*next;
@@ -124,12 +125,11 @@ quot_bulkstat_add(
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
+	struct xfs_bstat	*buf;
+	uint64_t		last = 0;
+	uint32_t		count;
 	int			i, sts, fsfd;
 	du_t			**dp;
 
@@ -158,12 +158,7 @@ quot_bulkstat_mount(
 		return;
 	}
 
-	bulkreq.lastip = &last;
-	bulkreq.icount = NBSTAT;
-	bulkreq.ubuffer = buf;
-	bulkreq.ocount = &count;
-
-	while ((sts = xfsctl(fsdir, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
+	while ((sts = xfrog_bulkstat(fsfd, &last, NBSTAT, buf, &count)) == 0) {
 		if (count == 0)
 			break;
 		for (i = 0; i < count; i++)
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 442a5978..7950208d 100644
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
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT_SINGLE,
-				&onereq);
+		error = xfrog_bulkstat_single(ctx->mnt_fd,
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
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		error = xfrog_bulkstat(ctx->mnt_fd, &ino, inogrp.xi_alloccount,
+				bstat, &bulklen);
 		if (error)
 			str_info(ctx, descr, "%s", strerror_r(errno,
 						buf, DESCR_BUFSZ));
