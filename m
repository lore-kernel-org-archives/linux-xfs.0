Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A37E7F5D
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 08:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A995304039
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 06:43:02 -0700 (PDT)
Received: from mail-pb0-f43.google.com (mail-pb0-f43.google.com
	[209.85.160.43]) by cuda.sgi.com with ESMTP id 5ZqR0PzZFxzf2TGY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Sep 2013 06:43:01 -0700 (PDT)
Received: by mail-pb0-f43.google.com with SMTP id md4so5068110pbc.16
	for <xfs@oss.sgi.com>; Sun, 08 Sep 2013 06:43:00 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v3 6/7] xfstest: Add test case to test multiple collapse range
	call
Date: Sun,  8 Sep 2013 22:42:51 +0900
Message-Id: <1378647771-2768-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

We execute collapse range multiple times on same file.
Each collapse range call collapses a single alternate block.
After the test execution, file will be left with 80 blocks and
as much number of extents.
We also check for file system consistency after the completion.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/shared/317     |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/317.out |   85 ++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/group   |    1 +
 3 files changed, 182 insertions(+)
 create mode 100644 tests/shared/317
 create mode 100644 tests/shared/317.out

diff --git a/tests/shared/317 b/tests/shared/317
new file mode 100644
index 0000000..1d7c384
--- /dev/null
+++ b/tests/shared/317
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 317
+#
+# Test multiple fallocate collapse range calls
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs ext4
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+_do_die_on_error=y
+test=$SCRATCH_MNT/test
+testfile=$SCRATCH_MNT/317.$$
+BSIZE=4096
+BLOCKS=10240
+
+# Filters fiemap output
+_filter_fiemap()
+{
+	awk --posix '
+		$3 ~ /hole/ {
+			print $1, $2, $3;
+			next;
+		}
+		$5 ~ /0x[[:xdigit:]]+/ {
+			print $1, $2, "extent";
+		}'
+}
+
+case $FSTYP in
+	ext4)
+		export MKFS_OPTIONS="-F -b $BSIZE"
+		;;
+	xfs)
+		export MKFS_OPTIONS="-f -b size=$BSIZE"
+		;;
+esac
+
+# make filesystem on scratch with 4KB blocksize
+_do 'make filesystem on $SCRATCH_DEV' '_scratch_mkfs'
+_do 'mount filesytem' '_scratch_mount'
+
+# Write file
+length=$(($BLOCKS*$BSIZE))
+$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
+
+# Collapse alternate blocks
+for (( i = 1; i <= 7; i++ )); do
+	for(( j=0 ; j < $(($BLOCKS/(2**$i))) ; j++ )); do
+		offset=$(($j*$BSIZE))
+		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
+	done
+done
+
+# Check if 80 extents are present
+$XFS_IO_PROG -c "fiemap -v" $testfile | _filter_fiemap
+
+_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
+_do 'repair filesystem' '_check_scratch_fs'
+
+# success, all done
+status=0; exit
diff --git a/tests/shared/317.out b/tests/shared/317.out
new file mode 100644
index 0000000..836f0fe
--- /dev/null
+++ b/tests/shared/317.out
@@ -0,0 +1,85 @@
+QA output created by 317
+make filesystem on $SCRATCH_DEV... done
+mount filesytem... done
+0: [0..7]: extent
+1: [8..15]: extent
+2: [16..23]: extent
+3: [24..31]: extent
+4: [32..39]: extent
+5: [40..47]: extent
+6: [48..55]: extent
+7: [56..63]: extent
+8: [64..71]: extent
+9: [72..79]: extent
+10: [80..87]: extent
+11: [88..95]: extent
+12: [96..103]: extent
+13: [104..111]: extent
+14: [112..119]: extent
+15: [120..127]: extent
+16: [128..135]: extent
+17: [136..143]: extent
+18: [144..151]: extent
+19: [152..159]: extent
+20: [160..167]: extent
+21: [168..175]: extent
+22: [176..183]: extent
+23: [184..191]: extent
+24: [192..199]: extent
+25: [200..207]: extent
+26: [208..215]: extent
+27: [216..223]: extent
+28: [224..231]: extent
+29: [232..239]: extent
+30: [240..247]: extent
+31: [248..255]: extent
+32: [256..263]: extent
+33: [264..271]: extent
+34: [272..279]: extent
+35: [280..287]: extent
+36: [288..295]: extent
+37: [296..303]: extent
+38: [304..311]: extent
+39: [312..319]: extent
+40: [320..327]: extent
+41: [328..335]: extent
+42: [336..343]: extent
+43: [344..351]: extent
+44: [352..359]: extent
+45: [360..367]: extent
+46: [368..375]: extent
+47: [376..383]: extent
+48: [384..391]: extent
+49: [392..399]: extent
+50: [400..407]: extent
+51: [408..415]: extent
+52: [416..423]: extent
+53: [424..431]: extent
+54: [432..439]: extent
+55: [440..447]: extent
+56: [448..455]: extent
+57: [456..463]: extent
+58: [464..471]: extent
+59: [472..479]: extent
+60: [480..487]: extent
+61: [488..495]: extent
+62: [496..503]: extent
+63: [504..511]: extent
+64: [512..519]: extent
+65: [520..527]: extent
+66: [528..535]: extent
+67: [536..543]: extent
+68: [544..551]: extent
+69: [552..559]: extent
+70: [560..567]: extent
+71: [568..575]: extent
+72: [576..583]: extent
+73: [584..591]: extent
+74: [592..599]: extent
+75: [600..607]: extent
+76: [608..615]: extent
+77: [616..623]: extent
+78: [624..631]: extent
+79: [632..639]: extent
+unmount $SCRATCH_DEV... done
+repair filesystem... done
diff --git a/tests/shared/group b/tests/shared/group
index 3a69294..80ff7ec 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -12,3 +12,4 @@
 298 auto trim
 305 aio dangerous enospc rw stress
 316 auto quick collapse
+317 auto collapse
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
