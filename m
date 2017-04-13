Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753286AbdDMHbP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 03:31:15 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v4] fstests/xfs: xfs_repair should junk empty attribute leaf blocks
Date: Thu, 13 Apr 2017 15:31:09 +0800
Message-Id: <1492068669-16730-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

There was a bug during log replay, the attr/attr3 leaf verifier
reported corruption when encountering a leaf attribute with a
count of 0 in the header, as below:

Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000

commit f714016 from xfsprogs has fixed this bug. This test case
will emulate this corruption by xfs_db and use xfs_repair to fix
it.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V3 did below changes:
1) Only test on V4 XFS.
2) Use 'ablock 0' to instead of "a.bmx[0].startblock"
3) Use "dd ... | attr -s ..." to instead of that python command in
   "setfattr ..."
4) Do "xfs_repair -n" to check if xfs_repair can find the corruption
   we made.
5) Use xfs_db to check if xfs_repair has fixed the corruption properly.
   I check it by trying to locate 'ablock 0' again. Should I turn to
   check if core.naextents == 0?

V4 did below changes:
1) Remove useless $write_cmd
2) Use _scratch_mkfs_xfs
3) Use setfattr, and use $(perl -e "print 'v' x ${maxisize};") to generate
   attribute content.

Thanks,
Zorro

 tests/xfs/288     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/288.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 112 insertions(+)
 create mode 100755 tests/xfs/288
 create mode 100644 tests/xfs/288.out

diff --git a/tests/xfs/288 b/tests/xfs/288
new file mode 100755
index 0000000..6266dd8
--- /dev/null
+++ b/tests/xfs/288
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 288
+#
+# When an attribute leaf block count is 0, xfs_repair should junk
+# that leaf directly (as xfsprogs commit f714016).
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_attrs
+
+# Due to xfs_db's write -d option is still not stable, and there's no
+# plan to support attr3. So only run this case on V4 XFS.
+# Please update this if xfs_db get enough improvement in one day.
+if [ -z "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
+	mkfs_opts="-m crc=0"
+fi
+# get block size ($dbsize) from the mkfs output
+_scratch_mkfs_xfs $mkfs_opts | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+
+_scratch_mount
+
+touch $SCRATCH_MNT/$seq.attrfile
+inum=$(stat -c '%i' $SCRATCH_MNT/$seq.attrfile)
+
+# To get an attr block leaf, we need to extend attr format to extent
+# or btree format at least, and the max inode size is half of filesystem
+# block size, so write half of block size attr to make sure attr
+# out of local format.
+maxisize=$((dbsize/2))
+$SETFATTR_PROG -n "user.testattr${seq}" \
+	       -v "$(perl -e "print 'v' x ${maxisize};")" \
+	       $SCRATCH_MNT/$seq.attrfile
+
+_scratch_unmount
+# manually corrupt the XFS, by set the header count of attr to 0
+_scratch_xfs_db -x -c "inode $inum" \
+		   -c "ablock 0" \
+		   -c "write hdr.count 0" >> $seqres.full
+
+# make sure xfs_repair can find above corruption. If it can't, that
+# means we need to fix this bug on current xfs_repair
+_scratch_xfs_repair -n >> $seqres.full 2>&1
+if [ $? -eq 0 ];then
+	_fail "xfs_repair can't find the corruption"
+else
+	# If xfs_repair can find this corruption, then this repair
+	# should junk above leaf attribute and fix this XFS.
+	_scratch_xfs_repair >> $seqres.full 2>&1
+
+	# Old xfs_repair maybe find and fix this corruption by
+	# reset the first used heap value and the usedbytes cnt
+	# in ablock 0. That's not what we want. So check if
+	# xfs_repair has junked the whole ablock 0 by xfs_db.
+	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" | \
+		grep -q "no attribute data"
+	if [ $? -ne 0 ]; then
+		_fail "xfs_repair didn't junk the empty attr leaf"
+	fi
+fi
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/288.out b/tests/xfs/288.out
new file mode 100644
index 0000000..2958a5c
--- /dev/null
+++ b/tests/xfs/288.out
@@ -0,0 +1,2 @@
+QA output created by 288
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 75769f9..f27a7b6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -285,6 +285,7 @@
 285 dangerous_fuzzers dangerous_scrub
 286 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 287 auto dump quota quick
+288 auto quick repair fuzzers
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.7.4

