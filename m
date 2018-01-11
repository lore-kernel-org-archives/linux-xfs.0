Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753896AbeAKGmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 01:42:19 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v4 2/4] dmflakey: support error_writes feature for dm-flakey
Date: Thu, 11 Jan 2018 14:49:31 +0800
Message-ID: <20180111064933.12088-3-houtao1@huawei.com>
In-Reply-To: <20180111064933.12088-1-houtao1@huawei.com>
References: <20180111064933.12088-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Add _require_flakey_with_error_writes() to check the availability of
dm-flakey target and its error_writes feature, and support for enabling
FLAKEY_TABLE_ERROR table by passing FLAKEY_ERROR_WRITES to
_load_flakey_table().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v4: call _cleanup_flakey() directly instead of copy & paste
---
 common/dmflakey | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/common/dmflakey b/common/dmflakey
index e34fce8..06eee37 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -20,6 +20,7 @@
 
 FLAKEY_ALLOW_WRITES=0
 FLAKEY_DROP_WRITES=1
+FLAKEY_ERROR_WRITES=2
 
 echo $MOUNT_OPTIONS | grep -q dax
 if [ $? -eq 0 ]; then
@@ -32,6 +33,7 @@ _init_flakey()
 	FLAKEY_DEV=/dev/mapper/flakey-test
 	FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
 	FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"
+	FLAKEY_TABLE_ERROR="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 error_writes"
 	$DMSETUP_PROG create flakey-test --table "$FLAKEY_TABLE" || \
 		_fatal "failed to create flakey device"
 	$DMSETUP_PROG mknodes > /dev/null 2>&1
@@ -67,9 +69,9 @@ _cleanup_flakey()
 # table, so it simulates power failure.
 _load_flakey_table()
 {
-
 	table="$FLAKEY_TABLE"
 	[ $1 -eq $FLAKEY_DROP_WRITES ] && table="$FLAKEY_TABLE_DROP"
+	[ $1 -eq $FLAKEY_ERROR_WRITES ] && table="$FLAKEY_TABLE_ERROR"
 
 	suspend_opt="--nolockfs"
 	[ $# -gt 1 ] && [ $2 -eq 1 ] && suspend_opt=""
@@ -101,3 +103,23 @@ _flakey_drop_and_remount()
 	_load_flakey_table $FLAKEY_ALLOW_WRITES
 	_mount_flakey
 }
+
+_require_flakey_with_error_writes()
+{
+	local SIZE
+	local TABLE
+	local NAME=flakey-test
+
+	_require_dm_target flakey
+
+	SIZE=`blockdev --getsz $SCRATCH_DEV`
+	TABLE="0 $SIZE flakey $SCRATCH_DEV 0 0 180 1 error_writes"
+
+	$DMSETUP_PROG create $NAME --table "$TABLE" >/dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_notrun "This test requires error_writes feature in dm-flakey"
+	fi
+	$DMSETUP_PROG mknodes >/dev/null 2>&1
+
+	_cleanup_flakey
+}
-- 
2.9.5

