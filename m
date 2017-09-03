Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39178 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752585AbdICMOw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 08:14:52 -0400
Date: Sun, 3 Sep 2017 14:14:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: test getbmap on reflinked files
Message-ID: <20170903121451.GA18274@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Test that we correctly report shared and unshared regions in a file.

To do so we also update _filter_bmap to include the shared flag.

Based on a test case from Darrick Wong.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/common/punch b/common/punch
index c4ed261..3c400c1 100644
--- a/common/punch
+++ b/common/punch
@@ -263,6 +263,10 @@ _filter_bmap()
 			print $1, $2, $3;
 			next;
 		}
+		$7 ~ /1[01][01][01][01][01]/ {
+			print $1, $2, "shared";
+			next;
+		}
 		$7 ~ /1[01][01][01][01]/ {
 			print $1, $2, "unwritten";
 			next;
diff --git a/tests/xfs/115 b/tests/xfs/115
new file mode 100755
index 0000000..eb456dc
--- /dev/null
+++ b/tests/xfs/115
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 115
+#
+# Check getbmap reporting for reflinked files
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Christoph Hellwig.  All Rights Reserved.
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
+file=$TEST_DIR/${seq}.file
+clone=$TEST_DIR/${seq}.clone
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f ${file} ${clone}
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/punch
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_test_reflink
+_require_cp_reflink
+
+# write file and check extent map
+touch ${file}
+xfs_io -c 'pwrite 0 1m' \
+	-c 'fsync' ${file} >/dev/null
+echo "initial file layout:"
+xfs_io -c 'bmap -elpv' ${file} | _filter_test_dir | _filter_bmap
+echo
+
+# reflink file and check for the shared bit in the extent map
+cp --reflink=always ${file} ${clone} >/dev/null
+echo "layout after reflink"
+xfs_io -c 'bmap -elpv' ${file} | _filter_test_dir | _filter_bmap
+echo
+
+# break COW and check the shared split in the extent map
+xfs_io -c 'pwrite 200k 4k' \
+	-c 'pwrite 700k 4k' \
+	-c 'fsync' ${clone} | >/dev/null
+echo "layout after partial unshare:"
+xfs_io -c 'bmap -elpv' ${file} | _filter_test_dir | _filter_bmap
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/115.out b/tests/xfs/115.out
new file mode 100644
index 0000000..45e1d3c
--- /dev/null
+++ b/tests/xfs/115.out
@@ -0,0 +1,13 @@
+QA output created by 115
+initial file layout:
+0: [0..2047]: data
+
+layout after reflink
+0: [0..2047]: shared
+
+layout after partial unshare:
+0: [0..399]: shared
+1: [400..407]: data
+2: [408..1399]: shared
+3: [1400..1407]: data
+4: [1408..2047]: shared
diff --git a/tests/xfs/group b/tests/xfs/group
index 5c02498..97d6eee 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -112,6 +112,7 @@
 112 fuzzers
 113 fuzzers
 114 auto rw dangerous
+115 auto quick ioctl clone
 116 quota auto quick
 117 fuzzers
 118 auto quick fsr dangerous
