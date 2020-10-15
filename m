Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE694C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79AB42224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgJOHWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60709 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728946AbgJOHWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:14 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 45FBC3AB14B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvi-Pz
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLy-Ht
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/27] libxfs: introduce userspace buftarg infrastructure
Date:   Thu, 15 Oct 2020 18:21:41 +1100
Message-Id: <20201015072155.1631135-14-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=w2ichieFBIccr0T-9c4A:9
        a=nVqKaCECdAw4Cc_Q:21 a=dpSYp7CSjhJ2OXP8:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This mirrors the buftarg interface provided by the kernel for
devices. While parts of the interface are the same for supporting
xfs_buf.c and the allocation/freeing of buftargs, the implementation
in userspace is substantially different and so we are starting with
a cut down copy of the kernel xfs_buftarg.h rather than sharing it
via libxfs.

The buftarg implementation in this patch will provide most
of the mangement infrastructure the kernel side provides. This
initial patch provides buftarg setup and teardown routines.

Note that mkfs abuses the mounting code to calculate the log size
before we've finished setting up the superblock. Given that mount
will now actually open and check device sizes unconditionally, the
mkfs code now needs to set up enough of the superblock and pass real
devices to the mount code for it to work correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h     |  1 +
 include/xfs_inode.h  |  1 -
 libfrog/linux.c      | 14 ++++++-
 libxfs/Makefile      |  4 +-
 libxfs/buftarg.c     | 99 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/init.c        | 38 +++++++----------
 libxfs/libxfs_io.h   | 21 ++--------
 libxfs/libxfs_priv.h |  3 ++
 libxfs/xfs_buftarg.h | 55 ++++++++++++++++++++++++
 mkfs/xfs_mkfs.c      | 23 +++++++---
 10 files changed, 209 insertions(+), 50 deletions(-)
 create mode 100644 libxfs/buftarg.c
 create mode 100644 libxfs/xfs_buftarg.h

diff --git a/include/libxfs.h b/include/libxfs.h
index 923a376bd71a..72c0b525f9db 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -50,6 +50,7 @@ struct iomap;
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
  * every files via a similar include in the kernel xfs_linux.h.
  */
