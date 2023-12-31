Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E62C8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRIAYy3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D66C433C8;
	Sun, 31 Dec 2023 22:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061874;
	bh=TM9NXqiMHDSBaX9QW4FIpK2KcrK+zbON4AXSzj9JQxE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qRIAYy3AyWxeJO6aZFZXhickcLPrZDnGv71PlvzjerqObfmNXIJWFAa16IWKxUeNS
	 MwAhrjBPcHYH95rLHA0tB3XCiRWG2P+VNG5KFLehF7dD93z90usprB6kTzXa+RGjMS
	 aVFUo0wyMAXHRM6WCYcqQqPE0mWFzo5hy7Z2CQLWH/eqhkPUyn6yZUrpbdUGTg5Oa6
	 Rzz3hB9su1yRmi18MxTXbdeZITYmEFpCPI3OMbQ8EsIyRcJGkGiBeHpsX4wRyZ9RF+
	 A3c0B2GRW9XJ4kQ3IJdVOtGb7m/TKoCmDyQc8d5kMNVRHB9GsaoB6vQdG4KQuMiW5V
	 ZjjPCdBK+J0Fg==
Date: Sun, 31 Dec 2023 14:31:13 -0800
Subject: [PATCH 16/20] xfs_fsr: convert to bulkstat v5 ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996489.1796128.15788565040447636713.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that libhandle can, er, handle bulkstat information coming from the
v5 bulkstat ioctl, port xfs_fsr to use the new interfaces instead of
repeatedly converting things back and forth.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c    |  148 ++++++++++++++++++++++++++++++------------------------
 libfrog/fsgeom.c |   45 ++++++++++++----
 libfrog/fsgeom.h |    1 
 3 files changed, 117 insertions(+), 77 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index ba02506d8e4..8e916faee94 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -65,10 +65,10 @@ static int	pagesize;
 
 void usage(int ret);
 static int  fsrfile(char *fname, xfs_ino_t ino);
-static int  fsrfile_common( char *fname, char *tname, char *mnt,
-                            int fd, struct xfs_bstat *statp);
-static int  packfile(char *fname, char *tname, int fd,
-                     struct xfs_bstat *statp, struct fsxattr *fsxp);
+static int  fsrfile_common(char *fname, char *tname, char *mnt,
+			   struct xfs_fd *file_fd, struct xfs_bulkstat *statp);
+static int  packfile(char *fname, char *tname, struct xfs_fd *file_fd,
+                     struct xfs_bulkstat *statp, struct fsxattr *fsxp);
 static void fsrdir(char *dirname);
 static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
 static void initallfs(char *mtab);
@@ -80,7 +80,7 @@ int xfs_getrt(int fd, struct statvfs *sfbp);
 char * gettmpname(char *fname);
 char * getparent(char *fname);
 int fsrprintf(const char *fmt, ...);
