Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83C8A7F63
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:05:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 764ED304062
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:05:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AIs1eTLP8HDd8LyF for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 10:05:51 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s42H5nWO026495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:50 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s42H5nam005215
	for <xfs@oss.sgi.com>; Fri, 2 May 2014 13:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/5] xfs/013: stress the free inode btree
Date: Fri,  2 May 2014 13:14:02 -0400
Message-Id: <1399050842-19633-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Create a stress test for the free inode btree. Allocate a set of inodes
sequentually and run a hard link clone and random replacement algorithm
across the set. Background removal of the oldest directories creates a
sparse set of free inodes over time. Run an fsstress workload
concurrently to exercise the fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/013     | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/013.out |   7 +++
 tests/xfs/group   |   1 +
 3 files changed, 163 insertions(+)
 create mode 100755 tests/xfs/013
 create mode 100644 tests/xfs/013.out

diff --git a/tests/xfs/013 b/tests/xfs/013
new file mode 100755
index 0000000..049f0dc
--- /dev/null
+++ b/tests/xfs/013
@@ -0,0 +1,155 @@
+#!/bin/bash
+# FS QA Test No. xfs/013
+#
+# Exercise the free inode btree (finobt). XFS allocates physical inodes in
+# chunks of 64. Inode records with at least one free inode are stored in the
+# finobt to optimize free inode lookup. This test runs a workload that creates
+# and modifies a sparsely allocated set of inodes in combination with an
+# fsstress workload.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_cleanup()
+{
+	killall fsstress 2>/dev/null
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_create()
+{
+	dir=$1
+	count=$2
+
+	mkdir -p $dir
+	for i in $(seq 0 $count)
+	do
+		touch $dir/$i
+	done
+}
+
+_rand_replace()
+{
+	dir=$1
+	count=$2
+
+	# replace 5% of the dataset
+	for i in $(seq 0 $((count / 20)))
+	do
+		file=$((RANDOM % count))
+		rm -f $dir/$file
+		touch $dir/$file
+	done
+}
+
+_cleaner()
+{
+	dir=$1
+	iters=$2
+	mindirs=$3
+
+	iters=$((iters - mindirs))
+
+	for i in $(seq 1 $iters)
+	do
+		need=$dir/dir$((i + mindirs))
+		while [ ! -e $need ]
+		do
+			sleep 3
+		done
+
+		rm -rf $dir/dir$i
+	done
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_mkfs_finobt
+_require_xfs_finobt
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" | \
+	_filter_mkfs 2>> $seqres.full
+_scratch_mount
+
+COUNT=20000	# number of files per directory
+LOOPS=15	# last loop iteration
+MINDIRS=2	# number of dirs for the cleaner to leave trailing behind the
+		# most recent (no less than 2 to prevent an rm from trampling a
+		# clone)
+
+# create initial directory
+_create $SCRATCH_MNT/dir1 $COUNT
+
+# start background cleaner to remove old directories as new ones are created
+_cleaner $SCRATCH_MNT $LOOPS $MINDIRS &
+
+# start a background stress workload on the fs
+$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -w -n 9999999 -p 2 -S t \
+	>> $seqres.full 2>&1 &
+
+# Each cycle clones the current directory and makes a random file replacement
+# pass on the new directory. The directory is copied to the next using hard
+# links. The replacement pass then randomly removes and replaces ~5% of the
+# content in the directory. Files replaced as such are effectively marked to be
+# freed by the background cleaner as it moves forward and removes all of the
+# previous hard links to the inode. Over several iterations, this workload
+# creates a sparsely located set of a free inodes across the set and uses the
+# finobt to allocate new inodes for replacement.
+
+for i in $(seq 1 $LOOPS)
+do
+	# hard link the content of the current directory to the next
+	cp -Rl $SCRATCH_MNT/dir$i $SCRATCH_MNT/dir$((i+1))
+
+	# do a random replacement of files in the new directory
+	_rand_replace $SCRATCH_MNT/dir$((i+1)) $COUNT
+done
+
+killall fsstress
+wait
+
+# clean out the competing fsstress allocations, then everything else
+rm -rf $SCRATCH_MNT/fsstress
+rm -rf $SCRATCH_MNT/dir*
+
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/xfs/013.out b/tests/xfs/013.out
new file mode 100644
index 0000000..ae653ff
--- /dev/null
+++ b/tests/xfs/013.out
@@ -0,0 +1,7 @@
+QA output created by 013
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
diff --git a/tests/xfs/group b/tests/xfs/group
index c228a63..0fa6674 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -9,6 +9,7 @@
 009 rw ioctl auto prealloc quick
 010 auto quick repair
 012 rw auto quick
+013 stress
 016 rw auto quick
 017 mount auto quick stress
 018 deprecated # log logprint v2log
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
