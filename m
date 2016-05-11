Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3DE07CB0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:45:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C74CD304043
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nmxxEDEenyotfiDQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:31 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BB7ED821C3
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 22:45:30 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.52.194] (may be
	forged))
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4BMjTWI031072
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:45:30 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v5 1/2] libxcmd: generalize topology functions
Date: Wed, 11 May 2016 17:45:16 -0500
Message-Id: <1463006717-6104-2-git-send-email-billodo@redhat.com>
In-Reply-To: <1463006717-6104-1-git-send-email-billodo@redhat.com>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
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

Move general topology functions from xfs_mkfs to new topology
collection in libxcmd.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 include/Makefile   |   1 +
 include/libxcmd.h  |  56 +++++++++
 libxcmd/Makefile   |   2 +-
 libxcmd/topology.c | 342 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/Makefile      |   2 +-
 mkfs/xfs_mkfs.c    | 327 +-------------------------------------------------
 6 files changed, 402 insertions(+), 328 deletions(-)
 create mode 100644 include/libxcmd.h
 create mode 100644 libxcmd/topology.c

diff --git a/include/Makefile b/include/Makefile
index 5fb443a..36a9741 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -20,6 +20,7 @@ include $(TOPDIR)/include/builddefs
 
 LIBHFILES = libxfs.h \
 	libxlog.h \
+	libxcmd.h \
 	atomic.h \
 	bitops.h \
 	cache.h \
diff --git a/include/libxcmd.h b/include/libxcmd.h
new file mode 100644
index 0000000..e8d2ffc
--- /dev/null
+++ b/include/libxcmd.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __LIBXCMD_H__
+#define __LIBXCMD_H__
+
+#include "libxfs.h"
+#include <sys/time.h>
+
+/*
+ * Device topology information.
+ */
+typedef struct fs_topology {
+	int	dsunit;		/* stripe unit - data subvolume */
+	int	dswidth;	/* stripe width - data subvolume */
+	int	rtswidth;	/* stripe width - rt subvolume */
+	int	lsectorsize;	/* logical sector size &*/
+	int	psectorsize;	/* physical sector size */
+} fs_topology_t;
+
+extern void
+get_topology(
+	libxfs_init_t		*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite);
+
+extern void
+calc_default_ag_geometry(
+	int		blocklog,
+	__uint64_t	dblocks,
+	int		multidisk,
+	__uint64_t	*agsize,
+	__uint64_t	*agcount);
+
+extern int
+check_overwrite(
+	const char	*device);
+
+
+
+#endif	/* __LIBXCMD_H__ */
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index 7701ed9..aab8d6d 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -10,7 +10,7 @@ LT_CURRENT = 0
 LT_REVISION = 0
 LT_AGE = 0
 
