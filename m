Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7U5ogVD142096 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 00:50:42 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id GBXt3BWaXwiaMW7p for
	<xfs@oss.sgi.com>; Wed, 29 Aug 2012 22:51:34 -0700 (PDT)
Message-ID: <503EFF4D.2020900@cn.fujitsu.com>
Date: Thu, 30 Aug 2012 13:51:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add btrfs device add-del test
Reply-To: miaox@cn.fujitsu.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Linux Btrfs <linux-btrfs@vger.kernel.org>

This patch adds btrfs device add/delete test to xfstests. Though case 265 also
does device add/delete test, it is too simple. Compare with case 265, this case
is more complex.

First, this case test the basic function on different storage profiles, on different
number of the devices.

Second, this case check the file is corrupted or not after the device is added or removed.

Third, we designed some special cases to test the bugs which were reported before.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is against the bug fix patches of 265 which were sent several days ago. 
http://marc.info/?l=linux-btrfs&m=134577252108328&w=2
http://marc.info/?l=linux-btrfs&m=134577253308329&w=2
http://marc.info/?l=linux-btrfs&m=134579572613601&w=2
---
 285       |  415 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out   |    2 +
 common.rc |   16 +++
 group     |    1 +
 4 files changed, 434 insertions(+), 0 deletions(-)
 create mode 100755 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100755
