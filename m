Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54084 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbeCUIBr (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:0:0>);
        Wed, 21 Mar 2018 04:01:47 -0400
From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH 3/3] fstests: generic: Check the fs after each FUA writes
Date: Wed, 21 Mar 2018 16:01:25 +0800
Message-Id: <20180321080125.30404-3-wqu@suse.com>
In-Reply-To: <20180321080125.30404-1-wqu@suse.com>
References: <20180321080125.30404-1-wqu@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Cc: amir73il@gmail.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Basic test case which triggers fsstress with dm-log-writes, and then
check the fs after each FUA writes.
With needed infrastructure and special handlers for journal based fs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Unfortunately, neither xfs nor ext4 survies this test for even single
success, while btrfs survives.
(Although not what I want, I'm just trying my luck
to reproduce a serious btrfs corruption situation)

Although btrfs may be the fastest fs for the test, since it has fixed
small amount of write in mkfs and almost nothing to replay, it still
takes about 240s~300s to finish (the same level using snapshot).

It would take longer time for ext4 for its large amount of write during
mkfs, if it can survive the test in the first space.

As a comparison, btrfs takes about 5 seconds to replay log, mount,
unmount and run fsck at the end of the test.
But for ext4, it already takes about 5 seconds to do the same thing
before triggering fsck error.

Fsck fail for ext4:
_check_generic_filesystem: filesystem on /dev/mapper/test-scratch1 is inconsistent
*** fsck.ext4 output ***
fsck from util-linux 2.31.1
e2fsck 1.43.8 (1-Jan-2018)
Pass 1: Checking inodes, blocks, and sizes
Inode 131076 extent tree (at level 1) could be shorter.  Fix? no

Inode 131262, i_size is 0, should be 258048.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

For xfs:
_check_xfs_filesystem: filesystem on /dev/mapper/test-scratch1 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
bad symlink header ino 8409190, file block 0, disk block 1051147
problem with symbolic link in inode 8409190
would have cleared inode 8409190
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 3
        - agno = 2
entry "lb" in shortform directory 8409188 references free inode 8409190
would have junked entry "lb" in directory inode 8409188
bad symlink header ino 8409190, file block 0, disk block 1051147
problem with symbolic link in inode 8409190
would have cleared inode 8409190
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "lb" in shortform directory inode 8409188 points to free inode 8409190
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
Maximum metadata LSN (1:396) is ahead of log (1:63).
Would format log to cycle 4.
No modify flag set, skipping filesystem flush and exiting.

And special note for XFS guys, I also hit an XFS internal metadata
warning during journal replay:
[ 7901.423659] XFS (dm-4): Starting recovery (logdev: internal)
[ 7901.577511] XFS (dm-4): Metadata corruption detected at xfs_dinode_verify+0x467/0x570 [xfs], inode 0x805067 dinode
[ 7901.580529] XFS (dm-4): Unmount and run xfs_repair
[ 7901.581901] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[ 7901.583205] 00000000b8963f41: 49 4e a1 ff 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[ 7901.584659] 00000000f35a50e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 7901.586075] 00000000386eea9e: 5a b2 0e 69 0a f3 43 27 5a b2 0e 69 0a f3 43 27  Z..i..C'Z..i..C'
[ 7901.587561] 00000000ac636661: 5a b2 0e 69 0d 92 bc 00 00 00 00 00 00 00 00 00  Z..i............
[ 7901.588969] 00000000d75f9093: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 7901.590475] 00000000d2af5688: 00 00 00 02 00 00 00 00 00 00 00 00 84 d7 6a e9  ..............j.
[ 7901.591907] 00000000e8dd8211: ff ff ff ff 34 93 a9 3a 00 00 00 00 00 00 00 04  ....4..:........
[ 7901.593319] 00000000b7610e4e: 00 00 00 01 00 00 00 45 00 00 00 00 00 00 00 00  .......E........

---
 common/dmlogwrites    |  56 +++++++++++++++++++++++++++
 tests/generic/481     | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/481.out |   2 +
 tests/generic/group   |   1 +
 4 files changed, 163 insertions(+)
 create mode 100755 tests/generic/481
 create mode 100644 tests/generic/481.out

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 467b872e..bf643a77 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -126,3 +126,59 @@ _log_writes_cleanup()
 	$UDEV_SETTLE_PROG >/dev/null 2>&1
 	_log_writes_remove
 }
