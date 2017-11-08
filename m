Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:53840 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751040AbdKHH5I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:57:08 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v2 2/4] common/rc: support checking the version of dm-target in _require_dm_target()
Date: Wed, 8 Nov 2017 16:02:48 +0800
Message-ID: <20171108080250.5662-3-houtao1@huawei.com>
In-Reply-To: <20171108080250.5662-1-houtao1@huawei.com>
References: <20171108080250.5662-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Some features of dm-target are not available on the old linux kernel,
and we can use the version of dm-target to check the availability.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 common/rc | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/common/rc b/common/rc
index e2a8229..9ea84ba 100644
--- a/common/rc
+++ b/common/rc
@@ -1779,10 +1779,12 @@ _require_sane_bdev_flush()
 	fi
 }
 
-# this test requires a specific device mapper target
+# this test requires a specific device mapper target and
+# an optional version number (e.g., 1.4.0)
 _require_dm_target()
 {
-	_target=$1
+	local target=$1
+	local version=$2
 
 	# require SCRATCH_DEV to be a valid block device with sane BLKFLSBUF
 	# behaviour
@@ -1790,11 +1792,38 @@ _require_dm_target()
 	_require_sane_bdev_flush $SCRATCH_DEV
 	_require_command "$DMSETUP_PROG" dmsetup
 
-	modprobe dm-$_target >/dev/null 2>&1
+	modprobe dm-$target >/dev/null 2>&1
 
-	$DMSETUP_PROG targets 2>&1 | grep -q ^$_target
+	$DMSETUP_PROG targets 2>&1 | grep -q ^$target
 	if [ $? -ne 0 ]; then
-		_notrun "This test requires dm $_target support"
+		_notrun "This test requires dm $target support"
+	fi
+
+	if [ -n "$version" ]; then
+		local got
+
+		got=$($DMSETUP_PROG targets 2>&1 | \
+				awk -v tgt=$target '$0 ~ tgt {sub("v", "", $2); print $2}')
+		if [ -z "$got" ]; then
+			_notrun "This test requires dm $target $version at least (got unknown)"
+		fi
+
+		awk -v min=$version -v got=$got '
+		BEGIN \
+		{
+			cmin = split(min, amin, ".");
+			cgot = split(got, agot, ".");
+			for (i = 1; i <= cgot && i <= cmin; i++) {
+				if (agot[i] != amin[i]) {
+					exit(agot[i] < amin[i]);
+				}
+			}
+			exit(cgot < cmin);
+		}
+		'
+		if [ $? -ne 0 ]; then
+			_notrun "This test requires dm $target $version at least (got $got)"
+		fi
 	fi
 }
 
-- 
2.9.5

