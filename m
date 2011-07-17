Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6HNr1J7065391 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 18:53:01 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9ADB1508EF0
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:52:59 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id UldU6aa8VPIMOxkM for
	<xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:52:59 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6HNRdIG015172
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 19:27:39 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p6HNpg1W176526 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:42 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6HNpgg6027723
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:42 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/2 v8] XFS TESTS: Add ENOSPC Hole Punch Test
Date: Sun, 17 Jul 2011 16:52:46 -0700
Message-Id: <1310946766-30217-3-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

This patch adds a new test 255 that tests that a hole can be punched even when the
disk is full.  Reserved blocks should be used to allow a punch hole to proceed even
when there is not enough blocks to further fragment the file. To test this, the
file system is fragmented by punching holes in regular intervals and filling
the file system between punches. This will eventually force the file system to use
reserved blocks to proceed with the punch hole operation.

The work in this patch is a continuation from a previous patch set that has been
partially accepted.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v5->v6

Test moved out of 252 and put in its own test 255

_fill_fs and _test_full_fs_punch have been moved from common.punch
to test 255 and modified to use the _user_do routines in common.rc

_fill_fs has been optimized to stop once files smaller than a block
cannot be created.

v6->v7
Fixed bad file add

v7->v8
Removed "quick" tag from new test and added new "punch" tag
Corrected bad variable assignment
Moved _fill_fs to common.rc
Changed all "> &> /dev/null" to "> /dev/null 2>&1"
Changed all $(...) to `...` for sub-commands
Invoke _fill_fs with a only %50 filesystem size
Split up lengthy lines onto multiple lines

:000000 100644 0000000... 761bb5a... A	256
:000000 100644 0000000... e1b0437... A	256.out
:100644 100644 9d68574... 2ee4a4a... M	common.rc
:100644 100644 9558bc7... 91d8b10... M	group
 256       |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 256.out   |    1 +
 common.rc |   61 +++++++++++++++++++++++++++++++
 group     |   12 ++++--
 4 files changed, 190 insertions(+), 4 deletions(-)

diff --git a/256 b/256
new file mode 100644
index 0000000..761bb5a
--- /dev/null
+++ b/256
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. 256
+#
+# Test Full File System Hole Punching
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 IBM Corporation.  All Rights Reserved.
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
+owner=achender@linux.vnet.ibm.com
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
+_require_scratch
+_require_user
+
+testfile=$SCRATCH_MNT/$seq.$$
+fs_size=$(( 1024 * 1024 * 1024 ))
+
+# _test_full_fs_punch()
+#
+# This function will test that a hole may be punched
+# even when the file system is full.  Reserved blocks
+# should be used to allow a punch hole to proceed even
+# when there is not enough blocks to further fragment the
+# file. To test this, this function will fragment the file
+# system by punching holes in regular intervals and filling
+# the file system between punches. 
+#
+_test_full_fs_punch()
+{
+	local hole_len=$1      # The length of the holes to punch
+	local hole_interval=$2 # The interval between the holes
+	local iterations=$3    # The number of holes to punch
+	local file_name=$4     # File to punch holes in
+	local block_size=$5    # File system block size
+	local file_len=$(( $(( $hole_len + $hole_interval )) * $iterations ))
+	local path=$(dirname $file_name)
+	local hole_offset=0
+
+	if [ $# -ne 5 ] 
+	then
+		echo "USAGE: _test_full_fs_punch hole_len hole_interval iterations file_name block_size"
+		exit 1
+	fi
+
+	rm -f $file_name > /dev/null 2>&1
+
+	$XFS_IO_PROG -F -f -c "pwrite 0 $file_len" \
+		-c "fsync" $file_name > /dev/null 2>&1
+	chmod 666 $file_name
+
+	_fill_fs $(( $fs_size / 2 )) $path/fill $block_size
+
+	for (( i=0; i<$iterations; i++ ))
+	do
+		# This part must not be done as root in order to
+		# test that reserved blocks are used when needed
+		_user_do "$XFS_IO_PROG -F -f -c \"fpunch $hole_offset $hole_len\" $file_name"
+		rc=$?
+		if [ $? -ne 0 ] ; then
+			echo Punch hole failed
+			break
+		fi
+
+		hole_offset=$(( $hole_offset + $hole_len + $hole_interval ))
+
+		_fill_fs $hole_len $path/fill.$i $block_size
+
+	done
+}
+
+# Make a small file system to fill
+umount $SCRATCH_DEV > /dev/null 2>&1
+_scratch_mkfs_sized $fs_size > /dev/null 2>&1
+_scratch_mount
+# Test must be able to write files with non-root permissions
+chmod 777 $SCRATCH_MNT
+
+block_size=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+_test_full_fs_punch $(( $block_size * 2 )) $block_size 500 $testfile $block_size
+
+status=0 ; exit
diff --git a/256.out b/256.out
new file mode 100644
index 0000000..e1b0437
--- /dev/null
+++ b/256.out
@@ -0,0 +1 @@
+QA output created by 256
diff --git a/common.rc b/common.rc
index 9d68574..2ee4a4a 100644
--- a/common.rc
+++ b/common.rc
@@ -887,6 +887,67 @@ _user_do()
     fi  
 }
 
