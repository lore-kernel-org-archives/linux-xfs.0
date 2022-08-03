Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2702C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiHCEWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHCEWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33865558E7;
        Tue,  2 Aug 2022 21:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7E2612BE;
        Wed,  3 Aug 2022 04:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96956C433C1;
        Wed,  3 Aug 2022 04:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500535;
        bh=b/k1WIyVQreP0uDY5voLtAT70f2P6W4wA1DTy8NVvNg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fyzijIqok+ZaPpBBavWxLRChekwPVvFEkW2H7C7UR158MCyA4yde5czWAro0vwlNg
         WBVS+LkLJqsWGj6TdkSq5BSOufzU4zGgtN2tieZpSt4tguVMMS9imKYbfZ0+dU83Vj
         0P+P5+5g+h7QvRlSPKFrmNkZq6SQIEBbrUF81z5MqSa4fLQbdt5rg4jAWfR9xFtl4B
         YE5sziykoju+kpW6XlqBHAcD7BqQqNJctYA75G6Lxh0qGn6nlz5j6qrhL4drNAazTy
         Diy0GcGn/E6mkMlSh/kVUv0vAN5BbYyI3padWaAmIs0f3CEelu+xq1ZfmLWZIF+Sv8
         Y/BrcTPJdERdw==
Subject: [PATCH 1/2] common: refactor fail_make_request boilerplate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:15 -0700
Message-ID: <165950053513.199134.15842568650897036461.stgit@magnolia>
In-Reply-To: <165950052948.199134.11841652463463547824.stgit@magnolia>
References: <165950052948.199134.11841652463463547824.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the control functions from generic/019 into a common helper to
be used by all three tests that use fail_make_requests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fail_make_request |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 common/rc                |    7 -------
 tests/btrfs/088          |   14 +++++---------
 tests/btrfs/150          |   13 +++++--------
 tests/generic/019        |   40 +++++----------------------------------
 5 files changed, 62 insertions(+), 59 deletions(-)
 create mode 100644 common/fail_make_request


diff --git a/common/fail_make_request b/common/fail_make_request
new file mode 100644
index 00000000..581d176a
--- /dev/null
+++ b/common/fail_make_request
@@ -0,0 +1,47 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# common functions for setting up and tearing down block device error injection
+
+_require_fail_make_request()
+{
+    [ -f "$DEBUGFS_MNT/fail_make_request/probability" ] \
+	|| _notrun "$DEBUGFS_MNT/fail_make_request \
+ not found. Seems that CONFIG_FAULT_INJECTION_DEBUG_FS kernel config option not enabled"
+}
+
+_allow_fail_make_request()
+{
+    local prob="${1:-100}"
+    local times="${2:-9999999}"
+    local verbose="${3:-0}"
+
+    echo "Allow global fail_make_request feature"
+    echo "$prob" > $DEBUGFS_MNT/fail_make_request/probability
+    echo "$times" > $DEBUGFS_MNT/fail_make_request/times
+    echo "$verbose" > $DEBUGFS_MNT/fail_make_request/verbose
+}
+
+_disallow_fail_make_request()
+{
+    echo "Disallow global fail_make_request feature"
+    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 0 > $DEBUGFS_MNT/fail_make_request/times
+    echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
+}
+
+_start_fail_scratch_dev()
+{
+    local SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
+    echo "Force SCRATCH_DEV device failure"
+    echo " echo 1 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
+    echo 1 > $SYSFS_BDEV/make-it-fail
+}
+
+_stop_fail_scratch_dev()
+{
+    local SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
+    echo "Make SCRATCH_DEV device operable again"
+    echo " echo 0 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
+    echo 0 > $SYSFS_BDEV/make-it-fail
+}
diff --git a/common/rc b/common/rc
index b82bb36b..63bafb4b 100644
--- a/common/rc
+++ b/common/rc
@@ -2739,13 +2739,6 @@ _require_debugfs()
     [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
 }
 
-_require_fail_make_request()
-{
-    [ -f "$DEBUGFS_MNT/fail_make_request/probability" ] \
-	|| _notrun "$DEBUGFS_MNT/fail_make_request \
- not found. Seems that CONFIG_FAULT_INJECTION_DEBUG_FS kernel config option not enabled"
-}
-
 # The default behavior of SEEK_HOLE is to always return EOF.
 # Filesystems that implement non-default behavior return the offset
 # of holes with SEEK_HOLE. There is no way to query the filesystem
diff --git a/tests/btrfs/088 b/tests/btrfs/088
index d9c5528b..59972ae7 100755
--- a/tests/btrfs/088
+++ b/tests/btrfs/088
@@ -18,27 +18,23 @@ _begin_fstest auto quick metadata
 
 # Import common functions.
 . ./common/filter
+. ./common/fail_make_request
 
 # real QA test starts here
 _supported_fs btrfs
 _require_scratch
 _require_fail_make_request
 
-SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
-
 enable_io_failure()
 {
-	echo 100 > $DEBUGFS_MNT/fail_make_request/probability
-	echo 1000 > $DEBUGFS_MNT/fail_make_request/times
-	echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
-	echo 1 > $SYSFS_BDEV/make-it-fail
+	_allow_fail_make_request 100 1000 > /dev/null
+	_start_fail_scratch_dev > /dev/null
 }
 
 disable_io_failure()
 {
-	echo 0 > $SYSFS_BDEV/make-it-fail
-	echo 0 > $DEBUGFS_MNT/fail_make_request/probability
-	echo 0 > $DEBUGFS_MNT/fail_make_request/times
+	_stop_fail_scratch_dev > /dev/null
+	_disallow_fail_make_request > /dev/null
 }
 
 # We will abort a btrfs transaction later, which always produces a warning in
diff --git a/tests/btrfs/150 b/tests/btrfs/150
index c5e9c709..a7d7d9cc 100755
--- a/tests/btrfs/150
+++ b/tests/btrfs/150
@@ -15,6 +15,7 @@ _begin_fstest auto quick dangerous read_repair
 
 # Import common functions.
 . ./common/filter
+. ./common/fail_make_request
 
 # real QA test starts here
 
@@ -25,22 +26,18 @@ _require_fail_make_request
 _require_scratch_dev_pool 2
 _scratch_dev_pool_get 2
 
-SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
 enable_io_failure()
 {
-	echo 100 > $DEBUGFS_MNT/fail_make_request/probability
-	echo 1000 > $DEBUGFS_MNT/fail_make_request/times
-	echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
+	_allow_fail_make_request 100 1000 > /dev/null
 	echo 1 > $DEBUGFS_MNT/fail_make_request/task-filter
-	echo 1 > $SYSFS_BDEV/make-it-fail
+	_start_fail_scratch_dev > /dev/null
 }
 
 disable_io_failure()
 {
-	echo 0 > $DEBUGFS_MNT/fail_make_request/probability
-	echo 0 > $DEBUGFS_MNT/fail_make_request/times
+	_disallow_fail_make_request > /dev/null
 	echo 0 > $DEBUGFS_MNT/fail_make_request/task-filter
-	echo 0 > $SYSFS_BDEV/make-it-fail
+	_stop_fail_scratch_dev > /dev/null
 }
 
 _check_minimal_fs_size $(( 1024 * 1024 * 1024 ))
diff --git a/tests/generic/019 b/tests/generic/019
index 45c91624..b68dd90c 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -14,47 +14,17 @@ fio_config=$tmp.fio
 
 # Import common functions.
 . ./common/filter
+. ./common/fail_make_request
 _supported_fs generic
 _require_scratch
 _require_block_device $SCRATCH_DEV
 _require_fail_make_request
 
-SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
-
-allow_fail_make_request()
-{
-    echo "Allow global fail_make_request feature"
-    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
-    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
-    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
-}
-
-disallow_fail_make_request()
-{
-    echo "Disallow global fail_make_request feature"
-    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
-    echo 0 > $DEBUGFS_MNT/fail_make_request/times
-}
-
-start_fail_scratch_dev()
-{
-    echo "Force SCRATCH_DEV device failure"
-    echo " echo 1 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
-    echo 1 > $SYSFS_BDEV/make-it-fail
-}
-
-stop_fail_scratch_dev()
-{
-    echo "Make SCRATCH_DEV device operable again"
-    echo " echo 0 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
-    echo 0 > $SYSFS_BDEV/make-it-fail
-}
-
 # Override the default cleanup function.
 _cleanup()
 {
 	kill $fs_pid $fio_pid &> /dev/null
-	disallow_fail_make_request
+	_disallow_fail_make_request
 	cd /
 	rm -r -f $tmp.*
 }
@@ -129,7 +99,7 @@ _workout()
 
 	# Let's it work for awhile, and force device failure
 	sleep $RUN_TIME
-	start_fail_scratch_dev
+	_start_fail_scratch_dev
 	# After device turns in to failed state filesystem may yet not know about
 	# that so buffered write(2) may succeed, but any integrity operations
 	# such as (sync, fsync, fdatasync, direct-io) should fail.
@@ -147,7 +117,7 @@ _workout()
 	run_check _scratch_unmount
 	# Once filesystem was umounted no one is able to write to block device
 	# It is now safe to bring device back to normal state
-	stop_fail_scratch_dev
+	_stop_fail_scratch_dev
 
 	# In order to check that filesystem is able to recover journal on mount(2)
 	# perform mount/umount, after that all errors should be fixed
@@ -159,7 +129,7 @@ _workout()
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
-allow_fail_make_request
+_allow_fail_make_request
 _workout
 status=$?
 exit

