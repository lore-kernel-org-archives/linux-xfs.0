Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 709B37F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 13:13:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4BE428F8035
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 11:13:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iJxsVhE7MMZoRsYN for
	<xfs@oss.sgi.com>; Fri, 16 May 2014 11:13:07 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4GID78S014448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:13:07 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4GID7s6019756
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:13:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH] xfstests: create a test for xfs log grant head leak
	detection
Date: Fri, 16 May 2014 14:13:06 -0400
Message-Id: <1400263986-35627-1-git-send-email-bfoster@redhat.com>
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
 tests/xfs/011     | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/011.out |  11 +++++
 tests/xfs/group   |   1 +
 3 files changed, 146 insertions(+)
 create mode 100755 tests/xfs/011
 create mode 100644 tests/xfs/011.out

diff --git a/tests/xfs/011 b/tests/xfs/011
new file mode 100755
index 0000000..ed15164
--- /dev/null
+++ b/tests/xfs/011
@@ -0,0 +1,134 @@
+#!/bin/bash
+# FS QA Test No. xfs/011
+#
+# Test the xfs log reservation mechanism for leaks. Run a short fsstress
+# workload to include a variety of fs operations, freeze the filesystem and
+# verify that there are no oustanding reservations against the log.
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
+. ./common/filter
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
+# Determine the system device name for a particular block device. The device
+# name is how the block dev is referenced under sysfs.
+_get_device_name()
+{
+	devpath=$1
+
+	# check for a symlink (i.e., device mapper)
+	if [ -L $devpath ]
+	then
+		devpath=`readlink -f $devpath`
+	fi
+
+	# grab the major minor and convert from hex to decimal
+	major=$((0x`stat -c %t $devpath`))
+	minor=$((0x`stat -c %T $devpath`))
+
+	# refer to sysfs by major minor
+	basename `readlink /sys/dev/block/$major:$minor`
+}
+
+# Use the information exported by XFS to sysfs to determine whether the log has
+# active reservations after a filesystem freeze.
+_check_scratch_log_state()
+{
+	devname=`_get_device_name $SCRATCH_DEV`
+	attrpath="/sys/fs/xfs/$devname"
+
+	# freeze the fs to ensure data is synced and the log is flushed. this
+	# means no outstanding transactions, and thus no outstanding log
+	# reservations, should exist
+	xfs_freeze -f $SCRATCH_MNT
+
+	# the log head is exported in basic blocks and the log grant heads in
+	# bytes. convert the log head to bytes for precise comparison
+	log_head_lsn=`cat $attrpath/log_head_lsn`
+	log_head_cycle=$((log_head_lsn >> 32))
+	log_head_bytes=$(((log_head_lsn & 0xffffffff) * 512))
+
+	for attr in "reserve_head_lsn" "write_head_lsn"
+	do
+
+		lsn=`cat $attrpath/$attr`
+		cycle=$((lsn >> 32))
+		bytes=$((lsn & 0xffffffff))
+
+		if [ $cycle != $log_head_cycle ] ||
+		   [ $bytes != $log_head_bytes ]
+		then
+			echo "$attr ($lsn) does not match log_head_lsn" \
+				"($log_head_lsn), possible leak detected."
+		else
+			echo "$attr matches log_head_lsn"
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
+# TODO: _requre_xfs_sysfs
+if [ ! -e /sys/fs/xfs ]
+then
+	_notrun "no kernel support for XFS sysfs attributes"
+fi
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs | _filter_mkfs 2>> $seqres.full
+_scratch_mount
+
+_check_scratch_log_state
+
+$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 1000 -p 2 -S t \
+	>> $seqres.full 2>&1
+
+_check_scratch_log_state
+
+umount $SCRATCH_MNT
+
+status=0
+exit
diff --git a/tests/xfs/011.out b/tests/xfs/011.out
new file mode 100644
index 0000000..e1d11e4
--- /dev/null
+++ b/tests/xfs/011.out
@@ -0,0 +1,11 @@
+QA output created by 011
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+reserve_head_lsn matches log_head_lsn
+write_head_lsn matches log_head_lsn
+reserve_head_lsn matches log_head_lsn
+write_head_lsn matches log_head_lsn
diff --git a/tests/xfs/group b/tests/xfs/group
index 19fd968..99bf0e1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -8,6 +8,7 @@
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
 010 auto quick repair
+011 auto quick freeze
 012 rw auto quick
 013 auto metadata stress
 016 rw auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
