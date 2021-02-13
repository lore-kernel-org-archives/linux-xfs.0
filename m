Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF91CC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBAE64E95
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhBMFem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhBMFel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFD9264E9C;
        Sat, 13 Feb 2021 05:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194428;
        bh=S18gsYEOZhqLmvuL7W7EADjxO1rNLGZs7D1+yGvvH8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XciRFvG+AHA8BURPROGqWnnzeph1kR8y+3BdSf5/HPVRCFqOcUKBskAjicMVanRm3
         Bypo5r/uuMp34qxxUg7iobBkbvZW1nFUPX15DshTpD0Zqnm94H+1ePjAJB8vtgIg+Y
         Bz83IYF2UEzp8L5ifdfaezWwPqqQ39lcK8nrklnxabr1Qq/KnHU9oQejCsgSqAijFD
         n1TIhE8xSQXuUNhWMnk613Wc505zkzhVipMemV7dG++/Kukj7665jk2QXxEq8UL2Tv
         DhOrWuUFlaTXtDfO7P+4FKlZnvctXFaV1LUMImJbhGktdOtqFmWzn+5ADpPemRg1Yt
         0EaPhOh1PjvOg==
Subject: [PATCH 3/3] xfs: test inobtcount upgrade
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:48 -0800
Message-ID: <161319442843.403510.16010746384411877041.stgit@magnolia>
In-Reply-To: <161319441183.403510.7352964287278809555.stgit@magnolia>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
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
 common/xfs        |   20 ++++++
 tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/764.out |   21 ++++++
 tests/xfs/910     |   84 +++++++++++++++++++++++
 tests/xfs/910.out |    8 ++
 tests/xfs/group   |    2 +
 6 files changed, 325 insertions(+)
 create mode 100755 tests/xfs/764
 create mode 100644 tests/xfs/764.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out


diff --git a/common/xfs b/common/xfs
index 7795856a..30544f88 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1045,3 +1045,23 @@ _require_xfs_copy()
 	[ "$USE_EXTERNAL" = yes ] && \
 		_notrun "Cannot xfs_copy with external devices"
 }
