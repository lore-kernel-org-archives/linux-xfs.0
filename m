Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46161 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757664AbdKOMLo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:11:44 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 3/3] xfs: initial fiemap range query test
Date: Wed, 15 Nov 2017 14:11:40 +0200
Message-Id: <1510747900-13440-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1510747900-13440-1-git-send-email-nborisov@suse.com>
References: <1510747821-13270-1-git-send-email-nborisov@suse.com>
 <1510747900-13440-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

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

 tests/xfs/900     |  92 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/900.out | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+)
 create mode 100755 tests/xfs/900
 create mode 100644 tests/xfs/900.out

diff --git a/tests/xfs/900 b/tests/xfs/900
new file mode 100755
index 0000000..06a5c64
--- /dev/null
+++ b/tests/xfs/900
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 900
+# Test for the new ranged query functionality in xfs_io's fiemap command.
+# This tests various combinations of hole + data layout being printed.
+# Also the test used 16k holes to be compatible with 16k block filesystems
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Nikolay Borisov <nborisov@suse.com>
+#
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap" "ranged"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount || _fail "mount failure"
+
+file=$SCRATCH_MNT/testfile
+$XFS_IO_PROG -f -c "falloc 0 1m" $file 
+for i in {0..31}; do $XFS_IO_PROG -c "fpunch $(($i*32))k 16k" $file; done
+
+# Query 1 data extent between 16k..16k range
+echo "Basic data extent"
+$XFS_IO_PROG -c "fiemap -v 16k 16k" $file | _filter_fiemap 
+
+# Query data and hole extent
+echo "Data + Hole"
+$XFS_IO_PROG -c "fiemap -v 16k 20k" $file | _filter_fiemap
+
+echo "Hole + Data + Hole"
+$XFS_IO_PROG -c "fiemap -v 32k 40k" $file | _filter_fiemap
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
+#mapping past eof shouldn't print anything"
+$XFS_IO_PROG -c "fiemap -v 2m" $file | _filter_fiemap
+
+#check everything without the first hole
+$XFS_IO_PROG -c "fiemap -v 16k" $file | wc -l
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/900.out b/tests/xfs/900.out
new file mode 100644
index 0000000..6ecf1b6
--- /dev/null
+++ b/tests/xfs/900.out
@@ -0,0 +1,119 @@
+QA output created by 900
+Basic data extent
+0: [32..63]: unwritten
+Data + Hole
+0: [32..63]: unwritten
+1: [64..95]: hole
+Hole + Data + Hole
+0: [64..95]: hole
+1: [96..127]: unwritten
+2: [128..159]: hole
+Beginning with a hole
+0: [0..31]: hole
+Query more than 32 extents
+0: [0..31]: hole
+1: [32..63]: unwritten
+2: [64..95]: hole
+3: [96..127]: unwritten
+4: [128..159]: hole
+5: [160..191]: unwritten
+6: [192..223]: hole
+7: [224..255]: unwritten
+8: [256..287]: hole
+9: [288..319]: unwritten
+10: [320..351]: hole
+11: [352..383]: unwritten
+12: [384..415]: hole
+13: [416..447]: unwritten
+14: [448..479]: hole
+15: [480..511]: unwritten
+16: [512..543]: hole
+17: [544..575]: unwritten
+18: [576..607]: hole
+19: [608..639]: unwritten
+20: [640..671]: hole
+21: [672..703]: unwritten
+22: [704..735]: hole
+23: [736..767]: unwritten
+24: [768..799]: hole
+25: [800..831]: unwritten
+26: [832..863]: hole
+27: [864..895]: unwritten
+28: [896..927]: hole
+29: [928..959]: unwritten
+30: [960..991]: hole
+31: [992..1023]: unwritten
+32: [1024..1055]: hole
+33: [1056..1087]: unwritten
+34: [1088..1119]: hole
+35: [1120..1151]: unwritten
+36: [1152..1183]: hole
+37: [1184..1215]: unwritten
+38: [1216..1247]: hole
+39: [1248..1279]: unwritten
+Larger query than file size
+0: [0..31]: hole
+1: [32..63]: unwritten
+2: [64..95]: hole
+3: [96..127]: unwritten
+4: [128..159]: hole
+5: [160..191]: unwritten
+6: [192..223]: hole
+7: [224..255]: unwritten
+8: [256..287]: hole
+9: [288..319]: unwritten
+10: [320..351]: hole
+11: [352..383]: unwritten
+12: [384..415]: hole
+13: [416..447]: unwritten
+14: [448..479]: hole
+15: [480..511]: unwritten
+16: [512..543]: hole
+17: [544..575]: unwritten
+18: [576..607]: hole
+19: [608..639]: unwritten
+20: [640..671]: hole
+21: [672..703]: unwritten
+22: [704..735]: hole
+23: [736..767]: unwritten
+24: [768..799]: hole
+25: [800..831]: unwritten
+26: [832..863]: hole
+27: [864..895]: unwritten
+28: [896..927]: hole
+29: [928..959]: unwritten
+30: [960..991]: hole
+31: [992..1023]: unwritten
+32: [1024..1055]: hole
+33: [1056..1087]: unwritten
+34: [1088..1119]: hole
+35: [1120..1151]: unwritten
+36: [1152..1183]: hole
+37: [1184..1215]: unwritten
+38: [1216..1247]: hole
+39: [1248..1279]: unwritten
+40: [1280..1311]: hole
+41: [1312..1343]: unwritten
+42: [1344..1375]: hole
+43: [1376..1407]: unwritten
+44: [1408..1439]: hole
+45: [1440..1471]: unwritten
+46: [1472..1503]: hole
+47: [1504..1535]: unwritten
+48: [1536..1567]: hole
+49: [1568..1599]: unwritten
+50: [1600..1631]: hole
+51: [1632..1663]: unwritten
+52: [1664..1695]: hole
+53: [1696..1727]: unwritten
+54: [1728..1759]: hole
+55: [1760..1791]: unwritten
+56: [1792..1823]: hole
+57: [1824..1855]: unwritten
+58: [1856..1887]: hole
+59: [1888..1919]: unwritten
+60: [1920..1951]: hole
+61: [1952..1983]: unwritten
+62: [1984..2015]: hole
+63: [2016..2047]: unwritten
+65
-- 
2.7.4

