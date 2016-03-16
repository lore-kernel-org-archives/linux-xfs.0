Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29DDE7CE7
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:33:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 531E0AC001
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 02:33:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lOb0gZX0pFGGKd2i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 02:33:38 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] fstests: make xfs/006 generic
Date: Wed, 16 Mar 2016 17:30:54 +0800
Message-Id: <1458120654-27284-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

xfs/006 has no requirements that are specific to XFS, so make it generic
and other filesystems could get some coverage too.

Along with the movement, I also added a test that removes all created
dirs, as that's how the original bug was found.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/339     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/339.out |  2 ++
 tests/generic/group   |  1 +
 tests/xfs/006         | 63 ---------------------------------------------
 tests/xfs/006.out     | 28 --------------------
 tests/xfs/group       |  1 -
 6 files changed, 74 insertions(+), 92 deletions(-)
 create mode 100755 tests/generic/339
 create mode 100644 tests/generic/339.out
 delete mode 100755 tests/xfs/006
 delete mode 100644 tests/xfs/006.out

diff --git a/tests/generic/339 b/tests/generic/339
new file mode 100755
index 0000000..cbcad00
--- /dev/null
+++ b/tests/generic/339
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 339
+#
+# Test that directory hash entries are place in the correct order.
+# commit f5ea110 ("xfs: add CRCs to dir2/da node blocks") left the
+# directory with incorrect hash ordering.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Hannes Frederic Sowa.  All Rights Reserved.
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_test_program "dirhash_collide"
+
+rm -f $seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+echo "Silence is golden"
+
+testdir=$SCRATCH_MNT/$seq.$$
+mkdir -p $testdir
+$here/src/dirhash_collide -d -n 10000 $testdir >>$seqres.full 2>&1
+
+# check the scratch device
+_scratch_unmount
+_check_scratch_fs
+
+# remove all test dirs and let test harness check scratch fs again
+_scratch_mount
+rm -rf $testdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/339.out b/tests/generic/339.out
new file mode 100644
index 0000000..293ea80
--- /dev/null
+++ b/tests/generic/339.out
@@ -0,0 +1,2 @@
+QA output created by 339
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 8818827..cd2a2b7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -341,3 +341,4 @@
 336 auto quick metadata
 337 auto quick metadata
 338 auto quick rw
+339 auto dir
diff --git a/tests/xfs/006 b/tests/xfs/006
deleted file mode 100755
index 13631be..0000000
--- a/tests/xfs/006
+++ /dev/null
@@ -1,63 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 006
-#
-# Test that directory hash entries are place in the correct order.
-# commit f5ea110 ("xfs: add CRCs to dir2/da node blocks") left the
-# directory with incorrect hash ordering.
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014 Hannes Frederic Sowa.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-. ./common/repair
-
-# real QA test starts here
-
-_supported_fs xfs
-_supported_os Linux
-_require_scratch
-
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
-_scratch_mount | _filter_scratch
-
-mkdir $SCRATCH_MNT/x
-$here/src/dirhash_collide -d -n 10000 $SCRATCH_MNT/x
-_scratch_unmount 2>&1 | _filter_scratch
-
-_scratch_xfs_repair 2>&1 | _filter_repair
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/006.out b/tests/xfs/006.out
deleted file mode 100644
index 9c142ac..0000000
--- a/tests/xfs/006.out
+++ /dev/null
@@ -1,28 +0,0 @@
-QA output created by 006
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
diff --git a/tests/xfs/group b/tests/xfs/group
index e0c4553..db495c9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -3,7 +3,6 @@
 003 db auto quick
 004 db auto quick
 005 auto quick
-006 auto dir
 007 auto quota quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
