Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FFDA29E0A
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 05:58:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8052DAC007
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 03:58:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oCCNZAkxn0HKoYqh for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 03:58:03 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31Aw3e6027191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Apr 2013 06:58:03 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 3/4] xfstests ext4 310: test read
	/proc/fs/ext4/<dev>/mb_groups while the fs is being unmounted
Date: Mon,  1 Apr 2013 18:57:43 +0800
Message-Id: <1364813864-10820-4-git-send-email-eguan@redhat.com>
In-Reply-To: <1364813864-10820-1-git-send-email-eguan@redhat.com>
References: <1364813864-10820-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

Regression test for commit:
9559996 ext4: remove mb_groups before tearing down the buddy_cache

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/ext4/310     | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/310.out |  2 ++
 tests/ext4/group   |  2 +-
 3 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 tests/ext4/310
 create mode 100644 tests/ext4/310.out

diff --git a/tests/ext4/310 b/tests/ext4/310
new file mode 100644
index 0000000..eb9320f
--- /dev/null
+++ b/tests/ext4/310
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 310
+#
+# Regression test for commit:
+# 9559996 ext4: remove mb_groups before tearing down the buddy_cache
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    kill $PIDS >/dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seq.full
+echo "Silence is golden"
+
+DEV_BASENAME=$(basename $(readlink -f $SCRATCH_DEV))
+echo "Start test on device $SCRATCH_DEV, basename $DEV_BASENAME" >$seq.full
+_scratch_mkfs >>$seq.full 2>&1
+
+while true;do
+	mount $SCRATCH_DEV $SCRATCH_MNT
+	umount $SCRATCH_DEV
+done &
+PIDS=$!
+
+while true;do
+	cat /proc/fs/ext4/$DEV_BASENAME/mb_groups > /dev/null 2>&1
+done &
+PIDS="$PIDS $!"
+
+# sleep for 180s, in most cases a buggy kernel could hit BUG_ON within 3 minutes
+sleep 180
+
+# no BUG_ON, all done
+kill $PIDS >/dev/null 2>&1
+wait
+status=0
+exit
diff --git a/tests/ext4/310.out b/tests/ext4/310.out
new file mode 100644
index 0000000..7b9eaf7
--- /dev/null
+++ b/tests/ext4/310.out
@@ -0,0 +1,2 @@
+QA output created by 310
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index 6a44db3..a53cd87 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -8,4 +8,4 @@
 302 aio dangerous ioctl rw stress
 303 aio dangerous ioctl rw stress
 304 aio dangerous ioctl rw stress
-
+310 auto
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
