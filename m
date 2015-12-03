Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73FD67F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 17:16:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5181AC005
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 15:16:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xiNfOQjGlL08IwxV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2015 15:16:48 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D662F3798C7
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 23:16:47 +0000 (UTC)
Received: from Liberator.example.com (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tB3NGkBa027885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 3 Dec 2015 18:16:47 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] mkfs: get sector size from host fs dev when mkfs'ing file
Message-ID: <5660CD5E.2040209@redhat.com>
Date: Thu, 3 Dec 2015 17:16:46 -0600
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Now that we allow logical-sector-sized DIOs even if our xfs
filesystem is set to physical-sector-sized "sectors," we can
allow the creation of filesystem images with block and sector
sizes down to the host device's logical sector size, rather
than the filesystem's sector size.

So in platform_findsizes(), change our query of the filesystem
to a query of the device, and use that for sector size in the
S_IFREG case.

This allows the creation of i.e. a 2k block sized image on
an xfs filesystem w/ 4k sector size created on a 4k/512
block device, which would otherwise fail today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This feels like about my 5th stab at this; it seems like
the correct thing to do but by now my brain is full.
Seem sane?

Still needs a run through xfstests but wanted to see if this
was obviously bonkers or not...?

(I don't know why copy/Makefile needs a $(LIBBLKID), either...)


diff --git a/libxfs/Makefile b/libxfs/Makefile
index ecf1921..87f9d93 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -100,7 +100,7 @@ LSRCFILES += gen_crc32table.c
 
 FCFLAGS = -I.
 
-LTLIBS = $(LIBPTHREAD) $(LIBRT)
+LTLIBS = $(LIBPTHREAD) $(LIBRT) $(LIBBLKID)
 
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
diff --git a/libxfs/linux.c b/libxfs/linux.c
index 885016a..3a8dc12 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -24,6 +24,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
+#include <blkid/blkid.h>
 
 #include "libxfs_priv.h"
 #include "xfs_fs.h"
@@ -142,18 +143,29 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 			progname, path, strerror(errno));
 		exit(1);
 	}
+
 	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		struct xfs_fsop_geom_v1 geom = { 0 };
+		int	fd;
+		char	*hostfs_dev_path;	/* path to host fs device */
 
 		*sz = (long long)(st.st_size >> 9);
-		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
-			/*
-			 * fall back to BBSIZE; mkfs might fail if there's a
-			 * size mismatch between the image & the host fs...
-			 */
-			*bsz = BBSIZE;
-		} else
-			*bsz = geom.sectsize;
+
+		/*
+		 * Default to BBSIZE; mkfs might fail if there's a
+		 * size mismatch between the image & the host fs...
+		 */
+		*bsz = BBSIZE;
+
+		/* Get logical sector size of host device */
+		hostfs_dev_path = blkid_devno_to_devname(st.st_dev);
+		if (hostfs_dev_path) {
+			fd = open(hostfs_dev_path, O_RDONLY);
+			if (fd >= 0)
+				if (ioctl(fd, BLKSSZGET, bsz) < 0)
+					*bsz = BBSIZE;
+			close(fd);
+			free(hostfs_dev_path);
+		}
 
 		if (*bsz > max_block_alignment)
 			max_block_alignment = *bsz;

diff --git a/copy/Makefile b/copy/Makefile
index e630b17..4b45a66 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_copy
CFILES = xfs_copy.c
HFILES = xfs_copy.h

-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) $(LIBBLKID)
LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
LLDFLAGS = -static-libtool-libs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
