Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEA4C43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7556528A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCIElO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhCIEk7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D81CA6523B;
        Tue,  9 Mar 2021 04:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264858;
        bh=BRd+NOJXW3rif+YdB76MWtwYJY6rd4IdNc/vUZxoaYM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HpORDagaSHsuYc/HT88bNCVXxV7T9QaqMEFu6bs+btiC6nqhynWuYPCaC6tn5hDp5
         a357UwUuyrxFl7wnWPYbEc9KzGWmcO2/nf7MZhbAsYb6Y8NXyWCz5c1Mf978vGwL/g
         K11PFe8/HMV47Of8OhaUfjIuFYkoSjhRk80sbNr2XsAgfEfTcn8zX+6fY4yw8vpQM6
         LU0SdT8xH7ZauiWOhyt/M9Bs1qaEo2eY6ZC1CnpAkooeSjyjl/R8AWiqP/OCjJHmPN
         UJw+LgYoVEo/ytNqsRB9e9vDBW+hxbP1keDpC31kX3G4/6cXPOgH9dQ7dwPlsMARKC
         5+DE7KJ5t4kmw==
Subject: [PATCH 10/10] xfs: test delalloc quota leak when chprojid fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:58 -0800
Message-ID: <161526485870.1214319.7885928745714445687.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for a bug in the XFS implementation of
FSSETXATTR.  When we try to change a file's project id, the quota
reservation code will update the incore quota reservations for delayed
allocation blocks.  Unfortunately, it does this before we finish
validating all the FSSETXATTR parameters, which means that if we decide
to bail out, we also fail to undo the incore changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .gitignore          |    1 +
 src/Makefile        |    2 +
 src/chprojid_fail.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/765       |   71 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/765.out   |    4 ++
 tests/xfs/group     |    1 +
 6 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100644 src/chprojid_fail.c
 create mode 100755 tests/xfs/765
 create mode 100644 tests/xfs/765.out


diff --git a/.gitignore b/.gitignore
index 03c03be5..3af8e207 100644
--- a/.gitignore
+++ b/.gitignore
@@ -58,6 +58,7 @@
 /src/bulkstat_null_ocount
 /src/bulkstat_unlink_test
 /src/bulkstat_unlink_test_modified
+/src/chprojid_fail
 /src/cloner
 /src/dbtest
 /src/devzero
diff --git a/src/Makefile b/src/Makefile
index 38ee6718..3d729a34 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -29,7 +29,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
-	fscrypt-crypt-util bulkstat_null_ocount splice-test
+	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail
 
 SUBDIRS = log-writes perf
 
diff --git a/src/chprojid_fail.c b/src/chprojid_fail.c
new file mode 100644
index 00000000..8c5b5fee
--- /dev/null
+++ b/src/chprojid_fail.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ *
+ * Regression test for failing to undo delalloc quota reservations when
+ * changing project id and we fail some other FSSETXATTR validation.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <linux/fs.h>
+
+static char zerobuf[65536];
+
+int
+main(
+	int		argc,
+	char		*argv[])
+{
+	struct fsxattr	fa;
+	ssize_t		sz;
+	int		fd, ret;
+
+	if (argc < 2) {
+		printf("Usage: %s filename\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_CREAT | O_TRUNC | O_RDWR, 0600);
+	if (fd < 0) {
+		perror(argv[1]);
+		return 2;
+	}
+
+	/* Zero the project id and the extent size hint. */
+	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fa);
+	if (ret) {
+		perror("FSGETXATTR check file");
+		return 2;
+	}
+
+	if (fa.fsx_projid != 0 || fa.fsx_extsize != 0) {
+		fa.fsx_projid = 0;
+		fa.fsx_extsize = 0;
+		ret = ioctl(fd, FS_IOC_FSSETXATTR, &fa);
+		if (ret) {
+			perror("FSSETXATTR zeroing");
+			return 2;
+		}
+	}
+
+	/* Dirty a few kb of a file to create delalloc extents. */
+	sz = write(fd, zerobuf, sizeof(zerobuf));
+	if (sz != sizeof(zerobuf)) {
+		perror("delalloc write");
+		return 2;
+	}
+
+	/*
+	 * The regression we're trying to test happens when the fsxattr input
+	 * validation decides to bail out after the chown quota reservation has
+	 * been made on a file containing delalloc extents.  Extent size hints
+	 * can't be set on non-empty files and we can't check the value until
+	 * we've reserved resources and taken the file's ILOCK, so this is a
+	 * perfect vector for triggering this condition.  In this way we set up
+	 * a FSSETXATTR call that will fail.
+	 */
+	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fa);
+	if (ret) {
+		perror("FSGETXATTR");
+		return 2;
+	}
+
+	fa.fsx_projid = 23652;
+	fa.fsx_extsize = 2;
+	fa.fsx_xflags |= FS_XFLAG_EXTSIZE;
+
+	ret = ioctl(fd, FS_IOC_FSSETXATTR, &fa);
+	if (ret) {
+		printf("FSSETXATTRR should fail: %s\n", strerror(errno));
+		return 0;
+	}
+
+	/* Uhoh, that FSSETXATTR call should have failed! */
+	return 3;
+}
diff --git a/tests/xfs/765 b/tests/xfs/765
new file mode 100755
index 00000000..68b89ce3
--- /dev/null
+++ b/tests/xfs/765
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 765
+#
+# Regression test for failing to undo delalloc quota reservations when changing
+# project id but we fail some other part of FSSETXATTR validation.  If we fail
+# the test, we trip debugging assertions in dmesg.  This is a regression test
+# for commit 1aecf3734a95 ("xfs: fix chown leaking delalloc quota blocks when
+# fssetxattr fails").
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_command "$FILEFRAG_PROG" filefrag
+_require_test_program "chprojid_fail"
+_require_quota
+_require_scratch
+
+rm -f $seqres.full
+
+echo "Format filesystem" | tee -a $seqres.full
+_scratch_mkfs > $seqres.full
+_qmount_option 'prjquota'
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+# Make sure that a regular buffered write produces delalloc reservations.
+$XFS_IO_PROG -f -c 'pwrite 0 64k' $SCRATCH_MNT/testy &> /dev/null
+$FILEFRAG_PROG -v $SCRATCH_MNT/testy 2>&1 | grep -q delalloc || \
+	_notrun "test requires delayed allocation writes"
+rm -f $SCRATCH_MNT/testy
+
+echo "Run test program"
+$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
+$here/src/chprojid_fail $SCRATCH_MNT/blah
+
+# The regression we're testing for is an accounting bug involving delalloc
+# reservations.  FSSETXATTR does not itself cause dirty data writeback, so we
+# assume that if the file still has delalloc extents, then it must have had
+# them when chprojid_fail was running, and therefore the test was set up
+# correctly.  There's a slight chance that background writeback can sneak in
+# and flush the file, but this should be a small enough gap.
+$FILEFRAG_PROG -v $SCRATCH_MNT/blah 2>&1 | grep -q delalloc || \
+	echo "file didn't get delalloc extents, test invalid?"
+
+# Make a note of current quota status for diagnostic purposes
+$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/765.out b/tests/xfs/765.out
new file mode 100644
index 00000000..d5f8fc11
--- /dev/null
+++ b/tests/xfs/765.out
@@ -0,0 +1,4 @@
+QA output created by 765
+Format filesystem
+Run test program
+FSSETXATTRR should fail: Invalid argument
diff --git a/tests/xfs/group b/tests/xfs/group
index d7aafc94..84468d10 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -505,4 +505,5 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 763 auto quick rw realtime
+765 auto quick quota
 915 auto quick quota

