Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C42C47E49
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D131E218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/il2Jar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbfJVSws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56040 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJVSws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiCn9091007;
        Tue, 22 Oct 2019 18:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pgRdKnyvhFttRPmfbxy+/jtm7iVjTDOCQGHfOShFJ60=;
 b=E/il2JarfBgDoohgDBblH4iwX+6mdgEj0moMeKB4tzULclyNNY8/RNpkfmWkD+AcEO3z
 PKy/8K9MG4kc+3oRWiywVtuW+L3R1sMg+1b5LqID89gdN9Bi/+kih1Mc4DjdsRw9u55g
 UnyF3Kd/F378tBQ2p8g7XUz7tC93Dk70/P6CIr7e/booO3LzTavlmQtzZY7URJzTrFRs
 Nm4vOP9feydUUQ6vZSkZg8PKojhbM5XaaEsxFIrlbJo1LiFQjtYFoW/BXMobIdFJWJxe
 GB4AgFjZBqUhPeWpu7PbzMQhzW0+54Ut55cP27+l+p9AEvWZARrq0mG4hIwdWFWWq4hb gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteprrus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiN9V070489;
        Tue, 22 Oct 2019 18:52:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2rkvxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIqXJ5028679;
        Tue, 22 Oct 2019 18:52:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:33 -0700
Subject: [PATCH 1/7] libfrog: print library errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:52:32 -0700
Message-ID: <157177035218.1462916.18216041986075713954.stgit@magnolia>
In-Reply-To: <157177034582.1462916.12588287391821422188.stgit@magnolia>
References: <157177034582.1462916.12588287391821422188.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a libfrog library function that will print tagged error messages.
This will eliminate the need for a lot of open-coded:

errno = ret;
perror("...");

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/bulkstat.c     |   19 +++++++------------
 io/imap.c         |    4 ++--
 io/open.c         |   13 +++++--------
 io/stat.c         |    4 ++--
 io/swapext.c      |    7 +++----
 libfrog/Makefile  |    2 ++
 libfrog/logging.c |   18 ++++++++++++++++++
 libfrog/logging.h |   11 +++++++++++
 quota/free.c      |    4 ++--
 quota/quot.c      |   10 ++++------
 spaceman/file.c   |    7 +++----
 spaceman/health.c |   13 +++++--------
 12 files changed, 64 insertions(+), 48 deletions(-)
 create mode 100644 libfrog/logging.c
 create mode 100644 libfrog/logging.h


diff --git a/io/bulkstat.c b/io/bulkstat.c
index ab84468a..9641370b 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -7,6 +7,7 @@
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 #include "libfrog/paths.h"
@@ -164,8 +165,7 @@ bulkstat_f(
 
 	ret = xfd_prepare_geometry(&xfd);
 	if (ret) {
-		errno = ret;
-		perror("xfd_prepare_geometry");
+		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
 		return 0;
 	}
@@ -202,8 +202,7 @@ _("bulkstat: startino=%lld flags=0x%x agno=%u ret=%d icount=%u ocount=%u\n"),
 		}
 	}
 	if (ret) {
-		errno = ret;
-		perror("xfrog_bulkstat");
+		xfrog_perror(ret, "xfrog_bulkstat");
 		exitcode = 1;
 	}
 
