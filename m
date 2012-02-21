Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGwwJm198230 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 10:58:58 -0600
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id gV6mnJNxjUI8UyUb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 08:58:57 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 21 Feb 2012 11:58:57 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C8E0E38C803A
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:53 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1LGwqMG161214 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:58:53 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q1LGwqj2011956 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 14:58:52 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 10:58:51 -0600
Message-Id: <20120221165851.23253.12954.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 3/4] xfstests: Add a simple test to check separate
	pquota/gquota
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From d54abe9e75f7b3750982275f04eecd9cc6b86335 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 8 Feb 2012 10:06:18 -0600
Subject: [PATCH 3/3] Add a simple test to check simultaneous use of pquota and gquota.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 276     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 276.out |   69 +++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100755 276
 create mode 100644 276.out

diff --git a/276 b/276
new file mode 100755
index 0000000..3ce95ab
--- /dev/null
+++ b/276
@@ -0,0 +1,117 @@
+#! /bin/bash
+# FS QA Test No. 276
+#
+# Simple quota accounting test for simulaneously using pquota and gquota
+# A cut-down version of test # 180.
+#
+#-----------------------------------------------------------------------
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
+owner=sekharan@us.ibm.com
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
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_xfs_quota
+_require_seppquota
+
+test_files()
+{
+	echo; echo "### create files, setting up ownership (type=$type)"
+	rm -f $SCRATCH_MNT/{buffer,direct,mmap}
+	$XFS_IO_PROG -fc "chproj $prid" $SCRATCH_MNT/{buffer,direct,mmap}
+	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
+	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
+	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+		$here/src/lstat64 $file | head -3 | _filter_scratch
+		$XFS_IO_PROG -c lsproj $file
+	done
+}
+
+test_accounting()
+{
+	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
+	echo "--- initiating parallel IO..." >>$seq.full
+	$XFS_IO_PROG -c 'pwrite -b 1m 0 16m' -c 'fsync' \
+					$SCRATCH_MNT/buffer >>$seq.full 2>&1 &
+	$XFS_IO_PROG -c 'pwrite -b 1m 0 16m' -d \
+					$SCRATCH_MNT/direct >>$seq.full 2>&1 &
+	$XFS_IO_PROG -c 't 16m' -c 'mm -rw 0 16m' -c 'mw 0 16m' -c 'ms -s' \
+					$SCRATCH_MNT/mmap   >>$seq.full 2>&1 &
+	wait
+	echo "--- completed parallel IO ($type)" >>$seq.full
+
+	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+		$here/src/lstat64 $file | head -3 | _filter_scratch
+	done
+	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch | _filter_spaces
+	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch | _filter_spaces
+	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch | _filter_spaces
+}
+
+export MOUNT_OPTIONS="-opquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+_require_prjquota $SCRATCH_DEV
+
+# real QA test starts here
+rm -f $tmp.projects $seq.full
+umount $SCRATCH_DEV 2>/dev/null
+export MKFS_OPTIONS="$MKFS_OPTIONS -d seppquota=1"
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+cat $tmp.mkfs >>$seq.full
+_scratch_mount
+
+uid=1
+gid=2
+prid=3
+export QARGS="-x -D /dev/null -P /dev/null $SCRATCH_MNT"
+umount $SCRATCH_DEV
+export MOUNT_OPTIONS="-ogquota,pquota"
+_qmount
+
+echo; echo "### test group accounting"
+type=g
+id=$gid
+test_files
+test_accounting
+
+#echo; echo "### test project accounting"
+type=p
+id=$prid
+test_files
+test_accounting
+umount $SCRATCH_DEV 2>/dev/null
+
+status=0
+exit
diff --git a/276.out b/276.out
new file mode 100644
index 0000000..4d2390b
--- /dev/null
+++ b/276.out
@@ -0,0 +1,69 @@
+QA output created by 276
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+### test group accounting
+
+### create files, setting up ownership (type=g)
+  File: "SCRATCH_MNT/buffer"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+  File: "SCRATCH_MNT/direct"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+  File: "SCRATCH_MNT/mmap"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+### some controlled buffered, direct and mmapd IO (type=g)
+  File: "SCRATCH_MNT/buffer"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+  File: "SCRATCH_MNT/direct"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+  File: "SCRATCH_MNT/mmap"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+Disk quotas for Group #2 (2)
+Filesystem Blocks Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
+Disk quotas for Group #2 (2)
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
+
+### create files, setting up ownership (type=p)
+  File: "SCRATCH_MNT/buffer"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+  File: "SCRATCH_MNT/direct"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+  File: "SCRATCH_MNT/mmap"
+  Size: 0            Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+projid = 3
+### some controlled buffered, direct and mmapd IO (type=p)
+  File: "SCRATCH_MNT/buffer"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+  File: "SCRATCH_MNT/direct"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+  File: "SCRATCH_MNT/mmap"
+  Size: 16777216     Filetype: Regular File
+  Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
+Disk quotas for Project #3 (3)
+Filesystem Blocks Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
+Disk quotas for Project #3 (3)
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
