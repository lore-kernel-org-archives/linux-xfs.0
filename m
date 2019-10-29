Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB35CA9EC4
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 20:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA2621479
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 20:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Do4mVMA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfJ2UX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 16:23:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59648 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfJ2UX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 16:23:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TKIvMd074038;
        Tue, 29 Oct 2019 20:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=J0eQtCP/NofNdSFKQeIjWFP2iy8v1t1zDyRmNhBTOa0=;
 b=Do4mVMA9RCYaw/HgabSW0dLITej3hc1XxxkqFUoz38aZ0wp6bzz9Dc0qkTJQKXfJWkD3
 vl5rpS6bcWDih5+uGGlFWXxtM2qspn+J7Johjad9S+/5TUFjx6Feuy2xs8Zbdh4uoaSj
 JqnpeRE7kpNg06PIEDExeH2R9Ob16SZ6jGqpsI54JBp4w8jkU5Oc8I8pNL6VYPgOJlSk
 7ooqOdAuwySON1JiAa8Vedvt2iEI6WUaVVFmMPu3bPnV/zRMRdbiI2hPJypNRoemxXaZ
 b9/M8+R08q3DyqYKLjXicl7Wz2Ab/Z6x37EydlgFH5jSei9m1/8LqkluTN7U2iylUMiQ LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vve3qbq95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 20:23:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TKNa2o011400;
        Tue, 29 Oct 2019 20:23:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vxj8gw1pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 20:23:44 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TKNhOi008007;
        Tue, 29 Oct 2019 20:23:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 13:23:43 -0700
Date:   Tue, 29 Oct 2019 13:23:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        fstests <fstests@vger.kernel.org>
Subject: [RFC PATCH] generic: test race between appending AIO DIO and
 fallocate
Message-ID: <20191029202342.GG15222@magnolia>
References: <20191029034850.8212-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029034850.8212-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Dave Chinner reports[1] that an appending AIO DIO write to the second
block of a zero-length file and an fallocate request to the first block
of the same file can race to set isize, with the user-visible end result
that the file size is set incorrectly to one block long.  Write a small
test to reproduce the results.

[1] https://lore.kernel.org/linux-xfs/20191029100342.GA41131@bfoster/T/

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../aio-dio-append-write-fallocate-race.c          |  212 ++++++++++++++++++++
 tests/generic/722                                  |   44 ++++
 tests/generic/722.out                              |    2 
 tests/generic/group                                |    1 
 4 files changed, 259 insertions(+)
 create mode 100644 src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
 create mode 100755 tests/generic/722
 create mode 100644 tests/generic/722.out

