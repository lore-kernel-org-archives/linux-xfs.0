Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E3AC43140
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318F220820
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jcLq16IM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392126AbfIFDdl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:33:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392118AbfIFDdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:33:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863TpvX106680;
        Fri, 6 Sep 2019 03:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Wamv3MP24X7isCpFNWBthu8yUg15Lsa0tbYZj/TmASA=;
 b=jcLq16IMoo2NuvFnhSXocKg1YBW07aLrUyTu/97vdgxNSRqRxrvl07pQ2TEZcvrnEHRb
 l3D9jOsqt4wkfs8k59pFSTOoSjkK3vhbIfDGiH0kj7eOx9f0DfhoMiJWxuV4P95CU9qv
 sXbE5F2FlpNhQwGZU/CTc2mR6GDiQIx4PVjHTNW5HwHVB4RkLuCV3tnOfvOugkiex3cR
 uNI6d5oOcNH2BZF2Xonh1RqiQj0/+DKDYBd/f2v1uzypTrdY9BvwChxHziBD2SdH6v9F
 1Eq//8jKaQ/TMjmdwBZzPQ3puGqqE/wLy5wKUDkcaDyGxYmRudDmyG4z+JW25ryrn6pW sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uuf4n0330-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XTIr188625;
        Fri, 6 Sep 2019 03:33:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2utpmc73gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863XZAj017560;
        Fri, 6 Sep 2019 03:33:35 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:33:34 -0700
Subject: [PATCH 2/5] libfrog: share scrub headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:33:34 -0700
Message-ID: <156774081444.2643094.5994336399369294046.stgit@magnolia>
In-Reply-To: <156774080205.2643094.9791648860536208060.stgit@magnolia>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_io and xfs_scrub have nearly identical structures to describe scrub
types.  Combine them into a single header file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c       |   89 ++++++++++------------------------
 libfrog/Makefile |    2 +
 libfrog/scrub.c  |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/scrub.h  |   29 +++++++++++
 scrub/scrub.c    |  141 +++++++++++++++---------------------------------------
 5 files changed, 238 insertions(+), 163 deletions(-)
 create mode 100644 libfrog/scrub.c
 create mode 100644 libfrog/scrub.h


diff --git a/io/scrub.c b/io/scrub.c
index 9d1c62b5..fc22ba49 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -10,55 +10,17 @@
 #include "input.h"
 #include "init.h"
 #include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "io.h"
 
 static struct cmdinfo scrub_cmd;
 static struct cmdinfo repair_cmd;
 
-/* Type info and names for the scrub types. */
-enum scrub_type {
-	ST_NONE,	/* disabled */
-	ST_PERAG,	/* per-AG metadata */
-	ST_FS,		/* per-FS metadata */
-	ST_INODE,	/* per-inode metadata */
-};
-
-struct scrub_descr {
-	const char	*name;
-	enum scrub_type	type;
-};
-
-static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
-	[XFS_SCRUB_TYPE_PROBE]		= {"probe",		ST_NONE},
-	[XFS_SCRUB_TYPE_SB]		= {"sb",		ST_PERAG},
-	[XFS_SCRUB_TYPE_AGF]		= {"agf",		ST_PERAG},
-	[XFS_SCRUB_TYPE_AGFL]		= {"agfl",		ST_PERAG},
-	[XFS_SCRUB_TYPE_AGI]		= {"agi",		ST_PERAG},
-	[XFS_SCRUB_TYPE_BNOBT]		= {"bnobt",		ST_PERAG},
-	[XFS_SCRUB_TYPE_CNTBT]		= {"cntbt",		ST_PERAG},
-	[XFS_SCRUB_TYPE_INOBT]		= {"inobt",		ST_PERAG},
-	[XFS_SCRUB_TYPE_FINOBT]		= {"finobt",		ST_PERAG},
-	[XFS_SCRUB_TYPE_RMAPBT]		= {"rmapbt",		ST_PERAG},
-	[XFS_SCRUB_TYPE_REFCNTBT]	= {"refcountbt",	ST_PERAG},
-	[XFS_SCRUB_TYPE_INODE]		= {"inode",		ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTD]		= {"bmapbtd",		ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTA]		= {"bmapbta",		ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTC]		= {"bmapbtc",		ST_INODE},
-	[XFS_SCRUB_TYPE_DIR]		= {"directory",		ST_INODE},
-	[XFS_SCRUB_TYPE_XATTR]		= {"xattr",		ST_INODE},
-	[XFS_SCRUB_TYPE_SYMLINK]	= {"symlink",		ST_INODE},
-	[XFS_SCRUB_TYPE_PARENT]		= {"parent",		ST_INODE},
-	[XFS_SCRUB_TYPE_RTBITMAP]	= {"rtbitmap",		ST_FS},
-	[XFS_SCRUB_TYPE_RTSUM]		= {"rtsummary",		ST_FS},
-	[XFS_SCRUB_TYPE_UQUOTA]		= {"usrquota",		ST_FS},
-	[XFS_SCRUB_TYPE_GQUOTA]		= {"grpquota",		ST_FS},
-	[XFS_SCRUB_TYPE_PQUOTA]		= {"prjquota",		ST_FS},
-};
-
 static void
 scrub_help(void)
 {
-	const struct scrub_descr	*d;
+	const struct xfrog_scrub_descr	*d;
 	int				i;
 
 	printf(_(
@@ -74,7 +36,7 @@ scrub_help(void)
 " 'scrub bmapbtd 128 13525' - scrubs the extent map of inode 128 gen 13525.\n"
 "\n"
 " Known metadata scrub types are:"));
-	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
+	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
 	printf("\n");
 }
