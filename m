Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4IKwp0T260840 for <xfs@oss.sgi.com>; Wed, 18 May 2011 15:58:51 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5C461652A6F
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:49 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id TRLoFYarOM67aSoD for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:49 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4IKbumL024399
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:37:56 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4IKwmRO123198 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4IKwmN0004539 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:48 -0400
Message-ID: <4DD43305.7090508@linux.vnet.ibm.com>
Date: Wed, 18 May 2011 13:58:45 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [XFS Tests Punch Hole 3/3 v3] XFS TESTS: Add Fallocate Punch Hole Test
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
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>

This patch adds punch hole tests that are based off the test scripts that were 
used to test and develop punch hole for ext4.  The tests use the new common 
routines in common.punch to run through various corners cases for punching holes.  

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:000000 100755 0000000... 32e8224... A	254
:000000 100644 0000000... 020e6da... A	254.out
:100644 100644 9f88e75... 29954dc... M	group
 254     |  293 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 254.out |   27 ++++++
 group   |    1 +
 3 files changed, 321 insertions(+), 0 deletions(-)

diff --git a/254 b/254
new file mode 100755
index 0000000..32e8224
--- /dev/null
+++ b/254
@@ -0,0 +1,293 @@
+#! /bin/bash
+# FS QA Test No. 254
+#
+# Test hole punching through fallocate
+#
+# This test is a collection of corner case tests for
+# hole punching through fallocate
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 IBM Corporation. All Rights Reserved.
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
+owner=achender@us.ibm.com
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
+. ./common.punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+
+testfile=$TEST_DIR/254.$$
+
+# Small Hole Test
+#
+# In this test a hole is punched in a 10K file from bytes 
+# 8180 to 16216 resulting in some blocks being removed, and 
+# the non block aligned data to be cleared.  
+#
+# This test is a general purpose punch hole test to verify 
+# that the code can successfully split the extents, and 
+# remove the affected blocks, as well as clearing the 
+# associated pages
+#----------------------------------------------------------------------
+echo Running Small Hole Test
+file_len=40960
+hole_offset=8180
+hole_len=8180
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo Small Hole Test OK
+
+# Big Hole and Hole Removal Test
+#
+# A hole large hole is punched in a large file,
+# Resulting in all but a few blocks being punched out
+# (exact number depends on the block size of the filesystem).
+# After the hole is punched out, the file is deleted
+#
+# This verifies that the code can properly
+# punch out a hole covering multiple extents, and
+# also ensure the all of the extents are properly
+# removed when the file is deleted.
+#
+# This test is successful when the following conditions are met:
+# - df shows that the number of available blocks is the same before the test file is copied 
+#  into the file system, and after the file is deleted
+#----------------------------------------------------------------------
+echo Running Big Hole and Hole Removal Test
+file_len=638162710
+hole_offset=6144
+hole_len=638150422
+
+block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+
+rm $testfile*
+
+#record how many blocks free blocks the filesystem has
+fs_used_before_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
+fs_avail_before_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
+
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+rm $testfile*
+
+#record how many blocks free blocks the filesystem has after the test
+fs_used_after_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
+fs_avail_after_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
+
+if [ $fs_used_before_test != $fs_used_after_test ] || \
+   [ $fs_avail_before_test != $fs_avail_after_test ]; then
+
+	echo Error: File system did not reclaim the correct number of blocks
+	echo The number of used and available blocks should be the same before and after the test
+	echo Used blocks before test: $fs_used_before_test
+	echo Available blocks before test: $fs_avail_before_test
+	echo Used blocks after test: $fs_used_after_test
+	echo Available blocks after test: $fs_avail_after_test
+	status=1 ; exit
+else
+	echo Big Hole and Hole Removal Test OK
+fi
+
+# Last Block Hole Test
+#
+# This test cases punches a hole in 10K file from bytes 32768 to 40960 
+# resulting in a hole that extends to the end of the file.  This test 
+# verifies that the code appropriately handles removing blocks at the 
+# end of the file
+#----------------------------------------------------------------------
+echo Running Last Block Hole Test
+file_len=40960
+hole_offset=32768
+hole_len=8192
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo Last Block Hole Test OK
+
+# First Block Hole Test
+#
+# This test cases punches a hole in 10K file from bytes 0 to 8180 
+# This test verifies that the code appropriately handles punching
+# holes appearing at the beginning of the file.
+#----------------------------------------------------------------------
+echo Running First Block Hole Test
+file_len=40960
+hole_offset=0
+hole_len=8180
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo First Block Hole Test OK
+
+# Cold Cache Hole Test
+#
+# This test is similar to the Small Hole Test, but the drive is 
+# unmounted and remounted before the hole is punched out to make 
+# sure that there are no pages in the cache. This test verifies
+# that the hole contains zeros even when the pages are cold.
+#----------------------------------------------------------------------
+echo Running Cold Cache Hole Test
+file_len=40960
+hole_offset=8180
+hole_len=8180
+_hole_test -m -s -c $file_len $testfile $hole_offset $hole_len
+echo Cold Cache Hole Test OK
+
+# Extended Last Block Hole Test
+#
+# This test cases punches a hole in 10K file from bytes 32768 to 45056
+# resulting in a hole that extends beyond the end of the file.  This 
+# test verifies that the code appropriately handles punching holes 
+# that extend beyond the end of the file
+#----------------------------------------------------------------------
+echo Running Last Block Hole Test
+file_len=40960
+hole_offset=32768
+hole_len=12288
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo Last Block Hole Test OK
+
+# Off Edge Hole Test
+#
+# This test case punches a hole that is beyond the edge of the file.
+# This test is successful when ls, df, filefrag and the file contents 
+# show no changes
+#----------------------------------------------------------------------
+echo Running Off Edge Hole Test
+file_len=40960
+hole_offset=49052
+hole_len=8180
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo Off Edge Hole Test OK
+
+# One Block Hole Test
+#
+# This test punches a hole in a file that is only one block in size 
+#----------------------------------------------------------------------
+echo Running One Block Hole Test
+block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+file_len=$block_size
+hole_offset=$(( $block_size / 4 ))
+hole_len=$(( $hole_offset * 2 ))
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len
+echo One Block Hole Test OK
+
+# Delayed Allocation Hole Test
+#
+# This test is similar to the Small Hole Test, but the file is not sync'd 
+# to the disk before the hole is punched out. This will test the codes 
+# ability to punch holes in delayed extents and also ensure that dirty
+# pages are zero'd properly
+#----------------------------------------------------------------------
+echo Running Delayed Allocation Hole Test
+file_len=40960
+hole_offset=8180
+hole_len=8180
+_hole_test -c $file_len $testfile $hole_offset $hole_len
+echo Delayed Allocation Hole Test OK
+
+# Pre Allocation Hole Test
+#
+# This test is similar to the Small Hole Test, but the file is 
+# preallocated before the hole is punched out.
+#----------------------------------------------------------------------
+echo Running Pre Allocation Hole Test
+file_len=40960
+hole_offset=8180
+hole_len=8180
+_hole_test -p $file_len $testfile $hole_offset $hole_len
+echo Pre Allocation Hole Test OK
+
+# Multi Hole Test
+#
+# This test verifies the code ability to handle existing holes
+# The test punches out 5 consecutive overlapping holes in a 10K file
+#----------------------------------------------------------------------
+echo Running Multi Hole Test
+file_len=40960
+hole_offset=8192
+hole_len=8192
+
+_hole_test -c $file_len $testfile $hole_offset $hole_len 
+
+hole_offset=8192
+hole_len=8192
+_hole_test $testfile $hole_offset $hole_len 
+
+hole_offset=8180
+hole_len=8192
+_hole_test $testfile $hole_offset $hole_len
+
+hole_offset=8204
+hole_len=8192
+_hole_test $testfile $hole_offset $hole_len
+
+hole_offset=12288
+hole_len=12288
+_hole_test $testfile $hole_offset $hole_len
+
+echo Multi Hole Test OK
+
+
+# Multi Hole Test Front
+#
+# This test verifies the codes ability to handle existing holes
+# at the front of the file.
+#----------------------------------------------------------------------
+echo Running Multi Hole Test Front
+file_len=40960
+hole_offset=0
+hole_len=8192
+_hole_test -s -c $file_len $testfile $hole_offset $hole_len 
+_hole_test $testfile $hole_offset $hole_len 
+echo Multi Hole Test Front OK
+
+
+# Multi Hole Test Delayed
+#
+# This test verifies the code ability to handle existing holes 
+# in delayed blocks. This test is similar to the Delayed Allocation 
+# Hole Test, but the hole is punched twice
+#----------------------------------------------------------------------
+echo Running Multi Hole Test Delayed
+file_len=40960
+hole_offset=8180
+hole_len=8180
+_hole_test -s -p $file_len $testfile $hole_offset $hole_len 
+_hole_test $testfile $hole_offset $hole_len 
+echo Multi Hole Test Delayed OK
+
+status=0 ; exit
+
+
+
diff --git a/254.out b/254.out
new file mode 100644
index 0000000..020e6da
--- /dev/null
+++ b/254.out
@@ -0,0 +1,27 @@
+QA output created by 254
+Running Small Hole Test
+Small Hole Test OK
+Running Big Hole and Hole Removal Test
+Big Hole and Hole Removal Test OK
+Running Last Block Hole Test
+Last Block Hole Test OK
+Running First Block Hole Test
+First Block Hole Test OK
+Running Cold Cache Hole Test
+Cold Cache Hole Test OK
+Running Last Block Hole Test
+Last Block Hole Test OK
+Running Off Edge Hole Test
+Off Edge Hole Test OK
+Running One Block Hole Test
+One Block Hole Test OK
+Running Delayed Allocation Hole Test
+Delayed Allocation Hole Test OK
+Running Pre Allocation Hole Test
+Pre Allocation Hole Test OK
+Running Multi Hole Test
+Multi Hole Test OK
+Running Multi Hole Test Front
+Multi Hole Test Front OK
+Running Multi Hole Test Delayed
+Multi Hole Test Delayed OK
diff --git a/group b/group
index 9f88e75..29954dc 100644
--- a/group
+++ b/group
@@ -367,3 +367,4 @@ deprecated
 251 ioctl trim
 252 auto quick prealloc
 253 auto quick
+254 other
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
