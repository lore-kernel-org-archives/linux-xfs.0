Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99FD27D02
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 09:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E7CB8F804C
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:47:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FvzbNQcQuk9ntlgI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2016 07:47:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A614D68E1E
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 14:47:49 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3TElmpv030844
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 10:47:48 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 15/19 v3] mkfs: don't treat files as though they are block
	devices
Date: Fri, 29 Apr 2016 16:47:47 +0200
Message-Id: <1461941267-31556-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461311383-30897-1-git-send-email-jtulak@redhat.com>
References: <1461311383-30897-1-git-send-email-jtulak@redhat.com>
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

From: Dave Chinner <dchinner@redhat.com>

If the device is actually a file, and "-d file" is not specified,
mkfs will try to treat it as a block device and get stuff wrong.
Image files don't necessarily have the same sector sizes as the
block device or filesystem underlying the image file, nor should we
be issuing discard ioctls on image files.

To fix this sanely, only require "-d file" if the device name is
invalid to trigger creation of the file. Otherwise, use stat() to
determine if the device is a file or block device and deal with that
appropriately by setting the "isfile" variables and turning off
direct IO. Then ensure that we check the "isfile" options before
doing things that are specific to block devices.

Other file/blockdev issues fixed:
	- use getstr to detect specifying the data device name
	  twice.
	- check file/size/name parameters before anything else.
	- overwrite checks need to be done before the image file is
	  opened and potentially truncated.
	- blkid_get_topology() should not be called for image files,
	  so warn when it is called that way.
	- zero_old_xfs_structures() emits a spurious error:
		"existing superblock read failed: Success"
	  when it is run on a truncated image file. Don't warn if we
	  see this problem on an image file.
	- Don't issue discards on image files.
	- Use fsync() for image files, not BLKFLSBUF in
	  platform_flush_device() for Linux.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGES:
* read image file size in advance of O_TRUNC in case of dfile&&dcreat
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libxfs/init.c   |  21 ++++++-
 libxfs/linux.c  |  11 +++-
 mkfs/xfs_mkfs.c | 182 ++++++++++++++++++++++++++++++++++++++------------------
 3 files changed, 154 insertions(+), 60 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 8d747e8..c7ae00d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -253,8 +253,15 @@ libxfs_init(libxfs_init_t *a)
 	rtname = a->rtname;
 	a->dfd = a->logfd = a->rtfd = -1;
 	a->ddev = a->logdev = a->rtdev = 0;
-	a->dbsize = a->lbsize = a->rtbsize = 0;
-	a->dsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
+	a->lbsize = a->rtbsize = 0;
+	a->logBBsize = a->logBBstart = a->rtsize = 0;
+
+	// We can reset dbsize only when it is not a file, or we won't
+	// truncate it. Otherwise, we loose the size of the file forever.
+	if (!a->disfile || !a->dcreat) {
+		a->dsize = 0;
+		a->dbsize = 0;
+	}
 
 	(void)getcwd(curdir,MAXPATHLEN);
 	needcd = 0;
@@ -278,6 +285,12 @@ libxfs_init(libxfs_init_t *a)
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
 						    a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