diff --git a/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
new file mode 100644
index 00000000..091b047d
--- /dev/null
+++ b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0-or-newer
+/*
+ * Copyright (c) 2019 Oracle.
+ * All Rights Reserved.
+ *
+ * Race appending aio dio and fallocate to make sure we get the correct file
+ * size afterwards.
+ */
+#include <stdio.h>
+#include <pthread.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <libaio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <limits.h>
+
+static int fd;
+static int blocksize;
+
+static void *
+falloc_thread(
+	void		*p)
+{
+	int		ret;
+
+	ret = fallocate(fd, 0, 0, blocksize);
+	if (ret)
+		perror("falloc");
+
+	return NULL;
+}
+
+static int
+test(
+	const char	*fname,
+	unsigned int	iteration,
+	unsigned int	*passed)
+{
+	struct stat	sbuf;
+	pthread_t	thread;
+	io_context_t	ioctx = 0;
+	struct iocb	iocb;
+	struct iocb	*iocbp = &iocb;
+	struct io_event	event;
+	char		*buf;
+	bool		wait_thread = false;
+	int		ret;
+
+	/* Truncate file, allocate resources for doing IO. */
+	fd = open(fname, O_DIRECT | O_RDWR | O_TRUNC | O_CREAT, 0644);
+	if (fd < 0) {
+		perror(fname);
+		return -1;
+	}
+
+	ret = fstat(fd, &sbuf);
+	if (ret) {
+		perror(fname);
+		goto out;
+	}
+	blocksize = sbuf.st_blksize;
+
+	ret = posix_memalign((void **)&buf, blocksize, blocksize);
+	if (ret) {
+		errno = ret;
+		perror("buffer");
+		goto out;
+	}
+	memset(buf, 'X', blocksize);
+	memset(&event, 0, sizeof(event));
+
+	ret = io_queue_init(1, &ioctx);
+	if (ret) {
+		errno = -ret;
+		perror("io_queue_init");
+		goto out_buf;
+	}
+
+	/*
+	 * Set ourselves up to race fallocate(0..blocksize) with aio dio
+	 * pwrite(blocksize..blocksize * 2).  This /should/ give us a file
+	 * with length (2 * blocksize).
+	 */
+	io_prep_pwrite(&iocb, fd, buf, blocksize, blocksize);
+
+	ret = pthread_create(&thread, NULL, falloc_thread, NULL);
+	if (ret) {
+		errno = ret;
+		perror("pthread");
+		goto out_io;
+	}
+	wait_thread = true;
+
+	ret = io_submit(ioctx, 1, &iocbp);
+	if (ret != 1) {
+		errno = -ret;
+		perror("io_submit");
+		goto out_join;
+	}
+
+	ret = io_getevents(ioctx, 1, 1, &event, NULL);
+	if (ret != 1) {
+		errno = -ret;
+		perror("io_getevents");
+		goto out_join;
+	}
+
+	if (event.res < 0) {
+		errno = -event.res;
+		perror("io_event.res");
+		goto out_join;
+	}
+
+	if (event.res2 < 0) {
+		errno = -event.res2;
+		perror("io_event.res2");
+		goto out_join;
+	}
+
+	wait_thread = false;
+	ret = pthread_join(thread, NULL);
+	if (ret) {
+		errno = ret;
+		perror("join");
+		goto out_io;
+	}
+
+	/* Make sure we actually got a file of size (2 * blocksize). */
+	ret = fstat(fd, &sbuf);
+	if (ret) {
+		perror(fname);
+		goto out_buf;
+	}
+
+	if (sbuf.st_size != 2 * blocksize) {
+		fprintf(stderr, "[%u]: sbuf.st_size=%llu, expected %llu.\n",
+				iteration,
+				(unsigned long long)sbuf.st_size,
+				(unsigned long long)2 * blocksize);
+	} else {
+		printf("[%u]: passed.\n", iteration);
+		(*passed)++;
+	}
+
+out_join:
+	if (wait_thread) {
+		ret = pthread_join(thread, NULL);
+		if (ret) {
+			errno = ret;
+			perror("join");
+			goto out_io;
+		}
+	}
+out_io:
+	ret = io_queue_release(ioctx);
+	if (ret) {
+		errno = -ret;
+		perror("io_queue_release");
+	}
+
+out_buf:
+	free(buf);
+out:
+	ret = close(fd);
+	fd = -1;
+	if (ret) {
+		perror("close");
+		return -1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int		ret;
+	long		l;
+	unsigned int	i;
+	unsigned int	passed = 0;
+
+	if (argc != 3) {
+		printf("Usage: %s filename iterations\n", argv[0]);
+		return 1;
+	}
+
+	errno = 0;
+	l = strtol(argv[2], NULL, 0);
+	if (errno) {
+		perror(argv[2]);
+		return 1;
+	}
+	if (l < 1 || l > UINT_MAX) {
+		fprintf(stderr, "%ld: must be between 1 and %u.\n",
+				l, UINT_MAX);
+		return 1;
+	}
+
+	for (i = 0; i < l; i++) {
+		ret = test(argv[1], i, &passed);
+		if (ret)
+			return 1;
+	}
+
+	printf("pass rate: %u/%u (%.2f%%)\n", passed, i, 100.0 * passed / i);
+
+	return 0;
+}
diff --git a/tests/generic/722 b/tests/generic/722
new file mode 100755
index 00000000..307e3b77
--- /dev/null
+++ b/tests/generic/722
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 722
+#
+# Race an appending aio dio write to the second block of a file while
+# simultaneously fallocating to the first block.  Make sure that we end up
+# with a two-block file.
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
+	rm -f $tmp.* $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_aiodio "aiocp"
+_require_test
+AIO_TEST=$here/src/aio-dio-regress/aio-dio-append-write-fallocate-race
+
+rm -f $seqres.full
+
+testfile=$TEST_DIR/test-$seq
+$AIO_TEST $testfile 100 >> $seqres.full
+
+echo Silence is golden.
+# success, all done
+status=0
+exit
diff --git a/tests/generic/722.out b/tests/generic/722.out
new file mode 100644
index 00000000..8621a87d
--- /dev/null
+++ b/tests/generic/722.out
@@ -0,0 +1,2 @@
+QA output created by 722
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index a252f424..20df0964 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -591,3 +591,4 @@
 716 dangerous_norepair
 720 dangerous_norepair
 721 auto quick atime
+722 auto quick rw falloc
