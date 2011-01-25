Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P3x5NL176143 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 21:59:05 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D588128D51D
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:01:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	t1UgAF4EEYfXKLe3 for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:01:27 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pha5j-0003Tp-65
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 15:01:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pha3Y-0005Nc-OK
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 14:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfstests: add simple splice test
Date: Tue, 25 Jan 2011 14:58:54 +1100
Message-Id: <1295927937-20634-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1295927937-20634-1-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We don't have any coverage of the splice functionality provided by
the kernel in xfstests. Add a simple test that uses the sendfile
operation built into xfs_io to copy a file ensure we at least
execute the code path in xfstests.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 249     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 249.out |    2 ++
 group   |    1 +
 3 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 249
 create mode 100644 249.out

diff --git a/249 b/249
new file mode 100644
index 0000000..6fc972e
--- /dev/null
+++ b/249
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 249
+#
+# simple splice(2) test.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
+owner=dchinner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=tmp/$$
+status=1  # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f $SRC $DST
+	_cleanup_testdir
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_setup_testdir
+
+echo "Feel the serenity."
+
+SRC=$TEST_DIR/$seq.src
+DST=$TEST_DIR/$seq.dst
+
+$XFS_IO_PROG -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC > /dev/null 2>&1
+$XFS_IO_PROG -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST > /dev/null 2>&1
+
+diff $SRC $DST
+
+status=$?
+exit
diff --git a/249.out b/249.out
new file mode 100644
index 0000000..592696f
--- /dev/null
+++ b/249.out
@@ -0,0 +1,2 @@
+QA output created by 249
+Feel the serenity.
diff --git a/group b/group
index a40c98f..b94f543 100644
--- a/group
+++ b/group
@@ -362,3 +362,4 @@ deprecated
 246 auto quick rw
 247 auto quick rw
 248 auto quick rw 
+249 auto quick rw 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
