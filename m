Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p757orwD108614 for <xfs@oss.sgi.com>; Fri, 5 Aug 2011 02:50:53 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BE44F4DBC0
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2011 00:51:49 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id zJti01xWgq6KdO3N for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2011 00:51:49 -0700 (PDT)
Message-ID: <4E3BA2F7.4080500@oracle.com>
Date: Fri, 05 Aug 2011 15:59:51 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] snapshot, defragment and raid test cases for btrfs
Content-Type: multipart/mixed; boundary="------------030109030109040807040307"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Chris Mason <chris.mason@oracle.com>

This is a multi-part message in MIME format.
--------------030109030109040807040307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,

  Attached is the patch for the xfstests, which adds snapshot,
  defragment and volume management test cases for the btrfs
  (257, 258 and 259 respectively).

  This introduces a new user variable 'DISK_POOL' which should
  be set to disks for the raid tests.

  An example of usage of these tests is as below.
------------
[root@localhost xfstests]# cat local.config
TEST_DEV="/dev/sdd"
TEST_DIR=/btrfs
SCRATCH_DEV="/dev/sde"
SCRATCH_MNT=/btrfs1
DISK_POOL="/dev/sdf /dev/sdg"
[root@localhost xfstests]#

[root@localhost xfstests]# ./check 257 258 259
FSTYP -- btrfs
PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
MKFS_OPTIONS -- /dev/sde
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sde /btrfs1

257 8s
258 3s
259 33s
Ran: 257 258 259
Passed all 3 tests
----------------

  Thank you.

Anand

--------------030109030109040807040307
Content-Type: text/x-patch;
 name="0001-Adding-257-258-259-to-test-snapshot-defragment-and-r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Adding-257-258-259-to-test-snapshot-defragment-and-r.pa";
 filename*1="tch"

>From 62d90cd24afc192e091d9b81fb78d7c666237e97 Mon Sep 17 00:00:00 2001
From: Anand Jain <Anand.Jain@oracle.com>
Date: Fri, 5 Aug 2011 15:36:25 +0800
Subject: [PATCH] Adding 257, 258, 259 to test snapshot, defragment and raid in btrfs

Adding test case number 257, 258 and 259 to test snapshot, defragment
and raid support in btrfs. This also adds a user input variable
'DISK_POOL'.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 257               |  198 ++++++++++++++++++++++++++++++++++++++++++
 257.out           |    8 ++
 258               |   75 ++++++++++++++++
 258.out           |    2 +
 259               |  220 +++++++++++++++++++++++++++++++++++++++++++++++
 259.out           |    9 ++
 common.rc         |   58 +++++++++++++
 group             |    3 +
 src/checksum_misc |   28 ++++++
 src/devmgt        |   25 ++++++
 src/fsmisc        |  247 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/randmisc      |   70 +++++++++++++++
 src/snapmisc      |   73 ++++++++++++++++
 13 files changed, 1016 insertions(+), 0 deletions(-)
 create mode 100755 257
 create mode 100644 257.out
 create mode 100755 258
 create mode 100644 258.out
 create mode 100755 259
 create mode 100644 259.out
 create mode 100644 src/checksum_misc
 create mode 100644 src/devmgt
 create mode 100644 src/fsmisc
 create mode 100644 src/randmisc
 create mode 100644 src/snapmisc

