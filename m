Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43639 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934218AbdKAVrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:52 -0400
Subject: [PATCH 13/14] xfs/013: don't fail because cp ran out of space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:48 -0700
Message-ID: <150957286832.18388.13139420646783539250.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't fail xfs/013 just because cp -Rl runs out of space to allocate
inodes and sprays the ENOSPC messages into the golden output.  We want
to stress the finobt by using cp to push us near ENOSPC conditions,
so it's fine to let cp run out of space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/013 |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/013 b/tests/xfs/013
index 4e49e4b..80298ca 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -48,6 +48,10 @@ _cleanup()
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
+filter_enospc() {
+	sed -e '/^.*No space left on device.*/d'
+}
+
 _create()
 {
 	dir=$1
@@ -56,7 +60,7 @@ _create()
 	mkdir -p $dir
 	for i in $(seq 0 $count)
 	do
-		touch $dir/$i
+		touch $dir/$i 2>&1 | filter_enospc
 	done
 }
 
@@ -70,7 +74,7 @@ _rand_replace()
 	do
 		file=$((RANDOM % count))
 		rm -f $dir/$file
-		touch $dir/$file
+		touch $dir/$file 2>&1 | filter_enospc
 	done
 }
 
@@ -141,7 +145,8 @@ $FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 9999999 -p 2 -S t \
 for i in $(seq 1 $LOOPS)
 do
 	# hard link the content of the current directory to the next
-	cp -Rl $SCRATCH_MNT/dir$i $SCRATCH_MNT/dir$((i+1))
+	cp -Rl $SCRATCH_MNT/dir$i $SCRATCH_MNT/dir$((i+1)) 2>&1 | \
+		filter_enospc
 
 	# do a random replacement of files in the new directory
 	_rand_replace $SCRATCH_MNT/dir$((i+1)) $COUNT

