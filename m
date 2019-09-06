Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F53C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0C6D206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lpeBQW1D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392130AbfIFDdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:33:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392118AbfIFDdW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:33:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863TXe3106553;
        Fri, 6 Sep 2019 03:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=D1gxZq5c/IK59+XX845gaLxJcFshr3mNitT/XkhxneQ=;
 b=lpeBQW1DuCvlT9r89EYRgcdtHpgZ+EwzPxPaDM2JHL3yC3b04AsdXU+u23Jyb0vAd2ZZ
 QZZLSGNGFvCIkLgnM5c3/KMAbcQod5L7k4Pib567y8M4+N/QSyLau36P1ANgY3yH0r9G
 /TclseydemXNndNWLFpwaLUhi6z7mJFSuQvGmnz+RryR/6A7rZsWSzzb1ZB1WpEJMdfl
 I8Y+//FExiEYJgnhOnMho2Fs9zud8LpwH2P3QZDwM9A/FImwJBwMLpM8yP99kZ8ByeR2
 uSeEbf1b5UHwFC9JcMRuURi0iqGCyccMJOWYEC1y1f3WZP0Tz2FdTKSuAW65ba7B15/I Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uuf4n032p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863NtdD173304;
        Fri, 6 Sep 2019 03:33:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmc73e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:33:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863XIKv013718;
        Fri, 6 Sep 2019 03:33:19 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:33:18 -0700
Subject: [PATCH 1/1] xfs_spaceman: report health problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:33:17 -0700
Message-ID: <156774079788.2643029.845208737705520807.stgit@magnolia>
In-Reply-To: <156774079152.2643029.531526071920135871.stgit@magnolia>
References: <156774079152.2643029.531526071920135871.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060037
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

Use the fs and ag geometry ioctls to report health problems to users.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c        |   16 ++
 libfrog/fsgeom.h        |    1 
 man/man8/xfs_spaceman.8 |   28 +++
 spaceman/Makefile       |    2 
 spaceman/health.c       |  459 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |    1 
 spaceman/space.h        |    1 
 7 files changed, 507 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/health.c


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 631286cd..3ea91e3f 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -159,3 +159,19 @@ xfd_close(
 
 	return 0;
 }
+
+/* Try to obtain an AG's geometry.  Returns zero or a positive error code. */
+int
+xfrog_ag_geometry(
+	int			fd,
+	unsigned int		agno,
+	struct xfs_ag_geometry	*ageo)
+{
+	int			ret;
+
+	ageo->ag_number = agno;
+	ret = ioctl(fd, XFS_IOC_AG_GEOMETRY, ageo);
+	if (ret)
+		return errno;
+	return 0;
+}
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 5dcfc1bb..55b14c2b 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -8,6 +8,7 @@
 void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
 		const char *logname, const char *rtname);
 int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
+int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
 
 /*
  * Structure for recording whatever observations we want about the level of
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
index 00000000..c3575b8e
--- /dev/null
+++ b/spaceman/health.c
@@ -0,0 +1,459 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2019 Oracle.
+ * All Rights Reserved.
+ */
+#include "platform_defs.h"
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "input.h"
+#include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/bulkstat.h"
+#include "space.h"
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
+	struct xfs_ag_geometry	ageo = { 0 };
+	char			descr[256];
+	int			ret;
+
+	ret = xfrog_ag_geometry(file->xfd.fd, agno, &ageo);
+	if (ret) {
+		errno = ret;
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
+		errno = ret;
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
+#define BULKSTAT_NR		(128)
+
+/*
+ * Report on all files' health for a given @agno.  If @agno is NULLAGNUMBER,
+ * report on all files in the filesystem.
+ */
+static int
+report_bulkstat_health(
+	xfs_agnumber_t		agno)
+{
+	struct xfs_bstat	bstat[BULKSTAT_NR];
+	char			descr[256];
+	uint64_t		startino = 0;
+	uint64_t		lastino = -1ULL;
+	uint32_t		ocount;
+	uint32_t		i;
+	int			error;
+
+	if (agno != NULLAGNUMBER) {
+		startino = cvt_agino_to_ino(&file->xfd, agno, 0);
+		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
+	}
+
+	while ((error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
+			bstat, &ocount) == 0) && ocount > 0) {
+		for (i = 0; i < ocount; i++) {
+			if (bstat[i].bs_ino > lastino)
+				goto out;
+			snprintf(descr, sizeof(descr) - 1, _("inode %llu"),
+					bstat[i].bs_ino);
+			report_sick(descr, inode_flags, bstat[i].bs_sick,
+					bstat[i].bs_checked);
+		}
+	}
+	if (error) {
+		errno = error;
+		perror("bulkstat");
+	}
+out:
+	return error;
+}
+
+#define OPT_STRING ("a:cfi:q")
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
+	/* Set our reporting options appropriately in the first pass. */
+	while ((c = getopt(argc, argv, OPT_STRING)) != EOF) {
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
+			break;
+		case 'c':
+			comprehensive = true;
+			break;
+		case 'f':
+			default_report = false;
+			break;
+		case 'i':
+			default_report = false;
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (errno) {
+				perror("inode health");
+				return 1;
+			}
+			break;
+		case 'q':
+			quiet = true;
+			break;
+		default:
+			return command_usage(&health_cmd);
+		}
+	}
+	if (optind < argc)
+		default_report = false;
+
+	/* Reparse arguments, this time for reporting actions. */
+	optind = 1;
+	while ((c = getopt(argc, argv, OPT_STRING)) != EOF) {
+		switch (c) {
+		case 'a':
+			agno = strtoll(optarg, NULL, 10);
+			ret = report_ag_sick(agno);
+			if (!ret && comprehensive)
+				ret = report_bulkstat_health(agno);
+			if (ret)
+				return 1;
+			break;
+		case 'f':
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
+			x = strtoll(optarg, NULL, 10);
+			ret = report_inode_health(x, NULL);
+			if (ret)
+				return 1;
+			break;
+		default:
+			break;
+		}
+	}
+
+	for (c = optind; c < argc; c++) {
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
index 4afdb386..cf1ff3cb 100644
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