+
+# Convert log writes mark to entry number
+# Result entry number is output to stdout, could be empty if not found
+_log_writes_mark_to_entry_number()
+{
+	local mark=$1
+	local ret
+
+	[ -z "$mark" ] && _fatal \
+		"mark must be given for _log_writes_mark_to_entry_number"
+
+	ret=$($here/src/log-writes/replay-log --find --log $LOGWRITES_DEV \
+		--end-mark $mark 2> /dev/null)
+	[ -z "$ret" ] && return
+	ret=$(echo "$ret" | cut -f1 -d\@)
+	echo "mark $mark has entry number $ret" >> $seqres.full
+	echo "$ret"
+}
+
+# Find next fua write entry number
+# Result entry number is output to stdout, could be empty if not found
+_log_writes_find_next_fua()
+{
+	local start_entry=$1
+	local ret
+
+	[ -z "$start_entry" ] && start_entry=0
+	ret=$($here/src/log-writes/replay-log --find --log $LOGWRITES_DEV \
+	      --next-fua --start-entry $start_entry 2> /dev/null)
+	[ -z "$ret" ] && return
+
+	# Result should be something like "1024@offset" where 1024 is the
+	# entry number we need
+	ret=$(echo "$ret" | cut -f1 -d\@)
+	echo "next fua is entry number $ret" >> $seqres.full
+	echo "$ret"
+}
+
+# Replay log range to specified entry
+# $1:	End entry. The entry with this number *WILL* be replayed
+_log_writes_replay_log_range()
+{
+	local end=$1
+
+	[ -z "$end" ] && _fail \
+	"end entry must be specified for _log_writes_replay_log_range"
+
+	# To ensure we replay the last entry,
+	# we need to manually increase the end entry number to ensure
+	# it's played
+	echo "=== replay to $end ===" >> $seqres.full
+	$here/src/log-writes/replay-log --log $LOGWRITES_DEV \
+		--replay $SCRATCH_DEV --limit $(($end + 1)) \
+		>> $seqres.full 2>&1
+	[ $? -ne 0 ] && _fail "replay failed"
+}
diff --git a/tests/generic/481 b/tests/generic/481
new file mode 100755
index 00000000..148347fe
--- /dev/null
+++ b/tests/generic/481
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test 481
+#
+# Test filesystem consistency after each FUA operation
+#
+# Will do log replay and check the filesystem.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 SuSE.  All Rights Reserved.
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
+	$KILLALL_PROG -KILL -q $FSSTRESS_PROG &> /dev/null
+	_log_writes_cleanup &> /dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmlogwrites
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_command "$KILLALL_PROG" killall
+# Use $SCRATCH_DEV as replay device
+_require_scratch
+# and we need extra device as log device
+_require_log_writes
+
+
+nr_cpus=$("$here/src/feature" -o)
+fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
+		$FSSTRESS_AVOID)
+
+_test_unmount
+_log_writes_init
+_log_writes_mkfs >> $seqres.full 2>&1
+_log_writes_mark mkfs
+
+_log_writes_mount
+$FSSTRESS_PROG $fsstress_args > /dev/null 2>&1
+_log_writes_unmount
+
+_log_writes_remove
+prev=$(_log_writes_mark_to_entry_number mkfs)
+[ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
+cur=$(_log_writes_find_next_fua $prev)
+[ -z "$cur" ] && _fail "failed to locate next FUA write"
+
+while [ ! -z "$cur" ]; do
+	_log_writes_replay_log_range $cur >> $seqres.full
+
+	# Here we need extra mount to replay the log, mainly for journal based
+	# fs, as their fsck will report dirty log as error.
+	# We don't care to preserve any data on $SCRATCH_DEV, as we can replay
+	# back to the point we need, and in fact sometimes creating/deleting
+	# snapshots repeatedly can be slower than replaying the log.
+	_scratch_mount
+	_scratch_unmount
+	_check_scratch_fs
+
+	prev=$cur
+	cur=$(_log_writes_find_next_fua $(($cur + 1)))
+	[ -z "$cur" ] && break
+done
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/481.out b/tests/generic/481.out
new file mode 100644
index 00000000..206e1163
--- /dev/null
+++ b/tests/generic/481.out
@@ -0,0 +1,2 @@
+QA output created by 481
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index ea2056b1..c4cc800a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -483,3 +483,4 @@
 478 auto quick
 479 auto quick metadata
 480 auto quick metadata
+481 auto replay
-- 
2.15.1