diff --git a/257 b/257
new file mode 100755
index 0000000..2a75944
--- /dev/null
+++ b/257
@@ -0,0 +1,198 @@
+#! /bin/bash
+# FS QA Test No. 257
+#
+# Extented btrfs snapshot test cases
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle  All Rights Reserved.
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
+# creator
+owner=anand.jain@oracle.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+. ./src/checksum_misc
+. ./src/randmisc
+. ./src/fsmisc
+. ./src/snapmisc
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+#FS fill size
+#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
+QUICK="1 4 4 4096 4096"
+SMALL="1 10 100 4096 8192"
+MEDIUM="10 30 1000 4096 8192"
+LARGE="1000 1 1000 4096 1048576"
+FDPROF=$QUICK
+dolog=1
+
+# compare check sum of $1 with $2
+_testa_snap_check()
+{
+	local volname
+	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
+	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
+	save_checksum $1 $tmp.$volname.sum
+	#$here/src/checksum_misc verify_checksum $2 $tmp.$volname.sum
+	verify_checksum $2 $tmp.$volname.sum
+	[ $dolog = 1 ] && echo "testa_snap_check ok"
+}
+
+_testb_file_append_check()
+{
+	local volname
+
+	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
+	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
+	save_checksum $1 $tmp.$volname.sum
+
+	# modify the snap
+	# $here/src/fsmisc modifyfs_fillblk ${2}
+	modifyfs_fillblk ${2}
+
+	#$here/src/fsmisc check_sum $1 $tmp.$volname.sum
+	verify_checksum $1 $tmp.$volname.sum
+	echo "testb_file_append_check ok"
+}
+
+
+# arg1: Original subvolume
+# arg2 : its snapshot
+_testc_file_append2_check()
+{
+	local volname
+
+	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
+	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
+	save_checksum $1 $tmp.$volname.sum
+
+	#$here/src/fsmisc modifyfs_append $2
+	modifyfs_append $2
+
+	#$here/src/checksum_misc verify_checksum $1 $tmp.$volname.sum
+	verify_checksum $1 $tmp.$volname.sum
+	echo "testc_file_append2_check ok"
+}
+
+# arg1: Original subvolume
+# arg2 : its snapshot
+_testd_read_modify_check()
+{
+	local volname
+
+	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
+	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
+	save_checksum $1 $tmp.$volname.sum
+	#$here/src/fsmisc modifyfs_readmodifywrite ${2}
+	modifyfs_readmodifywrite ${2}
+
+	#$here/src/checksum_misc verify_checksum $1 $tmp.$volname.sum
+	verify_checksum $1 $tmp.$volname.sum
+	echo "testd_read_modify_check ok"
+}
+
+# arg 1: depth
+# arg 2: base vol
+_teste_nested_snap_check()
+{
+	local n
+	local x
+
+	# we need two additional snapshot to compare
+	#$here/src/snapmisc create_nestedclones $(($1+2)) $2
+	create_nestedclones $(($1+2)) $2
+	#$here/src/snapmisc update_clonelist
+	update_clonelist
+
+	n=${#CLONE_LIST[*]}
+	if [ $n -lt $1 ]; then echo Clone List Error; status=1; exit; fi
+
+	dolog=0
+	for i in `seq 1 $1`
+	do
+		n=$(($n-1))
+		_testa_snap_check ${CLONE_LIST[$(($n-1))]} ${CLONE_LIST[$n]}
+	done
+	dolog=1
+	echo "teste_nested_snap_check ok"
+}
+
+_testf_delete_file_check()
+{
+	local org=$1
+	local org_n=`echo $org | rev | cut -d"/" -f1 | rev`
+	local afile
+
+	#$here/src/checksum_misc save_checksum $org $tmp.${org_n}.sum
+	save_checksum $org $tmp.${org_n}.sum
+
+	#afile=`$here/src/randmisc picka rfile ${2}`
+	afile=`picka rfile ${2}`
+	#$here/src/fsmisc modifyfs_delete $afile
+	modifyfs_delete $afile
+
+	#$here/src/checksum_misc verify_checksum $org $tmp.${org_n}.sum
+	verify_checksum $org $tmp.${org_n}.sum
+
+	echo "testf_delete_file_check ok"
+}
+
+# real QA test starts here
+
+firstvol="$SCRATCH_MNT/sv1"
+btrfs subvolume create $firstvol | _filter_scratch
+#$here/src/fsmisc fillfs $firstvol $FDPROF
+fillfs $firstvol $FDPROF
+SNAPNAME=0
+#$here/src/snapmisc create_snap $firstvol $SCRATCH_MNT
+create_snap $firstvol $SCRATCH_MNT
+# Single clone test
+_testa_snap_check $firstvol $SNAPNAME
+_testb_file_append_check $firstvol $SNAPNAME
+_testc_file_append2_check $firstvol $SNAPNAME
+_testd_read_modify_check $firstvol $SNAPNAME
+# nested clone test
+_teste_nested_snap_check  7 $firstvol  # as of now don't do beyond 7 - btrfs bug
+SNAPNAME=0
+create_snap $firstvol $SCRATCH_MNT
+_testf_delete_file_check $firstvol $SNAPNAME
+
+status=0 ; exit
diff --git a/257.out b/257.out
new file mode 100644
index 0000000..ad91d67
--- /dev/null
+++ b/257.out
@@ -0,0 +1,8 @@
+QA output created by 257
+Create subvolume 'SCRATCH_MNT/sv1'
+testa_snap_check ok
+testb_file_append_check ok
+testc_file_append2_check ok
+testd_read_modify_check ok
+teste_nested_snap_check ok
+testf_delete_file_check ok
diff --git a/258 b/258
new file mode 100755
index 0000000..000d505
--- /dev/null
+++ b/258
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. 258
+#
+# btrfs defragmentation tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle.  All Rights Reserved.
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
+owner=anand.jain@oracle.com
+
+seq=`basename $0`
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
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+. ./src/checksum_misc
+. ./src/randmisc
+. ./src/fsmisc
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+#FS fill size
+#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
+QUICK="1 4 4 4096 4096"
+SMALL="1 10 100 4096 8192"
+MEDIUM="10 30 1000 4096 8192"
+LARGE="1000 1 1000 4096 1048576"
+FDPROF=$QUICK
+
+_testa_defrag()
+{
+        btrfs filesystem defragment $1
+        if [ ! $? ]; then echo "Error: Defrag failed"; exit; fi
+        echo "testa_defrag.... ok"
+}
+
+fillfs $SCRATCH_MNT $FDPROF
+_testa_defrag $SCRATCH_MNT
+
+status=0
+exit
diff --git a/258.out b/258.out
new file mode 100644
index 0000000..6ccf5cf
--- /dev/null
+++ b/258.out
@@ -0,0 +1,2 @@
+QA output created by 258
+testa_defrag.... ok
diff --git a/259 b/259
new file mode 100755
index 0000000..770d61b
--- /dev/null
+++ b/259
@@ -0,0 +1,220 @@
+#! /bin/bash
+# FS QA Test No. 259
+#
+# btrfs vol tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle.  All Rights Reserved.
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
+owner=anand.jain@oracle.com
+
+seq=`basename $0`
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
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_disk_pool
+
+. ./src/checksum_misc
+. ./src/randmisc
+. ./src/fsmisc
+. ./src/devmgt
+
+#FS fill size
+#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
+QUICK="1 4 4 4096 4096"
+SMALL="1 10 100 4096 8192"
+MEDIUM="10 30 1000 4096 8192"
+LARGE="1000 1 1000 4096 1048576"
+FDPROF=$QUICK
+
+FSDEV="$SCRATCH_DEV $DISK_POOL"
+
+if_error()
+{
+        if [[ $? -ne 0 ]]; then
+                echo "$1"
+                exit
+        fi
+}
+
+
+fun_error()
+{
+        echo $1
+        exit
+}
+
+
+test1_default()
+{
+	local i
+	mk_fs $1 "$2"
+	fillfs $1 $FDPROF
+        echo "test1_default ok"
+}
+
+test2_raid0()
+{
+	mk_fs $1 raid0 raid0 "$2"
+	fillfs $1 $FDPROF
+	echo "test2_raid0 ok"
+}
+
+test3_raid1()
+{
+	mk_fs $1 raid1 raid1 "$2"
+	fillfs $1 $FDPROF
+	echo "test3_raid1 ok"
+}
+
+test4_raid10()
+{
+	mk_fs $1 raid10 raid10 "$2"
+	fillfs $1 $FDPROF
+	echo "test4_raid10 ok"
+}
+
+test5_single()
+{
+	mk_fs $1 single single "$2"
+	fillfs $1 $FDPROF
+	echo "test5_single ok"
+}
+
+test6_add()
+{
+	local i
+	local devs[]="( $2 )"
+	local n=${#devs[@]}
+
+	n=$(($n-1))
+
+	_trace_wipe "$2"
+	mk_fs $1 "${devs[0]}"
+	fillfs $1 $FDPROF
+	for i in `seq 1 $n`
+	do
+		# echo i=$i ${devs[$i]} $1
+		btrfs device add ${devs[$i]} $1 2>&1 > /dev/null
+	done
+	btrfs filesystem balance $1
+	btrfs filesystem show 2>&1 | egrep devid |awk '{
+		if ( $6 == "0.00" ) {
+			print "Error: Device "$8" balance failed"
+			exit
+		}
+	}'
+	if_error "Error: test6_add... failed"
+	echo "test6_add ok"
+}
+
+test7_replace()
+{
+	local i
+	local x
+	local devs=( $2 )
+	local n=${#devs[@]}
+	local ds
+	local DEVHTL=""
+
+	if [ $n -lt 3 ]; then echo "Error: Need atleast 3 physical disks for the vol:test7_replace"; exit; fi
+	n=$(($n-1))
+	ds=${devs[@]:0:$n}
+	_trace_wipe "$2"
+	mk_fs $1 "$ds"
+	fillfs $1 $FDPROF
+
+	#fail a disk
+	ds=${devs[@]:$(($n-1)):1}
+	devmgt remove ${ds}
+
+	btrfs fi show | egrep "Some devices missing" > /dev/null 2>&1
+	if_error "Error: btrfs did not report device missing"
+	# if [ ! $? ]; then echo "Error: btrfs did not report device missing"; exit; fi
+
+	# add a new disk to btrfs
+	ds=${devs[@]:$(($n)):1}
+	btrfs device add ${ds} ${1}
+	btrfs fi balance $1
+	btrfs filesystem show 2>&1 | egrep devid |awk '{
+		if ( $6 == "0.00" ) {
+			print "Error: Device "$8" balance failed"
+			exit
+		}
+	}'
+	if_error "Error: test7_repalce... failed"
+	echo "test7_replace ok"
+
+	# cleaup. add the removed disk
+	umount $1 > /dev/null 2>&1
+	devmgt add "${DEVHTL}"
+}
+
+function test8_remove
+{
+	local res="ok"
+	_trace_wipe "$2"
+	mk_fs $1 "$2"
+	fillfs $1 $FDPROF
+
+	dev_del=`echo ${2} | awk '{print $NF}'`
+
+	btrfs device delete $dev_del $1 || if_error "Error: delete failed"
+
+	btrfs fi balance $1
+	btrfs filesystem show 2>&1 | egrep devid |awk '{
+		if ( $6 == "0.00" ) {
+			print "Error: Device "$8" balance failed"
+			exit
+		}
+	} '
+	if_error "test8_remove... failed"
+	echo "test8_remove ok"
+	umount $1 > /dev/null 2>&1
+	_trace_wipe "$2"
+}
+
+test1_default $SCRATCH_MNT "$FSDEV"
+test2_raid0 $SCRATCH_MNT "$FSDEV"
+test3_raid1 $SCRATCH_MNT "$FSDEV"
+test4_raid10 $SCRATCH_MNT "$FSDEV"
+test5_single $SCRATCH_MNT "$FSDEV"
+test6_add $SCRATCH_MNT "$FSDEV"
+test7_replace $SCRATCH_MNT "$FSDEV"
+test8_remove $SCRATCH_MNT "$FSDEV"
+
+status=0
+exit
diff --git a/259.out b/259.out
new file mode 100644
index 0000000..b3bd62a
--- /dev/null
+++ b/259.out
@@ -0,0 +1,9 @@
+QA output created by 259
+test1_default ok
+test2_raid0 ok
+test3_raid1 ok
+test4_raid10 ok
+test5_single ok
+test6_add ok
+test7_replace ok
+test8_remove ok
diff --git a/common.rc b/common.rc
index cb23a02..a354f69 100644
--- a/common.rc
+++ b/common.rc
@@ -1559,7 +1559,65 @@ _test_inode_extsz()
     echo $blocks
 }
 
