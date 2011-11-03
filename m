Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3HuNqJ038442 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 12:56:23 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C5A6568DA0
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 10:56:21 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id hqmvi016ID7DIkcH
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 10:56:21 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1634560bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 10:56:21 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 8/9] xfstress: add regression testcase for d583fb87a3ff0
Date: Thu,  3 Nov 2011 21:55:52 +0400
Message-Id: <1320342953-7973-8-git-send-email-dmonakhov@openvz.org>
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

Should be fixed by following patch http://patchwork.ozlabs.org/patch/120883/

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 271     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 271.out |   44 ++++++++++++++++++++++++++++++++++++++++
 group   |    1 +
 3 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100755 271
 create mode 100644 271.out

diff --git a/271 b/271
new file mode 100755
index 0000000..b4e6043
--- /dev/null
+++ b/271
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FSQA Test No. 271
+#
+# Regression testcase for d583fb87a3ff0 (ext4 extent corruption)
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
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seq.full 2>&1
+
+# -onoload and EXT4_SYNC_FL on file is important becase result in
+# metadata sync writes inside ext4_handle_dirty_metadata()
+_scratch_mount -onoload
+touch $SCRATCH_MNT/file
+chattr +S $SCRATCH_MNT/file
+# Create sparse file 
+for ((i = 0; i < 21; i++))
+do
+    dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k count=1 seek=$((i*10))
+done
+# truncate last extent
+truncate $SCRATCH_MNT/file --size $((4096* 200))
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+echo "Check filesystem"
+_check_scratch_fs
+status=$?
+exit
diff --git a/271.out b/271.out
new file mode 100644
index 0000000..22a3c50
--- /dev/null
+++ b/271.out
@@ -0,0 +1,44 @@
+QA output created by 271
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+1+0 records in
+1+0 records out
+Check filesystem
diff --git a/group b/group
index 84e81f5..fefa580 100644
--- a/group
+++ b/group
@@ -384,3 +384,4 @@ deprecated
 268 dump ioctl tape
 269 auto rw prealloc ioctl enospc
 270 auto quota rw prealloc ioctl enospc
+271 auto rw quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
