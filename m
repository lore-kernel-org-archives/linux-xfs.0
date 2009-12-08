Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB8IP098164370 for <xfs@oss.sgi.com>; Tue, 8 Dec 2009 12:25:00 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97B78193A522
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2009 10:25:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lqtz7BpKv5Y7YD7h for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2009 10:25:33 -0800 (PST)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB8IPXiW003669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 8 Dec 2009 13:25:33 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nB8IPTjs010964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 8 Dec 2009 13:25:32 -0500
Message-ID: <4B1E9A25.50108@redhat.com>
Date: Tue, 08 Dec 2009 12:25:41 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] mkfs: handle 4k sector devices more cleanly
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
To: xfs-oss <xfs@oss.sgi.com>

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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
index bd92bc0..be8271e 100644
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
@@ -348,7 +349,9 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth)
 	val = blkid_topology_get_optimal_io_size(tp) >> 9;
 	if (val > 1)
 		*swidth = val;
-
+	val = blkid_probe_get_sectorsize(pr);
+	if (val > 1)
+		*sectorsize = val;
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
 			_("warning: device is not properly aligned %s\n"),
@@ -370,13 +373,13 @@ static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
 	if (!xi->disfile) {
 		const char *dfile = xi->volname ? xi->volname : xi->dname;
 
-		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth);
+		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth, &ft->sectorsize);
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int dummy;
 
-		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth);
+		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy);
 	}
 }
 #else /* ENABLE_BLKID */
@@ -1543,8 +1546,15 @@ main(
 	memset(&ft, 0, sizeof(ft));
 	get_topology(&xi, &ft);
 
-	if (ft.sectoralign) {
-		sectorsize = blocksize;
+	/*
+	 * MD wants sector size set == block size to avoid switching.
+	 * Otherwise, if not specfied via command, use device sectorsize
+	 */
+	if (ft.sectoralign || !ssflag) {
+		if (ft.sectoralign)
+			sectorsize = blocksize;
+		else
+			sectorsize = ft.sectorsize;
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
@@ -1556,6 +1566,11 @@ main(
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
@@ -1749,10 +1764,10 @@ main(
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
-	if (slflag || ssflag)
+	if (slflag || ssflag || ft.setorsize)
 		xi.setblksize = sectorsize;
 	else
-		xi.setblksize = 1;
+		xi.setblksize = 1; /* Use default sector size */
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
