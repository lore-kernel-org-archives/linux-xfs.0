Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04HsnNH161288 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 11:54:49 -0600
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id LUZ8zUm9lTWkU0bd for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 09:54:47 -0800 (PST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] xfstests: fixup check 276
Date: Wed,  4 Jan 2012 18:54:46 +0100
Message-Id: <1325699686-21851-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: xfs@oss.sgi.com, hch@infradead.org
Cc: sandeen@sandeen.net, linux-btrfs@vger.kernel.org

This commit fixes bd8ee45c. Changes:
- added a _require_btrfs helper function
- check for filefrag with _require_command
- always use _fail in case of errors
- added some comments
- removed $fresh code
- don't set FSTYP

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 276       |  119 +++++++++++++++++++++++++++++++++++++------------------------
 common.rc |   12 ++++++
 2 files changed, 84 insertions(+), 47 deletions(-)

diff --git a/276 b/276
index f22d089..082f943 100755
--- a/276
+++ b/276
@@ -1,5 +1,29 @@
 #! /bin/bash
-
+# FSQA Test No. 276
+#
+# Run fsstress to create a reasonably strange file system, make a
+# snapshot and run more fsstress. Then select some files from that fs,
+# run filefrag to get the extent mapping and follow the backrefs.
+# We check to end up back at the original file with the correct offset.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2011 STRATO.  All rights reserved.
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
 # creator
 owner=list.btrfs@jan-o-sch.net
 
@@ -7,18 +31,13 @@ seq=`basename $0`
 echo "QA output created by $seq"
 
 here=`pwd`
-# 1=production, 0=avoid touching the scratch dev (no mount/umount, no writes)
-fresh=1
 tmp=/tmp/$$
 status=1
-FSTYP=btrfs
 
 _cleanup()
 {
-	if [ $fresh -ne 0 ]; then
-		echo "*** unmount" 
-		umount $SCRATCH_MNT 2>/dev/null
-	fi
+	echo "*** unmount"
+	umount $SCRATCH_MNT 2>/dev/null
 	rm -f $tmp.*
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -28,21 +47,14 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
+_need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
-
-if [ $fresh -ne 0 ]; then
-	_require_scratch
-fi
+_require_scratch
 
 _require_nobigloopfs
-
-[ -n "$BTRFS_UTIL_PROG" ] || _notrun "btrfs executable not found"
-$BTRFS_UTIL_PROG inspect-internal --help >/dev/null 2>&1
-[ $? -eq 0 ] || _notrun "btrfs executable too old"
-which filefrag >/dev/null 2>&1
-[ $? -eq 0 ] || _notrun "filefrag missing"
-
+_require_btrfs inspect-internal
+_require_command "/usr/sbin/filefrag"
 
 rm -f $seq.full
 
@@ -52,6 +64,10 @@ FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
 '/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
 '$length * $blocksize, "#", $logical * $blocksize, " "'
 
+# this makes filefrag output script readable by using a perl helper.
+# output is one extent per line, with three numbers separated by '#'
+# the numbers are: physical, length, logical (all in bytes)
+# sample output: "1234#10#5678" -> physical 1234, length 10, logical 5678
 _filter_extents()
 {
 	tee -a $seq.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
@@ -70,6 +86,9 @@ _check_file_extents()
 	return 0
 }
 
+# use a logical address and walk the backrefs back to the inode.
+# compare to the expected result.
+# returns 0 on success, 1 on error (with output made)
 _btrfs_inspect_addr()
 {
 	mp=$1
@@ -101,6 +120,9 @@ _btrfs_inspect_addr()
 	return 1
 }
 
+# use an inode number and walk the backrefs back to the file name.
+# compare to the expected result.
+# returns 0 on success, 1 on error (with output made)
 _btrfs_inspect_inum()
 {
 	file=$1
@@ -134,14 +156,13 @@ _btrfs_inspect_check()
 	echo "# $cmd" >> $seq.full
 	inum=`$cmd`
 	echo "$inum" >> $seq.full
-	_btrfs_inspect_addr "$SCRATCH_MNT/$snap_name" $physical $logical $inum\
-			$file
+	_btrfs_inspect_addr $SCRATCH_MNT $physical $logical $inum $file
 	ret=$?
 	if [ $ret -eq 0 ]; then
 		_btrfs_inspect_inum $file $inum $snap_name
 		ret=$?
 	fi
-	return $?
+	return $ret
 }
 
 run_check()
@@ -157,30 +178,34 @@ workout()
 	procs=$3
 	snap_name=$4
 
-	if [ $fresh -ne 0 ]; then
-		umount $SCRATCH_DEV >/dev/null 2>&1
-		echo "*** mkfs -dsize=$fsz"    >>$seq.full
-		echo ""                                     >>$seq.full
-		_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
-			|| _fail "size=$fsz mkfs failed"
-		_scratch_mount                              >>$seq.full 2>&1 \
-			|| _fail "mount failed"
-		# -w ensures that the only ops are ones which cause write I/O
-		run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
-			$FSSTRESS_AVOID
-
-		run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
-			$SCRATCH_MNT/$snap_name
-
-		run_check umount $SCRATCH_DEV >/dev/null 2>&1
-		run_check _scratch_mount "-o compress=lzo"
-
-		# -w ensures that the only ops are ones which cause write I/O
-		run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
-			$FSSTRESS_AVOID
-	else
-		echo "*** skipping mkfs part"	>>$seq.full
-	fi
+	umount $SCRATCH_DEV >/dev/null 2>&1
+	echo "*** mkfs -dsize=$fsz"    >>$seq.full
+	echo ""                                     >>$seq.full
+	_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
+		|| _fail "size=$fsz mkfs failed"
+	run_check _scratch_mount
+	# -w ensures that the only ops are ones which cause write I/O
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
+		$FSSTRESS_AVOID
+
+	run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
+		$SCRATCH_MNT/$snap_name
+
+	run_check umount $SCRATCH_DEV >/dev/null 2>&1
+	run_check _scratch_mount "-o compress=lzo"
+
+	# make some noise but ensure we're not touching existing data
+	# extents.
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 2000 \
+		-z -f chown=3 -f link=1 -f mkdir=2 -f mknod=2 \
+		-f rename=2 -f setxattr=1 -f symlink=2
+	clean_dir="$SCRATCH_MNT/next"
+	mkdir $clean_dir
+	# now make more files to get a higher tree
+	run_check $FSSTRESS_PROG -d $clean_dir -w -p $procs -n 2000 \
+		$FSSTRESS_AVOID
+	run_check umount $SCRATCH_DEV >/dev/null 2>&1
+	run_check _scratch_mount "-o atime"
 
 	cnt=0
 	errcnt=0
@@ -212,7 +237,7 @@ workout()
 		fi
 	done
 	if [ $errcnt -gt 0 ]; then
-		echo "test failed: $errcnt error(s)"
+		_fail "test failed: $errcnt error(s)"
 	fi
 }
 
diff --git a/common.rc b/common.rc
index 978ddbf..ed3613e 100644
--- a/common.rc
+++ b/common.rc
@@ -1692,6 +1692,18 @@ _require_deletable_scratch_dev_pool()
 	done
 }
 
+# We check for btrfs and (optionally) features of the btrfs command
+_require_btrfs()
+{
+	cmd=$1
+	_require_command $BTRFS_UTIL_PROG btrfs
+	if [ -z "$1" ]; then
+		return 1;
+	fi
+	$BTRFS_UTIL_PROG $cmd --help >/dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support $cmd)"
+}
+
 # arg 1 is dev to remove and is output of the below eg.
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()
-- 
1.7.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
