Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C7D8E7F58
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 18:21:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B1FE304053
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 16:21:12 -0800 (PST)
Received: from mail-we0-f178.google.com (mail-we0-f178.google.com
	[74.125.82.178]) by cuda.sgi.com with ESMTP id LeSQ7Za6dXh1INZ5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 16:21:10 -0800 (PST)
Received: by mail-we0-f178.google.com with SMTP id q59so9943569wes.23
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 16:21:08 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] xfstests: add regression test for btrfs incremental send
Date: Mon, 17 Feb 2014 00:20:38 +0000
Message-Id: <1392596438-6509-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
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
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Test for a btrfs incremental send issue where we end up sending a
wrong section of data from a file extent if the corresponding file
extent is compressed and the respective file extent item has a non
zero data offset.

Fixed by the following linux kernel btrfs patch:

   Btrfs: use right clone root offset for compressed extents

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
    hole punch implementation leaving hole file extent items when we punch
    beyond the file's current size.
V3: Filter xfs_io output and make less use of the run_check function, as
    suggested by Dave Chinner.

 common/rc           |    5 +++
 tests/btrfs/040     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/040.out |    9 ++++
 tests/btrfs/group   |    1 +
 4 files changed, 134 insertions(+)
 create mode 100755 tests/btrfs/040
 create mode 100644 tests/btrfs/040.out

diff --git a/common/rc b/common/rc
index e91568b..27be009 100644
--- a/common/rc
+++ b/common/rc
@@ -2207,6 +2207,11 @@ run_check()
 	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
 }
 
+_run_btrfs_util_prog()
+{
+	run_check $BTRFS_UTIL_PROG $*
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/040 b/tests/btrfs/040
new file mode 100755
index 0000000..9037782
--- /dev/null
+++ b/tests/btrfs/040
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test No. btrfs/040
+#
+# Test for a btrfs incremental send issue where we end up sending a
+# wrong section of data from a file extent if the corresponding file
+# extent is compressed and the respective file extent item has a non
+# zero data offset.
+#
+# Fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: use right clone root offset for compressed extents
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
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
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
+_need_to_be_root
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount "-o compress-force=lzo"
+
+$XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap1
+
+$XFS_IO_PROG -c "pwrite -S 0x3e -b 80000 200000 80000" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Sync to avoid btrfs merging file extent items, which would make the test
+# succeed when it should fail.
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+
+$XFS_IO_PROG -c "pwrite -S 0xdc -b 10000 250000 10000" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+$XFS_IO_PROG -c "pwrite -S 0xff -b 10000 300000 10000" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# will be used for incremental send to be able to issue clone operations
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/clones_snap
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	-x $SCRATCH_MNT/mysnap2/clones_snap $SCRATCH_MNT/mysnap2
+run_check $FSSUM_PROG -A -f -w $tmp/clones.fssum $SCRATCH_MNT/clones_snap \
+	-x $SCRATCH_MNT/clones_snap/mysnap1 -x $SCRATCH_MNT/clones_snap/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+_run_btrfs_util_prog send $SCRATCH_MNT/clones_snap -f $tmp/clones.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 \
+	-c $SCRATCH_MNT/clones_snap $SCRATCH_MNT/mysnap2 -f $tmp/2.snap
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/clones.snap
+run_check $FSSUM_PROG -r $tmp/clones.fssum $SCRATCH_MNT/clones_snap 2>> $seqres.full
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/040.out b/tests/btrfs/040.out
new file mode 100644
index 0000000..cc77aed
--- /dev/null
+++ b/tests/btrfs/040.out
@@ -0,0 +1,9 @@
+QA output created by 040
+wrote 39987/39987 bytes at offset 92267
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 80000/80000 bytes at offset 200000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10000/10000 bytes at offset 250000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10000/10000 bytes at offset 300000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2ca2225..a687634 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -38,3 +38,4 @@
 033 auto quick
 034 auto quick
 036 auto quick
+040 auto quick
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
