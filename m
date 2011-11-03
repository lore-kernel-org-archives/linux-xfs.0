Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA339vNl223666 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 22:09:57 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A148C1000B45
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 20:09:55 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id jgS0xS33c1hTzPIA for
	<xfs@oss.sgi.com>; Wed, 02 Nov 2011 20:09:55 -0700 (PDT)
Message-ID: <4EB205CC.6010509@cn.fujitsu.com>
Date: Thu, 03 Nov 2011 11:09:00 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfstests 265: add a prealloc and reserve test
References: <4EB20505.7070005@cn.fujitsu.com>
In-Reply-To: <4EB20505.7070005@cn.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

This test is for preallocation test. If the disk is full, just with a prealloc
file has some free space that prealloc early. We need to check whether the write
to the free space is success or not.

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 265     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out |    5 +++
 group   |    1 +
 3 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100755 265
 create mode 100644 265.out

diff --git a/265 b/265
new file mode 100755
index 0000000..13c3520
--- /dev/null
+++ b/265
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# preallocation test
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
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
+#creator
+owner=wu.bo@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0    # success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $TEST_DIR/* $tmp.*
+	
+	if [ $_resize -eq 1 ]
+	then
+		btrfs filesystem resize ${_old}B $TEST_DIR > /dev/null 2>&1
+	fi
+	
+	_cleanup_testdir
+}
+
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os IRIX Linux
+
+_setup_testdir
+_check_test_fs
+
+echo "------------------------------"
+echo "preallocation test"
+echo "------------------------------"
+
+_resize=0
+_new=$(( 1 * 1024 * 1024 * 1024 )) # 1G
+_old=`df --block-size=1 | grep $TEST_DEV | awk '{print $2}'`
+if [ $_new -lt $_old ]
+then
+	btrfs filesystem resize ${_new}B $TEST_DIR > /dev/null 2>&1
+	if [ $? -ne 0 ]
+	then
+		echo "btrfs filesystem resize err"
+		status=1
+		exit
+	fi
+	_resize=1
+fi
+
+rm -rf $TEST_DIR/*
+cd $TEST_DIR
+dd if=/dev/zero of=test bs=4K count=1 > /dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "create file err"
+	status=1
+	exit
+fi
+
+fallocate -n -o 4K -l 1M test > /dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "fallocate file err"
+	status=1
+	exit
+fi
+
+dd if=/dev/zero of=tmp1 bs=1M > /dev/null 2>&1
+dd if=/dev/zero of=tmp2 bs=4K > /dev/null 2>&1
+sync
+
+dd if=/dev/zero of=test seek=1 bs=4K count=2 conv=notrunc > /dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "fill prealloc range err"
+	status=1
+	exit
+fi
+
+echo "done"
+exit
diff --git a/265.out b/265.out
new file mode 100644
index 0000000..202ca6a
--- /dev/null
+++ b/265.out
@@ -0,0 +1,5 @@
+QA output created by 265
+------------------------------
+preallocation test
+------------------------------
+done
diff --git a/group b/group
index 301aaec..f76ab8c 100644
--- a/group
+++ b/group
@@ -378,3 +378,4 @@ deprecated
 262 auto quick quota
 263 rw auto quick
 264 auto rw
+265 auto rw
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
