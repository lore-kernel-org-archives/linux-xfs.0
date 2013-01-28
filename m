Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA6B37F52
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 01:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA1DC8F8054
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:33 -0800 (PST)
Received: from mail-da0-f51.google.com (mail-da0-f51.google.com
	[209.85.210.51]) by cuda.sgi.com with ESMTP id iY6AMVTYKOBQ2hh4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:31 -0800 (PST)
Received: by mail-da0-f51.google.com with SMTP id i30so1107262dad.38
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:31 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/4] xfstests: 295: test fallocate hole punching for all file
	systems
Date: Mon, 28 Jan 2013 15:32:49 +0800
Message-Id: <1359358371-21411-3-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In 255 it tries to test fallocate hole punching for a file system, but
it is only for the file system that supports to preallocate unwritten
extents.

Recently ext4 file systems will support hole punching feature for a
indirect-based file.  So a new test case is created to test it.  Here
this test case does the same thing like 255 except it doesn't try to
preallocate some unwritten extents.  Certainly all file systems that
support hole punching feature and can preallocate unwritten extents
also survive in this test case.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
---
 295     |  68 ++++++++++++++
 295.out | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group   |   1 +
 3 files changed, 376 insertions(+)
 create mode 100755 295
 create mode 100644 295.out

diff --git a/295 b/295
new file mode 100755
index 0000000..3df7dc8
--- /dev/null
+++ b/295
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 295
+#
+# Test Generic fallocate hole punching w/o unwritten extent
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
+# creator
+owner=wenqing.lz@taobao.com
+
+seq=`basename $0`
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
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_fiemap
+
+testfile=$TEST_DIR/295.$$
+
+# Standard punch hole tests
+_test_generic_punch pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation punch hole tests
+_test_generic_punch -d pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Multi hole punch tests
+_test_generic_punch -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation multi punch hole tests
+_test_generic_punch -d -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# success, all done
+status=0
+exit
diff --git a/295.out b/295.out
new file mode 100644
index 0000000..c4c495f
--- /dev/null
+++ b/295.out
@@ -0,0 +1,307 @@
+QA output created by 295
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
diff --git a/group b/group
index 505bc7f..a07d7f3 100644
--- a/group
+++ b/group
@@ -413,3 +413,4 @@ deprecated
 292 auto mkfs quick
 293 auto quick
 294 auto quick
+295 auto quick prealloc
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
