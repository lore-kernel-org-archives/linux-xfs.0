Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD9DE7F4E
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 08:30:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90E4A304032
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 06:30:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cRe7bps0R9Cu7aK1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2015 06:30:24 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests/xfs: xfs_repair secondary sb verification regression
	test
Date: Mon, 19 Jan 2015 09:30:21 -0500
Message-Id: <1421677821-30752-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

The secondary superblock verification in xfs_repair was subject to a bug
that unnecessarily leads to a brute force superblock scan if the last
superblock in the fs happens to be corrupt. Normally, xfs_repair handles
one-off superblock corruption gracefully using a heuristic that finds
the most consistent superblock content across the set of secondary
superblocks.

Create a regression test for xfs_repair that corrupts the last
superblock in the fs. Verify the superblock is updated from the
previously verified sb content and a brute force scan is not initiated.
In the event of failure, detect that a brute force scan has started and
abort the repair in order to fail the test quickly.

To support the test, extend the xfs_repair filter to handle corrupted
superblock repair output and provide generic test output for arbitrary
AG counts.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This is an xfs_repair regression test to trigger the problem fixed by
the following previously posted fix:

http://oss.sgi.com/archives/xfs/2015-01/msg00244.html

Thoughts appreciated, thanks.

Brian

 common/repair     |   4 ++
 tests/xfs/069     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/069.out |  27 ++++++++++++++
 tests/xfs/group   |   1 +
 4 files changed, 142 insertions(+)
 create mode 100755 tests/xfs/069
 create mode 100644 tests/xfs/069.out

diff --git a/common/repair b/common/repair
index a157580..7a99546 100644
--- a/common/repair
+++ b/common/repair
@@ -88,6 +88,10 @@ s/(inode chunk) (\d+)\/(\d+)/AGNO\/INO/;
 # sunit/swidth reset messages
 s/^(Note - .*) were copied.*/\1 fields have been reset./;
 s/^(Please) reset (with .*) if necessary/\1 set \2/;
+# corrupt sb messages
+s/(superblock) (\d+)/\1 AGNO/;
+s/(AG \#)(\d+)/\1AGNO/;
+s/(reset bad sb for ag) (\d+)/\1 AGNO/;
 	print;'
 }
 
diff --git a/tests/xfs/069 b/tests/xfs/069
new file mode 100755
index 0000000..b1ed425
--- /dev/null
+++ b/tests/xfs/069
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 069
+#
+# As part of superblock verification, xfs_repair checks the primary sb and
+# verifies all secondary sb's against the primary. In the event of geometry
+# inconsistency, repair uses a heuristic that tracks the most frequently
+# occurring settings across the set of N (agcount) superblocks.
+#
+# xfs_repair was subject to a bug that disregards this heuristic in the event
+# that the last secondary superblock in the fs is corrupt. The side effect is an
+# unnecessary and potentially time consuming brute force superblock scan.
+#
+# This is a regression test for the aforementioned xfs_repair bug. We
+# intentionally corrupt the last superblock in the fs, run xfs_repair and
+# verify it repairs the fs correctly. We explicitly detect a brute force scan
+# and abort the repair to save time in the failure case.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc. All Rights Reserved.
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
+	killall -9 $XFS_REPAIR_PROG > /dev/null 2>&1
+	wait > /dev/null 2>&1
+}
+
+# Start and monitor an xfs_repair of the scratch device. This test can induce a
+# time consuming brute force superblock scan. Since a brute force scan means
+# test failure, detect it and end the repair.
+_xfs_repair_noscan()
+{
+	# invoke repair directly so we can kill the process if need be
+	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
+	repair_pid=$!
+
+	# monitor progress for as long as it is running
+	while [ `ps -q $repair_pid > /dev/null; echo $?` == 0 ]; do
+		grep "couldn't verify primary superblock" $tmp.repair \
+			> /dev/null 2>&1
+		if [ $? == 0 ]; then
+			# we've started a brute force scan. kill repair and
+			# fail the test
+			kill -9 $repair_pid >> $seqres.full 2>&1
+			wait >> $seqres.full 2>&1
+
+			_fail "xfs_repair resorted to brute force scan"
+		fi
+
+		sleep 1
+	done
+
+	wait
+
+	cat $tmp.repair | _filter_repair
+}
+
+rm -f $seqres.full
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/repair
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# corrupt the last secondary sb in the fs
+agcount=`$XFS_DB_PROG -c "sb" -c "p agcount" $SCRATCH_DEV | awk '{ print $3 }'`
+last_secondary=$((agcount - 1))
+$XFS_DB_PROG -x -c "sb $last_secondary" -c "type data" \
+	-c "write fill 0xff 0 512" $SCRATCH_DEV
+
+# attempt to repair
+_xfs_repair_noscan
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/069.out b/tests/xfs/069.out
new file mode 100644
index 0000000..c6b11d1
--- /dev/null
+++ b/tests/xfs/069.out
@@ -0,0 +1,27 @@
+QA output created by 069
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+bad magic number
+bad on-disk superblock AGNO - bad magic number
+primary/secondary superblock AGNO conflict - AG superblock geometry info conflicts with filesystem geometry
+zeroing unused portion of secondary superblock (AG #AGNO)
+reset bad sb for ag AGNO
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
diff --git a/tests/xfs/group b/tests/xfs/group
index 496630d..9394703 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -66,6 +66,7 @@
 066 dump ioctl auto quick
 067 acl attr auto quick
 068 auto stress dump
+069 auto quick repair
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
