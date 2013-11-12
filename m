Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 423B37F59
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 02:58:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BF908F8033
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 00:58:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gGcIg6SUoJzXFEss for
	<xfs@oss.sgi.com>; Tue, 12 Nov 2013 00:58:30 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAC8wTjx027229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 03:58:29 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3] xfstests generic/320: heavy rm workload test
Date: Tue, 12 Nov 2013 15:59:44 +0800
Message-Id: <1384243184-19406-1-git-send-email-eguan@redhat.com>
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
v3: Address more comments from Dave
 - use LOAD_FACTOR to scale the workload
 - wrap long lines

v2: Address Dave's comments
 - don't check return value of mkdir
 - don't cd to origin dir
 - don't calculate fs size, already have fs size
 - use $XFS_IO_PROG instead of dd
 - remove leading "_" from local vars
 - call _supported_fs etc. functions before any local functions
 - set status=0 before exit

 tests/generic/320     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/320.out |   2 +
 tests/generic/group   |   2 +-
 3 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/320
 create mode 100644 tests/generic/320.out

diff --git a/tests/generic/320 b/tests/generic/320
new file mode 100755
index 0000000..e1ba970
--- /dev/null
+++ b/tests/generic/320
@@ -0,0 +1,121 @@
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+threads=100
+count=2
+fs_size=$((2 * 1024 * 1024 * 1024))
+ORIGIN=$SCRATCH_MNT/origin
+
+threads_set()
+{
+	threads=$((LOAD_FACTOR * 100))
+	if [ $threads -gt 200 ]
+	then
+		threads=200
+	fi
+}
+
+file_create()
+{
+	i=0
+	mkdir $ORIGIN
+
+	disksize=$(($fs_size / 3))
+	num=$(($disksize / $count / $threads / 4096))
+	while [ $i -lt $num ]; do
+		$XFS_IO_PROG -f -c "pwrite 0 $((4096*count))" \
+			$ORIGIN/file_$i >>$seqres.full 2>&1
+		i=$(($i + 1))
+	done
+}
+
+worker()
+{
+	suffix=$1
+
+	mkdir $SCRATCH_MNT/sub_$suffix
+
+	cp -r $ORIGIN/* $SCRATCH_MNT/sub_$suffix >>$seqres.full 2>&1
+	rm -rf $SCRATCH_MNT/sub_$suffix
+}
+
+do_workload()
+{
+	pids=""
+	loop=1
+
+	threads_set
+	file_create
+
+	while [ $loop -lt $threads ]; do
+		worker $loop &
+		pids="$pids $!"
+		loop=$(($loop + 1))
+	done
+
+	wait $pids
+}
+
+echo "Silence is golden"
+
+rm -f $seqres.full
+
+_scratch_mkfs_sized $fs_size >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+do_workload
+
+_check_scratch_fs
+status=0
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
