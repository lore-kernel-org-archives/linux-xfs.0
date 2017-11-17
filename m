Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47415 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761989AbdKQVC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:02:29 -0500
Subject: [PATCH 22/27] xfs_scrub: optionally use SCSI READ VERIFY commands
 to scrub data blocks on disk
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:02:21 -0800
Message-ID: <151095254178.4825.2289633099675110355.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we sense that we're talking to a raw SCSI disk, use the SCSI READ
VERIFY command to ask the disk to verify a disk internally.  This can
sharply reduce the runtime of the data block verification phase on
devices whose internal bandwidth exceeds their link bandwidth.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    2 +
 include/builddefs.in  |    2 +
 m4/package_libcdev.m4 |   30 ++++++++++
 scrub/Makefile        |    8 +++
 scrub/disk.c          |  146 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/disk.h          |    1 
 6 files changed, 188 insertions(+), 1 deletion(-)


diff --git a/configure.ac b/configure.ac
index 2a86767..0a2e7f3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -169,6 +169,8 @@ AC_PACKAGE_WANT_UNINORM_H
 AC_HAVE_U8NORMALIZE
 AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
+AC_HAVE_SG_IO
+AC_HAVE_HDIO_GETGEO
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index a7034d8..0e358d0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -121,6 +121,8 @@ HAVE_LIBATTR = @have_libattr@
 HAVE_U8NORMALIZE = @have_u8normalize@
 HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
+HAVE_SG_IO = @have_sg_io@
+HAVE_HDIO_GETGEO = @have_hdio_getgeo@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index d111fd1..339e8a2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -360,3 +360,33 @@ AC_DEFUN([AC_HAVE_FSTATAT],
        #include <unistd.h>])
     AC_SUBST(have_fstatat)
   ])
