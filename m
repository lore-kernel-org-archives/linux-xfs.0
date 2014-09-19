Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B07B47F3F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 13:13:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73E148F8052
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 11:13:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vjXfCFW09CWdMSq4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Sep 2014 11:13:08 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs/062: add xfs unwritten extent data corruption reproducer
Date: Fri, 19 Sep 2014 14:13:05 -0400
Message-Id: <1411150385-32121-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here's a test for the data corruption issue I sent a fix for yesterday:

	http://oss.sgi.com/archives/xfs/2014-09/msg00259.html

It took a little time to improve the effectiveness of the test, but I've
been able to run it in current form for 90+ iterations without a false
negative (e.g., test passes when it shouldn't) on my setup. It runs in
~30s when there is no failure.

Brian

 tests/xfs/062     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/062.out |   5 +++
 tests/xfs/group   |   1 +
 3 files changed, 120 insertions(+)
 create mode 100755 tests/xfs/062
 create mode 100644 tests/xfs/062.out

diff --git a/tests/xfs/062 b/tests/xfs/062
new file mode 100755
index 0000000..61f8cf4
--- /dev/null
+++ b/tests/xfs/062
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 062
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	kill -9 $syncpid > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/punch
+
+# real QA test starts here
+
+_syncloop()
+{
+	while [ true ]
+	do
+		sync
+	done
+}
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "falloc"
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
+	for pgoff in $(seq 0 0x1000 0xf000)
+	do
+		offset=$((pgoff + 0xc00))
+		$XFS_IO_PROG -fc "pwrite $offset 0x1" $SCRATCH_MNT/file \
+			 > /dev/null 2>&1
+	done
+
+	# preallocate the first 64k and overwite, writing past 64k to contend
+	# with writeback
+	$XFS_IO_PROG \
+		-c "falloc 0 0x10000"	\
+		-c "pwrite 0 0x100000"	\
+		-c "fsync"		\
+		$SCRATCH_MNT/file > /dev/null 2>&1
+
+	# Check for unwritten extents. We should have none since we wrote over
+	# the entire preallocated region and ran fsync.
+	xfs_bmap -v $SCRATCH_MNT/file | _filter_bmap | grep unwritten \
+		> /dev/null 2>&1
+	if [ $? == 0 ]
+	then
+		xfs_bmap -v $SCRATCH_MNT/file
+		break
+	fi
+done
+
+echo $iters iterations
+
+kill $syncpid
+wait
+
+# clear page cache and dump the file
+_scratch_unmount
+_scratch_mount
+hexdump $SCRATCH_MNT/file
+
+_scratch_unmount
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/xfs/062.out b/tests/xfs/062.out
new file mode 100644
index 0000000..420f2e4
--- /dev/null
+++ b/tests/xfs/062.out
@@ -0,0 +1,5 @@
+QA output created by 062
+100 iterations
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0100000
diff --git a/tests/xfs/group b/tests/xfs/group
index 09bce15..685cbe7 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -57,6 +57,7 @@
 059 dump ioctl auto quick
 060 dump ioctl auto quick
 061 dump ioctl auto quick
+062 auto quick
 063 dump attr auto quick
 064 dump auto
 065 dump auto
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
