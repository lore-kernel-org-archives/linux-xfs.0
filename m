Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145926.iagghihwvyrcu5qf@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1040.oracle.com ([156.151.31.81]:21964 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdBYBM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 20:12:57 -0500
Subject: [PATCH 2/4] xfs: minor fixes to the fsmap tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 24 Feb 2017 17:12:51 -0800
Message-ID: <148798517171.25833.15263002232887612727.stgit@birch.djwong.org>
In-Reply-To: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
References: <148798515933.25833.2842247083803775089.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the fsmap tests slightly to use new helpers, and
fix some minor output scanning issues.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/273 |    3 +--
 tests/xfs/275 |    4 +---
 tests/xfs/276 |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/tests/xfs/273 b/tests/xfs/273
index 1a4ee93..f784a35 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -50,8 +50,7 @@ _require_xfs_io_command "fsmap"
 rm -f "$seqres.full"
 
 echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-_scratch_populate >> $seqres.full
+_scratch_populate_cached nofill > $seqres.full 2>&1
 
 echo "Compare fsmap" | tee -a $seqres.full
 _scratch_mount
diff --git a/tests/xfs/275 b/tests/xfs/275
index cc6d353..3ccfd77 100755
--- a/tests/xfs/275
+++ b/tests/xfs/275
@@ -42,11 +42,9 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_logdev
 _require_scratch
 _require_xfs_io_command "fsmap"
-if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_LOGDEV" ]; then
-	_notrun "Need external log device"
-fi
 
 rm -f "$seqres.full"
 
diff --git a/tests/xfs/276 b/tests/xfs/276
index cea91c9..e39b5d5 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -77,7 +77,7 @@ done
 
 echo "Check device field of FS metadata and realtime file"
 data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
-rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*[[:space:]]*[0-9]*$" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" != "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
 # success, all done

