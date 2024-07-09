Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0951B86D8
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552235; cv=none; b=YGgZ/FnELbZZgNfb90gdt2K9GdSVKrUWB+tsO8gPFFhabuzEPvlO4bc5p0q3angne6hGwxqyc6pVtKz3MLCHEMJ+0fmys4cuHj/DNnpT4hib7yJkWcjFacXzzOGzA72UeC3a7I1kOXm+iS2bTjHtVI7g9Otbp2XzpCKDa7TYqW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552235; c=relaxed/simple;
	bh=ZikabLqcFbRtymuaN3PyrgFK+xj2E1Y9pQkxR/G8TzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/Qv/sN+c0CP6HDgP+3Ugu6nvSd6YpLQ5tPqRk5RVIj31zFfUGoPH1/j2qRvi4rGO1oR7XfnRr3dzCOFbUCRQ8uZU1RWMc9wHKkgeFLjw3yYZKayYuvO9F1OSk0rW1HQZF4nvTztLsqRrsr+Mtpu8v/cmf0OOHjDNZ+tkuP1Olw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nFn1wgTI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nFn1wgTI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtWpB007633
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=/RJMgwyfGqz0D8cSjgOsZlxLZ2gWOl2wNhAs0GAuhoA=; b=
	nFn1wgTIej3h+Kd2RaOCzfzvq6oZV1vc289rT0VpreYIfmuHBGKPmou/SSlPtT51
	AMlsED/C1nM2LtAEskNkxzE3f1EqP2qc+4Ykwr/TPeUjgCFvyIgdR0NZi42dGgEk
	R38K3hruXAsoXmCLf8PRKtGnTdKwj0/xDZYCC975ej9imBb7QxDMdEPnLyZI/aJB
	r4UxTkIqBWFgkhiEVVrWKWYvn9Pj6m0oHWV8re3pQ6ADLe05x0vaDLNOyeU7h45z
	zYeylauycubbgwoPU9yp5Ig8K80GWOU9/8e4BhRrdUgQb//FVGJ3hi0lQB/dV+bs
	B+E4PBVljk+3u0rnuoLu5w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgpwsrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469J3SKO013658
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPQ024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:30 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-2;
	Tue, 09 Jul 2024 19:10:30 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 1/9] xfsprogs: introduce defrag command to spaceman
Date: Tue,  9 Jul 2024 12:10:20 -0700
Message-Id: <20240709191028.2329-2-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240709191028.2329-1-wen.gang.wang@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_08,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=937 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407090129
X-Proofpoint-ORIG-GUID: ftOoV3lJDWNt_4lnYWjgjRdPh5Nh1Lev
X-Proofpoint-GUID: ftOoV3lJDWNt_4lnYWjgjRdPh5Nh1Lev

Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Non-exclusive defragment
Here we are introducing the non-exclusive manner to defragment a file,
especially for huge files, without blocking IO to it long.
Non-exclusive defragmentation divides the whole file into small segments.
For each segment, we lock the file, defragment the segment and unlock the file.
Defragmenting the small segment doesn’t take long. File IO requests can get
served between defragmenting segments before blocked long.  Also we put
(user adjustable) idle time between defragmenting two consecutive segments to
balance the defragmentation and file IOs.

The first patch in the set checks for valid target files

