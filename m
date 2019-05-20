Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36868 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:13 -0400
Subject: [PATCH 04/12] libxfs: refactor open-coded bulkstat calls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:17:06 -0700
Message-ID: <155839422634.68606.5333502357929240836.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
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
 fsr/xfs_fsr.c     |   33 ++-------------------------
 include/linux.h   |    5 ++++
 io/open.c         |   66 +++++++++++++++++++++++++----------------------------
 io/swapext.c      |   17 +-------------
 libhandle/ioctl.c |   38 +++++++++++++++++++++++++++++++
 quota/quot.c      |   16 ++++---------
 scrub/inodes.c    |   27 ++++++----------------
 7 files changed, 90 insertions(+), 112 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 968d133c..bc5cf9ed 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -101,31 +101,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
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
@@ -599,7 +574,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	int	fsfd, fd;
 	int	count = 0;
 	int	ret;
-	__s32	buflenout;
+	uint32_t buflenout;
 	xfs_bstat_t buf[GRABSZ];
 	char	fname[64];
 	char	*tname;
@@ -751,7 +726,7 @@ fsrfile(char *fname, xfs_ino_t ino)
 		goto out;
 	}
 
-	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
+	if ((xfs_bulkstat_single(fsfd, ino, &statbuf)) < 0) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(errno));
 		goto out;
@@ -980,7 +955,6 @@ fsr_setup_attr_fork(
 	i = 0;
 	do {
 		xfs_bstat_t	tbstat;
-		xfs_ino_t	ino;
 		char		name[64];
 
 		/*
@@ -988,8 +962,7 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ino = tstatbuf.st_ino;
-		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
+		if ((xfs_bulkstat_single(tfd, tstatbuf.st_ino, &tbstat)) < 0) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(errno));
 			return -1;
diff --git a/include/linux.h b/include/linux.h
index 5fe33117..98750e18 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -328,4 +328,9 @@ fsmap_advance(
 struct xfs_fsop_geom;
 int xfs_fsgeometry(int fd, struct xfs_fsop_geom *fsgeo);
 
+struct xfs_bstat;
+int xfs_bulkstat_single(int fd, uint64_t ino, struct xfs_bstat *ubuffer);
+int xfs_bulkstat(int fd, uint64_t *lastino, uint32_t icount,
+		struct xfs_bstat *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/io/open.c b/io/open.c
index b6aacb83..6ceff18d 100644
--- a/io/open.c
+++ b/io/open.c
@@ -712,19 +712,18 @@ get_last_inode(void)
 
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
@@ -766,35 +765,32 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		}
+	} else if (ret_next) {
+		/* get next inode */
+		ret = xfs_bulkstat(file->fd, &userino, 1, &bstat, &count);
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
+		ret = xfs_bulkstat_single(file->fd, userino, &bstat);
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
index d360c221..8b1b1b18 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -20,21 +20,6 @@ swapext_help(void)
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
@@ -60,7 +45,7 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfs_bulkstat_single(file->fd, &stat.st_ino, &sx.sx_stat);
+	error = xfs_bulkstat_single(file->fd, stat.st_ino, &sx.sx_stat);
 	if (error) {
 		perror("bulkstat");
 		goto out;
diff --git a/libhandle/ioctl.c b/libhandle/ioctl.c
index 5c954bd0..a4676fea 100644
--- a/libhandle/ioctl.c
+++ b/libhandle/ioctl.c
@@ -24,3 +24,41 @@ xfs_fsgeometry(
 
 	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
 }
+
+/* Bulkstat a single inode. */
+int
+xfs_bulkstat_single(
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
+xfs_bulkstat(
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
+
diff --git a/quota/quot.c b/quota/quot.c
index d60cf4a8..789e4b40 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -124,12 +124,11 @@ quot_bulkstat_add(
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
 
@@ -158,12 +157,7 @@ quot_bulkstat_mount(
 		return;
 	}
 
-	bulkreq.lastip = &last;
-	bulkreq.icount = NBSTAT;
-	bulkreq.ubuffer = buf;
-	bulkreq.ocount = &count;
-
-	while ((sts = xfsctl(fsdir, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
+	while ((sts = xfs_bulkstat(fsfd, &last, NBSTAT, buf, &count)) == 0) {
 		if (count == 0)
 			break;
 		for (i = 0; i < count; i++)
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 442a5978..702b7d50 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -50,17 +50,10 @@ xfs_iterate_inodes_range_check(
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
@@ -70,10 +63,8 @@ xfs_iterate_inodes_range_check(
 		}
 
 		/* Load the one inode. */
-		oneino = inogrp->xi_startino + i;
-		onereq.ubuffer = bs;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT_SINGLE,
-				&onereq);
+		error = xfs_bulkstat_single(ctx->mnt_fd,
+				inogrp->xi_startino + i, bs);
 		if (error || bs->bs_ino != inogrp->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bstat));
 			bs->bs_ino = inogrp->xi_startino + i;
@@ -99,7 +90,6 @@ xfs_iterate_inodes_range(
 	void			*arg)
 {
 	struct xfs_fsop_bulkreq	igrpreq = {NULL};
-	struct xfs_fsop_bulkreq	bulkreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
@@ -107,8 +97,8 @@ xfs_iterate_inodes_range(
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
@@ -117,10 +107,6 @@ xfs_iterate_inodes_range(
 
 
 	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
-	bulkreq.lastip  = &ino;
-	bulkreq.icount  = XFS_INODES_PER_CHUNK;
-	bulkreq.ubuffer = &bstat;
-	bulkreq.ocount  = &bulklen;
 
 	igrpreq.lastip  = &igrp_ino;
 	igrpreq.icount  = 1;
@@ -138,14 +124,15 @@ xfs_iterate_inodes_range(
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
+		error = xfs_bulkstat(ctx->mnt_fd, &ino, inogrp.xi_alloccount,
+				bstat, &bulklen);
 		if (error)
 			str_info(ctx, descr, "%s", strerror_r(errno,
 						buf, DESCR_BUFSZ));
