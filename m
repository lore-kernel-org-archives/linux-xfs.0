Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6A8WV3b066117 for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 03:32:31 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 244278F8049
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 01:32:28 -0700 (PDT)
Received: from [134.15.69.59] (cf-vpn-sw-corp-69-59.corp.sgi.com
	[134.15.69.59])
	by estes.americas.sgi.com (Postfix) with ESMTP id 718757001D73
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 03:32:27 -0500 (CDT)
Message-ID: <4FFBE89A.3070705@sgi.com>
Date: Tue, 10 Jul 2012 10:32:26 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstest: test corruption with multi extent in PAGE.
References: <20120710082318.685263546@sgi.com>
In-Reply-To: <20120710082318.685263546@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


   Test using extsize/resvspace to create a file with multiple extent in 
one PAGE. This show an error in the block conversion from unwritten to 
real. As a result we tag raw disk block as valid(3-4)
and  valid data as unwritten(5-6)

On an x86_64 machine the page should look like this.

buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023
2       DATA   b_state = 0x1023
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023
6       DATA   b_state = 0x1023
7       empty  b_state = 0

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
  287     |  148 	148 +	0 -	0 !
  287.out |  102 	102 +	0 -	0 !
  group   |    1 	1 +	0 -	0 !
  3 files changed, 251 insertions(+)
  create mode 100755 287
  create mode 100644 287.out

Index: b/287
===================================================================
--- /dev/null
+++ b/287
@@ -0,0 +1,148 @@
+#! /bin/bash
+# FS QA Test No. 287
+#
+# File corruption with multiple extent in a page.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+owner=arenaud@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+pgsize=$($here/src/feature -s)
+blksize=$(( ${pgsize} / 8))
+
+rm -f $seq.full
+if ! _scratch_mkfs_xfs -b size=${blksize} >> $seq.full 2>&1
+then
+    echo "!!! failed to mkfs on $SCRATCH_DEV"
+    exit ${status}
+fi
+
+_scratch_mount
+
+# Test one create a file using extsize with mix
+# real/unwritten extent in page. assume 8 blocks per page
+# U/R/R/U/U/R/R/U
+echo "Testing page U/R/R/U/U/R/R/U with extsize"
+testfile=${SCRATCH_MNT}/test_extsize_urrurru.data
+rm -f ${testfile}
+xfs_io -f -c "extsize $(( $pgsize * 5))" \
+    -c "pwrite $(( $pgsize + $blksize )) $(( $blksize * 2))" \
+    -c "pwrite $(( $pgsize + $blksize * 5 )) $(( $blksize * 2))" \
+    -c "truncate $(( $pgsize * 3))" \
+    -c stat -c "bmap -vp" \
+    ${testfile} >> $seq.full 2>&1
+
+hexdump ${testfile}
+echo
+
+# Test one create a file using resvsp with mix
+# real/unwritten extent in page. assume 8 blocks per page
+# U/R/R/U/U/R/R/U
+echo "Testing page U/R/R/U/U/R/R/U with resvsp"
+testfile=${SCRATCH_MNT}/test_resvsp_urrurru.data
+rm -f ${testfile}
+xfs_io -f -c "resvsp 0 $(( $pgsize * 5))" \
+    -c "pwrite $(( $pgsize + $blksize )) $(( $blksize * 2))" \
+    -c "pwrite $(( $pgsize + $blksize * 5 )) $(( $blksize * 2))" \
+    -c "truncate $(( $pgsize * 3))" \
+    -c stat -c "bmap -vp" \
+    ${testfile} >> $seq.full 2>&1
+
+hexdump ${testfile}
+echo
+
+
+# Test one create a file using resvsp with mix
+# real/unwritten extent in page. assume 8 blocks per page
+# real overflow resvspace
+# U/R/R/U/U/R/R/R R...
+echo "Testing page U/R/R/U/U/R/R/R with resvsp"
+testfile=${SCRATCH_MNT}/test_resvsp_urrurrr.data
+rm -f ${testfile}
+xfs_io -f -c "resvsp 0 $(( $pgsize * 2))" \
+    -c "pwrite $(( $pgsize + $blksize )) $(( $blksize * 2))" \
+    -c "pwrite $(( $pgsize + $blksize * 5 )) $(( $blksize * 4))" \
+    -c "truncate $(( $pgsize * 5))" \
+    -c stat -c "bmap -vp" \
+   ${testfile} >> $seq.full 2>&1
+
+hexdump ${testfile}
+echo
+
+# Test one create a file using resvsp with mix
+# real/unwritten extent in page. assume 8 blocks per page
+# switch problem to cluster write.
+#  R/R/R/R/R/R/R/R R/R/R/U/U/R/R/U
+echo "Testing page R/R/R/U/U/R/R/U with resvsp"
+testfile=${SCRATCH_MNT}/test_resvsp_rrrurru.data
+rm -f ${testfile}
+xfs_io -f -c "resvsp 0 $(( $pgsize * 10))" \
+    -c "pwrite $(( $pgsize )) $(( $blksize * 10))" \
+    -c "pwrite $(( $pgsize + $blksize * 12 )) $(( $blksize * 2))" \
+    -c "truncate $(( $pgsize * 5))" \
+    -c stat -c "bmap -vp" \
+    ${testfile} >> $seq.full 2>&1
+
+hexdump ${testfile}
+echo
+
+
+_scratch_unmount
+_scratch_mount
+echo
+# Dump all the file again after unmount making sure no
+# pages can be cached.
+
+echo "dumping test_extsize_urrurru.data"
+hexdump ${SCRATCH_MNT}/test_extsize_urrurru.data
+
+echo "dumping test_resvsp_urrurru.data"
+hexdump ${SCRATCH_MNT}/test_resvsp_urrurru.data
+
+echo "dumping test_resvsp_urrurrr.data"
+hexdump ${SCRATCH_MNT}/test_resvsp_urrurrr.data
+
+echo "dumping test_resvsp_rrrurru.data"
+hexdump ${SCRATCH_MNT}/test_resvsp_rrrurru.data
+
+_scratch_unmount
+
+
+# success, all done
+status=0
+exit
Index: b/287.out
===================================================================
--- /dev/null
+++ b/287.out
@@ -0,0 +1,102 @@
+QA output created by 287
+Testing page U/R/R/U/U/R/R/U with extsize
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001e00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0003000
+
+Testing page U/R/R/U/U/R/R/U with resvsp
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001e00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0003000
+
+Testing page U/R/R/U/U/R/R/R with resvsp
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0005000
+
+Testing page R/R/R/U/U/R/R/U with resvsp
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002400 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0002800 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002c00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0005000
+
+
+dumping test_extsize_urrurru.data
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001e00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0003000
+dumping test_resvsp_urrurru.data
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001e00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0003000
+dumping test_resvsp_urrurrr.data
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001600 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0005000
+dumping test_resvsp_rrrurru.data
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0001000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002400 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0002800 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0002c00 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0005000
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -405,3 +405,4 @@
  284 auto
  285 auto rw
  286 other
+287 auto rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
