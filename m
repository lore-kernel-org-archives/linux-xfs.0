Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 655BB7F8D
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 12:46:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C05DCAC001
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 10:46:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HKvZZ1IzUauIkskf for
	<xfs@oss.sgi.com>; Tue, 18 Mar 2014 10:46:41 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] [PATCH] generic/009: add generic test for fallocate zero range
Date: Tue, 18 Mar 2014 18:46:28 +0100
Message-Id: <1395164788-19779-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1395164788-19779-1-git-send-email-lczerner@redhat.com>
References: <1395164788-19779-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

This is based on xfs/242. This is very similar to ext4/001 however this
test has some tweaks to make it work test zero range on generic file
system. This includes turning off ext4 extents zeroout and disabling
the test for xfs on systems where PAGE_SIZE > 4096.

It is testing extent tree manipulation with fallocate zero range
operation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/009     |  78 ++++++++++++
 tests/generic/009.out | 333 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 412 insertions(+)
 create mode 100644 tests/generic/009
 create mode 100644 tests/generic/009.out

diff --git a/tests/generic/009 b/tests/generic/009
new file mode 100644
index 0000000..b7b0b3f
--- /dev/null
+++ b/tests/generic/009
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test No. 009
+#
+# Test fallocate FALLOC_FL_ZERO_RANGE
+#
+#-----------------------------------------------------------------------
+# Copyright 2014 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
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
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_os Linux
+_require_xfs_io_falloc "fzero"
+
+testfile=$TEST_DIR/009.$$
+
+# Disable extent zeroing for ext4 as that change where holes are created
+if [ "$FSTYP" = "ext4" ]; then
+	DEV=`basename $TEST_DEV`
+	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
+fi
+
+# When PAGE_SIZE > 4096 xfs extent layout is different so it would not match
+# the output.
+if [ "$FSTYP" = "xfs" ]; then
+	PAGE_SIZE=`getconf PAGE_SIZE`
+	if [ $PAGE_SIZE -gt 4096 ]; then
+		_notrun "Not supported on xfs with page size > 4096"
+	fi
+fi
+
+# Standard zero range tests
+_test_generic_punch falloc fzero fzero fiemap _filter_fiemap $testfile
+
+# Delayed allocation zero range tests
+_test_generic_punch -d falloc fzero fzero fiemap _filter_fiemap $testfile
+
+# Multi zero range tests
+_test_generic_punch -k falloc fzero fzero fiemap _filter_fiemap $testfile
+
+# Delayed allocation multi zero range tests
+_test_generic_punch -d -k falloc fzero fzero fiemap _filter_fiemap $testfile
+
+status=0 ; exit
diff --git a/tests/generic/009.out b/tests/generic/009.out
new file mode 100644
index 0000000..4b451ba
--- /dev/null
+++ b/tests/generic/009.out
@@ -0,0 +1,333 @@
+QA output created by 009
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..23]: unwritten
+1: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..23]: unwritten
+1: [24..31]: data
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+daa100df6e6711906b61c9ab5aa16032
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: data
+1: [24..39]: unwritten
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: unwritten
+1: [16..39]: data
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: data
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
diff --git a/tests/generic/group b/tests/generic/group
index a99b6a1..71bde41 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -10,6 +10,7 @@
 006 dir udf auto quick
 007 dir udf auto quick
 008 auto quick prealloc
+009 auto quick prealloc
 010 other udf auto
 011 dir udf auto quick
 013 other ioctl udf auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
