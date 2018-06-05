Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:38 -0400
Subject: [PATCH 6/6] xfs: make sure pretty printed geometry output matches
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:43:33 -0700
Message-ID: <152821701376.24976.4940261016750526905.stgit@magnolia>
In-Reply-To: <152821697018.24976.12939094615403004592.stgit@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that all of our commands that can print geometry information
all print the /same/ information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |   41 +++++++++++++++++++++++++
 tests/xfs/710     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/710.out |    2 +
 tests/xfs/group   |    1 +
 4 files changed, 132 insertions(+)
 create mode 100755 tests/xfs/710
 create mode 100644 tests/xfs/710.out


diff --git a/common/xfs b/common/xfs
index 3e34b118..bc35cd87 100644
--- a/common/xfs
+++ b/common/xfs
@@ -710,3 +710,44 @@ _require_xfs_db_write_array()
 	rm -f $TEST_DIR/$seq.img
 	[ $supported -eq 0 ] && _notrun "xfs_db write can't support array"
 }
+
+_require_xfs_spaceman_command()
+{
+	if [ -z "$1" ]
+	then
+		echo "Usage: _require_xfs_spaceman_command command [switch]" 1>&2
+		exit 1
+	fi
+	local command=$1
+	shift
+	local param="$*"
+	local param_checked=0
+	local opts=""
+
+	_require_command "$XFS_SPACEMAN_PROG" "xfs_spaceman"
+
+	testfile=$TEST_DIR/$$.xfs_spaceman
+	case $command in
+	*)
+		testio=`$XFS_SPACEMAN_PROG -c "help $command" $TEST_DIR 2>&1`
+	esac
+
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_spaceman $command support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_spaceman $command failed (old kernel/wrong fs?)"
+	echo $testio | grep -q "Invalid" && \
+		_notrun "xfs_spaceman $command failed (old kernel/wrong fs/bad args?)"
+	echo $testio | grep -q "foreign file active" && \
+		_notrun "xfs_spaceman $command not supported on $FSTYP"
+	echo $testio | grep -q "Function not implemented" && \
+		_notrun "xfs_spaceman $command support is missing (missing syscall?)"
+
+	[ -n "$param" ] || return
+
+	if [ $param_checked -eq 0 ]; then
+		$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
+			_notrun "xfs_spaceman $command doesn't support $param"
+	fi
+}
diff --git a/tests/xfs/710 b/tests/xfs/710
new file mode 100755
index 00000000..b03d4836
--- /dev/null
+++ b/tests/xfs/710
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 710
+#
+# Make sure pretty printed XFS geometry is the same across all programs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.
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
+status=1
+trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+rm -f $seqres.full
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch_nocheck
+
+# Geometry printing wasn't unified until xfs_spaceman grew an 'info'
+# command, so skip this test if there is no spaceman or it doesn't
+# know what 'info' is.
+_require_xfs_spaceman_command "info"
+_require_command "$XFS_DB_PROG" xfs_db
+_require_command "$XFS_GROWFS_PROG" xfs_growfs
+_require_command "$XFS_INFO_PROG" xfs_info
+
+_scratch_mkfs > $tmp.mkfs
+echo MKFS >> $seqres.full
+cat $tmp.mkfs >> $seqres.full
+
+_scratch_xfs_db -c "info" > $tmp.dbinfo
+echo DB >> $seqres.full
+cat $tmp.dbinfo >> $seqres.full
+diff -u $tmp.mkfs $tmp.dbinfo
+
+_scratch_mount
+
+$XFS_SPACEMAN_PROG -c "info" $SCRATCH_MNT > $tmp.spaceman
+echo SPACEMAN >> $seqres.full
+cat $tmp.spaceman >> $seqres.full
+diff -u $tmp.mkfs $tmp.spaceman
+
+$XFS_GROWFS_PROG -n $SCRATCH_MNT > $tmp.growfs
+echo GROWFS >> $seqres.full
+cat $tmp.growfs >> $seqres.full
+diff -u $tmp.mkfs $tmp.growfs
+
+$XFS_INFO_PROG $SCRATCH_MNT > $tmp.info
+echo INFO >> $seqres.full
+cat $tmp.info >> $seqres.full
+diff -u $tmp.mkfs $tmp.info
+
+echo "Silence is golden."
+status=0
+exit 0
diff --git a/tests/xfs/710.out b/tests/xfs/710.out
new file mode 100644
index 00000000..ae2659d5
--- /dev/null
+++ b/tests/xfs/710.out
@@ -0,0 +1,2 @@
+QA output created by 710
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 2319f58f..9dd30ae0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -445,3 +445,4 @@
 445 auto quick filestreams
 446 auto quick
 447 auto mount
+710 auto quick

