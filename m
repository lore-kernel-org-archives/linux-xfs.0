Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22Gpgxs106755 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 10:51:42 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fbj6zeyz27pSC1Ep for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 08:51:41 -0800 (PST)
Message-ID: <4F50FA9B.6040503@redhat.com>
Date: Fri, 02 Mar 2012 10:51:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 280: test freeze deadlock  w/ quotas
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Jan Kara <jack@suse.cz>

This tests the quota+freeze hang scenario described & fixed in
dcdbed85 quota: Fix deadlock with suspend and quotas

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/280 b/280
new file mode 100755
index 0000000..55849ed
--- /dev/null
+++ b/280
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 280
+#
+# Test quota vs. suspend/freeze deadlock, 
+# dcdbed85 quota: Fix deadlock with suspend and quotas
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
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
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+_require_scratch
+_require_quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_supported_fs ext3 ext4 xfs
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon $SCRATCH_MNT 2>/dev/null
+xfs_freeze -f $SCRATCH_MNT
+setquota -u root 1 2 3 4 $SCRATCH_MNT &
+sleep 1
+xfs_freeze -u $SCRATCH_MNT
+umount $SCRATCH_DEV
+
+# Failure comes in the form of a deadlock.
+
+# success, all done
+status=0
+exit
diff --git a/280.out b/280.out
new file mode 100644
index 0000000..fb29270
--- /dev/null
+++ b/280.out
@@ -0,0 +1 @@
+QA output created by 280
diff --git a/group b/group
index 7a91f41..01f406d 100644
--- a/group
+++ b/group
@@ -393,3 +393,4 @@ deprecated
 277 auto ioctl quick metadata
 278 repair auto
 279 auto mkfs
+280 auto quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
