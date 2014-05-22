Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 299967F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 04:59:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 274158F8033
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 02:59:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9lMBId8JV6kLRH1X for
	<xfs@oss.sgi.com>; Thu, 22 May 2014 02:59:16 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic: new ENOSPC regression test
Date: Thu, 22 May 2014 17:58:42 +0800
Message-Id: <1400752722-22782-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Run 8 processes writing 1k files to seperate files in seperate dirs to
hit ENOSPC on small fs with little free space. Loop for 100 iterations.

Regression test for
34cf865 ext4: fix deadlock when writing in ENOSPC conditions

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

btrfs takes much longer time than xfs and extN do, the rough test time
on my test box is

xfs	50s
extN	90s
btrfs	1h

I'm not sure what's the best way to deal with such situation, so I simply
reduce iteration count for btrfs to 10, and test time on btrfs is about
5m now.

 tests/generic/027     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/027.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 110 insertions(+)
 create mode 100755 tests/generic/027
 create mode 100644 tests/generic/027.out

diff --git a/tests/generic/027 b/tests/generic/027
new file mode 100755
index 0000000..b9232ec
--- /dev/null
+++ b/tests/generic/027
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. generic/027
+#
+# Run 8 processes writing 1k files to seperate files in seperate dirs to
+# hit ENOSPC on small fs with little free space. Loop for 100 iterations.
+#
+# Regression test for
+# 34cf865 ext4: fix deadlock when writing in ENOSPC conditions
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat Inc.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+}
+
+create_file()
+{
+	local dir=$1
+	local direct=$2
+	local i=0
+
+	mkdir -p $dir
+	while $XFS_IO_PROG -f $direct -c "pwrite 0 1k" $dir/file_$i >/dev/null 2>&1; do
+		let i=$i+1
+	done
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mount
+
+echo "Reserve 2M space" >>$seqres.full
+$XFS_IO_PROG -f -c "pwrite 0 2m" $SCRATCH_MNT/testfile >>$seqres.full 2>&1
+echo "Fulfill the fs" >>$seqres.full
+$XFS_IO_PROG -f -c "pwrite 0 254m" $SCRATCH_MNT/bigfile >>$seqres.full 2>&1
+echo "Remove reserved file" >>$seqres.full
+rm -f $SCRATCH_MNT/testfile
+
+loop=100
+# btrfs takes much longer time, reduce the loop count
+if [ "$FSTYP" == "btrfs" ]; then
+	loop=10
+fi
+
+dir=$SCRATCH_MNT/testdir
+echo -n "iteration" >>$seqres.full
+i=1
+while [ $i -le $loop ]; do
+	echo -n " $i" >>$seqres.full
+	nr_worker=8
+	while [ $nr_worker -gt 0 ]; do
+		# half buffered I/O half direct I/O
+		if [ `expr $nr_worker % 2` -eq 0 ]; then
+			create_file $dir/$nr_worker -d >>$seqres.full &
+		else
+			create_file $dir/$nr_worker >>$seqres.full &
+		fi
+		let nr_worker=$nr_worker-1
+	done
+	wait
+	rm -rf $dir
+	let i=$i+1
+done
+_scratch_unmount
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/generic/027.out b/tests/generic/027.out
new file mode 100644
index 0000000..ef78cda
--- /dev/null
+++ b/tests/generic/027.out
@@ -0,0 +1,2 @@
+QA output created by 027
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 961f4e5..e851c62 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -29,6 +29,7 @@
 024 auto quick
 025 auto quick
 026 acl quick auto
+027 auto enospc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
