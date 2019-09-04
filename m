Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14791C3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC433206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ULzfOz3B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfIDHjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 03:39:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIDHjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 03:39:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x847Y1rC192662;
        Wed, 4 Sep 2019 07:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OeZt2yrP19q6TLPPhxnae4MwunZxr2+CTXKzOdVDerA=;
 b=ULzfOz3BOxieO0N/1v0stGCt0odelsov5s2RBUUUIneYMThLNucjKs+qAGbPxKrF2KwU
 keHq5Dq5P2c72jRuLKDNpC+tJA2+0eyBHvehZf8EnqaMA+tb+PeAO1y3zeeq8itUM2vZ
 RQWWmPFYU03cN9zLBKOdJQYMpE1fYgTIhK6AbKlb3KrMEuKtb6BN0Fb79HvF7Z/Rig06
 BFPYub1Qcj010v/71CWBFvaLGEcIK1UMbt80Zk0Mze7znRSQiQBhFIOiGAkRm7sN8c/o
 vNya7gD66It+If9UcoDoBKYklvzhRGAb6i8JRMrXCmrY8whneS2632OYeSTpZaBpkb7q Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ut8v8r3en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 07:39:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XkCO163044;
        Wed, 4 Sep 2019 04:36:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2usu52bgtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844aGhD030488;
        Wed, 4 Sep 2019 04:36:16 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:16 -0700
Subject: [PATCH 05/12] libfrog: move fsgeom.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:15 -0700
Message-ID: <156757177526.1838135.183624284465092358.stgit@magnolia>
In-Reply-To: <156757174409.1838135.8885359673458816401.stgit@magnolia>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040079
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/info.c           |    2 +
 fsr/xfs_fsr.c       |    2 +
 growfs/xfs_growfs.c |    2 +
 include/fsgeom.h    |  102 ---------------------------------------------------
 io/bmap.c           |    2 +
 io/fsmap.c          |    2 +
 io/imap.c           |    2 +
 io/open.c           |    2 +
 io/stat.c           |    2 +
 io/swapext.c        |    2 +
 libfrog/Makefile    |    1 +
 libfrog/fsgeom.h    |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c     |    2 +
 quota/free.c        |    2 +
 quota/quot.c        |    2 +
 repair/xfs_repair.c |    2 +
 rtcp/xfs_rtcp.c     |    2 +
 scrub/inodes.c      |    2 +
 scrub/phase1.c      |    2 +
 scrub/xfs_scrub.h   |    2 +
 spaceman/file.c     |    2 +
 spaceman/info.c     |    2 +
 22 files changed, 122 insertions(+), 121 deletions(-)
 delete mode 100644 include/fsgeom.h
 create mode 100644 libfrog/fsgeom.h


diff --git a/db/info.c b/db/info.c
index 7dae6e25..e5f1c2dd 100644
--- a/db/info.c
+++ b/db/info.c
@@ -7,7 +7,7 @@
 #include "command.h"
 #include "init.h"
 #include "output.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static void
 info_help(void)
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 64892dd5..1fd89eb8 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -11,7 +11,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
 #include "path.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 #include <fcntl.h>
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 4d48617a..a3fe74ae 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -6,7 +6,7 @@
 
 #include "libxfs.h"
 #include "path.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static void
 usage(void)
