Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FKKZev219309 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 15:20:35 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7A53366B1D
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 13:21:14 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 9igpmBvv3qtkmwtv for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2009 13:21:14 -0700 (PDT)
Message-ID: <4A5E3A37.5050306@redhat.com>
Date: Wed, 15 Jul 2009 15:21:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: very basic defragmentation testing for xfs & ext4
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
To: xfs mailing list <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

Test a few very basic defragmentation scenarios.

This test creates some files, runs defrag on them,
and compares the before/after fragmentation as well
as file md5sums and timestamps.

(md5sums may just be reading buffered data though,
suggestions?)

The test currently expects to find e4defrag in
/usr/bin

It should be relatively easy to add more interestingly
fragmented files to the tests, as well as to test
that memory-mapped files aren't touched, etc - 
but this gives us a framework.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

--- a/group
+++ b/group
@@ -326,3 +326,4 @@ prealloc
 215 auto metadata quick
 216 log metadata auto quick
 217 log metadata auto
+218 auto fsr quick
--- /dev/null	2009-07-15 14:17:48.882013317 -0500
+++ a/218	2009-07-15 15:18:06.546093921 -0500
@@ -0,0 +1,131 @@
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
+fragfile=$SCRATCH_MNT/fragfile.$$
+
+if [ "$FSTYP" == "xfs" ]; then
+	DEFRAG=/usr/sbin/xfs_fsr
+else
+	DEFRAG=/usr/bin/e4defrag
+fi
+
+_require_command $DEFRAG
+_require_command /usr/sbin/filefrag
+
+_extent_count()
+{
+	filefrag $1 | awk '{print $2}'
+}
+
+# Defrag file, check it, and remove it.
+_defrag()
+{
+	echo -n "Before: "
+	_extent_count $1
+	CSUM_BEFORE=`md5sum $1`
+	STAT_BEFORE=`stat -c "a: %x m: %y c: %z" $1`
+	$DEFRAG -v $1 >> $seq.full 2>&1
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
+# Craft some fragmented(?) files, defrag them, check the result.
+
+rm -f $fragfile
+
+echo "Empty file:"
+touch $fragfile
+_defrag $fragfile
+
+echo "Sparse file (no blocks):"
+xfs_io -F -f -c "truncate 1m" $fragfile
+_defrag $fragfile
+
+# note - sync IO here.  Should some be non-sync?
+# (necessary for the backwards writing though)
+
+echo "Contiguous file:"
+dd if=/dev/zero of=$fragfile bs=4k count=4 oflag=sync &>/dev/null
+_defrag $fragfile
+
+echo "Write backwards sync, but contiguous - should defrag to 1 extent"
+for I in `seq 9 -1 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write backwards sync leaving holes - defrag should do nothing"
+for I in `seq 31 -2 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write forwards sync leaving holes - defrag should do nothing"
+for I in `seq 0 2 31`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+rm -f $seq.full
+status=0
+exit

--- /dev/null	2009-07-15 14:17:48.882013317 -0500
+++ a/218.out	2009-07-15 15:17:45.947092973 -0500
@@ -0,0 +1,19 @@
+QA output created by 218
+Empty file:
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
