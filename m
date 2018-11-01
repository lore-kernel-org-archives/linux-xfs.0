Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:47 -0400
Subject: [PATCH 6/8] xfs/205: update for v5 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:40 -0700
Message-ID: <154111437994.6577.18298654458777481642.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Update this test to work with v5 filesystems, which have a minimum block
size of 1k.  Adapt the script to sense the amount of free space reported
so that we can get close to ENOSPC instead of hardcoding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/205 |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/205 b/tests/xfs/205
index ed07d165..9cc9b599 100755
--- a/tests/xfs/205
+++ b/tests/xfs/205
@@ -27,14 +27,15 @@ _require_scratch_nocheck
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -d size=16m -b size=512 -l size=4944b >> $seqres.full 2>&1
+fsblksz=1024
+_scratch_mkfs_xfs -d size=$((32768*fsblksz)) -b size=$fsblksz >> $seqres.full 2>&1
 _scratch_mount
 
 # fix the reserve block pool to a known size so that the enospc calculations
 # work out correctly.
 _scratch_resvblks 1024 >> $seqres.full 2>&1
 
-# on a 16MB filesystem, there's 32768x512byte blocks. used is:
+# on a 16MB filesystem, there's 32768x$fsblkszbyte blocks. used is:
 #	- 4944 in the log,
 #	- 32+1 for the root inode cluster
 #	- 4 for the AG header
@@ -50,19 +51,25 @@ _scratch_resvblks 1024 >> $seqres.full 2>&1
 # Filesystem           1K-blocks      Used Available Use% Mounted on
 # /dev/ubdc                13912     13908         4 100% /mnt/scratch
 #
-dd if=/dev/zero of=$SCRATCH_MNT/fred bs=512 count=25000 2>&1 | _filter_dd
-dd if=/dev/zero of=$SCRATCH_MNT/fred2 bs=512 count=500 2>&1 | _filter_dd
-dd if=/dev/zero of=$SCRATCH_MNT/fred3 bs=512 count=245 2>&1 | _filter_dd
+blks=$(( ($(_get_available_space $SCRATCH_MNT) / $fsblksz) - 15 ))
+test $blks -gt 1100 || _notrun "not enough space"
+b1=$(echo $blks | sed -e 's/[0-9][0-9][0-9]$/000/g')
+b2=$(echo $blks | sed -e 's/^[0-9][0-9]//g')
+echo "blks: $blks b1: $b1 b2: $b2" >> $seqres.full
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=$fsblksz count=$((b1 - 1000)) 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred2 bs=$fsblksz count=$b2 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred3 bs=$fsblksz count=$((blks - (b1 + b2))) 2>&1 | _filter_dd
 rm -f $SCRATCH_MNT/fred*
 
 echo "*** one file"
 # now try a single file of that size
-dd if=/dev/zero of=$SCRATCH_MNT/fred bs=512 count=26745 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=$fsblksz count=$blks 2>&1 | _filter_dd
 #rm -f $SCRATCH_MNT/fred*
 
 echo "*** one file, a few bytes at a time"
 # now try a single file of that size
-dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=$[26745/15*512] 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=$[blks/15*$fsblksz] 2>&1 | _filter_dd
+echo space: $(_get_available_space $SCRATCH_MNT) >> $seqres.full
 
 # success, all done
 echo "*** done"
