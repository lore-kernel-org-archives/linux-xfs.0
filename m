Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BJr0Or002751 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 14:53:00 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E22AD4536
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 12:52:59 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id QZnPdZgDfwh2a6y6 for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 12:52:59 -0700 (PDT)
Message-ID: <4E443517.5090105@oracle.com>
Date: Fri, 12 Aug 2011 04:01:27 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] Added test case 258 for btrfs defragmentation
References: <4E3BA2F7.4080500@oracle.com>
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Chris Mason <chris.mason@oracle.com>

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
  258     |   60 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  258.out |    2 ++
  group   |    1 +
  3 files changed, 63 insertions(+), 0 deletions(-)
  create mode 100755 258
  create mode 100644 258.out

diff --git a/258 b/258
new file mode 100755
index 0000000..798bbaf
--- /dev/null
+++ b/258
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 258
+#
+# btrfs defragmentation tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle.  All Rights Reserved.
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
+owner=anand.jain@oracle.com
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
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+
+btrfs filesystem defragment $SCRATCH_MNT
+[ $? = 20 ] || _fail "Defragment failed"
+
+umount $SCRATCH_MNT || _fail "umount failed"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/258.out b/258.out
new file mode 100644
index 0000000..9d47016
--- /dev/null
+++ b/258.out
@@ -0,0 +1,2 @@
+QA output created by 258
+Silence is golden
diff --git a/group b/group
index 84c45da..739f806 100644
--- a/group
+++ b/group
@@ -371,3 +371,4 @@ deprecated
  255 auto quick prealloc
  256 auto quick
  257 auto quick
+258 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