-int read_fd_bmap(int, struct xfs_bstat *, int *);
+int read_fd_bmap(int, struct xfs_bulkstat *, int *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
@@ -102,6 +102,26 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
 				 * of extents */
 static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
 
+/*
+ * Open a file on an XFS filesystem from file handle components and fs geometry
+ * data.  Returns zero or a negative error code.
+ */
+static int
+open_handle(
+	struct xfs_fd		*xfd,
+	jdm_fshandle_t		*fshandle,
+	struct xfs_bulkstat	*bulkstat,
+	struct xfs_fsop_geom	*fsgeom,
+	int			flags)
+{
+	xfd->fd = jdm_open_v5(fshandle, bulkstat, flags);
+	if (xfd->fd < 0)
+		return errno;
+
+	xfd_install_geometry(xfd, fsgeom);
+	return 0;
+}
+
 static int
 xfs_swapext(int fd, xfs_swapext_t *sx)
 {
@@ -600,7 +620,6 @@ static int
 fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 {
 	struct xfs_fd	fsxfd = XFS_FD_INIT_EMPTY;
-	int	fd;
 	int	count = 0;
 	int	ret;
 	char	fname[64];
@@ -638,10 +657,10 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	}
 
 	while ((ret = -xfrog_bulkstat(&fsxfd, breq) == 0)) {
-		struct xfs_bstat	bs1;
 		struct xfs_bulkstat	*buf = breq->bulkstat;
 		struct xfs_bulkstat	*p;
 		struct xfs_bulkstat	*endp;
+		struct xfs_fd		file_fd = XFS_FD_INIT_EMPTY;
 		uint32_t		buflenout = breq->hdr.ocount;
 
 		if (buflenout == 0)
@@ -658,15 +677,9 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			     (p->bs_extents64 < 2))
 				continue;
 
-			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
+			ret = open_handle(&file_fd, fshandlep, p,
+					&fsxfd.fsgeom, O_RDWR | O_DIRECT);
 			if (ret) {
-				fsrprintf(_("bstat conversion error: %s\n"),
-						strerror(ret));
-				continue;
-			}
-
-			fd = jdm_open(fshandlep, &bs1, O_RDWR | O_DIRECT);
-			if (fd < 0) {
 				/* This probably means the file was
 				 * removed while in progress of handling
 				 * it.  Just quietly ignore this file.
@@ -683,11 +696,12 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			/* Get a tmp file name */
 			tname = tmp_next(mntdir);
 
-			ret = fsrfile_common(fname, tname, mntdir, fd, &bs1);
+			ret = fsrfile_common(fname, tname, mntdir, &file_fd,
+					p);
 
 			leftoffino = p->bs_ino;
 
-			close(fd);
+			xfd_close(&file_fd);
 
 			if (ret == 0) {
 				if (--count <= 0)
@@ -735,9 +749,8 @@ fsrfile(
 {
 	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
 	struct xfs_bulkstat	bulkstat;
-	struct xfs_bstat	statbuf;
+	struct xfs_fd		file_fd = XFS_FD_INIT_EMPTY;
 	jdm_fshandle_t		*fshandlep;
-	int			fd = -1;
 	int			error = -1;
 	char			*tname;
 
@@ -765,17 +778,12 @@ fsrfile(
 			fname, strerror(error));
 		goto out;
 	}
-	error = -xfrog_bulkstat_v5_to_v1(&fsxfd, &statbuf, &bulkstat);
-	if (error) {
-		fsrprintf(_("bstat conversion error on %s: %s\n"),
-			fname, strerror(error));
-		goto out;
-	}
 
-	fd = jdm_open(fshandlep, &statbuf, O_RDWR|O_DIRECT);
-	if (fd < 0) {
+	error = open_handle(&file_fd, fshandlep, &bulkstat, &fsxfd.fsgeom,
+			O_RDWR | O_DIRECT);
+	if (error) {
 		fsrprintf(_("unable to open handle %s: %s\n"),
-			fname, strerror(errno));
+			fname, strerror(error));
 		goto out;
 	}
 
@@ -783,14 +791,13 @@ fsrfile(
 	memcpy(&fsgeom, &fsxfd.fsgeom, sizeof(fsgeom));
 
 	tname = gettmpname(fname);
-
 	if (tname)
-		error = fsrfile_common(fname, tname, NULL, fd, &statbuf);
+		error = fsrfile_common(fname, tname, NULL, &file_fd,
+				&bulkstat);
 
 out:
 	xfd_close(&fsxfd);
-	if (fd >= 0)
-		close(fd);
+	xfd_close(&file_fd);
 	free(fshandlep);
 
 	return error;
@@ -816,8 +823,8 @@ fsrfile_common(
 	char		*fname,
 	char		*tname,
 	char		*fsname,
-	int		fd,
-	struct xfs_bstat *statp)
+	struct xfs_fd	*file_fd,
+	struct xfs_bulkstat *statp)
 {
 	int		error;
 	struct statvfs  vfss;
@@ -827,7 +834,7 @@ fsrfile_common(
 	if (vflag)
 		fsrprintf("%s\n", fname);
 
-	if (fsync(fd) < 0) {
+	if (fsync(file_fd->fd) < 0) {
 		fsrprintf(_("sync failed: %s: %s\n"), fname, strerror(errno));
 		return -1;
 	}
@@ -851,7 +858,7 @@ fsrfile_common(
 		fl.l_whence = SEEK_SET;
 		fl.l_start = (off_t)0;
 		fl.l_len = 0;
-		if ((fcntl(fd, F_GETLK, &fl)) < 0 ) {
+		if ((fcntl(file_fd->fd, F_GETLK, &fl)) < 0 ) {
 			if (vflag)
 				fsrprintf(_("locking check failed: %s\n"),
 					fname);
@@ -869,7 +876,7 @@ fsrfile_common(
 	/*
 	 * Check if there is room to copy the file.
 	 *
-	 * Note that xfs_bstat.bs_blksize returns the filesystem blocksize,
+	 * Note that xfs_bulkstat.bs_blksize returns the filesystem blocksize,
 	 * not the optimal I/O size as struct stat.
 	 */
 	if (statvfs(fsname ? fsname : fname, &vfss) < 0) {
@@ -886,7 +893,7 @@ fsrfile_common(
 		return 1;
 	}
 
-	if ((ioctl(fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+	if ((ioctl(file_fd->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fsrprintf(_("failed to get inode attrs: %s\n"), fname);
 		return(-1);
 	}
@@ -902,7 +909,7 @@ fsrfile_common(
 		return(0);
 	}
 	if (fsx.fsx_xflags & FS_XFLAG_REALTIME) {
-		if (xfs_getrt(fd, &vfss) < 0) {
+		if (xfs_getrt(file_fd->fd, &vfss) < 0) {
 			fsrprintf(_("cannot get realtime geometry for: %s\n"),
 				fname);
 			return(-1);
@@ -928,7 +935,7 @@ fsrfile_common(
 	 * file we're defragging, in packfile().
 	 */
 
-	if ((error = packfile(fname, tname, fd, statp, &fsx)))
+	if ((error = packfile(fname, tname, file_fd, statp, &fsx)))
 		return error;
 	return -1; /* no error */
 }
@@ -952,7 +959,7 @@ static int
 fsr_setup_attr_fork(
 	int		fd,
 	int		tfd,
-	struct xfs_bstat *bstatp)
+	struct xfs_bulkstat *bstatp)
 {
 #ifdef HAVE_FSETXATTR
 	struct xfs_fd	txfd = XFS_FD_INIT(tfd);
@@ -1136,23 +1143,28 @@ fsr_setup_attr_fork(
  *  1: No change / No Error
  */
 static int
-packfile(char *fname, char *tname, int fd,
-	 struct xfs_bstat *statp, struct fsxattr *fsxp)
+packfile(
+	char			*fname,
+	char			*tname,
+	struct xfs_fd		*file_fd,
+	struct xfs_bulkstat	*statp,
+	struct fsxattr		*fsxp)
 {
-	int 		tfd = -1;
-	int		srval;
-	int		retval = -1;	/* Failure is the default */
-	int		nextents, extent, cur_nextents, new_nextents;
-	unsigned	blksz_dio;
-	unsigned	dio_min;
-	struct dioattr	dio;
-	static xfs_swapext_t   sx;
-	struct xfs_flock64  space;
-	off64_t 	cnt, pos;
-	void 		*fbuf = NULL;
-	int 		ct, wc, wc_b4;
-	char		ffname[SMBUFSZ];
-	int		ffd = -1;
+	int			tfd = -1;
+	int			srval;
+	int			retval = -1;	/* Failure is the default */
+	int			nextents, extent, cur_nextents, new_nextents;
+	unsigned		blksz_dio;
+	unsigned		dio_min;
+	struct dioattr		dio;
+	static xfs_swapext_t	sx;
+	struct xfs_flock64	space;
+	off64_t			cnt, pos;
+	void			*fbuf = NULL;
+	int			ct, wc, wc_b4;
+	char			ffname[SMBUFSZ];
+	int			ffd = -1;
+	int			error;
 
 	/*
 	 * Work out the extent map - nextents will be set to the
@@ -1160,7 +1172,7 @@ packfile(char *fname, char *tname, int fd,
 	 * into account holes), cur_nextents is the current number
 	 * of extents.
 	 */
-	nextents = read_fd_bmap(fd, statp, &cur_nextents);
+	nextents = read_fd_bmap(file_fd->fd, statp, &cur_nextents);
 
 	if (cur_nextents == 1 || cur_nextents <= nextents) {
 		if (vflag)
@@ -1183,7 +1195,7 @@ packfile(char *fname, char *tname, int fd,
 	unlink(tname);
 
 	/* Setup extended attributes */
-	if (fsr_setup_attr_fork(fd, tfd, statp) != 0) {
+	if (fsr_setup_attr_fork(file_fd->fd, tfd, statp) != 0) {
 		fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);
 		goto out;
 	}
@@ -1301,7 +1313,7 @@ packfile(char *fname, char *tname, int fd,
 				   tname, strerror(errno));
 				goto out;
 			}
-			if (lseek(fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+			if (lseek(file_fd->fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
 				fsrprintf(_("could not lseek in file: %s : %s\n"),
 				   fname, strerror(errno));
 				goto out;
@@ -1321,7 +1333,7 @@ packfile(char *fname, char *tname, int fd,
 				ct = min(cnt + dio_min - (cnt % dio_min),
 					blksz_dio);
 			}
-			ct = read(fd, fbuf, ct);
+			ct = read(file_fd->fd, fbuf, ct);
 			if (ct == 0) {
 				/* EOF, stop trying to read */
 				extent = nextents;
@@ -1392,9 +1404,15 @@ packfile(char *fname, char *tname, int fd,
 		goto out;
 	}
 
-	sx.sx_stat     = *statp; /* struct copy */
+	error = -xfrog_bulkstat_v5_to_v1(file_fd, &sx.sx_stat, statp);
+	if (error) {
+		fsrprintf(_("bstat conversion error on %s: %s\n"),
+				fname, strerror(error));
+		goto out;
+	}
+
 	sx.sx_version  = XFS_SX_VERSION;
-	sx.sx_fdtarget = fd;
+	sx.sx_fdtarget = file_fd->fd;
 	sx.sx_fdtmp    = tfd;
 	sx.sx_offset   = 0;
 	sx.sx_length   = statp->bs_size;
@@ -1408,7 +1426,7 @@ packfile(char *fname, char *tname, int fd,
         }
 
 	/* Swap the extents */
-	srval = xfs_swapext(fd, &sx);
+	srval = xfs_swapext(file_fd->fd, &sx);
 	if (srval < 0) {
 		if (errno == ENOTSUP) {
 			if (vflag || dflag)
@@ -1504,7 +1522,7 @@ getparent(char *fname)
 #define MAPSIZE	128
 #define	OUTMAP_SIZE_INCREMENT	MAPSIZE
 
-int	read_fd_bmap(int fd, struct xfs_bstat *sin, int *cur_nextents)
+int	read_fd_bmap(int fd, struct xfs_bulkstat *sin, int *cur_nextents)
 {
 	int		i, cnt;
 	struct getbmap	map[MAPSIZE];
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 3e7f0797d8b..6980d3ffab6 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -102,29 +102,50 @@ xfrog_geometry(
 	return -errno;
 }
 
-/*
- * Prepare xfs_fd structure for future ioctl operations by computing the xfs
- * geometry for @xfd->fd.  Returns zero or a negative error code.
- */
-int
-xfd_prepare_geometry(
+/* Compute conversion factors of an xfs_fd structure. */
+static void
+xfd_compute_conversion_factors(
 	struct xfs_fd		*xfd)
 {
-	int			ret;
-
-	ret = xfrog_geometry(xfd->fd, &xfd->fsgeom);
-	if (ret)
-		return ret;
-
 	xfd->agblklog = log2_roundup(xfd->fsgeom.agblocks);
 	xfd->blocklog = highbit32(xfd->fsgeom.blocksize);
 	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
 	xfd->inopblog = xfd->blocklog - xfd->inodelog;
 	xfd->aginolog = xfd->agblklog + xfd->inopblog;
 	xfd->blkbb_log = xfd->blocklog - BBSHIFT;
+}
+
+/*
+ * Prepare xfs_fd structure for future ioctl operations by computing the xfs
+ * geometry for @xfd->fd.  Returns zero or a negative error code.
+ */
+int
+xfd_prepare_geometry(
+	struct xfs_fd		*xfd)
+{
+	int			ret;
+
+	ret = xfrog_geometry(xfd->fd, &xfd->fsgeom);
+	if (ret)
+		return ret;
+
+	xfd_compute_conversion_factors(xfd);
 	return 0;
 }
 
+/*
+ * Prepare xfs_fd structure for future ioctl operations by computing the xfs
+ * geometry for @xfd->fd.  Returns zero or a negative error code.
+ */
+void
+xfd_install_geometry(
+	struct xfs_fd		*xfd,
+	struct xfs_fsop_geom	*fsgeom)
+{
+	memcpy(&xfd->fsgeom, fsgeom, sizeof(*fsgeom));
+	xfd_compute_conversion_factors(xfd);
+}
+
 /* Open a file on an XFS filesystem.  Returns zero or a negative error code. */
 int
 xfd_open(
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 2ff748caaf4..7e002c5137a 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -61,6 +61,7 @@ struct xfs_fd {
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
 
 int xfd_prepare_geometry(struct xfs_fd *xfd);
+void xfd_install_geometry(struct xfs_fd *xfd, struct xfs_fsop_geom *fsgeom);
 int xfd_open(struct xfs_fd *xfd, const char *pathname, int flags);
 int xfd_close(struct xfs_fd *xfd);
 

