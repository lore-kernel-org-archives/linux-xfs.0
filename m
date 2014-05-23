Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E478C7F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:58:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 653D0AC006
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 05:58:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d0ou8BqVI4sB5EMr for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 05:58:33 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: test speculative preallocation reclaim on ENOSPC
Date: Fri, 23 May 2014 08:58:31 -0400
Message-Id: <1400849911-46606-1-git-send-email-bfoster@redhat.com>
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

XFS can allocate significant amounts of space to files via speculative
preallocation. Such preallocation may not be reclaimed automatically on
file close() if a file is repeatedly opened and extended. For smaller
filesystems with relatively large and slow growing files, this
preallocation can linger for some time, including contributing to out of
space conditions.

Create a situation where an fs is near out of space while several files
still have lingering, significant preallocations. Verify that new
writers reclaim the preallocated space rather than return ENOSPC.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This test is associated with the recently posted eofblocks scan on
ENOSPC series. It currently fails and should pass with the
aforementioned patches applied. Thanks.

Brian

 tests/xfs/014     | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/014.out |  95 ++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 237 insertions(+)
 create mode 100755 tests/xfs/014
 create mode 100644 tests/xfs/014.out

diff --git a/tests/xfs/014 b/tests/xfs/014
new file mode 100755
index 0000000..53bc9e1
--- /dev/null
+++ b/tests/xfs/014
@@ -0,0 +1,141 @@
+#!/bin/bash
+# FS QA Test No. xfs/014
+#
+# Test the behavior of XFS dynamic speculative preallocation at ENOSPC
+# conditions. Speculative preallocation allocates post-EOF space to files as
+# they are extended. This test creates conditions that bypass natural low space
+# preallocation throttling and verifies that when no other space is available,
+# writers reclaim the preallocated space and do not fail with premature ENOSPC.
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
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# create a file that is likely to retain speculative preallocation after close
+_spec_prealloc_file()
+{
+	file=$1
+
+	rm -f $file
+
+	# a few file extending open-write-close cycles should be enough to
+	# trigger the fs to retain preallocation. write 256k in 32k intervals to
+	# be sure
+	for i in $(seq 0 32768 262144)
+	do
+		$XFS_IO_PROG -fc "pwrite $i 32k" $file | _filter_xfs_io
+	done
+
+	# write a 4k aligned amount of data to keep the calculations simple
+	$XFS_IO_PROG -c "pwrite 0 128m" $file | _filter_xfs_io
+
+	size=`stat -c "%s" $file`
+	blocks=`stat -c "%b" $file`
+	blocksize=`stat -c "%B" $file`
+
+	prealloc_size=$((blocks * blocksize - size))
+	if [ $prealloc_size -eq 0 ]
+	then
+		echo "Warning: No speculative preallocation for $file." \
+			"Check use of the allocsize= mount option."
+	fi
+
+	# keep a running total of how much preallocation we've created
+	TOTAL_PREALLOC=$((TOTAL_PREALLOC + prealloc_size))
+}
+
+_consume_free_space()
+{
+	dir=$1
+
+	# calculate the rough amount of free space in MB
+	fsblocksize=`$XFS_IO_PROG -x -c "statfs" $dir | grep f_bsize | \
+			awk '{ print $3 }'`
+	blocksavail=`$XFS_IO_PROG -x -c "statfs" $dir | grep f_bavail | \
+			awk '{ print $3 }'`
+	freesp=$((fsblocksize * blocksavail / 1024 / 1024))
+
+	# allocate all but 10MB
+	freesp=$((freesp - 10))
+	$XFS_IO_PROG -fc "falloc 0 ${freesp}M" $dir/spc
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+# 10GB fs
+_scratch_mkfs_xfs_opts "-d size=$((1024*1024*1024 * 10))" | \
+	 _filter_mkfs 2>> $seqres.full
+_scratch_mount
+
+# make sure the background eofblocks scanner doesn't interfere
+orig_sp_time=`cat /proc/sys/fs/xfs/speculative_prealloc_lifetime`
+echo 9999 > /proc/sys/fs/xfs/speculative_prealloc_lifetime
+
+# create a few files with relatively significant preallocation
+TOTAL_PREALLOC=0
+for i in $(seq 0 3)
+do
+	_spec_prealloc_file $SCRATCH_MNT/pre$i
+done
+
+# consume most of the remaining free space in the fs to put us near ENOSPC
+_consume_free_space $SCRATCH_MNT
+
+# start a few background writers to consume the bulk of the space that has been
+# previously preallocated to other files. this space should be reclaimed such
+# these writers complete without hitting ENOSPC
+write_size=$((TOTAL_PREALLOC / 2 / 4))
+for i in $(seq 0 3)
+do
+	$XFS_IO_PROG -fc "pwrite 0 $write_size" $SCRATCH_MNT/file.$i | \
+		_filter_xfs_io &
+done
+wait
+
+echo $orig_sp_time > /proc/sys/fs/xfs/speculative_prealloc_lifetime
+umount $SCRATCH_MNT
+
+status=0
+exit
diff --git a/tests/xfs/014.out b/tests/xfs/014.out
new file mode 100644
index 0000000..aed3c0f
--- /dev/null
+++ b/tests/xfs/014.out
@@ -0,0 +1,95 @@
+QA output created by 014
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 98304
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 163840
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 196608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 229376
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 134217728/134217728 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 98304
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 163840
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 196608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 229376
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 134217728/134217728 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 98304
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 163840
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 196608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 229376
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 134217728/134217728 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 98304
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 163840
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 196608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 229376
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 134217728/134217728 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67076096/67076096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67076096/67076096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67076096/67076096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67076096/67076096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/xfs/group b/tests/xfs/group
index 19fd968..a39afc1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -10,6 +10,7 @@
 010 auto quick repair
 012 rw auto quick
 013 auto metadata stress
+014 auto enospc quick
 016 rw auto quick
 017 mount auto quick stress
 018 deprecated # log logprint v2log
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
