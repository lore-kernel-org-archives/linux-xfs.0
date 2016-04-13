Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EB9D7CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:04:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA4DDAC003
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:04:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4FPc83W3UoAAqf1E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:04:55 -0700 (PDT)
Date: Tue, 12 Apr 2016 21:04:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/3] block: test fallocate for block devices
Message-ID: <20160413040421.GB25280@birch.djwong.org>
References: <20160413040121.10562.98998.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160413040121.10562.98998.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

Now that we're wiring up fallocate's PUNCH_HOLE and ZERO_RANGE
features for block devices, add some tests to make sure they
work correctly.

v2: Update tests to reflect EOD clamping suggested by Linus.
Note that the VFS fallocate makes us play some weird games wrt
MAX_LFS_FILESIZE.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/scsi_debug     |    6 ++
 tests/generic/705     |   89 ++++++++++++++++++++++++++++++++++
 tests/generic/705.out |   11 ++++
 tests/generic/706     |   86 ++++++++++++++++++++++++++++++++
 tests/generic/706.out |   10 ++++
 tests/generic/707     |  130 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/707.out |   32 ++++++++++++
 tests/generic/group   |    3 +
 8 files changed, 366 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/705
 create mode 100644 tests/generic/705.out
 create mode 100755 tests/generic/706
 create mode 100644 tests/generic/706.out
 create mode 100755 tests/generic/707
 create mode 100644 tests/generic/707.out

diff --git a/common/scsi_debug b/common/scsi_debug
index eb08126..74c3802 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -40,13 +40,17 @@ _get_scsi_debug_dev()
 	logical=${2-512}
 	unaligned=${3-0}
 	size=${4-128}
+	test -n "$4" && shift
+	test -n "$3" && shift
+	test -n "$2" && shift
+	test -n "$1" && shift
 
 	phys_exp=0
 	while [ $logical -lt $physical ]; do
 		let physical=physical/2
 		let phys_exp=phys_exp+1
 	done
-	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size"
+	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
 	echo "scsi_debug options $opts" >> $seqres.full
 	modprobe scsi_debug $opts
 	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
