Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EAqHXg087170 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 04:52:17 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id RsrZ8gj3ajl4CpqK for
	<xfs@oss.sgi.com>; Tue, 14 Feb 2012 02:52:15 -0800 (PST)
From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/3 v3] xfstests: add btrfs online defragments QA test
Date: Tue, 14 Feb 2012 18:50:24 +0800
Message-Id: <1329216624-22076-1-git-send-email-liubo2009@cn.fujitsu.com>
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

v3:
- use xfstests wrappers.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 278     |  171 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 278.out |   11 ++++
 group   |    1 +
 3 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100755 278
 create mode 100644 278.out

diff --git a/278 b/278
new file mode 100755
index 0000000..4ecbc30
--- /dev/null
+++ b/278
@@ -0,0 +1,171 @@
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
+here="`pwd`"
+tmp=/tmp/$$
+cnt=11999
+filesize=48000
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
+	if [ $1 -ne 2 ]; then
+		tmpfile="$SCRATCH_MNT/tmp_file"
+	else
+		tmpfile="$SCRATCH_MNT/tmp_dir/tmp_file"
+	fi
+		
+	for i in `seq $cnt -1 0`; do
+		dd if=/dev/zero of=$tmpfile bs=4k count=1 \
+		 conv=notrunc seek=$i oflag=sync &>/dev/null
+	done
+	# get md5sum
+	md5sum $tmpfile > /tmp/checksum
+}
+
+_btrfs_online_defrag()
+{
+	str=""
+	if [ "$2" = "2" ];then
+		str="$str -s -1 -l $((filesize / 2)) "
+	elif [ "$2" = "3" ];then
+		str="$str -s $((filesize + 1)) -l $((filesize / 2)) "
+		HAVE_DEFRAG=1
+	elif [ "$2" = "4" ];then
+		str="$str -l -1 "
+	elif [ "$2" = "5" ];then
+		str="$str -l $((filesize + 1)) "
+	elif [ "$2" = "6" ];then
+		str="$str -l $((filesize / 2)) "
+	fi
+
+	if [ "$3" = "2" ];then
+		str="$str -c "
+	fi
+
+	if [ "$str" != "" ]; then
+		btrfs filesystem defragment $str $SCRATCH_MNT/tmp_file
+	else
+		if [ "$1" = "1" ];then
+			btrfs filesystem defragment $SCRATCH_MNT/tmp_file
+		elif [ "$1" = "2" ];then
+			btrfs filesystem defragment $SCRATCH_MNT/tmp_dir
+		elif [ "$1" = "3" ];then
+			btrfs filesystem defragment $SCRATCH_MNT
+		fi
+	fi
+	ret_val=$?
+	_scratch_remount
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
+_cleanup_defrag()
+{
+	umount $SCRATCH_MNT > /dev/null 2>&1
+}
+
+_setup_defrag()
+{
+	umount $SCRATCH_MNT > /dev/null 2>&1
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	_create_file $1
+}
+
+_rundefrag()
+{
+	_setup_defrag $1
+	_btrfs_online_defrag $1 $2 $3
+	_checksum
+	_cleanup_defrag
+	_check_scratch_fs
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
+_require_defrag
+
+echo "defrag object | defragment range | defragment compress"
+echo "a single file |  default | off"
+_rundefrag 1 1 1
+
+echo "a single file | default |  on"
+_rundefrag 1 1 2
+
+echo "a single file | start < 0 && 0 < len < file size | off"
+_rundefrag 1 2 1
+
+echo "a single file | start > file size && 0 < len < file size | off"
+_rundefrag 1 3 1
+
+echo "a single file | start = 0 && len < 0 | off"
+_rundefrag 1 4 1
+
+echo "a single file | start = 0 && len > file size | off"
+_rundefrag 1 5 1
+
+echo "a single file | start = 0 && 0 < len < file size | off"
+_rundefrag 1 6 1
+
+echo "a directory | default | off"
+_rundefrag 2 1 1
+
+echo "a filesystem | default | off"
+_rundefrag 3 1 1
+
+status=0
+exit
diff --git a/278.out b/278.out
new file mode 100644
index 0000000..100869e
--- /dev/null
+++ b/278.out
@@ -0,0 +1,11 @@
+QA output created by 278
+defrag object | defragment range | defragment compress
+a single file |  default | off
+a single file | default |  on
+a single file | start < 0 && 0 < len < file size | off
+a single file | start > file size && 0 < len < file size | off
+a single file | start = 0 && len < 0 | off
+a single file | start = 0 && len > file size | off
+a single file | start = 0 && 0 < len < file size | off
+a directory | default | off
+a filesystem | default | off
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
