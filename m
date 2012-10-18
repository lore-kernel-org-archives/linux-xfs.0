Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I8iLqL168700 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 03:44:21 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6cVEdOOKaaoHpdKm for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 01:45:59 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9I8jxtO016613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 04:45:59 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 3/3] 289: Test that filesystem sends discard requests only on
	free sectors
Date: Thu, 18 Oct 2012 10:45:46 +0200
Message-Id: <1350549946-17192-3-git-send-email-tracek@redhat.com>
In-Reply-To: <1350549946-17192-1-git-send-email-tracek@redhat.com>
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

This is done by comparing free sectors reported by some FS utility
(dumpe2fs/xfs_db) and actual discard commands sent to device obtained
via blk tracer in debugfs.

Currently supported FS are ext[34], xfs; device with discard support is
not required, the test creates loop device for this purpose.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 289     | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 289.out |   5 ++
 group   |   1 +
 3 files changed, 175 insertions(+)
 create mode 100755 289
 create mode 100644 289.out

diff --git a/289 b/289
new file mode 100755
index 0000000..b6bffc1
--- /dev/null
+++ b/289
@@ -0,0 +1,169 @@
+#! /bin/bash
+# FS QA Test No. 289
+#
+# Test that filesystem sends discard requests only on free blocks
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc., Tomas Racek <tracek@redhat.com>
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
+# creator
+owner=tracek@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	$UMOUNT_PROG $loop_mnt
+	rm -rf $tmp
+	_destroy_loop_device $loop_dev
+	rm $img_file
+}
+
+mkfs_loop()
+{
+	if [ $FSTYP = "xfs" ]; then
+		MKFS_OPTIONS="-f $MKFS_OPTIONS"
+	fi
+
+	$MKFS_PROG -t $FSTYP $MKFS_OPTIONS $loop_dev &> /dev/null
+}
+
+get_block_size()
+{
+	case $FSTYP in
+	ext[34])
+		bsize=$($DUMPE2FS_PROG $loop_dev 2>&1 | sed -n '/^Block size/ s/.*: *\(.*\)/\1/p')
+	;;
+	xfs)
+		$UMOUNT_PROG $loop_mnt
+		bsize=$($XFS_DB_PROG -c "sb" -c"p" $loop_dev | sed -n 's/^blocksize = \([0-9]\+\).*/\1/p')
+		$MOUNT_PROG $loop_dev $loop_mnt
+	;;
+	esac
+}
+
+get_free_sectors()
+{
+	case $FSTYP in
+	ext[34])
+		size=1
+		clstsize=$($DUMPE2FS_PROG $loop_dev 2>/dev/null | sed '/Cluster size/!d; s/.*: *//')
+		if [ -n "$clstsize" ]; then
+			size=$((clstsize/bsize))
+		fi
+		$DUMPE2FS_PROG $loop_dev 2>/dev/null | sed '/  Free blocks/!d; s/.*: //; s/, /\n/g; /^$/d' | \
+			$AWK_PROG -v spb=$spb -v size=$size 'BEGIN{FS="-"}; {printf "%d-%d\n", spb * $1, (spb * $2 == 0)? spb * ($1 + size) - 1 : spb * ($2 + size) - 1}' > $free_sectors
+	;;
+	xfs)
+		$UMOUNT_PROG $loop_mnt
+		agblocks=$($XFS_DB_PROG -c"sb" -c "p" $loop_dev | sed -n 's/agblocks = \(.*\)$/\1/p')
+		$XFS_DB_PROG -c"freesp -d" $loop_dev | $AWK_PROG '{if($1 == "from") exit; else print}' | \
+			$AWK_PROG -v agb=$agblocks -v spb=$spb '{print spb * ($1 * agb + $2) "-" spb * ($1 * agb + $2 + $3) - 1}' | sort -n > $free_sectors
+		$MOUNT_PROG $loop_dev $loop_mnt
+	;;
+	esac
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.config
+
+# real QA test starts here
+
+_supported_fs ext3 ext4 xfs
+_supported_os Linux
+_require_fstrim
+_require_dumpe2fs
+_require_fs_space $TEST_DIR 3145728
+
+debugfs=$($MOUNT_PROG | grep debugfs | cut -d " " -f3)
+[ -n $debugfs ] || _notrun "This test requires mounted debugfs"
+
+cat $debugfs/tracing/available_tracers | grep -q blk || _notrun "blk tracer is not available"
+
+img_file=$TEST_DIR/$$.fs
+$XFS_IO_PROG -f -c "truncate 3G" $img_file
+
+loop_dev=$(_create_loop_device $img_file)
+loop_base=$(basename $loop_dev)
+loop_mnt=$tmp/loop_mnt
+
+mkdir $loop_mnt
+
+mkfs_loop
+$MOUNT_PROG $loop_dev $loop_mnt
+
+echo -n "Generating garbage on loop..."
+for i in `seq 1 30`; do
+
+	mkdir $loop_mnt/$i
+	cp -r $here/* $loop_mnt/$i
+done
+find $loop_mnt -type f -print | $AWK_PROG 'BEGIN {srand()}; {if(rand() > 0.7) print $1;}' | xargs rm
+echo "done."
+
+ssize=`cat /sys/block/$loop_base/queue/hw_sector_size`
+get_block_size
+spb=$((bsize/ssize))
+
+free_sectors=$tmp/sectors
+trace=$tmp/trace
+
+echo -n "Obtaining free sectors from FS..."
+get_free_sectors
+echo "done."
+
+echo -n "Running fstrim & trace..."
+echo 1 > /sys/block/$loop_base/trace/enable
+echo blk > $debugfs/tracing/current_tracer
+echo > $debugfs/tracing/trace
+echo 1 > $debugfs/tracing/tracing_on
+
+$FSTRIM_PROG $loop_mnt > /dev/null
+
+cat $debugfs/tracing/trace | grep "\[fstrim\]"  | cut -d ":" -f2- |
+$AWK_PROG '$3 == "D"' |  		   # Filter discard operation
+$AWK_PROG '{print $4 "-" $4 + $6 - 1}' | # Transform (start, length) => (start, end)
+sort -n > $trace
+
+echo 0 > $debugfs/tracing/tracing_on
+echo 0 > /sys/block/$loop_base/trace/enable
+echo "done."
+
+echo -n "Comparing trace to free sectors..."
+while read line
+do
+	start=${line%-*}
+	end=${line#*-}
+	# Check if sectors obtained from trace can be matched with free sectors
+	if ! $AWK_PROG -v s=$start -v e=$end 'BEGIN {FS="-"}; {if ($1 <= s && e <= $2) found = 1}; END{if (found) exit 0; else exit 1}' $free_sectors
+	then
+		echo "Sectors $line are not marked as free by FS!"
+		exit
+	fi
+done <$trace
+echo "done."
+
+# success, all done
+status=0
+exit
diff --git a/289.out b/289.out
new file mode 100644
index 0000000..90465a6
--- /dev/null
+++ b/289.out
@@ -0,0 +1,5 @@
+QA output created by 289
+Generating garbage on loop...done.
+Obtaining free sectors from FS...done.
+Running fstrim & trace...done.
+Comparing trace to free sectors...done.
diff --git a/group b/group
index f52c5d5..ead4911 100644
--- a/group
+++ b/group
@@ -406,3 +406,4 @@ deprecated
 285 auto rw
 286 other
 287 auto dump quota quick
+289 auto trim
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