diff --git a/tests/generic/705 b/tests/generic/705
new file mode 100755
index 0000000..f30f2c3
--- /dev/null
+++ b/tests/generic/705
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 705
+#
+# Test fallocate(ZERO_RANGE) on a block device, which should be able to
+# WRITE SAME (or equivalent) the range.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/scsi_debug
+
+# real QA test starts here
+_supported_os Linux
+_require_scsi_debug
+_require_xfs_io_command "fzero"
+
+echo "Create and format"
+dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
+_pwrite_byte 0x62 0 4m $dev >> $seqres.full
+
+echo "Zero range"
+$XFS_IO_PROG -c "fzero -k 512k 1m" $dev
+
+echo "Zero range without keep_size"
+$XFS_IO_PROG -c "fzero 384k 64k" $dev
+
+echo "Zero range past EOD"
+$XFS_IO_PROG -c "fzero -k 3m 4m" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Zero range to MAX_LFS_FILESIZE"
+# zod = MAX_LFS_FILESIZE
+case "$(getconf LONG_BIT)" in
+"32")
+	zod=$(( ($(getconf PAGE_SIZE) << ($(getconf LONG_BIT) - 1) ) - 1))
+	;;
+"64")
+	zod=9223372036854775807
+	;;
+*)
+	_fail "sizeof(long) == $(getconf LONG_BIT)?"
+	;;
+esac
+$XFS_IO_PROG -c "fzero -k 0 $zod" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Destroy device"
+_put_scsi_debug_dev
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/705.out b/tests/generic/705.out
new file mode 100644
index 0000000..86d0317
--- /dev/null
+++ b/tests/generic/705.out
@@ -0,0 +1,11 @@
+QA output created by 705
+Create and format
+Zero range
+Zero range without keep_size
+Zero range past EOD
+Check contents
+f0cb9070c098aa347f664bead3a219d9  SCSI_DEBUG_DEV
+Zero range to MAX_LFS_FILESIZE
+Check contents
+b5cfa9d6c8febd618f91ac2843d50a1c  SCSI_DEBUG_DEV
+Destroy device
diff --git a/tests/generic/706 b/tests/generic/706
new file mode 100755
index 0000000..dd502e2
--- /dev/null
+++ b/tests/generic/706
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 706
+#
+# Test fallocate(PUNCH_HOLE) on a block device, which should be able to
+# zero-TRIM (or equivalent) the range.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/scsi_debug
+
+# real QA test starts here
+_supported_os Linux
+_require_scsi_debug
+_require_xfs_io_command "fpunch"
+
+echo "Create and format"
+dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
+_pwrite_byte 0x62 0 4m $dev >> $seqres.full
+
+echo "Zero punch"
+$XFS_IO_PROG -c "fpunch 512k 1m" $dev
+
+echo "Punch range past EOD"
+$XFS_IO_PROG -c "fpunch 3m 4m" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Punch to MAX_LFS_FILESIZE"
+# zod = MAX_LFS_FILESIZE
+case "$(getconf LONG_BIT)" in
+"32")
+	zod=$(( ($(getconf PAGE_SIZE) << ($(getconf LONG_BIT) - 1) ) - 1))
+	;;
+"64")
+	zod=9223372036854775807
+	;;
+*)
+	_fail "sizeof(long) == $(getconf LONG_BIT)?"
+	;;
+esac
+$XFS_IO_PROG -c "fpunch 0 $zod" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Destroy device"
+_put_scsi_debug_dev
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/706.out b/tests/generic/706.out
new file mode 100644
index 0000000..de8de0c
--- /dev/null
+++ b/tests/generic/706.out
@@ -0,0 +1,10 @@
+QA output created by 706
+Create and format
+Zero punch
+Punch range past EOD
+Check contents
+8c6a3fd51601141b56eaebbab3746156  SCSI_DEBUG_DEV
+Punch to MAX_LFS_FILESIZE
+Check contents
+b5cfa9d6c8febd618f91ac2843d50a1c  SCSI_DEBUG_DEV
+Destroy device
diff --git a/tests/generic/707 b/tests/generic/707
new file mode 100755
index 0000000..229b152
--- /dev/null
+++ b/tests/generic/707
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 707
+#
+# Test the unsupported fallocate flags on a block device.  No collapse
+# or insert range, no regular fallocate, no forgetting keep-space on
+# zero range, no punching past EOD, no requests that aren't aligned
+# with the logicalsector size, and make sure the fallbacks work for
+# devices that don't support write_same or discard.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/scsi_debug
+
+# real QA test starts here
+_supported_os Linux
+_require_scsi_debug
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "fpunch"
+
+
+echo "Create and format"
+dev=$(_get_scsi_debug_dev 4096 4096 0 4 "lbpws=1 lbpws10=1")
+_pwrite_byte 0x62 0 4m $dev >> $seqres.full
+$XFS_IO_PROG -c "fsync" $dev
+
+echo "Regular fallocate"
+$XFS_IO_PROG -c "falloc 64k 64k" $dev
+
+echo "Insert range"
+$XFS_IO_PROG -c "finsert 128k 64k" $dev
+
+echo "Collapse range"
+$XFS_IO_PROG -c "fcollapse 256k 64k" $dev
+
+echo "Unaligned zero range"
+$XFS_IO_PROG -c "fzero -k 512 512" $dev
+
+echo "Unaligned punch"
+$XFS_IO_PROG -c "fpunch 512 512" $dev
+
+echo "Zero range past MAX_LFS_FILESIZE keep size"
+# zod = MAX_LFS_FILESIZE
+case "$(getconf LONG_BIT)" in
+"32")
+	zod=$(( ($(getconf PAGE_SIZE) << ($(getconf LONG_BIT) - 1) ) - 1))
+	;;
+"64")
+	zod=9223372036854775807
+	;;
+*)
+	_fail "sizeof(long) == $(getconf LONG_BIT)?"
+	;;
+esac
+$XFS_IO_PROG -c "fzero -k 512k $zod" $dev
+
+echo "Zero range past MAX_LFS_FILESIZE"
+$XFS_IO_PROG -c "fzero 512k $zod" $dev
+
+echo "Zero range to MAX_LFS_FILESIZE fail w/o keepsize"
+$XFS_IO_PROG -c "fzero 0 $zod" $dev
+
+echo "Zero range starts past EOD"
+$XFS_IO_PROG -c "fzero -k 900m 1m" $dev
+
+echo "Punch starts past EOD"
+$XFS_IO_PROG -c "fpunch 900m 1m" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Destroy device"
+_put_scsi_debug_dev
+
+echo "Create w/o unmap or writesame and format"
+dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=0 lbpws10=0 lbpu=0 write_same_length=0 unmap_max_blocks=0")
+_pwrite_byte 0x62 0 4m $dev >> $seqres.full
+$XFS_IO_PROG -c "fsync" $dev
+
+echo "Zero punch, no fallback available"
+$XFS_IO_PROG -c "fpunch 512k 512k" $dev
+
+echo "Zero range, write fallback"
+$XFS_IO_PROG -c "fzero -k 1536k 512k" $dev
+
+echo "Check contents"
+md5sum $dev | sed -e "s|$dev|SCSI_DEBUG_DEV|g"
+
+echo "Destroy device"
+_put_scsi_debug_dev
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/707.out b/tests/generic/707.out
new file mode 100644
index 0000000..a520221
--- /dev/null
+++ b/tests/generic/707.out
@@ -0,0 +1,32 @@
+QA output created by 707
+Create and format
+Regular fallocate
+fallocate: Operation not supported
+Insert range
+fallocate: Operation not supported
+Collapse range
+fallocate: Operation not supported
+Unaligned zero range
+fallocate: Invalid argument
+Unaligned punch
+fallocate: Invalid argument
+Zero range past MAX_LFS_FILESIZE keep size
+fallocate: File too large
+Zero range past MAX_LFS_FILESIZE
+fallocate: File too large
+Zero range to MAX_LFS_FILESIZE fail w/o keepsize
+fallocate: Invalid argument
+Zero range starts past EOD
+fallocate: Invalid argument
+Punch starts past EOD
+fallocate: Invalid argument
+Check contents
+b83f9394092e15bdcda585cd8e776dc6  SCSI_DEBUG_DEV
+Destroy device
+Create w/o unmap or writesame and format
+Zero punch, no fallback available
+fallocate: Operation not supported
+Zero range, write fallback
+Check contents
+0fc6bc93cd0cd97e3cde5ea39ea1185d  SCSI_DEBUG_DEV
+Destroy device
diff --git a/tests/generic/group b/tests/generic/group
index ef1a423..cc14c80 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -345,3 +345,6 @@
 340 auto
 341 auto quick metadata
 342 auto quick metadata
+705 blockdev quick rw
+706 blockdev quick rw
+707 blockdev quick rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
