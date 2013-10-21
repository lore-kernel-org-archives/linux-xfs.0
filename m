Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E62327F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:02:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B83FF304066
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 06:02:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GRGbJGb7uT2A3M6b for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 06:01:58 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9LD1w2D006956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:01:58 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests generic/320: heavy rm workload test
Date: Mon, 21 Oct 2013 21:01:24 +0800
Message-Id: <1382360484-6570-1-git-send-email-eguan@redhat.com>
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

This test is based on generic/273, a regression test for commit

9a3a5da xfs: check for stale inode before acquiring iflock on push

On unpatched kernel, rm processes would hang.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/320     | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/320.out |   2 +
 tests/generic/group   |   2 +-
 3 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/320
 create mode 100644 tests/generic/320.out

diff --git a/tests/generic/320 b/tests/generic/320
new file mode 100755
index 0000000..afe35a3
--- /dev/null
+++ b/tests/generic/320
@@ -0,0 +1,139 @@
+#! /bin/bash
+# FS QA Test No. generic/320
+#
+# heavy rm workload
+#
+# Regression test for commit:
+# 9a3a5da xfs: check for stale inode before acquiring iflock on push
+#
+# Based on generic/273
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+#
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
+	rm -rf $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+
+threads=50
+count=2
+
+_threads_set()
+{
+	_cpu_num=`grep -c processor /proc/cpuinfo`
+	threads=$(($_cpu_num * 50))
+	if [ $threads -gt 200 ]
+	then
+		threads=200
+	fi
+}
+
+_file_create()
+{
+	_i=0
+
+	if ! mkdir $SCRATCH_MNT/origin
+	then
+		echo "mkdir origin err"
+		status=1
+		exit
+	fi
+
+	cd $SCRATCH_MNT/origin
+
+	_disksize=`df --block-size=1 $SCRATCH_DEV | $AWK_PROG -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
+	_disksize=$(($_disksize / 3))
+	_num=$(($_disksize / $count / $threads / 4096))
+	_count=$count
+	while [ $_i -lt $_num ]
+	do
+		dd if=/dev/zero of=file_$_i bs=4096 count=$_count >/dev/null 2>&1
+		_i=$(($_i + 1))
+	done
+
+	cd $here
+}
+
+_worker()
+{
+	_suffix=$1
+
+	if ! mkdir $SCRATCH_MNT/sub_$_suffix
+	then
+		echo "mkdir sub_xxx err"
+		status=1
+		exit
+	fi
+
+	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seqres.full 2>&1
+	rm -rf $SCRATCH_MNT/sub_$_suffix
+}
+
+_do_workload()
+{
+	_pids=""
+	_pid=1
+
+	_threads_set
+	_file_create
+
+	_threads=$threads
+
+	while [ $_pid -lt $_threads ]
+	do
+		_worker $_pid &
+		_pids="$_pids $!"
+		_pid=$(($_pid + 1))
+	done
+
+	wait $_pids
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+echo "Silence is golden"
+
+rm -f $seqres.full
+
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+_do_workload
+
+_check_scratch_fs
+status=$?
+exit
diff --git a/tests/generic/320.out b/tests/generic/320.out
new file mode 100644
index 0000000..1c4165d
--- /dev/null
+++ b/tests/generic/320.out
@@ -0,0 +1,2 @@
+QA output created by 320
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 3488c42..40da6dc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -122,4 +122,4 @@
 317 auto metadata quick
 318 acl attr auto quick
 319 acl auto quick
-
+320 auto rw
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
