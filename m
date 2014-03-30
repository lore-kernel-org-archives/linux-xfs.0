Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBDD629DF7
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 16:11:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D9F68F804B
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 14:11:22 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	g6ziQCljxSUb9g9Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 14:11:19 -0700 (PDT)
Received: by mail-wi0-f181.google.com with SMTP id hm4so2396565wib.2
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 14:11:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: regression test for btrfs incremental send data
	corruption
Date: Sun, 30 Mar 2014 23:10:27 +0100
Message-Id: <1396217427-19533-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, clm@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Regression test for the btrfs incremental send feature, where the kernel
would incorrectly consider a range of a file as a hole and send a stream
of 0 bytes to the destination (send stream) that would overwrite the
corresponding file region.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: send, fix data corruption due to incorrect hole detection
   (https://patchwork.kernel.org/patch/3910081/)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/046     |  304 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/046.out |  213 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/group   |    1 +
 3 files changed, 518 insertions(+)
 create mode 100644 tests/btrfs/046
 create mode 100644 tests/btrfs/046.out

diff --git a/tests/btrfs/046 b/tests/btrfs/046
new file mode 100644
index 0000000..685e359
--- /dev/null
+++ b/tests/btrfs/046
@@ -0,0 +1,304 @@
+#! /bin/bash
+# FS QA Test No. btrfs/046
+#
+# Regression test for the btrfs incremental send feature, where the kernel
+# would incorrectly consider a range of a file as a hole and send a stream
+# of 0 bytes to the destination (send stream) that would overwrite the
+# corresponding file region.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: send, fix data corruption due to incorrect hole detection
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
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+_cleanup()
+{
+	rm -fr $send_files_dir
+	rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fssum
+_need_to_be_root
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "falloc -k 0 268435456" $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap0
+
+$XFS_IO_PROG -c "pwrite -S 0x01 -b 9216 16190218 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x02 -b 1121 198720104 1121" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x05 -b 9216 107887439 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x06 -b 9216 225520207 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x07 -b 67584 102138300 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x08 -b 7000 94897484 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x09 -b 113664 245083212 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x10 -b 123 17937788 123" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x11 -b 39936 229573311 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x12 -b 67584 174792222 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x13 -b 9216 249253213 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x16 -b 67584 150046083 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x17 -b 39936 118246040 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x18 -b 67584 215965442 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x19 -b 33792 97096725 33792" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x20 -b 125952 166300596 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x21 -b 123 1078957 123" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x25 -b 9216 212044492 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x26 -b 7000 265037146 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x27 -b 42757 215922685 42757" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x28 -b 7000 69865411 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x29 -b 67584 67948958 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x30 -b 39936 266967019 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x31 -b 1121 19582453 1121" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x32 -b 17408 257710255 17408" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x33 -b 39936 3895518 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x34 -b 125952 12045847 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x35 -b 17408 19156379 17408" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x36 -b 39936 50160066 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x37 -b 113664 9549793 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x38 -b 105472 94391506 105472" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x39 -b 23552 143632863 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x40 -b 39936 241283845 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x41 -b 113664 199937606 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x42 -b 67584 67380093 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x43 -b 67584 26793129 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x44 -b 39936 14421913 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x45 -b 123 253097405 123" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x46 -b 1121 128233424 1121" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x47 -b 105472 91577959 105472" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x48 -b 1121 7245381 1121" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x49 -b 113664 182414694 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x50 -b 9216 32750608 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x51 -b 67584 266546049 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x52 -b 67584 87969398 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x53 -b 9216 260848797 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x54 -b 39936 119461243 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x55 -b 7000 200178693 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x56 -b 9216 243316029 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x57 -b 7000 209658229 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x58 -b 101376 179745192 101376" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x59 -b 9216 64012300 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x60 -b 125952 181705139 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x61 -b 23552 235737348 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x62 -b 113664 106021355 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x63 -b 67584 135753552 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x64 -b 23552 95730888 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x65 -b 11 17311415 11" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x66 -b 33792 120695553 33792" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x67 -b 9216 17164631 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x68 -b 9216 136065853 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x69 -b 67584 37752198 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x70 -b 101376 189717473 101376" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x71 -b 7000 227463698 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x72 -b 9216 12655137 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x73 -b 7000 7488866 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x74 -b 113664 87813649 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x75 -b 33792 25802183 33792" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x76 -b 39936 93524024 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x77 -b 33792 113336388 33792" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x78 -b 105472 184955320 105472" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x79 -b 101376 225691598 101376" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x80 -b 23552 77023155 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x81 -b 11 201888192 11" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x82 -b 11 115332492 11" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x83 -b 67584 230278015 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x84 -b 11 120589073 11" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x85 -b 125952 202207819 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x86 -b 113664 86672080 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x87 -b 17408 208459603 17408" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x88 -b 7000 73372211 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x89 -b 7000 42252122 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x90 -b 23552 46784881 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x91 -b 101376 63172351 101376" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x92 -b 23552 59341931 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x93 -b 39936 239599283 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x94 -b 67584 175643105 67584" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x97 -b 23552 105534880 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x98 -b 113664 8236844 113664" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0x99 -b 125952 144489686 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa0 -b 7000 73273112 7000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa1 -b 125952 194580243 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa2 -b 123 56296779 123" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa3 -b 11 233066845 11" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa4 -b 39936 197727090 39936" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa5 -b 101376 53579812 101376" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa6 -b 9216 85669738 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa7 -b 125952 21266322 125952" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa8 -b 23552 125726568 23552" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xa9 -b 9216 18423680 9216" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xb0 -b 1121 165901483 1121" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+$XFS_IO_PROG -c "pwrite -S 0xff -b 10 16190218 10" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+echo "File digests in the original filesystem:"
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap0/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+_check_scratch_fs
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+
+echo "File digests in the replica filesystem:"
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/046.out b/tests/btrfs/046.out
new file mode 100644
index 0000000..1467c86
--- /dev/null
+++ b/tests/btrfs/046.out
@@ -0,0 +1,213 @@
+QA output created by 046
+wrote 9216/9216 bytes at offset 16190218
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1121/1121 bytes at offset 198720104
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 107887439
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 225520207
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 102138300
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 94897484
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 245083212
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 123/123 bytes at offset 17937788
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 229573311
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 174792222
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 249253213
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 150046083
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 118246040
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 215965442
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33792/33792 bytes at offset 97096725
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 166300596
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 123/123 bytes at offset 1078957
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 212044492
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 265037146
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 42757/42757 bytes at offset 215922685
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 69865411
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 67948958
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 266967019
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1121/1121 bytes at offset 19582453
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 17408/17408 bytes at offset 257710255
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 3895518
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 12045847
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 17408/17408 bytes at offset 19156379
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 50160066
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 9549793
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 105472/105472 bytes at offset 94391506
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 143632863
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 241283845
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 199937606
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 67380093
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 26793129
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 14421913
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 123/123 bytes at offset 253097405
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1121/1121 bytes at offset 128233424
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 105472/105472 bytes at offset 91577959
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1121/1121 bytes at offset 7245381
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 182414694
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 32750608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 266546049
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 87969398
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 260848797
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 119461243
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 200178693
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 243316029
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 209658229
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 101376/101376 bytes at offset 179745192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 64012300
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 181705139
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 235737348
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 106021355
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 135753552
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 95730888
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 17311415
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33792/33792 bytes at offset 120695553
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 17164631
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 136065853
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 37752198
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 101376/101376 bytes at offset 189717473
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 227463698
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 12655137
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 7488866
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 87813649
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33792/33792 bytes at offset 25802183
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 93524024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33792/33792 bytes at offset 113336388
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 105472/105472 bytes at offset 184955320
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 101376/101376 bytes at offset 225691598
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 77023155
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 201888192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 115332492
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 230278015
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 120589073
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 202207819
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 86672080
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 17408/17408 bytes at offset 208459603
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 73372211
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 42252122
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 46784881
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 101376/101376 bytes at offset 63172351
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 59341931
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 239599283
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 67584/67584 bytes at offset 175643105
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 105534880
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 113664/113664 bytes at offset 8236844
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 144489686
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 7000/7000 bytes at offset 73273112
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 194580243
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 123/123 bytes at offset 56296779
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 233066845
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 39936/39936 bytes at offset 197727090
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 101376/101376 bytes at offset 53579812
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 85669738
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 125952/125952 bytes at offset 21266322
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 23552/23552 bytes at offset 125726568
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 9216/9216 bytes at offset 18423680
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1121/1121 bytes at offset 165901483
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10/10 bytes at offset 16190218
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+79e53f1466bfc09fd82b450689e6119e  SCRATCH_MNT/foo
+d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/mysnap0/foo
+6eaa6adbb0d608958367d236a9fbe407  SCRATCH_MNT/mysnap1/foo
+79e53f1466bfc09fd82b450689e6119e  SCRATCH_MNT/mysnap2/foo
+File digests in the replica filesystem:
+6eaa6adbb0d608958367d236a9fbe407  SCRATCH_MNT/mysnap1/foo
+79e53f1466bfc09fd82b450689e6119e  SCRATCH_MNT/mysnap2/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9b41895..3a6d34e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -48,3 +48,4 @@
 043 auto quick
 044 auto quick
 045 auto quick
+046 auto quick
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
