Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 865B77F53
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 04:28:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EE36AC001
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 02:28:14 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.137]) by
	cuda.sgi.com with ESMTP id CsVondHXfszAVeSC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 02:28:12 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstest: add a test for btrfs device replace operation
Date: Fri, 26 Jul 2013 11:28:05 +0200
Message-Id: <1374830885-26966-1-git-send-email-sbehrens@giantdisaster.de>
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
Cc: linux-btrfs@vger.kernel.org

Unfortunately this test takes 6 minutes on my SSD equiped test box since
it runs all possible single/dup/raid0/raid1/raid10/mixed profiles, one
round with the '-f' option to 'btrfs replace start' and one round
without this option. The cancelation is tested only once and with the
dup/single profile for metadata/data.

Almost all the time is spent when the filesystem is populated with test
data. The replace operation itself takes one second for all the tests,
and 20 seconds for the test that is marked as 'thorough' (this one
spends more than a minute to populate the filesystem with data).

The amount of tests done depends on the number of devices in the
SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
be available (e.g. 5 partitions).

For the first round, the last device in the SCRATCH_DEV_POOL string
is taken as the target device for the replace operation, the first
device is the source device. For the second round it is the other way
round. Therefore make sure that both devices have _exactly_ the same
size, otherwise the tests fail! The target device for a replace
operation always needs to be larger or of equal size than the source
device.

If SCRATCH_DEV_POOL is set to "A B C D E" for example, the first
round creates a filesystem on "A B C D" and replaces A with E in the
first round, and E again with A in the second round. E and A need to
have the same size for the tests to succeed.

To check the filesystems after replacing a device, a scrub run is
performed, a btrfsck run, and finally the filesystem is remounted.

This commit depends on my other commit:
"xfstest: don't remove the two first devices from SCRATCH_DEV_POOL"

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 tests/btrfs/317     | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/317.out |   3 +
 tests/btrfs/group   |   1 +
 3 files changed, 213 insertions(+)

