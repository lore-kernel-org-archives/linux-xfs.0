Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBMB92M1155180 for <xfs@oss.sgi.com>; Thu, 22 Dec 2011 05:09:02 -0600
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id fgLliWIwtAGHkFFK for <xfs@oss.sgi.com>;
	Thu, 22 Dec 2011 03:08:59 -0800 (PST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2] xfstests: new check 278 to ensure btrfs backref integrity
Date: Thu, 22 Dec 2011 12:08:58 +0100
Message-Id: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: xfs@oss.sgi.com
Cc: sandeen@sandeen.net, linux-btrfs@vger.kernel.org

This is a btrfs specific scratch test checking the backref walker. It
creates a file system with compressed and uncompressed data extents, picks
files randomly and uses filefrag to get their extents. It then asks the
btrfs utility (inspect-internal) to do the backref resolving from fs-logical
address (the one filefrag calls "physical") back to the inode number and
file-logical offset, verifying the result.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
change log ->v2:
- renamed 276->278
- added _require_btrfs helper
- check for filefrag with _require_command
- added some comments
- removed $fresh code
- don't set FSTYP
---
 278           |  255 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 278.out       |    4 +
 common.config |    1 +
 common.rc     |   12 +++
 group         |    1 +
 5 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100755 278
 create mode 100644 278.out