@@ -274,8 +273,7 @@ bulkstat_single_f(
 
 	ret = xfd_prepare_geometry(&xfd);
 	if (ret) {
-		errno = ret;
-		perror("xfd_prepare_geometry");
+		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
 		return 0;
 	}
@@ -309,8 +307,7 @@ bulkstat_single_f(
 
 		ret = xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
 		if (ret) {
-			errno = ret;
-			perror("xfrog_bulkstat_single");
+			xfrog_perror(ret, "xfrog_bulkstat_single");
 			continue;
 		}
 
@@ -424,8 +421,7 @@ inumbers_f(
 
 	ret = xfd_prepare_geometry(&xfd);
 	if (ret) {
-		errno = ret;
-		perror("xfd_prepare_geometry");
+		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
 		return 0;
 	}
@@ -462,8 +458,7 @@ _("bulkstat: startino=%"PRIu64" flags=0x%"PRIx32" agno=%"PRIu32" ret=%d icount=%
 		}
 	}
 	if (ret) {
-		errno = ret;
-		perror("xfrog_inumbers");
+		xfrog_perror(ret, "xfrog_inumbers");
 		exitcode = 1;
 	}
 
diff --git a/io/imap.c b/io/imap.c
index fa69676e..6b338640 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
@@ -44,8 +45,7 @@ imap_f(int argc, char **argv)
 	}
 
 	if (error) {
-		errno = error;
-		perror("xfsctl(XFS_IOC_FSINUMBERS)");
+		xfrog_perror(error, "xfsctl(XFS_IOC_FSINUMBERS)");
 		exitcode = 1;
 	}
 	free(ireq);
diff --git a/io/open.c b/io/open.c
index fa9ca01a..a5192e87 100644
--- a/io/open.c
+++ b/io/open.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "io.h"
 #include "libxfs.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
@@ -125,8 +126,7 @@ openfile(
 
 		ret = xfrog_geometry(fd, geom);
 		if (ret) {
-			errno = ret;
-			perror("XFS_IOC_FSGEOMETRY");
+			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 			close(fd);
 			return -1;
 		}
@@ -696,8 +696,7 @@ get_last_inode(void)
 
 		ret = xfrog_inumbers(&xfd, ireq);
 		if (ret) {
-			errno = ret;
-			perror("XFS_IOC_FSINUMBERS");
+			xfrog_perror(ret, "XFS_IOC_FSINUMBERS");
 			goto out;
 		}
 
@@ -795,8 +794,7 @@ inode_f(
 		/* get next inode */
 		ret = xfrog_bulkstat(&xfd, breq);
 		if (ret) {
-			errno = ret;
-			perror("bulkstat");
+			xfrog_perror(ret, "bulkstat");
 			free(breq);
 			exitcode = 1;
 			return 0;
@@ -817,8 +815,7 @@ inode_f(
 			/* Not in use */
 			result_ino = 0;
 		} else if (ret) {
-			errno = ret;
-			perror("bulkstat_single");
+			xfrog_perror(ret, "bulkstat_single");
 			exitcode = 1;
 			return 0;
 		} else {
diff --git a/io/stat.c b/io/stat.c
index 6c666146..db335780 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -12,6 +12,7 @@
 #include "io.h"
 #include "statx.h"
 #include "libxfs.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 
 #include <fcntl.h>
@@ -198,8 +199,7 @@ statfs_f(
 		return 0;
 	ret = xfrog_geometry(file->fd, &fsgeo);
 	if (ret) {
-		errno = ret;
-		perror("XFS_IOC_FSGEOMETRY");
+		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
diff --git a/io/swapext.c b/io/swapext.c
index 1139cf21..dc4e418f 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
@@ -51,14 +52,12 @@ swapext_f(
 
 	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
 	if (error) {
-		errno = error;
-		perror("bulkstat");
+		xfrog_perror(error, "bulkstat");
 		goto out;
 	}
 	error = xfrog_bulkstat_v5_to_v1(&fxfd, &sx.sx_stat, &bulkstat);
 	if (error) {
-		errno = error;
-		perror("bulkstat conversion");
+		xfrog_perror(error, "bulkstat conversion");
 		goto out;
 	}
 	sx.sx_version = XFS_SX_VERSION;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index de67bf00..780600cd 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -19,6 +19,7 @@ crc32.c \
 fsgeom.c \
 list_sort.c \
 linux.c \
+logging.c \
 paths.c \
 projects.c \
 ptvar.c \
@@ -38,6 +39,7 @@ crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
 fsgeom.h \
+logging.h \
 paths.h \
 projects.h \
 ptvar.h \
diff --git a/libfrog/logging.c b/libfrog/logging.c
new file mode 100644
index 00000000..91ea4537
--- /dev/null
+++ b/libfrog/logging.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <errno.h>
+#include <stdio.h>
+#include "logging.h"
+
+/* Print an error. */
+void
+xfrog_perror(
+	int		error,
+	const char	*s)
+{
+	errno = error < 0 ? -error : error;
+	perror(s);
+}
diff --git a/libfrog/logging.h b/libfrog/logging.h
new file mode 100644
index 00000000..8b125bfd
--- /dev/null
+++ b/libfrog/logging.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2019 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_LOGGING_H__
+#define __LIBFROG_LOGGING_H__
+
+void xfrog_perror(int error, const char *s);
+
+#endif	/* __LIBFROG_LOGGING_H__ */
diff --git a/quota/free.c b/quota/free.c
index 73aeb459..45ce2ceb 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -8,6 +8,7 @@
 #include "command.h"
 #include "init.h"
 #include "quota.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 
 static cmdinfo_t free_cmd;
@@ -70,8 +71,7 @@ mount_free_space_data(
 	if (!(mount->fs_flags & FS_FOREIGN)) {
 		ret = xfrog_geometry(fd, &fsgeo);
 		if (ret) {
-			errno = ret;
-			perror("XFS_IOC_FSGEOMETRY");
+			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 			close(fd);
 			return 0;
 		}
diff --git a/quota/quot.c b/quota/quot.c
index 7edfad16..0f69fabd 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -11,6 +11,7 @@
 #include <grp.h>
 #include "init.h"
 #include "quota.h"
+#include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 
@@ -147,8 +148,7 @@ quot_bulkstat_mount(
 
 	ret = xfd_open(&fsxfd, fsdir, O_RDONLY);
 	if (ret) {
-		errno = ret;
-		perror(fsdir);
+		xfrog_perror(ret, fsdir);
 		return;
 	}
 
@@ -165,10 +165,8 @@ quot_bulkstat_mount(
 		for (i = 0; i < breq->hdr.ocount; i++)
 			quot_bulkstat_add(&breq->bulkstat[i], flags);
 	}
-	if (sts < 0) {
-		errno = sts;
-		perror("XFS_IOC_FSBULKSTAT");
-	}
+	if (sts < 0)
+		xfrog_perror(sts, "XFS_IOC_FSBULKSTAT");
 	free(breq);
 	xfd_close(&fsxfd);
 }
diff --git a/spaceman/file.c b/spaceman/file.c
index 43b87e14..b7794328 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -10,6 +10,7 @@
 #include "command.h"
 #include "input.h"
 #include "init.h"
+#include "libfrog/logging.h"
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "space.h"
@@ -57,10 +58,8 @@ openfile(
 			fprintf(stderr,
 _("%s: Not on a mounted XFS filesystem.\n"),
 					path);
-		else {
-			errno = ret;
-			perror(path);
-		}
+		else
+			xfrog_perror(ret, path);
 		return -1;
 	}
 
diff --git a/spaceman/health.c b/spaceman/health.c
index 0d3aa243..a0079bd7 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -8,6 +8,7 @@
 #include "command.h"
 #include "init.h"
 #include "input.h"
+#include "libfrog/logging.h"
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
@@ -193,8 +194,7 @@ report_ag_sick(
 
 	ret = xfrog_ag_geometry(file->xfd.fd, agno, &ageo);
 	if (ret) {
-		errno = ret;
-		perror("ag_geometry");
+		xfrog_perror(ret, "ag_geometry");
 		return 1;
 	}
 	snprintf(descr, sizeof(descr) - 1, _("AG %u"), agno);
@@ -219,8 +219,7 @@ report_inode_health(
 
 	ret = xfrog_bulkstat_single(&file->xfd, ino, 0, &bs);
 	if (ret) {
-		errno = ret;
-		perror(descr);
+		xfrog_perror(ret, descr);
 		return 1;
 	}
 
@@ -294,10 +293,8 @@ report_bulkstat_health(
 		}
 	} while (breq->hdr.ocount > 0);
 
-	if (error) {
-		errno = error;
-		perror("bulkstat");
-	}
+	if (error)
+		xfrog_perror(error, "bulkstat");
 
 	free(breq);
 	return error;

