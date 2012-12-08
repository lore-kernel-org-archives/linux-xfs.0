Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8KuP49055415 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 14:56:25 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kNC7NwzlSmT93D4f for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 12:58:52 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0C50063C3E3F
	for <xfs@oss.sgi.com>; Sat,  8 Dec 2012 14:58:52 -0600 (CST)
Message-ID: <50C3AA0F.4070505@sandeen.net>
Date: Sat, 08 Dec 2012 14:58:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: ensure all xfs_io commands are documented in the
	manpage
References: <50C39123.6050303@sandeen.net>
In-Reply-To: <50C39123.6050303@sandeen.net>
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

Ensure that all commands listed in "xfs_io -c help" are
documented in the xfs_io(8) manpage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/293 b/293
new file mode 100755
index 0000000..e42344d
--- /dev/null
+++ b/293
@@ -0,0 +1,59 @@
+#! /bin/bash
+# FS QA Test No. 293
+#
+# Ensure all xfs_io commands are documented
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
+owner=sandeen@redhat.com
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os IRIX Linux
+
+echo "Silence is golden"
+
+for COMMAND in `$XFS_IO_PROG -c help | awk '{print $1}' | grep -v "^Use "`; do
+  man xfs_io | col -b | grep -wq $COMMAND || \
+	echo "$COMMAND not documented in the xfs_io manpage"
+done
+
+# success, all done
+status=0
+exit
diff --git a/293.out b/293.out
new file mode 100644
index 0000000..076fc05
--- /dev/null
+++ b/293.out
@@ -0,0 +1,2 @@
+QA output created by 293
+Silence is golden
diff --git a/group b/group
index 9562685..b04fb50 100644
--- a/group
+++ b/group
@@ -411,3 +411,4 @@ deprecated
 290 auto rw prealloc quick ioctl
 291 auto mkfs quick
 292 auto quick
+293 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
