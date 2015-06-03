Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 735567FD3
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 14:08:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 549CA304043
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 12:08:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JgeHc0aRArgwIOrC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 12:08:29 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests/xfs: test inode allocation with fragmented free space
Date: Wed,  3 Jun 2015 15:08:26 -0400
Message-Id: <1433358506-27002-1-git-send-email-bfoster@redhat.com>
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

XFS dynamic inode allocation has a fundamental limitation in that an
inode chunk requires a contiguous extent of a minimum size. Depending on
the level of free space fragmentation, inode allocation can fail with
ENOSPC where the filesystem might not be near 100% usage.

The sparse inodes feature was implemented to provide an inode allocation
strategy that maximizes the ability to allocate inodes under free space
fragmentation. This test fragments free space and verifies that
filesystems that support sparse inode allocation can allocate a minimum
percentage of inodes on the fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is a test I've been using to verify the effectiveness of the XFS
sparse inodes feature. I put some effort into trying to make it generic
and have kind of gone back and forth on the matter. That said, it's kind
of pointless on ext4, doesn't work well on btrfs because it doesn't
track inode counts, and is generally expected to fail on XFS filesystems
without sparse inodes support.

Given all of that, I kind of went in the other direction and let it run
only for XFS when sparse inodes is supported. We still have broader
functional sparse inodes testability by virtue of DEBUG, of course.
Thoughts?

Brian

 tests/xfs/075     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/075.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 140 insertions(+)
 create mode 100755 tests/xfs/075
 create mode 100644 tests/xfs/075.out

diff --git a/tests/xfs/075 b/tests/xfs/075
new file mode 100755
index 0000000..6f26cf5
--- /dev/null
+++ b/tests/xfs/075
@@ -0,0 +1,137 @@
+#!/bin/bash
+# FS QA Test No. xfs/075
+#
+# Verify that a filesystem can allocate inodes in the event of free space
+# fragmentation. This test is generic in nature but primarily relevant to
+# filesystems that implement dynamic inode allocation (e.g., XFS).
+#
+# The test is inspired by inode allocation limitations on XFS when available
+# free space is fragmented. XFS allocates inodes 64 at a time and thus requires
+# an extent of length that depends on inode size (64 * isize / blksize).
+#
+# The test creates a small filesystem, fragments free space, allocates inodes to
+# ENOSPC and then verifies that most of the available inodes have been consumed.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
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
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_avail_bytes()
+{
+	avail_kb=`$DF_PROG $SCRATCH_MNT | tail -n1 | awk '{ print $5 }'`
+	echo $((avail_kb * 1024))
+}
+
+_consume_freesp()
+{
+	file=$1
+
+	# consume nearly all available space (leave ~1MB)
+	avail=`_avail_bytes`
+	filesizemb=$((avail / 1024 / 1024 - 1))
+	$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $file \
+		2>> $seqres.full || _fail "falloc failed"
+}
+
+# Allocate inodes in a directory until failure.
+_alloc_inodes()
+{
+	dir=$1
+
+	i=0
+	while [ true ]; do
+		touch $dir/$i 2>> $seqres.full || break
+		i=$((i + 1))
+	done
+}
+
+# real QA test starts here
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+
+_scratch_mkfs_sized $((1024*1024*50)) | _filter_mkfs > /dev/null 2> $tmp.mkfs ||
+	_fail "mkfs failed"
+. $tmp.mkfs	# for isize
+
+# This test runs a workload that is known to fail on XFS unless the sparse
+# inodes chunk feature is enabled. Skip the test if it is not supported to avoid
+# unnecessary and expected test failures.
+$XFS_DB_PROG -c version $SCRATCH_DEV | grep SPARSE_INODES > /dev/null ||
+	_notrun "requires sparse inodes support"
+
+_scratch_mount
+
+# magic heuristic value of 64 - # of inodes in an XFS inode record
+FRAG_FACTOR=$((isize * 64))
+[ $FRAG_FACTOR != 0 ] || _fail "could not calculate fragmentation factor"
+
+_consume_freesp $SCRATCH_MNT/spc
+
+offset=`stat -c "%s" $SCRATCH_MNT/spc`
+offset=$((offset - $FRAG_FACTOR * 2))
+while [ $offset -ge 0 ]; do
+	# punch small holes in the file to fragment free space
+	$XFS_IO_PROG -c "fpunch $offset $FRAG_FACTOR" $SCRATCH_MNT/spc \
+		2>> $seqres.full || _fail "fpunch failed"
+
+	# allocate as many inodes as possible
+	mkdir -p $SCRATCH_MNT/offset.$offset > /dev/null 2>&1
+	_alloc_inodes $SCRATCH_MNT/offset.$offset
+
+	offset=$((offset - $FRAG_FACTOR * 2))
+done
+
+# check the inode % usage
+iusepct=`$DF_PROG -i $SCRATCH_MNT | tail -n 1 | awk '{ print $6 }' |
+	 sed -e 's/%//'`
+if [ $iusepct -lt 95 ]; then
+	$DF_PROG -i $SCRATCH_MNT
+	_fail "could not allocate enough inodes"
+fi
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/075.out b/tests/xfs/075.out
new file mode 100644
index 0000000..73c3af2
--- /dev/null
+++ b/tests/xfs/075.out
@@ -0,0 +1,2 @@
+QA output created by 075
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 848a1bd..b5d55ed 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -71,6 +71,7 @@
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
+075 auto enospc
 078 growfs auto quick
 080 rw ioctl
 081 deprecated # log logprint quota
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
