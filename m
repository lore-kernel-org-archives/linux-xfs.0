Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91155C43216
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7936761051
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbhIAANM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243220AbhIAANG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4042861008;
        Wed,  1 Sep 2021 00:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455130;
        bh=EZmNqyVWvnE4pxq7tuwELspdOoWOzw5mjZI50WeEXxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UoJDT+0CiDXs0bGJ6YirZJCouyABxK0YdgJxJeQGhE2osRG4VDCA9YCuM4eQkGnnp
         /nlApK3IU3yj5mlJF0mPzboDmNnZsIUFsuTO/K5R1ZodcWDAoFwXVEhYSW//kPyaW/
         YyFJiKN/cd6qVjBLd+nH7gna/KZYAAJ5sLyzDBhbmp0WRdx9CKwVTF9SKiIL50KFEl
         IYd+EOMsPkcHQeiIu2R6W2NOeZ2PKBW2bNQ5j9XK9T+421LwaaZoyNmtvdBhJVjShq
         FLplVC2TuQiYBXWPpSOYbTS2QHomc8BtAHYY+gYYsrmYCmxkTbDJG58lcIASyyXwz4
         MbYWKRUQLafMA==
Subject: [PATCH 1/4] generic: regression test for a FALLOC_FL_UNSHARE bug in
 XFS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:10 -0700
Message-ID: <163045512999.771394.1315069897087646871.stgit@magnolia>
In-Reply-To: <163045512451.771394.12554760323831932499.stgit@magnolia>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for "xfs: only set IOMAP_F_SHARED when
providing a srcmap to a write".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 tests/generic/729     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/729.out |    2 +
 2 files changed, 79 insertions(+)
 create mode 100755 tests/generic/729
 create mode 100644 tests/generic/729.out


diff --git a/tests/generic/729 b/tests/generic/729
new file mode 100755
index 00000000..90cecc03
--- /dev/null
+++ b/tests/generic/729
@@ -0,0 +1,77 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 729
+#
+# Regression test for commit:
+#
+# 72a048c1056a ("xfs: only set IOMAP_F_SHARED when providing a srcmap to a write")
+#
+# If a user creates a sparse shared region in a file, convinces XFS to create a
+# copy-on-write delayed allocation reservation spanning both the shared blocks
+# and the holes, and then calls the fallocate unshare command to unshare the
+# entire sparse region, XFS incorrectly tells iomap that the delalloc blocks
+# for the holes are shared, which causes it to error out while trying to
+# unshare a hole.
+#
+. ./common/preamble
+_begin_fstest auto clone unshare
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $TEST_DIR/$seq
+}
+
+# Import common functions.
+. ./common/reflink
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_cp_reflink
+_require_test_reflink
+_require_test_program "punch-alternating"
+_require_xfs_io_command "fpunch"	# make sure punch-alt can do its job
+_require_xfs_io_command "funshare"
+test "$FSTYP" = "xfs" && _require_xfs_io_command "cowextsize"
+
+mkdir $TEST_DIR/$seq
+file1=$TEST_DIR/$seq/a
+file2=$TEST_DIR/$seq/b
+
+$XFS_IO_PROG -f -c "pwrite -S 0x58 -b 10m 0 10m" $file1 >> $seqres.full
+
+f1sum0="$(md5sum $file1 | _filter_test_dir)"
+
+_cp_reflink $file1 $file2
+$here/src/punch-alternating -o 1 $file2
+
+f2sum0="$(md5sum $file2 | _filter_test_dir)"
+
+# set cowextsize to the defaults (128k) to force delalloc cow preallocations
+test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'cowextsize 0' $file2
+$XFS_IO_PROG -c "funshare 0 10m" $file2
+
+f1sum1="$(md5sum $file1 | _filter_test_dir)"
+f2sum1="$(md5sum $file2 | _filter_test_dir)"
+
+test "${f1sum0}" = "${f1sum1}" || echo "file1 should not have changed"
+test "${f2sum0}" = "${f2sum1}" || echo "file2 should not have changed"
+
+_test_cycle_mount
+
+f1sum2="$(md5sum $file1 | _filter_test_dir)"
+f2sum2="$(md5sum $file2 | _filter_test_dir)"
+
+test "${f1sum2}" = "${f1sum1}" || echo "file1 should not have changed ondisk"
+test "${f2sum2}" = "${f2sum1}" || echo "file2 should not have changed ondisk"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/729.out b/tests/generic/729.out
new file mode 100644
index 00000000..0f175ae2
--- /dev/null
+++ b/tests/generic/729.out
@@ -0,0 +1,2 @@
+QA output created by 729
+Silence is golden

