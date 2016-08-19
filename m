Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A305F7CA2
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 12:51:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09D1FAC003
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 10:51:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8jcZxlaQ90gZOQTs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 10:51:53 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 2/2] fstests: xfs EIO error handling test
Date: Sat, 20 Aug 2016 01:51:45 +0800
Message-Id: <1471629105-13359-2-git-send-email-zlang@redhat.com>
In-Reply-To: <1471629105-13359-1-git-send-email-zlang@redhat.com>
References: <1471629105-13359-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

Besides fail_at_unmount, all EIO error handling can stop umount
hanging on IO error too.

This case test EIO/max_retries and EIO/retry_timeout_seconds as
below:

1) fail_at_unmount=0 && \
   EIO/max_retries=1 && \
   EIO/retry_timeout_seconds=0

2) fail_at_unmount=0 && \
   EIO/max_retries=-1 && \
   EIO/retry_timeout_seconds=1

Make sure when fail_at_unmount=0, umount won't hang there.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/263     | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263.out |  21 +++++++++
 tests/xfs/group   |   1 +
 3 files changed, 148 insertions(+)
 create mode 100755 tests/xfs/263
 create mode 100644 tests/xfs/263.out

diff --git a/tests/xfs/263 b/tests/xfs/263
new file mode 100755
index 0000000..2df139c
--- /dev/null
+++ b/tests/xfs/263
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test 263
+#
+# Test XFS EIO error handling configuration. Stop XFS from retrying
+# to writeback forever when hit EIO.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_dm_target error
+_require_scratch
+_require_fs_sysfs error/fail_at_unmount
+_require_fs_sysfs error/metadata/EIO/max_retries
+_require_fs_sysfs error/metadata/EIO/retry_timeout_seconds
+
+_scratch_mkfs >> $seqres.full 2>&1
+_dmerror_init
+
+do_test()
+{
+	local attr="$1"
+	local num=0
+
+	_dmerror_mount
+	reset_xfs_sysfs_error_handling $DMERROR_DEV
+	# Disable fail_at_unmount before test EIO error handling
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
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
new file mode 100644
index 0000000..714350f
--- /dev/null
+++ b/tests/xfs/263.out
@@ -0,0 +1,21 @@
+QA output created by 263
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
diff --git a/tests/xfs/group b/tests/xfs/group
index 6905a62..ec3c022 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -260,6 +260,7 @@
 260 auto quick quota
 261 auto quick quota
 262 auto quick quota
+263 auto quick mount
 265 auto clone
 266 dump ioctl auto quick
 267 dump ioctl tape
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
