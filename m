Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8796C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3EF22339E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KHQi8BHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfIDGiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:38:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDGiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:38:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x846cgg8140741;
        Wed, 4 Sep 2019 06:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JIYVcd1HdJl32RePw/Uwj0dMW1OprQsUVe5jLemHDpg=;
 b=KHQi8BHaehpyo07cCJRBvdO8RRTe6g46OyFztNw1i5gy1SsupxcW6pGidUnJb0MB3t7L
 hJP+D8MHW9ZEz28NEBFdZCgEtlsqTEmAbg7MdRd6Vi/4HuZ/PuUGJ8M5WJLEeoBRRSZr
 l0Os2Fk77qNIoYs2/w+iVKf6oiRPeavcwsqc3uCbeYYukgD5xa9QiM66+KrEM1D+INAy
 e/5LvKyXh8bdWX8O8WCQ/UrtvwJeeez13f8M4R4cgTXuJ7aZNYfKABcDg+kV9YMbtAQ4
 DfT/WvkeBYAeNQtydSkzkc42sVBrQjdqNTkfFOM2kKs5q+b1ldXFOK6f9H1j+QBNB54C 0Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ut84k00kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 06:38:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844Xk66163053;
        Wed, 4 Sep 2019 04:36:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2usu52bhh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:49 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844am5o023818;
        Wed, 4 Sep 2019 04:36:48 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:48 -0700
Subject: [PATCH 10/12] libfrog: move path.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:47 -0700
Message-ID: <156757180712.1838135.10985554611262678469.stgit@magnolia>
In-Reply-To: <156757174409.1838135.8885359673458816401.stgit@magnolia>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040068
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c       |    2 +-
 growfs/xfs_growfs.c |    2 +-
 include/Makefile    |    1 -
 include/path.h      |   61 ---------------------------------------------------
 io/cowextsize.c     |    2 +-
 io/encrypt.c        |    2 +-
 io/fsmap.c          |    2 +-
 io/io.h             |    2 +-
 io/label.c          |    2 +-
 io/parent.c         |    2 +-
 io/scrub.c          |    2 +-
 libfrog/Makefile    |    1 +
 libfrog/paths.c     |    2 +-
 libfrog/paths.h     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 quota/init.c        |    2 +-
 quota/quota.h       |    2 +-
 scrub/common.c      |    2 +-
 scrub/disk.c        |    2 +-
 scrub/filemap.c     |    2 +-
 scrub/fscounters.c  |    2 +-
 scrub/inodes.c      |    2 +-
 scrub/phase1.c      |    2 +-
 scrub/phase2.c      |    2 +-
 scrub/phase3.c      |    2 +-
 scrub/phase4.c      |    2 +-
 scrub/phase5.c      |    2 +-
 scrub/phase6.c      |    2 +-
 scrub/phase7.c      |    2 +-
 scrub/progress.c    |    2 +-
 scrub/read_verify.c |    2 +-
 scrub/repair.c      |    2 +-
 scrub/scrub.c       |    2 +-
 scrub/spacemap.c    |    2 +-
 scrub/unicrash.c    |    2 +-
 scrub/vfs.c         |    2 +-
 scrub/xfs_scrub.c   |    2 +-
 spaceman/file.c     |    2 +-
 spaceman/freesp.c   |    2 +-
 spaceman/info.c     |    2 +-
 spaceman/init.c     |    2 +-
 spaceman/prealloc.c |    2 +-
 spaceman/trim.c     |    2 +-
 42 files changed, 100 insertions(+), 100 deletions(-)
 delete mode 100644 include/path.h
 create mode 100644 libfrog/paths.h


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 1fd89eb8..a53eb924 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -10,7 +10,7 @@
 #include "jdm.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a3fe74ae..eab15984 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -5,7 +5,7 @@
  */
 
 #include "libxfs.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 
 static void
diff --git a/include/Makefile b/include/Makefile
index 2a00dea9..fc90bc48 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -28,7 +28,6 @@ LIBHFILES = libxfs.h \
 	xfs_trans.h \
 	command.h \
 	input.h \
-	path.h \
 	project.h \
 	platform_defs.h
 
