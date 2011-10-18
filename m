Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I6Q5L4058140 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 01:26:05 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD871D51D8
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 23:26:03 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id gqhZetl2PZgxgI87 for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 23:26:03 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 1/3] 264: Functional test case for the btrfs snapshot
Date: Tue, 18 Oct 2011 14:28:54 +0800
Message-Id: <1318919336-32206-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
Cc: Anand Jain <Anand.Jain@oracle.com>

Create snapshots in various ways, modify the data around the block and
file boundaries and verify the data integrity.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 264           |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out       |    2 +
 README        |    7 ++-
 common.config |   14 ++++
 common.rc     |   95 +++++++++++++++++++++++++++-
 group         |    1 +
 6 files changed, 306 insertions(+), 5 deletions(-)
 create mode 100755 264
 create mode 100644 264.out

diff --git a/264 b/264
new file mode 100755
index 0000000..cd7aae2
--- /dev/null
+++ b/264
@@ -0,0 +1,192 @@
+#!/bin/bash
+# FS QA Test No. 263
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
+_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+# Create and save sha256sum
+# arg1 FS to generate sha256
+# arg2 File name to save the sha256 output
+_save_checksum()
+{
+	local i=0
+	>$2
+	cd $1
+	for i in `find . -type f`; do sha256sum $i >> $2; done
+	cd $OLDPWD
+}
+
+# Verify the sha256sum for a FS
+# arg1 FS to be tested
+# arg2 sha256 file
+_verify_checksum()
+{
+	cd $1
+	[ -f $2 ] || _fail "checksum file $2 not found"
+	sha256sum -c $2 | grep "FAILED"
+	cd $OLDPWD
+}
+
+# Create a snapshot
+# arg1 dest dir
+# Return snapshot name in the SNAPNAME
+_create_snap()
+{
+	local x
+	[ -d $1 ] || _fail "Destination dir $1 not present"
+	SNAPNAME=`mktemp -u $SCRATCH_MNT/snap.XXXXXX`
+	btrfs subvolume snapshot $1 $SNAPNAME > /dev/null || _fail "snapshot create failed"
+}
+
+# Reads and writes new data but does not allocate new blocks
+# arg1 FS to be modified
+_read_modify_write()
+{
+	local i
+	local FSIZE
+	for i in `find $1 -type f`
+	do
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		dd if=$i of=/dev/null obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+		dd if=/dev/urandom of=$i obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+	done
+	wait $!
+}
+
+# Fills the allocated blocks
+# arg1 FS in question
+_fill_blk()
+{
+	local FSIZE
+	local BLKS
+	local NBLK
+	local FALLOC
+	local WS
+
+	for i in `find /$1 -type f`
+	do
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		BLKS=`stat -c "%B" $i`
+		NBLK=`stat -c "%b" $i`
+		FALLOC=$(($BLKS * $NBLK))
+		WS=$(($FALLOC - $FSIZE))
+		dd if=/dev/urandom of=$i oseek=$FSIZE obs=$WS count=1 status=noxfer 2>/dev/null &
+	done
+	wait $!
+}
+
+
+# Append a random size to the files
+# arg1 : FS in question
+_append_file()
+{
+	local FSIZE
+	local X
+	local N
+	local i
+	N=0
+	for i in `find $1 -type f`
+	do
+		if [ $N == 0 ]; then
+			X=$i
+			FSIZE=`stat -t $X | cut -d" " -f2`
+			dd if=$X of=$X seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+			N=$(($N+1))
+			continue
+		fi
+		FSIZE=`stat -t $i | cut -d" " -f2`
+		dd if=$X of=$i seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &
+		X=$i
+	done
+	wait $!
+}
+
+##################### real QA test starts here###################################
+# sv1 - is just a name nothing spl
+firstvol="$SCRATCH_MNT/sv1"
+btrfs subvolume create $firstvol > /dev/null || _fail "btrfs subvolume create $firstvol failed"
+_populate_fs -n 1 -f 20 -d 10 -r $firstvol -s 10 -x
+SNAPNAME=0
+_create_snap $firstvol
+_save_checksum $firstvol $tmp.sv1.sum
+_verify_checksum $SNAPNAME $tmp.sv1.sum
+
+#Append1 the files
+_fill_blk $SNAPNAME
+_verify_checksum $firstvol $tmp.sv1.sum
+
+#Append2 the files
+_append_file $SNAPNAME
+_verify_checksum $firstvol $tmp.sv1.sum
+
+#read modify write
+_read_modify_write $SNAPNAME
+_verify_checksum $firstvol $tmp.sv1.sum
+
+#nested snapshot test
+src_vol=$firstvol
+for i in `seq 1 7`; do
+	SNAPNAME=0
+	_create_snap $src_vol
+	_verify_checksum $SNAPNAME $tmp.sv1.sum
+	src_vol=$SNAPNAME
+done
+
+# file delete test
+SNAPNAME=0
+_create_snap $firstvol
+tname=`echo $SNAPNAME | rev | cut -d"/" -f1 | rev`
+_save_checksum $SNAPNAME $tmp.$tname.sum
+\rm -rf $firstvol/*
+_verify_checksum $SNAPNAME $tmp.$tname.sum
+
+umount $SCRATCH_DEV || _fail "unmount failed"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/264.out b/264.out
new file mode 100644
index 0000000..7a26e35
--- /dev/null
+++ b/264.out
@@ -0,0 +1,2 @@
+QA output created by 263
+Silence is golden
diff --git a/README b/README
index 5367be6..7c135c7 100644
--- a/README
+++ b/README
@@ -36,12 +36,17 @@ Preparing system for tests (IRIX and Linux):
               not be run.
               
         (these must be two DIFFERENT partitions)
+
+    - for btrfs only: some tests would need 3 or more independent SCRATCH disks,
+      which should be setenv SCRATCH_DEV_POOL instead of SCRATCH_DEV
+              
               
     - setup your environment
         - setenv TEST_DEV "device containing TEST PARTITION"
         - setenv TEST_DIR "mount point of TEST PARTITION"   
        	- optionally:
              - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
+             - setenv SCRATCH_DEV_POOL "pool of SCRATCH disks for testing btrfs"
              - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
              - setenv TAPE_DEV "tape device for testing xfsdump"
              - setenv RMT_TAPE_DEV "remote tape device for testing xfsdump"
@@ -63,7 +68,7 @@ Preparing system for tests (IRIX and Linux):
       tape which can be overwritten.
           
     - make sure $TEST_DEV is a mounted XFS partition
-    - make sure that $SCRATCH_DEV contains nothing useful
+    - make sure that $SCRATCH_DEV or $SCRATCH_DEV_POOL contains nothing useful
     
 Running tests:
 
diff --git a/common.config b/common.config
index e94624e..4212fc8 100644
--- a/common.config
+++ b/common.config
@@ -229,6 +229,20 @@ if [ ! -d "$TEST_DIR" ]; then
     exit 1
 fi
 
+# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
+# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
+if [ "$HOSTOS" == "Linux" ]; then
+    FSTYP_tmp=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+else
+    FSTYP_tmp=xfs
+fi
+if [ "$FSTYP_tmp" == "btrfs" ]; then
+    if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+	SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | cut -d" " -f 1`
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | cut -d" " -f 2-`
+    fi
+fi
+	
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
     echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
diff --git a/common.rc b/common.rc
index e948169..a59d5f0 100644
--- a/common.rc
+++ b/common.rc
@@ -1498,7 +1498,11 @@ _nfiles()
                 file=f$f
                 echo > $file
                 if [ $size -gt 0 ]; then
-                    dd if=/dev/zero of=$file bs=1024 count=$size
+		    if [ $randomdata == false ]; then
+	                dd if=/dev/zero of=$file bs=1024 count=$size 2>&1 | _filter_dd
+		    else
+                    	dd if=/dev/urandom of=$file bs=1024 count=$size 2>&1 | _filter_dd
+		    fi
                 fi
 		let f=$f+1
         done
@@ -1508,7 +1512,11 @@ _nfiles()
 _descend()
 {
         dirname=$1; depth=$2
-        mkdir $dirname  || die "mkdir $dirname failed"
+	if [ -d $dirname ]; then
+		dirname=`mktemp -dq $dirname/dir.XXXXXX`
+	else
+	        mkdir $dirname  || die "mkdir $dirname failed"
+	fi
         cd $dirname
 
         _nfiles $files           # files for this dir
@@ -1529,7 +1537,7 @@ _descend()
 
 # Populate a filesystem with inodes for performance experiments
 #
-# usage: populate [-v] [-n ndirs] [-f nfiles] [-d depth] [-r root] [-s size]
+# usage: populate [-v] [-n ndirs] [-f nfiles] [-d depth] [-r root] [-s size] [-x ] 
 #
 _populate_fs()
 {
@@ -1540,8 +1548,9 @@ _populate_fs()
     depth=2         # depth of tree from root to leaves
     verbose=false
     root=root       # path of initial root of directory tree
+    randomdata=false # -x Use Random data instead of zero
 
-    while getopts "d:f:n:r:s:v" c
+    while getopts "d:f:n:r:s:v:x" c
     do
         case $c in
         d)      depth=$OPTARG;;
@@ -1550,6 +1559,7 @@ _populate_fs()
         s)      size=$OPTARG;;
         v)      verbose=true;;
         r)      root=$OPTARG;;
+	x)	randomdata=true;;
         esac
     done
 
@@ -1591,6 +1601,83 @@ _test_inode_extsz()
     echo $blocks
 }
 
+# scratch_dev_pool should contain the disks pool for the btrfs raid
+_require_scratch_dev_pool()
+{
+	local i
+	case "$FSTYP" in
+	btrfs)
+		if [ -z "$SCRATCH_DEV_POOL" ]
+		then
+			_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
+		fi
+		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]
+		then
+			_notrun "this test needs 2 or more disks in SCRATCH_DEV_POOL"
+		fi
+
+		for i in $SCRATCH_DEV_POOL
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
+
+# We will check if the device is virtual (eg: loop device) since it does not
+# have the delete entry-point. Otherwise SCSI and USB devices are fine. 
+_require_deletable_scratch_dev_pool()
+{
+	local i
+	local x
+	for i in $SCRATCH_DEV_POOL; do
+		x=`echo $i | cut -d"/" -f 3`
+		ls -l /sys/class/block/${x} | grep -q "virtual" 
+		if [ $? == "0" ]; then
+			_notrun "$i is a virtual device which is not deletable"
+		fi
+	done
+}
+
+# arg 1 is dev to remove and is output of the below eg.
+# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
+_devmgt_remove()
+{
+	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove disk failed"
+}
+
+# arg 1 is dev to add and is output of the below eg.
+# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
+_devmgt_add()
+{
+	local h
+	local tdl
+	# arg 1 will be in h:t:d:l format now in the h and "t d l" format
+	h=`echo ${1} | cut -d":" -f 1`
+	tdl=`echo ${1} | cut -d":" -f 2-|sed 's/:/ /g'`
+
+	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"
+}
 
 ################################################################################
 
diff --git a/group b/group
index 2a8970c..cfbae8c 100644
--- a/group
+++ b/group
@@ -377,3 +377,4 @@ deprecated
 261 auto quick quota
 262 auto quick quota
 263 rw auto quick
+264 auto quick
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