index 0000000..7160aed
--- /dev/null
+++ b/285
@@ -0,0 +1,415 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# btrfs add-del device tests
+# Compare with case 265, this case is more complex. We test the basic
+# function on different profiles, on different number of devices, we
+# also check the file in the test fs is corrupted or not. And beside that,
+# we designed some special cases to test the bugs which were reported before.
+# such as: delete-add mounted device.
+#
+# Note: This test needs five devices.
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Fujitsu.  All Rights Reserved.
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
+# creator
+owner=miaox@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+detail_info="$here/$seq.full"
+tmp=/tmp/$$
+status=1	# failure is the default!
+FS_SIZE=`expr 5 \* 1024 \* 1024 \* 1024` # Filesystem size is 5G
+num=1
+
+stress_run=0
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	if [ $stress_run -ne 0 ]; then
+		_kill_background_operation
+	fi
+	_scratch_unmount &> /dev/null
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool 5
+_require_big_scratch_dev_pool 5	# We require every device is bigger than 5G
+
+
+devs=( $SCRATCH_DEV_POOL )
+ndevs=${#devs[@]}
+
+orphan_dev=
+fs_devs=
+inner_dev=
+
+checkfile="tmp_checkfile"
+stress_pid=
+
+_raid_to_min_devs()
+{
+	case $1 in
+	raid0|raid1)
+		return 2
+	;;
+	raid10)
+		return 4
+	;;
+	*)
+		return 1
+	;;
+	esac
+}
+
+_prepare_test()
+{
+	local nr_devs=$1
+	local profile=$2
+	local min_devs
+
+	_raid_to_min_devs $profile
+	min_devs=$?
+
+	if [ $nr_devs -eq 0 -o $nr_devs -lt $min_devs ]; then
+		_fail "Case $num is wrong, we need at least more devices to create fs"
+	fi
+
+	nr_devs=$(($nr_devs - 1))
+	if [ $nr_devs -eq 0 ]; then
+		fs_devs=""
+		inner_dev=$SCRATCH_DEV
+		orphan_dev=${devs[@]:0:1}
+	elif [ $nr_devs -gt 0 -a $nr_devs -le $ndevs ]; then
+		fs_devs=${devs[@]:0:$nr_devs}
+		inner_dev=${devs[@]:0:1}
+		orphan_dev=${devs[@]:$nr_devs:1}
+	elif [ $nr_devs -gt $ndevs ]; then
+		_fail "Case $num is wrong, the devices we need is more then we have"
+	fi
+}
+
+_make_fs()
+{
+	local nr_devs=$1
+	local profile=$2
+
+	export MKFS_OPTIONS="-d $profile -m $profile -b $(($FS_SIZE / $nr_devs))"
+	_scratch_mkfs "$fs_devs" >> $detail_info 2>&1 || _fail "case $num failed, mkfs failed"
+	_scratch_mount
+}
+
+_test_add()
+{
+	local obj_dev=$1
+	local expected_ret=$2
+	local ret=
+
+	btrfs device add $obj_dev $SCRATCH_MNT >> $detail_info 2>&1
+	ret=$?
+	if [ $ret -ne 0 -a $expected_ret -eq 0 ]; then
+		_fail "case $num failed, adding device $1 failed"
+	elif [ $ret -eq 0 -a $expected_ret -eq 1 ]; then
+		_fail "case $num failed, device $1 was added successfully"
+	fi
+}
+
+# _test_del 0|1|... If the parameter is 0, it means we expect this operation
+# can complete successfully, if the parameter is 1, it means we expect this
+# operation should fail. Other number means we need not check the result.
+_test_del()
+{
+	local obj_dev=$1
+	local expected_ret=$2
+	local ret=
+
+	btrfs device del $obj_dev $SCRATCH_MNT >> $detail_info 2>&1
+	ret=$?
+	if [ $ret -ne 0 -a $expected_ret -eq 0 ]; then
+		_fail "case $num failed, removing device $1 failed"
+	elif [ $ret -eq 0 -a $expected_ret -eq 1 ]; then
+		_fail "case $num failed, device $1 was removed successfully"
+	fi
+	# When we do stress test, it is hard to know if the operation will be
+	# successful or not. So we do not check the result. All things we want
+	# to do is to make sure the fs is not corrupted(btrfsck check), and
+	# the kernel don't crash.
+}
+
+# _fill_fs 1|2|3
+# 1 - just create a empty file
+# 2 - fill < 30% of the fs
+# 3 - fill > 50% of the fs
+_fill_fs()
+{
+	case "$1" in
+	"1")
+		touch $SCRATCH_MNT/foo
+	;;
+	"2")
+		#fill half of the filesystem
+		dd if=/dev/urandom of=$SCRATCH_MNT/foo bs=1M count=50 &> /dev/null
+	;;
+	"3")
+		#fill full of the filesystem
+		dd if=/dev/urandom of=$SCRATCH_MNT/foo bs=4M count=1000 &> /dev/null
+	;;
+	*)
+		_fail "Case $num passes wrong parameter into _fill_fs()"
+	;;
+	esac
+
+	md5sum $SCRATCH_MNT/foo > $SCRATCH_MNT/$checkfile 2>> $detail_info
+	if [ $? -ne 0 ]; then
+		_fail "Case $num failed to compute md5sum"
+	fi
+}
+
+_check_files()
+{
+	if [ -f $SCRATCH_MNT/$checkfile ]; then
+		md5sum -c $SCRATCH_MNT/$checkfile >> $detail_info 2>&1
+		if [ $? -ne 0 ]; then
+			_fail "Case $num test file has been modified"
+		fi
+	else
+		_fail "There is no checkfile"
+	fi
+}
+
+# add_del order operation
+_add_del_dev()
+{
+	_test_add $1 0
+	_test_del $1 0
+}
+
+# del_add order operation
+_del_add_dev()
+{
+	_test_del $1 0
+	_test_add $1 0
+}
+
+# for stress test
+_background_operation()
+{
+	local stress_out="$SCRATCH_MNT/fsstress.$$"
+	local args="-p8 -n100000 -d $stress_out"
+
+	$FSSTRESS_PROG $args &> /dev/null &
+	stress_pid=$!
+	stress_run=1
+}
+
+_kill_background_operation()
+{
+	kill $stress_pid > /dev/null 2>&1
+	wait $stress_pid > /dev/null 2>&1
+	stress_run=0
+}
+
+_test_process()
+{
+	local nr_devs=$1
+	local profile=$2
+	local fill_type=$3
+	local obj_dev_type=$4	# 0 - inner device
+				# 1 - mounted device
+				# 2 - outer device
+	local operation_type=$5	# 0 - add device
+				# 1 - del device
+				# 2 - add-del device
+				# 3 - del-add device
+	local expected_result=$6
+	local obj_dev=
+	local operation=
+
+	_prepare_test $nr_devs $profile
+
+	case $obj_dev_type in
+	0)
+		obj_dev=$inner_dev
+	;;
+	1)
+		obj_dev=$SCRATCH_DEV
+	;;
+	2)
+		obj_dev=$orphan_dev
+	;;
+	*)
+		_fail "Wrong device type for add/del"
+	;;
+	esac
+
+	if [ "$obj_dev" == "" ]; then
+		_fail "Case $num is wrong, no device to add/del"
+	fi
+
+	case $operation_type in
+	0)
+		operation="_test_add"
+	;;
+	1)
+		operation="_test_del"
+	;;
+	2)
+		operation="_add_del_dev"
+	;;
+	3)
+		operation="_del_add_dev"
+	;;
+	*)
+		_fail "The operation is not supported"
+	;;
+	esac
+
+	_make_fs $nr_devs $profile
+	_fill_fs $fill_type
+
+	$operation $obj_dev $expected_result
+
+	_check_files
+	_scratch_unmount
+	_check_scratch_fs
+
+	num=$[num+1]
+}
+
+_stress_test_process()
+{
+	local nr_devs=$1
+	local profile=$2
+	local add_first=$3
+
+	_prepare_test $nr_devs $profile
+	_make_fs $nr_devs $profile
+	_background_operation
+
+	for ((i=0; i<20; i++))
+	do
+		if [ $add_first -ne 0 ]; then
+			_test_add $orphan_dev 2
+			_test_del $orphan_dev 2
+		else
+			_test_del $inner_dev 2
+			_test_add $inner_dev 2
+		fi
+	done
+	_kill_background_operation
+	_scratch_unmount
+	_check_scratch_fs
+	num=$[num+1]
+}
+
+rm -rf $seq.full
+
+# case 1-4
+# * | * | a little data | inner device | add device | fail
+_test_process 1 single 2 0 0 1
+_test_process 2 raid0 2 0 0 1
+_test_process 2 raid1 2 0 0 1
+_test_process 4 raid10 2 0 0 1
+
+# case 5-8
+# * | * | a little data | outer device | add device | success
+_test_process 1 single 2 2 0 0
+_test_process 2 raid0 2 2 0 0
+_test_process 2 raid1 2 2 0 0
+_test_process 4 raid10 2 2 0 0
+
+# case 9-12
+# * | * | a little data | outer device | del device | fail
+_test_process 1 single 2 2 1 1
+_test_process 2 raid0 2 2 1 1
+_test_process 2 raid1 2 2 1 1
+_test_process 4 raid10 2 2 1 1
+
+# case 13-16
+# * | * | a little data | inner device | del device | *
+_test_process 1 single 2 0 1 1
+_test_process 2 raid0 2 0 1 0	# special case
+_test_process 2 raid1 2 0 1 1
+_test_process 4 raid10 2 0 1 1
+
+# case 17-20
+# * | * | full fs | outer device | add device | success
+_test_process 1 single 3 2 0 0
+_test_process 2 raid0 3 2 0 0
+_test_process 2 raid1 3 2 0 0
+_test_process 4 raid10 3 2 0 0
+
+# case 21-24
+# * | * | full fs | inner device | del device | fail
+_test_process 2 single 3 0 1 1
+_test_process 3 raid0 3 0 1 1
+_test_process 3 raid1 3 0 1 1
+_test_process 5 raid10 3 0 1 1
+
+# case 25-28
+# * | * | a little data | outer device | add-del device | *
+_test_process 1 single 2 2 2 0
+_test_process 2 raid0 2 2 2 0
+_test_process 2 raid1 2 2 2 0
+_test_process 4 raid10 2 2 2 0
+
+# case 29-32
+# * | * | a little data | inner device | del-add device | *
+_test_process 2 single 2 0 3 0
+_test_process 3 raid0 2 0 3 0
+_test_process 3 raid1 2 0 3 0
+_test_process 5 raid10 2 0 3 0
+
+# case 33-36
+# * | * | a little data | mounted device | del-add device | *
+_test_process 2 single 2 1 3 0
+_test_process 3 raid0 2 1 3 0
+_test_process 3 raid1 2 1 3 0
+_test_process 5 raid10 2 1 3 0
+
+# case 37
+# * | * | a little data | inner device | del-add device | *
+_test_process 2 raid0 2 0 3 0
+
+# stress case 38-41
+_stress_test_process 1 single 1
+_stress_test_process 2 raid0 1
+_stress_test_process 2 raid1 1
+_stress_test_process 4 raid10 1
+
+# stress case 42-45
+_stress_test_process 2 single 0
+_stress_test_process 3 raid0 0
+_stress_test_process 3 raid1 0
+_stress_test_process 5 raid10 0
+
+# special stress case 46
+_stress_test_process 2 raid0 0
+
+echo "Silence is golden"
+status=0; exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..ab12da9
--- /dev/null
+++ b/285.out
@@ -0,0 +1,2 @@
+QA output created by 285
+Silence is golden
diff --git a/common.rc b/common.rc
index a254e0e..74ad14b 100644
--- a/common.rc
+++ b/common.rc
@@ -1735,6 +1735,22 @@ _require_scratch_dev_pool()
 	done
 }
 
+# Check all the devices in the pool if the size of each one is bigger than
+# the size we required.
+# The parameter is the size we required, and the unit is GB(1024 * 1024 * 1024)
+_require_big_scratch_dev_pool()
+{
+	local i
+	local expected_size=$1
+	local dev_size
+	for i in $SCRATCH_DEV_POOL; do
+		dev_size=$((`fdisk -s $i` / 1024 / 1024))
+		if [ $dev_size -lt $expected_size ]; then
+			_notrun "The size of $i ($dev_size G) is less than $expected_size G."
+		fi
+	done
+}
+
 # We will check if the device is deletable. 
 _require_deletable_scratch_dev_pool()
 {
diff --git a/group b/group
index 104ed35..0b33178 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