diff --git a/include/path.h b/include/path.h
deleted file mode 100644
index 2d6c3c53..00000000
--- a/include/path.h
+++ /dev/null
@@ -1,61 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __PATH_H__
-#define __PATH_H__
-
-#include "platform_defs.h"
-
-/*
- * XFS Filesystem Paths
- *
- * Utility routines for iterating and searching through the list
- * of known mounted filesystems and project paths.
- */
-
-#define FS_MOUNT_POINT	(1<<0)
-#define FS_PROJECT_PATH	(1<<1)
-#define FS_FOREIGN	(1<<2)
-
-typedef struct fs_path {
-	char		*fs_name;	/* Data device for filesystem 	*/
-	dev_t		fs_datadev;
-	char		*fs_log;	/* External log device, if any	*/
-	dev_t		fs_logdev;
-	char		*fs_rt;		/* Realtime device, if any	*/
-	dev_t		fs_rtdev;
-	char		*fs_dir;	/* Directory / mount point	*/
-	uint		fs_flags;	/* FS_{MOUNT_POINT,PROJECT_PATH}*/
-	uint		fs_prid;	/* Project ID for tree root	*/
-} fs_path_t;
-
-extern int fs_count;		/* number of entries in fs table */
-extern int xfs_fs_count;	/* number of xfs entries in fs table */
-extern fs_path_t *fs_table;	/* array of entries in fs table  */
-extern fs_path_t *fs_path;	/* current entry in the fs table */
-extern char *mtab_file;
-
-extern void fs_table_initialise(int, char *[], int, char *[]);
-extern void fs_table_destroy(void);
-
-extern void fs_table_insert_project_path(char *__dir, uint __projid);
-
-
-extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
-extern fs_path_t *fs_table_lookup_mount(const char *__dir);
-extern fs_path_t *fs_table_lookup_blkdev(const char *bdev);
-
-typedef struct fs_cursor {
-	uint		count;		/* total count of mount entries	*/
-	uint		index;		/* current position in table	*/
-	uint		flags;		/* iterator flags: mounts/trees */
-	fs_path_t	*table;		/* local/global table pointer	*/
-	fs_path_t	local;		/* space for single-entry table	*/
-} fs_cursor_t;
-
-extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
-extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
-
-#endif	/* __PATH_H__ */
diff --git a/io/cowextsize.c b/io/cowextsize.c
index 029605af..da5c6680 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -14,7 +14,7 @@
 #include "init.h"
 #include "io.h"
 #include "input.h"
-#include "path.h"
+#include "libfrog/paths.h"
 
 static cmdinfo_t cowextsize_cmd;
 static long cowextsize;
diff --git a/io/encrypt.c b/io/encrypt.c
index 8db35259..7a0b2465 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -7,7 +7,7 @@
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "io.h"
 
 #ifndef ARRAY_SIZE
diff --git a/io/fsmap.c b/io/fsmap.c
index e91ffc36..12ec1e44 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -6,7 +6,7 @@
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "io.h"
 #include "input.h"
 #include "libfrog/fsgeom.h"
diff --git a/io/io.h b/io/io.h
index 0848ab98..00dff2b7 100644
--- a/io/io.h
+++ b/io/io.h
@@ -5,7 +5,7 @@
  */
 
 #include "xfs.h"
-#include "path.h"
+#include "libfrog/paths.h"
 
 /*
  * Read/write patterns (default is always "forward")
diff --git a/io/label.c b/io/label.c
index 72e07964..890ddde4 100644
--- a/io/label.c
+++ b/io/label.c
@@ -6,7 +6,7 @@
 #include <sys/ioctl.h>
 #include "platform_defs.h"
 #include "libxfs.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/parent.c b/io/parent.c
index 18bbf9b8..a78b4588 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -6,7 +6,7 @@
 
 #include "command.h"
 #include "input.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "parent.h"
 #include "handle.h"
 #include "jdm.h"
diff --git a/io/scrub.c b/io/scrub.c
index 052497be..9d1c62b5 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -9,7 +9,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "io.h"
 
 static struct cmdinfo scrub_cmd;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 715589c7..f8f7de68 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -37,6 +37,7 @@ crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
 fsgeom.h \
+paths.h \
 ptvar.h \
 radix-tree.h \
 topology.h \
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 6e266654..f0f4548e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -12,7 +12,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include "path.h"
+#include "paths.h"
 #include "input.h"
 #include "project.h"
 #include <limits.h>
diff --git a/libfrog/paths.h b/libfrog/paths.h
new file mode 100644
index 00000000..c08e3733
--- /dev/null
+++ b/libfrog/paths.h
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_PATH_H__
+#define __LIBFROG_PATH_H__
+
+#include "platform_defs.h"
+
+/*
+ * XFS Filesystem Paths
+ *
+ * Utility routines for iterating and searching through the list
+ * of known mounted filesystems and project paths.
+ */
+
+#define FS_MOUNT_POINT	(1<<0)
+#define FS_PROJECT_PATH	(1<<1)
+#define FS_FOREIGN	(1<<2)
+
+typedef struct fs_path {
+	char		*fs_name;	/* Data device for filesystem 	*/
+	dev_t		fs_datadev;
+	char		*fs_log;	/* External log device, if any	*/
+	dev_t		fs_logdev;
+	char		*fs_rt;		/* Realtime device, if any	*/
+	dev_t		fs_rtdev;
+	char		*fs_dir;	/* Directory / mount point	*/
+	uint		fs_flags;	/* FS_{MOUNT_POINT,PROJECT_PATH}*/
+	uint		fs_prid;	/* Project ID for tree root	*/
+} fs_path_t;
+
+extern int fs_count;		/* number of entries in fs table */
+extern int xfs_fs_count;	/* number of xfs entries in fs table */
+extern fs_path_t *fs_table;	/* array of entries in fs table  */
+extern fs_path_t *fs_path;	/* current entry in the fs table */
+extern char *mtab_file;
+
+extern void fs_table_initialise(int, char *[], int, char *[]);
+extern void fs_table_destroy(void);
+
+extern void fs_table_insert_project_path(char *__dir, uint __projid);
+
+
+extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
+extern fs_path_t *fs_table_lookup_mount(const char *__dir);
+extern fs_path_t *fs_table_lookup_blkdev(const char *bdev);
+
+typedef struct fs_cursor {
+	uint		count;		/* total count of mount entries	*/
+	uint		index;		/* current position in table	*/
+	uint		flags;		/* iterator flags: mounts/trees */
+	fs_path_t	*table;		/* local/global table pointer	*/
+	fs_path_t	local;		/* space for single-entry table	*/
+} fs_cursor_t;
+
+extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
+extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
+
+#endif	/* __LIBFROG_PATH_H__ */
diff --git a/quota/init.c b/quota/init.c
index 8244e38d..94258275 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "path.h"
+#include "libfrog/paths.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/quota/quota.h b/quota/quota.h
index b7f259e8..5db0a741 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -5,7 +5,7 @@
  */
 
 #include "xqm.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "project.h"
 #include <stdbool.h>
 
