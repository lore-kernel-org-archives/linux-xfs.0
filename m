Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59BCC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9203421848
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hbr3V0VD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHZV2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfHZV2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmf1000868;
        Mon, 26 Aug 2019 21:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=lXl/EZt+NlB4kvOJl5Wv/QVDLh5QNXE/AArW5ColAIM=;
 b=hbr3V0VDYpLg3zEfbYllWBjNrSdTyuHwvQs21UQkPX2sk9vMFXzbbVSr3mRsMRwjtUHX
 kKgLpcCymFDL5ao+j8yEK3KpPP0Iv3cCqEHUbhbMqqdIdVTCXak3g1Gpux49InxEIBHD
 i3RF/oHnGgNrzgWPXCRtnUkf/75tJi48Sf8IjKG2F6N2zrk+bZ+GeHyYQW7L4obWJ0uD
 xmoeRYTzI05GpKfViMP5srgCwColkYewKw59eS24Ik+RAkKmoD3h1pQ/BaGzmziVCh66
 vnmWMlPKPYmHK+c/iOsPEfkjKk1zPOXAc499iDE9WQx3I1Q2+q30C1bHCBBN+/hAoXF4 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx0556-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:27:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIRKR025044;
        Mon, 26 Aug 2019 21:27:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tk3yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:27:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLRvdf005357;
        Mon, 26 Aug 2019 21:27:57 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:27:55 -0700
Subject: [PATCH 1/4] xfs_io: add a bulkstat command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:27:54 -0700
Message-ID: <156685487465.2841421.358121830253489458.stgit@magnolia>
In-Reply-To: <156685486843.2841421.7117771040713668517.stgit@magnolia>
References: <156685486843.2841421.7117771040713668517.stgit@magnolia>
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

Add a bulkstat command to xfs_io so that we can test our new xfrog code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |    3 
 io/Makefile        |    9 -
 io/bulkstat.c      |  525 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c          |    1 
 io/io.h            |    1 
 libfrog/bulkstat.c |   20 ++
 man/man8/xfs_io.8  |   68 +++++++
 7 files changed, 623 insertions(+), 4 deletions(-)
 create mode 100644 io/bulkstat.c


diff --git a/include/xfrog.h b/include/xfrog.h
index 0dcee510..df7cfdf6 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -188,11 +188,14 @@ void xfrog_bulkstat_to_bstat(struct xfs_fd *xfd, struct xfs_bstat *bs1,
 void xfrog_bstat_to_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
 		const struct xfs_bstat *bs1);
 
+void xfrog_bulkstat_set_ag(struct xfs_bulkstat_req *req, uint32_t agno);
+
 struct xfs_inogrp;
 int xfrog_inumbers(struct xfs_fd *xfd, struct xfs_inumbers_req *req);
 
 struct xfs_inumbers_req *xfrog_inumbers_alloc_req(uint32_t nr,
 		uint64_t startino);
