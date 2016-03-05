Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D09637CB1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:37:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F09D8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:37:46 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Fz91cJlZtvNr9hju (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:37:43 -0800 (PST)
Subject: [PATCH 02/12] xfs: test copy-on-write leftover recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:30 -0800
Message-ID: <20160305003730.28738.33436.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Test recovery of CoW leftovers in xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/853     |  179 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/853.out |   13 ++++
 tests/xfs/854     |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/854.out |   13 ++++
 tests/xfs/group   |    2 +
 5 files changed, 387 insertions(+)
 create mode 100755 tests/xfs/853
 create mode 100644 tests/xfs/853.out
 create mode 100755 tests/xfs/854
 create mode 100644 tests/xfs/854.out


diff --git a/tests/xfs/853 b/tests/xfs/853
new file mode 100755
index 0000000..14a6940
--- /dev/null
+++ b/tests/xfs/853
@@ -0,0 +1,179 @@
+#! /bin/bash
+# FS QA Test No. 853
+#
+# Test recovery of "lost" CoW blocks:
+# - Use the debugger to fake a leftover CoW extent
+# - See if xfs_repair fixes it
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+
+rm -f $seqres.full
+
+echo "Format"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+umount $SCRATCH_MNT
+
+_get_agf_data() {
+	field="$1"
+	shift
+
+	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+}
+
+_set_agf_data() {
+	field="$1"
+	value="$2"
+	shift; shift
+
+	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+}
+
+_get_sb_data() {
+	field="$1"
+	shift
+
+	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+}
+
+_set_sb_data() {
+	field="$1"
+	value="$2"
+	shift; shift
+
+	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+}
+
+_filter_leftover() {
+	grep "^leftover" | sed -e "s/[0-9]\+/NR/g"
+}
+
+_dump_status() {
+	echo "** " "$@"
+	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
+	echo "** agf header"
+	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
+	echo "** refcntbt"
+	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
+	echo "** rmapbt"
+	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
+	echo "** bnobt"
+	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
+	echo "** cntbt"
+	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
+}
+
+echo "We need AG1 to have a single free extent"
+bno_lvl=$(_get_agf_data level -c 'addr bnoroot')
+bno_nr=$(_get_agf_data numrecs -c 'addr bnoroot')
+refc_lvl=$(_get_agf_data level -c 'addr refcntroot')
+refc_nr=$(_get_agf_data numrecs -c 'addr refcntroot')
+
+test $bno_lvl -eq 0 || echo "  AG 1 bnobt must only have one level"
+test $bno_nr -eq 1 || echo "  AG 1 bnobt must only have one record"
+test $refc_lvl -eq 0 || echo "  AG 1 refcountbt must only have one level"
+test $refc_nr -eq 0 || echo "  AG 1 refcountbt must only have one record"
+
+if [ $is_rmap -gt 0 ]; then
+	rmap_lvl=$(_get_agf_data level -c 'addr rmaproot')
+	rmap_nr=$(_get_agf_data numrecs -c 'addr rmaproot')
+	test $rmap_lvl -eq 0 || echo "  AG 1 rmapbt must only have one level"
+fi
+
+echo "Find our extent and old counter values"
+bno=$(_get_agf_data "recs[1].startblock" -c 'addr bnoroot')
+len=$(_get_agf_data "recs[1].blockcount" -c 'addr bnoroot')
+agf_freeblks=$(_get_agf_data freeblks)
+sb_fdblocks=$(_get_sb_data fdblocks)
+
+test $len -ge 200 || echo "  AG 1 doesn't have enough free blocks"
+
+# Take the last 100 blocks of the free extent
+debris_len=100
+debris_bno=$((bno + len - debris_len))
+
+echo "Remove the extent from the freesp btrees"
+_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
+_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
+_set_agf_data freeblks $((agf_freeblks - debris_len))
+_set_agf_data longest $((len - debris_len))
+_set_sb_data fdblocks $((sb_fdblocks - debris_len))
+
+echo "Add the extent to the refcount btree"
+_set_agf_data numrecs 1 -c 'addr refcntroot'
+_set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
+_set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
+_set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
+
+if [ $is_rmap -gt 0 ]; then
+	rmap_nr=$((rmap_nr + 1))
+	_set_agf_data numrecs $rmap_nr -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].startblock" $debris_bno -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].blockcount" $debris_len -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].owner" -9 -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].offset" 0 -c 'addr rmaproot'
+fi
+
+_dump_status "broken fs config" >> $seqres.full
+
+echo "Look for leftover warning in xfs_check"
+_scratch_xfs_check | _filter_leftover
+
+echo "Look for leftover warning in xfs_repair"
+_scratch_xfs_repair -n 2>&1 | _filter_leftover
+
+echo "Fix filesystem"
+_scratch_xfs_repair >> $seqres.full 2>&1 || echo "xfs_repair failed?"
+
+_dump_status "supposedly fixed fs config" >> $seqres.full
+
+echo "Look for no more leftover warning in xfs_check"
+_scratch_xfs_check | _filter_leftover
+
+echo "Look for no more leftover warning in xfs_repair"
+_scratch_xfs_repair -n 2>&1 | _filter_leftover
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/853.out b/tests/xfs/853.out
new file mode 100644
index 0000000..3224e8d
--- /dev/null
+++ b/tests/xfs/853.out
@@ -0,0 +1,13 @@
+QA output created by 853
+Format
+We need AG1 to have a single free extent
+Find our extent and old counter values
+Remove the extent from the freesp btrees
+Add the extent to the refcount btree
+Look for leftover warning in xfs_check
+leftover CoW extent (NR/NR) len NR
+Look for leftover warning in xfs_repair
+leftover CoW extent (NR/NR) len NR
+Fix filesystem
+Look for no more leftover warning in xfs_check
+Look for no more leftover warning in xfs_repair
diff --git a/tests/xfs/854 b/tests/xfs/854
new file mode 100755
index 0000000..5c6bec9
--- /dev/null
+++ b/tests/xfs/854
@@ -0,0 +1,180 @@
+#! /bin/bash
+# FS QA Test No. 854
+#
+# Test recovery of "lost" CoW blocks:
+# - Use the debugger to fake a leftover CoW extent
+# - See if mount/umount fixes it
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+
+rm -f $seqres.full
+
+echo "Format"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+umount $SCRATCH_MNT
+
+_get_agf_data() {
+	field="$1"
+	shift
+
+	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+}
+
+_set_agf_data() {
+	field="$1"
+	value="$2"
+	shift; shift
+
+	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+}
+
+_get_sb_data() {
+	field="$1"
+	shift
+
+	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+}
+
+_set_sb_data() {
+	field="$1"
+	value="$2"
+	shift; shift
+
+	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+}
+
+_filter_leftover() {
+	grep "^leftover" | sed -e "s/[0-9]\+/NR/g"
+}
+
+_dump_status() {
+	echo "** " "$@"
+	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
+	echo "** agf header"
+	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
+	echo "** refcntbt"
+	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
+	echo "** rmapbt"
+	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
+	echo "** bnobt"
+	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
+	echo "** cntbt"
+	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
+}
+
+echo "We need AG1 to have a single free extent"
+bno_lvl=$(_get_agf_data level -c 'addr bnoroot')
+bno_nr=$(_get_agf_data numrecs -c 'addr bnoroot')
+refc_lvl=$(_get_agf_data level -c 'addr refcntroot')
+refc_nr=$(_get_agf_data numrecs -c 'addr refcntroot')
+
+test $bno_lvl -eq 0 || echo "  AG 1 bnobt must only have one level"
+test $bno_nr -eq 1 || echo "  AG 1 bnobt must only have one record"
+test $refc_lvl -eq 0 || echo "  AG 1 refcountbt must only have one level"
+test $refc_nr -eq 0 || echo "  AG 1 refcountbt must only have one record"
+
+if [ $is_rmap -gt 0 ]; then
+	rmap_lvl=$(_get_agf_data level -c 'addr rmaproot')
+	rmap_nr=$(_get_agf_data numrecs -c 'addr rmaproot')
+	test $rmap_lvl -eq 0 || echo "  AG 1 rmapbt must only have one level"
+fi
+
+echo "Find our extent and old counter values"
+bno=$(_get_agf_data "recs[1].startblock" -c 'addr bnoroot')
+len=$(_get_agf_data "recs[1].blockcount" -c 'addr bnoroot')
+agf_freeblks=$(_get_agf_data freeblks)
+sb_fdblocks=$(_get_sb_data fdblocks)
+
+test $len -ge 200 || echo "  AG 1 doesn't have enough free blocks"
+
+# Take the last 100 blocks of the free extent
+debris_len=100
+debris_bno=$((bno + len - debris_len))
+
+echo "Remove the extent from the freesp btrees"
+_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
+_set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
+_set_agf_data freeblks $((agf_freeblks - debris_len))
+_set_agf_data longest $((len - debris_len))
+_set_sb_data fdblocks $((sb_fdblocks - debris_len))
+
+echo "Add the extent to the refcount btree"
+_set_agf_data numrecs 1 -c 'addr refcntroot'
+_set_agf_data "recs[1].startblock" $debris_bno -c 'addr refcntroot'
+_set_agf_data "recs[1].blockcount" $debris_len -c 'addr refcntroot'
+_set_agf_data "recs[1].refcount" 1 -c 'addr refcntroot'
+
+if [ $is_rmap -gt 0 ]; then
+	rmap_nr=$((rmap_nr + 1))
+	_set_agf_data numrecs $rmap_nr -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].startblock" $debris_bno -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].blockcount" $debris_len -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].owner" -9 -c 'addr rmaproot'
+	_set_agf_data "recs[$rmap_nr].offset" 0 -c 'addr rmaproot'
+fi
+
+_dump_status "broken fs config" >> $seqres.full
+
+echo "Look for leftover warning in xfs_check"
+_scratch_xfs_check | _filter_leftover
+
+echo "Look for leftover warning in xfs_repair"
+_scratch_xfs_repair -n 2>&1 | _filter_leftover
+
+echo "Mount filesystem"
+_scratch_mount
+umount $SCRATCH_MNT
+
+_dump_status "supposedly fixed fs config" >> $seqres.full
+
+echo "Look for no more leftover warning in xfs_check"
+_scratch_xfs_check | _filter_leftover
+
+echo "Look for no more leftover warning in xfs_repair"
+_scratch_xfs_repair -n 2>&1 | _filter_leftover
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/854.out b/tests/xfs/854.out
new file mode 100644
index 0000000..aae2fd7
--- /dev/null
+++ b/tests/xfs/854.out
@@ -0,0 +1,13 @@
+QA output created by 854
+Format
+We need AG1 to have a single free extent
+Find our extent and old counter values
+Remove the extent from the freesp btrees
+Add the extent to the refcount btree
+Look for leftover warning in xfs_check
+leftover CoW extent (NR/NR) len NR
+Look for leftover warning in xfs_repair
+leftover CoW extent (NR/NR) len NR
+Mount filesystem
+Look for no more leftover warning in xfs_check
+Look for no more leftover warning in xfs_repair
diff --git a/tests/xfs/group b/tests/xfs/group
index e0c4553..50353f1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -284,3 +284,5 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+853 auto quick clone
+854 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
