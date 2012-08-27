Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R3Ql91235001 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 22:26:47 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ObUs8pdQzz1swZ4H for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 20:27:36 -0700 (PDT)
Message-ID: <503AE924.2000106@sandeen.net>
Date: Sun, 26 Aug 2012 22:27:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test dump/restore of 32-bit projids
References: <503ABD37.7090006@redhat.com>
In-Reply-To: <503ABD37.7090006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Bill Kendall <wkendall@sgi.com>, =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWM=?=@oss.sgi.com, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Test that xfsdump/xfsrestore properly restores more than the
bottom 16 bits of a 32-bit projid.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/285 b/285
new file mode 100755
index 0000000..2804e5d
--- /dev/null
+++ b/285
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Test projid32: persist 32 bit projids thorugh dump/restore
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Eric Sandeen.  All Rights Reserved.
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
+owner=sandeen@sandeen.net
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
+. ./common.dump
+. ./common.quota
+
+_require_scratch
+_require_xfs_quota
+
+# real QA test starts here
+
+_supported_fs xfs
+_supported_os IRIX Linux
+
+_scratch_mkfs_xfs -i projid32bit=1 >> $seq.full || _fail "mkfs failed"
+
+export MOUNT_OPTIONS="-opquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+# > 16 bit project ID
+PROJID=2123456789
+
+# Put a project quota on a dir
+mkdir $SCRATCH_MNT/dir
+xfs_quota -x -c "project -s -p $SCRATCH_MNT/dir $PROJID" $SCRATCH_MNT >> $seq.full || _fail "dir pquota failed"
+
+# Dump it then restore it to a fresh fs, and check the projid
+rm -f $tmp.dumpfile
+xfsdump -L label -M media -f $tmp.dumpfile $SCRATCH_MNT >> $seq.full || _fail "dump failed"
+umount $SCRATCH_DEV
+
+_scratch_mkfs_xfs -i projid32bit=1 >> $seq.full || _fail "re-mkfs failed"
+_qmount
+xfsrestore -f $tmp.dumpfile $SCRATCH_MNT >> $seq.full || _fail "restore failed"
+
+# check (-c) that we got the correct project ID back post-restore
+xfs_quota -x -c "project -s -c -p $SCRATCH_MNT/dir $PROJID" $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..daf4e4c
--- /dev/null
+++ b/285.out
@@ -0,0 +1,3 @@
+QA output created by 285
+Checking project 2123456790 (path /mnt/scratch/dir)...
+Processed 1 (/etc/projects and cmdline) paths for project 2123456790 with recursion depth infinite (-1).
diff --git a/group b/group
index 104ed35..bbc74fe 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto dump quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
