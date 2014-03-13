Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E570A7F83
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:14:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C063C304053
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:14:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id UOMj0ZN5SWKckUZQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:14:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WO2en-00084F-NT
	for xfs@oss.sgi.com; Thu, 13 Mar 2014 10:14:33 +0000
Message-Id: <20140313101433.608283621@bombadil.infradead.org>
Date: Thu, 13 Mar 2014 03:13:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: add a test for unlinked inodes due to O_TMPFILE
References: <20140313101302.996355155@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-xfs-add-a-test-for-unlinked-inodes-due-to-O_TMPFILE.patch
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

Make sure that we see unlinked inodes when shutting a filesystem
down that has an open O_TMPFILE descriptor, and make sure that it
has been deleted after a mount/umount cycle.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/006     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/006.out |   43 ++++++++++++++++++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 133 insertions(+)
 create mode 100755 tests/xfs/006
 create mode 100644 tests/xfs/006.out

diff --git a/tests/xfs/006 b/tests/xfs/006
new file mode 100755
index 0000000..7dae43d
--- /dev/null
+++ b/tests/xfs/006
@@ -0,0 +1,89 @@
+#! /bin/bash
+# XFS QA Test No. 006
+#
+# Test O_TMPFILE interaction with log recovery and repair.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Christoph Hellwig.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+    rm -f ${testfile}
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/repair
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "flink"
+
+testfile="${SCRATCH_MNT}/tst-tmpfile-flink"
+
+_scratch_mount
+
+#
+# Test creating a r/w tmpfile, make sure it goes out to disk while still
+# open using a freeze/thaw, and then shut down the filesystem.
+#
+$XFS_IO_PROG -x -T \
+	-c "pwrite 0 4096" \
+	-c "pread 0 4096" \
+	-c "freeze" \
+	-c "thaw" \
+	-c "shutdown" \
+	${SCRATCH_MNT} | _filter_xfs_io
+
+_scratch_unmount
+
+# repair should find an unlinked inode now
+_scratch_xfs_repair -n 2>&1 | \
+	_filter_repair > $tmp.repair
+
+ino=`grep 'disconnected inode ' $tmp.repair | \
+	head -1 | \
+	awk '{print $3}' | \
+	sed 's/,//'`
+
+cat $tmp.repair | sed "s/$ino/XXX/g"
+
+# filesystem should be clean after an unmount/mount cycle
+_scratch_mount
+_scratch_unmount
+
+_scratch_xfs_repair -n 2>&1 | _filter_repair
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/006.out b/tests/xfs/006.out
new file mode 100644
index 0000000..46f3b73
--- /dev/null
+++ b/tests/xfs/006.out
@@ -0,0 +1,43 @@
+QA output created by 006
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan (but don't clear) agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+No modify flag set, skipping phase 5
+Phase 6 - check inode connectivity...
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+disconnected inode XXX, would move to lost+found
+Phase 7 - verify link counts...
+would have reset inode XXX nlinks from 0 to 1
+No modify flag set, skipping filesystem flush and exiting.
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan (but don't clear) agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+No modify flag set, skipping phase 5
+Phase 6 - check inode connectivity...
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify link counts...
+No modify flag set, skipping filesystem flush and exiting.
diff --git a/tests/xfs/group b/tests/xfs/group
index ba34650..2f896e1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -3,6 +3,7 @@
 003 db auto quick
 004 db auto quick
 005 auto quick
+006 auto quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
 012 rw auto quick
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
