Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 661377F55
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 09:39:15 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 502D730407A
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 07:39:15 -0800 (PST)
Message-Id: <20130129153915.105853779@sgi.com>
Date: Tue, 29 Jan 2013 09:39:16 -0600
From: rjohnston@sgi.com
Subject: [PATCH 2/3] xfstests: add test for agskip mount option
References: <20130129153914.801475275@sgi.com>
Content-Disposition: inline; filename=xfstests-add-agskip-test.patch
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

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
 295     |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 295.out |    2 
 group   |    1 
 3 files changed, 150 insertions(+)

Index: b/295
===================================================================
--- /dev/null
+++ b/295
@@ -0,0 +1,147 @@
+#! /bin/bash
+# FS QA Test No. 295
+#
+# Test agskip mount options
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 SGI.  All Rights Reserved.
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
+#
+# This test is a modified version of agskip test written by Alain Renaud.
+#
+#   Phase 1: Create an xfs filesystem with AGCOUNT=32 and verify that the
+#            AGCOUNT is 32.
+#   Phase 2: Mount the filesystem with AGSKIP=3.
+#   Phase 3: Verify that the AGSKIP is working correctly:
+#            Create a file that spans more than one AG (size=1.5 * AGSIZE)
+#            Create another file that is less than AGSIZE.
+#            Use xfs_bmap to verify that the second extent is at location
+#            previous_AG+1.
+#            Continue creating/verifying that the AG's are created 3 AG's
+#            apart
+#
+# creator
+owner=rjohnston@sgi.com
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
+
+# real QA test starts here
+rm -f $seq.full
+_require_scratch
+
+BLK_SIZE=4096
+AGCOUNT=32
+AGSKIP=3
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+echo "Phase 1: mkfs the filesystem" >> $seq.full 2>&1
+echo "DEBUG: agcount=${AGCOUNT}" >> $seq.full 2>&1
+_scratch_mkfs_xfs " -dagcount=${AGCOUNT}" \
+    >> $seq.full 2>&1 || _fail "mkfs_xfs failed"
+
+# Get fs agcount
+_agcount=$( xfs_db -r -c 'sb 0' -c 'print' ${SCRATCH_DEV} | \
+    awk '$1 == "agcount" { print $3 }' ) >> $seq.full 2>&1
+_agblocks=$( xfs_db -r -c 'sb 0' -c 'print' ${SCRATCH_DEV} | \
+    awk '$1 == "agblocks" { print $3 }' ) >> $seq.full 2>&1
+
+# Print size in meg
+_agsize=$(( _agblocks * ${BLK_SIZE} / 1024 / 1024 )) >> $seq.full 2>&1
+
+if [[ "${_agcount}" -ne ${AGCOUNT} ]]
+then
+    echo "ERROR: agcount(${_agcount}) value is incorrect " >> $seq.full 2>&1
+    exit
+fi
+
+echo "Phase 2: mount filesystem with agskip option" >> $seq.full 2>&1
+echo "DEBUG: agskip=${AGSKIP} "  >> $seq.full 2>&1
+
+# mount
+_scratch_mount "-o agskip=${AGSKIP}" >> $seq.full 2>&1 \
+    || _fail "xfs_mount failed"
+
+echo "Phase 3: test agskip option"
+mkdir ${SCRATCH_MNT}/agskip-${AGSKIP}.dir >> $seq.full 2>&1 \
+    || _fail "mkdir failed"
+
+# make the first file with 2 extents
+FSIZE=$(( ${_agsize} + (  ${_agsize} / 2 )))
+FILE=${SCRATCH_MNT}/agskip-${AGSKIP}.dir/file-0
+echo "DEBUG: making first file with size = ${FSIZE}m" >> $seq.full 2>&1
+xfs_mkfile ${FSIZE}m ${FILE} >> $seq.full 2>&1 \
+    || _fail "failed to make file ${FILE}"
+
+agvalue=$( xfs_bmap -v ${FILE} | awk '$1 == "0:" { print $4 }')
+
+# make sure that the second extent is at location AG+1
+_agtmp=$( xfs_bmap -v ${FILE} | awk '$1 == "1:" { print $4 }')
+
+if [[ $(( ( agvalue + 1 ) % AGCOUNT )) -ne ${_agtmp} ]]
+then
+    echo -n "ERROR: The AG location of extent-1=${_agtmp}" >> $seq.full 2>&1
+    echo    "       as where extent-0=${agvalue}" >> $seq.full 2>&1
+    exit
+fi
+
+_cmpt=1
+while [[ ${_cmpt} -lt 25 ]]
+do
+    FILE=${SCRATCH_MNT}/agskip-${AGSKIP}.dir/file-${_cmpt}
+    if ! xfs_mkfile 10m ${FILE}
+    then
+        echo "ERROR: failed to make file ${FILE}" >> $seq.full 2>&1
+        exit
+    fi
+    _agtmp=$( xfs_bmap -v ${FILE} | awk '$1 == "0:" { print $4 }')
+    if [[ $(( ( agvalue + AGSKIP ) % AGCOUNT )) -ne ${_agtmp} ]]
+    then
+        echo "ERROR: The AG location of file ${FILE} not at AG+${AGSKIP}" \
+             >> $seq.full 2>&1
+        echo "       old AG == ${agvalue} new AG == ${_agtmp}" >> $seq.full 2>&1
+        exit
+    fi
+    agvalue=${_agtmp}
+    let _cmpt++
+done
+
+echo "# unmounting scratch" >> $seq.full 2>&1
+${UMOUNT_PROG} ${SCRATCH_MNT} >>$seq.full 2>&1 || _fail "unmount failed"
+
+# success, all done
+status=0
+_cleanup
+exit
Index: b/295.out
===================================================================
--- /dev/null
+++ b/295.out
@@ -0,0 +1,2 @@
+QA output created by 295
+Phase 3: test agskip option
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -413,3 +413,4 @@ deprecated
 292 auto mkfs quick
 293 auto quick
 294 auto quick
+294 auto mount

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
