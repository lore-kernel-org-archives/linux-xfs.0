Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U5LiE0184000 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:21:44 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51EE74C28DB
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:43 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id kvHxAoFnTZ3d1EVR for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 22:21:43 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5U4wjQ1012571
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:58:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5U5LhB3630840 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:43 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5U5LgFM032094 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:21:43 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/4 v3] XFS TESTS: Fix 252 Failure: Add Generic FS Punch Hole
	Test 255
Date: Wed, 29 Jun 2011 22:24:01 -0700
Message-Id: <1309411441-2491-5-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

This patch adds a new test 255 that tests fallocate punch hole,
but is for use by generic filesystems.  It is similar to 252,
but uses a weaker fiemap filter that only displays the location
of the hole, and not the extent types.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:000000 100644 0000000... 0083963... A	255
:000000 100644 0000000... 2ce882b... A	255.out
:100644 100644 c18f88a... a48b7ae... M	common.punch
:100644 100644 1f86075... 9558bc7... M	group
 255          |   67 +++++++++++++
 255.out      |  307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.punch |   17 +++
 group        |    1 +
 4 files changed, 392 insertions(+), 0 deletions(-)

diff --git a/255 b/255
new file mode 100644
index 0000000..0083963
--- /dev/null
+++ b/255
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 255
+#
+# Test Generic fallocate hole punching
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
+# creator
+owner=josef@redhat.com
+
+seq=`basename $0`
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
+testfile=$TEST_DIR/255.$$
+
+# Standard punch hole tests
+_test_generic_punch falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation punch hole tests
+_test_generic_punch -d falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Multi hole punch tests
+_test_generic_punch -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation multi punch hole tests
+_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+status=0 ; exit
diff --git a/255.out b/255.out
new file mode 100644
index 0000000..2ce882b
--- /dev/null
+++ b/255.out
@@ -0,0 +1,307 @@
+QA output created by 255
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
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
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
+daa100df6e6711906b61c9ab5aa16032
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
+daa100df6e6711906b61c9ab5aa16032
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+1b3779878366498b28c702ef88c4a773
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+daa100df6e6711906b61c9ab5aa16032
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
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
+daa100df6e6711906b61c9ab5aa16032
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
diff --git a/common.punch b/common.punch
index c18f88a..a48b7ae 100644
--- a/common.punch
+++ b/common.punch
@@ -218,6 +218,23 @@ _filter_fiemap()
 	_coalesce_extents
 }
 
+# Filters fiemap output to only print the 
+# file offset column and whether or not
+# it is an extent or a hole
+_filter_hole_fiemap()
+{
+	awk --posix '
+		$3 ~ /hole/ {
+			print $1, $2, $3; 
+			next;
+		}   
+		$5 ~ /0x[[:digit:]]+/ {
+			print $1, $2, "extent";
+		}' |
+	_coalesce_extents
+}
+
+
 # Prints the md5 checksum of a given file
 _md5_checksum()
 {
diff --git a/group b/group
index 1f86075..9558bc7 100644
--- a/group
+++ b/group
@@ -368,3 +368,4 @@ deprecated
 252 auto quick prealloc
 253 auto quick
 254 auto quick
+255 auto quick prealloc
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
