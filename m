Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FFB37CA4
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 03:03:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B94DF304039
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 01:03:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id plYdR7kHkginIMI2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 01:02:58 -0700 (PDT)
Date: Fri, 5 Aug 2016 01:02:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] generic: test accurate shared extent reporting
Message-ID: <20160805080251.GI25565@birch.djwong.org>
References: <20160805072147.GG25565@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805072147.GG25565@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com
Cc: mfasheh@suse.de, dedekind1@gmail.com, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Ensure that we can create a file with a single extent, reflink two
blocks out of the middle of that extent, and the resulting fiemap
reports two shared extents, instead of lazily reporting the entire
huge extent as shared.

v2: add _supported_fs

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/929     |   90 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/929.out |   17 +++++++++
 tests/generic/group   |    1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/generic/929
 create mode 100644 tests/generic/929.out

diff --git a/tests/generic/929 b/tests/generic/929
new file mode 100755
index 0000000..1871789
--- /dev/null
+++ b/tests/generic/929
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 929
+#
+# Check that bmap/fiemap accurately report shared extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch_reflink
+_require_fiemap
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blocks=5
+blksz=65536
+sz=$((blocks * blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
+_scratch_cycle_mount
+
+echo "file1 extents and holes"
+_count_extents $testdir/file1
+_count_holes $testdir/file1
+
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 3)) $blksz >> $seqres.full
+_reflink_range $testdir/file1 $((blksz * 3)) $testdir/file2 $blksz $blksz >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "file1 extents and holes"
+_count_extents $testdir/file1
+_count_holes $testdir/file1
+echo "file2 extents and holes"
+_count_extents $testdir/file2
+_count_holes $testdir/file2
+echo "file1 shared extents"
+$XFS_IO_PROG -c 'fiemap -v' $testdir/file1 | awk '{print $5}' | grep -c '0x.*[2367aAbBfF]...$'
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/929.out b/tests/generic/929.out
new file mode 100644
index 0000000..e290f4c
--- /dev/null
+++ b/tests/generic/929.out
@@ -0,0 +1,17 @@
+QA output created by 929
+Format and mount
+Create the original files
+file1 extents and holes
+1
+0
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-929/file1
+79418df9c55ab7f58781cb7b9e7d5d91  SCRATCH_MNT/test-929/file2
+file1 extents and holes
+5
+0
+file2 extents and holes
+2
+2
+file1 shared extents
+2
diff --git a/tests/generic/group b/tests/generic/group
index 18b9775..732f6f6 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -375,3 +375,4 @@
 370 auto quick richacl
 927 auto quick clone
 928 auto quick clone dedupe
+929 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
