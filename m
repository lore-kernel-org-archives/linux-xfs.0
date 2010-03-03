Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o236ILi0048463 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 00:18:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63C9E1D0B915
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 22:19:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Lbu5qfBT9mok7Aml for <xfs@oss.sgi.com>;
	Tue, 02 Mar 2010 22:19:37 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15740699-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Mar 2010 16:49:36 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nmhvi-0003N5-6p
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:34 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nmhva-00039l-SR
	for xfs@oss.sgi.com; Wed, 03 Mar 2010 17:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfsqa: add delayed allocation @ ENOSPC exerciser
Date: Wed,  3 Mar 2010 17:19:20 +1100
Message-Id: <1267597162-12092-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1267597162-12092-1-git-send-email-david@fromorbit.com>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
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

When we deplete the reserve block pool or receive an error during
delayed allocation, we currently toss the page away. If that page
has delayed allocation extents on it, we can fail to remove them and
leave stale delayed llocation extents lying around on the inode.
This can, in certain circumstances, trigger errors later on when the
stale delalloc extent it found again, including tripping a BUG().

Exercise this failure path so that we get code coverage of the fix
that prevents stale delalloc mappings from being left on the inode
when pages are tossed.

This is based on a test case supplied by Lachlan McIlroy.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 224     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 224.out |    2 +
 group   |    1 +
 3 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 224
 create mode 100644 224.out

diff --git a/224 b/224
new file mode 100644
index 0000000..ee01c41
--- /dev/null
+++ b/224
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 224
+#
+# Delayed allocation at ENOSPC test
+#
+# Derived from a test case from Lachlan McIlroy and improved to
+# reliably trigger a BUG in xfs_get_blocks(). Despite this XFS
+# focus, the test can to run on any filesystem to exercise ENOSPC
+# behaviour.
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
+	killall -9 dd > /dev/null 2>&1
+	rm -f $tmp.*
+	rm -f $SCRATCH_MNT/testfile.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+
+# make a 1GB filesystem
+_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > $seq.full 2>&1
+_scratch_mount >> $seq.full 2>&1
+
+# set the reserved block pool to almost empty for XFS
+if [ "$FSTYP" = "xfs" ]; then
+	xfs_io -x -c "resblks 4" /mnt/scratch/ >> $seq.full 2>&1
+fi
+
+FILES=1000
+for i in `seq 0 1 $FILES`; do
+
+	# set the file size to be 10MB - that way the direct IO will always try
+	# to read at least 10MB even if only 4k was written. This allows
+	# discarded delalloc pages that would have been beyond EOF to be
+	# tripped over.
+        (
+		sleep 5
+		xfs_io -f -c "truncate 10485760" $SCRATCH_MNT/testfile.$i
+		dd if=/dev/zero of=$SCRATCH_MNT/testfile.$i bs=4k conv=notrunc
+	) > /dev/null 2>&1 &
+done
+wait
+
+for i in `seq 0 1 $FILES`; do
+        dd of=/dev/null if=$SCRATCH_MNT/testfile.$i bs=512k iflag=direct > /dev/null 2>&1 &
+done
+wait
+echo "*** Silence is golden ***"
+status=0
+exit
diff --git a/224.out b/224.out
new file mode 100644
index 0000000..cf4fd9c
--- /dev/null
+++ b/224.out
@@ -0,0 +1,2 @@
+QA output created by 224
+*** Silence is golden ***
diff --git a/group b/group
index c66d965..5d675f0 100644
--- a/group
+++ b/group
@@ -337,3 +337,4 @@ deprecated
 221 auto metadata quick
 222 auto fsr ioctl quick
 223 auto quick
+224 auto
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