+void xfrog_inumbers_set_ag(struct xfs_inumbers_req *req, uint32_t agno);
 void xfrog_inumbers_to_inogrp(struct xfs_inogrp *ig1,
 		const struct xfs_inumbers *ig);
 void xfrog_inogrp_to_inumbers(struct xfs_inumbers *ig,
diff --git a/io/Makefile b/io/Makefile
index 484e2b5a..1112605e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -9,10 +9,11 @@ LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
-	attr.c bmap.c crc32cselftest.c cowextsize.c encrypt.c file.c freeze.c \
-	fsync.c getrusage.c imap.c inject.c label.c link.c mmap.c open.c \
-	parent.c pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c \
-	seek.c shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
+	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
+	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
+	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
+	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
+	truncate.c utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/bulkstat.c b/io/bulkstat.c
new file mode 100644
index 00000000..7944a0fa
--- /dev/null
+++ b/io/bulkstat.c
@@ -0,0 +1,525 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "path.h"
+#include "io.h"
+#include "input.h"
+#include "xfrog.h"
+
+static bool debug;
+
+static void
+dump_bulkstat_time(
+	const char		*tag,
+	uint64_t		sec,
+	uint32_t		nsec)
+{
+	printf("\t%s = %"PRIu64".%"PRIu32"\n", tag, sec, nsec);
+}
+
+static void
+dump_bulkstat(
+	struct xfs_bulkstat	*bstat)
+{
+	printf("bs_ino = %"PRIu64"\n", bstat->bs_ino);
+	printf("\tbs_size = %"PRIu64"\n", bstat->bs_size);
+
+	printf("\tbs_blocks = %"PRIu64"\n", bstat->bs_blocks);
+	printf("\tbs_xflags = 0x%"PRIx64"\n", bstat->bs_xflags);
+
+	dump_bulkstat_time("bs_atime", bstat->bs_atime, bstat->bs_atime_nsec);
+	dump_bulkstat_time("bs_ctime", bstat->bs_ctime, bstat->bs_ctime_nsec);
+	dump_bulkstat_time("bs_mtime", bstat->bs_mtime, bstat->bs_mtime_nsec);
+	dump_bulkstat_time("bs_btime", bstat->bs_btime, bstat->bs_btime_nsec);
+
+	printf("\tbs_gen = 0x%"PRIx32"\n", bstat->bs_gen);
+	printf("\tbs_uid = %"PRIu32"\n", bstat->bs_uid);
+	printf("\tbs_gid = %"PRIu32"\n", bstat->bs_gid);
+	printf("\tbs_projectid = %"PRIu32"\n", bstat->bs_projectid);
+
+	printf("\tbs_blksize = %"PRIu32"\n", bstat->bs_blksize);
+	printf("\tbs_rdev = %"PRIu32"\n", bstat->bs_rdev);
+	printf("\tbs_cowextsize_blks = %"PRIu32"\n", bstat->bs_cowextsize_blks);
+	printf("\tbs_extsize_blks = %"PRIu32"\n", bstat->bs_extsize_blks);
+
+	printf("\tbs_nlink = %"PRIu32"\n", bstat->bs_nlink);
+	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents);
+	printf("\tbs_aextents = %"PRIu32"\n", bstat->bs_aextents);
+	printf("\tbs_version = %"PRIu16"\n", bstat->bs_version);
+	printf("\tbs_forkoff = %"PRIu16"\n", bstat->bs_forkoff);
+
+	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
+	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
+	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+};
+
+static void
+bulkstat_help(void)
+{
+	printf(_(
+"Bulk-queries the filesystem for inode stat information and prints it.\n"
+"\n"
+"   -a   Only iterate this AG.\n"
+"   -d   Print debugging output.\n"
+"   -e   Stop after this inode.\n"
+"   -n   Ask for this many results at once.\n"
+"   -s   Inode to start with.\n"
+"   -v   Use this version of the ioctl (1 or 5).\n"));
+}
+
+static int
+bulkstat_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_bulkstat_req	*breq;
+	unsigned long long	startino = 0;
+	unsigned long long	endino = -1ULL;
+	unsigned long		batch_size = 4096;
+	unsigned long		agno = 0;
+	unsigned long		ver = 0;
+	bool			has_agno = false;
+	unsigned int		i;
+	int			c;
+	int			error;
+
+	while ((c = getopt(argc, argv, "a:cde:n:qs:v:")) != -1) {
+		switch (c) {
+		case 'a':
+			errno = 0;
+			agno = strtoul(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			has_agno = true;
+			break;
+		case 'd':
+			debug = true;
+			break;
+		case 'e':
+			errno = 0;
+			endino = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'n':
+			errno = 0;
+			batch_size = strtoul(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 's':
+			errno = 0;
+			startino = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'v':
+			errno = 0;
+			ver = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			if (ver != 1 && ver != 5) {
+				fprintf(stderr, "version must be 1 or 5.\n");
+				return 1;
+			}
+			break;
+		default:
+			bulkstat_help();
+			return 0;
+		}
+	}
+	if (optind != argc) {
+		bulkstat_help();
+		return 0;
+	}
+
+	error = xfrog_prepare_geometry(&xfd);
+	if (error) {
+		perror("xfrog_prepare_geometry");
+		exitcode = 1;
+		return 0;
+	}
+
+	breq = xfrog_bulkstat_alloc_req(batch_size, startino);
+	if (!breq) {
+		perror("alloc bulkreq");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (has_agno)
+		xfrog_bulkstat_set_ag(breq, agno);
+
+	switch (ver) {
+	case 1:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	case 5:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V5;
+		break;
+	default:
+		break;
+	}
+
+	while ((error = xfrog_bulkstat(&xfd, breq)) == 0) {
+		if (debug)
+			printf(
+_("bulkstat: startino=%lld flags=0x%x agno=%u ret=%d icount=%u ocount=%u\n"),
+				(long long)breq->hdr.ino,
+				(unsigned int)breq->hdr.flags,
+				(unsigned int)breq->hdr.agno,
+				error,
+				(unsigned int)breq->hdr.icount,
+				(unsigned int)breq->hdr.ocount);
+		if (breq->hdr.ocount == 0)
+			break;
+
+		for (i = 0; i < breq->hdr.ocount; i++) {
+			if (breq->bulkstat[i].bs_ino > endino)
+				break;
+			dump_bulkstat(&breq->bulkstat[i]);
+		}
+	}
+	if (error) {
+		perror("xfrog_bulkstat");
+		exitcode = 1;
+		return 0;
+	}
+
+	free(breq);
+	return 0;
+}
+
+static void
+bulkstat_single_help(void)
+{
+	printf(_(
+"Queries the filesystem for a single inode's stat information and prints it.\n"
+"\n"
+"   -v   Use this version of the ioctl (1 or 5).\n"
+"\n"
+"Pass in inode numbers or a special inode name:\n"
+"    root    Root directory.\n"));
+}
+
+struct single_map {
+	const char		*tag;
+	uint64_t		code;
+};
+
+struct single_map tags[] = {
+	{"root", XFS_BULK_IREQ_SPECIAL_ROOT},
+	{NULL, 0},
+};
+
+static int
+bulkstat_single_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_bulkstat	bulkstat;
+	unsigned long		ver = 0;
+	unsigned int		i;
+	int			c;
+	int			error;
+
+	while ((c = getopt(argc, argv, "v:")) != -1) {
+		switch (c) {
+		case 'v':
+			errno = 0;
+			ver = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			if (ver != 1 && ver != 5) {
+				fprintf(stderr, "version must be 1 or 5.\n");
+				return 1;
+			}
+			break;
+		default:
+			bulkstat_single_help();
+			return 0;
+		}
+	}
+
+	error = xfrog_prepare_geometry(&xfd);
+	if (error) {
+		perror("xfrog_prepare_geometry");
+		exitcode = 1;
+		return 0;
+	}
+
+	switch (ver) {
+	case 1:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	case 5:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V5;
+		break;
+	default:
+		break;
+	}
+
+	for (i = optind; i < argc; i++) {
+		struct single_map	*sm = tags;
+		uint64_t		ino;
+		unsigned int		flags = 0;
+
+		/* Try to look up our tag... */
+		for (sm = tags; sm->tag; sm++) {
+			if (!strcmp(argv[i], sm->tag)) {
+				ino = sm->code;
+				flags |= XFS_BULK_IREQ_SPECIAL;
+				break;
+			}
+		}
+
+		/* ...or else it's an inode number. */
+		if (sm->tag == NULL) {
+			errno = 0;
+			ino = strtoull(argv[i], NULL, 10);
+			if (errno) {
+				perror(argv[i]);
+				exitcode = 1;
+				return 0;
+			}
+		}
+
+		error = xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
+		if (error) {
+			perror("xfrog_bulkstat_single");
+			continue;
+		}
+
+		if (debug)
+			printf(
+_("bulkstat_single: startino=%"PRIu64" flags=0x%"PRIx32" ret=%d\n"),
+				ino, flags, error);
+
+		dump_bulkstat(&bulkstat);
+	}
+
+	return 0;
+}
+
+static void
+dump_inumbers(
+	struct xfs_inumbers	*inumbers)
+{
+	printf("xi_startino = %"PRIu64"\n", inumbers->xi_startino);
+	printf("\txi_allocmask = 0x%"PRIx64"\n", inumbers->xi_allocmask);
+	printf("\txi_alloccount = %"PRIu8"\n", inumbers->xi_alloccount);
+	printf("\txi_version = %"PRIu8"\n", inumbers->xi_version);
+}
+
+static void
+inumbers_help(void)
+{
+	printf(_(
+"Queries the filesystem for inode group information and prints it.\n"
+"\n"
+"   -a   Only iterate this AG.\n"
+"   -d   Print debugging output.\n"
+"   -e   Stop after this inode.\n"
+"   -n   Ask for this many results at once.\n"
+"   -s   Inode to start with.\n"
+"   -v   Use this version of the ioctl (1 or 5).\n"));
+}
+
+static int
+inumbers_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_inumbers_req	*ireq;
+	unsigned long long	startino = 0;
+	unsigned long long	endino = -1ULL;
+	unsigned long		batch_size = 4096;
+	unsigned long		agno = 0;
+	unsigned long		ver = 0;
+	bool			has_agno = false;
+	unsigned int		i;
+	int			c;
+	int			error;
+
+	while ((c = getopt(argc, argv, "a:cde:n:qs:v:")) != -1) {
+		switch (c) {
+		case 'a':
+			errno = 0;
+			agno = strtoul(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			has_agno = true;
+			break;
+		case 'd':
+			debug = true;
+			break;
+		case 'e':
+			errno = 0;
+			endino = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'n':
+			errno = 0;
+			batch_size = strtoul(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 's':
+			errno = 0;
+			startino = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'v':
+			errno = 0;
+			ver = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			if (ver != 1 && ver != 5) {
+				fprintf(stderr, "version must be 1 or 5.\n");
+				return 1;
+			}
+			break;
+		default:
+			bulkstat_help();
+			return 0;
+		}
+	}
+	if (optind != argc) {
+		bulkstat_help();
+		return 0;
+	}
+
+	error = xfrog_prepare_geometry(&xfd);
+	if (error) {
+		perror("xfrog_prepare_geometry");
+		exitcode = 1;
+		return 0;
+	}
+
+	ireq = xfrog_inumbers_alloc_req(batch_size, startino);
+	if (!ireq) {
+		perror("alloc inumbersreq");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (has_agno)
+		xfrog_inumbers_set_ag(ireq, agno);
+
+	switch (ver) {
+	case 1:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	case 5:
+		xfd.flags |= XFROG_FLAG_BULKSTAT_FORCE_V5;
+		break;
+	default:
+		break;
+	}
+
+	while ((error = xfrog_inumbers(&xfd, ireq)) == 0) {
+		if (debug)
+			printf(
+_("bulkstat: startino=%"PRIu64" flags=0x%"PRIx32" agno=%"PRIu32" ret=%d icount=%"PRIu32" ocount=%"PRIu32"\n"),
+				ireq->hdr.ino,
+				ireq->hdr.flags,
+				ireq->hdr.agno,
+				error,
+				ireq->hdr.icount,
+				ireq->hdr.ocount);
+		if (ireq->hdr.ocount == 0)
+			break;
+
+		for (i = 0; i < ireq->hdr.ocount; i++) {
+			if (ireq->inumbers[i].xi_startino > endino)
+				break;
+			dump_inumbers(&ireq->inumbers[i]);
+		}
+	}
+	if (error) {
+		perror("xfrog_inumbers");
+		exitcode = 1;
+		return 0;
+	}
+
+	free(ireq);
+	return 0;
+}
+
+static cmdinfo_t	bulkstat_cmd = {
+	.name = "bulkstat",
+	.cfunc = bulkstat_f,
+	.argmin = 0,
+	.argmax = -1,
+	.flags = CMD_NOMAP_OK,
+	.help = bulkstat_help,
+};
+
+static cmdinfo_t	bulkstat_single_cmd = {
+	.name = "bulkstat_single",
+	.cfunc = bulkstat_single_f,
+	.argmin = 0,
+	.argmax = -1,
+	.flags = CMD_NOMAP_OK,
+	.help = bulkstat_single_help,
+};
+
+static cmdinfo_t	inumbers_cmd = {
+	.name = "inumbers",
+	.cfunc = inumbers_f,
+	.argmin = 0,
+	.argmax = -1,
+	.flags = CMD_NOMAP_OK,
+	.help = inumbers_help,
+};
+
+void
+bulkstat_init(void)
+{
+	bulkstat_cmd.args =
+		_("[-a agno] [-d] [-e endino] [-n batchsize] [-s startino]");
+	bulkstat_cmd.oneline = _("Bulk stat of inodes in a filesystem");
+
+	bulkstat_single_cmd.args = _("inum...");
+	bulkstat_single_cmd.oneline = _("Stat one inode in a filesystem");
+
+	inumbers_cmd.args =
+		_("[-a agno] [-d] [-e endino] [-n batchsize] [-s startino]");
+	inumbers_cmd.oneline = _("Query inode groups in a filesystem");
+
+	add_command(&bulkstat_cmd);
+	add_command(&bulkstat_single_cmd);
+	add_command(&inumbers_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 7025aea5..033ed67d 100644
--- a/io/init.c
+++ b/io/init.c
@@ -46,6 +46,7 @@ init_commands(void)
 {
 	attr_init();
 	bmap_init();
+	bulkstat_init();
 	copy_range_init();
 	cowextsize_init();
 	encrypt_init();
diff --git a/io/io.h b/io/io.h
index 0848ab98..5b21b0ca 100644
--- a/io/io.h
+++ b/io/io.h
@@ -183,3 +183,4 @@ extern void		log_writes_init(void);
 extern void		scrub_init(void);
 extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
+extern void		bulkstat_init(void);
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 26db9af2..00100491 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -384,6 +384,16 @@ xfrog_bulkstat_alloc_req(
 	return breq;
 }
 
+/* Set a bulkstat cursor to iterate only a particular AG. */
+void
+xfrog_bulkstat_set_ag(
+	struct xfs_bulkstat_req	*req,
+	uint32_t		agno)
+{
+	req->hdr.agno = agno;
+	req->hdr.flags |= XFS_BULK_IREQ_AGNO;
+}
+
 /* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
 void
 xfrog_inumbers_to_inogrp(
@@ -501,3 +511,13 @@ xfrog_inumbers_alloc_req(
 
 	return ireq;
 }
+
+/* Set an inumbers cursor to iterate only a particular AG. */
+void
+xfrog_inumbers_set_ag(
+	struct xfs_inumbers_req	*req,
+	uint32_t		agno)
+{
+	req->hdr.agno = agno;
+	req->hdr.flags |= XFS_BULK_IREQ_AGNO;
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6e064bdd..8fd3ffbe 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -996,6 +996,45 @@ for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
 .TP
+.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ]
+Display raw stat information about a bunch of inodes in an XFS filesystem.
+Options are as follows:
+.RS 1.0i
+.PD 0
+.TP
+.BI \-a " agno"
+Display only results from the given allocation group.
+Defaults to zero.
+.TP
+.BI \-d
+Print debugging information about call results.
+.TP
+.BI \-e " endino"
+Stop displaying records when this inode number is reached.
+Defaults to stopping when the system call stops returning results.
+.TP
+.BI \-n " batchsize"
+Retrieve at most this many records per call.
+.TP
+.BI \-s " startino"
+Display inode allocation records starting with this inode.
+Defaults to zero.
+If this value is zero, then display starts with the allocation group
+given above.
+.RE
+.PD
+.TP
+.BI "bulkstat_single [ " inum... " | " special... " ]
+Display raw stat information about individual inodes in an XFS filesystem.
+Arguments must be inode numbers or any of the special values:
+.RS 1.0i
+.PD 0
+.TP
+.B root
+Display information about the root directory inode.
+.RE
+.PD
+.TP
 .B freeze
 Suspend all write I/O requests to the filesystem of the current file.
 Only available in expert mode and requires privileges.
@@ -1067,6 +1106,35 @@ was specified on the command line, the maximum possible inode number in
 the system will be printed along with its size.
 .PD
 .TP
+.BI "inumbers [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-s " startino " ]
+Prints allocation information about groups of inodes in an XFS filesystem.
+Callers can use this information to figure out which inodes are allocated.
+Options are as follows:
+.RS 1.0i
+.PD 0
+.TP
+.BI \-a " agno"
+Display only results from the given allocation group.
+Defaults to zero.
+.TP
+.BI \-d
+Print debugging information about call results.
+.TP
+.BI \-e " endino"
+Stop displaying records when this inode number is reached.
+Defaults to stopping when the system call stops returning results.
+.TP
+.BI \-n " batchsize"
+Retrieve at most this many records per call.
+.TP
+.BI \-s " startino"
+Display inode allocation records starting with this inode.
+Defaults to zero.
+If this value is zero, then display starts with the allocation group
+given above.
+.RE
+.PD
+.TP
 .BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type

