Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FAobY9003924 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:50:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EA8C199E15
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:49:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail11.adl2.internode.on.net
	[203.16.214.75]) by cuda.sgi.com with ESMTP id ZZU2cWrYGZ0ChYem
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:49:54 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	46130993-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:19:52 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinuX-0004ns-NQ
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] [XFSQA] Add simple delayed allocation ENOSPC test.
Date: Sun, 15 Mar 2009 21:49:40 +1100
Message-Id: <1237114181-18431-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1237114181-18431-1-git-send-email-david@fromorbit.com>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
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

Using a small (100MB) filesystem and writing lots of
single block files can result in spurious ENOSPCs
being reported. Reproduce this test case so we can confirm
that it gets fixed.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 203     |   41 +++++++++++++++++++++++++++++++++++++++++
 203.out |    2 ++
 group   |    1 +
 3 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100755 203
 create mode 100644 203.out

diff --git a/203 b/203
new file mode 100755
index 0000000..16c5714
--- /dev/null
+++ b/203
@@ -0,0 +1,41 @@
+#! /bin/sh
+# FS QA Test No. 203
+#
+# Test out ENOSPC flushiung on small filesystems.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Christoph Hellwig.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+_scratch_mkfs_xfs -d size=104m >/dev/null
+_scratch_mount
+
+for i in `seq 1 22500`; do
+    echo -n > $SCRATCH_MNT/$i
+    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
+done
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
diff --git a/203.out b/203.out
new file mode 100644
index 0000000..f7476c0
--- /dev/null
+++ b/203.out
@@ -0,0 +1,2 @@
+QA output created by 203
+*** done
diff --git a/group b/group
index 35f02fc..0a51d9a 100644
--- a/group
+++ b/group
@@ -307,3 +307,4 @@ atime
 200 mount auto quick
 201 metadata auto quick
 202 repair auto quick
+203 metadata rw auto
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
