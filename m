Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751580AbdF1Low (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 07:44:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs/141: use new errortag knob for crc error injection
Date: Wed, 28 Jun 2017 07:44:50 -0400
Message-Id: <20170628114450.9670-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Update the test to use the newly available sysfs errortag injection
knobs. The errortag knob has replaced the previous custom knob in
the kernel. Create a local helper to support the old knob for
backwards compatibility.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This updates xfs/141 to use the new error injection tag sysfs knob that
has replaced log_badcrc_factor in the latest XFS for-next tree.

Brian

 tests/xfs/141 | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/141 b/tests/xfs/141
index 56ff14e..ea4f558 100755
--- a/tests/xfs/141
+++ b/tests/xfs/141
@@ -43,6 +43,21 @@ _cleanup()
 	wait > /dev/null 2>&1
 }
 
+# require either the current error tag or the old custom log record crc error
+# injection knob
+_setup_bad_crc()
+{
+	if [ -e /sys/fs/xfs/$1/errortag/log_bad_crc ]; then
+		badcrc_attr=/sys/fs/xfs/$1/errortag/log_bad_crc
+		return
+	fi
+	if [ -e /sys/fs/xfs/$1/log/log_badcrc_factor ]; then
+		badcrc_attr=/sys/fs/xfs/$1/log/log_badcrc_factor
+		return
+	fi
+	_notrun "bad crc sysfs attribute not supported"
+}
+
 rm -f $seqres.full
 
 # get standard environment, filters and checks
@@ -53,7 +68,6 @@ rm -f $seqres.full
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os Linux
-_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_badcrc_factor
 _require_scratch
 _require_command "$KILLALL_PROG" killall
 
@@ -62,14 +76,14 @@ echo "Silence is golden."
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
-sdev=$(_short_dev $SCRATCH_DEV)
+_setup_bad_crc $(_short_dev $SCRATCH_DEV)
 
 for i in $(seq 1 5); do
 	# Enable error injection. Use a random bad crc factor up to 100
 	# (increase this value to run fsstress longer).
 	factor=$((RANDOM % 100 + 1))
-	echo iteration $i log_badcrc_factor: $factor >> $seqres.full 2>&1
-	echo $factor > /sys/fs/xfs/$sdev/log/log_badcrc_factor
+	echo iteration $i bad crc factor: $factor >> $seqres.full 2>&1
+	echo $factor > $badcrc_attr
 
 	# Run fsstress until the filesystem shuts down. It will shut down
 	# automatically when error injection triggers.
-- 
2.9.4

