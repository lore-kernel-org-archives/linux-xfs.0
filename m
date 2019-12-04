Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966E5C432C3
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 02:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A277207DD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 02:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QsJKNrI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLDChb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 21:37:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfLDChb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 21:37:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB42TCqv093085;
        Wed, 4 Dec 2019 02:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=xeFs8RZo2hUhlXNnkBnEibDBlsjSqtQXl0u92a/Safo=;
 b=QsJKNrI87UD1aU1DpTRXrKq+oUzuSlUebVqj23QraLyPioKpNzpJjBF0zB5yHSboC4uu
 G8HmJQuzGC6sCdXedPu9ZOFlz21NcpsnPtAIdIUOZs7lj0g4Xv+R6DbwZApbUzbtHmnE
 PHMK6XxtVBwSFgk5aF8WOhsShobaC3HRsFaMnntqyp+xndZj/RKi92Mv93/rmkXX3sQj
 coLeGRgyJS4h6Kh+3fCHnGX+aDkSdvQ9EeNdGOAAQEtDrV58afGT6GZ/BkY8hPBNAnLX
 sxPUd2jY0+5Vy3prXizWMdZiRqfz26UONg84lX7mESdO1U2g2ayzEFe3jAssLDShs0XZ 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wkfuubpdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 02:37:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB42Xl6v024576;
        Wed, 4 Dec 2019 02:37:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wp169eguu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 02:37:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB42bP2a006297;
        Wed, 4 Dec 2019 02:37:25 GMT
Received: from localhost (/10.159.254.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 18:37:25 -0800
Date:   Tue, 3 Dec 2019 18:37:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        agruenba@redhat.com
Subject: [PATCH] generic: test splice() with pipes
Message-ID: <20191204023724.GE7328@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Andreas Grünbacher reports that on the two filesystems that support
iomap directio, it's possible for splice() to return -EAGAIN (instead of
a short splice) if the pipe being written to has less space available in
its pipe buffers than the length supplied by the calling process.

This is a regression test to check for correct operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .gitignore            |    1 
 src/Makefile          |    2 -
 src/splice-test.c     |  173 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/720     |   41 ++++++++++++
 tests/generic/720.out |    7 ++
 tests/generic/group   |    1 
 6 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 src/splice-test.c
 create mode 100755 tests/generic/720
 create mode 100644 tests/generic/720.out

diff --git a/.gitignore b/.gitignore
index b0f96ca0..7e6b7daf 100644
--- a/.gitignore
+++ b/.gitignore
@@ -113,6 +113,7 @@
 /src/runas
 /src/seek_copy_test
 /src/seek_sanity_test
+/src/splice-test
 /src/stale_handle
 /src/stat_test
 /src/swapon
diff --git a/src/Makefile b/src/Makefile
index ce6d8610..b015e78b 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -28,7 +28,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
-	fscrypt-crypt-util bulkstat_null_ocount
+	fscrypt-crypt-util bulkstat_null_ocount splice-test
 
 SUBDIRS = log-writes perf
 