+# _fill_fs()
+#
+# Fills a file system by repeatedly creating files in the given folder
+# starting with the given file size.  Files are reduced in size when
+# they can no longer fit untill no more files can be created.
+#
+# This routine is used by _test_full_fs_punch to test that a hole may
+# still be punched when the disk is full by borrowing reserved blocks.
+# All files are created as a non root user to prevent reserved blocks
+# from being consumed.
+#
+_fill_fs() {
+	local file_size=$1
+	local dir=$2
+	local block_size=$3
+	local file_count=1
+	local bytes_written=0
+	
+	if [ $# -ne 3 ] 
+	then
+		echo "USAGE: _fill_fs filesize dir block_size"
+		exit 1
+	fi  
+	
+	# Creation of files or folders
+	# must not be done as root or
+	# reserved blocks will be consumed
+	_user_do "mkdir -p $dir > /dev/null 2>&1"
+	if [ $? -ne 0 ] ; then
+		return 0
+	fi  
+
+	if [ $file_size -lt $block_size ]
+	then
+		file_size=$block_size
+	fi  
+
+	while [ $file_size -ge $block_size ]
+	do
+		bytes_written=0
+		_user_do "$XFS_IO_PROG -F -f -c \
+			\"pwrite 0 $file_size\" \
+			$dir/$file_count.bin > /dev/null 2>&1"
+		
+		if [ -f $dir/$file_count.bin ]
+		then
+			bytes_written=$($XFS_IO_PROG -F -c "stat" \
+				$dir/$file_count.bin | grep size | cut -d ' ' -f3)
+		fi  
+		
+		# If there was no room to make the file,
+		# then divide it in half, and keep going
+		if [ $bytes_written -lt $file_size ]
+		then
+			file_size=$(( $file_size / 2 ))
+		fi     
+		file_count=$(( $file_count + 1 ))
+
+	done
+}
+
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
 # fallocate
 #
diff --git a/group b/group
index 9558bc7..91d8b10 100644
--- a/group
+++ b/group
@@ -108,6 +108,9 @@ prealloc
 # on current systems
 deprecated
 
+# Punch Hole Tests
+punch
+
 #
 # test-group association ... one line per test
 #
@@ -288,8 +291,8 @@ deprecated
 172 rw filestreams
 173 rw filestreams
 174 rw filestreams auto
-175 dmapi auto
-176 dmapi auto
+175 dmapi auto punch
+176 dmapi auto punch
 177 rw other auto
 178 mkfs other auto
 179 metadata rw auto
@@ -365,7 +368,8 @@ deprecated
 249 auto quick rw 
 250 auto quick rw prealloc metadata
 251 ioctl trim
-252 auto quick prealloc
+252 auto quick prealloc punch
 253 auto quick
 254 auto quick
-255 auto quick prealloc
+255 auto quick prealloc punch
+256 auto punch
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
