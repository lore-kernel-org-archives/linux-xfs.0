Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BBORKR257523 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 06:24:27 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCE3D1B9BCC
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:24:26 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id dCHG0yK5IfSjjW4e for
	<xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:24:26 -0700 (PDT)
Message-ID: <4E942823.1030206@oracle.com>
Date: Tue, 11 Oct 2011 19:27:31 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] 264: Functional test case for the btrfs de-fragmentation
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
	<4E92C1D7.2010301@oracle.com>
	<20111010112151.GA28627@infradead.org>
In-Reply-To: <20111010112151.GA28627@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

To verify the btrfs de-fragmentation does not fail

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
  264     |   60 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  264.out |    2 ++
  group   |    1 +
  3 files changed, 63 insertions(+), 0 deletions(-)
  create mode 100755 264
  create mode 100644 264.out

diff --git a/264 b/264
new file mode 100755
index 0000000..61efeb8
--- /dev/null
+++ b/264
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 264
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
diff --git a/264.out b/264.out
new file mode 100644
index 0000000..eca790b
--- /dev/null
+++ b/264.out
@@ -0,0 +1,2 @@
+QA output created by 264
+Silence is golden
diff --git a/group b/group
index d86624f..b5863be 100644
--- a/group
+++ b/group
@@ -377,3 +377,4 @@ deprecated
  261 auto quick quota
  262 auto quick quota
  263 auto quick
+264 auto quick
-- 
1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