+
+#
+# Check if we have the SG_IO ioctl
+#
+AC_DEFUN([AC_HAVE_SG_IO],
+  [ AC_MSG_CHECKING([for struct sg_io_hdr ])
+    AC_TRY_COMPILE([#include <scsi/sg.h>],
+    [
+         struct sg_io_hdr hdr;
+         ioctl(0, SG_IO, &hdr);
+    ], have_sg_io=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sg_io)
+  ])
+
+#
+# Check if we have the HDIO_GETGEO ioctl
+#
+AC_DEFUN([AC_HAVE_HDIO_GETGEO],
+  [ AC_MSG_CHECKING([for struct hd_geometry ])
+    AC_TRY_COMPILE([#include <linux/hdreg.h>],
+    [
+         struct hd_geometry hdr;
+         ioctl(0, HDIO_GETGEO, &hdr);
+    ], have_hdio_getgeo=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_hdio_getgeo)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index ce3aa9d..cb7d9c1 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -70,6 +70,14 @@ CFILES += unicrash.c
 LCFLAGS += -DHAVE_U8NORMALIZE
 endif
 
+ifeq ($(HAVE_SG_IO),yes)
+LCFLAGS += -DHAVE_SG_IO
+endif
+
+ifeq ($(HAVE_HDIO_GETGEO),yes)
+LCFLAGS += -DHAVE_HDIO_GETGEO
+endif
+
 default: depend $(LTCOMMAND)
 
 phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
diff --git a/scrub/disk.c b/scrub/disk.c
index 96eaa6a..31a99af 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -29,12 +29,19 @@
 #include <sys/statvfs.h>
 #include <sys/vfs.h>
 #include <linux/fs.h>
+#ifdef HAVE_SG_IO
+# include <scsi/sg.h>
+#endif
+#ifdef HAVE_HDIO_GETGEO
+# include <linux/hdreg.h>
+#endif
 #include "platform_defs.h"
 #include "libfrog.h"
 #include "xfs.h"
 #include "path.h"
 #include "xfs_fs.h"
 #include "xfs_scrub.h"
+#include "common.h"
 #include "disk.h"
 
 /*
@@ -90,12 +97,119 @@ disk_heads(
 	return __disk_heads(disk);
 }
 
+/*
+ * Execute a SCSI VERIFY(16) to verify disk contents.
+ * For devices that support this command, this can sharply reduce the
+ * runtime of the data block verification phase if the storage device's
+ * internal bandwidth exceeds its link bandwidth.  However, it only
+ * works if we're talking to a raw SCSI device, and only if we trust the
+ * firmware.
+ */
+#ifdef HAVE_SG_IO
+# define SENSE_BUF_LEN		64
+# define VERIFY16_CMDLEN	16
+# define VERIFY16_CMD		0x8F
+
+# ifndef SG_FLAG_Q_AT_TAIL
+#  define SG_FLAG_Q_AT_TAIL	0x10
+# endif
+static int
+disk_scsi_verify(
+	struct disk		*disk,
+	uint64_t		startblock, /* lba */
+	uint64_t		blockcount) /* lba */
+{
+	struct sg_io_hdr	iohdr;
+	unsigned char		cdb[VERIFY16_CMDLEN];
+	unsigned char		sense[SENSE_BUF_LEN];
+	uint64_t		llba;
+	uint64_t		veri_len = blockcount;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"));
+
+	llba = startblock + (disk->d_start >> BBSHIFT);
+
+	/* Borrowed from sg_verify */
+	cdb[0] = VERIFY16_CMD;
+	cdb[1] = 0; /* skip PI, DPO, and byte check. */
+	cdb[2] = (llba >> 56) & 0xff;
+	cdb[3] = (llba >> 48) & 0xff;
+	cdb[4] = (llba >> 40) & 0xff;
+	cdb[5] = (llba >> 32) & 0xff;
+	cdb[6] = (llba >> 24) & 0xff;
+	cdb[7] = (llba >> 16) & 0xff;
+	cdb[8] = (llba >> 8) & 0xff;
+	cdb[9] = llba & 0xff;
+	cdb[10] = (veri_len >> 24) & 0xff;
+	cdb[11] = (veri_len >> 16) & 0xff;
+	cdb[12] = (veri_len >> 8) & 0xff;
+	cdb[13] = veri_len & 0xff;
+	cdb[14] = 0;
+	cdb[15] = 0;
+	memset(sense, 0, SENSE_BUF_LEN);
+
+	/* v3 SG_IO */
+	memset(&iohdr, 0, sizeof(iohdr));
+	iohdr.interface_id = 'S';
+	iohdr.dxfer_direction = SG_DXFER_NONE;
+	iohdr.cmdp = cdb;
+	iohdr.cmd_len = VERIFY16_CMDLEN;
+	iohdr.sbp = sense;
+	iohdr.mx_sb_len = SENSE_BUF_LEN;
+	iohdr.flags |= SG_FLAG_Q_AT_TAIL;
+	iohdr.timeout = 30000; /* 30s */
+
+	error = ioctl(disk->d_fd, SG_IO, &iohdr);
+	if (error)
+		return error;
+
+	dbg_printf("VERIFY(16) fd %d lba %"PRIu64" len %"PRIu64" info %x "
+			"status %d masked %d msg %d host %d driver %d "
+			"duration %d resid %d\n",
+			disk->d_fd, startblock, blockcount, iohdr.info,
+			iohdr.status, iohdr.masked_status, iohdr.msg_status,
+			iohdr.host_status, iohdr.driver_status, iohdr.duration,
+			iohdr.resid);
+
+	if (iohdr.info & SG_INFO_CHECK) {
+		dbg_printf("status: msg %x host %x driver %x\n",
+				iohdr.msg_status, iohdr.host_status,
+				iohdr.driver_status);
+		errno = EIO;
+		return -1;
+	}
+
+	return error;
+}
+#else
+# define disk_scsi_verify(...)		(ENOTTY)
+#endif /* HAVE_SG_IO */
+
+/* Test the availability of the kernel scrub ioctl. */
+static bool
+disk_can_scsi_verify(
+	struct disk		*disk)
+{
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"))
+		return false;
+
+	error = disk_scsi_verify(disk, 0, 1);
+	return error == 0;
+}
+
 /* Open a disk device and discover its geometry. */
 struct disk *
 disk_open(
 	const char		*pathname)
 {
+#ifdef HAVE_HDIO_GETGEO
+	struct hd_geometry	bdgeo;
+#endif
 	struct disk		*disk;
+	bool			suspicious_disk = false;
 	int			lba_sz;
 	int			error;
 
@@ -126,13 +240,34 @@ disk_open(
 		error = ioctl(disk->d_fd, BLKBSZGET, &disk->d_blksize);
 		if (error)
 			disk->d_blksize = 0;
-		disk->d_start = 0;
+#ifdef HAVE_HDIO_GETGEO
+		error = ioctl(disk->d_fd, HDIO_GETGEO, &bdgeo);
+		if (!error) {
+			/*
+			 * dm devices will pass through ioctls, which means
+			 * we can't use SCSI VERIFY unless the start is 0.
+			 * Most dm devices don't set geometry (unlike scsi
+			 * and nvme) so use a zeroed out CHS to screen them
+			 * out.
+			 */
+			if (bdgeo.start != 0 &&
+			    (unsigned long long)bdgeo.heads * bdgeo.sectors *
+					bdgeo.sectors == 0)
+				suspicious_disk = true;
+			disk->d_start = bdgeo.start << BBSHIFT;
+		} else
+#endif
+			disk->d_start = 0;
 	} else {
 		disk->d_size = disk->d_sb.st_size;
 		disk->d_blksize = disk->d_sb.st_blksize;
 		disk->d_start = 0;
 	}
 
+	/* Can we issue SCSI VERIFY? */
+	if (!suspicious_disk && disk_can_scsi_verify(disk))
+		disk->d_flags |= DISK_FLAG_SCSI_VERIFY;
+
 	return disk;
 out_close:
 	close(disk->d_fd);
@@ -155,6 +290,10 @@ disk_close(
 	return error;
 }
 
+#define BTOLBAT(d, bytes)	((uint64_t)(bytes) >> (d)->d_lbalog)
+#define LBASIZE(d)		(1ULL << (d)->d_lbalog)
+#define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
+
 /* Read-verify an extent of a disk device. */
 ssize_t
 disk_read_verify(
@@ -163,5 +302,10 @@ disk_read_verify(
 	uint64_t		start,
 	uint64_t		length)
 {
+	/* Convert to logical block size. */
+	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
+		return disk_scsi_verify(disk, BTOLBAT(disk, start),
+				BTOLBA(disk, length));
+
 	return pread(disk->d_fd, buf, length, start);
 }
diff --git a/scrub/disk.h b/scrub/disk.h
index 4331300..b1b15c0 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -20,6 +20,7 @@
 #ifndef XFS_SCRUB_DISK_H_
 #define XFS_SCRUB_DISK_H_
 
+#define DISK_FLAG_SCSI_VERIFY	0x1
 struct disk {
 	struct stat	d_sb;
 	int		d_fd;

