Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfETWbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:31:19 -0400
Subject: [PATCH 3/3] generic,
 xfs: use _scratch_shutdown instead of calling src/godown
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 15:31:10 -0700
Message-ID: <155839147057.62682.15559355049172171217.stgit@magnolia>
In-Reply-To: <155839145160.62682.10916303376882370723.stgit@magnolia>
References: <155839145160.62682.10916303376882370723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com, amir73il@gmail.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Overlayfs introduces some complexity with regards to what path we have
to use to shut down the scratch filesystem: it's SCRATCH_MNT for regular
filesystems, but it's OVL_BASE_SCRATCH_MNT (i.e. the lower mount of the
overlay) if overlayfs is enabled.  The helper works through all that, so
we might as well use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/050 |    2 +-
 tests/xfs/051     |    2 +-
 tests/xfs/079     |    2 +-
 tests/xfs/121     |    4 ++--
 tests/xfs/181     |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/tests/generic/050 b/tests/generic/050
index 9a327165..91632d2d 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -92,7 +92,7 @@ echo "touch files"
 touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
 
 echo "going down:"
-src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 
 echo "unmounting shutdown filesystem:"
 _scratch_unmount 2>&1 | _filter_scratch
diff --git a/tests/xfs/051 b/tests/xfs/051
index bcc824f8..105fa9ff 100755
--- a/tests/xfs/051
+++ b/tests/xfs/051
@@ -47,7 +47,7 @@ _scratch_mount
 # recovery.
 $FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT > /dev/null 2>&1 &
 sleep 5
-src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 $KILLALL_PROG -q $FSSTRESS_PROG
 wait
 _scratch_unmount
diff --git a/tests/xfs/079 b/tests/xfs/079
index bf965a7f..67250495 100755
--- a/tests/xfs/079
+++ b/tests/xfs/079
@@ -56,7 +56,7 @@ _scratch_mount "-o logbsize=32k"
 # Run a workload to dirty the log, wait a bit and shutdown the fs.
 $FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 99999999 >> $seqres.full 2>&1 &
 sleep 10
-./src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 wait
 
 # Remount with a different log buffer size. Going from 32k to 64k increases the
diff --git a/tests/xfs/121 b/tests/xfs/121
index d82a367f..2e3914b7 100755
--- a/tests/xfs/121
+++ b/tests/xfs/121
@@ -52,7 +52,7 @@ src/multi_open_unlink -f $SCRATCH_MNT/test_file -n $num_files -s $delay &
 sleep 3
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 # time for multi_open_unlink to exit out after its delay
 # so we have no references and can unmount
@@ -69,7 +69,7 @@ _try_scratch_mount $mnt >>$seqres.full 2>&1 \
     || _fail "mount failed: $mnt $MOUNT_OPTIONS"
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 echo "unmount"
 _scratch_unmount
diff --git a/tests/xfs/181 b/tests/xfs/181
index 882a974b..dba69a70 100755
--- a/tests/xfs/181
+++ b/tests/xfs/181
@@ -65,7 +65,7 @@ pid=$!
 sleep 10
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 # kill the multi_open_unlink
 kill $pid 2>/dev/null
@@ -83,7 +83,7 @@ _scratch_mount $mnt >>$seqres.full 2>&1 \
     || _fail "mount failed: $mnt $MOUNT_OPTIONS"
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 echo "unmount"
 _scratch_unmount
