Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D70C77F57
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2014 08:18:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B19978F8037
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2014 06:18:18 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	3QWreEjg5gKkDamn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 20 Apr 2014 06:18:13 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so1013888wiv.15
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2014 06:18:12 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] xfstests: btrfs,
	test send's ability to punch holes and prealloc extents
Date: Sun, 20 Apr 2014 15:17:03 +0100
Message-Id: <1398003423-14200-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
References: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

This test verifies that after an incremental btrfs send the
replicated file has the same exact hole and data structure as in
the origin filesystem. This didn't use to be the case before the
send stream version 2 - holes were sent as write operations of 0
valued bytes instead of punching holes with the fallocate system
call, and pre-allocated extents were sent as well as write
operations of 0 valued bytes instead of intructions for the
receiver to use the fallocate system call.

It also checks that prealloc extents that lie beyond the file's
size are replicated by an incremental send.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Addressed Dave's comments, and updated btrfs send invocation, by specifying
    the new command line option (-a) that enables use of fallocate - added
    function _require_btrfs_send_fallocate_flag() to skip the test when an old
    version of btrfs-progs is found.
V3: Corrected use of fiemap with _filter_fiemap. Was passing -l instead of -v
    to fiemap, which resulted in output consisting only of a single line related
    to a hole instead of all holes and data extents (and I wanted to verify the
    falloc -k extents were preserved after the btrfs send).
V4: Updated invocation of btrfs send, as the flag -a was removed from btrfs-send
    in favour of --stream-version=version

 common/rc           |   9 ++++
 tests/btrfs/047     | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/047.out |  35 +++++++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 167 insertions(+)
 create mode 100755 tests/btrfs/047
 create mode 100644 tests/btrfs/047.out

diff --git a/common/rc b/common/rc
index acf419b..a9d1c4c 100644
--- a/common/rc
+++ b/common/rc
@@ -2262,6 +2262,15 @@ _run_btrfs_util_prog()
 	run_check $BTRFS_UTIL_PROG $*
 }
 
+_require_btrfs_send_stream_version()
+{
+	$BTRFS_UTIL_PROG send 2>&1 | \
+		grep '^[ \t]*\-\-stream\-version <version>' > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_notrun "Missing btrfs-progs send --stream-version command line option, skipped this test"
+	fi
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/047 b/tests/btrfs/047
new file mode 100755
index 0000000..cc1936d
--- /dev/null
+++ b/tests/btrfs/047
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FS QA Test No. btrfs/047
+#
+# Verify that after an incremental btrfs send the replicated file has
+# the same exact hole and data structure as in the origin filesystem.
+# This didn't use to be the case before the send stream version 2 -
+# holes were sent as write operations of 0 valued bytes instead of punching
+# holes with the fallocate system call, and pre-allocated extents were sent
+# as well as write operations of 0 valued bytes instead of intructions for
+# the receiver to use the fallocate system call. Also check that prealloc
+# extents that lie beyond the file's size are replicated by an incremental
+# send.
+#
+# More specifically, this structure preserving guarantee was added by the
+# following linux kernel commits:
+#
+#    Btrfs: send, use fallocate command to punch holes
+#    Btrfs: send, use fallocate command to allocate extents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $send_files_dir
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fssum
+_require_xfs_io_fiemap
+_require_btrfs_send_stream_version
+_need_to_be_root
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 300000 0 300000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+$XFS_IO_PROG -c "fpunch 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "pwrite -S 0xff -b 1000 120000 1000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "fpunch 250000 20000" $SCRATCH_MNT/foo
+
+$XFS_IO_PROG -c "falloc -k 300000 1000000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc -k 9000000 2000000" $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send --stream-version 2 $SCRATCH_MNT/mysnap1 \
+	-f $send_files_dir/1.snap
+_run_btrfs_util_prog send --stream-version 2 -p $SCRATCH_MNT/mysnap1 \
+	$SCRATCH_MNT/mysnap2 -f $send_files_dir/2.snap
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/mysnap2/foo | _filter_fiemap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/mysnap2/foo | _filter_fiemap
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/047.out b/tests/btrfs/047.out
new file mode 100644
index 0000000..be39edc
--- /dev/null
+++ b/tests/btrfs/047.out
@@ -0,0 +1,35 @@
+QA output created by 047
+wrote 300000/300000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 120000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+0: [0..495]: data
+1: [496..519]: hole
+2: [520..2543]: data
+3: [2544..17575]: hole
+4: [17576..21487]: data
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+0: [0..495]: data
+1: [496..519]: hole
+2: [520..2543]: data
+3: [2544..17575]: hole
+4: [17576..21487]: data
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3a6d34e..d4e3fc1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -49,3 +49,4 @@
 044 auto quick
 045 auto quick
 046 auto quick
+047 auto quick
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
