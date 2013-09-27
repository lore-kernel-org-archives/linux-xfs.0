Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 754F17F5E
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:27:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DDC9AC002
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 07:27:37 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id 8Z4a3TGpjKmCZEy6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 07:27:36 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 130EA7C0427
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:27:36 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs/015 regression test for prealloc with balance
Date: Fri, 27 Sep 2013 10:27:33 -0400
Message-ID: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

We had a regression where we were not copying csums properly when balancing a
prealloc extent.  Unfortunately the way this showed up the most was with the
csum simply missing, which doesn't result in an error to userspace.  So I've
copied what generic/310 does and check dmesg for csum errors when the test
starts and then compare that count to the csum errors after the test finishes to
see if there was a problem.  This approach caught the error without my fix, and
then passed fine with my fix in place but with the previous errors still in
dmesg.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/015     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/015.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100644 tests/btrfs/015
 create mode 100644 tests/btrfs/015.out

diff --git a/tests/btrfs/015 b/tests/btrfs/015
new file mode 100644
index 0000000..d463e48
--- /dev/null
+++ b/tests/btrfs/015
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. btrfs/015
+#
+# Regression test for balance with prealloc extents.  This checks to make sure
+# we are balacing prealloc'ed extents properly by making sure we don't have any
+# csum errors.  Unfortunately this manifests itself with no csum which means
+# userspace doesn't get an error when reading the file back so we have to grok
+# dmesg to see if there was a csum error.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+nr_csum_no_found=$(dmesg | grep -c "no csum found")
+nr_csum_failed=$(dmesg | grep -c "csum failed")
+
+_check_csum_error()
+{
+	new_csum_no_found=$(dmesg | grep -c "no csum found")
+	new_csum_failed=$(dmesg | grep -c "csum failed")
+
+	if [ $nr_csum_no_found -eq $new_csum_no_found -a \
+	     $nr_csum_failed -eq $new_csum_failed ]; then
+		return 0
+	fi
+	return 1
+}
+$XFS_IO_PROG -f -c "falloc 0 1M" -c "pwrite 16k 8k" -c "fsync" \
+	$SCRATCH_MNT/foo > $seqres.full 2>&1
+$BTRFS_UTIL_PROG fi ba $SCRATCH_MNT >> $seqres.full 2>&1 || \
+	_fail "balance failed"
+_scratch_unmount
+_scratch_mount
+$XFS_IO_PROG -c "pread 0 1M" $SCRATCH_MNT/foo >> $seqres.full 2>&1 || \
+	_fail "pread failed"
+
+# This sucks but unfortunately it is the only way to be sure something didn't go
+# wrong.
+_check_csum_error || _fail "csum detected, please check dmesg"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/015.out b/tests/btrfs/015.out
new file mode 100644
index 0000000..fee0fcf
--- /dev/null
+++ b/tests/btrfs/015.out
@@ -0,0 +1,2 @@
+QA output created by 015
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3a5747f..dc5bbea 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -17,3 +17,4 @@
 012 auto quick
 013 auto quick
 014 auto quick
+015 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
