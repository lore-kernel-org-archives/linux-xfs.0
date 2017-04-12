Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdDLKlj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 06:41:39 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] fstests/xfs: xfs_repair should junk empty attribute leaf blocks
Date: Wed, 12 Apr 2017 18:41:33 +0800
Message-Id: <1491993693-9667-1-git-send-email-zlang@redhat.com>
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

xfs_db already support 'write -d' from last year, even though the
manpage doesn't record that. But the '-d' option can't be run for
everything.

I just saw Eric and Darrick send two patches to allow write -d to
dqblks and inodes. But they haven't been merged. In this case, I
hope to change a field of attr3 on V5 XFS, so I have to find a way
to make sure if the current xfs_db can do that. I'm not the one
who learn about xfs_db so much, so if someone feel something wrong,
please feel free to tell me.

I know I can limit this case test on V4 XFS, then there's no 'write -d'
problem. But I hope to cover V5 XFS test if I can.

Thanks,
Zorro

 tests/xfs/288     | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/288.out |   2 ++
 tests/xfs/group   |   1 +
 3 files changed, 106 insertions(+)
 create mode 100755 tests/xfs/288
 create mode 100644 tests/xfs/288.out

diff --git a/tests/xfs/288 b/tests/xfs/288
new file mode 100755
index 0000000..3dc0a75
--- /dev/null
+++ b/tests/xfs/288
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test 288
+#
+# When an attribute leaf block count is 0, xfs_repair should junk
+# that leaf directly (as xfsprogs commit f714016).
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 YOUR NAME HERE.  All Rights Reserved.
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
+# V4 XFS attr type is 'attr'
+write_cmd="write"
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_attrs
+_require_xfs_db_command write
+_require_xfs_db_command addr
+
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+
+# If test on XFS with CRC enabled, after change attr's hdr.count we need
+# to recalculate crc.
+if [ $_fs_has_crcs -eq 1 ]; then
+	# This's a trick to check if xfs_db support recalculating
+	# CRCs of attr3
+	_scratch_xfs_db -x -c "daddr 0" \
+			   -c "type attr3" \
+			   -c "write -d" 2>/dev/null | \
+		grep -q "Cannot recalculate CRCs on this type of object"
+	if [ $? -eq 0 ];then
+		_notrun "xfs_db can't recalculate CRCs of attr3"
+	fi
+	# V5 XFS attr type is 'attr3'
+	write_cmd="write -d"
+fi
+
+_scratch_mount
+
+touch $SCRATCH_MNT/$seq.attrfile
+inum=$(stat -c '%i' $SCRATCH_MNT/$seq.attrfile)
+
+# To get a attr block leaf, we need to extend attr format to extent
+# format at least, and the max inode size is half of filesystem
+# block size, so write half of block size attr to make sure attr
+# out of local format.
+fsblocksize=`xfs_info $SCRATCH_MNT|sed 's/=/ /g'|awk '/^data / { print $3 }'`
+maxisize=$((fsblocksize/2))
+setfattr -n "user.testattr${seq}" -v `python -c "print ($maxisize * 'a')"` \
+	$SCRATCH_MNT/$seq.attrfile
+umount $SCRATCH_MNT
+_scratch_xfs_db -x -c "inode $inum" \
+		   -c "addr a.bmx[0].startblock" \
+		   -c "$write_cmd hdr.count 0" >> $seqres.full
+
+# This repair should junk above leaf attribute to fix this XFS
+_repair_scratch_fs >> $seqres.full
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
index 75769f9..a0a03c0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -285,6 +285,7 @@
 285 dangerous_fuzzers dangerous_scrub
 286 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 287 auto dump quota quick
+288 auto quick repair
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.7.4