diff --git a/include/fsgeom.h b/include/fsgeom.h
deleted file mode 100644
index 1c397cb6..00000000
--- a/include/fsgeom.h
+++ /dev/null
@@ -1,102 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
- */
-#ifndef _LIBFROG_FSGEOM_H_
-#define _LIBFROG_FSGEOM_H_
-
-void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
-		const char *logname, const char *rtname);
-int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
-
-/*
- * Structure for recording whatever observations we want about the level of
- * xfs runtime support for this fd.  Right now we only store the fd and fs
- * geometry.
- */
-struct xfs_fd {
-	/* ioctl file descriptor */
-	int			fd;
-
-	/* filesystem geometry */
-	struct xfs_fsop_geom	fsgeom;
-
-	/* log2 of sb_agblocks (rounded up) */
-	unsigned int		agblklog;
-
-	/* log2 of sb_blocksize */
-	unsigned int		blocklog;
-
-	/* log2 of sb_inodesize */
-	unsigned int		inodelog;
-
-	/* log2 of sb_inopblock */
-	unsigned int		inopblog;
-
-	/* bits for agino in inum */
-	unsigned int		aginolog;
-};
-
-/* Static initializers */
-#define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
-#define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
-
-int xfd_prepare_geometry(struct xfs_fd *xfd);
-int xfd_open(struct xfs_fd *xfd, const char *pathname, int flags);
-int xfd_close(struct xfs_fd *xfd);
-
-/* Convert AG number and AG inode number into fs inode number. */
-static inline uint64_t
-cvt_agino_to_ino(
-	const struct xfs_fd	*xfd,
-	uint32_t		agno,
-	uint32_t		agino)
-{
-	return ((uint64_t)agno << xfd->aginolog) + agino;
-}
-
-/* Convert fs inode number into AG number. */
-static inline uint32_t
-cvt_ino_to_agno(
-	const struct xfs_fd	*xfd,
-	uint64_t		ino)
-{
-	return ino >> xfd->aginolog;
-}
-
-/* Convert fs inode number into AG inode number. */
-static inline uint32_t
-cvt_ino_to_agino(
-	const struct xfs_fd	*xfd,
-	uint64_t		ino)
-{
-	return ino & ((1ULL << xfd->aginolog) - 1);
-}
-
-/*
- * Convert a linear fs block offset number into bytes.  This is the runtime
- * equivalent of XFS_FSB_TO_B, which means that it is /not/ for segmented fsbno
- * format (= agno | agbno) that we use internally for the data device.
- */
-static inline uint64_t
-cvt_off_fsb_to_b(
-	const struct xfs_fd	*xfd,
-	uint64_t		fsb)
-{
-	return fsb << xfd->blocklog;
-}
-
-/*
- * Convert bytes into a (rounded down) linear fs block offset number.  This is
- * the runtime equivalent of XFS_B_TO_FSBT.  It does not produce segmented
- * fsbno numbers (= agno | agbno).
- */
-static inline uint64_t
-cvt_b_to_off_fsbt(
-	const struct xfs_fd	*xfd,
-	uint64_t		bytes)
-{
-	return bytes >> xfd->blocklog;
-}
-
-#endif /* _LIBFROG_FSGEOM_H_ */
diff --git a/io/bmap.c b/io/bmap.c
index d4262cf2..cf4ea12b 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -9,7 +9,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static cmdinfo_t bmap_cmd;
 
diff --git a/io/fsmap.c b/io/fsmap.c
index 67baa817..e91ffc36 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -9,7 +9,7 @@
 #include "path.h"
 #include "io.h"
 #include "input.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
diff --git a/io/imap.c b/io/imap.c
index 86d8bda3..472c1fda 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -8,7 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 static cmdinfo_t imap_cmd;
diff --git a/io/open.c b/io/open.c
index 169f375c..99ca0dd3 100644
--- a/io/open.c
+++ b/io/open.c
@@ -9,7 +9,7 @@
 #include "init.h"
 #include "io.h"
 #include "libxfs.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 #ifndef __O_TMPFILE
diff --git a/io/stat.c b/io/stat.c
index 4c1cc83d..6c666146 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -12,7 +12,7 @@
 #include "io.h"
 #include "statx.h"
 #include "libxfs.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 #include <fcntl.h>
 
diff --git a/io/swapext.c b/io/swapext.c
index d805ffbb..2b4918f8 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -8,7 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 static cmdinfo_t swapext_cmd;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 5ba32a22..98f2feb5 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -34,6 +34,7 @@ bitmap.h \
 convert.h \
 crc32defs.h \
 crc32table.h \