+
+_require_xfs_repair_upgrade()
+{
+	local type="$1"
+
+	$XFS_REPAIR_PROG -c "$type=narf" 2>&1 | \
+		grep -q 'unknown option' && \
+		_notrun "xfs_repair does not support upgrading fs with $type"
+}
+
+_require_xfs_scratch_inobtcount()
+{
+	_require_scratch
+
+	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
+		_notrun "mkfs.xfs doesn't have inobtcount feature"
+	_try_scratch_mount || \
+		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
+	_scratch_unmount
+}
diff --git a/tests/xfs/764 b/tests/xfs/764
new file mode 100755
index 00000000..ce815a02
--- /dev/null
+++ b/tests/xfs/764
@@ -0,0 +1,190 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 764
+#
+# Functional testing for xfs_admin -O, which is a new switch that enables us to
+# add features to an existing filesystem.  In these test scenarios, we try to
+# add the inode btree counter 'feature' to the filesystem, and make sure that
+# NEEDSREPAIR (aka the thing that prevents us from mounting after an upgrade
+# fails) is clear if the upgraded succeeds and set if it fails.
+#
+# The first scenario tests that we can't add inobtcount to the V4 format,
+# which is now deprecated.
+#
+# The middle five scenarios ensure that xfs_admin -O works even when external
+# log devices and realtime volumes are specified.  This part is purely an
+# exerciser for the userspace tools; kernel support for those features is not
+# required.
+#
+# The last scenario uses a xfs_repair debug knob to simulate failure during an
+# inobtcount upgrade, then checks that mounts fail when the flag is enabled,
+# that repair clears the flag, and mount works after repair.
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
+	rm -f $tmp.* $fake_logfile $fake_rtfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_test
+_require_xfs_scratch_inobtcount
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_repair_upgrade inobtcount
+
+rm -f $seqres.full
+
+note() {
+	echo "$@" | tee -a $seqres.full
+}
+
+note "S1: Cannot add inobtcount to a V4 fs"
+_scratch_mkfs -m crc=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+
+# Middle five scenarios: Make sure upgrades work with various external device
+# configurations.
+note "S2: Check that setting with xfs_admin + logdev works"
+fake_logfile=$TEST_DIR/scratch.log
+rm -f $fake_logfile
+truncate -s 500m $fake_logfile
+
+old_external=$USE_EXTERNAL
+old_logdev=$SCRATCH_LOGDEV
+USE_EXTERNAL=yes
+SCRATCH_LOGDEV=$fake_logfile
+
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_admin should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+
+note "Check clean"
+_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
+
+USE_EXTERNAL=$old_external
+SCRATCH_LOGDEV=$old_logdev
+
+note "S3: Check that setting with xfs_admin + realtime works"
+fake_rtfile=$TEST_DIR/scratch.rt
+rm -f $fake_rtfile
+truncate -s 500m $fake_rtfile
+
+old_external=$USE_EXTERNAL
+old_rtdev=$SCRATCH_RTDEV
+USE_EXTERNAL=yes
+SCRATCH_RTDEV=$fake_rtfile
+
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_admin should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+
+note "Check clean"
+_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
+
+USE_EXTERNAL=$old_external
+SCRATCH_RTDEV=$old_rtdev
+
+note "S4: Check that setting with xfs_admin + realtime + logdev works"
+old_external=$USE_EXTERNAL
+old_logdev=$SCRATCH_LOGDEV
+old_rtdev=$SCRATCH_RTDEV
+USE_EXTERNAL=yes
+SCRATCH_LOGDEV=$fake_logfile
+SCRATCH_RTDEV=$fake_rtfile
+
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_admin should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+
+note "Check clean"
+_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
+
+USE_EXTERNAL=$old_external
+SCRATCH_LOGDEV=$old_logdev
+SCRATCH_RTDEV=$old_rtdev
+
+note "S5: Check that setting with xfs_admin + nortdev + nologdev works"
+old_external=$USE_EXTERNAL
+old_logdev=$SCRATCH_LOGDEV
+old_rtdev=$SCRATCH_RTDEV
+USE_EXTERNAL=
+SCRATCH_LOGDEV=
+SCRATCH_RTDEV=
+
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_admin should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+
+note "Check clean"
+_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
+
+USE_EXTERNAL=$old_external
+SCRATCH_LOGDEV=$old_logdev
+SCRATCH_RTDEV=$old_rtdev
+
+# Run our test with the test runner's config last so that the post-test check
+# won't trip over our artificial log/rt devices
+note "S6: Check that setting with xfs_admin testrunner config works"
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_admin should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+
+note "Check clean"
+_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
+
+note "S7: Simulate failure during upgrade process"
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR || \
+	echo "needsrepair should have been set on fs"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "inobtcount should have been set on fs"
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "needsrepair should have prevented mount"
+	_scratch_unmount
+fi
+_scratch_xfs_repair 2>> $seqres.full
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "xfs_repair should have cleared needsrepair?"
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "xfs_admin should have set inobtcount?"
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/764.out b/tests/xfs/764.out
new file mode 100644
index 00000000..e64bce21
--- /dev/null
+++ b/tests/xfs/764.out
@@ -0,0 +1,21 @@
+QA output created by 764
+S1: Cannot add inobtcount to a V4 fs
+Inode btree count feature only supported on V5 filesystems.
+S2: Check that setting with xfs_admin + logdev works
+Adding inode btree counts to filesystem.
+Check clean
+S3: Check that setting with xfs_admin + realtime works
+Adding inode btree counts to filesystem.
+Check clean
+S4: Check that setting with xfs_admin + realtime + logdev works
+Adding inode btree counts to filesystem.
+Check clean
+S5: Check that setting with xfs_admin + nortdev + nologdev works
+Adding inode btree counts to filesystem.
+Check clean
+S6: Check that setting with xfs_admin testrunner config works
+Adding inode btree counts to filesystem.
+Check clean
+S7: Simulate failure during upgrade process
+Adding inode btree counts to filesystem.
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
diff --git a/tests/xfs/910 b/tests/xfs/910
new file mode 100755
index 00000000..eb4fd23d
--- /dev/null
+++ b/tests/xfs/910
@@ -0,0 +1,84 @@
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
+_require_xfs_scratch_inobtcount
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
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
+	echo "Should not be able to upgrade to inobtcount without V5."
+
+# Make sure we can't upgrade a filesystem to inobtcount without finobt.
+_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
+	echo "Should not be able to upgrade to inobtcount without finobt."
+
+# Format V5 filesystem without inode btree counter support and populate it
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo moo > $SCRATCH_MNT/urk
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to inobtcount support
+_scratch_xfs_admin -O inobtcount=1
+_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
+	echo "Cannot detect new feature?"
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
+
+# Make sure we have nonzero counters
+_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
+	sed -e 's/= [1-9]*/= NONZERO/g'
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+cat $SCRATCH_MNT/urk
+
+# Make sure we can't re-add inobtcount
+_scratch_unmount
+_scratch_xfs_admin -O inobtcount=1
+_scratch_mount >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/910.out b/tests/xfs/910.out
new file mode 100644
index 00000000..56e6d931
--- /dev/null
+++ b/tests/xfs/910.out
@@ -0,0 +1,8 @@
+QA output created by 910
+Inode btree count feature only supported on V5 filesystems.
+Inode btree count feature requires free inode btree.
+Adding inode btree counts to filesystem.
+ino_blocks = NONZERO
+fino_blocks = NONZERO
+moo
+Filesystem already has inode btree counts.
diff --git a/tests/xfs/group b/tests/xfs/group
index b4bb006d..90d2098f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -505,9 +505,11 @@
 760 auto quick rw collapse punch insert zero prealloc
 761 auto quick realtime
 763 auto quick rw realtime
+764 auto quick repair
 765 auto quick quota
 768 auto quick repair
 770 auto repair
+910 auto quick inobtcount
 915 auto quick quota
 917 auto quick db
 918 auto quick db

