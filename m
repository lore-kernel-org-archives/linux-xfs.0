Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdA1RiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 12:38:19 -0500
Subject: [PATCH 1/3] xfs/263: don't hardcode inode numbers in output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 28 Jan 2017 09:38:12 -0800
Message-ID: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we can't control the inode number assignments when creating files,
don't hardcode them in the golden output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/263     |    6 +++++-
 tests/xfs/263.out |   52 ++++++++++++++++++++++++++--------------------------
 2 files changed, 31 insertions(+), 27 deletions(-)


diff --git a/tests/xfs/263 b/tests/xfs/263
index 1dc47ae..7aebf90 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -71,6 +71,10 @@ function option_string()
 	echo $OPT
 }
 
+filter_quota_state() {
+	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' | _filter_scratch
+}
+
 function test_all_state()
 {
 	for I in `seq 0 7`; do
@@ -79,7 +83,7 @@ function test_all_state()
 		# Some combinations won't mount on V4 supers (grp + prj)
 		_qmount_option "$OPTIONS"
 		_scratch_mount &>> $seqres.full || continue
-		$XFS_QUOTA_PROG -x -c "state" $SCRATCH_MNT | _filter_scratch
+		$XFS_QUOTA_PROG -x -c "state" $SCRATCH_MNT | filter_quota_state
 		_scratch_unmount
 	done
 }
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
index 70454dd..531d45d 100644
--- a/tests/xfs/263.out
+++ b/tests/xfs/263.out
@@ -5,7 +5,7 @@ QA output created by 263
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #131 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -21,11 +21,11 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #131 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #132 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -37,11 +37,11 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #131 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #132 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -53,7 +53,7 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #131 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -61,7 +61,7 @@ Group quota state on SCRATCH_MNT (SCRATCH_DEV)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #132 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
@@ -69,7 +69,7 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #131 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -77,7 +77,7 @@ Group quota state on SCRATCH_MNT (SCRATCH_DEV)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #132 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
@@ -89,7 +89,7 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -105,11 +105,11 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -121,11 +121,11 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
@@ -137,15 +137,15 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #101 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
@@ -153,15 +153,15 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #101 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
@@ -169,15 +169,15 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: OFF
   Enforcement: OFF
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #101 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
@@ -185,15 +185,15 @@ Realtime Blocks grace time: [7 days]
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #99 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Group quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #100 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Project quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
   Enforcement: ON
-  Inode: #101 (1 blocks, 1 extents)
+  Inode #XXX (1 blocks, 1 extents)
 Blocks grace time: [7 days]
 Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]

