Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 23:33:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k966WsaG023628
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 23:32:58 -0700
Date: Fri, 06 Oct 2006 16:34:03 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: review: set blocksize patch - libxfs & mkfs
Message-ID: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Request for review of libxfs patch.

Thanks.

--Tim

Subject: Re: LVM and XFS cannot set blocksize on block device

Shailendra wrote:
    libxfs_device_open () seems to be working with the pre-conceived notion
    of assuming block devices of only 512 bytes in size.
    This eventually calls to set the blk sz to 512. Since, your volume does
    not support less than 4k, it returns EINVAL. I think, libxfs_init should
    be modified to pass on the -s size option to this call so that it
    does not happen.
    ...

Index: xfsprogs/doc/CHANGES
===================================================================
--- xfsprogs/doc/CHANGES.orig	2006-10-06 14:12:51.000000000 +1000
+++ xfsprogs/doc/CHANGES	2006-10-06 14:14:03.000000000 +1000
@@ -1,6 +1,11 @@
-xfsprogs-2.8.xx (??)
+xfsprogs-2.8.14 (6 October 2006)
 	- Fix up the ring command in xfs_db,
 	  thanks to Utako Kusaka
+	- Set the blocksize on the device to the given sector
+	  size which is _not_ necessarily 512 bytes;
+	  idea suggested by Shailendra Tripathi.
+	- Fix up xfs_copy and its variable argument handling
+	  around vfprintf; xfs_copy was seg faulting on x86_64.

 xfsprogs-2.8.13 (21 September 2006)
 	- Fix v2 directory checking with holes and unreadable blocks.
Index: xfsprogs/libxfs/darwin.c
===================================================================
--- xfsprogs/libxfs/darwin.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/darwin.c	2006-10-06 14:14:03.000000000 +1000
@@ -51,8 +51,8 @@
 	return (writable == 0);
 }

-void
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
int fatal)
 {
 }

Index: xfsprogs/libxfs/freebsd.c
===================================================================
--- xfsprogs/libxfs/freebsd.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/freebsd.c	2006-10-06 14:14:03.000000000 +1000
@@ -91,8 +91,8 @@
 	return 0;
 }

-void
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
int fatal)
 {
 	return;
 }
Index: xfsprogs/libxfs/init.c
===================================================================
--- xfsprogs/libxfs/init.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/init.c	2006-10-06 14:14:03.000000000 +1000
@@ -116,8 +116,16 @@
 		exit(1);
 	}

-	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
-		platform_set_blocksize(fd, path, statb.st_rdev, 512);
+	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
+		if (setblksize == 1)
+			/* use the default blocksize */
+			(void)platform_set_blocksize(fd, path, statb.st_rdev, 
XFS_MIN_SECTORSIZE, 0);
+		else {
+			/* given an explicit blocksize to use */
+			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
+			    exit(1);
+		}
+	}

 	/*
 	 * Get the device number from the stat buf - unless
Index: xfsprogs/libxfs/irix.c
===================================================================
--- xfsprogs/libxfs/irix.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/irix.c	2006-10-06 14:14:03.000000000 +1000
@@ -36,8 +36,8 @@
 	return 1;
 }

-void
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
int fatal)
 {
 	return;
 }
Index: xfsprogs/libxfs/linux.c
===================================================================
--- xfsprogs/libxfs/linux.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/linux.c	2006-10-06 14:14:03.000000000 +1000
@@ -102,16 +102,20 @@
 	return sts;
 }

-void
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
int fatal)
 {
+	int error = 0;
+
 	if (major(device) != RAMDISK_MAJOR) {
-		if (ioctl(fd, BLKBSZSET, &blocksize) < 0) {
-			fprintf(stderr, _("%s: warning - cannot set blocksize "
+		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
+			fprintf(stderr, _("%s: %s - cannot set blocksize "
 					"on block device %s: %s\n"),
-				progname, path, strerror(errno));
+				progname, fatal ? "error": "warning",
+				path, strerror(errno));
 		}
 	}
+	return error;
 }

 void
Index: xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs/mkfs/xfs_mkfs.c.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/mkfs/xfs_mkfs.c	2006-10-06 14:14:03.000000000 +1000
@@ -634,7 +634,6 @@
 	bzero(&fsx, sizeof(fsx));

 	bzero(&xi, sizeof(xi));
-	xi.setblksize = 1;
 	xi.isdirect = LIBXFS_DIRECT;
 	xi.isreadonly = LIBXFS_EXCLUSIVELY;

@@ -1506,6 +1505,11 @@
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);

+	if (slflag || ssflag)
+	    xi.setblksize = sectorsize;
+	else
+	    xi.setblksize = 1;
+
 	/*
 	 * Initialize.  This will open the log and rt devices as well.
 	 */
Index: xfsprogs/libxfs/init.h
===================================================================
--- xfsprogs/libxfs/init.h.orig	2006-10-06 14:12:27.000000000 +1000
+++ xfsprogs/libxfs/init.h	2006-10-06 14:14:03.000000000 +1000
@@ -25,7 +25,7 @@
 extern int platform_check_iswritable (char *path, char *block,
 					struct stat64 *sptr, int fatal);
 extern void platform_findsizes (char *path, int fd, long long *sz, int 
*bsz);
-extern void platform_set_blocksize (int fd, char *path, dev_t device, int 
bsz);
+extern int platform_set_blocksize (int fd, char *path, dev_t device, int 
bsz, int fatal);
 extern void platform_flush_device (int fd, dev_t device);
 extern char *platform_findrawpath(char *path);
 extern char *platform_findrawpath (char *path);
Index: xfsprogs/VERSION
===================================================================
--- xfsprogs/VERSION.orig	2006-10-06 14:28:43.000000000 +1000
+++ xfsprogs/VERSION	2006-10-06 14:22:40.000000000 +1000
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=8
-PKG_REVISION=13
+PKG_REVISION=14
 PKG_BUILD=1