Valid target files to defrag must:
1. be accessible for read/write
2. be regular files
3. be in XFS filesystem
4. the containing XFS has reflink enabled. This is not checked
   before starting defragmentation, but error would be reported
   later.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 spaceman/Makefile |   2 +-
 spaceman/defrag.c | 198 ++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c   |   1 +
 spaceman/space.h  |   1 +
 4 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/defrag.c

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 1f048d54..9c00b20a 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = info.c init.c file.c health.c prealloc.c trim.c
+CFILES = info.c init.c file.c health.c prealloc.c trim.c defrag.c
 LSRCFILES = xfs_info.sh
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/spaceman/defrag.c b/spaceman/defrag.c
new file mode 100644
index 00000000..c9732984
--- /dev/null
+++ b/spaceman/defrag.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include <linux/fsmap.h>
+#include "libfrog/fsgeom.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "space.h"
+#include "input.h"
+
+/* defrag segment size limit in units of 512 bytes */
+#define MIN_SEGMENT_SIZE_LIMIT 8192 /* 4MiB */
+#define DEFAULT_SEGMENT_SIZE_LIMIT 32768 /* 16MiB */
+static int g_segment_size_lmt = DEFAULT_SEGMENT_SIZE_LIMIT;
+
+/* size of the defrag target file */
+static off_t g_defrag_file_size = 0;
+
+/* stats for the target file extents before defrag */
+struct ext_stats {
+	long	nr_ext_total;
+	long	nr_ext_unwritten;
+	long	nr_ext_shared;
+};
+static struct ext_stats	g_ext_stats;
+
+/*
+ * check if the target is a valid file to defrag
+ * also store file size
+ * returns:
+ * true for yes and false for no
+ */
+static bool
+defrag_check_file(char *path)
+{
+	struct statfs statfs_s;
+	struct stat stat_s;
+
+	if (access(path, F_OK|W_OK) == -1) {
+		if (errno == ENOENT)
+			fprintf(stderr, "file \"%s\" doesn't exist\n", path);
+		else
+			fprintf(stderr, "no access to \"%s\", %s\n", path,
+				strerror(errno));
+		return false;
+	}
+
+	if (stat(path, &stat_s) == -1) {
+		fprintf(stderr, "failed to get file info on \"%s\":  %s\n",
+			path, strerror(errno));
+		return false;
+	}
+
+	g_defrag_file_size = stat_s.st_size;
+
+	if (!S_ISREG(stat_s.st_mode)) {
+		fprintf(stderr, "\"%s\" is not a regular file\n", path);
+		return false;
+	}
+
+	if (statfs(path, &statfs_s) == -1) {
+		fprintf(stderr, "failed to get FS info on \"%s\":  %s\n",
+			path, strerror(errno));
+		return false;
+	}
+
+	if (statfs_s.f_type != XFS_SUPER_MAGIC) {
+		fprintf(stderr, "\"%s\" is not a xfs file\n", path);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * defragment a file
+ * return 0 if successfully done, 1 otherwise
+ */
+static int
+defrag_xfs_defrag(char *file_path) {
+	int	max_clone_us = 0, max_unshare_us = 0, max_punch_us = 0;
+	long	nr_seg_defrag = 0, nr_ext_defrag = 0;
+	int	scratch_fd = -1, defrag_fd = -1;
+	char	tmp_file_path[PATH_MAX+1];
+	char	*defrag_dir;
+	struct fsxattr	fsx;
+	int	ret = 0;
+
+	fsx.fsx_nextents = 0;
+	memset(&g_ext_stats, 0, sizeof(g_ext_stats));
+
+	if (!defrag_check_file(file_path)) {
+		ret = 1;
+		goto out;
+	}
+
+	defrag_fd = open(file_path, O_RDWR);
+	if (defrag_fd == -1) {
+		fprintf(stderr, "Opening %s failed. %s\n", file_path,
+			strerror(errno));
+		ret = 1;
+		goto out;
+	}
+
+	defrag_dir = dirname(file_path);
+	snprintf(tmp_file_path, PATH_MAX, "%s/.xfsdefrag_%d", defrag_dir,
+		getpid());
+	tmp_file_path[PATH_MAX] = 0;
+	scratch_fd = open(tmp_file_path, O_CREAT|O_EXCL|O_RDWR, 0600);
+	if (scratch_fd == -1) {
+		fprintf(stderr, "Opening temporary file %s failed. %s\n",
+			tmp_file_path, strerror(errno));
+		ret = 1;
+		goto out;
+	}
+out:
+	if (scratch_fd != -1) {
+		close(scratch_fd);
+		unlink(tmp_file_path);
+	}
+	if (defrag_fd != -1) {
+		ioctl(defrag_fd, FS_IOC_FSGETXATTR, &fsx);
+		close(defrag_fd);
+	}
+
+	printf("Pre-defrag %ld extents detected, %ld are \"unwritten\","
+		"%ld are \"shared\"\n",
+		g_ext_stats.nr_ext_total, g_ext_stats.nr_ext_unwritten,
+		g_ext_stats.nr_ext_shared);
+	printf("Tried to defragment %ld extents in %ld segments\n",
+		nr_ext_defrag, nr_seg_defrag);
+	printf("Time stats(ms): max clone: %d, max unshare: %d,"
+	       " max punch_hole: %d\n",
+	       max_clone_us/1000, max_unshare_us/1000, max_punch_us/1000);
+	printf("Post-defrag %u extents detected\n", fsx.fsx_nextents);
+	return ret;
+}
+
+
+static void defrag_help(void)
+{
+	printf(_(
+"\n"
+"Defragemnt files on XFS where reflink is enabled. IOs to the target files \n"
+"can be served durning the defragmentations.\n"
+"\n"
+" -s segment_size    -- specify the segment size in MiB, minmum value is 4 \n"
+"                       default is 16\n"));
+}
+
+static cmdinfo_t defrag_cmd;
+
+static int
+defrag_f(int argc, char **argv)
+{
+	int	i;
+	int	c;
+
+	while ((c = getopt(argc, argv, "s:")) != EOF) {
+		switch(c) {
+		case 's':
+			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
+			if (g_segment_size_lmt < MIN_SEGMENT_SIZE_LIMIT) {
+				g_segment_size_lmt = MIN_SEGMENT_SIZE_LIMIT;
+				printf("Using minimium segment size %d\n",
+					g_segment_size_lmt);
+			}
+			break;
+		default:
+			command_usage(&defrag_cmd);
+			return 1;
+		}
+	}
+
+	for (i = 0; i < filecount; i++)
+		defrag_xfs_defrag(filetable[i].name);
+	return 0;
+}
+void defrag_init(void)
+{
+	defrag_cmd.name		= "defrag";
+	defrag_cmd.altname	= "dfg";
+	defrag_cmd.cfunc	= defrag_f;
+	defrag_cmd.argmin	= 0;
+	defrag_cmd.argmax	= 4;
+	defrag_cmd.args		= "[-s segment_size]";
+	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
+	defrag_cmd.oneline	= _("Defragment XFS files");
+	defrag_cmd.help		= defrag_help;
+
+	add_command(&defrag_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cb..396f965c 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -35,6 +35,7 @@ init_commands(void)
 	trim_init();
 	freesp_init();
 	health_init();
+	defrag_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209ed..c288aeb9 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -26,6 +26,7 @@ extern void	help_init(void);
 extern void	prealloc_init(void);
 extern void	quit_init(void);
 extern void	trim_init(void);
+extern void	defrag_init(void);
 #ifdef HAVE_GETFSMAP
 extern void	freesp_init(void);
 #else
-- 
2.39.3 (Apple Git-146)

