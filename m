Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q168Su2N114492 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 02:28:56 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 0oh9XQL9EnzaEEkc for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 00:28:48 -0800 (PST)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/3] xfstests: add btrfs online defragments QA test
Date: Mon, 6 Feb 2012 16:27:49 +0800
Message-Id: <1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
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
To: linux-btrfs@vger.kernel.org
Cc: hch@infradead.org, xfs@oss.sgi.com

As the title shows, we port btrfs online defragments QA test into xfstests.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 278                                    |   66 +++++++
 278.out                                |  125 ++++++++++++++
 group                                  |    1 +
 src/Makefile                           |    2 +-
 src/btrfs_online_defragment/Makefile   |   17 ++
 src/btrfs_online_defragment/args.in    |   18 ++
 src/btrfs_online_defragment/runtest.sh |  291 ++++++++++++++++++++++++++++++++
 7 files changed, 519 insertions(+), 1 deletions(-)
 create mode 100755 278
 create mode 100644 278.out
 create mode 100644 src/btrfs_online_defragment/Makefile
 create mode 100644 src/btrfs_online_defragment/args.in
 create mode 100755 src/btrfs_online_defragment/runtest.sh

diff --git a/278 b/278
new file mode 100755
index 0000000..be501cd
--- /dev/null
+++ b/278
@@ -0,0 +1,66 @@
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
+progs_dir="`pwd`/src/btrfs_online_defragment/"
+tmp=tmp/$$
+defrag_args="$progs_dir/args.in"
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
+_runtest()
+{
+	$progs_dir/runtest.sh $defrag_args $SCRATCH_MNT $SCRATCH_DEV
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.defrag
+
+# real QA test starts here
+_supported_fs xfs btrfs
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
diff --git a/278.out b/278.out
new file mode 100644
index 0000000..f679df2
--- /dev/null
+++ b/278.out
@@ -0,0 +1,125 @@
+QA output created by 278
+btrfs online defragment test start
+***1	1	1	1	1***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	1	1	1	1***END***
+***1	1	1	1	2***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: -1
+***1	1	1	1	2***END***
+***1	1	1	1	3***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: PAGESIZE
+***1	1	1	1	3***END***
+***1	1	1	2	1***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: on
+online defragment thresh: default(256K)
+***1	1	1	2	1***END***
+***1	1	2	-	-***START***
+a single file
+online defragment range: default
+online defragment compress: on
+***1	1	2	-	-***END***
+***1	6	1	1	1***START***
+a single file
+online defragment range: start = 0 && 0 < len < file size
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	6	1	1	1***END***
+***1	1	1	1	1***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	1	1	1	1***END***
+***1	1	1	1	2***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: -1
+***1	1	1	1	2***END***
+***1	1	1	1	3***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: PAGESIZE
+***1	1	1	1	3***END***
+***1	1	1	2	1***START***
+a single file
+online defragment range: default
+online defragment compress: off
+online defragment flush: on
+online defragment thresh: default(256K)
+***1	1	1	2	1***END***
+***1	1	2	-	-***START***
+a single file
+online defragment range: default
+online defragment compress: on
+***1	1	2	-	-***END***
+***1	2	1	1	1***START***
+a single file
+online defragment range: start < 0 && 0 < len < file size
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	2	1	1	1***END***
+***1	3	1	1	1***START***
+a single file
+online defragment range: start > file size && 0 < len < file size
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	3	1	1	1***END***
+***1	4	1	1	1***START***
+a single file
+online defragment range: start = 0 && len < 0
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	4	1	1	1***END***
+***1	5	1	1	1***START***
+a single file
+online defragment range: start = 0 && len > file size
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	5	1	1	1***END***
+***1	6	1	1	1***START***
+a single file
+online defragment range: start = 0 && 0 < len < file size
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***1	6	1	1	1***END***
+***2	1	1	1	1***START***
+a directory
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***2	1	1	1	1***END***
+***3	1	1	1	1***START***
+a filesystem
+online defragment range: default
+online defragment compress: off
+online defragment flush: off
+online defragment thresh: default(256K)
+***3	1	1	1	1***END***
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
diff --git a/src/Makefile b/src/Makefile
index 67250ee..cba2f58 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2
 
-SUBDIRS =
+SUBDIRS = btrfs_online_defragment
 
 LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
 
diff --git a/src/btrfs_online_defragment/Makefile b/src/btrfs_online_defragment/Makefile
new file mode 100644
index 0000000..e05700e
--- /dev/null
+++ b/src/btrfs_online_defragment/Makefile
@@ -0,0 +1,17 @@
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+SCRIPTS = runtest.sh
+
+default: depend $(SCRIPTS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src/btrfs_online_defragment
+	$(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/src/btrfs_online_defragment
+
+-include .dep
diff --git a/src/btrfs_online_defragment/args.in b/src/btrfs_online_defragment/args.in
new file mode 100644
index 0000000..9c22dc9
--- /dev/null
+++ b/src/btrfs_online_defragment/args.in
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
diff --git a/src/btrfs_online_defragment/runtest.sh b/src/btrfs_online_defragment/runtest.sh
new file mode 100755
index 0000000..7c4e07f
--- /dev/null
+++ b/src/btrfs_online_defragment/runtest.sh
@@ -0,0 +1,291 @@
+#!/bin/sh
+################################################################################
+#                                                                              #
+# Copyright (c) 2010 FUJITSU LIMITED                                           #
+#                                                                              #
+# This program is free software;  you can redistribute it and#or modify        #
+# it under the terms of the GNU General Public License as published by         #
+# the Free Software Foundation; either version 2 of the License, or            #
+# (at your option) any later version.                                          #
+#                                                                              #
+# This program is distributed in the hope that it will be useful, but          #
+# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY   #
+# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License     #
+# for more details.                                                            #
+#                                                                              #
+# You should have received a copy of the GNU General Public License            #
+# along with this program;  if not, write to the Free Software                 #
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA      #
+#                                                                              #
+#                                                                              #
+# Author:       Liu Bo     <liubo2009@cn.fujitsu.com>                          #
+#                                                                              #
+#                                                                              #
+################################################################################
+
+#****************************************************************************
+#  DEV: mount device							    #
+#  MNT: mount point							    #
+# ARGS: test case argument set						    #
+#****************************************************************************
+
+TPATH="`pwd`/src/btrfs_online_defragment"
+PAGESIZE=4096
+FILESIZE=0
+
+Mkbtrfs()
+{
+#******************************
+# mkfs.btrfs
+#******************************
+	umount $MNT &>/dev/null
+	umount $DEV &>/dev/null
+
+	mkfs.btrfs $DEV &> /dev/null
+
+	if [ $? -ne 0 ];then
+		echo "***this case FAIL on mkfs.btrfs***"
+		continue
+	fi
+}
+
+Mountfs()
+{
+	mount $DEV $MNT
+}
+
+Createfile()
+{
+	CNT=11999
+	FILESIZE=48000
+	if [ "$DEFRAG_TARGET" = "1" ];then
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$MNT/tmp_file bs=4k count=1 conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $MNT/tmp_file > /tmp/checksum
+	elif [ "$DEFRAG_TARGET" = "2" ];then
+		mkdir $MNT/tmp_dir
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$MNT/tmp_dir/tmp_file bs=4k count=1 conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $MNT/tmp_dir/tmp_file > /tmp/checksum
+	elif [ "$DEFRAG_TARGET" = "3" ];then
+		for i in `seq $CNT -1 0`; do
+			dd if=/dev/zero of=$MNT/tmp_file bs=4k count=1 conv=notrunc seek=$i oflag=sync &>/dev/null
+		done
+		# get md5sum
+		md5sum $MNT/tmp_file > /tmp/checksum
+	fi
+}
+
+Setup()
+{
+#******************************
+# first---mkfs.btrfs
+#******************************
+	Mkbtrfs
+
+#******************************
+# second---mount
+#******************************
+	Mountfs
+
+#******************************
+# third---create file
+#******************************
+	Createfile
+
+}
+
+Cleanup()
+{
+	rm -fr $MNT/*
+
+	umount $MNT
+	if [ $? -ne 0 ];then
+		echo "umount failed!"
+	fi
+}
+
+Btrfs_online_defrag()
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
+		btrfs filesystem defragment $str $MNT/tmp_file
+	else
+		if [ "$DEFRAG_TARGET" = "1" ];then
+			btrfs filesystem defragment $MNT/tmp_file
+		elif [ "$DEFRAG_TARGET" = "2" ];then
+			btrfs filesystem defragment $MNT/tmp_dir
+		elif [ "$DEFRAG_TARGET" = "3" ];then
+			btrfs filesystem defragment $MNT
+		fi
+	fi
+	ret_val=$?
+	sync
+	if [ $ret_val -ne 20 ];then
+		echo "btrfs filesystem defragment failed! err is $ret_val"
+	fi
+}
+
+Checksum()
+{
+	md5sum -c /tmp/checksum > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "md5 checksum failed!"
+	fi
+}
+
+FSCK()
+{
+	btrfsck $DEV > /dev/null 2>&1
+	ret_val=$?
+	if [ $ret_val -ne 0 ];then
+		echo "*****btrfsck _FAIL_! err is $ret_val*****"
+	fi
+}
+
+Parse_options()
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
+
+	FLUSH=`echo $args | awk -F ' ' '{ print $4 }'`
+	case $FLUSH in
+		"1")
+			echo "online defragment flush: off"
+			;;
+		"2")
+			echo "online defragment flush: on"
+			;;
+	esac
+
+	THRESH=`echo $args | awk -F ' ' '{ print $5 }'`
+	case $THRESH in
+		"1")
+			echo "online defragment thresh: default(256K)"
+			;;
+		"2")
+			echo "online defragment thresh: -1"
+			;;
+		"3")
+			echo "online defragment thresh: PAGESIZE"
+			;;
+	esac
+	fi
+}
+
+Usage()
+{
+	echo "*********************************************"
+	echo " usage:"
+	echo " runtest.sh args.in mount_point device  "
+	echo "*********************************************"
+}
+
+#***************************************************************
+# main
+#***************************************************************
+if [ `id -ru` -ne 0 ];then
+	echo "You need to be root to RUN this test"
+	exit 1
+fi
+
+if [ "$3" = "" -o "$2" = "" -o "$1" = "" ];then
+	Usage
+	exit 1
+fi
+
+ARGS=$1
+MNT=$2
+DEV=$3
+
+echo "btrfs online defragment test start"
+while read args
+do
+	echo "***$args***START***"
+	Parse_options $args
+	Setup
+	Btrfs_online_defrag
+	Checksum
+	Cleanup
+	FSCK
+	echo "***$args***END***"
+done < $ARGS
+echo "btrfs online defragment test done"
-- 
1.6.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
