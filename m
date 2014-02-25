Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AB027F56
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:11:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F22EC304071
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eyN8gsL2VEUEV3l0 for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:11:43 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero range
Date: Tue, 25 Feb 2014 20:15:28 +0100
Message-Id: <1393355728-12056-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

This is copy of xfs/242. However it's better to make it file system
specific because the range can be zeroes either directly by writing
zeroes, or converting to unwritten extent, so the actual result might
differ from file system to file system.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/ext4/242     | 63 ++++++++++++++++++++++++++++++++++++++++
 tests/ext4/242.out | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/group   |  1 +
 3 files changed, 148 insertions(+)
 create mode 100755 tests/ext4/242
 create mode 100644 tests/ext4/242.out

diff --git a/tests/ext4/242 b/tests/ext4/242
new file mode 100755
index 0000000..f34036c
--- /dev/null
+++ b/tests/ext4/242
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 242
+#
+# Test fallocate FALLOC_FL_ZERO_RANGE
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat.  All Rights Reserved.
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
+_supported_fs ext4
+_supported_os Linux
+_require_xfs_io_falloc_zero
+
+_test_io_zero()
+{
+	$XFS_IO_PROG -c "fzero help" 2>&1 | \
+			grep 'command "zero" not found' > /dev/null
+	echo $?
+}
+
+[ $(_test_io_zero) -eq 0 ] && _notrun "fzero command not supported"
+
+testfile=$TEST_DIR/242.$$
+
+_test_generic_punch falloc fzero fzero fiemap _filter_fiemap $testfile
+
+status=0 ; exit
diff --git a/tests/ext4/242.out b/tests/ext4/242.out
new file mode 100644
index 0000000..3b80b4d
--- /dev/null
+++ b/tests/ext4/242.out
@@ -0,0 +1,84 @@
+QA output created by 242
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
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
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
diff --git a/tests/ext4/group b/tests/ext4/group
index 7e1a68b..c8b47cc 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -3,6 +3,7 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
+242 auto prealloc quick
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
