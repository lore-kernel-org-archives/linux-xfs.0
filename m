Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E50C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152CC6141F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhDUAXa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhDUAXa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B855B6141C;
        Wed, 21 Apr 2021 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964577;
        bh=O5QcX5Cx5sMncqEOoFS2MzFmIaUdBa/PUcPX4TaSJFE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t5+bjL2aGNYb68MSlaS9ubtdxhUV4BptnDbaawy4VP3SEp0u7pK8aa0y/Zj/PgBm4
         r4qvMLbQBB+bkJ5yBbzhDTVwDVpnVv/j4gVLkufTD9F2xiTi+fxleNIGM+6ojf366r
         6olJJwz/x53rMjdgiRmAR2tL+t1lmJEbQIg9YjUNjrz+XwMEF8VO+aCkFuZ9WMzTJf
         AwXmk3H5tx7weCoHbkgPKQKpP9Re5y/Wii9RkVS7PnHrERY79x8qORD1LiyfWK7saz
         PHnxBXPH1Y0M6kjYpOhPNmweSgxW3lyBl10/nLGIJVjjWxsoT9KO+ClwNYM3SeE6I/
         dcRTsubgv4Pxw==
Subject: [PATCH 2/2] xfs: test inobtcount upgrade
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:57 -0700
Message-ID: <161896457693.776366.7071083307521835427.stgit@magnolia>
In-Reply-To: <161896456467.776366.1514131340097986327.stgit@magnolia>
References: <161896456467.776366.1514131340097986327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we can actually upgrade filesystems to support inode btree
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |    8 +++-
 tests/xfs/910     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |   23 ++++++++++++
 tests/xfs/group   |    1 +
 4 files changed, 127 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out


diff --git a/common/xfs b/common/xfs
index 5abc7034..3d660858 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1153,13 +1153,15 @@ _require_xfs_repair_upgrade()
 		_notrun "xfs_repair does not support upgrading fs with $type"
 }
 
-_require_xfs_scratch_inobtcount()
+# Require that the scratch device exists, that mkfs can format with inobtcount
+# enabled, and that the kernel can mount such a filesystem.
+_require_scratch_xfs_inobtcount()
 {
 	_require_scratch
 
 	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
-		_notrun "mkfs.xfs doesn't have inobtcount feature"
+		_notrun "mkfs.xfs doesn't support inobtcount feature"
 	_try_scratch_mount || \
-		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
+		_notrun "kernel doesn't support xfs inobtcount feature"
 	_scratch_unmount
 }
diff --git a/tests/xfs/910 b/tests/xfs/910
new file mode 100755
index 00000000..237d0a35
--- /dev/null
+++ b/tests/xfs/910
@@ -0,0 +1,98 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 910
+#
+# Check that we can upgrade a filesystem to support inobtcount and that
+# everything works properly after the upgrade.
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
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_xfs_inobtcount
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_repair_upgrade inobtcount
+
+rm -f $seqres.full
+
+# Make sure we can't format a filesystem with inobtcount and not finobt.
+_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
+	echo "Should not be able to format with inobtcount but not finobt."
+
+# Make sure we can't upgrade a V4 filesystem
+_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+
+# Make sure we can't upgrade a filesystem to inobtcount without finobt.
+_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+
+# Format V5 filesystem without inode btree counter support and populate it.
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_mount
+
+mkdir $SCRATCH_MNT/stress
+$FSSTRESS_PROG -d $SCRATCH_MNT/stress -n 1000 >> $seqres.full
+echo moo > $SCRATCH_MNT/urk
+
+_scratch_unmount
+
+# Upgrade filesystem to have the counters and inject failure into repair and
+# make sure that the only path forward is to re-run repair on the filesystem.
+echo "Fail partway through upgrading"
+XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "needsrepair should have prevented mount"
+	_scratch_unmount
+fi
+
+echo "Re-run repair to finish upgrade"
+_scratch_xfs_repair 2>> $seqres.full
+_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
+
+echo "Filesystem should be usable again"
+_scratch_mount
+$FSSTRESS_PROG -d $SCRATCH_MNT/stress -n 1000 >> $seqres.full
+_scratch_unmount
+_check_scratch_fs
+_check_scratch_xfs_features INOBTCNT
+
+echo "Make sure we have nonzero counters"
+_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
+	sed -e 's/= [1-9]*/= NONZERO/g'
+
+echo "Make sure we can't re-add inobtcount"
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+
+echo "Mount again, look at our files"
+_scratch_mount >> $seqres.full
+cat $SCRATCH_MNT/urk
+
+status=0
+exit
diff --git a/tests/xfs/910.out b/tests/xfs/910.out
new file mode 100644
index 00000000..1bf040d5
--- /dev/null
+++ b/tests/xfs/910.out
@@ -0,0 +1,23 @@
+QA output created by 910
+Running xfs_repair to upgrade filesystem.
+Inode btree count feature only supported on V5 filesystems.
+FEATURES: INOBTCNT:NO
+Running xfs_repair to upgrade filesystem.
+Inode btree count feature requires free inode btree.
+FEATURES: INOBTCNT:NO
+Fail partway through upgrading
+Adding inode btree counts to filesystem.
+FEATURES: NEEDSREPAIR:YES INOBTCNT:YES
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
+Re-run repair to finish upgrade
+FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
+Filesystem should be usable again
+FEATURES: INOBTCNT:YES
+Make sure we have nonzero counters
+ino_blocks = NONZERO
+fino_blocks = NONZERO
+Make sure we can't re-add inobtcount
+Running xfs_repair to upgrade filesystem.
+Filesystem already has inode btree counts.
+Mount again, look at our files
+moo
diff --git a/tests/xfs/group b/tests/xfs/group
index a2309465..bd47333c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 768 auto quick repair
 770 auto repair
 773 auto quick repair
+910 auto quick inobtcount

