Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BI9fRb167855 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 12:09:41 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B25A159DDA
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:10:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KmxV417NCOYsQHii for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:10:35 -0800 (PST)
Message-ID: <4B4B6990.8090604@sandeen.net>
Date: Mon, 11 Jan 2010 12:10:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] mkfs: handle 4k sector devices more cleanly
References: <4B1E9A25.50108@redhat.com> <4B476171.4020701@sandeen.net>
In-Reply-To: <4B476171.4020701@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Trying to mkfs a 4k sector device today fails w/o manually specifying
sector size:

# modprobe scsi_debug sector_size=4096 dev_size_mb=32
# mkfs.xfs -f /dev/sdc
mkfs.xfs: warning - cannot set blocksize on block device /dev/sdc: Invalid argument
Warning: the data subvolume sector size 512 is less than the sector size 
reported by the device (4096).
... <fail>

add sectorsize to the device topology info, and use that if present.

Also check that explicitly requested sector sizes are not smaller
than the hardware size.  This already fails today, but with the more
cryptic "cannot set blocksize" ioctl error above.

With a few more suggested comments & cleanups from Christoph.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/libxfs.h b/include/libxfs.h
index ab37a60..e7199c7 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -115,6 +115,7 @@ extern void	libxfs_device_zero (dev_t, xfs_daddr_t, uint);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
+extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef xfs_caddr_t (libxfs_get_block_t)(xfs_caddr_t, int, void *);
diff --git a/libxfs/init.h b/libxfs/init.h
index 1f27af6..f0b8cb6 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -24,7 +24,6 @@ extern int platform_check_ismounted (char *path, char *block,
 					struct stat64 *sptr, int verbose);
 extern int platform_check_iswritable (char *path, char *block,
 					struct stat64 *sptr, int fatal);
-extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);
 extern int platform_set_blocksize (int fd, char *path, dev_t device, int bsz, int fatal);
 extern void platform_flush_device (int fd, dev_t device);
 extern char *platform_findrawpath(char *path);
diff --git a/libxfs/linux.c b/libxfs/linux.c
index bc49903..2e07d54 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -112,9 +112,9 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
 	if (major(device) != RAMDISK_MAJOR) {
 		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
 			fprintf(stderr, _("%s: %s - cannot set blocksize "
-					"on block device %s: %s\n"),
+					"%d on block device %s: %s\n"),
 				progname, fatal ? "error": "warning",
-				path, strerror(errno));
+				blocksize, path, strerror(errno));
 		}
 	}
 	return error;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d3ed00a..64b324c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -33,6 +33,7 @@ struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
+	int	sectorsize;
 	int	sectoralign;
 };
 
@@ -320,7 +321,7 @@ out_free_probe:
 	return ret;
 }
 
-static void blkid_get_topology(const char *device, int *sunit, int *swidth)
+static void blkid_get_topology(const char *device, int *sunit, int *swidth, int *sectorsize)
 {
 	blkid_topology tp;
 	blkid_probe pr;
@@ -348,6 +349,8 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth)
 	val = blkid_topology_get_optimal_io_size(tp) >> 9;
 	if (val > 1)
 		*swidth = val;
+	val = blkid_probe_get_sectorsize(pr);
+	*sectorsize = val;
 
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
@@ -370,13 +373,14 @@ static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
 	if (!xi->disfile) {
 		const char *dfile = xi->volname ? xi->volname : xi->dname;
 
-		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth);
+		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
+				   &ft->sectorsize);
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int dummy;
 
-		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth);
+		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy);
 	}
 }
 #else /* ENABLE_BLKID */
@@ -403,15 +407,29 @@ check_overwrite(
 	return 0;
 }
 
+extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);
+
 static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
 {
 	char *dfile = xi->volname ? xi->volname : xi->dname;
+	int bsz = BBSIZE;
 
 	if (!xi->disfile) {
+		int fd;
+		long long dummy;
+
 		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
 				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
+		fd = open(dfile, O_RDONLY);
+		/* If this fails we just fall back to BBSIZE */
+		if (fd) {
+			platform_findsizes(dfile, fd, &dummy, &bsz);
+			close(fd);
+		}
 	}
 
+	ft->sectorsize = bsz;
+
 	if (xi->rtname && !xi->risfile) {
 		int dummy1;
 
@@ -1544,18 +1562,41 @@ main(
 	get_topology(&xi, &ft);
 
 	if (ft.sectoralign) {
+		/*
+		 * Older Linux software RAID versions want the sector size
+		 * to match the block size to avoid switching I/O sizes.
+		 * For the legacy libdisk case we thus set the sector size to
+		 * match the block size.  For systems using libblkid we assume
+		 * that the kernel is recent enough to not require this and
+		 * ft.sectoralign will never be set.
+		 */
 		sectorsize = blocksize;
+	} else if (!ssflag) {
+		/*
+		 * Unless specified manually on the command line use the
+		 * advertised sector size of the device.
+		 */
+		sectorsize = ft.sectorsize;
+	}
+
+	if (ft.sectoralign || !ssflag) {
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
 			lsectorlog = sectorlog;
 		}
 	}
+
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
 		fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		usage();
 	}
+	if (sectorsize < ft.sectorsize) {
+		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
+			sectorsize, ft.sectorsize);
+		usage();
+	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
 	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
 		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
@@ -1749,10 +1790,7 @@ main(
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
-	if (slflag || ssflag)
-		xi.setblksize = sectorsize;
-	else
-		xi.setblksize = 1;
+	xi.setblksize = sectorsize;
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