+fsgeom.h \
 topology.h
 
 LSRCFILES += gen_crc32table.c
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
new file mode 100644
index 00000000..6993dafb
--- /dev/null
+++ b/libfrog/fsgeom.h
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+#ifndef __LIBFROG_FSGEOM_H__
+#define __LIBFROG_FSGEOM_H__
+
+void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
+		const char *logname, const char *rtname);
+int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
+
+/*
+ * Structure for recording whatever observations we want about the level of
+ * xfs runtime support for this fd.  Right now we only store the fd and fs
+ * geometry.
+ */
+struct xfs_fd {
+	/* ioctl file descriptor */
+	int			fd;
+
+	/* filesystem geometry */
+	struct xfs_fsop_geom	fsgeom;
+
+	/* log2 of sb_agblocks (rounded up) */
+	unsigned int		agblklog;
+
+	/* log2 of sb_blocksize */
+	unsigned int		blocklog;
+
+	/* log2 of sb_inodesize */
+	unsigned int		inodelog;
+
+	/* log2 of sb_inopblock */
+	unsigned int		inopblog;
+
+	/* bits for agino in inum */
+	unsigned int		aginolog;
+};
+
+/* Static initializers */
+#define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
+#define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
+
+int xfd_prepare_geometry(struct xfs_fd *xfd);
+int xfd_open(struct xfs_fd *xfd, const char *pathname, int flags);
+int xfd_close(struct xfs_fd *xfd);
+
+/* Convert AG number and AG inode number into fs inode number. */
+static inline uint64_t
+cvt_agino_to_ino(
+	const struct xfs_fd	*xfd,
+	uint32_t		agno,
+	uint32_t		agino)
+{
+	return ((uint64_t)agno << xfd->aginolog) + agino;
+}
+
+/* Convert fs inode number into AG number. */
+static inline uint32_t
+cvt_ino_to_agno(
+	const struct xfs_fd	*xfd,
+	uint64_t		ino)
+{
+	return ino >> xfd->aginolog;
+}
+
+/* Convert fs inode number into AG inode number. */
+static inline uint32_t
+cvt_ino_to_agino(
+	const struct xfs_fd	*xfd,
+	uint64_t		ino)
+{
+	return ino & ((1ULL << xfd->aginolog) - 1);
+}
+
+/*
+ * Convert a linear fs block offset number into bytes.  This is the runtime
+ * equivalent of XFS_FSB_TO_B, which means that it is /not/ for segmented fsbno
+ * format (= agno | agbno) that we use internally for the data device.
+ */
+static inline uint64_t
+cvt_off_fsb_to_b(
+	const struct xfs_fd	*xfd,
+	uint64_t		fsb)
+{
+	return fsb << xfd->blocklog;
+}
+
+/*
+ * Convert bytes into a (rounded down) linear fs block offset number.  This is
+ * the runtime equivalent of XFS_B_TO_FSBT.  It does not produce segmented
+ * fsbno numbers (= agno | agbno).
+ */
+static inline uint64_t
+cvt_b_to_off_fsbt(
+	const struct xfs_fd	*xfd,
+	uint64_t		bytes)
+{
+	return bytes >> xfd->blocklog;
+}
+
+#endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fd6823c5..50913866 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -8,7 +8,7 @@
 #include <ctype.h>
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
diff --git a/quota/free.c b/quota/free.c
index a8b6bd1f..73aeb459 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -8,7 +8,7 @@
 #include "command.h"
 #include "init.h"
 #include "quota.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static cmdinfo_t free_cmd;
 
diff --git a/quota/quot.c b/quota/quot.c
index b718b09d..686b2726 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -11,7 +11,7 @@
 #include <grp.h>
 #include "init.h"
 #include "quota.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 typedef struct du {
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d7e70dd0..b11b7448 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -22,7 +22,7 @@
 #include "dinode.h"
 #include "slab.h"
 #include "rmap.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 /*
  * option tables for getsubopt calls
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f6ef0e6c..a5737699 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -5,7 +5,7 @@
  */
 
 #include "libxfs.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 int rtcp(char *, char *, int);
 int xfsrtextsize(char *path);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index bf98f6ee..faffef54 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -17,7 +17,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
 /*
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6d1cbe25..23df9a15 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -26,7 +26,7 @@
 #include "disk.h"
 #include "scrub.h"
 #include "repair.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 6178f324..f9a72052 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -6,7 +6,7 @@
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
 
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 extern char *progname;
 
diff --git a/spaceman/file.c b/spaceman/file.c
index 72ef27f3..34e5f005 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -12,7 +12,7 @@
 #include "init.h"
 #include "path.h"
 #include "space.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static cmdinfo_t print_cmd;
 
diff --git a/spaceman/info.c b/spaceman/info.c
index 151594a8..80442e9a 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -8,7 +8,7 @@
 #include "init.h"
 #include "path.h"
 #include "space.h"
-#include "fsgeom.h"
+#include "libfrog/fsgeom.h"
 
 static void
 info_help(void)