diff --git a/src/splice-test.c b/src/splice-test.c
new file mode 100644
index 00000000..11fb11fa
--- /dev/null
+++ b/src/splice-test.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 RedHat Inc.  All Rights Reserved.
+ * Author: Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * Make sure that reading and writing to a pipe via splice.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <err.h>
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <string.h>
+#include <errno.h>
+
+#define SECTOR_SIZE 512
+#define BUFFER_SIZE (150 * SECTOR_SIZE)
+
+void read_from_pipe(int fd, const char *filename, size_t size)
+{
+	char buffer[SECTOR_SIZE];
+	size_t sz;
+	ssize_t ret;
+
+	while (size) {
+		sz = size;
+		if (sz > sizeof buffer)
+			sz = sizeof buffer;
+		ret = read(fd, buffer, sz);
+		if (ret < 0)
+			err(1, "read: %s", filename);
+		if (ret == 0) {
+			fprintf(stderr, "read: %s: unexpected EOF\n", filename);
+			exit(1);
+		}
+		size -= sz;
+	}
+}
+
+void do_splice1(int fd, const char *filename, size_t size)
+{
+	bool retried = false;
+	int pipefd[2];
+
+	if (pipe(pipefd) == -1)
+		err(1, "pipe");
+	while (size) {
+		ssize_t spliced;
+
+		spliced = splice(fd, NULL, pipefd[1], NULL, size, SPLICE_F_MOVE);
+		if (spliced == -1) {
+			if (errno == EAGAIN && !retried) {
+				retried = true;
+				fprintf(stderr, "retrying splice\n");
+				sleep(1);
+				continue;
+			}
+			err(1, "splice");
+		}
+		read_from_pipe(pipefd[0], filename, spliced);
+		size -= spliced;
+	}
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
+void do_splice2(int fd, const char *filename, size_t size)
+{
+	bool retried = false;
+	int pipefd[2];
+	int pid;
+
+	if (pipe(pipefd) == -1)
+		err(1, "pipe");
+
+	pid = fork();
+	if (pid == 0) {
+		close(pipefd[1]);
+		read_from_pipe(pipefd[0], filename, size);
+		exit(0);
+	} else {
+		close(pipefd[0]);
+		while (size) {
+			ssize_t spliced;
+
+			spliced = splice(fd, NULL, pipefd[1], NULL, size, SPLICE_F_MOVE);
+			if (spliced == -1) {
+				if (errno == EAGAIN && !retried) {
+					retried = true;
+					fprintf(stderr, "retrying splice\n");
+					sleep(1);
+					continue;
+				}
+				err(1, "splice");
+			}
+			size -= spliced;
+		}
+		close(pipefd[1]);
+		waitpid(pid, NULL, 0);
+	}
+}
+
+void usage(const char *argv0)
+{
+	fprintf(stderr, "USAGE: %s [-rd] {filename}\n", basename(argv0));
+	exit(2);
+}
+
+int main(int argc, char *argv[])
+{
+	void (*do_splice)(int fd, const char *filename, size_t size);
+	const char *filename;
+	char *buffer;
+	int opt, open_flags, fd;
+	ssize_t ret;
+
+	do_splice = do_splice1;
+	open_flags = O_CREAT | O_TRUNC | O_RDWR | O_DIRECT;
+
+	while ((opt = getopt(argc, argv, "rd")) != -1) {
+		switch(opt) {
+		case 'r':
+			do_splice = do_splice2;
+			break;
+		case 'd':
+			open_flags &= ~O_DIRECT;
+			break;
+		default:  /* '?' */
+			usage(argv[0]);
+		}
+	}
+
+	if (optind >= argc)
+		usage(argv[0]);
+	filename = argv[optind];
+
+	printf("%s reader %s O_DIRECT\n",
+		   do_splice == do_splice1 ? "sequential" : "concurrent",
+		   (open_flags & O_DIRECT) ? "with" : "without");
+
+	buffer = aligned_alloc(SECTOR_SIZE, BUFFER_SIZE);
+	if (buffer == NULL)
+		err(1, "aligned_alloc");
+
+	fd = open(filename, open_flags, 0666);
+	if (fd == -1)
+		err(1, "open: %s", filename);
+
+	memset(buffer, 'x', BUFFER_SIZE);
+	ret = write(fd, buffer, BUFFER_SIZE);
+	if (ret < 0)
+		err(1, "write: %s", filename);
+	if (ret != BUFFER_SIZE) {
+		fprintf(stderr, "%s: short write\n", filename);
+		exit(1);
+	}
+
+	ret = lseek(fd, 0, SEEK_SET);
+	if (ret != 0)
+		err(1, "lseek: %s", filename);
+
+	do_splice(fd, filename, BUFFER_SIZE);
+
+	if (unlink(filename) == -1)
+		err(1, "unlink: %s", filename);
+
+	return 0;
+}
diff --git a/tests/generic/720 b/tests/generic/720
new file mode 100755
index 00000000..b7f09c40
--- /dev/null
+++ b/tests/generic/720
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 720
+#
+# Test using splice() to read from pipes.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $TEST_DIR/a
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_test
+
+rm -f $seqres.full
+
+src/splice-test -r $TEST_DIR/a
+src/splice-test -rd $TEST_DIR/a
+src/splice-test $TEST_DIR/a
+src/splice-test -d $TEST_DIR/a
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/720.out b/tests/generic/720.out
new file mode 100644
index 00000000..b0fc9935
--- /dev/null
+++ b/tests/generic/720.out
@@ -0,0 +1,7 @@
+QA output created by 720
+concurrent reader with O_DIRECT
+concurrent reader with O_DIRECT
+concurrent reader without O_DIRECT
+concurrent reader without O_DIRECT
+sequential reader with O_DIRECT
+sequential reader without O_DIRECT
diff --git a/tests/generic/group b/tests/generic/group
index fdb7281f..9b5ec377 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -591,4 +591,5 @@
 586 auto quick rw prealloc
 587 auto quick rw prealloc
 588 auto quick log clone
+720 auto quick rw pipe splice
 721 auto quick atime