+			// with dcreat, it would overwrite dsize with zero
+			// and lost the size
+			if (!a->dcreat) {
+				platform_findsizes(dname, a->dfd, &a->dsize,
+							&a->dbsize);
+			}
 		} else {
 			if (!check_open(dname, flags, &rawfile, &blockfile))
 				goto done;
@@ -297,6 +310,8 @@ libxfs_init(libxfs_init_t *a)
 			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
+			platform_findsizes(dname, a->logfd, &a->logBBsize,
+						&a->lbsize);
 		} else {
 			if (!check_open(logname, flags, &rawfile, &blockfile))
 				goto done;
@@ -316,6 +331,8 @@ libxfs_init(libxfs_init_t *a)
 			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
+			platform_findsizes(dname, a->rtfd, &a->rtsize,
+						&a->rtbsize);
 		} else {
 			if (!check_open(rtname, flags, &rawfile, &blockfile))
 				goto done;
diff --git a/libxfs/linux.c b/libxfs/linux.c
index f6ea1b2..c9f2baf 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -125,7 +125,16 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
 void
 platform_flush_device(int fd, dev_t device)
 {
-	if (major(device) != RAMDISK_MAJOR)
+	struct stat64	st;
+	if (major(device) == RAMDISK_MAJOR)
+		return;
+
+	if (fstat64(fd, &st) < 0)
+		return;
+
+	if (S_ISREG(st.st_mode))
+		fsync(fd);
+	else
 		ioctl(fd, BLKFLSBUF, 0);
 }
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b1043fb..f75b89c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -787,7 +787,7 @@ calc_stripe_factors(
 #ifdef ENABLE_BLKID
 static int
 check_overwrite(
-	char		*device)
+	const char	*device)
 {
 	const char	*type;
 	blkid_probe	pr = NULL;
@@ -804,7 +804,7 @@ check_overwrite(
 	fd = open(device, O_RDONLY);
 	if (fd < 0)
 		goto out;
-	platform_findsizes(device, fd, &size, &bsz);
+	platform_findsizes((char *)device, fd, &size, &bsz);
 	close(fd);
 
 	/* nothing to overwrite on a 0-length device */
@@ -851,7 +851,6 @@ check_overwrite(
 			"according to blkid\n"), progname, device);
 	}
 	ret = 1;
-
 out:
 	if (pr)
 		blkid_free_probe(pr);
@@ -877,8 +876,12 @@ static void blkid_get_topology(
 	struct stat statbuf;
 
 	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
+	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
+		fprintf(stderr,
+	_("%s: Warning: trying to probe topology of a file %s!\n"),
+			progname, device);
 		return;
+	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)
@@ -988,7 +991,6 @@ static void get_topology(
 	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
 		int fd;
 		int flags = O_RDONLY;
-		long long dummy;
 
 		/* with xi->disfile we may not have the file yet! */
 		if (xi->disfile)
@@ -996,9 +998,10 @@ static void get_topology(
 
 		fd = open(dfile, flags, 0666);
 		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			platform_findsizes(dfile, fd, &xi->dsize, &ft->lsectorsize);
 			close(fd);
 			ft->psectorsize = ft->lsectorsize;
+			xi->dbsize = ft->lsectorsize;	
 		} else
 			ft->psectorsize = ft->lsectorsize = BBSIZE;
 	} else {
@@ -1016,6 +1019,79 @@ static void get_topology(
 }
 
 static void
+check_device_type(
+	const char	*name,
+	int		*isfile,
+	bool		no_size,
+	bool		no_name,
+	int		*create,
+	bool		force_overwrite,
+	const char	*optname)
+{
+	struct stat64 statbuf;
+	/*
+	if (*isfile && (no_size || no_name)) {
+		fprintf(stderr,
+	_("if -%s file then -%s name and -%s size are required\n"),
+			optname, optname, optname);
+		usage();
+	}*/
+
+	if (name == NULL) {
+		usage();
+	}
+
+	if (stat64(name, &statbuf)) {
+		if (errno == ENOENT && *isfile) {
+			if (create)
+				*create = 1;
+			return;
+		}
+
+		fprintf(stderr,
+	_("Error accessing specified device %s: %s\n"),
+				name, strerror(errno));
+		usage();
+		return;
+	}
+
+	if (!force_overwrite && check_overwrite(name)) {
+		fprintf(stderr,
+	_("%s: Use the -f option to force overwrite.\n"),
+			progname);
+		exit(1);
+	}
+
+	/*
+	 * We only want to completely truncate and recreate an existing file if
+	 * we were specifically told it was a file. Set the create flag only in
+	 * this case to trigger that behaviour.
+	 */
+	if (S_ISREG(statbuf.st_mode)) {
+		if (!*isfile)
+			*isfile = 1;
+		else if (create)
+			*create = 1;
+		return;
+	}
+
+	if (S_ISBLK(statbuf.st_mode)) {
+		if (*isfile) {
+			fprintf(stderr,
+	_("specified \"-%s file\" on a block device %s\n"),
+				optname, name);
+			usage();
+		}
+		return;
+	}
+
+	fprintf(stderr,
+	_("specified device %s not a file or block device\n"),
+		name);
+	usage();
+}
+
+static void
 fixup_log_stripe_unit(
 	int		lsflag,
 	int		sunit,
@@ -1280,7 +1356,6 @@ zero_old_xfs_structures(
 	__uint32_t		bsize;
 	int			i;
 	xfs_off_t		off;
-	int			tmp;
 
 	/*
 	 * We open regular files with O_TRUNC|O_CREAT. Nothing to do here...
@@ -1300,15 +1375,18 @@ zero_old_xfs_structures(
 	}
 	memset(buf, 0, new_sb->sb_sectsize);
 
-	tmp = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
-	if (tmp < 0) {
-		fprintf(stderr, _("existing superblock read failed: %s\n"),
-			strerror(errno));
-		goto done;
-	}
-	if (tmp != new_sb->sb_sectsize) {
-		fprintf(stderr,
-	_("warning: could not read existing superblock, skip zeroing\n"));
+	/*
+	 * If we are creating an image file, it might be of zero length at this
+	 * point in time. Hence reading the existing superblock is going to
+	 * return zero bytes. It's not a failure we need to warn about in this
+	 * case.
+	 */
+	off = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
+	if (off != new_sb->sb_sectsize) {
+		if (!xi->disfile)
+			fprintf(stderr,
+	_("error reading existing superblock: %s\n"),
+				strerror(errno));
 		goto done;
 	}
 	libxfs_sb_from_disk(&sb, buf);
@@ -1786,8 +1864,6 @@ main(
 				case D_FILE:
 					xi.disfile = getnum(value, &dopts,
 							    D_FILE);
-					if (xi.disfile && !Nflag)
-						xi.dcreat = 1;
 					break;
 				case D_NAME:
 					xi.dname = getstr(value, &dopts, D_NAME);
@@ -1913,11 +1989,6 @@ main(
 				case L_FILE:
 					xi.lisfile = getnum(value, &lopts,
 							    L_FILE);
-					if (xi.lisfile && loginternal)
-						conflict('l', subopts, L_INTERNAL,
-							 L_FILE);
-					if (xi.lisfile)
-						xi.lcreat = 1;
 					break;
 				case L_INTERNAL:
 					loginternal = getnum(value, &lopts,
@@ -2075,8 +2146,6 @@ main(
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
 							    R_FILE);
-					if (xi.risfile)
-						xi.rcreat = 1;
 					break;
 				case R_NAME:
 				case R_DEV:
@@ -2181,6 +2250,26 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		lsectorsize = sectorsize;
 	}
 
+	/*
+	 * Before anything else, verify that we are correctly operating on
+	 * files or block devices and set the control parameters correctly.
+	 * Explicitly disable direct IO for image files so we don't error out on
+	 * sector size mismatches between the new filesystem and the underlying
+	 * host filesystem.
+	 */
+	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
+			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
+	if (!loginternal)
+		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
+				  Nflag ? NULL : &xi.lcreat,
+				  force_overwrite, "l");
+	if (xi.rtname)
+		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
+				  Nflag ? NULL : &xi.rcreat,
+				  force_overwrite, "r");
+	if (xi.disfile || xi.lisfile || xi.risfile)
+		xi.isdirect = 0;
+
 	memset(&ft, 0, sizeof(ft));
 	get_topology(&xi, &ft, force_overwrite);
 
@@ -2331,11 +2420,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	}
 
 
-	if (xi.disfile && (!dsize || !xi.dname)) {
-		fprintf(stderr,
-	_("if -d file then -d name and -d size are required\n"));
-		usage();
-	}
 	if (dsize) {
 		__uint64_t dbytes;
 
@@ -2368,11 +2452,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		usage();
 	}
 
-	if (xi.lisfile && (!logsize || !xi.logname)) {
-		fprintf(stderr,
-		_("if -l file then -l name and -l size are required\n"));
-		usage();
-	}
 	if (logsize) {
 		__uint64_t logbytes;
 
@@ -2390,11 +2469,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 				(long long)logbytes, blocksize,
 				(long long)(logblocks << blocklog));
 	}
-	if (xi.risfile && (!rtsize || !xi.rtname)) {
-		fprintf(stderr,
-		_("if -r file then -r name and -r size are required\n"));
-		usage();
-	}
 	if (rtsize) {
 		__uint64_t rtbytes;
 
@@ -2516,22 +2590,14 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	xi.rtsize &= sector_mask;
 	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
 
-	if (!force_overwrite) {
-		if (check_overwrite(dfile) ||
-		    check_overwrite(logfile) ||
-		    check_overwrite(xi.rtname)) {
-			fprintf(stderr,
-			_("%s: Use the -f option to force overwrite.\n"),
-				progname);
-			exit(1);
-		}
-	}
 
+	/* don't do discards on print-only runs or on files */
 	if (discard && !Nflag) {
-		discard_blocks(xi.ddev, xi.dsize);
-		if (xi.rtdev)
+		if (!xi.disfile)
+			discard_blocks(xi.ddev, xi.dsize);
+		if (xi.rtdev && !xi.risfile)
 			discard_blocks(xi.rtdev, xi.rtsize);
-		if (xi.logdev && xi.logdev != xi.ddev)
+		if (xi.logdev && xi.logdev != xi.ddev && !xi.lisfile)
 			discard_blocks(xi.logdev, xi.logBBsize);
 	}
 
@@ -3063,10 +3129,12 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * so that the reads for the end of the device in the mount code
 	 * will succeed.
 	 */
-	if (xi.disfile && ftruncate64(xi.dfd, dblocks * blocksize) < 0) {
-		fprintf(stderr, _("%s: Growing the data section failed\n"),
-			progname);
-		exit(1);
+	if (xi.disfile && xi.dsize*xi.dbsize <=  dblocks * blocksize) {
+		if (ftruncate64(xi.dfd, dblocks * blocksize) < 0) {
+			fprintf(stderr, _("%s: Growing the data section failed\n"),
+				progname);
+			exit(1);
+		}
 	}
 
 	/*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