diff --git a/278 b/278
new file mode 100755
index 0000000..f831a0e
--- /dev/null
+++ b/278
@@ -0,0 +1,255 @@
+#! /bin/bash
+# FSQA Test No. 278
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
+# creator
+owner=list.btrfs@jan-o-sch.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1
+
+_cleanup()
+{
+	echo "*** unmount"
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_require_nobigloopfs
+_require_btrfs inspect-internal
+_require_command "/usr/sbin/filefrag"
+
+rm -f $seq.full
+
+FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
+'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
+'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
+'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
+'$length * $blocksize, "#", $logical * $blocksize, " "'
+
+# this makes filefrag output script readable by using a perl helper.
+# output is one extent per line, with three numbers separated by '#'
+# the numbers are: physical, length, logical (all in bytes)
+# sample output: "1234#10#5678" -> physical 1234, length 10, logical 5678
+_filter_extents()
+{
+	tee -a $seq.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
+}
+
+_check_file_extents()
+{
+	cmd="filefrag -vx $1"
+	echo "# $cmd" >> $seq.full
+	out=`$cmd | _filter_extents`
+	if [ -z "$out" ]; then
+		return 1
+	fi
+	echo "after filter: $out" >> $seq.full
+	echo $out
+	return 0
+}
+
+# use a logical address and walk the backrefs back to the inode.
+# compare to the expected result.
+# returns 0 on success, 1 on error (with output made)
+_btrfs_inspect_addr()
+{
+	mp=$1
+	addr=$2
+	expect_addr=$3
+	expect_inum=$4
+	file=$5
+	cmd="$BTRFS_UTIL_PROG inspect-internal logical-resolve -P $addr $mp"
+	echo "# $cmd" >> $seq.full
+	out=`$cmd`
+	echo "$out" >> $seq.full
+	grep_expr="inode $expect_inum offset $expect_addr root"
+	echo "$out" | grep "^$grep_expr 5$" >/dev/null
+	ret=$?
+	if [ $ret -eq 0 ]; then
+		# look for a root number that is not 5
+		echo "$out" | grep "^$grep_expr \([0-46-9][0-9]*\|5[0-9]\+\)$" \
+			>/dev/null
+		ret=$?
+	fi
+	if [ $ret -eq 0 ]; then
+		return 0
+	fi
+	echo "unexpected output from"
+	echo "	$cmd"
+	echo "expected inum: $expect_inum, expected address: $expect_addr,"\
+		"file: $file, got:"
+	echo "$out"
+	return 1
+}
+
+# use an inode number and walk the backrefs back to the file name.
+# compare to the expected result.
+# returns 0 on success, 1 on error (with output made)
+_btrfs_inspect_inum()
+{
+	file=$1
+	inum=$2
+	snap_name=$3
+	mp="$SCRATCH_MNT/$snap_name"
+	cmd="$BTRFS_UTIL_PROG inspect-internal inode-resolve $inum $mp"
+	echo "# $cmd" >> $seq.full
+	out=`$cmd`
+	echo "$out" >> $seq.full
+	grep_expr="^$file$"
+	cnt=`echo "$out" | grep "$grep_expr" | wc -l`
+	if [ $cnt -ge "1" ]; then
+		return 0
+	fi
+	echo "unexpected output from"
+	echo "	$cmd"
+	echo "expected path: $file, got:"
+	echo "$out"
+	return 1
+}
+
+_btrfs_inspect_check()
+{
+	file=$1
+	physical=$2
+	length=$3
+	logical=$4
+	snap_name=$5
+	cmd="stat -c %i $file"
+	echo "# $cmd" >> $seq.full
+	inum=`$cmd`
+	echo "$inum" >> $seq.full
+	_btrfs_inspect_addr $SCRATCH_MNT $physical $logical $inum $file
+	ret=$?
+	if [ $ret -eq 0 ]; then
+		_btrfs_inspect_inum $file $inum $snap_name
+		ret=$?
+	fi
+	return $ret
+}
+
+run_check()
+{
+	echo "# $@" >> $seq.full 2>&1
+	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
+}
+
+workout()
+{
+	fsz=$1
+	nfiles=$2
+	procs=$3
+	snap_name=$4
+
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
+
+	cnt=0
+	errcnt=0
+	dir="$SCRATCH_MNT/$snap_name/"
+	for file in `find $dir -name f\* -size +0 | sort -R`; do
+		extents=`_check_file_extents $file`
+		ret=$?
+		if [ $ret -ne 0 ]; then
+			continue;
+		fi
+		for i in $extents; do
+			physical=$i
+			length=$i
+			logical=$i
+			physical=`echo $physical | sed -e 's/#.*//'`
+			length=`echo $length | sed -e 's/[^#]+#//'`
+			length=`echo $length | sed -e 's/#.*//'`
+			logical=`echo $logical | sed -e 's/.*#//'`
+			_btrfs_inspect_check $file $physical $length $logical \
+						$snap_name
+			ret=$?
+			if [ $ret -ne 0 ]; then
+				errcnt=`expr $errcnt + 1`
+			fi
+		done
+		cnt=`expr $cnt + 1`
+		if [ $cnt -ge $nfiles ]; then
+			break
+		fi
+	done
+	if [ $errcnt -gt 0 ]; then
+		_fail "test failed: $errcnt error(s)"
+	fi
+}
+
+echo "*** test backref walking"
+
+snap_name="snap1"
+filesize=`expr 2000 \* 1024 \* 1024`
+nfiles=4
+numprocs=1
+
+workout $filesize $nfiles $numprocs $snap_name
+
+echo "*** done"
+status=0
+exit
diff --git a/278.out b/278.out
new file mode 100644
index 0000000..8ccbf3f
--- /dev/null
+++ b/278.out
@@ -0,0 +1,4 @@
+QA output created by 278
+*** test backref walking
+*** done
+*** unmount
diff --git a/common.config b/common.config
index 1df2bbd..7bed1c5 100644
--- a/common.config
+++ b/common.config
@@ -185,6 +185,7 @@ case "$HOSTOS" in
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
         export MKFS_BTRFS_PROG="`set_prog_path mkfs.btrfs`"
+        export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
         ;;
diff --git a/common.rc b/common.rc
index f540a79..2e60bc7 100644
--- a/common.rc
+++ b/common.rc
@@ -1656,6 +1656,18 @@ _require_deletable_scratch_dev_pool()
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
diff --git a/group b/group
index 08d999a..e548875 100644
--- a/group
+++ b/group
@@ -389,3 +389,4 @@ deprecated
 273 auto rw
 274 auto rw
 275 auto rw
+278 auto rw metadata
-- 
1.7.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
