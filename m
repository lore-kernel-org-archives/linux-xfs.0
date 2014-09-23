Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57D397F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 07:42:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37BFD304053
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 05:42:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yGaoQDtUyCU5QuL7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 05:42:26 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] generic/032: add xfs unwritten extent data corruption
	reproducer
Date: Tue, 23 Sep 2014 08:42:24 -0400
Message-Id: <1411476144-51074-1-git-send-email-bfoster@redhat.com>
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

XFS had a data corruption problem where writeback of pages to unwritten
extents would fail to run unwritten extent conversion at I/O completion.
This causes subsequent reads of written, but unconverted regions to
return zeroes. This occurs on sub-page block size filesystems when
writeback contends for the inode lock (e.g., with a file writer).

Add a test that creates the conditions to reproduce the data corruption
and detect it by looking for unwritten extents after all said extents
have been overwritten.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3:
- Exit test (_fail) on unwritten extent detection.
v2: http://oss.sgi.com/archives/xfs/2014-09/msg00315.html
- Converted to generic test.
- Use fiemap instead of xfs_bmap.
- Added to rw group.
- Various fixups: init/clean $tmp, loop syntax, redirect output to
  $seqres.full, use _scratch_remount.
v1: http://oss.sgi.com/archives/xfs/2014-09/msg00296.html

 tests/generic/032     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/032.out |   5 +++
 tests/generic/group   |   1 +
 3 files changed, 117 insertions(+)
 create mode 100755 tests/generic/032
 create mode 100644 tests/generic/032.out

diff --git a/tests/generic/032 b/tests/generic/032
new file mode 100755
index 0000000..53fb3de
--- /dev/null
+++ b/tests/generic/032
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 032
+#
+# This test implements a data corruption scenario on XFS filesystems with
+# sub-page sized blocks and unwritten extents. Inode lock contention during
+# writeback of pages to unwritten extents leads to failure to convert those
+# extents on I/O completion. This causes data corruption as unwritten extents
+# are always read back as zeroes.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	kill -9 $syncpid > /dev/null 2>&1
+	wait
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/punch
+
+# real QA test starts here
+rm -f $seqres.full
+
+_syncloop()
+{
+	while [ true ]; do
+		sync
+	done
+}
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# run background sync thread
+_syncloop &
+syncpid=$!
+
+for iters in $(seq 1 100)
+do
+	rm -f $SCRATCH_MNT/file
+
+	# create a delalloc block in each page of the first 64k of the file
+	for pgoff in $(seq 0 0x1000 0xf000); do
+		offset=$((pgoff + 0xc00))
+		$XFS_IO_PROG -f \
+			-c "pwrite $offset 0x1" \
+			$SCRATCH_MNT/file >> $seqres.full 2>&1
+	done
+
+	# preallocate the first 64k and overwite, writing past 64k to contend
+	# with writeback
+	$XFS_IO_PROG \
+		-c "falloc 0 0x10000"	\
+		-c "pwrite 0 0x100000"	\
+		-c "fsync"		\
+		$SCRATCH_MNT/file >> $seqres.full 2>&1
+
+	# Check for unwritten extents. We should have none since we wrote over
+	# the entire preallocated region and ran fsync.
+	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/file | \
+		tee -a $seqres.full | \
+		_filter_fiemap | grep unwritten
+	[ $? == 0 ] && _fail "Unwritten extents found!"
+done
+
+echo $iters iterations
+
+kill $syncpid
+wait
+
+# clear page cache and dump the file
+_scratch_remount
+hexdump $SCRATCH_MNT/file
+
+status=0
+exit
diff --git a/tests/generic/032.out b/tests/generic/032.out
new file mode 100644
index 0000000..ca5376d
--- /dev/null
+++ b/tests/generic/032.out
@@ -0,0 +1,5 @@
+QA output created by 032
+100 iterations
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0100000
diff --git a/tests/generic/group b/tests/generic/group
index bdcfd9d..8e0c22a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -31,6 +31,7 @@
 026 acl quick auto
 027 auto enospc
 028 auto quick
+032 auto quick rw
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