-CFILES = command.c input.c paths.c projects.c help.c quit.c
+CFILES = command.c input.c paths.c projects.c help.c quit.c topology.c
 
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
diff --git a/libxcmd/topology.c b/libxcmd/topology.c
new file mode 100644
index 0000000..8b0276a
--- /dev/null
+++ b/libxcmd/topology.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "libxfs.h"
+#include "libxcmd.h"
+#ifdef ENABLE_BLKID
+#  include <blkid/blkid.h>
+#endif /* ENABLE_BLKID */
+#include "xfs_multidisk.h"
+
+#define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
+#define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
+#define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
+
+void
+calc_default_ag_geometry(
+	int		blocklog,
+	__uint64_t	dblocks,
+	int		multidisk,
+	__uint64_t	*agsize,
+	__uint64_t	*agcount)
+{
+	__uint64_t	blocks = 0;
+	int		shift = 0;
+
+	/*
+	 * First handle the high extreme - the point at which we will
+	 * always use the maximum AG size.
+	 *
+	 * This applies regardless of storage configuration.
+	 */
+	if (dblocks >= TERABYTES(32, blocklog)) {
+		blocks = XFS_AG_MAX_BLOCKS(blocklog);
+		goto done;
+	}
+
+	/*
+	 * For a single underlying storage device over 4TB in size
+	 * use the maximum AG size.  Between 128MB and 4TB, just use
+	 * 4 AGs and scale up smoothly between min/max AG sizes.
+	 */
+	if (!multidisk) {
+		if (dblocks >= TERABYTES(4, blocklog)) {
+			blocks = XFS_AG_MAX_BLOCKS(blocklog);
+			goto done;
+		} else if (dblocks >= MEGABYTES(128, blocklog)) {
+			shift = XFS_NOMULTIDISK_AGLOG;
+			goto calc_blocks;
+		}
+	}
+
+	/*
+	 * For the multidisk configs we choose an AG count based on the number
+	 * of data blocks available, trying to keep the number of AGs higher
+	 * than the single disk configurations. This makes the assumption that
+	 * larger filesystems have more parallelism available to them.
+	 */
+	shift = XFS_MULTIDISK_AGLOG;
+	if (dblocks <= GIGABYTES(512, blocklog))
+		shift--;
+	if (dblocks <= GIGABYTES(8, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(128, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(64, blocklog))
+		shift--;
+	if (dblocks < MEGABYTES(32, blocklog))
+		shift--;
+
+	/*
+	 * If dblocks is not evenly divisible by the number of
+	 * desired AGs, round "blocks" up so we don't lose the
+	 * last bit of the filesystem. The same principle applies
+	 * to the AG count, so we don't lose the last AG!
+	 */
+calc_blocks:
+	ASSERT(shift >= 0 && shift <= XFS_MULTIDISK_AGLOG);
+	blocks = dblocks >> shift;
+	if (dblocks & xfs_mask32lo(shift)) {
+		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
+		    blocks++;
+	}
+done:
+	*agsize = blocks;
+	*agcount = dblocks / blocks + (dblocks % blocks != 0);
+}
+
+/*
+ * Check for existing filesystem or partition table on device.
+ * Returns:
+ *	 1 for existing fs or partition
+ *	 0 for nothing found
+ *	-1 for internal error
+ */
+#ifdef ENABLE_BLKID
+int
+check_overwrite(
+	const char	*device)
+{
+	const char	*type;
+	blkid_probe	pr = NULL;
+	int		ret;
+	int		fd;
+	long long	size;
+	int		bsz;
+
+	if (!device || !*device)
+		return 0;
+
+	ret = -1; /* will reset on success of all setup calls */
+
+	fd = open(device, O_RDONLY);
+	if (fd < 0)
+		goto out;
+	platform_findsizes((char *)device, fd, &size, &bsz);
+	close(fd);
+
+	/* nothing to overwrite on a 0-length device */
+	if (size == 0) {
+		ret = 0;
+		goto out;
+	}
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		goto out;
+
+	ret = blkid_probe_enable_partitions(pr, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = blkid_do_fullprobe(pr);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
+	 * but we want the exact opposite, so reverse the return value here.
+	 *
+	 * In addition print some useful diagnostics about what actually is
+	 * on the device.
+	 */
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
+		fprintf(stderr,
+			_("%s: %s appears to contain an existing "
+			"filesystem (%s).\n"), progname, device, type);
+	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
+		fprintf(stderr,
+			_("%s: %s appears to contain a partition "
+			"table (%s).\n"), progname, device, type);
+	} else {
+		fprintf(stderr,
+			_("%s: %s appears to contain something weird "
+			"according to blkid\n"), progname, device);
+	}
+	ret = 1;
+out:
+	if (pr)
+		blkid_free_probe(pr);
+	if (ret == -1)
+		fprintf(stderr,
+			_("%s: probe of %s failed, cannot detect "
+			  "existing filesystem.\n"), progname, device);
+	return ret;
+}
+
+static void blkid_get_topology(
+	const char	*device,
+	int		*sunit,
+	int		*swidth,
+	int		*lsectorsize,
+	int		*psectorsize,
+	int		force_overwrite)
+{
+
+	blkid_topology tp;
+	blkid_probe pr;
+	unsigned long val;
+	struct stat statbuf;
+
+	/* can't get topology info from a file */
+	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
+		fprintf(stderr,
+	_("%s: Warning: trying to probe topology of a file %s!\n"),
+			progname, device);
+		return;
+	}
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		return;
+
+	tp = blkid_probe_get_topology(pr);
+	if (!tp)
+		goto out_free_probe;
+
+	val = blkid_topology_get_logical_sector_size(tp);
+	*lsectorsize = val;
+	val = blkid_topology_get_physical_sector_size(tp);
+	*psectorsize = val;
+	val = blkid_topology_get_minimum_io_size(tp);
+	*sunit = val;
+	val = blkid_topology_get_optimal_io_size(tp);
+	*swidth = val;
+
+	/*
+	 * If the reported values are the same as the physical sector size
+	 * do not bother to report anything.  It will only cause warnings
+	 * if people specify larger stripe units or widths manually.
+	 */
+	if (*sunit == *psectorsize || *swidth == *psectorsize) {
+		*sunit = 0;
+		*swidth = 0;
+	}
+
+	/*
+	 * Blkid reports the information in terms of bytes, but we want it in
+	 * terms of 512 bytes blocks (only to convert it to bytes later..)
+	 */
+	*sunit = *sunit >> 9;
+	*swidth = *swidth >> 9;
+
+	if (blkid_topology_get_alignment_offset(tp) != 0) {
+		fprintf(stderr,
+			_("warning: device is not properly aligned %s\n"),
+			device);
+
+		if (!force_overwrite) {
+			fprintf(stderr,
+				_("Use -f to force usage of a misaligned device\n"));
+
+			exit(EXIT_FAILURE);
+		}
+		/* Do not use physical sector size if the device is misaligned */
+		*psectorsize = *lsectorsize;
+	}
+
+	blkid_free_probe(pr);
+	return;
+
+out_free_probe:
+	blkid_free_probe(pr);
+	fprintf(stderr,
+		_("warning: unable to probe device topology for device %s\n"),
+		device);
+}
+#else /* ifdef ENABLE_BLKID */
+/*
+ * Without blkid, we can't do a good check for signatures.
+ * So instead of some messy attempts, just disable any checks
+ * and always return 'nothing found'.
+ */
+#  warning BLKID is disabled, so signature detection and block device\
+ access are not working!
+int
+check_overwrite(
+	const char	*device)
+{
+	return 1;
+}
+
+static void blkid_get_topology(
+	const char	*device,
+	int		*sunit,
+	int		*swidth,
+	int		*lsectorsize,
+	int		*psectorsize,
+	int		force_overwrite)
+{
+	/*
+	 * Shouldn't make any difference (no blkid = no block device access),
+	 * but make sure this dummy replacement returns with at least some
+	 * sanity.
+	 */
+	*lsectorsize = *psectorsize = 512;
+}
+
+#endif /* ENABLE_BLKID */
+
+void get_topology(
+	libxfs_init_t		*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite)
+{
+	struct stat statbuf;
+	char *dfile = xi->volname ? xi->volname : xi->dname;
+
+	/*
+	 * If our target is a regular file, use platform_findsizes
+	 * to try to obtain the underlying filesystem's requirements
+	 * for direct IO; we'll set our sector size to that if possible.
+	 */
+	if (xi->disfile ||
+	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
+		int fd;
+		int flags = O_RDONLY;
+		long long dummy;
+
+		/* with xi->disfile we may not have the file yet! */
+		if (xi->disfile)
+			flags |= O_CREAT;
+
+		fd = open(dfile, flags, 0666);
+		if (fd >= 0) {
+			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			close(fd);
+			ft->psectorsize = ft->lsectorsize;
+		} else
+			ft->psectorsize = ft->lsectorsize = BBSIZE;
+	} else {
+		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
+				   &ft->lsectorsize, &ft->psectorsize,
+				   force_overwrite);
+	}
+
+	if (xi->rtname && !xi->risfile) {
+		int sunit, lsectorsize, psectorsize;
+
+		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
+				   &lsectorsize, &psectorsize, force_overwrite);
+	}
+}
diff --git a/mkfs/Makefile b/mkfs/Makefile
index 63ba4ec..f0e4ce1 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,7 +10,7 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
 LTDEPENDENCIES += $(LIBXFS)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..ad3fd77 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -22,17 +22,7 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
