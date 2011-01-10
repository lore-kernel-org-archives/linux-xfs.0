Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ANUP35052713 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 17:30:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61428250F24
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 15:32:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	1CyuRTCYOpB8uGyQ for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 15:32:36 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	7077316-1927428
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 10:02:34 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcRE0-0006Uo-Jk
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:32:32 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcRDs-0003v1-Ck
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:32:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: add simple splice test
Date: Tue, 11 Jan 2011 10:32:24 +1100
Message-Id: <1294702344-15035-1-git-send-email-david@fromorbit.com>
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
