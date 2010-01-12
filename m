Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C4itwX217514 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:44:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E1DCEFE5BB
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 20:45:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	AeQ1ahyavgq2jByC for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 20:45:48 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11406828-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:15:47 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYdV-0004gA-Qa
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:45:45 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYZJ-0005zj-CD
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfsqa: add simple xfs_fsr test
Date: Tue, 12 Jan 2010 15:41:09 +1100
Message-Id: <1263271269-18997-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1263271269-18997-1-git-send-email-david@fromorbit.com>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
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

We have very little fsr test coverage in the test suite right now.
042 is the only test that runs it, and it only defragments a single
file.

Improve the coverage by simply running xfs_fsr of the test
filesystem. This gives xfs_fsr a wide variety of inodes to try to
defragment. A simple test like this would have tripped over the
attr2 fork offset problems in the swap extents ioctl long ago
thanks to the varied nature of inodes the test suite leaves around
in this filesystem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 221     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 221.out |    2 ++
 group   |    1 +
 3 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 221
 create mode 100644 221.out

diff --git a/221 b/221
new file mode 100644
index 0000000..5fe5583
--- /dev/null
+++ b/221
@@ -0,0 +1,57 @@
+#! /bin/sh
+# FS QA Test No. 221
+#
+# xfs_fsr QA tests
+# run xfs_fsr over the test filesystem to give it a wide and varied set of
+# inodes to try to defragment. This is effectively a crash/assert failure
+# test looking for corruption induced by xfs_fsr runs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Dave Chinner.  All Rights Reserved.
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
+owner=david@fromorbit.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
+
+xfs_fsr $TEST_MNT > /dev/null 2>&1
+
+echo "--- silence is golden ---"
+status=0 ; exit
diff --git a/221.out b/221.out
new file mode 100644
index 0000000..34b5d1b
--- /dev/null
+++ b/221.out
@@ -0,0 +1,2 @@
+QA output created by 221
+--- silence is golden ---
diff --git a/group b/group
index 2c2e293..528f5e9 100644
--- a/group
+++ b/group
@@ -330,3 +330,4 @@ prealloc
 218 auto fsr quick
 219 auto quota quick
 220 auto quota quick
+221 fsr ioctl auto quick
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
