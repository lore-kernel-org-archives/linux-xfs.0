Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9G9eBDO099633 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 04:40:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mTJfgGs4jdDgKdrP for
	<xfs@oss.sgi.com>; Tue, 16 Oct 2012 02:41:47 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] 286: Test FITRIM where length is smaller than FSB
Date: Tue, 16 Oct 2012 11:41:33 +0200
Message-Id: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

This tests corner case in FITRIM implementation where range size is
smaller than file system block or zero. In this case FITRIM should fail
with EINVAL.

The problem was spotted in xfs and ext4 where in case of length = 0 the
'end' variable underflowed. In case of length smaller than 1 FSB FITRIM
finished successfully, but we really should rather return EINVAL in both
cases.

(This patch has to be applied after 'Use upstream version of fstrim
instead of the local one')

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 286     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 286.out |    6 ++++++
 group   |    1 +
 3 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 286
 create mode 100644 286.out

diff --git a/286 b/286
new file mode 100644
index 0000000..b5122ec
--- /dev/null
+++ b/286
@@ -0,0 +1,58 @@
+#!/bin/bash
+# FS QA Test No. 286
+#
+# This check the FITRIM argument handling in the corner case where length is
+# smaller than block size of zero.
+#
+#-----------------------------------------------------------------------
+# Copyright 2012 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
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
+
+owner=lczerner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=0
+trap "exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_fstrim
+_require_scratch
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
+
+echo "[+] Length is zero (should fail)"
+out=$("$FSTRIM_PROG" -v -o0 -l0 $SCRATCH_MNT 2>&1)
+[ $? -eq 0 ] && status=1
+echo $out | _filter_scratch
+
+echo "[+] Length is smaller than block size (should fail)"
+out=$("$FSTRIM_PROG" -v -o0 -l100 $SCRATCH_MNT 2>&1)
+[ $? -eq 0 ] && status=1
+echo $out | _filter_scratch
+
+echo "Test done"
+exit
diff --git a/286.out b/286.out
new file mode 100644
index 0000000..b164872
--- /dev/null
+++ b/286.out
@@ -0,0 +1,6 @@
+QA output created by 286
+[+] Length is zero (should fail)
+fstrim: SCRATCH_MNT: FITRIM ioctl failed: Invalid argument
+[+] Length is smaller than block size (should fail)
+fstrim: SCRATCH_MNT: FITRIM ioctl failed: Invalid argument
+Test done
diff --git a/group b/group
index 697269b..c1bb04c 100644
--- a/group
+++ b/group
@@ -404,3 +404,4 @@ deprecated
 283 dump ioctl auto quick
 284 auto
 285 auto dump quota quick
+286 auto quick ioctl trim
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
