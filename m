Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64081C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267CF64E56
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhBBTmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhBBTlm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 14:41:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5165064F51;
        Tue,  2 Feb 2021 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612294861;
        bh=IMvAUtMc73E+O/bcxQ0FL9XmI09d1UXthaE6IPvMMZ4=;
        h=Date:From:To:Cc:Subject:From;
        b=TYs0FWlpvTXX+DqMGz6eQbWLwF3atdaXjSNwwTetn8JV/5/YaHfMwckxCzk2mpZ8E
         +Z0Iy9Dhw2mVlRnV809OEpbck1llAIGjo1c1mog0Gc/kswJloatBvE3RakcJ7JSlzi
         mSaNihuLYv91wdOujuLuoqqL2rNJeUYfiIklyTDBx8HALjiRiNV9lGYTLtSUw9ATRF
         J+GrFdGvuGfwNLiXjok38pZNcM62r7SrKz9Z1S0MCT3WaawGDYGruaQ+c/+IRnlgC0
         0tlDJ6ykqBtnfzdnr1EXguitAzkwrRSoyxHaRn+JZebLL50Tdjus9UjegYYZEbZdiP
         cfH5oV921Hpqg==
Date:   Tue, 2 Feb 2021 11:41:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: test delalloc quota leak when chprojid fails
Message-ID: <20210202194101.GQ7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
 src/Makefile        |    3 +-
 src/chprojid_fail.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/765       |   63 +++++++++++++++++++++++++++++++++++++
 tests/xfs/765.out   |    3 ++
 tests/xfs/group     |    1 +
 6 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100644 src/chprojid_fail.c
 create mode 100755 tests/xfs/765
 create mode 100644 tests/xfs/765.out

diff --git a/.gitignore b/.gitignore
index f988a44a..6d5c4ba6 100644
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
index 28789915..435c1e8a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -29,7 +29,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
-	fscrypt-crypt-util bulkstat_null_ocount splice-test immutable_write
+	fscrypt-crypt-util bulkstat_null_ocount splice-test immutable_write \
+	chprojid_fail
 
 SUBDIRS = log-writes perf
 
diff --git a/src/chprojid_fail.c b/src/chprojid_fail.c
new file mode 100644
index 00000000..e7467372
--- /dev/null
+++ b/src/chprojid_fail.c
@@ -0,0 +1,86 @@
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
+	 * Fail to chprojid and set an extent size hint after we wrote the file.
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
index 00000000..769b545b
--- /dev/null
+++ b/tests/xfs/765
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 765
+#
+# Regression test for failing to undo delalloc quota reservations when changing
+# project id but we fail some other part of FSSETXATTR validation.  If we fail
+# the test, we trip debugging assertions in dmesg.
+#
+# The appropriate XFS patch is:
+# xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
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
+_require_xfs_debug
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
+echo "Run test program"
+$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
+$here/src/chprojid_fail $SCRATCH_MNT/blah >> $seqres.full
+res=$?
+if [ $res -ne 0 ]; then
+	echo "chprojid_fail returned $res, expected 0"
+fi
+$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
+$FILEFRAG_PROG -v $SCRATCH_MNT/blah >> $seqres.full
+$FILEFRAG_PROG -v $SCRATCH_MNT/blah 2>&1 | grep -q delalloc || \
+	echo "file didn't get delalloc extents?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/765.out b/tests/xfs/765.out
new file mode 100644
index 00000000..f44ba43e
--- /dev/null
+++ b/tests/xfs/765.out
@@ -0,0 +1,3 @@
+QA output created by 765
+Format filesystem
+Run test program
diff --git a/tests/xfs/group b/tests/xfs/group
index f406a9b9..fb78b0d7 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -544,6 +544,7 @@
 762 auto quick rw scrub realtime
 763 auto quick rw realtime
 764 auto quick repair
+765 auto quick quota
 908 auto quick bigtime
 909 auto quick bigtime quota
 910 auto quick inobtcount
