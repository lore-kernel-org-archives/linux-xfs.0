Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90DB17F61
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 12:24:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 466118F808E
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:24:43 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.137]) by
	cuda.sgi.com with ESMTP id KMtBWm0IWc9H1KxK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 10:24:41 -0700 (PDT)
From: Jan Schmidt <list.xfs@jan-o-sch.net>
Subject: [PATCH v4 2/2] xfstests btrfs/316: test send / receive
Date: Tue, 13 Aug 2013 19:24:18 +0200
Message-Id: <1376414658-4563-3-git-send-email-list.xfs@jan-o-sch.net>
In-Reply-To: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
References: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
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
Cc: sandeen@sandeen.net, sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org

Basic send / receive functionality test for btrfs. Requires current
version of fsstress built (-x support). Relies on fssum tool but can
skip the test if it failed to build.

Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
Reviewed-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/316     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316.out |    4 ++
 tests/btrfs/group   |    1 +
 3 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

diff --git a/tests/btrfs/316 b/tests/btrfs/316
new file mode 100755
index 0000000..b3af7d9
--- /dev/null
+++ b/tests/btrfs/316
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FSQA Test No. 316
+#
+# Run fsstress to create a reasonably strange file system, make a
+# snapshot (base) and run more fsstress. Then take another snapshot
+# (incr) and send both snapshots to a temp file. Remake the file
+# system and receive from the files. Check both states with fssum.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 STRATO.  All rights reserved.
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
+# creator
+owner=list.btrfs@jan-o-sch.net
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=`mktemp -d`
+status=1
+
+_cleanup()
+{
+	echo "*** unmount"
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_seek_data_hole
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+workout()
+{
+	fsz=$1
+	ops=$2
+
+	umount $SCRATCH_DEV >/dev/null 2>&1
+	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
+	echo ""                                     >>$seqres.full
+	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
+		|| _fail "size=$fsz mkfs failed"
+	run_check _scratch_mount "-o noatime"
+
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
+		"$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/base"
+
+	run_check $BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/incr
+
+	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
+		>> $seqres.full
+	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap 2>> $seqres.full \
+		|| _fail "failed: '$@'"
+	echo "# $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base\
+		$SCRATCH_MNT/incr > $tmp/incr.snap" >> $seqres.full
+	$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base \
+		$SCRATCH_MNT/incr > $tmp/incr.snap 2>> $seqres.full \
+		|| _fail "failed: '$@'"
+
+	run_check $FSSUM_PROG -A -f -w $tmp/base.fssum $SCRATCH_MNT/base
+	run_check $FSSUM_PROG -A -f -w $tmp/incr.fssum -x $SCRATCH_MNT/incr/base \
+		$SCRATCH_MNT/incr
+
+	umount $SCRATCH_DEV >/dev/null 2>&1
+	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
+	echo ""                                     >>$seqres.full
+	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
+		|| _fail "size=$fsz mkfs failed"
+	run_check _scratch_mount "-o noatime"
+
+	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/base.snap
+	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base
+
+	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/incr.snap
+	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
+}
+
+echo "*** test send / receive"
+
+fssize=`expr 2000 \* 1024 \* 1024`
+ops=200
+
+workout $fssize $ops
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/btrfs/316.out b/tests/btrfs/316.out
new file mode 100644
index 0000000..4564c85
--- /dev/null
+++ b/tests/btrfs/316.out
@@ -0,0 +1,4 @@
+QA output created by 316
+*** test send / receive
+*** done
+*** unmount
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..11d708a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+316 auto rw metadata
-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
