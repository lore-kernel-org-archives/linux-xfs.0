Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1450C7CA0
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 09:44:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC31A8F8037
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 07:43:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2c7x75Ogc4ssvgdc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 07:43:58 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs/006: add EIO error handling test
Date: Sun, 31 Jul 2016 22:43:54 +0800
Message-Id: <1469976234-15121-1-git-send-email-zlang@redhat.com>
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
To: fstests@vger.kernel.org
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, eguan@redhat.com, xfs@oss.sgi.com

Except fail_at_unmount, all EIO error handling can stop umount hanging
on IO error too. This case only tested fail_at_unmount before, so add
EIO/max_retries and EIO/retry_timeout_seconds test.

Now this case test three situation when unmount hit EIO:
1) fail_at_unmount=1 && \
   EIO/max_retries=-1 && \
   EIO/retry_timeout_seconds=0

2) fail_at_unmount=0 && \
   EIO/max_retries=1 && \
   EIO/retry_timeout_seconds=0

3) fail_at_unmount=0 && \
   EIO/max_retries=-1 && \
   EIO/retry_timeout_seconds=1

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

There're three patches from Eric fix XFS error handling bugs:
  5539d36 xfs: don't reset b_retries to 0 on every failure
  0b4db5d xfs: remove extraneous buffer flag changes
  e97f6c5 xfs: fix xfs_error_get_cfg for negative errnos

Without these patches, configurable error handling cannot be properly
set, and once set is not honored.

For test part of this bug, add EIO error handling test into xfs/006.
The kernel with above 3 patches shouldn't hang on xfs/006.

I haven't got an idea about how to test ENOSPC and default error
handling. So use EIO test to prove above patches can work well
on EIO handling at least.

Thanks,
Zorro

 tests/xfs/006     | 153 ++++++++++++++++++++++++++++++++++--------------------
 tests/xfs/006.out |  24 +++++++++
 2 files changed, 122 insertions(+), 55 deletions(-)

diff --git a/tests/xfs/006 b/tests/xfs/006
index 8910026..9e43eef 100755
--- a/tests/xfs/006
+++ b/tests/xfs/006
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test 006
 #
-# Test xfs' "fail at unmount" error handling configuration. Stop
+# Test "fail_at_umount" and EIO error handling configuration. Stop
 # XFS from retrying to writeback forever at unmount.
 #
 #-----------------------------------------------------------------------
@@ -35,6 +35,9 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
+	# prevent test hanging if someone kill this process
+	# after just setting fail_at_unmount=0
+	reset_error_handling >/dev/null 2>&1
 	_dmerror_cleanup
 }
 
@@ -52,64 +55,104 @@ _supported_os Linux
 _require_dm_target error
 _require_scratch
 _require_fs_sysfs error/fail_at_unmount
+_require_fs_sysfs error/metadata/EIO/max_retries
+_require_fs_sysfs error/metadata/EIO/retry_timeout_seconds
 
-_scratch_mkfs > $seqres.full 2>&1
+_scratch_mkfs >> $seqres.full 2>&1
 _dmerror_init
-_dmerror_mount
 
+reset_error_handling()
+{
+	_set_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount 1
+	echo -n "error/fail_at_unmount="
+	_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount
+
+	# Make sure all will be configured to retry forever by default, except
+	# for ENODEV, which is an unrecoverable error, so it will be configured
+	# to not retry on error by default.
+	for e in default EIO ENOSPC; do
+		_set_fs_sysfs_attr $DMERROR_DEV \
+				   error/metadata/${e}/max_retries -1
+		echo -n "error/metadata/${e}/max_retries="
+		_get_fs_sysfs_attr $DMERROR_DEV error/metadata/${e}/max_retries
+
+		_set_fs_sysfs_attr $DMERROR_DEV \
+				   error/metadata/${e}/retry_timeout_seconds 0
+		echo -n "error/metadata/${e}/retry_timeout_seconds="
+		_get_fs_sysfs_attr $DMERROR_DEV \
+				   error/metadata/${e}/retry_timeout_seconds
+	done
+}
+
+do_test()
+{
+	local attr="$1"
+	local num=0
+
+	_dmerror_mount
+	reset_error_handling
+	# Disable fail_at_unmount at every test beginning
+	# Wait for later operations on it
+	_set_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount 0
+	echo -n "error/fail_at_unmount="
+	_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount
+
+	_set_fs_sysfs_attr $DMERROR_DEV $attr 1
+	num=`_get_fs_sysfs_attr $DMERROR_DEV $attr`
+	echo "$attr=$num"
+	# _fail the test if we fail to set $attr to 1, because the test
+	# probably will hang in such case and block subsequent tests.
+	if [ "$num" != "1" ]; then
+		_fail "Failed to set $attr: 1"
+	fi
+
+	# start a metadata-intensive workload, but no data allocation operation.
+	# Because uncompleted new space allocation I/Os may cause XFS to shutdown
+	# after loading error table.
+	$FSSTRESS_PROG -z -n 5000 -p 10 \
+		       -f creat=10 \
+		       -f resvsp=1 \
+		       -f truncate=1 \
+		       -f punch=1 \
+		       -f chown=5 \
+		       -f mkdir=5 \
+		       -f rmdir=1 \
+		       -f mknod=1 \
+		       -f unlink=1 \
+		       -f symlink=1 \
+		       -f rename=1 \
+		       -d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
+
+	# Loading error table without "--nolockfs" option. Because "--nolockfs"
+	# won't freeze fs, then some running I/Os may cause XFS to shutdown
+	# prematurely. That's not what we want to test.
+	_dmerror_load_error_table lockfs
+	_dmerror_unmount
+
+	# Mount again to replay log after loading working table, so we have a
+	# consistent XFS after test.
+	_dmerror_load_working_table
+	_dmerror_mount
+	_dmerror_unmount
+}
+
+#### Test fail_at_unmount ####
 # Enable fail_at_unmount, so XFS stops retrying on errors at unmount
