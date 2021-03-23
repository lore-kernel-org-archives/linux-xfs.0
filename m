Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CBAC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF85619B4
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCWEUb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhCWEUZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A07D61990;
        Tue, 23 Mar 2021 04:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473224;
        bh=pFl9OAijd0ou2fxUN/iJ0DkrVZXx8h+yEECykGj207I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=np57qy+3pY6+8Qv6h185PIKEkHBYtcgvN1BMCP7CaiJD/5uyXIk4QUyDaMka8Oa71
         5f/SqF2b2AsTqrf6hNPiDP1om3e5A3fxsg733T2pWH6KrED/Gnq6oUcthyBCyxlBvC
         tjSbobs0kgNDtYFZqxu/g7iH6a8O+oeCGg55k7ttX62TXnU7yUR9pFJrZNG/w/N5qa
         pbdeuvv/quH2LncA+umOpqkgXs1YXuf0gSnDLwyifdixaEzbDw5UxsQ6JcXjHjgb1v
         EbaVaTfeE1H0FYokFt7QeAmPT3lfXq0VkfSzOs7sR95WhPr04ay0QevkLtdwFvAWoz
         z713dQLfTugBA==
Subject: [PATCH 1/2] xfs: test the xfs_db path command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:24 -0700
Message-ID: <161647322430.3430916.12437291741320143904.stgit@magnolia>
In-Reply-To: <161647321880.3430916.13415014495565709258.stgit@magnolia>
References: <161647321880.3430916.13415014495565709258.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new test to make sure the xfs_db path command works the way the
author thinks it should.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/917.out |   19 ++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/xfs/917
 create mode 100644 tests/xfs/917.out


diff --git a/tests/xfs/917 b/tests/xfs/917
new file mode 100755
index 00000000..bf21b290
--- /dev/null
+++ b/tests/xfs/917
@@ -0,0 +1,98 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 917
+#
+# Make sure the xfs_db path command works the way the author thinks it does.
+# This means that it can navigate to random inodes, fails on paths that don't
+# resolve.
+#
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
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_db_command "path"
+_require_scratch
+
+echo "Format filesystem and populate"
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/a/b
+$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
+ln -s -f c $SCRATCH_MNT/a/d
+mknod $SCRATCH_MNT/a/e b 8 0
+ln -s -f b $SCRATCH_MNT/a/f
+
+_scratch_unmount
+
+echo "Check xfs_db path on directories"
+_scratch_xfs_db -c 'path /a' -c print | grep -q 'sfdir.*count.* 5$' || \
+	echo "Did not find directory /a"
+
+_scratch_xfs_db -c 'path /a/b' -c print | grep -q sfdir || \
+	echo "Did not find empty sf directory /a/b"
+
+echo "Check xfs_db path on files"
+_scratch_xfs_db -c 'path /a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a/c"
+
+echo "Check xfs_db path on file symlinks"
+_scratch_xfs_db -c 'path /a/d' -c print | grep -q symlink || \
+	echo "Did not find symlink /a/d"
+
+echo "Check xfs_db path on bdevs"
+_scratch_xfs_db -c 'path /a/e' -c print | grep -q 'format.*dev' || \
+	echo "Did not find bdev /a/e"
+
+echo "Check xfs_db path on dir symlinks"
+_scratch_xfs_db -c 'path /a/f' -c print | grep -q symlink || \
+	echo "Did not find symlink /a/f"
+
+echo "Check nonexistent path"
+_scratch_xfs_db -c 'path /does/not/exist'
+
+echo "Check xfs_db path on file path with multiple slashes"
+_scratch_xfs_db -c 'path /a////////c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a////////c"
+
+echo "Check xfs_db path on file path going in and out of /a to get to /a/c"
+_scratch_xfs_db -c 'path /a/.././a/.././a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file /a/.././a/.././a/c"
+
+echo "Check xfs_db path on file path going above the root to get to /a/c"
+_scratch_xfs_db -c 'path /../../../a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file  /../../../a/c"
+
+echo "Check xfs_db path on file path going to then above the root to get to /a/c"
+_scratch_xfs_db -c 'path /a/../../../a/c' -c print | grep -q 'core.size.*61' || \
+	echo "Did not find 61-byte file  /a/../../../a/c"
+
+echo "Check xfs_db path component that isn't a directory"
+_scratch_xfs_db -c 'path /a/c/b' -c print
+
+echo "Check xfs_db path on a dot-dot applied to a non-directory"
+_scratch_xfs_db -c 'path /a/c/../b' -c print
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/917.out b/tests/xfs/917.out
new file mode 100644
index 00000000..7c613c3d
--- /dev/null
+++ b/tests/xfs/917.out
@@ -0,0 +1,19 @@
+QA output created by 917
+Format filesystem and populate
+Check xfs_db path on directories
+Check xfs_db path on files
+Check xfs_db path on file symlinks
+Check xfs_db path on bdevs
+Check xfs_db path on dir symlinks
+Check nonexistent path
+/does/not/exist: No such file or directory
+Check xfs_db path on file path with multiple slashes
+Check xfs_db path on file path going in and out of /a to get to /a/c
+Check xfs_db path on file path going above the root to get to /a/c
+Check xfs_db path on file path going to then above the root to get to /a/c
+Check xfs_db path component that isn't a directory
+/a/c/b: Not a directory
+no current type
+Check xfs_db path on a dot-dot applied to a non-directory
+/a/c/../b: Not a directory
+no current type
diff --git a/tests/xfs/group b/tests/xfs/group
index eebe7dde..daa56787 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -517,3 +517,4 @@
 538 auto stress
 759 auto quick rw realtime
 760 auto quick rw realtime collapse insert unshare zero prealloc
+917 auto quick db

