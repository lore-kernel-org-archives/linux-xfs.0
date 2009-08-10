Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AEddOd063740 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:39:40 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 415AB33C40B
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:50:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yMZg1C6jxRLBMYCc for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:50:27 -0700 (PDT)
Message-ID: <4A803162.8020806@sandeen.net>
Date: Mon, 10 Aug 2009 09:40:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2 2/2] xfstests: 220 - generic quota sanity
References: <4A7C7C1C.2010202@redhat.com>
In-Reply-To: <4A7C7C1C.2010202@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Add some very basic quota sanity tests for generic filesystems.

This is based on test 108, but uses the generic quota tools,
not xfs_quota, and therefore cannot test project quota.

Also, the IOs are much smaller (48k) so that ext3 won't get into
indirect blocks and throw off the accounting.  This does
assume 4k blocks though.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: xfs test changes split out, fix 220.out for 12-block IO

diff --git a/220 b/220
new file mode 100644
index 0000000..3b828cb
--- /dev/null
+++ b/220
@@ -0,0 +1,123 @@
+#! /bin/sh
+# FS QA Test No. 220
+#
+# Simple quota accounting test for direct/buffered/mmap IO.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
+#
+# Based on test 108,
+# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
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
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+filter_scratch()
+{
+	perl -ne "
+s,$SCRATCH_MNT,[SCR_MNT],;
+s,$SCRATCH_DEV,[SCR_DEV],;
+	print;"
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux #IRIX
+_require_scratch
+_require_quota
+
+test_files()
+{
+	echo; echo "### create files, setting up ownership (type=$type)"
+	rm -f $SCRATCH_MNT/{buffer,direct,mmap}
+	touch $SCRATCH_MNT/{buffer,direct,mmap}
+	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
+	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
+	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+		$here/src/lstat64 $file | head -3 | filter_scratch
+	done
+}
+
+test_accounting()
+{
+	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
+	echo "--- initiating parallel IO..." >>$seq.full
+	# Small ios here because ext3 will account for indirect blocks too ...   :( 
+	# 48k will fit w/o indirect for 4k blocks (default blocksize)
+	$XFS_IO_PROG -F -c 'pwrite 0 48k' -c 'fsync' \
+					$SCRATCH_MNT/buffer >>$seq.full 2>&1 &
+	$XFS_IO_PROG -F -c 'pwrite 0 48k' -d \
+					$SCRATCH_MNT/direct >>$seq.full 2>&1 &
+	$XFS_IO_PROG -F -c 't 48k' -c 'mm -rw 0 48k' -c 'mw 0 48k' -c 'ms -s' \
+					$SCRATCH_MNT/mmap   >>$seq.full 2>&1 &
+	wait
+	echo "--- completed parallel IO ($type)" >>$seq.full
+
+	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+		$here/src/lstat64 $file | head -3 | filter_scratch
+	done
+
+	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch
+}
+
+# real QA test starts here
+rm -f $seq.full
+
+uid=1
+gid=2
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon $SCRATCH_MNT 2>/dev/null
+umount $SCRATCH_DEV
+
+echo; echo "### test user accounting"
+export MOUNT_OPTIONS="-o usrquota"
+_qmount
+quotaon $SCRATCH_MNT 2>/dev/null
+type=u
+test_files
+test_accounting
+umount $SCRATCH_DEV 2>/dev/null
+
+echo; echo "### test group accounting"
+export MOUNT_OPTIONS="-o grpquota"
+_qmount
+quotaon $SCRATCH_MNT 2>/dev/null
+type=g
+test_files
+test_accounting
+umount $SCRATCH_DEV 2>/dev/null
+
+status=0
+exit
diff --git a/220.out b/220.out
new file mode 100644
index 0000000..a204087
--- /dev/null
+++ b/220.out
@@ -0,0 +1,63 @@
+QA output created by 220
+
+### test user accounting
+
+### create files, setting up ownership (type=u)
+  File: "[SCR_MNT]/buffer"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/direct"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/mmap"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+### some controlled buffered, direct and mmapd IO (type=u)
+  File: "[SCR_MNT]/buffer"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/direct"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/mmap"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+#1        --     144       0       0              3     0     0       
+
+
+
+### test group accounting
+
+### create files, setting up ownership (type=g)
+  File: "[SCR_MNT]/buffer"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/direct"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/mmap"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+### some controlled buffered, direct and mmapd IO (type=g)
+  File: "[SCR_MNT]/buffer"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/direct"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+  File: "[SCR_MNT]/mmap"
+  Size: 49152        Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+#2        --     144       0       0              3     0     0       
+
+
diff --git a/group b/group
index e068e92..1fc280f 100644
--- a/group
+++ b/group
@@ -328,3 +328,4 @@ prealloc
 217 log metadata auto
 218 auto fsr quick
 219 auto
+220 auto quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
