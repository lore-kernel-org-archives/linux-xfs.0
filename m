Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 127BF7F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 14:31:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97180AC003
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 12:31:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5t9EkTlu9oLk03ik for
	<xfs@oss.sgi.com>; Wed, 11 Jun 2014 12:31:13 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfstests: create a test for xfs log grant head leak
	detection
Date: Wed, 11 Jun 2014 15:31:10 -0400
Message-Id: <1402515070-40264-1-git-send-email-bfoster@redhat.com>
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

Changes in the XFS logging code have lead to small leaks in the log
grant heads that consume log space slowly over time. Such problems have
gone undetected for an unnecessarily long time due to code complexity
and potential for very subtle problems. Losing only a few bytes per
logged item on a reasonably large enough fs (10s of GB) means only the
most continuously stressful workloads will cause a severe enough failure
(deadlock due to log reservation exhaustion) quickly enough to indicate
something is seriously wrong.

Recent changes in XFS export the state of the various log heads through
sysfs to aid in userspace/runtime analysis of the log. This test runs a
workload against an XFS filesystem, quiesces the fs and verifies that
the log reserve and write grant heads have not leaked any space with
respect to the current head of the physical log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Rework the test to run a background fsstress and a foreground log
  check loop.
- Replace _get_device_name() with _short_dev().
- Create and use _require_xfs_sysfs().
- Added to log and metadata test groups.
- Assorted fixes for test output, filters and awk invocations.
v1: http://oss.sgi.com/archives/xfs/2014-06/msg00145.html
- Use updated attribute names and value format.
rfc: http://oss.sgi.com/archives/xfs/2014-05/msg00428.html

 common/rc         |  17 ++++++++
 tests/xfs/011     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/011.out |   2 +
 tests/xfs/group   |   1 +
 4 files changed, 136 insertions(+)
 create mode 100755 tests/xfs/011
 create mode 100644 tests/xfs/011.out

diff --git a/common/rc b/common/rc
index f27ee53..e87d1f1 100644
--- a/common/rc
+++ b/common/rc
@@ -1131,6 +1131,23 @@ _require_xfs_finobt()
 	umount $SCRATCH_MNT
 }
 
+# this test requires xfs sysfs attribute support
+#
+_require_xfs_sysfs()
+{
+	attr=$1
+	sysfsdir=/sys/fs/xfs
+	testdev=`_short_dev $TEST_DEV`
+
+	if [ ! -e $sysfsdir ]; then
+		_notrun "no kernel support for XFS sysfs attributes"
+	fi
+
+	if [ ! -z $1 ] && [ ! -e $sysfsdir/$testdev/$attr ]; then
+		_notrun "sysfs attribute '$attr' is not supported"
+	fi
+}
+
 # this test requires that external log/realtime devices are not in use
 #
 _require_nonexternal()
diff --git a/tests/xfs/011 b/tests/xfs/011
new file mode 100755
index 0000000..5763af9
--- /dev/null
+++ b/tests/xfs/011
@@ -0,0 +1,116 @@
+#!/bin/bash
+# FS QA Test No. xfs/011
+#
+# Test the xfs log reservation mechanism for leaks. Run an fsstress workload to
+# include a variety of fs operations, freeze the filesystem and verify that
+# there are no oustanding reservations against the log.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+# get standard environment, filters and checks
+. ./common/rc
+
+_cleanup()
+{
+	killall -9 fsstress 2>/dev/null
+	wait
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# Use the information exported by XFS to sysfs to determine whether the log has
+# active reservations after a filesystem freeze.
+_check_scratch_log_state()
+{
+	devname=`_short_dev $SCRATCH_DEV`
+	attrpath="/sys/fs/xfs/$devname/log"
+
+	# freeze the fs to ensure data is synced and the log is flushed. this
+	# means no outstanding transactions, and thus no outstanding log
+	# reservations, should exist
+	xfs_freeze -f $SCRATCH_MNT
+
+	# the log head is exported in basic blocks and the log grant heads in
+	# bytes. convert the log head to bytes for precise comparison
+	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`
+	log_head_bytes=`awk -F : '{ print $2 }' $attrpath/log_head_lsn`
+	log_head_bytes=$((log_head_bytes * 512))
+
+	for attr in "reserve_grant_head" "write_grant_head"; do
+		cycle=`cat $attrpath/$attr | awk -F : '{ print $1 }'`
+		bytes=`cat $attrpath/$attr | awk -F : '{ print $2 }'`
+
+		if [ $cycle != $log_head_cycle ] ||
+		   [ $bytes != $log_head_bytes ]
+		then
+			echo "$attr ($cycle:$bytes) does not match" \
+				"log_head_lsn ($log_head_cycle:$log_head_bytes)," \
+				"possible leak detected."
+		fi
+	done
+
+	xfs_freeze -u $SCRATCH_MNT
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_freeze
+_require_xfs_sysfs log
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+
+_scratch_mkfs_xfs >> $seqres.full 2>&1
+_scratch_mount
+
+_check_scratch_log_state
+
+$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 9999999 -p 2 -S t \
+	>> $seqres.full 2>&1 &
+
+iters=5
+while [ $iters -gt 0 ]; do
+	sleep 3
+	_check_scratch_log_state
+	iters=$((iters - 1))
+done
+
+killall $FSSTRESS_PROG
+wait
+
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/xfs/011.out b/tests/xfs/011.out
new file mode 100644
index 0000000..6d75ef2
--- /dev/null
+++ b/tests/xfs/011.out
@@ -0,0 +1,2 @@
+QA output created by 011
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 19fd968..cfef69f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -8,6 +8,7 @@
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
 010 auto quick repair
+011 auto freeze log metadata quick
 012 rw auto quick
 013 auto metadata stress
 016 rw auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
