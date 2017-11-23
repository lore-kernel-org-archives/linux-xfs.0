Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbdKWMNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 07:13:42 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v6] generic: initial fiemap range query test
Date: Thu, 23 Nov 2017 14:13:34 +0200
Message-Id: <1511439214-8400-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net, Nikolay Borisov <nborisov@suse.com>

Fiemap gained support for passing in optional offset len
which denote the range requested, so this patch adds
testcases for this functionality. Aditionally, a special "ranged"
argument is added to the require_xfs_io_command which checks
for the presence of fiemap range support.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
--- 
 V6:
 * Moved to generic tests and successfully ran against ext4/btrfs
 * Use pwrite to create the holes to make it even more generic

 V5: 
  * Drop changes to existing generic punch hole tests since 
  the new fiemap implementation don't require them 
  * Merge the common/rc change with this patch
  * Added Data + Hole + Data and Hole + Data tests as per Eryu's request
  * Adjusted output of some tests which fall in a hole, since holes are
  truncated to passed range
  * Simplified the logic to check for fiemap range support (Eryu)

 V4: 
  * Added test description
  * Added new test for past-eof behavior
  * Removed supported_generic_fs line
  * Switched to using the "ranged" param require
  * Revert v3 changes

 V3:
  * Adjusted tests for '-r' fiemap param
  * Tests for invalid -r combination

 V2: No change
 V1: No change
 common/rc             |   7 +++
 tests/generic/900     | 108 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |   1 +
 4 files changed, 241 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/common/rc b/common/rc
index 4c053a5..a0d162a 100644
--- a/common/rc
+++ b/common/rc
@@ -2056,6 +2056,13 @@ _require_xfs_io_command()
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
 	"fiemap")
