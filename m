Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA83gOoP088944 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 21:42:25 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40E5622A3BC
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 19:42:22 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id aSyzZVGUf6LVsOFK for
	<xfs@oss.sgi.com>; Mon, 07 Nov 2011 19:42:22 -0800 (PST)
Message-ID: <4EB8A4F9.8060006@cn.fujitsu.com>
Date: Tue, 08 Nov 2011 11:41:45 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH v2 3/3] xfstests 275: add a write and reserve test
References: <4EB8A441.7090506@cn.fujitsu.com>
In-Reply-To: <4EB8A441.7090506@cn.fujitsu.com>
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
To: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

This test is for write-posix test. If writing a file when the disk is almost
full, the posix wants the call to write as much as possible but not none.

quote the POSIX:
If a write() requests that more bytes be written than there is room for
(for example, [XSI] [Option Start] the process' file size limit or
[Option End] the physical end of a medium), only as many bytes as there
is room for shall be written. For example, suppose there is space for 20
bytes more in a file before reaching a limit. A write of 512 bytes will
return 20. The next write of a non-zero number of bytes would give a
failure return (except as noted below).

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 275     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 275.out |    5 +++
 group   |    1 +
 3 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100755 275
 create mode 100644 275.out

diff --git a/275 b/275
new file mode 100755
index 0000000..214262e
--- /dev/null
+++ b/275
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 275
+#
+# The posix write test. when write size is larger than disk free size,
+# should write as more as possible
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
+	cd /
+	rm -f $SCRATCH_MNT/* $tmp.*
+	_scratch_unmount
+}
+
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+echo "------------------------------"
+echo "write lack test"
+echo "------------------------------"
+
+rm -f $seq.full
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
+_scratch_mount
+
+rm -rf $SCRATCH_MNT/*
+cd $SCRATCH_MNT
+
+dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "create file err"
+	status=1
+	exit
+fi
+
+dd if=/dev/zero of=tmp2 bs=1M >/dev/null 2>&1
+dd if=/dev/zero of=tmp3 bs=4K >/dev/null 2>&1
+sync
+
+rm -f tmp1
+sync
+
+dd if=/dev/zero of=tmp1 bs=8K count=1 >/dev/null 2>&1
+_filesize=`du tmp1 | awk '{print $1}'`
+if [ $_filesize -ne 4 ]
+then
+	echo "write file err"
+	status=1
+	exit
+fi
+
+echo "done"
+exit
diff --git a/275.out b/275.out
new file mode 100644
index 0000000..30af43c
--- /dev/null
+++ b/275.out
@@ -0,0 +1,5 @@
+QA output created by 275
+------------------------------
+write lack test
+------------------------------
+done
diff --git a/group b/group
index 44a9999..8cdddd6 100644
--- a/group
+++ b/group
@@ -388,3 +388,4 @@ deprecated
 272 auto enospc rw
 273 auto rw
 274 auto rw
+275 auto rw
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
