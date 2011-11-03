Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3HuGJr038413 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 12:56:16 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF928568D97
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 10:56:15 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id k9Fvbj3m5I9AvMDW
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 10:56:15 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1634560bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 10:56:15 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/9] xfstests: add a new test that runs fsstress under ENOSPC
	conditions
Date: Thu,  3 Nov 2011 21:55:50 +0400
Message-Id: <1320342953-7973-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
References: <1320342953-7973-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

During stress testing we want to cover as much code paths as possible
fsstress is very good for this purpose. But it has expandable nature
(disk usage almost continually grow). So once it goes in no ENOSPC
condition it will be where till the end. But by running 'dd' writers
in parallel we can regularly trigger ENOSPC but only for a limited
periods of time because each time it opens the same file with O_TRUNC.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 269     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 269.out |    5 +++
 group   |    1 +
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100755 269
 create mode 100644 269.out

diff --git a/269 b/269
new file mode 100755
index 0000000..61e83ad
--- /dev/null
+++ b/269
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FSQA Test No. 269
+#
+# Run fsstress and ENSPC hitters in parallel, check fs consistency an the end
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
+owner=dmonakhov@openvz.org
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+# Disable all sync operations to get higher load
+FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
+_workout()
+{
+	echo ""
+	echo "Run fsstress"
+	echo ""
+	num_iterations=10
+	enospc_time=2
+	out=$SCRATCH_MNT/fsstress.$$
+	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	echo "fsstress $args" >> $here/$seq.full
+	$FSSTRESS_PROG $args > /dev/null 2>&1 &
+	pid=$!
+	echo "Run dd writers in parallel"
+	for ((i=0; i < num_iterations; i++))
+	do
+		# File will be opened with O_TRUNC each time
+		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
+			> /dev/null 2>&1
+		sleep $enospc_time
+	done
+	kill $pid
+	wait $pid
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/269.out b/269.out
new file mode 100644
index 0000000..0a83965
--- /dev/null
+++ b/269.out
@@ -0,0 +1,5 @@
+QA output created by 269
+
+Run fsstress
+
+Run dd writers in parallel
diff --git a/group b/group
index aaa8eba..8a5c334 100644
--- a/group
+++ b/group
@@ -382,3 +382,4 @@ deprecated
 266 dump ioctl auto quick
 267 dump ioctl tape
 268 dump ioctl tape
+269 auto rw prealloc ioctl enospc
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
