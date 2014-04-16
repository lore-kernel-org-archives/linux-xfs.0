Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C0E07F4E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:03:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B33D7AC003
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:03:51 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id fCy5LwgvAq4GvOYL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:03:49 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id x48so10621870wes.7
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:03:48 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: btrfs, add test for btrfs properties
Date: Wed, 16 Apr 2014 16:04:26 +0100
Message-Id: <1397660666-8300-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397591424-25439-1-git-send-email-fdmanana@gmail.com>
References: <1397591424-25439-1-git-send-email-fdmanana@gmail.com>
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

This test case verifies the btrfs properties feature, a new feature
introduced in the linux kernel version 3.14.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Addressed Dave's comments, removed function to check for existence of
    the btrfs-progs property command and use instead existing function
    _require_btrfs which checks if a btrfs-progs command exists and is
    equivalent to what I had before.

 tests/btrfs/048     | 220 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/048.out |  78 +++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 299 insertions(+)
 create mode 100755 tests/btrfs/048
 create mode 100644 tests/btrfs/048.out

diff --git a/tests/btrfs/048 b/tests/btrfs/048
new file mode 100755
index 0000000..e998f97
--- /dev/null
+++ b/tests/btrfs/048
@@ -0,0 +1,220 @@
+#! /bin/bash
+# FS QA Test No. btrfs/048
+#
+# Btrfs properties test. The btrfs properties feature was introduced in the
+# linux kernel 3.14.
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
+here=`pwd`
+tmp=/tmp/$$
+
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
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_btrfs "property"
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
+echo "Testing label property"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT label foobar
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT label ''
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+mkdir $SCRATCH_MNT/testdir
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir label
+echo "***"
+
+echo -e "\nTesting subvolume ro property"
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/sv1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 ro
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro foo
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro true
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 ro
+echo "***"
+touch $SCRATCH_MNT/sv1/foobar 2>&1 | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro false
+touch $SCRATCH_MNT/sv1/foobar 2>&1 | _filter_scratch
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1
+echo "***"
+
+echo -e "\nTesting compression property"
+mkdir $SCRATCH_MNT/testdir/subdir1
+touch $SCRATCH_MNT/testdir/file1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression \
+	foo 2>&1 | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression lzo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+# Verify property was persisted.
+_scratch_unmount
+_check_scratch_fs
+_scratch_mount
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression zlib
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression ''
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+# Test compression property inheritance.
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression lzo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+mkdir $SCRATCH_MNT/testdir/subdir1/subsubdir
+touch $SCRATCH_MNT/testdir/subdir1/some_file
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+mkdir $SCRATCH_MNT/testdir/subdir1/subsubdir/foo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir/foo \
+	compression
+echo "***"
+
+# Verify property was persisted.
+_scratch_unmount
+_check_scratch_fs
+_scratch_mount
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir/foo \
+	compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1/subsubdir \
+	compression ''
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1/some_file \
+	compression ''
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression ''
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+touch $SCRATCH_MNT/testdir/subdir1/some_file_2
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file_2 \
+	compression
+echo "***"
+
+# Verify send is able to replicate properties.
+echo -e "\nTesting properties with send"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression lzo
+touch $SCRATCH_MNT/testdir/subdir1/foobar
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/foobar compression
+echo "***"
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+touch $SCRATCH_MNT/testdir/subdir1/foobar2
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+_scratch_unmount
+_check_scratch_fs
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1/foobar \
+	compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1/foobar2 \
+	compression
+echo "***"
+
+_scratch_unmount
+_check_scratch_fs
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+echo -e "\nTesting subvolume properties"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
+echo "***"
+touch $SCRATCH_MNT/file1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/file1 compression
+echo "***"
+mkdir $SCRATCH_MNT/dir1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1 compression
+echo "***"
+mkdir $SCRATCH_MNT/dir1/subdir1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1/subdir1 compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/dir1/subdir1 compression 'zlib'
+touch $SCRATCH_MNT/dir1/subdir1/foo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1/subdir1/foo compression
+
+echo -e "\nTesting subvolume property inheritance"
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/sv1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
+touch $SCRATCH_MNT/sv1/file2
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
new file mode 100644
index 0000000..0b20d0b
--- /dev/null
+++ b/tests/btrfs/048.out
@@ -0,0 +1,78 @@
+QA output created by 048
+Testing label property
+label=
+***
+label=foobar
+***
+ro=false
+label=foobar
+***
+label=
+***
+ERROR: object is not compatible with property
+***
+
+Testing subvolume ro property
+ro=false
+***
+ERROR: invalid value for property.
+***
+***
+ro=true
+***
+touch: cannot touch 'SCRATCH_MNT/sv1/foobar': Read-only file system
+***
+ro=false
+***
+
+Testing compression property
+***
+ERROR: failed to set compression for SCRATCH_MNT/testdir/file1. Invalid argument
+***
+compression=lzo
+compression=lzo
+compression=zlib
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+***
+***
+***
+***
+***
+
+Testing properties with send
+compression=lzo
+compression=lzo
+***
+compression=lzo
+compression=lzo
+compression=lzo
+***
+
+Testing subvolume properties
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=zlib
+
+Testing subvolume property inheritance
+compression=lzo
+compression=lzo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d4e3fc1..af60c79 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -50,3 +50,4 @@
 045 auto quick
 046 auto quick
 047 auto quick
+048 auto quick
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
