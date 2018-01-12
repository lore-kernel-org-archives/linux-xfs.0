Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932860AbeALEQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 23:16:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0C4E8GZ017814
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 20:16:45 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2fejmxgp1y-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 20:16:45 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v4 2/3] xfs/realtime: Default rtinherit=1, add _require_no_rtinherit function
Date: Thu, 11 Jan 2018 20:16:18 -0800
Message-ID: <20180112041619.540900-3-rwareing@fb.com>
In-Reply-To: <20180112041619.540900-1-rwareing@fb.com>
References: <20180112041619.540900-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: darrick.wong@oracle.com, eguan@redhat.com, linux-xfs@vger.kernel.org

To better exercise the data path code of realtime subvolumes, we will
set rtinherit=1 during mkfs calls.  For tests which this is not desired
we introduce a _require_no_rtinherit function to opt out of this
behavior.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v3:
* XFS FS check in _require_no_rtinherit
* Fixed comment for _require_no_rtinherit to reflect (reworked) function

Changes since v2:
* Removed use of RT_INHERT, instead we now simply bail from the test.  Users
  will have to create two separate configs for realtime one with rtinherit=1
  in the mkfs options, one without and do separate runs to get full test
  coverage.
* Added comments explaining reasons for _require_no_rtinherit declarations

Changes since v1:
* None

 common/rc         | 10 ++++++++++
 tests/generic/250 |  3 +++
 tests/generic/252 |  3 +++
 tests/generic/441 |  3 +++
 tests/xfs/170     |  1 +
 5 files changed, 20 insertions(+)

diff --git a/common/rc b/common/rc
index 76f9d69..cceabce 100644
--- a/common/rc
+++ b/common/rc
@@ -33,6 +33,16 @@ BC=$(which bc 2> /dev/null) || BC=
 VALID_TEST_ID="[0-9]\{3\}"
 VALID_TEST_NAME="$VALID_TEST_ID-\?[[:alnum:]-]*"
 
+# Some tests are not relevant or functional when testing XFS realtime
+# subvolumes along with the rtinherit=1 mkfs option.  In these cases,
+# this test will opt-out of the test.
+_require_no_rtinherit()
+{
+  [ "$FSTYP" = "xfs" ] && echo "$MKFS_OPTIONS" | 
+    egrep -q "rtinherit([^=]|=1)" && \
+    _notrun "rtinherit mkfs option is not supported by this test."
+}
+
 _require_math()
 {
 	if [ -z "$BC" ]; then
diff --git a/tests/generic/250 b/tests/generic/250
index 3c4fe6d..a8fd97e 100755
--- a/tests/generic/250
+++ b/tests/generic/250
@@ -48,6 +48,9 @@ _require_scratch
 _require_dm_target error
 _require_xfs_io_command "falloc"
 _require_odirect
+# This test uses "dm" without taking into account the data could be on
+# realtime subvolume, thus the test will fail with rtinherit=1
+_require_no_rtinherit
 
 rm -f $seqres.full
 
diff --git a/tests/generic/252 b/tests/generic/252
index ffedd56..b506d59 100755
--- a/tests/generic/252
+++ b/tests/generic/252
@@ -47,6 +47,9 @@ _supported_os Linux
 _require_scratch
 _require_dm_target error
 _require_xfs_io_command "falloc"
+# This test uses "dm" without taking into account the data could be on
+# realtime subvolume, thus the test will fail with rtinherit=1
+_require_no_rtinherit
 _require_aiodio "aiocp"
 AIO_TEST="src/aio-dio-regress/aiocp"
 
diff --git a/tests/generic/441 b/tests/generic/441
index 075d877..5fbfece 100755
--- a/tests/generic/441
+++ b/tests/generic/441
@@ -47,6 +47,9 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch
+# This test uses "dm" without taking into account the data could be on
+# realtime subvolume, thus the test will fail with rtinherit=1
+_require_no_rtinherit
 
 # Generally, we want to avoid journal errors on the extended testcase. Only
 # unset the -s flag if we have a logdev
diff --git a/tests/xfs/170 b/tests/xfs/170
index c5ae8e4..6deef1b 100755
--- a/tests/xfs/170
+++ b/tests/xfs/170
@@ -50,6 +50,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
-- 
2.9.5

