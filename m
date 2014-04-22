Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B23D7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 22:27:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D7E3AC005
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 20:27:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wKkQ40ylfmqPbMOD for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 20:27:40 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3M3ReF7023966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 23:27:40 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] common: new function to get real device path name and basename
Date: Tue, 22 Apr 2014 11:27:27 +0800
Message-Id: <1398137247-4883-1-git-send-email-eguan@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

If TEST_DEV or SCRATCH_DEV is symlink(mostly a lvm lv), a simple
basename is not enough, symlink should be followed.

This task is common enough, so introduce new helper functions and
replace all readlink calls in

ext4/305
generic/009
generic/019
generic/285
generic/312

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc         | 16 ++++++++++++++++
 tests/ext4/305    |  2 +-
 tests/generic/009 |  2 +-
 tests/generic/019 |  4 +---
 tests/generic/285 |  2 +-
 tests/generic/312 |  2 +-
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index acf419b..68b040d 100644
--- a/common/rc
+++ b/common/rc
@@ -2302,6 +2302,22 @@ init_rc()
 	export XFS_IO_PROG="$XFS_IO_PROG -F"
 }
 
+# get real device path name by following link
+_real_dev()
+{
+	local _dev=$1
+	if [ -b "$_dev" ] && [ -L "$_dev" ]; then
+		_dev=`readlink -f "$_dev"`
+	fi
+	echo $_dev
+}
+
+# basename of a device
+_basename_dev()
+{
+	echo `basename $(_real_dev $1)`
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/ext4/305 b/tests/ext4/305
index eee461a..645f5c8 100755
--- a/tests/ext4/305
+++ b/tests/ext4/305
@@ -49,7 +49,7 @@ _require_scratch
 rm -f $seqres.full
 echo "Silence is golden"
 
-DEV_BASENAME=$(basename $(readlink -f $SCRATCH_DEV))
+DEV_BASENAME=$(_basename_dev $SCRATCH_DEV)
 echo "Start test on device $SCRATCH_DEV, basename $DEV_BASENAME" >$seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
diff --git a/tests/generic/009 b/tests/generic/009
index b7b0b3f..0886594 100644
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -50,7 +50,7 @@ testfile=$TEST_DIR/009.$$
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
-	DEV=`basename $TEST_DEV`
+	DEV=`_basename_dev $TEST_DEV`
 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
 fi
 
diff --git a/tests/generic/019 b/tests/generic/019
index 1208c49..8c37a31 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -41,9 +41,7 @@ _need_to_be_root
 _require_scratch
 _require_fail_make_request
 
-# TODO: Function are common enough to be moved to common/blkdev
-SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
-SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
+SCRATCH_BDEV=`_basename_dev $SCRATCH_DEV`
 
 allow_fail_make_request()
 {
diff --git a/tests/generic/285 b/tests/generic/285
index 8078b1c..8826023 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -48,7 +48,7 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
-	DEV=`basename $TEST_DEV`
+	DEV=`_basename_dev $TEST_DEV`
 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
 fi
 
diff --git a/tests/generic/312 b/tests/generic/312
index eaec43c..a81b0df 100755
--- a/tests/generic/312
+++ b/tests/generic/312
@@ -52,7 +52,7 @@ _require_scratch
 # 5G in byte
 fssize=$((2**30 * 5))
 required_blocks=$(($fssize / 1024))
-dev_blocks=$(grep $(basename $(readlink -f $SCRATCH_DEV)) /proc/partitions | $AWK_PROG '{print $3}')
+dev_blocks=$(grep $(_basename_dev $SCRATCH_DEV) /proc/partitions | $AWK_PROG '{print $3}')
 if [ $required_blocks -gt $dev_blocks ];then
 	_notrun "this test requires \$SCRATCH_DEV has ${fssize}B space"
 fi
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
