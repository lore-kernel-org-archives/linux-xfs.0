Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SEgwKN231608 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 09:42:59 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 616DD15E82D4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 07:42:57 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id xdIj4NfFLfGHJfDB for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 07:42:57 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5SEV8D4005365
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:31:08 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5SEgti9145804 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:42:55 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5SEghBf012176
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:42:44 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/2 v7] XFS TESTS: Add ENOSPC Hole Punch Test
Date: Tue, 28 Jun 2011 07:45:01 -0700
Message-Id: <1309272301-5742-3-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
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


:000000 100644 0000000... 3d39fdb... A	255
:000000 100644 0000000... 3525403... A	255.out
:100644 100644 1f86075... c045e70... M	group
 255     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 255.out |    1 +
 group   |    1 +
 3 files changed, 180 insertions(+), 0 deletions(-)

diff --git a/255 b/255
new file mode 100644
index 0000000..3d39fdb
--- /dev/null
+++ b/255
@@ -0,0 +1,178 @@
+#! /bin/bash
+# FS QA Test No. 255
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
+testfile=$TEST_DIR/255.$$
+
+
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
+		echo "USAGE: _fill_fs filesize dir block size"
+		exit 1
+	fi
+
+	# Creation of files or folders
+	# must not be done as root or
+	# reserved blocks will be consumed
+	_user_do "mkdir -p $dir &> /dev/null"
+	if [ $? -ne 0 ] ; then
+		return 0
+	fi
+
+	if [ $file_size -lt $block_size ]
+	then
+		$file_size = $block_size
+	fi
+
+	while [ $file_size -ge $block_size ]
+	do
+		bytes_written=0
+		_user_do "$XFS_IO_PROG -F -f -c \"pwrite 0 $file_size\" $dir/$file_count.bin &> /dev/null"
+
+		if [ -f $dir/$file_count.bin ]
+		then
+			bytes_written=`$XFS_IO_PROG -F -c "stat"  $dir/$file_count.bin | grep size | cut -d ' ' -f3`
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
+	local path=`dirname $file_name`
+	local hole_offset=0
+
+	if [ $# -ne 5 ] 
+	then
+		echo "USAGE: _test_full_fs_punch hole_len hole_interval iterations file_name block_size"
+		exit 1
+	fi
+
+	rm -f $file_name &> /dev/null
+
+	$XFS_IO_PROG -F -f -c "pwrite 0 $file_len" \
+		-c "fsync" $file_name &> /dev/null
+	chmod 666 $file_name
+
+	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size
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
+umount $SCRATCH_DEV &> /dev/null
+_scratch_mkfs_sized $(( 1024 * 1024 * 1024 )) &> /dev/null
+_scratch_mount
+# Test must be able to write files with non-root permissions
+chmod 777 $SCRATCH_MNT
+
+block_size=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+_test_full_fs_punch $(( $block_size * 2 )) $block_size 500 $SCRATCH_MNT/252.$$ $block_size
+
+status=0 ; exit
diff --git a/255.out b/255.out
new file mode 100644
index 0000000..3525403
--- /dev/null
+++ b/255.out
@@ -0,0 +1 @@
+QA output created by 255
diff --git a/group b/group
index 1f86075..c045e70 100644
--- a/group
+++ b/group
@@ -368,3 +368,4 @@ deprecated
 252 auto quick prealloc
 253 auto quick
 254 auto quick
+255 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
