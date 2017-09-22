Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751780AbdIVCCm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 22:02:42 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8M20Dut007158
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 19:02:42 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2d4n2g966t-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 19:02:42 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH 2/3] xfs/realtime: Default rtinherit=1, add _require_no_rtinherit function
Date: Thu, 21 Sep 2017 19:02:39 -0700
Message-ID: <20170922020240.2503987-3-rwareing@fb.com>
In-Reply-To: <20170922020240.2503987-1-rwareing@fb.com>
References: <20170922020240.2503987-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

To better exercise the data path code of realtime subvolumes, we will
set rtinherit=1 during mkfs calls.  For tests which this is not desired
we introduce a _require_no_rtinherit function to opt out of this
behavior.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
 common/rc         | 24 +++++++++++++++++++++++-
 tests/generic/250 |  1 +
 tests/generic/252 |  1 +
 tests/generic/427 |  1 +
 tests/generic/441 |  1 +
 tests/xfs/019     |  1 +
 tests/xfs/031     |  1 +
 tests/xfs/170     |  1 +
 tests/xfs/187     |  1 +
 9 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index c65b4b3..4408c47 100644
--- a/common/rc
+++ b/common/rc
@@ -33,6 +33,16 @@ BC=$(which bc 2> /dev/null) || BC=
 VALID_TEST_ID="[0-9]\{3\}"
 VALID_TEST_NAME="$VALID_TEST_ID-\?[[:alnum:]-]*"
 
+# When running tests with a realtime device configured, the realtime inherit
+# flag will be set during mkfs via -d rtinherit=1 option.  For some tests
+# this may render the test invalid (i.e. it uses a function which is not
+# supported by the realtime subvolume); to prevent failure these tests may
+# disable this behavior by calling _require_no_rtinherit .
+_require_no_rtinherit()
+{
+	RT_INHERIT=false
+}
+
 _require_math()
 {
 	if [ -z "$BC" ]; then
@@ -562,6 +572,13 @@ _scratch_do_mkfs()
 	local mkfs_status
 	local tmp=`mktemp -u`
 
+	# Add rtinherit=1 to mkfs so we exercise realtime subvolume during
+	# our tests.  Tests can opts out of this behavior by calling
+	# _require_no_rtinherit.
+	if $RT_INHERIT && echo "$mkfs_cmd" | grep rtdev &> /dev/null; then
+		extra_mkfs_options="$extra_mkfs_options -d rtinherit=1"
+	fi
+
 	# save mkfs output in case conflict means we need to run again.
 	# only the output for the mkfs that applies should be shown
 	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
@@ -760,7 +777,12 @@ _mkfs_dev()
 	;;
 
     *)
-	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
+	local extra_mkfs_options="$*"
+	# Similar behavior to the scratch variant of this
+	if $RT_INHERIT && echo $extra_mkfs_options | grep rtdev &> /dev/null; then
+		extra_mkfs_options="$extra_mkfs_options -d rtinherit=1"
+	fi
+	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $extra_mkfs_options \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	;;
     esac
diff --git a/tests/generic/250 b/tests/generic/250
index 3c4fe6d..9f4e364 100755
--- a/tests/generic/250
+++ b/tests/generic/250
@@ -48,6 +48,7 @@ _require_scratch
 _require_dm_target error
 _require_xfs_io_command "falloc"
 _require_odirect
+_require_no_rtinherit
 
 rm -f $seqres.full
 
diff --git a/tests/generic/252 b/tests/generic/252
index ffedd56..1156902 100755
--- a/tests/generic/252
+++ b/tests/generic/252
@@ -47,6 +47,7 @@ _supported_os Linux
 _require_scratch
 _require_dm_target error
 _require_xfs_io_command "falloc"
+_require_no_rtinherit
 _require_aiodio "aiocp"
 AIO_TEST="src/aio-dio-regress/aiocp"
 
diff --git a/tests/generic/427 b/tests/generic/427
index 9cde5f5..18f8476 100755
--- a/tests/generic/427
+++ b/tests/generic/427
@@ -53,6 +53,7 @@ _supported_os Linux
 _require_scratch
 _require_test_program "feature"
 _require_aiodio aio-dio-eof-race
+_require_no_rtinherit
 
 # limit the filesystem size, to save the time of filling filesystem
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
diff --git a/tests/generic/441 b/tests/generic/441
index 075d877..589069a 100755
--- a/tests/generic/441
+++ b/tests/generic/441
@@ -47,6 +47,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch
+_require_no_rtinherit
 
 # Generally, we want to avoid journal errors on the extended testcase. Only
 # unset the -s flag if we have a logdev
diff --git a/tests/xfs/019 b/tests/xfs/019
index 3e4f169..1ab8991 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -66,6 +66,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 protofile=$tmp.proto
 tempfile=$tmp.file
diff --git a/tests/xfs/031 b/tests/xfs/031
index b05f28b..321f67a 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -96,6 +96,7 @@ _supported_os Linux
 
 _require_scratch
 _require_no_large_scratch_dev
+_require_no_rtinherit
 
 # sanity test - default + one root directory entry
 # Note: must do this proto/mkfs now for later inode size calcs
diff --git a/tests/xfs/170 b/tests/xfs/170
index c5ae8e4..6deef1b 100755
--- a/tests/xfs/170
+++ b/tests/xfs/170
@@ -50,6 +50,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/187 b/tests/xfs/187
index 07ef3ae..89e7b11 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -56,6 +56,7 @@ _filter_version()
 _supported_fs xfs
 _supported_os Linux
 
+_require_no_rtinherit
 _require_scratch
 _require_attrs
 _require_attr_v1
-- 
2.9.5