@@ -87,22 +49,23 @@ scrub_ioctl(
 	uint32_t			control2)
 {
 	struct xfs_scrub_metadata	meta;
-	const struct scrub_descr	*sc;
+	const struct xfrog_scrub_descr	*sc;
 	int				error;
 
-	sc = &scrubbers[type];
+	sc = &xfrog_scrubbers[type];
 	memset(&meta, 0, sizeof(meta));
 	meta.sm_type = type;
 	switch (sc->type) {
-	case ST_PERAG:
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		meta.sm_agno = control;
 		break;
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		meta.sm_ino = control;
 		meta.sm_gen = control2;
 		break;
-	case ST_NONE:
-	case ST_FS:
+	case XFROG_SCRUB_TYPE_NONE:
+	case XFROG_SCRUB_TYPE_FS:
 		/* no control parameters */
 		break;
 	}
@@ -135,7 +98,7 @@ parse_args(
 	int				i, c;
 	uint64_t			control = 0;
 	uint32_t			control2 = 0;
-	const struct scrub_descr	*d = NULL;
+	const struct xfrog_scrub_descr	*d = NULL;
 
 	while ((c = getopt(argc, argv, "")) != EOF) {
 		switch (c) {
@@ -146,7 +109,7 @@ parse_args(
 	if (optind > argc - 1)
 		return command_usage(cmdinfo);
 
-	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
+	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
 		if (strcmp(d->name, argv[optind]) == 0) {
 			type = i;
 			break;
@@ -159,7 +122,7 @@ parse_args(
 	optind++;
 
 	switch (d->type) {
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		if (optind == argc) {
 			control = 0;
 			control2 = 0;
@@ -184,7 +147,8 @@ parse_args(
 			return 0;
 		}
 		break;
-	case ST_PERAG:
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		if (optind != argc - 1) {
 			fprintf(stderr,
 				_("Must specify one AG number.\n"));
@@ -197,8 +161,8 @@ parse_args(
 			return 0;
 		}
 		break;
-	case ST_FS:
-	case ST_NONE:
+	case XFROG_SCRUB_TYPE_FS:
+	case XFROG_SCRUB_TYPE_NONE:
 		if (optind != argc) {
 			fprintf(stderr,
 				_("No parameters allowed.\n"));
@@ -241,7 +205,7 @@ scrub_init(void)
 static void
 repair_help(void)
 {
-	const struct scrub_descr	*d;
+	const struct xfrog_scrub_descr	*d;
 	int				i;
 
 	printf(_(
@@ -257,7 +221,7 @@ repair_help(void)
 " 'repair bmapbtd 128 13525' - repairs the extent map of inode 128 gen 13525.\n"
 "\n"
 " Known metadata repairs types are:"));
-	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
+	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
 	printf("\n");
 }
@@ -270,22 +234,23 @@ repair_ioctl(
 	uint32_t			control2)
 {
 	struct xfs_scrub_metadata	meta;
-	const struct scrub_descr	*sc;
+	const struct xfrog_scrub_descr	*sc;
 	int				error;
 
-	sc = &scrubbers[type];
+	sc = &xfrog_scrubbers[type];
 	memset(&meta, 0, sizeof(meta));
 	meta.sm_type = type;
 	switch (sc->type) {
-	case ST_PERAG:
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		meta.sm_agno = control;
 		break;
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		meta.sm_ino = control;
 		meta.sm_gen = control2;
 		break;
-	case ST_NONE:
-	case ST_FS:
+	case XFROG_SCRUB_TYPE_NONE:
+	case XFROG_SCRUB_TYPE_FS:
 		/* no control parameters */
 		break;
 	}
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 25b5a03c..de67bf00 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -23,6 +23,7 @@ paths.c \
 projects.c \
 ptvar.c \
 radix-tree.c \
+scrub.c \
 topology.c \
 util.c \
 workqueue.c
@@ -41,6 +42,7 @@ paths.h \
 projects.h \
 ptvar.h \
 radix-tree.h \
+scrub.h \
 topology.h \
 workqueue.h
 
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
new file mode 100644
index 00000000..228e4339
--- /dev/null
+++ b/libfrog/scrub.c
@@ -0,0 +1,140 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2019 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "fsgeom.h"
+#include "scrub.h"
+
+/* These must correspond to XFS_SCRUB_TYPE_ */
+const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_PROBE] = {
+		.name	= "probe",
+		.descr	= "metadata",
+		.type	= XFROG_SCRUB_TYPE_NONE,
+	},
+	[XFS_SCRUB_TYPE_SB] = {
+		.name	= "sb",
+		.descr	= "superblock",
+		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+	},
+	[XFS_SCRUB_TYPE_AGF] = {
+		.name	= "agf",
+		.descr	= "free space header",
+		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+	},
+	[XFS_SCRUB_TYPE_AGFL] = {
+		.name	= "agfl",
+		.descr	= "free list",
+		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+	},
+	[XFS_SCRUB_TYPE_AGI] = {
+		.name	= "agi",
+		.descr	= "inode header",
+		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+	},
+	[XFS_SCRUB_TYPE_BNOBT] = {
+		.name	= "bnobt",
+		.descr	= "freesp by block btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_CNTBT] = {
+		.name	= "cntbt",
+		.descr	= "freesp by length btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_INOBT] = {
+		.name	= "inobt",
+		.descr	= "inode btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_FINOBT] = {
+		.name	= "finobt",
+		.descr	= "free inode btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_RMAPBT] = {
+		.name	= "rmapbt",
+		.descr	= "reverse mapping btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_REFCNTBT] = {
+		.name	= "refcountbt",
+		.descr	= "reference count btree",
+		.type	= XFROG_SCRUB_TYPE_PERAG,
+	},
+	[XFS_SCRUB_TYPE_INODE] = {
+		.name	= "inode",
+		.descr	= "inode record",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_BMBTD] = {
+		.name	= "bmapbtd",
+		.descr	= "data block map",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_BMBTA] = {
+		.name	= "bmapbta",
+		.descr	= "attr block map",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_BMBTC] = {
+		.name	= "bmapbtc",
+		.descr	= "CoW block map",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_DIR] = {
+		.name	= "directory",
+		.descr	= "directory entries",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_XATTR] = {
+		.name	= "xattr",
+		.descr	= "extended attributes",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_SYMLINK] = {
+		.name	= "symlink",
+		.descr	= "symbolic link",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_PARENT] = {
+		.name	= "parent",
+		.descr	= "parent pointer",
+		.type	= XFROG_SCRUB_TYPE_INODE,
+	},
+	[XFS_SCRUB_TYPE_RTBITMAP] = {
+		.name	= "rtbitmap",
+		.descr	= "realtime bitmap",
+		.type	= XFROG_SCRUB_TYPE_FS,
+	},
+	[XFS_SCRUB_TYPE_RTSUM] = {
+		.name	= "rtsummary",
+		.descr	= "realtime summary",
+		.type	= XFROG_SCRUB_TYPE_FS,
+	},
+	[XFS_SCRUB_TYPE_UQUOTA] = {
+		.name	= "usrquota",
+		.descr	= "user quotas",
+		.type	= XFROG_SCRUB_TYPE_FS,
+	},
+	[XFS_SCRUB_TYPE_GQUOTA] = {
+		.name	= "grpquota",
+		.descr	= "group quotas",
+		.type	= XFROG_SCRUB_TYPE_FS,
+	},
+	[XFS_SCRUB_TYPE_PQUOTA] = {
+		.name	= "prjquota",
+		.descr	= "project quotas",
+		.type	= XFROG_SCRUB_TYPE_FS,
+	},
+};
+
+int
+xfrog_scrub_metadata(
+	struct xfs_fd			*xfd,
+	struct xfs_scrub_metadata	*meta)
+{
+	return ioctl(xfd->fd, XFS_IOC_SCRUB_METADATA, meta);
+}
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
new file mode 100644
index 00000000..6fda8975
--- /dev/null
+++ b/libfrog/scrub.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2019 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_SCRUB_H__
+#define __LIBFROG_SCRUB_H__
+
+/* Type info and names for the scrub types. */
+enum xfrog_scrub_type {
+	XFROG_SCRUB_TYPE_NONE,		/* not metadata */
+	XFROG_SCRUB_TYPE_AGHEADER,	/* per-AG header */
+	XFROG_SCRUB_TYPE_PERAG,		/* per-AG metadata */
+	XFROG_SCRUB_TYPE_FS,		/* per-FS metadata */
+	XFROG_SCRUB_TYPE_INODE,		/* per-inode metadata */
+};
+
+/* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
+struct xfrog_scrub_descr {
+	const char		*name;
+	const char		*descr;
+	enum xfrog_scrub_type	type;
+};
+
+extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
+
+int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
+
+#endif	/* __LIBFROG_SCRUB_H__ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 62edc361..153d29d5 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -12,6 +12,8 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -21,93 +23,28 @@
 
 /* Online scrub and repair wrappers. */
 
-/* Type info and names for the scrub types. */
-enum scrub_type {
-	ST_NONE,	/* disabled */
-	ST_AGHEADER,	/* per-AG header */
-	ST_PERAG,	/* per-AG metadata */
-	ST_FS,		/* per-FS metadata */
-	ST_INODE,	/* per-inode metadata */
-};
-struct scrub_descr {
-	const char	*name;
-	enum scrub_type	type;
-};
-
-/* These must correspond to XFS_SCRUB_TYPE_ */
-static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
-	[XFS_SCRUB_TYPE_PROBE] =
-		{"metadata",				ST_NONE},
-	[XFS_SCRUB_TYPE_SB] =
-		{"superblock",				ST_AGHEADER},
-	[XFS_SCRUB_TYPE_AGF] =
-		{"free space header",			ST_AGHEADER},
-	[XFS_SCRUB_TYPE_AGFL] =
-		{"free list",				ST_AGHEADER},
-	[XFS_SCRUB_TYPE_AGI] =
-		{"inode header",			ST_AGHEADER},
-	[XFS_SCRUB_TYPE_BNOBT] =
-		{"freesp by block btree",		ST_PERAG},
-	[XFS_SCRUB_TYPE_CNTBT] =
-		{"freesp by length btree",		ST_PERAG},
-	[XFS_SCRUB_TYPE_INOBT] =
-		{"inode btree",				ST_PERAG},
-	[XFS_SCRUB_TYPE_FINOBT] =
-		{"free inode btree",			ST_PERAG},
-	[XFS_SCRUB_TYPE_RMAPBT] =
-		{"reverse mapping btree",		ST_PERAG},
-	[XFS_SCRUB_TYPE_REFCNTBT] =
-		{"reference count btree",		ST_PERAG},
-	[XFS_SCRUB_TYPE_INODE] =
-		{"inode record",			ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTD] =
-		{"data block map",			ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTA] =
-		{"attr block map",			ST_INODE},
-	[XFS_SCRUB_TYPE_BMBTC] =
-		{"CoW block map",			ST_INODE},
-	[XFS_SCRUB_TYPE_DIR] =
-		{"directory entries",			ST_INODE},
-	[XFS_SCRUB_TYPE_XATTR] =
-		{"extended attributes",			ST_INODE},
-	[XFS_SCRUB_TYPE_SYMLINK] =
-		{"symbolic link",			ST_INODE},
-	[XFS_SCRUB_TYPE_PARENT] =
-		{"parent pointer",			ST_INODE},
-	[XFS_SCRUB_TYPE_RTBITMAP] =
-		{"realtime bitmap",			ST_FS},
-	[XFS_SCRUB_TYPE_RTSUM] =
-		{"realtime summary",			ST_FS},
-	[XFS_SCRUB_TYPE_UQUOTA] =
-		{"user quotas",				ST_FS},
-	[XFS_SCRUB_TYPE_GQUOTA] =
-		{"group quotas",			ST_FS},
-	[XFS_SCRUB_TYPE_PQUOTA] =
-		{"project quotas",			ST_FS},
-};
-
 /* Format a scrub description. */
 static void
 format_scrub_descr(
 	char				*buf,
 	size_t				buflen,
 	struct xfs_scrub_metadata	*meta,
-	const struct scrub_descr	*sc)
+	const struct xfrog_scrub_descr	*sc)
 {
 	switch (sc->type) {
-	case ST_AGHEADER:
-	case ST_PERAG:
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
-				_(sc->name));
+				_(sc->descr));
 		break;
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		snprintf(buf, buflen, _("Inode %"PRIu64" %s"),
-				(uint64_t)meta->sm_ino, _(sc->name));
+				(uint64_t)meta->sm_ino, _(sc->descr));
 		break;
-	case ST_FS:
-		snprintf(buf, buflen, _("%s"), _(sc->name));
+	case XFROG_SCRUB_TYPE_FS:
+		snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
-	case ST_NONE:
+	case XFROG_SCRUB_TYPE_NONE:
 		assert(0);
 		break;
 	}
@@ -186,11 +123,12 @@ xfs_check_metadata(
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	format_scrub_descr(buf, DESCR_BUFSZ, meta, &scrubbers[meta->sm_type]);
+	format_scrub_descr(buf, DESCR_BUFSZ, meta,
+			&xfrog_scrubbers[meta->sm_type]);
 
 	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
 retry:
-	error = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, meta);
+	error = xfrog_scrub_metadata(&ctx->mnt, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	if (error) {
@@ -296,7 +234,7 @@ xfs_scrub_report_preen_triggers(
 			ctx->preen_triggers[i] = false;
 			pthread_mutex_unlock(&ctx->lock);
 			str_info(ctx, ctx->mntpoint,
-_("Optimizations of %s are possible."), scrubbers[i].name);
+_("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 		} else {
 			pthread_mutex_unlock(&ctx->lock);
 		}
@@ -321,12 +259,12 @@ xfs_scrub_save_repair(
 	memset(aitem, 0, sizeof(*aitem));
 	aitem->type = meta->sm_type;
 	aitem->flags = meta->sm_flags;
-	switch (scrubbers[meta->sm_type].type) {
-	case ST_AGHEADER:
-	case ST_PERAG:
+	switch (xfrog_scrubbers[meta->sm_type].type) {
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		aitem->agno = meta->sm_agno;
 		break;
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		aitem->ino = meta->sm_ino;
 		aitem->gen = meta->sm_gen;
 		break;
@@ -342,16 +280,16 @@ xfs_scrub_save_repair(
 static bool
 xfs_scrub_metadata(
 	struct scrub_ctx		*ctx,
-	enum scrub_type			scrub_type,
+	enum xfrog_scrub_type		scrub_type,
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {0};
-	const struct scrub_descr	*sc;
+	const struct xfrog_scrub_descr	*sc;
 	enum check_outcome		fix;
 	int				type;
 
-	sc = scrubbers;
+	sc = xfrog_scrubbers;
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
 		if (sc->type != scrub_type)
 			continue;
@@ -423,7 +361,7 @@ xfs_scrub_ag_headers(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_AGHEADER, agno, alist);
+	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
 }
 
 /* Scrub each AG's metadata btrees. */
@@ -433,7 +371,7 @@ xfs_scrub_ag_metadata(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_PERAG, agno, alist);
+	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
 }
 
 /* Scrub whole-FS metadata btrees. */
@@ -442,7 +380,7 @@ xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, ST_FS, 0, alist);
+	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
 }
 
 /* How many items do we have to check? */
@@ -450,18 +388,18 @@ unsigned int
 xfs_scrub_estimate_ag_work(
 	struct scrub_ctx		*ctx)
 {
-	const struct scrub_descr	*sc;
+	const struct xfrog_scrub_descr	*sc;
 	int				type;
 	unsigned int			estimate = 0;
 
-	sc = scrubbers;
+	sc = xfrog_scrubbers;
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
 		switch (sc->type) {
-		case ST_AGHEADER:
-		case ST_PERAG:
+		case XFROG_SCRUB_TYPE_AGHEADER:
+		case XFROG_SCRUB_TYPE_PERAG:
 			estimate += ctx->mnt.fsgeom.agcount;
 			break;
-		case ST_FS:
+		case XFROG_SCRUB_TYPE_FS:
 			estimate++;
 			break;
 		default:
@@ -484,7 +422,7 @@ __xfs_scrub_file(
 	enum check_outcome		fix;
 
 	assert(type < XFS_SCRUB_TYPE_NR);
-	assert(scrubbers[type].type == ST_INODE);
+	assert(xfrog_scrubbers[type].type == XFROG_SCRUB_TYPE_INODE);
 
 	meta.sm_type = type;
 	meta.sm_ino = ino;
@@ -605,7 +543,7 @@ __xfs_scrub_test(
 	meta.sm_type = type;
 	if (repair)
 		meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
-	error = ioctl(ctx->mnt.fd, XFS_IOC_SCRUB_METADATA, &meta);
+	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
 	if (!error)
 		return true;
 	switch (errno) {
@@ -622,7 +560,7 @@ _("Filesystem is mounted norecovery; cannot proceed."));
 		if (debug || verbose)
 			str_info(ctx, ctx->mntpoint,
 _("Kernel %s %s facility not detected."),
-					_(scrubbers[type].name),
+					_(xfrog_scrubbers[type].descr),
 					repair ? _("repair") : _("scrub"));
 		return false;
 	case ENOENT:
@@ -709,12 +647,12 @@ xfs_repair_metadata(
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	meta.sm_type = aitem->type;
 	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
-	switch (scrubbers[aitem->type].type) {
-	case ST_AGHEADER:
-	case ST_PERAG:
+	switch (xfrog_scrubbers[aitem->type].type) {
+	case XFROG_SCRUB_TYPE_AGHEADER:
+	case XFROG_SCRUB_TYPE_PERAG:
 		meta.sm_agno = aitem->agno;
 		break;
-	case ST_INODE:
+	case XFROG_SCRUB_TYPE_INODE:
 		meta.sm_ino = aitem->ino;
 		meta.sm_gen = aitem->gen;
 		break;
@@ -726,14 +664,15 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
-	format_scrub_descr(buf, DESCR_BUFSZ, &meta, &scrubbers[meta.sm_type]);
+	format_scrub_descr(buf, DESCR_BUFSZ, &meta,
+			&xfrog_scrubbers[meta.sm_type]);
 
 	if (needs_repair(&meta))
 		str_info(ctx, buf, _("Attempting repair."));
 	else if (debug || verbose)
 		str_info(ctx, buf, _("Attempting optimization."));
 
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
 	if (error) {
 		switch (errno) {
 		case EDEADLOCK:

