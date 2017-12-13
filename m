Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdLMGSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:18:35 -0500
Subject: [PATCH 4/8] xfs: fix tests to handle removal of no-alloc create
 nonfeature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:03:42 -0800
Message-ID: <151314502196.18893.14496524309954254435.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're removing from XFS the ability to perform no-allocation file
creation.  This was added years ago because someone at SGI demanded that
we still be able to create (empty?) files with zero free blocks
remaining so long as there were free inodes and space in existing
directory blocks.  This came at an unacceptable risk of ENOSPC'ing
midway through a transaction and shutting down the fs, so we're removing
it for the create case.

However, some tests fail as a result, so fix them to be more flexible
about not failing when a dir/file creation fails due to ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/013 |    6 ++++--
 tests/xfs/014 |    3 +++
 tests/xfs/104 |    2 +-
 tests/xfs/109 |    2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/013 b/tests/xfs/013
index 80298ca..394b9bc 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -145,8 +145,10 @@ $FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 9999999 -p 2 -S t \
 for i in $(seq 1 $LOOPS)
 do
 	# hard link the content of the current directory to the next
-	cp -Rl $SCRATCH_MNT/dir$i $SCRATCH_MNT/dir$((i+1)) 2>&1 | \
-		filter_enospc
+	while ! test -d $SCRATCH_MNT/dir$((i+1)); do
+		cp -Rl $SCRATCH_MNT/dir$i $SCRATCH_MNT/dir$((i+1)) 2>&1 | \
+			filter_enospc
+	done
 
 	# do a random replacement of files in the new directory
 	_rand_replace $SCRATCH_MNT/dir$((i+1)) $COUNT
diff --git a/tests/xfs/014 b/tests/xfs/014
index 875ab40..08cd001 100755
--- a/tests/xfs/014
+++ b/tests/xfs/014
@@ -112,6 +112,9 @@ _test_enospc()
 	# consume 1/2 of the current preallocation across the set of 4 writers
 	write_size=$((TOTAL_PREALLOC / 2 / 4))
 	for i in $(seq 0 3); do
+		touch $dir/file.$i
+	done
+	for i in $(seq 0 3); do
 		$XFS_IO_PROG -f -c "pwrite 0 $write_size" $dir/file.$i \
 			>> $seqres.full &
 	done
diff --git a/tests/xfs/104 b/tests/xfs/104
index 785027e..c3b5977 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -65,7 +65,7 @@ _stress_scratch()
 	# -w ensures that the only ops are ones which cause write I/O
 	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
 	    -n $nops $FSSTRESS_AVOID`
-	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full &
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
 }
 
 # real QA test starts here
diff --git a/tests/xfs/109 b/tests/xfs/109
index e0fdec3..2625f15 100755
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -79,7 +79,7 @@ allocate()
 			while [ $j -lt 100 ]; do
 				$XFS_IO_PROG -f -c 'pwrite -b 64k 0 16m' $file \
 					>/dev/null 2>&1
-				rm $file
+				test -e $file && rm $file
 				let j=$j+1
 			done
 		} &

