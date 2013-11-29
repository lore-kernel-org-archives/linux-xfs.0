Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8249229E19
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:44:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 524F38F8035
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:44:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ywJwYA8Ug3keDbsG for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:44:06 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VmD7Y-0006Iw-V5
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VmD7Y-0002f8-UO
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 12:43:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/15] mkfs: don't treat files as though they are block devices
Date: Fri, 29 Nov 2013 12:43:50 +1100
Message-Id: <1385689430-10103-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1385689430-10103-1-git-send-email-david@fromorbit.com>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
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
---
 libxfs/linux.c  |  11 +++-
 mkfs/xfs_mkfs.c | 167 +++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 126 insertions(+), 52 deletions(-)

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2e07d54..2fd529c 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -123,7 +123,16 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
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
index 88dd53e..c1e3e9d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -701,7 +701,7 @@ calc_stripe_factors(
  */
 static int
 check_overwrite(
-	char		*device)
+	const char	*device)
 {
 	const char	*type;
 	blkid_probe	pr = NULL;
@@ -718,7 +718,7 @@ check_overwrite(
 	fd = open(device, O_RDONLY);
 	if (fd < 0)
 		goto out;
-	platform_findsizes(device, fd, &size, &bsz);
+	platform_findsizes((char *)device, fd, &size, &bsz);
 	close(fd);
 
 	/* nothing to overwrite on a 0-length device */
@@ -765,7 +765,6 @@ check_overwrite(
 			"according to blkid\n"), progname, device);
 	}
 	ret = 1;
-
 out:
 	if (pr)
 		blkid_free_probe(pr);
@@ -791,8 +790,12 @@ static void blkid_get_topology(
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
@@ -870,7 +873,7 @@ static void get_topology(
 #else /* ENABLE_BLKID */
 static int
 check_overwrite(
-	char		*device)
+	const char	*device)
 {
 	char		*type;
 
@@ -927,6 +930,75 @@ static void get_topology(
 #endif /* ENABLE_BLKID */
 
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
+
+	if (*isfile && (no_size || no_name)) {
+		fprintf(stderr,
+	_("if -%s file then -%s name and -%s size are required\n"),
+			optname, optname, optname);
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
@@ -1203,11 +1275,19 @@ zero_old_xfs_structures(
 	}
 	memset(buf, 0, new_sb->sb_sectsize);
 
-	if (pread(xi->dfd, buf, new_sb->sb_sectsize, 0) != new_sb->sb_sectsize) {
-		fprintf(stderr, _("existing superblock read failed: %s\n"),
-			strerror(errno));
-		free(buf);
-		return;
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
+		goto done;
 	}
 	libxfs_sb_from_disk(&sb, buf);
 
@@ -1645,8 +1725,6 @@ main(
 				case D_FILE:
 					xi.disfile = getnum(value, &dopts,
 							    D_FILE);
-					if (xi.disfile && !Nflag)
-						xi.dcreat = 1;
 					break;
 				case D_NAME:
 					xi.dname = getstr(value, &dopts, D_NAME);
@@ -1768,8 +1846,6 @@ main(
 				case L_FILE:
 					xi.lisfile = getnum(value, &lopts,
 							    L_FILE);
-					if (xi.lisfile)
-						xi.lcreat = 1;
 					break;
 				case L_INTERNAL:
 					loginternal = getnum(value, &lopts,
@@ -1926,8 +2002,6 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
 							    R_FILE);
-					if (xi.risfile)
-						xi.rcreat = 1;
 					break;
 				case R_NAME:
 				case R_DEV:
@@ -1994,13 +2068,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 		fprintf(stderr, _("extra arguments\n"));
 		usage();
 	} else if (argc - optind == 1) {
-		dfile = xi.volname = argv[optind];
-		if (xi.dname) {
-			fprintf(stderr,
-				_("cannot specify both %s and -d name=%s\n"),
-				xi.volname, xi.dname);
-			usage();
-		}
+		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
 	} else
 		dfile = xi.dname;
 
@@ -2027,6 +2095,26 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
 		lsectorsize = sectorsize;
 	}
 
+	/*
+	 * Before anything else, verify that we are correctly operating on
+	 * files or block devices and set the control parameters correctly.
+	 * Explicitly disable direct IO for image files so we don't error out on
+	 * sector size mismatches between the new filesystem and the underlying
+	 * host filesystem.
+	 */
+	check_device_type(dfile, &xi.disfile, !dsize, !xi.dname,
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
 
@@ -2167,11 +2255,6 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	}
 
 
-	if (xi.disfile && (!dsize || !xi.dname)) {
-		fprintf(stderr,
-	_("if -d file then -d name and -d size are required\n"));
-		usage();
-	}
 	if (dsize) {
 		__uint64_t dbytes;
 
@@ -2204,11 +2287,6 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		usage();
 	}
 
-	if (xi.lisfile && (!logsize || !xi.logname)) {
-		fprintf(stderr,
-		_("if -l file then -l name and -l size are required\n"));
-		usage();
-	}
 	if (logsize) {
 		__uint64_t logbytes;
 
@@ -2226,11 +2304,6 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
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
 
@@ -2354,22 +2427,14 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
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
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
