Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q195fs1o138931 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 23:41:55 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id ZlndIgF84mgfT0I1 for
	<xfs@oss.sgi.com>; Wed, 08 Feb 2012 21:41:51 -0800 (PST)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/3 v2] xfstests: add btrfs online defragments QA test
Date: Thu, 9 Feb 2012 13:40:34 +0800
Message-Id: <1328766034-1324-1-git-send-email-liubo2009@cn.fujitsu.com>
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
Cc: hch@infradead.org, linux-btrfs@vger.kernel.org

As the title shows, we port btrfs online defragments QA test into xfstests.

v1->v2:
- place the real tests inside testcases.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 278      |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 278.args |   18 +++++
 278.out  |   75 +++++++++++++++++++
 group    |    1 +
 4 files changed, 341 insertions(+), 0 deletions(-)
 create mode 100755 278
 create mode 100644 278.args
 create mode 100644 278.out

diff --git a/278 b/278
new file mode 100755
index 0000000..71f12e0
--- /dev/null
+++ b/278
@@ -0,0 +1,247 @@
+#! /bin/bash
+# FS QA Test No. 278
+#
+# Btrfs Online defragmentation tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Fujitsu Liu Bo.  All Rights Reserved.
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
+owner=liubo2009@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+test_path="`pwd`"
+progs_dir="$test_path/src/btrfs_online_defragment/"
+tmp=tmp/$$
+defrag_args="$test_path/${seq}.args"
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+_create_file()
+{
+	CNT=11999
+	FILESIZE=48000
+	if [ "$DEFRAG_TARGET" = "1" ];then
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$SCRATCH_MNT/tmp_file bs=4k count=1 \
+			 conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $SCRATCH_MNT/tmp_file > /tmp/checksum
+	elif [ "$DEFRAG_TARGET" = "2" ];then
+		mkdir $SCRATCH_MNT/tmp_dir
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$SCRATCH_MNT/tmp_dir/tmp_file bs=4k \
+			count=1 conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $SCRATCH_MNT/tmp_dir/tmp_file > /tmp/checksum
+	elif [ "$DEFRAG_TARGET" = "3" ];then
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$SCRATCH_MNT/tmp_file bs=4k count=1 \
+			conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $SCRATCH_MNT/tmp_file > /tmp/checksum
+	fi
+}
+
+_btrfs_online_defrag()
+{
+	str=""
+	if [ "$FILE_RANGE" = "2" ];then
+		str="$str -s -1 -l $((FILESIZE / 2)) "
+	elif [ "$FILE_RANGE" = "3" ];then
+		str="$str -s $((FILESIZE + 1)) -l $((FILESIZE / 2)) "
+		HAVE_DEFRAG=1
+	elif [ "$FILE_RANGE" = "4" ];then
+		str="$str -l -1 "
+	elif [ "$FILE_RANGE" = "5" ];then
+		str="$str -l $((FILESIZE + 1)) "
+	elif [ "$FILE_RANGE" = "6" ];then
+		str="$str -l $((FILESIZE / 2)) "
+	fi
+
+	if [ "$DEFRAG_COMPRESS" = "2" ];then
+		str="$str -c "
+	fi
+
+	if [ "$FLUSH" = "2" ];then
+		str="$str -f "
+	fi
+
+	if [ "$THRESH" = "2" ];then
+		str="$str -t -1 "
+	elif [ "$THRESH" = "3" ];then
+		str="$str -t $PAGESIZE "
+	fi
+
+	if [ "$str" != "" ]; then
+		btrfs filesystem defragment $str $SCRATCH_MNT/tmp_file
+	else
+		if [ "$DEFRAG_TARGET" = "1" ];then
+			btrfs filesystem defragment $SCRATCH_MNT/tmp_file
+		elif [ "$DEFRAG_TARGET" = "2" ];then
+			btrfs filesystem defragment $SCRATCH_MNT/tmp_dir
+		elif [ "$DEFRAG_TARGET" = "3" ];then
+			btrfs filesystem defragment $SCRATCH_MNT
+		fi
+	fi
+	ret_val=$?
+	sync
+	if [ $ret_val -ne 20 ];then
+		echo "btrfs filesystem defragment failed! err is $ret_val"
+	fi
+}
+
+_checksum()
+{
+	md5sum -c /tmp/checksum > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		echo "md5 checksum failed!"
+	fi
+}
+
+_fsck()
+{
+	btrfsck $SCRATCH_DEV > /dev/null 2>&1
+	ret_val=$?
+	if [ $ret_val -ne 0 ]; then
+		echo "btrfsck _FAIL_! err is $ret_val"
+	fi
+}
+
+_parse_options()
+{
+	PASS=0
+	if [ "`echo $args | grep "#"`" != "" ];then
+		PASS=1
+	fi
+
+	if [ $PASS -ne 1 ];then
+	DEFRAG_TARGET=`echo $args | awk -F ' ' '{ print $1 }'`
+	case $DEFRAG_TARGET in
+		"1")
+			echo "a single file"
+			;;
+		"2")
+			echo "a directory"
+			;;
+		"3")
+			echo "a filesystem"
+			;;
+	esac
+
+	FILE_RANGE=`echo $args | awk -F ' ' '{ print $2 }'`
+	case $FILE_RANGE in
+		"1")
+			echo "online defragment range: default"
+			;;
+		"2")
+			echo "online defragment range: start < 0 && 0 < len < file size"
+			;;
+		"3")
+			echo "online defragment range: start > file size && 0 < len < file size"
+			;;
+		"4")
+			echo "online defragment range: start = 0 && len < 0"
+			;;
+		"5")
+			echo "online defragment range: start = 0 && len > file size"
+			;;
+		"6")
+			echo "online defragment range: start = 0 && 0 < len < file size"
+			;;
+	esac
+
+	DEFRAG_COMPRESS=`echo $args | awk -F ' ' '{ print $3 }'`
+	case $DEFRAG_COMPRESS in
+		"1")
+			echo "online defragment compress: off"
+			;;
+		"2")
+			echo "online defragment compress: on"
+	esac
+	fi
+}
+
+_cleanup_defrag()
+{
+	rm -fr $SCRATCH_MNT/*
+	umount $SCRATCH_MNT > /dev/null 2>&1
+}
+
+_setup_defrag()
+{
+	umount $SCRATCH_MNT > /dev/null 2>&1
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	_create_file
+}
+
+_rundefrag()
+{
+	args=$1
+
+	echo "btrfs online defragment test start"
+	while read args
+	do
+		echo "$args"
+		_parse_options
+		_setup_defrag
+		_btrfs_online_defrag
+		_checksum
+		_cleanup_defrag
+		_fsck
+	done < $args
+	echo "btrfs online defragment test done"
+}
+
+_runtest()
+{
+	_rundefrag $defrag_args
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_setup_testdir
+## We require scratch so that we'll have free contiguous space
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_require_defrag
+
+_runtest
+
+status=0
+exit
diff --git a/278.args b/278.args
new file mode 100644
index 0000000..9c22dc9
--- /dev/null
+++ b/278.args
@@ -0,0 +1,18 @@
+1	1	1	1	1
+1	1	1	1	2
+1	1	1	1	3
+1	1	1	2	1
+1	1	2	-	-
+1	6	1	1	1
+1	1	1	1	1
+1	1	1	1	2
+1	1	1	1	3
+1	1	1	2	1
+1	1	2	-	-
+1	2	1	1	1
+1	3	1	1	1
+1	4	1	1	1
+1	5	1	1	1
+1	6	1	1	1
+2	1	1	1	1
+3	1	1	1	1
diff --git a/278.out b/278.out
new file mode 100644
index 0000000..2fc167d
--- /dev/null
+++ b/278.out
@@ -0,0 +1,75 @@
+QA output created by 278
+btrfs online defragment test start
+1	1	1	1	1
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	1	2
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	1	3
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	2	1
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	2	-	-
+a single file
+online defragment range: default
+online defragment compress: on
+1	6	1	1	1
+a single file
+online defragment range: start = 0 && 0 < len < file size
+online defragment compress: off
+1	1	1	1	1
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	1	2
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	1	3
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	1	2	1
+a single file
+online defragment range: default
+online defragment compress: off
+1	1	2	-	-
+a single file
+online defragment range: default
+online defragment compress: on
+1	2	1	1	1
+a single file
+online defragment range: start < 0 && 0 < len < file size
+online defragment compress: off
+1	3	1	1	1
+a single file
+online defragment range: start > file size && 0 < len < file size
+online defragment compress: off
+1	4	1	1	1
+a single file
+online defragment range: start = 0 && len < 0
+online defragment compress: off
+1	5	1	1	1
+a single file
+online defragment range: start = 0 && len > file size
+online defragment compress: off
+1	6	1	1	1
+a single file
+online defragment range: start = 0 && 0 < len < file size
+online defragment compress: off
+2	1	1	1	1
+a directory
+online defragment range: default
+online defragment compress: off
+3	1	1	1	1
+a filesystem
+online defragment range: default
+online defragment compress: off
+btrfs online defragment test done
diff --git a/group b/group
index 99592d3..9dedd25 100644
--- a/group
+++ b/group
@@ -391,3 +391,4 @@ deprecated
 275 auto rw
 276 auto rw metadata
 277 auto ioctl quick metadata
+278 auto
-- 
1.6.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