-
-/*
- * Device topology information.
- */
-struct fs_topology {
-	int	dsunit;		/* stripe unit - data subvolume */
-	int	dswidth;	/* stripe width - data subvolume */
-	int	rtswidth;	/* stripe width - rt subvolume */
-	int	lsectorsize;	/* logical sector size &*/
-	int	psectorsize;	/* physical sector size */
-};
+#include "libxcmd.h"
 
 /*
  * Prototypes for internal functions.
@@ -777,247 +767,6 @@ calc_stripe_factors(
 		*lsunit = (int)BTOBBT(lsu);
 }
 
-/*
- * Check for existing filesystem or partition table on device.
- * Returns:
- *	 1 for existing fs or partition
- *	 0 for nothing found
- *	-1 for internal error
- */
-#ifdef ENABLE_BLKID
-static int
-check_overwrite(
-	const char	*device)
-{
-	const char	*type;
-	blkid_probe	pr = NULL;
-	int		ret;
-	int		fd;
-	long long	size;
-	int		bsz;
-
-	if (!device || !*device)
-		return 0;
-
-	ret = -1; /* will reset on success of all setup calls */
-
-	fd = open(device, O_RDONLY);
-	if (fd < 0)
-		goto out;
-	platform_findsizes((char *)device, fd, &size, &bsz);
-	close(fd);
-
-	/* nothing to overwrite on a 0-length device */
-	if (size == 0) {
-		ret = 0;
-		goto out;
-	}
-
-	pr = blkid_new_probe_from_filename(device);
-	if (!pr)
-		goto out;
-
-	ret = blkid_probe_enable_partitions(pr, 1);
-	if (ret < 0)
-		goto out;
-
-	ret = blkid_do_fullprobe(pr);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
-	 * but we want the exact opposite, so reverse the return value here.
-	 *
-	 * In addition print some useful diagnostics about what actually is
-	 * on the device.
-	 */
-	if (ret) {
-		ret = 0;
-		goto out;
-	}
-
-	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
-		fprintf(stderr,
-			_("%s: %s appears to contain an existing "
-			"filesystem (%s).\n"), progname, device, type);
-	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
-		fprintf(stderr,
-			_("%s: %s appears to contain a partition "
-			"table (%s).\n"), progname, device, type);
-	} else {
-		fprintf(stderr,
-			_("%s: %s appears to contain something weird "
-			"according to blkid\n"), progname, device);
-	}
-	ret = 1;
-out:
-	if (pr)
-		blkid_free_probe(pr);
-	if (ret == -1)
-		fprintf(stderr,
-			_("%s: probe of %s failed, cannot detect "
-			  "existing filesystem.\n"), progname, device);
-	return ret;
-}
-
-static void blkid_get_topology(
-	const char	*device,
-	int		*sunit,
-	int		*swidth,
-	int		*lsectorsize,
-	int		*psectorsize,
-	int		force_overwrite)
-{
-
-	blkid_topology tp;
-	blkid_probe pr;
-	unsigned long val;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
-
-	pr = blkid_new_probe_from_filename(device);
-	if (!pr)
-		return;
-
-	tp = blkid_probe_get_topology(pr);
-	if (!tp)
-		goto out_free_probe;
-
-	val = blkid_topology_get_logical_sector_size(tp);
-	*lsectorsize = val;
-	val = blkid_topology_get_physical_sector_size(tp);
-	*psectorsize = val;
-	val = blkid_topology_get_minimum_io_size(tp);
-	*sunit = val;
-	val = blkid_topology_get_optimal_io_size(tp);
-	*swidth = val;
-
-	/*
-	 * If the reported values are the same as the physical sector size
-	 * do not bother to report anything.  It will only cause warnings
-	 * if people specify larger stripe units or widths manually.
-	 */
-	if (*sunit == *psectorsize || *swidth == *psectorsize) {
-		*sunit = 0;
-		*swidth = 0;
-	}
-
-	/*
-	 * Blkid reports the information in terms of bytes, but we want it in
-	 * terms of 512 bytes blocks (only to convert it to bytes later..)
-	 */
-	*sunit = *sunit >> 9;
-	*swidth = *swidth >> 9;
-
-	if (blkid_topology_get_alignment_offset(tp) != 0) {
-		fprintf(stderr,
-			_("warning: device is not properly aligned %s\n"),
-			device);
-
-		if (!force_overwrite) {
-			fprintf(stderr,
-				_("Use -f to force usage of a misaligned device\n"));
-
-			exit(EXIT_FAILURE);
-		}
-		/* Do not use physical sector size if the device is misaligned */
-		*psectorsize = *lsectorsize;
-	}
-
-	blkid_free_probe(pr);
-	return;
-
-out_free_probe:
-	blkid_free_probe(pr);
-	fprintf(stderr,
-		_("warning: unable to probe device topology for device %s\n"),
-		device);
-}
-#else /* ifdef ENABLE_BLKID */
-/*
- * Without blkid, we can't do a good check for signatures.
- * So instead of some messy attempts, just disable any checks
- * and always return 'nothing found'.
- */
-#  warning BLKID is disabled, so signature detection and block device\
- access are not working!
-static int
-check_overwrite(
-	const char	*device)
-{
-	return 1;
-}
-
-static void blkid_get_topology(
-	const char	*device,
-	int		*sunit,
-	int		*swidth,
-	int		*lsectorsize,
-	int		*psectorsize,
-	int		force_overwrite)
-{
-	/*
-	 * Shouldn't make any difference (no blkid = no block device access),
-	 * but make sure this dummy replacement returns with at least some
-	 * sanity.
-	 */
-	*lsectorsize = *psectorsize = 512;
-}
-
-#endif /* ENABLE_BLKID */
-
-static void get_topology(
-	libxfs_init_t		*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite)
-{
-	struct stat statbuf;
-	char *dfile = xi->volname ? xi->volname : xi->dname;
-
-	/*
-	 * If our target is a regular file, use platform_findsizes
-	 * to try to obtain the underlying filesystem's requirements
-	 * for direct IO; we'll set our sector size to that if possible.
-	 */
-	if (xi->disfile ||
-	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
-		int fd;
-		int flags = O_RDONLY;
-		long long dummy;
-
-		/* with xi->disfile we may not have the file yet! */
-		if (xi->disfile)
-			flags |= O_CREAT;
-
-		fd = open(dfile, flags, 0666);
-		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
-			close(fd);
-			ft->psectorsize = ft->lsectorsize;
-		} else
-			ft->psectorsize = ft->lsectorsize = BBSIZE;
-	} else {
-		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
-				   &ft->lsectorsize, &ft->psectorsize,
-				   force_overwrite);
-	}
-
-	if (xi->rtname && !xi->risfile) {
-		int sunit, lsectorsize, psectorsize;
-
-		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
-				   &lsectorsize, &psectorsize, force_overwrite);
-	}
-}
-
 static void
 check_device_type(
 	const char	*name,
@@ -1199,80 +948,6 @@ calc_default_imaxpct(
 	return 1;
 }
 
-
-void
-calc_default_ag_geometry(
-	int		blocklog,
-	__uint64_t	dblocks,
-	int		multidisk,
-	__uint64_t	*agsize,
-	__uint64_t	*agcount)
-{
-	__uint64_t	blocks = 0;
-	int		shift = 0;
-
-	/*
-	 * First handle the high extreme - the point at which we will
-	 * always use the maximum AG size.
-	 *
-	 * This applies regardless of storage configuration.
-	 */
-	if (dblocks >= TERABYTES(32, blocklog)) {
-		blocks = XFS_AG_MAX_BLOCKS(blocklog);
-		goto done;
-	}
-
-	/*
-	 * For a single underlying storage device over 4TB in size
-	 * use the maximum AG size.  Between 128MB and 4TB, just use
-	 * 4 AGs and scale up smoothly between min/max AG sizes.
-	 */
-	if (!multidisk) {
-		if (dblocks >= TERABYTES(4, blocklog)) {
-			blocks = XFS_AG_MAX_BLOCKS(blocklog);
-			goto done;
-		} else if (dblocks >= MEGABYTES(128, blocklog)) {
-			shift = XFS_NOMULTIDISK_AGLOG;
-			goto calc_blocks;
-		}
-	}
-
-	/*
-	 * For the multidisk configs we choose an AG count based on the number
-	 * of data blocks available, trying to keep the number of AGs higher
-	 * than the single disk configurations. This makes the assumption that
-	 * larger filesystems have more parallelism available to them.
-	 */
-	shift = XFS_MULTIDISK_AGLOG;
-	if (dblocks <= GIGABYTES(512, blocklog))
-		shift--;
-	if (dblocks <= GIGABYTES(8, blocklog))
-		shift--;
-	if (dblocks < MEGABYTES(128, blocklog))
-		shift--;
-	if (dblocks < MEGABYTES(64, blocklog))
-		shift--;
-	if (dblocks < MEGABYTES(32, blocklog))
-		shift--;
-
-	/*
-	 * If dblocks is not evenly divisible by the number of
-	 * desired AGs, round "blocks" up so we don't lose the
-	 * last bit of the filesystem. The same principle applies
-	 * to the AG count, so we don't lose the last AG!
-	 */
-calc_blocks:
-	ASSERT(shift >= 0 && shift <= XFS_MULTIDISK_AGLOG);
-	blocks = dblocks >> shift;
-	if (dblocks & xfs_mask32lo(shift)) {
-		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))
-		    blocks++;
-	}
-done:
-	*agsize = blocks;
-	*agcount = dblocks / blocks + (dblocks % blocks != 0);
-}
-
 static void
 validate_ag_geometry(
 	int		blocklog,
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