+		# If 'ranged' is passed as argument then we check to see if fiemap supports
+		# ranged query params
+		if echo "$param" | grep -q "ranged"; then
+			param=$(echo "$param" | sed "s/ranged//")
+			$XFS_IO_PROG -c "help fiemap" | grep -q "\[offset \[len\]\]"
+			[ $? -eq 0 ] || _notrun "xfs_io $command ranged support is missing"
+		fi
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "fiemap -v $param" $testfile 2>&1`
 		param_checked=1
diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 0000000..64a762f
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 900
+
+# Test for the new ranged query functionality in xfs_io's fiemap command.
+# This tests various combinations of hole + data layout being printed.
+# Also the test used 16k holes to be compatible with 16k block filesystems
+
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Nikolay Borisov <nborisov@suse.com>
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/punch
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "truncate"
+# ranged is a special argument which checks if fiemap supports
+# [offset [len]] args
+_require_xfs_io_command "fiemap" "ranged"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount || _fail "mount failure"
+
+file=$SCRATCH_MNT/testfile
+
+# Create a file with 16k hole followed by 16k data, and this pattern
+# repeats till it reaches 1M file size, so each extent has 16k data.
+# But truncate file to its final size first, otherwise XFS would merge
+# some extents due to speculative preallocation.
+$XFS_IO_PROG -f -c "truncate 1m" $file
+for i in {0..31}; do
+	$XFS_IO_PROG -c "pwrite $(($i*32+16))k 16k" $file >/dev/null;
+done
+
+# Query 1 data extent between 16k..16k range
+echo "Basic data extent"
+$XFS_IO_PROG -c "fiemap -v 16k 16k" $file | _filter_fiemap
+
+# Query data and hole extent
+echo "Data + Hole"
+$XFS_IO_PROG -c "fiemap -v 16k 20k" $file | _filter_fiemap
+
+echo "Hole + Data"
+$XFS_IO_PROG -c "fiemap -v 0 17k" $file | _filter_fiemap
+
+echo "Hole + Data + Hole"
+$XFS_IO_PROG -c "fiemap -v 32k 40k" $file | _filter_fiemap
+
+echo "Data + Hole + Data"
+$XFS_IO_PROG -c "fiemap -v 16k 33k" $file | _filter_fiemap
+
+echo "Beginning with a hole"
+$XFS_IO_PROG -c "fiemap -v 0 3k" $file | _filter_fiemap
+
+# Query for 0..160k that's 40 extents, more than the EXTENT_BATCH
+echo "Query more than 32 extents"
+$XFS_IO_PROG -c "fiemap -v 0 640k" $file | _filter_fiemap
+
+echo "Larger query than file size"
+$XFS_IO_PROG -c "fiemap -v 0 2m" $file | _filter_fiemap
+
+# mapping past eof shouldn't print anything"
+$XFS_IO_PROG -c "fiemap -v 2m" $file | _filter_fiemap
+
+# check everything without the first hole
+$XFS_IO_PROG -c "fiemap -v 16k" $file | wc -l
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 0000000..ba1b4d6
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,125 @@
+QA output created by 900
+Basic data extent
+0: [32..63]: data
+Data + Hole
+0: [32..63]: data
+1: [64..71]: hole
+Hole + Data
+0: [0..31]: hole
+1: [32..63]: data
+Hole + Data + Hole
+0: [64..95]: hole
+1: [96..127]: data
+2: [128..143]: hole
+Data + Hole + Data
+0: [32..63]: data
+1: [64..95]: hole
+2: [96..127]: data
+Beginning with a hole
+Query more than 32 extents
+0: [0..31]: hole
+1: [32..63]: data
+2: [64..95]: hole
+3: [96..127]: data
+4: [128..159]: hole
+5: [160..191]: data
+6: [192..223]: hole
+7: [224..255]: data
+8: [256..287]: hole
+9: [288..319]: data
+10: [320..351]: hole
+11: [352..383]: data
+12: [384..415]: hole
+13: [416..447]: data
+14: [448..479]: hole
+15: [480..511]: data
+16: [512..543]: hole
+17: [544..575]: data
+18: [576..607]: hole
+19: [608..639]: data
+20: [640..671]: hole
+21: [672..703]: data
+22: [704..735]: hole
+23: [736..767]: data
+24: [768..799]: hole
+25: [800..831]: data
+26: [832..863]: hole
+27: [864..895]: data
+28: [896..927]: hole
+29: [928..959]: data
+30: [960..991]: hole
+31: [992..1023]: data
+32: [1024..1055]: hole
+33: [1056..1087]: data
+34: [1088..1119]: hole
+35: [1120..1151]: data
+36: [1152..1183]: hole
+37: [1184..1215]: data
+38: [1216..1247]: hole
+39: [1248..1279]: data
+Larger query than file size
+0: [0..31]: hole
+1: [32..63]: data
+2: [64..95]: hole
+3: [96..127]: data
+4: [128..159]: hole
+5: [160..191]: data
+6: [192..223]: hole
+7: [224..255]: data
+8: [256..287]: hole
+9: [288..319]: data
+10: [320..351]: hole
+11: [352..383]: data
+12: [384..415]: hole
+13: [416..447]: data
+14: [448..479]: hole
+15: [480..511]: data
+16: [512..543]: hole
+17: [544..575]: data
+18: [576..607]: hole
+19: [608..639]: data
+20: [640..671]: hole
+21: [672..703]: data
+22: [704..735]: hole
+23: [736..767]: data
+24: [768..799]: hole
+25: [800..831]: data
+26: [832..863]: hole
+27: [864..895]: data
+28: [896..927]: hole
+29: [928..959]: data
+30: [960..991]: hole
+31: [992..1023]: data
+32: [1024..1055]: hole
+33: [1056..1087]: data
+34: [1088..1119]: hole
+35: [1120..1151]: data
+36: [1152..1183]: hole
+37: [1184..1215]: data
+38: [1216..1247]: hole
+39: [1248..1279]: data
+40: [1280..1311]: hole
+41: [1312..1343]: data
+42: [1344..1375]: hole
+43: [1376..1407]: data
+44: [1408..1439]: hole
+45: [1440..1471]: data
+46: [1472..1503]: hole
+47: [1504..1535]: data
+48: [1536..1567]: hole
+49: [1568..1599]: data
+50: [1600..1631]: hole
+51: [1632..1663]: data
+52: [1664..1695]: hole
+53: [1696..1727]: data
+54: [1728..1759]: hole
+55: [1760..1791]: data
+56: [1792..1823]: hole
+57: [1824..1855]: data
+58: [1856..1887]: hole
+59: [1888..1919]: data
+60: [1920..1951]: hole
+61: [1952..1983]: data
+62: [1984..2015]: hole
+63: [2016..2047]: data
+65
diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03..6a3662b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -472,3 +472,4 @@
 467 auto quick exportfs
 468 shutdown auto quick metadata
 469 auto quick
+900
-- 
2.7.4

