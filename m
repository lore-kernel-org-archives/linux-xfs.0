Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C185C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2326C20850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eaeP9dI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfHZVVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:21:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:21:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLE0vW001361;
        Mon, 26 Aug 2019 21:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MiKryXY0qRzkltzMDV+sq/kCtlCcHYz1UrK0fFyXnEg=;
 b=eaeP9dI8GeTloqc8h7c0gVgZco9ASJwCPp0lrq2H47UNMTMGz9YvhDoWTymfEbXN20gt
 uAD34mNOFicg1/VJTZEZy8cGENdXNmdF7yCD7Gxjjw+2CBnGkxm7C2dl9+pLUpiLudGL
 UysRP2N0RRY0p8BOhXHxLl2eRwRPpBboUI416fSntMaUafQAv/usp+XUzFQlqMhGWSi1
 AebdcCymsGi8uSevu2JWgLOiDofwnVWukk1SNRvVxEG/RVMJGegMwn51tRijTenpPDVm
 yv/0IHnYWXctmtsgk+EQ5Lymg4ieasOV7mYNThT8ahphnlSpn8anjCOR4xltRGISXmCw 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx0460-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIc4Y169612;
        Mon, 26 Aug 2019 21:20:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2umhu7wsmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:57 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLKtUU023538;
        Mon, 26 Aug 2019 21:20:56 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:20:55 -0700
Subject: [PATCH 1/1] xfs_spaceman: report health problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:20:54 -0700
Message-ID: <156685445446.2839912.426160608673674011.stgit@magnolia>
In-Reply-To: <156685444816.2839912.12432359726352663923.stgit@magnolia>
References: <156685444816.2839912.12432359726352663923.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the fs and ag geometry ioctls to report health problems to users.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h         |    2 
 libfrog/fsgeom.c        |   11 +
 man/man8/xfs_spaceman.8 |   28 +++
 spaceman/Makefile       |    2 
 spaceman/health.c       |  432 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |    1 
 spaceman/space.h        |    1 
 7 files changed, 476 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/health.c


diff --git a/include/xfrog.h b/include/xfrog.h
index 5748e967..3a43a403 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -177,4 +177,6 @@ struct xfs_inogrp;
 int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
 		struct xfs_inogrp *ubuffer, uint32_t *ocount);
 
+int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
+
 #endif	/* __XFROG_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 17479e4a..cddb5a39 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -131,3 +131,14 @@ xfrog_close(
 	xfd->fd = -1;
 	return ret;
 }
+
+/* Try to obtain an AG's geometry. */
+int
+xfrog_ag_geometry(
+	int			fd,
+	unsigned int		agno,
+	struct xfs_ag_geometry	*ageo)
+{
+	ageo->ag_number = agno;
+	return ioctl(fd, XFS_IOC_AG_GEOMETRY, ageo);
+}
diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 12dd04e4..ece840d7 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -91,6 +91,34 @@ The output will have the same format that
 .BR "xfs_info" "(8)"
 prints when querying a filesystem.
 .TP
+.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-q ] [ paths ]"
+Reports the health of the given group of filesystem metadata.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-a agno
+Report on the health of the given allocation group.
+.TP
+.B \-c
+Scan all inodes in the filesystem and report each file's health status.
+If the
+.B \-a
+option is given, scan only the inodes in that AG.
+.TP
+.B \-f
+Report on the health of metadata that affect the entire filesystem.
+.TP
+.B \-i inum
+Report on the health of a specific inode.
+.TP
+.B \-q
+Report only unhealthy metadata.
+.TP
+.B paths
+Report on the health of the files at the given path.
+.PD
+.RE
+.TP
 .BR "help [ " command " ]"
 Display a brief description of one or all commands.
 .TP