+#include "xfs_buftarg.h"
 #include "libxfs_io.h"
 
 #include "xfs_bit.h"
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 29086a7d5e2e..f30ce8792fba 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -67,7 +67,6 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
diff --git a/libfrog/linux.c b/libfrog/linux.c
index a45d99ab5bbe..8287b0d90b56 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -129,7 +129,19 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
 int
 platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
 {
-	int error = 0;
+	struct stat	st;
+	int		error = 0;
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr, _("%s: "
+			"cannot stat the device file \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+
+	/* Can't set block sizes on image files. */
+	if ((st.st_mode & S_IFMT) != S_IFBLK)
+		return 0;
 
 	if (major(device) != RAMDISK_MAJOR) {
 		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
diff --git a/libxfs/Makefile b/libxfs/Makefile
index de595b7cd49f..7f2fc0f878e2 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -30,6 +30,7 @@ HFILES = \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
 	xfs_btree_staging.h \
+	xfs_buftarg.h \
 	xfs_attr_remote.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
@@ -54,7 +55,8 @@ HFILES = \
 	libxfs_priv.h \
 	xfs_dir2_priv.h
 
-CFILES = cache.c \
+CFILES = buftarg.c \
+	cache.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
new file mode 100644
index 000000000000..d4bcb2936f01
--- /dev/null
+++ b/libxfs/buftarg.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2019 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "libfrog/platform.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs_errortag.h"
+
+#include "libxfs.h"		/* for libxfs_device_to_fd */
+
+int
+xfs_buftarg_setsize(
+	struct xfs_buftarg	*btp,
+	unsigned int		sectorsize)
+{
+	long long		size;
+	int			bsize;
+
+	/* Set up metadata sector size info */
+	btp->bt_meta_sectorsize = sectorsize;
+	btp->bt_meta_sectormask = sectorsize - 1;
+
+	if (platform_set_blocksize(btp->bt_fd, NULL, btp->bt_bdev,
+					sectorsize, true)) {
+		xfs_warn(btp->bt_mount,
+			"Cannot set_blocksize to %u on device %pg",
+			sectorsize, btp->bt_bdev);
+		return -EINVAL;
+	}
+
+	/* Set up device logical sector size mask */
+	platform_findsizes(NULL, btp->bt_fd, &size, &bsize);
+	btp->bt_logical_sectorsize = bsize;
+	btp->bt_logical_sectormask = bsize - 1;
+
+	return 0;
+}
+
+/*
+ * When allocating the initial buffer target we have not yet read in the
+ * superblock, so don't know what sized sectors are being used at this early
+ * stage.  Play safe.
+ */
+STATIC int
+xfs_buftarg_setsize_early(
+	struct xfs_buftarg	*btp)
+{
+	long long		size;
+	int			bsize;
+
+	platform_findsizes(NULL, btp->bt_fd, &size, &bsize);
+	return xfs_buftarg_setsize(btp, bsize);
+}
+
+struct xfs_buftarg *
+xfs_buftarg_alloc(
+	struct xfs_mount	*mp,
+	dev_t			bdev)
+{
+	struct xfs_buftarg	*btp;
+
+	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
+
+	btp->bt_mount = mp;
+	btp->bt_fd = libxfs_device_to_fd(bdev);
+	btp->bt_bdev = bdev;
+
+	if (xfs_buftarg_setsize_early(btp))
+		goto error_free;
+
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+		goto error_free;
+
+	return btp;
+
+error_free:
+	free(btp);
+	return NULL;
+}
+
+void
+xfs_buftarg_free(
+	struct xfs_buftarg	*btp)
+{
+	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
+	percpu_counter_destroy(&btp->bt_io_count);
+	platform_flush_device(btp->bt_fd, btp->bt_bdev);
+	free(btp);
+}
diff --git a/libxfs/init.c b/libxfs/init.c
index fc30f92d6fb2..3ab622e9ee3b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -590,26 +590,6 @@ out_unwind:
 	return error;
 }
 
-static struct xfs_buftarg *
-libxfs_buftarg_alloc(
-	struct xfs_mount	*mp,
-	dev_t			dev)
-{
-	struct xfs_buftarg	*btp;
-
-	btp = malloc(sizeof(*btp));
-	if (!btp) {
-		fprintf(stderr, _("%s: buftarg init failed\n"),
-			progname);
-		exit(1);
-	}
-	btp->bt_mount = mp;
-	btp->bt_bdev = dev;
-	btp->flags = 0;
-
-	return btp;
-}
-
 void
 libxfs_buftarg_init(
 	struct xfs_mount	*mp,
@@ -650,12 +630,24 @@ libxfs_buftarg_init(
 		return;
 	}
 
-	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev);
+	mp->m_ddev_targp = xfs_buftarg_alloc(mp, dev);
+	if (!mp->m_ddev_targp)
+		goto out_fail;
 	if (!logdev || logdev == dev)
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
+		mp->m_logdev_targp = xfs_buftarg_alloc(mp, logdev);
+	if (!mp->m_logdev_targp)
+		goto out_fail;
+	if (rtdev) {
+		mp->m_rtdev_targp = xfs_buftarg_alloc(mp, rtdev);
+		if (!mp->m_rtdev_targp)
+			goto out_fail;
+	}
+	return;
+out_fail:
+	fprintf(stderr, _("%s: Failed to allocate buftarg\n"), progname);
+	exit(1);
 }
 
 /*
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3bb00af9bdba..eeca8895b1d3 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -14,25 +14,10 @@
 struct xfs_buf;
 struct xfs_mount;
 struct xfs_perag;
+struct xfs_buftarg;
 
-/*
- * IO verifier callbacks need the xfs_mount pointer, so we have to behave
- * somewhat like the kernel now for userspace IO in terms of having buftarg
- * based devices...
- */
-struct xfs_buftarg {
-	struct xfs_mount	*bt_mount;
-	dev_t			bt_bdev;
-	unsigned int		flags;
-};
-
-/* We purged a dirty buffer and lost a write. */
-#define XFS_BUFTARG_LOST_WRITE		(1 << 0)
-/* A dirty buffer failed the write verifier. */
-#define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
-
-extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
-				    dev_t logdev, dev_t rtdev);
+void libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
+			dev_t logdev, dev_t rtdev);
 int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7be3f7615fdd..72665f71098e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -85,6 +85,7 @@ struct iomap;
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
  * every files via a similar include in the kernel xfs_linux.h.
  */
+#include "xfs_buftarg.h"
 #include "libxfs_io.h"
 
 /* for all the support code that uses progname in error messages */
@@ -201,6 +202,8 @@ static inline bool WARN_ON(bool expr) {
 }
 
 #define WARN_ON_ONCE(e)			WARN_ON(e)
+#define percpu_counter_init(x,v,gfp)	(*x = v)
+#define percpu_counter_destroy(x)	((void) 0)
 #define percpu_counter_read(x)		(*x)
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum(x)		(*x)
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
new file mode 100644
index 000000000000..1bc3a4d0bc9c
--- /dev/null
+++ b/libxfs/xfs_buftarg.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2019 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_BUFTARG_H
+#define __XFS_BUFTARG_H
+
+struct xfs_mount;
+struct xfs_buf;
+struct xfs_buf_ops;
+
+/*
+ * The xfs_buftarg contains 2 notions of "sector size" -
+ *
+ * 1) The metadata sector size, which is the minimum unit and
+ *    alignment of IO which will be performed by metadata operations.
+ * 2) The device logical sector size
+ *
+ * The first is specified at mkfs time, and is stored on-disk in the
+ * superblock's sb_sectsize.
+ *
+ * The latter is derived from the underlying device, and controls direct IO
+ * alignment constraints.
+ */
+struct xfs_buftarg {
+	dev_t			bt_bdev;
+	int			bt_fd;		/* for read/write IO */
+	struct xfs_mount	*bt_mount;
+	unsigned int		bt_meta_sectorsize;
+	size_t			bt_meta_sectormask;
+	size_t			bt_logical_sectorsize;
+	size_t			bt_logical_sectormask;
+
+	uint32_t		bt_io_count;
+	unsigned int		flags;
+};
+
+/* We purged a dirty buffer and lost a write. */
+#define XFS_BUFTARG_LOST_WRITE		(1 << 0)
+/* A dirty buffer failed the write verifier. */
+#define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
+
+/*
+ *	Handling of buftargs.
+ */
+struct xfs_buftarg *xfs_buftarg_alloc(struct xfs_mount *mp, dev_t bdev);
+void xfs_buftarg_free(struct xfs_buftarg *target);
+void xfs_buftarg_wait(struct xfs_buftarg *target);
+int xfs_buftarg_setsize(struct xfs_buftarg *target, unsigned int size);
+
+#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
+
+#endif /* __XFS_BUFTARG_H */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ba21b4accc97..e094c82f86b7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2660,6 +2660,16 @@ _("size %lld of data subvolume is too small, minimum %lld blocks\n"),
 reported by the device (%u).\n"),
 			cfg->sectorsize, xi->dbsize);
 	}
+
+	if (xi->disfile &&
+	    xi->dsize * xi->dbsize < cfg->dblocks * cfg->blocksize) {
+		if (ftruncate(xi->dfd, cfg->dblocks * cfg->blocksize) < 0) {
+			fprintf(stderr,
+				_("%s: Growing the data section failed\n"),
+				progname);
+			exit(1);
+		}
+	}
 }
 
 /*
@@ -3185,6 +3195,7 @@ calculate_log_size(
 	struct cli_params	*cli,
 	struct xfs_mount	*mp)
 {
+	struct libxfs_xinit	*xi = cli->xi;
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int			min_logblocks;
 	struct xfs_mount	mount;
@@ -3192,7 +3203,7 @@ calculate_log_size(
 	/* we need a temporary mount to calculate the minimum log size. */
 	memset(&mount, 0, sizeof(mount));
 	mount.m_sb = *sbp;
-	libxfs_mount(&mount, &mp->m_sb, 0, 0, 0, 0);
+	libxfs_mount(&mount, &mp->m_sb, xi->ddev, xi->logdev, xi->rtdev, 0);
 	min_logblocks = libxfs_log_calc_minimum_size(&mount);
 	libxfs_umount(&mount);
 
@@ -3352,8 +3363,10 @@ start_superblock_setup(
 	} else
 		sbp->sb_logsunit = 0;
 
-	/* log reservation calculations depend on rt geometry */
+	/* log reservation calculations depends on geometry */
+	sbp->sb_dblocks = cfg->dblocks;
 	sbp->sb_rblocks = cfg->rtblocks;
+	sbp->sb_rextents = cfg->rtextents;
 	sbp->sb_rextsize = cfg->rtextblocks;
 }
 
@@ -3390,8 +3403,6 @@ finish_superblock_setup(
 		memcpy(sbp->sb_fname, cfg->label, label_len);
 	}
 
-	sbp->sb_dblocks = cfg->dblocks;
-	sbp->sb_rextents = cfg->rtextents;
 	platform_uuid_copy(&sbp->sb_uuid, &cfg->uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
 	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
@@ -3414,7 +3425,6 @@ finish_superblock_setup(
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
-
 }
 
 /* Prepare an uncached buffer, ready to write something out. */
@@ -3524,7 +3534,8 @@ prepare_devices(
 			 lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	/* finally, check we can write the last block in the realtime area */
-	if (mp->m_rtdev_targp->bt_bdev && cfg->rtblocks > 0) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev &&
+	    cfg->rtblocks > 0) {
 		buf = alloc_write_buf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
-- 
2.28.0

