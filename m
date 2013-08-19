Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DFE57F9E
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 15:53:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15E55AC002
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:53:22 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id EaoDz5ubG77dEygx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 13:53:21 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0A97D7C065C
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 14:53:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: add regression test for kernel bz 60673 V2
Date: Mon, 19 Aug 2013 16:53:17 -0400
Message-ID: <1376945597-2202-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

There was a problem with send trying to overwrite a file that wasn't actually
the same.  This is a test to check this particular case where receive fails when
it should succeed properly.  I tested this to verify it fails without my fix and
passes with my fix.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: rebased onto newest xfstests and renumbered

 tests/btrfs/010     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/010.out |    2 +
 tests/btrfs/group   |    1 +
 3 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 tests/btrfs/010
 create mode 100644 tests/btrfs/010.out

diff --git a/tests/btrfs/010 b/tests/btrfs/010
new file mode 100644
index 0000000..f8258bf
--- /dev/null
+++ b/tests/btrfs/010
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. btrfs/010
+#
+# btrfs send ENOENT regression test, kernel bugzilla 60673
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+tmp_dir=send_temp_$seq
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap2 > /dev/null 2>&1
+	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
+	rm -rf $TEST_DIR/$tmp_dir
+	rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+
+#receive needs to be able to setxattrs, including the selinux context, if we use
+#the normal nfs context thing it screws up our ability to set the
+#security.selinux xattrs so we need to disable this for this test
+export SELINUX_MOUNT_OPTIONS=""
+
+_scratch_mount
+
+mkdir $TEST_DIR/$tmp_dir
+$BTRFS_UTIL_PROG subvol create $TEST_DIR/$tmp_dir/send \
+	> $seqres.full 2>&1 || _fail "failed subvol create"
+
+cd $TEST_DIR/$tmp_dir/send
+
+mkdir test
+touch test/baz
+touch test/blah
+mkdir test/foo
+touch test/foo/bar
+
+# cd out in case any of this fails
+cd /
+
+$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed snap1"
+
+$BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send1.dump \
+	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed send"
+
+$BTRFS_UTIL_PROG receive -f $TEST_DIR/$tmp_dir/send1.dump $SCRATCH_MNT \
+	>> $seqres.full 2>&1 || _fail "failed receive"
+
+#recreate everything exactly the way it was exceptn in a different order so we
+#get different inode numbers
+cd $TEST_DIR/$tmp_dir/send
+rm -rf test
+mkdir test
+touch test/baz
+mkdir test/foo
+touch test/foo/bar
+touch test/blah
+cd /
+
+$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
+	$TEST_DIR/$tmp_dir/snap2 >> $seqres.full 2>&1 || _fail "failed snap2"
+
+$BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send2.dump \
+	$TEST_DIR/$tmp_dir/snap2 -p $TEST_DIR/$tmp_dir/snap1 \
+	>> $seqres.full 2>&1 || _fail "failed second send"
+
+$BTRFS_UTIL_PROG receive -f $TEST_DIR/$tmp_dir/send2.dump $SCRATCH_MNT \
+	>> $seqres.full 2>&1 || _fail "failed second receive"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/010.out b/tests/btrfs/010.out
new file mode 100644
index 0000000..1d83a8d
--- /dev/null
+++ b/tests/btrfs/010.out
@@ -0,0 +1,2 @@
+QA output created by 010
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9eabadc..42a733e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -12,3 +12,4 @@
 007 auto rw metadata
 008 auto quick
 009 auto quick
+010 auto quick
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