-# time. _fail the test if we fail to set it to 1, because the test
-# probably will hang in such case and block subsequent tests.
-_set_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount 1
-attr=`_get_fs_sysfs_attr $DMERROR_DEV error/fail_at_unmount`
-if [ "$attr" != "1" ]; then
-	_fail "Failed to set error/fail_at_unmount: $attr"
-fi
-
-# Make sure all will be configured to retry forever by default, except
-# for ENODEV, which is an unrecoverable error, so it will be configured
-# to not retry on error by default.
-for e in default EIO ENOSPC; do
-	_set_fs_sysfs_attr $DMERROR_DEV \
-			   error/metadata/${e}/max_retries -1
-	echo -n "error/metadata/${e}/max_retries="
-	_get_fs_sysfs_attr $DMERROR_DEV error/metadata/${e}/max_retries
-
-	_set_fs_sysfs_attr $DMERROR_DEV \
-			   error/metadata/${e}/retry_timeout_seconds 0
-	echo -n "error/metadata/${e}/retry_timeout_seconds="
-	_get_fs_sysfs_attr $DMERROR_DEV \
-			   error/metadata/${e}/retry_timeout_seconds
-done
-
-# start a metadata-intensive workload, but no data allocation operation.
-# Because uncompleted new space allocation I/Os may cause XFS to shutdown
-# after loading error table.
-$FSSTRESS_PROG -z -n 5000 -p 10 \
-	       -f creat=10 \
-	       -f resvsp=1 \
-	       -f truncate=1 \
-	       -f punch=1 \
-	       -f chown=5 \
-	       -f mkdir=5 \
-	       -f rmdir=1 \
-	       -f mknod=1 \
-	       -f unlink=1 \
-	       -f symlink=1 \
-	       -f rename=1 \
-	       -d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
-
-# Loading error table without "--nolockfs" option. Because "--nolockfs"
-# won't freeze fs, then some running I/Os may cause XFS to shutdown
-# prematurely. That's not what we want to test.
-_dmerror_load_error_table lockfs
-_dmerror_unmount
-
-# Mount again to replay log after loading working table, so we have a
-# consistent XFS after test.
-_dmerror_load_working_table
-_dmerror_mount
-_dmerror_unmount
+# time.
+echo "=== Test fail_at_unmount ==="
+do_test error/fail_at_unmount
+
+#### Test EIO/max_retries ####
+# Set EIO/max_retries a limited number(>-1), then even if fail_at_unmount=0,
+# the test won't hang.
+echo "=== Test EIO/max_retries ==="
+do_test error/metadata/EIO/max_retries
+
+#### Test EIO/retry_timeout_seconds ####
+# Set EIO/retry_timeout_seconds to a limited number(>0), then even if
+# fail_at_unmount=0, the test won't hang.
+echo "=== Test EIO/retry_timeout_seconds ==="
+do_test error/metadata/EIO/retry_timeout_seconds
 
 # success, all done
 status=0
diff --git a/tests/xfs/006.out b/tests/xfs/006.out
index 393f411..d15e337 100644
--- a/tests/xfs/006.out
+++ b/tests/xfs/006.out
@@ -1,7 +1,31 @@
 QA output created by 006
+=== Test fail_at_unmount ===
+error/fail_at_unmount=1
 error/metadata/default/max_retries=-1
 error/metadata/default/retry_timeout_seconds=0
 error/metadata/EIO/max_retries=-1
 error/metadata/EIO/retry_timeout_seconds=0
 error/metadata/ENOSPC/max_retries=-1
 error/metadata/ENOSPC/retry_timeout_seconds=0
+error/fail_at_unmount=0
+error/fail_at_unmount=1
+=== Test EIO/max_retries ===
+error/fail_at_unmount=1
+error/metadata/default/max_retries=-1
+error/metadata/default/retry_timeout_seconds=0
+error/metadata/EIO/max_retries=-1
+error/metadata/EIO/retry_timeout_seconds=0
+error/metadata/ENOSPC/max_retries=-1
+error/metadata/ENOSPC/retry_timeout_seconds=0
+error/fail_at_unmount=0
+error/metadata/EIO/max_retries=1
+=== Test EIO/retry_timeout_seconds ===
+error/fail_at_unmount=1
+error/metadata/default/max_retries=-1
+error/metadata/default/retry_timeout_seconds=0
+error/metadata/EIO/max_retries=-1
+error/metadata/EIO/retry_timeout_seconds=0
+error/metadata/ENOSPC/max_retries=-1
+error/metadata/ENOSPC/retry_timeout_seconds=0
+error/fail_at_unmount=0
+error/metadata/EIO/retry_timeout_seconds=1
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