+_require_disk_pool()
+{
+	local i
+	case "$FSTYP" in
+	btrfs)
+		if [ -z "$DISK_POOL" ]
+		then
+			_notrun "this test requires a valid \$DISK_POOL"
+		fi
+		if [ "`echo $DISK_POOL|wc -w`" -lt 2 ]
+		then
+			_notrun "this test needs more than 1 disk in DISK_POOL"
+		fi
+
+		for i in $DISK_POOL
+		do
+			if [ "`_is_block_dev $i`" = "" ]
+			then
+				_notrun "this test requires valid block disk $i"
+			fi
+			if [ "`_is_block_dev $i`" = "`_is_block_dev $TEST_DEV`" ]
+			then
+				_notrun "$i is part of TEST_DEV, this test requires unique disks"
+			fi
+			if [ "`_is_block_dev $i`" = "`_is_block_dev $SCRATCH_DEV`" ]
+			then
+				_notrun "$i is part of SCRATCH_DEV, this test requires unique disks"
+			fi
+			if _mount | grep -q $i
+			then
+				if ! $UMOUNT_PROG $i
+			        then
+			            echo "failed to unmount $i - aborting"
+			            exit 1
+			        fi
+			fi
+			dd if=/dev/zero of=$i bs=4096 count=100 > /dev/null 2>&1
+		done
+	;;
+	esac
+}
 