diff --git a/scrub/common.c b/scrub/common.c
index 1cd2b7ba..7db47044 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -8,7 +8,7 @@
 #include <sys/statvfs.h>
 #include <syslog.h>
 #include "platform_defs.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
diff --git a/scrub/disk.c b/scrub/disk.c
index dd109533..91e13140 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -18,7 +18,7 @@
 #endif
 #include "platform_defs.h"
 #include "libfrog.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "disk.h"
diff --git a/scrub/filemap.c b/scrub/filemap.c
index dc8f4881..bdc6d8f9 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -10,7 +10,7 @@
 #include <string.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "filemap.h"
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9635c44f..8e4b3467 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -10,7 +10,7 @@
 #include "platform_defs.h"
 #include "xfs_arch.h"
 #include "xfs_format.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 19923de5..580a845e 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -12,7 +12,7 @@
 #include "xfs_arch.h"
 #include "xfs_format.h"
 #include "handle.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index d0e77cab..d123c419 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -16,7 +16,7 @@
 #include "libfrog.h"
 #include "libfrog/workqueue.h"
 #include "input.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "handle.h"
 #include "bitops.h"
 #include "libfrog/avl64.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index baec11dd..f064c83d 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -8,7 +8,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 64a499c3..5eff7907 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -8,7 +8,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 14074835..589777f6 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -9,7 +9,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index ab015821..3ff34251 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -14,7 +14,7 @@
 #include <linux/fs.h>
 #include "handle.h"
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase6.c b/scrub/phase6.c
index d0e62cea..506e75d2 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -8,7 +8,7 @@
 #include <dirent.h>
 #include <sys/statvfs.h>
 #include "handle.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 8ac1da07..f82b60d6 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -7,7 +7,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/ptvar.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/progress.c b/scrub/progress.c
index d0afe90a..c9a9d286 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -8,7 +8,7 @@
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include <time.h>
-#include "path.h"
+#include "libfrog/paths.h"
 #include "disk.h"
 #include "read_verify.h"
 #include "xfs_scrub.h"
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 828f6be6..2152d167 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -9,7 +9,7 @@
 #include <sys/statvfs.h>
 #include "libfrog/ptvar.h"
 #include "libfrog/workqueue.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
diff --git a/scrub/repair.c b/scrub/repair.c
index 45450d8c..0e5afb20 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -9,7 +9,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 136ed529..ac67f8ec 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -11,7 +11,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "list.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 774efbaa..a7876478 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -9,7 +9,7 @@
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include "libfrog/workqueue.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "spacemap.h"
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 824b10f0..17e8f34f 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -13,7 +13,7 @@
 #include <unicode/ustring.h>
 #include <unicode/unorm2.h>
 #include <unicode/uspoof.h>
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "unicrash.h"
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 7d79e7f7..b5d54837 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -9,7 +9,7 @@
 #include <sys/types.h>
 #include <sys/statvfs.h>
 #include "handle.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 71fc274f..05478093 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -12,7 +12,7 @@
 #include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "input.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "unicrash.h"
diff --git a/spaceman/file.c b/spaceman/file.c
index 34e5f005..f96a29e5 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -10,7 +10,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 #include "libfrog/fsgeom.h"
 
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 11d0aafb..034f2340 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -10,7 +10,7 @@
 #include <linux/fiemap.h>
 #include "command.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 #include "input.h"
 
diff --git a/spaceman/info.c b/spaceman/info.c
index 80442e9a..f563cf1e 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -6,7 +6,7 @@
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 #include "libfrog/fsgeom.h"
 
diff --git a/spaceman/init.c b/spaceman/init.c
index c845f920..fa0397ab 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -8,7 +8,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 
 char	*progname;
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index 85dfc9ee..b223010c 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -8,7 +8,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 
 static cmdinfo_t prealloc_cmd;
diff --git a/spaceman/trim.c b/spaceman/trim.c
index 88c75a57..b23e2bf9 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -7,7 +7,7 @@
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
-#include "path.h"
+#include "libfrog/paths.h"
 #include "space.h"
 #include "input.h"
 