diff --git a/spaceman/Makefile b/spaceman/Makefile
index b1c1b16d..d01aa74a 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = info.c init.c file.c prealloc.c trim.c
+CFILES = info.c init.c file.c health.c prealloc.c trim.c
 LSRCFILES = xfs_info.sh
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/spaceman/health.c b/spaceman/health.c
new file mode 100644
index 00000000..6c9c75a1
--- /dev/null
+++ b/spaceman/health.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2019 Oracle.
+ * All Rights Reserved.
+ */
+#include "platform_defs.h"
+#include "libxfs.h"
+#include "xfrog.h"
+#include "command.h"
+#include "init.h"
+#include "path.h"
+#include "space.h"
+#include "input.h"
+#include "fsgeom.h"
+#include "libfrog.h"
+
+static cmdinfo_t health_cmd;
+static unsigned long long reported;
+static bool comprehensive;
+static bool quiet;
+
+static bool has_realtime(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0;
+}
+
+static bool has_finobt(const struct xfs_fsop_geom *g)
+{
+	return g->flags & XFS_FSOP_GEOM_FLAGS_FINOBT;
+}
+
+static bool has_rmapbt(const struct xfs_fsop_geom *g)
+{
+	return g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT;
+}
+
+static bool has_reflink(const struct xfs_fsop_geom *g)
+{
+	return g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK;
+}
+
+struct flag_map {
+	unsigned int		mask;
+	bool			(*has_fn)(const struct xfs_fsop_geom *g);
+	const char		*descr;
+};
+
+static const struct flag_map fs_flags[] = {
+	{
+		.mask = XFS_FSOP_GEOM_SICK_COUNTERS,
+		.descr = "summary counters",
+	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_UQUOTA,
+		.descr = "user quota",
+	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_GQUOTA,
+		.descr = "group quota",
+	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_PQUOTA,
+		.descr = "project quota",
+	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_RT_BITMAP,
+		.descr = "realtime bitmap",
+		.has_fn = has_realtime,
+	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_RT_SUMMARY,
+		.descr = "realtime summary",
+		.has_fn = has_realtime,
+	},
+	{0},
+};
+
+static const struct flag_map ag_flags[] = {
+	{
+		.mask = XFS_AG_GEOM_SICK_SB,
+		.descr = "superblock",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_AGF,
+		.descr = "AGF header",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_AGFL,
+		.descr = "AGFL header",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_AGI,
+		.descr = "AGI header",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_BNOBT,
+		.descr = "free space by block btree",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_CNTBT,
+		.descr = "free space by length btree",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_INOBT,
+		.descr = "inode btree",
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_FINOBT,
+		.descr = "free inode btree",
+		.has_fn = has_finobt,
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_RMAPBT,
+		.descr = "reverse mappings btree",
+		.has_fn = has_rmapbt,
+	},
+	{
+		.mask = XFS_AG_GEOM_SICK_REFCNTBT,
+		.descr = "reference count btree",
+		.has_fn = has_reflink,
+	},
+	{0},
+};
+
+static const struct flag_map inode_flags[] = {
+	{
+		.mask = XFS_BS_SICK_INODE,
+		.descr = "inode core",
+	},
+	{
+		.mask = XFS_BS_SICK_BMBTD,
+		.descr = "data fork",
+	},
+	{
+		.mask = XFS_BS_SICK_BMBTA,
+		.descr = "extended attribute fork",
+	},
+	{
+		.mask = XFS_BS_SICK_BMBTC,
+		.descr = "copy on write fork",
+	},
+	{
+		.mask = XFS_BS_SICK_DIR,
+		.descr = "directory",
+	},
+	{
+		.mask = XFS_BS_SICK_XATTR,
+		.descr = "extended attributes",
+	},
+	{
+		.mask = XFS_BS_SICK_SYMLINK,
+		.descr = "symbolic link target",
+	},
+	{
+		.mask = XFS_BS_SICK_PARENT,
+		.descr = "parent pointers",
+	},
+	{0},
+};
+
+/* Convert a flag mask to a report. */
+static void
+report_sick(
+	const char			*descr,
+	const struct flag_map		*maps,
+	unsigned int			sick,
+	unsigned int			checked)
+{
+	const struct flag_map		*f;
+	bool				bad;
+
+	for (f = maps; f->mask != 0; f++) {
+		if (f->has_fn && !f->has_fn(&file->xfd.fsgeom))
+			continue;
+		if (!(checked & f->mask))
+			continue;
+		reported++;
+		bad = sick & f->mask;
+		if (!bad && quiet)
+			continue;
+		printf("%s %s: %s\n", descr, _(f->descr),
+				bad ? _("unhealthy") : _("ok"));
+	}
+}
+
+/* Report on an AG's health. */
+static int
+report_ag_sick(
+	xfs_agnumber_t		agno)
+{
+	struct xfs_ag_geometry	ageo;
+	char			descr[256];
+	int			ret;
+
+	ret = xfrog_ag_geometry(file->xfd.fd, agno, &ageo);
+	if (ret) {
+		perror("ag_geometry");
+		return 1;
+	}
+	snprintf(descr, sizeof(descr) - 1, _("AG %u"), agno);
+	report_sick(descr, ag_flags, ageo.ag_sick, ageo.ag_checked);
+	return 0;
+}
+
+/* Report on an inode's health. */
+static int
+report_inode_health(
+	unsigned long long	ino,
+	const char		*descr)
+{
+	struct xfs_bstat	bs;
+	char			d[256];
+	int			ret;
+
+	if (!descr) {
+		snprintf(d, sizeof(d) - 1, _("inode %llu"), ino);
+		descr = d;
+	}
+
+	ret = xfrog_bulkstat_single(&file->xfd, ino, &bs);
+	if (ret) {
+		perror(descr);
+		return 1;
+	}
+
+	report_sick(descr, inode_flags, bs.bs_sick, bs.bs_checked);
+	return 0;
+}
+
+/* Report on a file's health. */
+static int
+report_file_health(
+	const char	*path)
+{
+	struct stat	stata, statb;
+	int		ret;
+
+	ret = lstat(path, &statb);
+	if (ret) {
+		perror(path);
+		return 1;
+	}
+
+	ret = fstat(file->xfd.fd, &stata);
+	if (ret) {
+		perror(file->name);
+		return 1;
+	}
+
+	if (stata.st_dev != statb.st_dev) {
+		fprintf(stderr, _("%s: not on the open filesystem"), path);
+		return 1;
+	}
+
+	return report_inode_health(statb.st_ino, path);
+}
+
+/*
+ * Report on all files' health for a given @agno.  If @agno is NULLAGNUMBER,
+ * report on all files in the filesystem.
+ */
+static int
+report_bulkstat_health(
+	xfs_agnumber_t		agno)
+{
+	struct xfs_bstat	bstat[128];
+	char			descr[256];
+	uint64_t		startino = 0;
+	uint64_t		lastino = -1ULL;
+	uint32_t		ocount;
+	uint32_t		i;
+	int			error;
+
+	if (agno != NULLAGNUMBER) {
+		startino = xfrog_agino_to_ino(&file->xfd, agno, 0);
+		lastino = xfrog_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
+	}
+
+	while ((error = xfrog_bulkstat(&file->xfd, &startino, 128, bstat,
+			&ocount) == 0) && ocount > 0) {
+		for (i = 0; i < ocount; i++) {
+			if (bstat[i].bs_ino > lastino)
+				goto out;
+			snprintf(descr, sizeof(descr) - 1, _("inode %llu"),
+					bstat[i].bs_ino);
+			report_sick(descr, inode_flags, bstat[i].bs_sick,
+					bstat[i].bs_checked);
+		}
+	}
+out:
+	return error;
+}
+
+/* Report on health problems in XFS filesystem. */
+static int
+health_f(
+	int			argc,
+	char			**argv)
+{
+	unsigned long long	x;
+	xfs_agnumber_t		agno;
+	bool			default_report = true;
+	int			c;
+	int			ret;
+
+	reported = 0;
+
+	if (file->xfd.fsgeom.version != XFS_FSOP_GEOM_VERSION_V5) {
+		perror("health");
+		return 1;
+	}
+
+	while ((c = getopt(argc, argv, "a:cfi:q")) != EOF) {
+		switch (c) {
+		case 'a':
+			default_report = false;
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (!errno && x >= NULLAGNUMBER)
+				errno = ERANGE;
+			if (errno) {
+				perror("ag health");
+				return 1;
+			}
+			agno = x;
+			ret = report_ag_sick(agno);
+			if (!ret && comprehensive)
+				ret = report_bulkstat_health(agno);
+			if (ret)
+				return 1;
+			break;
+		case 'c':
+			comprehensive = true;
+			break;
+		case 'f':
+			default_report = false;
+			report_sick(_("filesystem"), fs_flags,
+					file->xfd.fsgeom.sick,
+					file->xfd.fsgeom.checked);
+			if (comprehensive) {
+				ret = report_bulkstat_health(NULLAGNUMBER);
+				if (ret)
+					return 1;
+			}
+			break;
+		case 'i':
+			default_report = false;
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (errno) {
+				perror("inode health");
+				return 1;
+			}
+			ret = report_inode_health(x, NULL);
+			if (ret)
+				return 1;
+			break;
+		case 'q':
+			quiet = true;
+			break;
+		default:
+			return command_usage(&health_cmd);
+		}
+	}
+
+	for (c = optind; c < argc; c++) {
+		default_report = false;
+		ret = report_file_health(argv[c]);
+		if (ret)
+			return 1;
+	}
+
+	/* No arguments gets us a summary of fs state. */
+	if (default_report) {
+		report_sick(_("filesystem"), fs_flags, file->xfd.fsgeom.sick,
+				file->xfd.fsgeom.checked);
+
+		for (agno = 0; agno < file->xfd.fsgeom.agcount; agno++) {
+			ret = report_ag_sick(agno);
+			if (ret)
+				return 1;
+		}
+		if (comprehensive) {
+			ret = report_bulkstat_health(NULLAGNUMBER);
+			if (ret)
+				return 1;
+		}
+	}
+
+	if (!reported) {
+		fprintf(stderr,
+_("Health status has not been collected for this filesystem.\n"));
+		fprintf(stderr,
+_("Please run xfs_scrub(8) to remedy this situation.\n"));
+	}
+
+	return 0;
+}
+
+static void
+health_help(void)
+{
+	printf(_(
+"\n"
+"Report all observed filesystem health problems.\n"
+"\n"
+" -a agno  -- Report health of the given allocation group.\n"
+" -c       -- Report on the health of all inodes.\n"
+" -f       -- Report health of the overall filesystem.\n"
+" -i inum  -- Report health of a given inode number.\n"
+" -q       -- Only report unhealthy metadata.\n"
+" paths    -- Report health of the given file path.\n"
+"\n"));
+
+}
+
+static cmdinfo_t health_cmd = {
+	.name = "health",
+	.cfunc = health_f,
+	.argmin = 0,
+	.argmax = -1,
+	.args = "[-a agno] [-c] [-f] [-i inum] [-q] [paths]",
+	.flags = CMD_FLAG_ONESHOT,
+	.help = health_help,
+};
+
+void
+health_init(void)
+{
+	health_cmd.oneline = _("Report observed XFS health problems."),
+	add_command(&health_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index 2698f420..80740cda 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -34,6 +34,7 @@ init_commands(void)
 	quit_init();
 	trim_init();
 	freesp_init();
+	health_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 2c26884a..723209ed 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -32,5 +32,6 @@ extern void	freesp_init(void);
 # define freesp_init()	do { } while (0)
 #endif
 extern void	info_init(void);
+extern void	health_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

