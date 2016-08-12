Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50D267CA0
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 07:13:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BBF1EAC001
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 05:13:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WFZbSbTPEoAY9qCa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 05:13:33 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] tests/xfs: test log recovery metadata LSN ordering
Date: Fri, 12 Aug 2016 08:13:30 -0400
Message-Id: <1471004010-52985-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

XFS had a bug that lead to a possible out-of-order log recovery
situation (e.g., replay a stale modification from the log over more
recent metadata in destination buffer). This resulted in false
corruption reports during log recovery and thus mount failure.

This condition is caused by system crash or filesystem shutdown shortly
after a successful log recovery. Add a test to run a combined workload,
fs shutdown and log recovery loop known to reproduce the problem on
affected kernels.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This test reproduces the problem described and addressed in the
following patchset:

  http://oss.sgi.com/pipermail/xfs/2016-August/050840.html

It runs anywhere from 50-100s in the couple of environments I've tested
on so far and reproduces the problem for me with 100% reliability. Note
that the bug only affects crc=1 kernels.

Brian

 tests/xfs/999     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 0000000..f9dd7f7
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 999
+#
+# Test XFS log recovery ordering on v5 superblock filesystems. XFS had a problem
+# where it would incorrectly replay older modifications from the log over more
+# recent versions of metadata due to failure to update metadata LSNs during log
+# recovery. This could result in false positive reports of corruption during log
+# recovery and permanent mount failure.
+#
+# To test this situation, run frequent shutdowns immediately after log recovery.
+# Ensure that log recovery does not recover stale modifications and cause
+# spurious corruption reports and/or mount failures.
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
+	killall -9 fsstress > /dev/null 2>&1
+	_scratch_unmount > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+
+_scratch_mkfs_xfs >> $seqres.full 2>&1
+_scratch_mount || _fail "mount failed"
+
+for i in $(seq 1 50); do
+	($FSSTRESS_PROG -d $SCRATCH_MNT -n 999999 -p 4 >> $seqres.full &) \
+		> /dev/null 2>&1
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % 3))
+	$XFS_IO_PROG -xc shutdown $SCRATCH_MNT
+
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? == 0 ]; do
+		killall -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+
+	# quit if mount fails so we don't shutdown the host fs
+	_scratch_cycle_mount || _fail "cycle mount failed"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 0000000..d254382
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 6905a62..aad41b5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -308,3 +308,4 @@
 325 auto quick clone
 326 auto quick clone
 327 auto quick clone
+999 auto log metadata
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
