Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158A8C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6AF65290
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCIElO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCIEkx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C9365275;
        Tue,  9 Mar 2021 04:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264853;
        bh=O/8xPqrlVA31AQ13Ug1211UcQ/I3PFRPbN+ktCU8lnA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X5sjV4Owp9wNDaWj3wvaU+5sJP1ReNw7zHNjErAla/dyulNZsVXUy8fvIimRV4gsJ
         0dGoEdovTS5K3dzc+F8NGxNGySjnrbcIlZgYbYO3TjTfl5X+zT9Fpc3sQTo5doD314
         kJz2hSvU2fG8E8AaGq0mVw7B5dewvv+GBKYBPNq76/8KJi2eibGD5yaIA4Mroyn/eF
         U5lqA/c/ld3I3rEcuXdiCA19nyx3V8Ll3YVoHoTqmPbFuVyni1nSNdNmwrwSTD3zCK
         XFn/DNuvCKJ3GAlQzJY1wP/gDqcIW4XpPVGKHPS9uA9vZyzbIRshf+LwySPcnJ5MIv
         LtvmWeibSkVcA==
Subject: [PATCH 09/10] generic: test a deadlock in xfs_rename when whiteing
 out files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     wenli xie <wlxie7296@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:53 -0800
Message-ID: <161526485320.1214319.14486851135232825638.stgit@magnolia>
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

wenli xie reported a buffer cache deadlock when an overlayfs is mounted
atop xfs and overlayfs tries to replace a single-nlink file with a
whiteout file.  This test reproduces that deadlock.

Reported-by: wenli xie <wlxie7296@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1300     |  109 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1300.out |    2 +
 tests/generic/group    |    1 
 3 files changed, 112 insertions(+)
 create mode 100755 tests/generic/1300
 create mode 100644 tests/generic/1300.out


diff --git a/tests/generic/1300 b/tests/generic/1300
new file mode 100755
index 00000000..10df44e3
--- /dev/null
+++ b/tests/generic/1300
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1300
+#
+# Reproducer for a deadlock in xfs_rename reported by Wenli Xie.
+#
+# When overlayfs is running on top of xfs and the user unlinks a file in the
+# overlay, overlayfs will create a whiteout inode and ask us to "rename" the
+# whiteout file atop the one being unlinked.  If the file being unlinked loses
+# its one nlink, we then have to put the inode on the unlinked list.
+#
+# This requires us to grab the AGI buffer of the whiteout inode to take it
+# off the unlinked list (which is where whiteouts are created) and to grab
+# the AGI buffer of the file being deleted.  If the whiteout was created in
+# a higher numbered AG than the file being deleted, we'll lock the AGIs in
+# the wrong order and deadlock.
+#
+# Note that this test doesn't do anything xfs-specific so it's a generic test.
+# This is a regression test for commit 6da1b4b1ab36 ("xfs: fix an ABBA deadlock
+# in xfs_rename").
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
+	stop_workers
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+test "$FSTYP" = "overlay" && _notrun "Test does not apply to overlayfs."
+
+modprobe -q overlay
+grep -q overlay /proc/filesystems || _notrun "Test requires overlayfs."
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+mkdir $SCRATCH_MNT/lowerdir
+mkdir $SCRATCH_MNT/lowerdir1
+mkdir $SCRATCH_MNT/lowerdir/etc
+mkdir $SCRATCH_MNT/workers
+echo salts > $SCRATCH_MNT/lowerdir/etc/access.conf
+touch $SCRATCH_MNT/running
+
+stop_workers() {
+	test -e $SCRATCH_MNT/running || return
+	rm -f $SCRATCH_MNT/running
+
+	while [ "$(ls $SCRATCH_MNT/workers/ | wc -l)" -gt 0 ]; do
+		wait
+	done
+}
+
+worker() {
+	local tag="$1"
+	local mergedir="$SCRATCH_MNT/merged$tag"
+	local l="lowerdir=$SCRATCH_MNT/lowerdir:$SCRATCH_MNT/lowerdir1"
+	local u="upperdir=$SCRATCH_MNT/upperdir$tag"
+	local w="workdir=$SCRATCH_MNT/workdir$tag"
+	local i="index=off,nfs_export=off"
+
+	touch $SCRATCH_MNT/workers/$tag
+	while test -e $SCRATCH_MNT/running; do
+		rm -rf $SCRATCH_MNT/merged$tag
+		rm -rf $SCRATCH_MNT/upperdir$tag
+		rm -rf $SCRATCH_MNT/workdir$tag
+		mkdir $SCRATCH_MNT/merged$tag
+		mkdir $SCRATCH_MNT/workdir$tag
+		mkdir $SCRATCH_MNT/upperdir$tag
+
+		mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
+		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
+		touch $mergedir/etc/access.conf
+		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
+		touch $mergedir/etc/access.conf
+		umount $mergedir
+	done
+	rm -f $SCRATCH_MNT/workers/$tag
+}
+
+for i in $(seq 0 $((4 + LOAD_FACTOR)) ); do
+	worker $i &
+done
+
+sleep $((30 * TIME_FACTOR))
+stop_workers
+
+echo Silence is golden.
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1300.out b/tests/generic/1300.out
new file mode 100644
index 00000000..5805d30d
--- /dev/null
+++ b/tests/generic/1300.out
@@ -0,0 +1,2 @@
+QA output created by 1300
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index 778aa8c4..2233a59d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -631,3 +631,4 @@
 947 auto quick rw clone
 948 auto quick rw copy_range
 949 auto quick rw dedupe clone
+1300 auto rw overlay

