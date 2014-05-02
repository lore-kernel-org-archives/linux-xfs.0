Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25B747F6A
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 080C4304064
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hq34JcMcBiDkYemZ for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:50 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nZ5005073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s42H5n3W005996
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/5] xfs/010: test repair for finobt corruption
Date: Fri,  2 May 2014 13:14:01 -0400
Message-Id: <1399050842-19633-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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

The finobt creates a duplicate subset of inode allocation metadata from
the inobt. xfs_repair should detect and repair inconsistencies in the
finobt that could be caused by bugs or corruption. This test uses xfs_db
to cause targeted corruptions in the finobt and verify repair detects
and corrects the filesystem.

In particular, the test corrupts individual finobt records to cause
inconsistency between the inode allocation count fields as well as
causing the finobt to contain a record with no free inodes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/010     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/010.out |  57 +++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 191 insertions(+)
 create mode 100755 tests/xfs/010
 create mode 100644 tests/xfs/010.out

diff --git a/tests/xfs/010 b/tests/xfs/010
new file mode 100755
index 0000000..2b5ad00
--- /dev/null
+++ b/tests/xfs/010
@@ -0,0 +1,133 @@
+#!/bin/bash
+# FS QA Test No. xfs/010
+#
+# Test xfs_repair of the free inode btree (finobt). Make a couple targeted
+# corruptions and verify that xfs_repair detects and repairs the filesystem to
+# a consistent state.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/repair
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_sparse_inode_populate()
+{
+	dir=$1
+	count=$2
+
+	for i in $(seq 0 $count)
+	do
+		touch $dir/$i
+	done
+
+	# Inode chunks are allocated 64 inodes at a time. If we remove 1 out of
+	# every 32 we allocated above, we'll end up leaving an inode or two free
+	# in each chunk. This ensures that most records are inserted into the
+	# finobt.
+	for i in $(seq 0 32 $count)
+	do
+		rm -f $dir/$i
+	done
+}
+
+_filter_dbval()
+{
+	awk '{ print $3 }'
+}
+
+_corrupt_finobt_records()
+{
+	dev=$1
+
+	# determine the root block of the finobt
+	free_root=`$XFS_DB_PROG -c "agi 0" -c "p free_root" $dev |
+			_filter_dbval`
+
+	# Corrupt a freecount value. This should never exceed 64.
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+		-c "write recs[1].freecount 70" $dev
+
+	# Create a corrupted non-free record, which should never appear in the
+	# finobt.
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+		 -c "write recs[2].freecount 0" $dev
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+		-c "write recs[2].free 0" $dev
+}
+
+_corrupt_finobt_root()
+{
+	dev=$1
+
+	# nuke the agi finobt root fields
+	$XFS_DB_PROG -x -c "agi 0" -c "write free_root 0" $dev
+	$XFS_DB_PROG -x -c "agi 0" -c "write free_level 0" $dev
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_mkfs_finobt
+_require_xfs_finobt
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" | _filter_mkfs 2>$seqres.full
+
+# sparsely populate the fs such that we create records with free inodes
+_scratch_mount
+_sparse_inode_populate $SCRATCH_MNT 999
+umount $SCRATCH_MNT
+
+# corrupt some finobt records
+_corrupt_finobt_records $SCRATCH_DEV
+
+# repair should detect the inconsistencies
+_scratch_xfs_repair 2>&1 | _filter_repair
+_check_scratch_fs
+
+# nuke the finobt root, repair will have to regenerate from the inobt
+_corrupt_finobt_root $SCRATCH_DEV
+
+_scratch_xfs_repair 2>&1 | _filter_repair
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/xfs/010.out b/tests/xfs/010.out
new file mode 100644
index 0000000..ab5e5f3
--- /dev/null
+++ b/tests/xfs/010.out
@@ -0,0 +1,57 @@
+QA output created by 010
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+recs[1].freecount = 70
+recs[2].freecount = 0
+recs[2].free = 0
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+finobt ir_freecount/free mismatch, AGNO/INO, freecount 70 nfree 2
+finobt record with no free inodes, AGNO/INO
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
+free_root = 0
+free_level = 0
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+bad agbno AGBNO for finobt root, agno 0
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
index 4624fc3..c228a63 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -7,6 +7,7 @@
 007 auto quota quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
+010 auto quick repair
 012 rw auto quick
 016 rw auto quick
 017 mount auto quick stress
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
