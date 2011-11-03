Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPmdJ018037 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:48 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A59705683F4
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:47 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id s5x1pKiYP8yWKBAW
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:47 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1398069bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:47 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 12/12] xfstress: Test data journaling flag switch for a single
	file
Date: Thu,  3 Nov 2011 18:25:01 +0400
Message-Id: <1320330301-2682-13-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 267     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 267.out |   37 +++++++++++++++++++++
 group   |    1 +
 3 files changed, 149 insertions(+), 0 deletions(-)
 create mode 100644 267
 create mode 100644 267.out

diff --git a/267 b/267
new file mode 100644
index 0000000..e2ce347
--- /dev/null
+++ b/267
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FSQA Test No. 267
+#
+# Test data journaling flag switch for a single file  
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
+_workout()
+{
+	echo ""
+	echo " Switch data journalling mode"
+	echo ""
+	write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
+	chattr_opt_list="+j -j +jS -j"
+	idx=0
+	#
+	for write_opt in $write_opt_list
+	do
+		idx=$((idx + 1))
+		for chattr_opt in $chattr_opt_list
+		do
+		    
+			echo "OP write_opt: $write_opt 4M, \
+chattr_opt: $chattr_opt"
+			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
+				bs=1M count=4 $write_opt \
+				> /dev/null 2>&1 || exit
+			chattr $chattr_opt $SCRATCH_MNT/file.$idx \
+				|| exit
+		done
+	done
+	sync
+	# Same as previous test, but for one file,
+	# and with ENOSPC triggering
+	for write_opt in $write_opt_list
+	do
+		idx=$((idx + 1))
+		for chattr_opt in $chattr_opt_list
+		do
+
+			echo "OP write_opt: $write_opt ENOSPC, \
+chattr_opt: $chattr_opt"
+			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
+				bs=1M $write_opt > /dev/null 2>&1
+			chattr $chattr_opt $SCRATCH_MNT/file.$idx \
+				|| exit
+		done
+		sync
+		unlink $SCRATCH_MNT/file.$idx
+	done
+}
+
+# real QA test starts here
+_supported_fs ext3 ext4
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seq.full 2>&1
+
+# -onoload and EXT4_SYNC_FL on file is important becase result in
+# metadata sync writes inside ext4_handle_dirty_metadata()
+_scratch_mount
+
+if ! _workout; then
+	echo "workout failed"
+	_scratch_unmount
+	status=1
+	exit
+fi
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
diff --git a/267.out b/267.out
new file mode 100644
index 0000000..d46b6f4
--- /dev/null
+++ b/267.out
@@ -0,0 +1,37 @@
+QA output created by 267
+
+ Switch data journalling mode
+
+OP write_opt: iflag=noatime 4M, chattr_opt: +j
+OP write_opt: iflag=noatime 4M, chattr_opt: -j
+OP write_opt: iflag=noatime 4M, chattr_opt: +jS
+OP write_opt: iflag=noatime 4M, chattr_opt: -j
+OP write_opt: conv=notrunc 4M, chattr_opt: +j
+OP write_opt: conv=notrunc 4M, chattr_opt: -j
+OP write_opt: conv=notrunc 4M, chattr_opt: +jS
+OP write_opt: conv=notrunc 4M, chattr_opt: -j
+OP write_opt: conv=fsync 4M, chattr_opt: +j
+OP write_opt: conv=fsync 4M, chattr_opt: -j
+OP write_opt: conv=fsync 4M, chattr_opt: +jS
+OP write_opt: conv=fsync 4M, chattr_opt: -j
+OP write_opt: oflag=direct 4M, chattr_opt: +j
+OP write_opt: oflag=direct 4M, chattr_opt: -j
+OP write_opt: oflag=direct 4M, chattr_opt: +jS
+OP write_opt: oflag=direct 4M, chattr_opt: -j
+OP write_opt: iflag=noatime ENOSPC, chattr_opt: +j
+OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
+OP write_opt: iflag=noatime ENOSPC, chattr_opt: +jS
+OP write_opt: iflag=noatime ENOSPC, chattr_opt: -j
+OP write_opt: conv=notrunc ENOSPC, chattr_opt: +j
+OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
+OP write_opt: conv=notrunc ENOSPC, chattr_opt: +jS
+OP write_opt: conv=notrunc ENOSPC, chattr_opt: -j
+OP write_opt: conv=fsync ENOSPC, chattr_opt: +j
+OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
+OP write_opt: conv=fsync ENOSPC, chattr_opt: +jS
+OP write_opt: conv=fsync ENOSPC, chattr_opt: -j
+OP write_opt: oflag=direct ENOSPC, chattr_opt: +j
+OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
+OP write_opt: oflag=direct ENOSPC, chattr_opt: +jS
+OP write_opt: oflag=direct ENOSPC, chattr_opt: -j
+Check filesystem
diff --git a/group b/group
index dfc6fa7..5efb43c 100644
--- a/group
+++ b/group
@@ -380,3 +380,4 @@ deprecated
 264 auto rw prealloc ioctl enospc
 265 auto quota rw prealloc ioctl enospc
 266 rw auto quick
+267 rw auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
