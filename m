Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbeLRUgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:36:01 -0500
Subject: [PATCH 2/5] xfs/123: fix remote symlink block size calculation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:35:57 -0800
Message-ID: <154516535699.31115.15359236623997726880.stgit@magnolia>
In-Reply-To: <154516534392.31115.7010578395334646479.stgit@magnolia>
References: <154516534392.31115.7010578395334646479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In this test we try to create a remote symlink block by creating a
symlink target buffer large enough to exceed the size of an inode.
Unfortunately we don't use the correct block size or symlink header
size, which on a 1k block filesystem causes there to be two remote
blocks.  This causes crc verification errors in xfs_db (because it's too
dumb to load both blocks as one like the kernel does) which we don't
care about because we're about to corrupt the block anyway.

So, fix the block size calculation so that we end up with one block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/123 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/123 b/tests/xfs/123
index 8a494ef9..f45e94bf 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -46,11 +46,12 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-blksz=1000
+blksz=1024
 
 echo "+ make some files"
 echo "file contents: moo" > "${SCRATCH_MNT}/x"
-str="$(perl -e "print './' x $(( (blksz / 2) - 16));")x"
+reps=$(( (blksz - (56 + 1)) / 2 ))
+str="$(perl -e "print './' x $reps;")x"
 (cd $SCRATCH_MNT; ln -s "${str}" "long_symlink")
 cat "${SCRATCH_MNT}/long_symlink"
 inode="$(stat -c '%i' "${SCRATCH_MNT}/long_symlink")"
@@ -60,7 +61,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-_scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 4)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 if _try_scratch_mount >> $seqres.full 2>&1; then
