Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FEB27CA6
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:46:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB1BD8F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:34 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bczgPk4ih4oGAXlv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:31 -0700 (PDT)
Subject: [PATCH 01/17] xfs/26[34]: remove duplicate tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:46:21 -0700
Message-ID: <146914478187.11762.1309628175021637188.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

These two tests were accidentally double-added as xfs/30[78], but the
newer versions have fixed up helper usage and fewer whitespace
problems, so nuke the old tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/263     |  179 -----------------------------------------------------
 tests/xfs/263.out |   13 ----
 tests/xfs/264     |  180 -----------------------------------------------------
 tests/xfs/264.out |   13 ----
 tests/xfs/group   |    2 -
 5 files changed, 387 deletions(-)
 delete mode 100755 tests/xfs/263
 delete mode 100644 tests/xfs/263.out
 delete mode 100755 tests/xfs/264
 delete mode 100644 tests/xfs/264.out


diff --git a/tests/xfs/263 b/tests/xfs/263
deleted file mode 100755
index 6659dee..0000000
--- a/tests/xfs/263
+++ /dev/null
@@ -1,179 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 263
-#
-# Test recovery of "lost" CoW blocks:
-# - Use the debugger to fake a leftover CoW extent
-# - See if xfs_repair fixes it
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -rf $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-. ./common/reflink
-
-# real QA test starts here
-_supported_os Linux
-_supported_fs xfs
-_require_scratch_reflink
-
-rm -f $seqres.full
-
-echo "Format"
-_scratch_mkfs > $seqres.full 2>&1
-_scratch_mount >> $seqres.full
-is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
-umount $SCRATCH_MNT
-
-_get_agf_data() {
-	field="$1"
-	shift
-
-	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
-}
-
-_set_agf_data() {
-	field="$1"
-	value="$2"
-	shift; shift
-
-	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
-}
-
-_get_sb_data() {
-	field="$1"
-	shift
-
-	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
-}
-
-_set_sb_data() {
-	field="$1"
-	value="$2"
-	shift; shift
-
-	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
-}
-
-_filter_leftover() {
-	grep "^leftover" | sed -e "s/[0-9]\+/NR/g"
-}
-
-_dump_status() {
-	echo "** " "$@"
-	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
-	echo "** agf header"
-	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
-	echo "** refcntbt"
-	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
-	echo "** rmapbt"
-	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
-	echo "** bnobt"
-	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
-	echo "** cntbt"
-	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
-}
-
-echo "We need AG1 to have a single free extent"
-bno_lvl=$(_get_agf_data level -c 'addr bnoroot')
-bno_nr=$(_get_agf_data numrecs -c 'addr bnoroot')
-refc_lvl=$(_get_agf_data level -c 'addr refcntroot')
-refc_nr=$(_get_agf_data numrecs -c 'addr refcntroot')
-
-test $bno_lvl -eq 0 || echo "  AG 1 bnobt must only have one level"
-test $bno_nr -eq 1 || echo "  AG 1 bnobt must only have one record"
-test $refc_lvl -eq 0 || echo "  AG 1 refcountbt must only have one level"
-test $refc_nr -eq 0 || echo "  AG 1 refcountbt must only have one record"
-
-if [ $is_rmap -gt 0 ]; then
-	rmap_lvl=$(_get_agf_data level -c 'addr rmaproot')
-	rmap_nr=$(_get_agf_data numrecs -c 'addr rmaproot')
-	test $rmap_lvl -eq 0 || echo "  AG 1 rmapbt must only have one level"
-fi
-
-echo "Find our extent and old counter values"
-bno=$(_get_agf_data "recs[1].startblock" -c 'addr bnoroot')
-len=$(_get_agf_data "recs[1].blockcount" -c 'addr bnoroot')
-agf_freeblks=$(_get_agf_data freeblks)
-sb_fdblocks=$(_get_sb_data fdblocks)
-
-test $len -ge 200 || echo "  AG 1 doesn't have enough free blocks"
-
-# Take the last 100 blocks of the free extent
-debris_len=100
-debris_bno=$((bno + len - debris_len))
-
-echo "Remove the extent from the freesp btrees"
-_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
-_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
-_set_agf_data freeblks $((agf_freeblks - debris_len))
-_set_agf_data longest $((len - debris_len))
-_set_sb_data fdblocks $((sb_fdblocks - debris_len))
-
-echo "Add the extent to the refcount btree"
-_set_agf_data numrecs 1 -c 'addr refcntroot'
-_set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
-_set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
-_set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
-
-if [ $is_rmap -gt 0 ]; then
-	rmap_nr=$((rmap_nr + 1))
-	_set_agf_data numrecs $rmap_nr -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].startblock" $debris_bno -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].blockcount" $debris_len -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].owner" -9 -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].offset" 0 -c 'addr rmaproot'
-fi
-
-_dump_status "broken fs config" >> $seqres.full
-
-echo "Look for leftover warning in xfs_check"
-_scratch_xfs_check | _filter_leftover
-
-echo "Look for leftover warning in xfs_repair"
-_scratch_xfs_repair -n 2>&1 | _filter_leftover
-
-echo "Fix filesystem"
-_scratch_xfs_repair >> $seqres.full 2>&1 || echo "xfs_repair failed?"
-
-_dump_status "supposedly fixed fs config" >> $seqres.full
-
-echo "Look for no more leftover warning in xfs_check"
-_scratch_xfs_check | _filter_leftover
-
-echo "Look for no more leftover warning in xfs_repair"
-_scratch_xfs_repair -n 2>&1 | _filter_leftover
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
deleted file mode 100644
index bc3eea9..0000000
--- a/tests/xfs/263.out
+++ /dev/null
@@ -1,13 +0,0 @@
-QA output created by 263
-Format
-We need AG1 to have a single free extent
-Find our extent and old counter values
-Remove the extent from the freesp btrees
-Add the extent to the refcount btree
-Look for leftover warning in xfs_check
-leftover CoW extent (NR/NR) len NR
-Look for leftover warning in xfs_repair
-leftover CoW extent (NR/NR) len NR
-Fix filesystem
-Look for no more leftover warning in xfs_check
-Look for no more leftover warning in xfs_repair
diff --git a/tests/xfs/264 b/tests/xfs/264
deleted file mode 100755
index 190361d..0000000
--- a/tests/xfs/264
+++ /dev/null
@@ -1,180 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 264
-#
-# Test recovery of "lost" CoW blocks:
-# - Use the debugger to fake a leftover CoW extent
-# - See if mount/umount fixes it
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -rf $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-. ./common/reflink
-
-# real QA test starts here
-_supported_os Linux
-_supported_fs xfs
-_require_scratch_reflink
-
-rm -f $seqres.full
-
-echo "Format"
-_scratch_mkfs > $seqres.full 2>&1
-_scratch_mount >> $seqres.full
-is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
-umount $SCRATCH_MNT
-
-_get_agf_data() {
-	field="$1"
-	shift
-
-	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
-}
-
-_set_agf_data() {
-	field="$1"
-	value="$2"
-	shift; shift
-
-	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
-}
-
-_get_sb_data() {
-	field="$1"
-	shift
-
-	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
-}
-
-_set_sb_data() {
-	field="$1"
-	value="$2"
-	shift; shift
-
-	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
-}
-
-_filter_leftover() {
-	grep "^leftover" | sed -e "s/[0-9]\+/NR/g"
-}
-
-_dump_status() {
-	echo "** " "$@"
-	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
-	echo "** agf header"
-	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
-	echo "** refcntbt"
-	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
-	echo "** rmapbt"
-	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
-	echo "** bnobt"
-	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
-	echo "** cntbt"
-	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
-}
-
-echo "We need AG1 to have a single free extent"
-bno_lvl=$(_get_agf_data level -c 'addr bnoroot')
-bno_nr=$(_get_agf_data numrecs -c 'addr bnoroot')
-refc_lvl=$(_get_agf_data level -c 'addr refcntroot')
-refc_nr=$(_get_agf_data numrecs -c 'addr refcntroot')
-
-test $bno_lvl -eq 0 || echo "  AG 1 bnobt must only have one level"
-test $bno_nr -eq 1 || echo "  AG 1 bnobt must only have one record"
-test $refc_lvl -eq 0 || echo "  AG 1 refcountbt must only have one level"
-test $refc_nr -eq 0 || echo "  AG 1 refcountbt must only have one record"
-
-if [ $is_rmap -gt 0 ]; then
-	rmap_lvl=$(_get_agf_data level -c 'addr rmaproot')
-	rmap_nr=$(_get_agf_data numrecs -c 'addr rmaproot')
-	test $rmap_lvl -eq 0 || echo "  AG 1 rmapbt must only have one level"
-fi
-
-echo "Find our extent and old counter values"
-bno=$(_get_agf_data "recs[1].startblock" -c 'addr bnoroot')
-len=$(_get_agf_data "recs[1].blockcount" -c 'addr bnoroot')
-agf_freeblks=$(_get_agf_data freeblks)
-sb_fdblocks=$(_get_sb_data fdblocks)
-
-test $len -ge 200 || echo "  AG 1 doesn't have enough free blocks"
-
-# Take the last 100 blocks of the free extent
-debris_len=100
-debris_bno=$((bno + len - debris_len))
-
-echo "Remove the extent from the freesp btrees"
-_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
-_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
-_set_agf_data freeblks $((agf_freeblks - debris_len))
-_set_agf_data longest $((len - debris_len))
-_set_sb_data fdblocks $((sb_fdblocks - debris_len))
-
-echo "Add the extent to the refcount btree"
-_set_agf_data numrecs 1 -c 'addr refcntroot'
-_set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
-_set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
-_set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
-
-if [ $is_rmap -gt 0 ]; then
-	rmap_nr=$((rmap_nr + 1))
-	_set_agf_data numrecs $rmap_nr -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].startblock" $debris_bno -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].blockcount" $debris_len -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].owner" -9 -c 'addr rmaproot'
-	_set_agf_data "recs[$rmap_nr].offset" 0 -c 'addr rmaproot'
-fi
-
-_dump_status "broken fs config" >> $seqres.full
-
-echo "Look for leftover warning in xfs_check"
-_scratch_xfs_check | _filter_leftover
-
-echo "Look for leftover warning in xfs_repair"
-_scratch_xfs_repair -n 2>&1 | _filter_leftover
-
-echo "Mount filesystem"
-_scratch_mount
-umount $SCRATCH_MNT
-
-_dump_status "supposedly fixed fs config" >> $seqres.full
-
-echo "Look for no more leftover warning in xfs_check"
-_scratch_xfs_check | _filter_leftover
-
-echo "Look for no more leftover warning in xfs_repair"
-_scratch_xfs_repair -n 2>&1 | _filter_leftover
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/264.out b/tests/xfs/264.out
deleted file mode 100644
index 3faaf42..0000000
--- a/tests/xfs/264.out
+++ /dev/null
@@ -1,13 +0,0 @@
-QA output created by 264
-Format
-We need AG1 to have a single free extent
-Find our extent and old counter values
-Remove the extent from the freesp btrees
-Add the extent to the refcount btree
-Look for leftover warning in xfs_check
-leftover CoW extent (NR/NR) len NR
-Look for leftover warning in xfs_repair
-leftover CoW extent (NR/NR) len NR
-Mount filesystem
-Look for no more leftover warning in xfs_check
-Look for no more leftover warning in xfs_repair
diff --git a/tests/xfs/group b/tests/xfs/group
index 9f8ca0f..aa3b3ec 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -259,8 +259,6 @@
 260 auto quick quota
 261 auto quick quota
 262 auto quick quota
-263 auto quick clone
-264 auto quick clone
 265 auto clone
 266 dump ioctl auto quick
 267 dump ioctl tape

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
