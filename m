Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753407AbdKMPuf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 10:50:35 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 2/2] xfs: initial fiemap range query test
Date: Mon, 13 Nov 2017 17:50:29 +0200
Message-Id: <1510588229-6079-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1510588229-6079-1-git-send-email-nborisov@suse.com>
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
 <1510588229-6079-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V3: 
 * Added tests for -r parameter error handling
 tests/xfs/900     |  98 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/900.out | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 222 insertions(+)
 create mode 100755 tests/xfs/900
 create mode 100644 tests/xfs/900.out

diff --git a/tests/xfs/900 b/tests/xfs/900
new file mode 100755
index 0000000..570f7d6
--- /dev/null
+++ b/tests/xfs/900
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 900
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap" "-r 0 4k"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount || _fail "mount failure"
+
+file=$SCRATCH_MNT/testfile
+$XFS_IO_PROG -f -c "falloc 0 256k" $file 
+for i in {0..31}; do $XFS_IO_PROG -c "fpunch $(($i*8))k 4k" $file; done
+
+# Query 1 data extent between 4k..8k range
+echo "Basic data extent"
+$XFS_IO_PROG -c "fiemap -v -r 4k 4k" $file | _filter_fiemap 
+
+# Query data and hole extent
+echo "Data + Hole"
+$XFS_IO_PROG -c "fiemap -v -r 4k 5k" $file | _filter_fiemap
+
+echo "Hole + Data + Hole"
+$XFS_IO_PROG -c "fiemap -v -r 8k 10k" $file | _filter_fiemap
+
+echo "Beginning with a hole"
+$XFS_IO_PROG -c "fiemap -v -r 0 3k" $file | _filter_fiemap
+
+# Query for 0..160k that's 40 extents, more than the EXTENT_BATCH
+echo "Query more than 32 extents"
+$XFS_IO_PROG -c "fiemap -v -r 0 160k" $file | _filter_fiemap
+
+echo "Larger query than file size"
+$XFS_IO_PROG -c "fiemap -v -r 0 300k" $file | _filter_fiemap
+
+echo "Parameter parsing tests"
+
+#check everything without the first hole, should print 65
+$XFS_IO_PROG -c "fiemap -v -r 4k" $file | wc -l
+
+#check correct handling of [-r offset] followed by another param
+$XFS_IO_PROG -c "fiemap -v -r 4k -n 5" $file | wc -l
+
+#check correct handling of [-r offset len] followed by another param
+$XFS_IO_PROG -c "fiemap -v -r 4k 12k -n 2" $file | wc -l
+
+#check incorrect offset arg. should return error
+$XFS_IO_PROG -c "fiemap -v -r -n 1" $file
+$XFS_IO_PROG -c "fiemap -v -r" $file
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/900.out b/tests/xfs/900.out
new file mode 100644
index 0000000..fa25565
--- /dev/null
+++ b/tests/xfs/900.out
@@ -0,0 +1,124 @@
+QA output created by 900
+Basic data extent
+0: [8..15]: unwritten
+Data + Hole
+0: [8..15]: unwritten
+1: [16..23]: hole
+Hole + Data + Hole
+0: [16..23]: hole
+1: [24..31]: unwritten
+2: [32..39]: hole
+Beginning with a hole
+0: [0..7]: hole
+Query more than 32 extents
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..23]: hole
+3: [24..31]: unwritten
+4: [32..39]: hole
+5: [40..47]: unwritten
+6: [48..55]: hole
+7: [56..63]: unwritten
+8: [64..71]: hole
+9: [72..79]: unwritten
+10: [80..87]: hole
+11: [88..95]: unwritten
+12: [96..103]: hole
+13: [104..111]: unwritten
+14: [112..119]: hole
+15: [120..127]: unwritten
+16: [128..135]: hole
+17: [136..143]: unwritten
+18: [144..151]: hole
+19: [152..159]: unwritten
+20: [160..167]: hole
+21: [168..175]: unwritten
+22: [176..183]: hole
+23: [184..191]: unwritten
+24: [192..199]: hole
+25: [200..207]: unwritten
+26: [208..215]: hole
+27: [216..223]: unwritten
+28: [224..231]: hole
+29: [232..239]: unwritten
+30: [240..247]: hole
+31: [248..255]: unwritten
+32: [256..263]: hole
+33: [264..271]: unwritten
+34: [272..279]: hole
+35: [280..287]: unwritten
+36: [288..295]: hole
+37: [296..303]: unwritten
+38: [304..311]: hole
+39: [312..319]: unwritten
+Larger query than file size
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..23]: hole
+3: [24..31]: unwritten
+4: [32..39]: hole
+5: [40..47]: unwritten
+6: [48..55]: hole
+7: [56..63]: unwritten
+8: [64..71]: hole
+9: [72..79]: unwritten
+10: [80..87]: hole
+11: [88..95]: unwritten
+12: [96..103]: hole
+13: [104..111]: unwritten
+14: [112..119]: hole
+15: [120..127]: unwritten
+16: [128..135]: hole
+17: [136..143]: unwritten
+18: [144..151]: hole
+19: [152..159]: unwritten
+20: [160..167]: hole
+21: [168..175]: unwritten
+22: [176..183]: hole
+23: [184..191]: unwritten
+24: [192..199]: hole
+25: [200..207]: unwritten
+26: [208..215]: hole
+27: [216..223]: unwritten
+28: [224..231]: hole
+29: [232..239]: unwritten
+30: [240..247]: hole
+31: [248..255]: unwritten
+32: [256..263]: hole
+33: [264..271]: unwritten
+34: [272..279]: hole
+35: [280..287]: unwritten
+36: [288..295]: hole
+37: [296..303]: unwritten
+38: [304..311]: hole
+39: [312..319]: unwritten
+40: [320..327]: hole
+41: [328..335]: unwritten
+42: [336..343]: hole
+43: [344..351]: unwritten
+44: [352..359]: hole
+45: [360..367]: unwritten
+46: [368..375]: hole
+47: [376..383]: unwritten
+48: [384..391]: hole
+49: [392..399]: unwritten
+50: [400..407]: hole
+51: [408..415]: unwritten
+52: [416..423]: hole
+53: [424..431]: unwritten
+54: [432..439]: hole
+55: [440..447]: unwritten
+56: [448..455]: hole
+57: [456..463]: unwritten
+58: [464..471]: hole
+59: [472..479]: unwritten
+60: [480..487]: hole
+61: [488..495]: unwritten
+62: [496..503]: hole
+63: [504..511]: unwritten
+Parameter parsing tests
+65
+7
+4
+Invalid offset argument for -r
+Invalid offset argument for -r
-- 
2.7.4