diff --git a/tests/btrfs/317 b/tests/btrfs/317
new file mode 100755
index 0000000..b4f0d8c
--- /dev/null
+++ b/tests/btrfs/317
@@ -0,0 +1,209 @@
+#! /bin/bash
+# FSQA Test No. 317
+#
+# Test of the btrfs replace operation.
+#
+# The amount of tests done depends on the number of devices in the
+# SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
+# be available (e.g. 5 partitions).
+#
+# For the first round, the last device in the SCRATCH_DEV_POOL string
+# is taken as the target device for the replace operation, the first
+# device is the source device. For the second round it is the other way
+# round.
+#
+# THEREFORE MAKE SURE THAT BOTH DEVICES HAVE _EXACTLY_ THE SAME
+# SIZE, OTHERWISE THE TESTS FAIL!
+#
+# The target device for a replace operation always needs to be larger
+# or of equal size than the source device.
+#
+# If SCRATCH_DEV_POOL is set to "A B C D E" for example, the first
+# round creates a filesystem on "A B C D" and replaces A with E in the
+# first round, and E again with A in the second round. E and A need to
+# have the same size for the tests to succeed.
+#
+# To check the filesystems after replacing a device, a scrub run is
+# performed, a btrfsck run, and finally the filesystem is remounted.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 STRATO.  All rights reserved.
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
+noise_pid=0
+
+_cleanup()
+{
+	if [ $noise_pid -ne 0 ] && ps -p $noise_pid | grep -q $noise_pid; then
+		kill -TERM $noise_pid
+	fi
+	wait
+	rm -f $tmp.tmp
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_require_scratch
+_require_scratch_dev_pool
+
+rm -f $seqres.full
+rm -f $tmp.tmp
+
+echo "*** test btrfs replace"
+
+workout()
+{
+	mkfs_options=$1
+	num_devs4raid=$2
+	with_cancel=$3
+	quick=$4
+	local first_dev=`echo ${SCRATCH_DEV_POOL} | awk '{print $1}'`
+	local last_dev=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
+	local without_1stnlast_dev=`echo $SCRATCH_DEV_POOL | \
+		awk '{ORS=" "; for (i = 2; i < NF; i++) print $i}'`
+
+	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt `expr $num_devs4raid + 1` ]; then
+		echo "skip workout $1 $2 $3 $4" >> $seqres.full
+		echo "Too less devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL" >> $seqres.full
+		return 0
+	fi
+
+	# dup works only on a single disk
+	if echo $mkfs_options | grep -q dup; then
+		without_1stnlast_dev=""
+	fi
+
+	# _scratch_mkfs adds the 1st device again (which is $SCRATCH_DEV)
+	_scratch_mkfs $mkfs_options $without_1stnlast_dev >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+
+	_populate_fs -r $SCRATCH_MNT/zero -s 130 -f 1000 -d 0 -n 0
+	_populate_fs -r $SCRATCH_MNT/urandom -x -s 1300 -f 10 -d 0 -n 0
+	if [ "${quick}Q" = "quickQ" ]; then
+		dd if=/dev/urandom of=$SCRATCH_MNT/r bs=1M count=10 >> $seqres.full 2>&1 &
+		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=250 >> $seqres.full 2>&1
+		wait
+	else
+		dd if=/dev/urandom of=$SCRATCH_MNT/r bs=1M count=100 >> $seqres.full 2>&1 &
+		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=2500 >> $seqres.full 2>&1
+		wait
+	fi
+	echo 3 > /proc/sys/vm/drop_caches; echo 3 > /proc/sys/vm/drop_caches
+	sync
+
+	# generate some (slow) background traffic in parallel to the
+	# replace operation. It is not a problem if cat fails early
+	# with ENOSPC.
+	cat /dev/urandom > $SCRATCH_MNT/noise 2> $seqres.full 2>&1 &
+	noise_pid=$!
+
+	if [ "${with_cancel}Q" = "cancelQ" ]; then
+		$BTRFS_UTIL_PROG replace start -f $first_dev $last_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
+		sleep 1
+		$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace cancel failed"
+
+		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
+		cat $tmp.tmp >> $seqres.full
+		egrep -q "canceled|finished" $tmp.tmp || _fail "btrfs replace status failed"
+	else
+		$BTRFS_UTIL_PROG replace start -Bf $first_dev $last_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
+
+		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
+		cat $tmp.tmp >> $seqres.full
+		grep -q finished $tmp.tmp || _fail "btrfs replace status failed"
+	fi
+
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT > $tmp.tmp 2>&1
+	cat $tmp.tmp >> $seqres.full
+	grep -q finished $tmp.tmp || _fail "btrfs scrub failed"
+	grep -q "with 0 errors" $tmp.tmp || _fail "btrfs scrub failed"
+
+	if ps -p $noise_pid | grep -q $noise_pid; then
+		kill -TERM $noise_pid 2> /dev/null
+	fi
+	noise_pid=0
+	wait
+	umount $SCRATCH_MNT
+	if [ "${with_cancel}Q" = "cancelQ" ]; then
+		_check_btrfs_filesystem $first_dev
+		return 0
+	else
+		_check_btrfs_filesystem $last_dev
+	fi
+
+	# now one more time without the -f option. Instead of wasting
+	# time to populate the filesystem with data again, use the
+	# existing filesystem in the state as it is after the previous
+	# replace operation.
+	umount $SCRATCH_MNT > /dev/null 2>&1
+	_mount -t $FSTYP `_scratch_mount_options | sed "s&${SCRATCH_DEV}&${last_dev}&"`
+	if [ $? -ne 0 ]; then
+		echo "mount failed"
+		exit 1
+	fi
+
+	cat /dev/urandom > $SCRATCH_MNT/noise2 2> $seqres.full 2>&1 &
+	noise_pid=$!
+
+	$BTRFS_UTIL_PROG replace start -B $last_dev $first_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
+
+	$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
+	cat $tmp.tmp >> $seqres.full
+	grep -q finished $tmp.tmp || _fail "btrfs replace status failed"
+
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT > $tmp.tmp 2>&1
+	cat $tmp.tmp >> $seqres.full
+	grep -q finished $tmp.tmp || _fail "btrfs scrub failed"
+	grep -q "with 0 errors" $tmp.tmp || _fail "btrfs scrub failed"
+
+	if ps -p $noise_pid | grep -q $noise_pid; then
+		kill -TERM $noise_pid 2> /dev/null
+	fi
+	noise_pid=0
+	wait
+	umount $SCRATCH_MNT
+	_check_btrfs_filesystem $first_dev
+}
+
+workout "-m single -d single" 1 no quick
+workout "-m single -d single -M" 1 no quick
+workout "-m dup -d single" 1 no quick
+workout "-m dup -d single" 1 cancel quick
+workout "-m dup -d dup -M" 1 no quick
+workout "-m raid0 -d raid0" 2 no quick
+workout "-m raid1 -d raid1" 2 no thorough
+#workout "-m raid5 -d raid5" 2 no quick
+#workout "-m raid6 -d raid6" 3 no quick
+workout "-m raid10 -d raid10" 4 no quick
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/btrfs/317.out b/tests/btrfs/317.out
new file mode 100644
index 0000000..4bda623
--- /dev/null
+++ b/tests/btrfs/317.out
@@ -0,0 +1,3 @@
+QA output created by 317
+*** test btrfs replace
+*** done
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..1b64321 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+317 auto
-- 
1.8.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