+_trace_wipe()
+{
+	local i
+	case "$FSTYP" in
+	btrfs)
+		for i in $1
+		do
+			dd if=/dev/zero of=$i bs=4096 count=100 > /dev/null 2>&1
+			if [ $? != 0 ]
+			then
+				echo "disk $i access failed"
+				exit 1
+			fi
+		done
+	;;
+	esac
+}
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
diff --git a/group b/group
index 0c746c8..62eebfb 100644
--- a/group
+++ b/group
@@ -370,3 +370,6 @@ deprecated
 254 auto quick
 255 auto quick prealloc
 256 auto quick
+257 auto quick
+258 auto quick
+259 auto quick
diff --git a/src/checksum_misc b/src/checksum_misc
new file mode 100644
index 0000000..42488cb
--- /dev/null
+++ b/src/checksum_misc
@@ -0,0 +1,28 @@
+#! /bin/bash
+# To Create the sha256 sum for the arg1
+# arg1 FS to generate sha256
+# arg2 File name to save the sha256 output
+function save_checksum()
+{
+	local i=0
+	>$2
+	cd $1
+	#echo "$1"
+	for i in `find . -type f`; do sha256sum $i >> $2; done
+	cd $OLDPWD
+}
+
+
+
+# To check the sha256 for the TESTFS
+# arg1 FS to be tested
+# arg2 sha256 file
+function verify_checksum()
+{
+	cd $1
+	if [ ! -f $2 ]; then echo "$2 file not found"; status=1;exit; fi
+	#$SHA256SUM --status -c $2 | $GREP "FAILED"
+	sha256sum -c $2 | grep "FAILED"
+	if [ $? == 0 ]; then status=1;exit; fi
+	cd $OLDPWD
+}
diff --git a/src/devmgt b/src/devmgt
new file mode 100644
index 0000000..d86b5c9
--- /dev/null
+++ b/src/devmgt
@@ -0,0 +1,25 @@
+#! /bin/bash
+# arg 1 remove/add
+# arg 2 /dev/sdx or return of devmgt resply
+function devmgt
+{
+	local x
+	local d
+
+	if [ ${1} == "remove" ]; then
+		d=`echo $2|cut -d"/" -f3`
+		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
+		#log_event log "Removing the disk ${d} ${x} ..."
+		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi
+		if [ ! $? ]; then echo "Error: Remove a disk failed"; exit 1; fi
+		DEVHTL=${x}
+		#log_event done
+		return
+	else
+		#log_event log "cleaning.. adding back the removed disk ${2} .. "
+		echo "scsi add-single-device ${2}" > /proc/scsi/scsi
+		if [ ! $? ]; then echo "Error: Remove a disk failed"; exit 1; fi
+		#log_event done
+		return
+	fi
+}
diff --git a/src/fsmisc b/src/fsmisc
new file mode 100644
index 0000000..2ee942d
--- /dev/null
+++ b/src/fsmisc
@@ -0,0 +1,247 @@
+#! /bin/bash
+# Create Dir tree and files in it.
+# arg1 basedir
+# arg2 dir depth
+# arg3 nfile_min
+# arg4 nfile_max
+# arg5 fsize_min
+# arg6 fsize_max
+
+function fillfs()
+{
+	umask 000
+	local j
+	local i
+	local DIRP
+	local FCNT
+	local FILEP
+	local SCNT
+	local BCNT
+	#log_event log "filling $1 with dir=$2 files=$3 to $4 of size=$5 to $6....."
+	DIRP=$1
+	for ((j=0; j<$2; j++))
+	do
+		DIRP=`mktemp -dq $DIRP/dir.XXXXXX`
+		FCNT=$(r_ranged $3 $4)
+		for ((i=0; i<$FCNT; i++))
+		do
+			FILEP=`mktemp -q $DIRP/file.XXXXXX`
+			SCNT=$(r_ranged $5 $6)
+			dd if=/dev/urandom of=$FILEP bs=$SCNT count=1 status=noxfer 2>/dev/null &
+			# if some kernel may not support non aligned blocks well
+			#BCNT=$(($SCNT/4096))
+			#dd if=/dev/urandom of=$FILEP bs=4096 count=$BCNT status=noxfer 2>/dev/null &
+		done
+	done
+	wait $!
+	#log_event done
+}
+
+
+# Reads and writes new data but does not allocate new blocks
+# arg1 FS to be modified
+
+function modifyfs_readmodifywrite()
+{
+	local i
+	local FSIZE
+	#log_event log "doing read modify write on $1....."
+	for i in `find $1 -type f`
+	do
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		dd if=$i of=/dev/null obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+		dd if=/dev/urandom of=$i obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+	done
+	wait $!
+	#log_event done
+
+}
+
+# Fills up the allocated blocks
+# arg1 FS in question
+
+function modifyfs_fillblk()
+{
+	local FSIZE
+	local BLKS
+	local NBLK
+	local FALLOC
+	local WS
+
+	#log_event log "filling the allocated blocks....."
+	for i in `find /$1 -type f`
+	do
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		BLKS=`stat -c "%B" $i`
+		NBLK=`stat -c "%b" $i`
+		FALLOC=$(($BLKS * $NBLK))
+		WS=$(($FALLOC - $FSIZE))
+		#echo $FSIZE $BLKS $NBLK $FALLOC $WS
+		dd if=/dev/urandom of=$i obs=$FALLOC count=1 status=noxfer 2>/dev/null &
+	done
+	wait $!
+	#log_event done
+}
+
+
+# Append a random size to the files
+# arg1 : FS in question
+
+function modifyfs_append()
+{
+	local FSIZE
+	local X
+	local N
+	local i
+	#log_event log "appending the files......"
+	N=0
+	for i in `find $1 -type f`
+	do
+		if [ $N == 0 ]; then
+			N=$(($N+1))
+			X=$i
+			FSIZE=`stat -t $X | cut -d" " -f2`
+			dd if=$X of=$X seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+			continue
+		fi
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		dd if=$X of=$i seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+		X=$i
+	done
+	wait $!
+	#log_event done
+}
+
+# Deletes files in a dir
+# arg 1: remove a file  OR files in the dir
+
+function modifyfs_delete()
+{
+	if [ -f $1 ]; then
+		#log_event log "delete a file ${1} ....."
+		\rm -rf $1
+	else
+		#log_event log "delete all files in the dir ${1} ....."
+		\rm -rf $1/*
+	fi
+	#log_event done
+}
+
+# To have a clean FS to test
+# arg 1: mount point
+# arg 2: metadata Raid Type/devs
+# arg 3: data Raid Type/none
+# arg 4: devices/none
+#or
+# arg 1: mount point
+# arg 2: devices
+function mk_fs()
+{
+	local ndev
+
+	umount $1 > /dev/null 2>&1
+
+	if [ $# == 2 ]; then
+		# use default options to create the FS.
+		ndev=( $2 )
+		#echo ${ndev[@]}
+		mkfs.btrfs ${ndev[@]} > /dev/null 2>&1
+		#mkfs.btrfs ${ndev[@]} 2>&1 | _filter_scratch
+		if [ $? != 0 ]; then echo mkfs failed ; exit; fi
+	else if [ $# == 4 ]; then
+		ndev=( $4 )
+		mkfs.btrfs -m $2 -d $3 ${ndev[@]} > /dev/null 2>&1
+		#mkfs.btrfs -m $2 -d $3 ${ndev[@]} 2>&1 | _filter_scratch
+		if [ $? != 0 ]; then echo mkfs failed; exit; fi
+	else
+		echo "Coding Error 234: xfstests alias would like to hear about it"
+	fi
+	fi
+
+	mount -t btrfs ${ndev[0]} $1
+}
+
+# arg1: mntpoint
+# arg2: Number of devs to use
+# arg3: devs in array
+function mk_fs_loopdev()
+{
+	local ndev
+
+	#log_event log "creating a new btrfs fs on $3...."
+	umount $1 > /dev/null 2>&1
+
+	ndev=( $3 )
+	#mkfs.btrfs -m $2 -d $3 ${ndev[@]} > ./tmp/out
+	#if [ $? != 0 ]; then echo mkfs failed ; cat ./tmp/out; exit 1; fi
+	#mount -t btrfs ${ndev[0]} $1
+
+#	echo
+#	echo $# ndev=${ndev[@]}
+	#log_event done
+}
+
+
+function leaned_fs
+{
+	echo $1 $2
+}
+
+#arg 1: mntpt
+#arg 2: phy disks
+#arg 3: Number of total loop devs
+#arg 4: initial mkfs devs
+
+function fs_on_loopdev()
+{
+	local sz
+	local n=0
+	local devname
+	local devs
+
+	mk_fs $1 "$2"
+
+	sz=$((`df -k $1 | egrep "$1" | awk '{print $4}'`/$(($3+1))))
+	sz=$(($sz*1024))
+	if [ $sz -lt 2671771648 ]; then echo "Error: Need at least 2G space for this test"; exit 1; fi
+
+	for n in $(seq 1 $3)
+	do
+		devname=`mktemp -q $1/dev.XXXXXX`
+		dd if=/dev/zero of=$devname bs=8192 count=64000 status=noxfer 2>/dev/null
+		losetup -f $devname
+		if [ $? != 0 ]; then echo "Error losetup failed";exit 1;fi
+		LOOPDEV[$(($n-1))]=`losetup -a | grep $devname|cut -d":" -f1`
+		LOOPFILE[$(($n-1))]=$devname
+	done
+
+	mkdir -p $1/mnt
+	devs=${LOOPDEV[@]:0:$4}
+	mk_fs $1/mnt "$devs"
+}
+
+#arg 1: mntpt
+function clean_loopdev()
+{
+	local i
+
+	#log_event log "Cleaning loop devices....."
+
+	local n=${#LOOPDEV[@]}
+	if [ ! $n ]; then return; fi
+
+	n=$(($n-1))
+
+	umount ${LOOPDEV[0]}
+	if [ $? != 0 ]; then echo "Error: umount loopdev failed"; exit 1;fi
+
+	for i in `seq 0 $n`
+	do
+		losetup -d ${LOOPDEV[$i]}
+		unlink ${LOOPFILE[$i]}
+		#echo ${LOOPDEVS[$i]}
+		#ls -l $MNTPT/fd$i
+	done
+
+	#log_event done
+}
diff --git a/src/randmisc b/src/randmisc
new file mode 100644
index 0000000..a0a065b
--- /dev/null
+++ b/src/randmisc
@@ -0,0 +1,70 @@
+#! /bin/bash
+
+# Generate Random number in a range
+# arg1 min
+# arg2 max
+
+function r_ranged()
+{
+	local X
+	local Y
+	local S
+	if [ $2 == 0 ]; then echo 0; return; fi
+	Y=$RANDOM
+	((X = $2 - $1 + 1))
+	((X = $Y % $X))
+	((X = $X + $1))
+	echo $X
+}
+
+# Picks a rand(r)/first(f)/last(l) file or subvol
+# arg1: what
+# arg2: FS
+function picka()
+{
+	local MAX
+	local X
+	local R
+	local i
+
+	case $1 in
+	rfile)
+		MAX=`find $2 -type f | wc -l`
+		X=`r_ranged 1 $MAX`
+		R=0
+		for i in `find $2 -type f`; do
+			if [ "$X" == "$R" ]; then echo $i; return; fi
+			R=$(($R+1))
+		done
+	;;
+	rsnap)
+		MAX=`$BTRFS subvolume list $2 | wc -l`
+		X=`r_ranged 1 $MAX`
+		R=0
+		for i in `$BTRFS subvolume list $2`; do
+			if [ $X == $R ]; then echo $i; return; fi
+			R=$(($R+1))
+		done
+	;;
+	ffile)
+		for i in `find $2 -type f`; do
+			echo $i
+			break
+		done
+	;;
+	fsnap)
+		for i in `$BTRFS subvolume list $2`; do
+			echo $i;
+			break
+		done
+	;;
+	lfile)
+		for i in `find $2 -type f`; do
+			sleep 1
+		done
+		echo $i
+	;;
+	lsnap)
+	;;
+	esac
+}
diff --git a/src/snapmisc b/src/snapmisc
new file mode 100644
index 0000000..7bd059f
--- /dev/null
+++ b/src/snapmisc
@@ -0,0 +1,73 @@
+#! /bin/bash
+# Create a snapshot
+# arg1 source
+# arg2 dest dir
+
+# Return snapshot name in the SNAPNAME
+function create_snap()
+{
+	local x
+	if [ ! -d $2 ]; then echo Destination dir $2 not present; fi
+	SNAPNAME=`mktemp -u $2/snap.XXXXXX`
+	btrfs subvolume snapshot $1 $SNAPNAME > /dev/null
+	if [ $? != 0 ]; then echo Error snapshot create failed; status=1;exit; fi
+	return
+}
+
+# Destroy a snapshot
+# arg 1: snapshot to be deleted
+
+function destroy_snap()
+{
+	#log_event log "deleting snapshot $1....."
+	btrfs subvolume delete $1
+	#log_event done done
+}
+
+# Creates n clones
+# arg 1: number of clones required
+# arg 2: soruce of which clone has to be taken
+
+function create_nclones()
+{
+	local i
+
+	for i in `seq 1 $1`
+	do
+		create_snap $2 $SCRATCH_MNT
+	done
+}
+
+function update_clonelist()
+{
+	local i
+	# Is there a way btrfs can distinguish sv and ss ?
+	local n=0
+	for i in `btrfs subvolume list $SCRATCH_MNT | rev|cut -d" " -f1|rev`
+	do
+		#echo i=$i n=$n
+		CLONE_LIST[$n]="${SCRATCH_MNT}/${i}"
+                n=$((n+1))
+        done
+	#echo n=$n
+	#for i in `seq 0 $((n-1))`; do echo i=$i ${CLONE_LIST[$i]}; done
+}
+
+# arg1: number of clones required
+# arg2: base subvol
+function create_nestedclones()
+{
+	local i
+	local x
+	local w
+	local SNAPNAME=0
+
+	x=$2
+	for i in `seq 1 $1`
+	do
+		create_snap $x $SCRATCH_MNT
+		x=$SNAPNAME
+		#w=`btrfs subvolume list $SCRATCH_MNT|wc -l`
+		#echo i=$i x=$x w=$w
+	done
+}
-- 
1.7.1


--------------030109030109040807040307
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------030109030109040807040307--
