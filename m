Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n764UmP9026809 for <xfs@oss.sgi.com>; Wed, 5 Aug 2009 23:30:49 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F6212B05F4
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 21:41:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1oE8GG6JBqc1QMdB for
	<xfs@oss.sgi.com>; Wed, 05 Aug 2009 21:41:09 -0700 (PDT)
Message-ID: <4A7A5CA8.8040702@sandeen.net>
Date: Wed, 05 Aug 2009 23:31:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests 218: very basic defragmentation testing for xfs
	& ext4
References: <4A5E3A37.5050306@redhat.com>
In-Reply-To: <4A5E3A37.5050306@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Test a few very basic defragmentation scenarios.

This test creates some files, runs defrag on them,
and compares the before/after fragmentation as well
as file md5sums and timestamps.

The test currently expects to find e4defrag in
/usr/bin

It should be relatively easy to add more interestingly
fragmented files to the tests, as well as to test
that memory-mapped files aren't touched, etc - 
but this gives us a framework.

V2: remount before checking file contents, and create
common.defrag.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/218 b/218
new file mode 100755
index 0000000..8c8afe7
--- /dev/null
+++ b/218
@@ -0,0 +1,96 @@
+#! /bin/sh
+# FS QA Test No. 218
+#
+# Basic defragmentation sanity tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
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
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    _cleanup_testdir
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_fs xfs ext4
+_supported_os Linux
+
+_setup_testdir
+# We require scratch so that we'll have free contiguous space
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_require_defrag
+
+fragfile=$SCRATCH_MNT/fragfile.$$
+
+rm -f $fragfile
+
+# Craft some fragmented files, defrag them, check the result.
+
+echo "zero-length file:" | tee -a $seq.full
+touch $fragfile
+_defrag $fragfile
+
+echo "Sparse file (no blocks):" | tee -a $seq.full
+xfs_io -F -f -c "truncate 1m" $fragfile
+_defrag $fragfile
+
+echo "Contiguous file:" | tee -a $seq.full
+dd if=/dev/zero of=$fragfile bs=4k count=4 &>/dev/null
+_defrag $fragfile
+
+echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seq.full
+for I in `seq 9 -1 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seq.full
+for I in `seq 31 -2 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seq.full
+for I in `seq 0 2 31`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+rm -f $seq.full
+status=0
+exit
diff --git a/218.out b/218.out
new file mode 100644
index 0000000..7559cdd
--- /dev/null
+++ b/218.out
@@ -0,0 +1,19 @@
+QA output created by 218
+zero-length file:
+Before: 0
+After: 0
+Sparse file (no blocks):
+Before: 0
+After: 0
+Contiguous file:
+Before: 1
+After: 1
+Write backwards sync, but contiguous - should defrag to 1 extent
+Before: 10
+After: 1
+Write backwards sync leaving holes - defrag should do nothing
+Before: 16
+After: 16
+Write forwards sync leaving holes - defrag should do nothing
+Before: 16
+After: 16
diff --git a/common.defrag b/common.defrag
new file mode 100644
index 0000000..a0716de
--- /dev/null
+++ b/common.defrag
@@ -0,0 +1,68 @@
+##/bin/sh
+#
+# Copyright (c) 2009 Eric Sandeen
+# All Rights Reserved.
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
+#
+# Functions useful for defragmentation tests
+#
+
+_require_defrag()
+{
+    case "$FSTYP" in
+    xfs)
+        DEFRAG_PROG=/usr/sbin/xfs_fsr
+	;;
+    ext4)
+        DEFRAG_PROG=/usr/bin/e4defrag
+	;;
+    *)
+        _notrun "defragmentation not supported for fstype \"$FSTYP\""
+	;;
+    esac
+
+    _require_command $DEFRAG_PROG
+    _require_command /usr/sbin/filefrag
+}
+
+_extent_count()
+{
+	filefrag $1 | awk '{print $2}'
+	filefrag -v $1  >> $seq.full 2>&1
+}
+
+# Defrag file, check it, and remove it.
+_defrag()
+{
+	echo -n "Before: "
+	_extent_count $1
+	CSUM_BEFORE=`md5sum $1`
+	STAT_BEFORE=`stat -c "a: %x m: %y c: %z" $1`
+	$DEFRAG_PROG -v $1 >> $seq.full 2>&1
+	_scratch_remount
+	STAT_AFTER=`stat -c "a: %x m: %y c: %z" $1`
+	CSUM_AFTER=`md5sum $1`
+	echo -n "After: "
+	_extent_count $1
+	if [ "$CSUM_BEFORE" != "$CSUM_AFTER" ]; then
+		_fail "file checksum changed post-defrag ($CSUM_BEFORE/$CSUM_AFTER)"
+	fi
+	if [ "$STAT_BEFORE" != "$STAT_AFTER" ]; then
+		_fail "file timestamps changed post-defrag:\n$STAT_BEFORE\n$STAT_AFTER"
+	fi
+	rm -f $1
+}
+
diff --git a/common.rc b/common.rc
index 0d655ca..82b0d51 100644
--- a/common.rc
+++ b/common.rc
@@ -198,6 +198,17 @@ _scratch_mount()
     _mount -t $FSTYP `_scratch_mount_options $*`
 }
 
+_scratch_unmount()
+{
+    $UMOUNT_PROG $SCRATCH_DEV
+}
+
+_scratch_remount()
+{
+    _scratch_unmount
+    _scratch_mount
+}
+
 _test_mount()
 {
     _test_options mount
diff --git a/group b/group
index 7a67ce7..b11f6a1 100644
--- a/group
+++ b/group
@@ -327,3 +327,4 @@ prealloc
 215 auto metadata quick
 216 log metadata auto quick
 217 log metadata auto
+218 auto fsr quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
