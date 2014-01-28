Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A77A7F8A
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 08:47:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 953FFAC012
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:46:59 -0800 (PST)
Received: from mail-ee0-f43.google.com (mail-ee0-f43.google.com
	[74.125.83.43]) by cuda.sgi.com with ESMTP id 7ERHh7dDp2rZEziR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:46:57 -0800 (PST)
Received: by mail-ee0-f43.google.com with SMTP id c41so280818eek.16
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 06:46:56 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: make test btrfs/025 more robust
Date: Tue, 28 Jan 2014 14:46:36 +0000
Message-Id: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Make the test btrfs/025 not depend on the output of the btrfs tools
subvolume, send, receive and filesystem commands output. The output
of these commands has changed several times in the past, and it can
change again in the future. Therefore just test for failure/success
and not for the exact output on the success case.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/025     |   34 +++++++++++++++++-----------------
 tests/btrfs/025.out |   12 ------------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/tests/btrfs/025 b/tests/btrfs/025
index 482467f..01b1f86 100755
--- a/tests/btrfs/025
+++ b/tests/btrfs/025
@@ -54,27 +54,27 @@ rm -f $seqres.full
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-$XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$XFS_IO_PROG -f -c "pwrite 1482752 2978" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "pwrite 1482752 2978" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
-    _filter_scratch
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap1
 
-$XFS_IO_PROG -f -c "truncate 883305" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "truncate 883305" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
-    _filter_scratch
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap2
 
-$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
-$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
-    -f $tmp/2.snap 2>&1 | _filter_scratch
+run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+    -f $tmp/2.snap 2>&1
 
 md5sum $SCRATCH_MNT/foo | _filter_scratch
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
@@ -85,10 +85,10 @@ _check_btrfs_filesystem $SCRATCH_DEV
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
 
-$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
 md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
 
 _scratch_unmount
diff --git a/tests/btrfs/025.out b/tests/btrfs/025.out
index aaad4ab..9921aea 100644
--- a/tests/btrfs/025.out
+++ b/tests/btrfs/025.out
@@ -1,18 +1,6 @@
 QA output created by 025
-FSSync 'SCRATCH_MNT'
-FSSync 'SCRATCH_MNT'
-wrote 2978/2978 bytes at offset 1482752
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-FSSync 'SCRATCH_MNT'
-Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
-FSSync 'SCRATCH_MNT'
-Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
-At subvol SCRATCH_MNT/mysnap1
-At subvol SCRATCH_MNT/mysnap2
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/foo
 42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
-At subvol mysnap1
 42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
-At snapshot mysnap2
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
