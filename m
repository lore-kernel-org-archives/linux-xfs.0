Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C0B87F59
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 04:20:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69D6D8F804C
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 02:20:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rWRtRgLC47q7drsr for
	<xfs@oss.sgi.com>; Sun, 03 Feb 2013 02:20:32 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r13AKU8w030076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2013 05:20:32 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 3/3 V2] xfstests: 297: Test that FS sends discard requests
	only on free blocks
Date: Sun,  3 Feb 2013 11:19:58 +0100
Message-Id: <1359886798-8818-3-git-send-email-tracek@redhat.com>
In-Reply-To: <1359886798-8818-1-git-send-email-tracek@redhat.com>
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

V1->V2: Change way of testing suggested by Dave Chinner
1. Create image file with FS on it
2. Call fstrim to discard free blocks
3. Check that every punched hole in the image file is in the area
   that is marked as free

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 297     | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 297.out |   5 ++
 group   |   1 +
 3 files changed, 196 insertions(+)
 create mode 100755 297
 create mode 100644 297.out

diff --git a/297 b/297
new file mode 100755
index 0000000..7121c03
--- /dev/null
+++ b/297
@@ -0,0 +1,190 @@
+#! /bin/bash
+# FS QA Test No. 297
+#
+# Test that filesystem sends discard requests only on free blocks
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc., Tomas Racek <tracek@redhat.com>
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+. common.config
+. common.rc
+
+_supported_fs ext4 xfs
+_supported_os Linux
+_require_fstrim
+_require_fs_space $TEST_DIR 307200
+[ "$FSTYP" = "ext4" ] && _require_dumpe2fs
+
+_cleanup()
+{
+	$UMOUNT_PROG $loop_dev &> /dev/null
+	_destroy_loop_device $loop_dev
+	if [ $status -eq 0 ]; then
+		rm -rf $tmp
+		rm $img_file
+	fi
+}
+
+get_holes()
+{
+	$XFS_IO_PROG -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
+}
+
+get_free_sectors()
+{
+	case $FSTYP in
+	ext4)
+	$DUMPE2FS_PROG $img_file  2>&1 | grep " Free blocks" | cut -d ":" -f2- | \
+		tr ',' '\n' | $SED_PROG 's/^ //' | \
+		$AWK_PROG -v spb=$sectors_per_block 'BEGIN{FS="-"};
+		     NF {
+			if($2 != "") # range of blocks
+				print spb * $1, spb * ($2 + 1) - 1;
+			else		# just single block
+				print spb * $1, spb * ($1 + 1) - 1;
+		     }'
+	;;
+	xfs)
+	agsize=`xfs_info $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
+	# Convert free space (agno, block, length) to (start sector, end sector)
+	$UMOUNT_PROG $loop_mnt
+	$XFS_DB_PROG -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
+		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
+		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
+	;;
+	esac
+}
+
+merge_ranges()
+{
+	# Merges consecutive ranges from two input files
+	file1=$1
+	file2=$2
+
+	tmp_file=$tmp/sectors.tmp
+
+	cat $file1 $file2 | sort -n > $tmp_file
+
+	read line < $tmp_file
+	start=${line% *}
+	end=${line#* }
+
+	# Continue from second line
+	sed -i "1d" $tmp_file
+	while read line; do
+		curr_start=${line% *}
+		curr_end=${line#* }
+
+		if [ `expr $end + 1` -ge $curr_start ]; then
+			if [ $curr_end -gt $end ]; then
+				end=$curr_end
+			fi
+		else
+			echo $start $end
+			start=$curr_start
+			end=$curr_end
+		fi
+	done < $tmp_file
+
+	# Print last line
+	echo $start $end
+
+	rm $tmp_file
+}
+
+here=`pwd`
+tmp=`mktemp -d`
+
+img_file=$TEST_DIR/$$.fs
+dd if=/dev/zero of=$img_file bs=1M count=300 &> /dev/null
+
+loop_dev=$(_create_loop_device $img_file)
+loop_mnt=$tmp/loop_mnt
+
+fiemap_ref="$tmp/reference"
+fiemap_after="$tmp/after"
+free_sectors="$tmp/free_sectors"
+merged_sectors="$tmp/merged_free_sectors"
+
+mkdir $loop_mnt
+
+[ "$FSTYP" = "xfs" ] && MKFS_OPTIONS="-f $MKFS_OPTIONS"
+
+$MKFS_PROG -t $FSTYP $MKFS_OPTIONS $loop_dev &> /dev/null
+$MOUNT_PROG $loop_dev $loop_mnt
+
+echo -n "Generating garbage on loop..."
+for i in `seq 1 10`; do
+	mkdir $loop_mnt/$i
+	cp -r $here/* $loop_mnt/$i
+done
+
+# Get reference fiemap, this can contain i.e. uninitialized inode table
+sync
+get_holes $img_file > $fiemap_ref
+
+# Delete some files
+find $loop_mnt -type f -print | $AWK_PROG \
+	'BEGIN {srand()}; {if(rand() > 0.7) print $1;}' | xargs rm
+echo "done."
+
+echo -n "Running fstrim..."
+$FSTRIM_PROG $loop_mnt &> /dev/null
+echo "done."
+
+echo -n "Detecting interesting holes in image..."
+# Get after-trim fiemap
+sync
+get_holes $img_file > $fiemap_after
+echo "done."
+
+echo -n "Comparing holes to the reported space from FS..."
+# Get block size
+block_size=$(stat -f -c "%S" $loop_mnt/)
+sectors_per_block=`expr $block_size / 512`
+
+# Obtain free space from filesystem
+get_free_sectors > $free_sectors
+# Merge original holes with free sectors
+merge_ranges $fiemap_ref $free_sectors > $merged_sectors
+
+# Check that all holes after fstrim call were already present before or
+# that they match free space reported from FS
+while read line; do
+        from=${line% *}
+        to=${line#* }
+	if ! $AWK_PROG -v s=$from -v e=$to \
+		'{ if ($1 <= s && e <= $2) found = 1};
+		END { if(found) exit 0; else exit 1}' $merged_sectors
+	then
+		echo "Sectors $from-$to are not marked as free!"
+		exit
+	fi
+done < $fiemap_after
+echo "done."
+
+status=0
+exit
diff --git a/297.out b/297.out
new file mode 100644
index 0000000..71d720a
--- /dev/null
+++ b/297.out
@@ -0,0 +1,5 @@
+QA output created by 297
+Generating garbage on loop...done.
+Running fstrim...done.
+Detecting interesting holes in image...done.
+Comparing holes to the reported space from FS...done.
diff --git a/group b/group
index eb4f375..64f322c 100644
--- a/group
+++ b/group
@@ -415,3 +415,4 @@ deprecated
 294 auto quick
 295 auto logprint quick
 296 dump auto quick
+297 auto trim
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
