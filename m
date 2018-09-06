Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728262AbeIFNNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:13:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868Yx71061209
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:38:55 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mayfkbv70-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:38:55 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:38:54 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 14/16] Fix generic/177 to work with 64k block size
Date: Thu,  6 Sep 2018 14:10:11 +0530
In-Reply-To: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
References: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180906084013.2687-15-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

This commit changes the test to work on file offsets that are aligned
with the block size of the underlying filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/177     | 20 +++++++++++---------
 tests/generic/177.out | 23 +++++++++++++++--------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/tests/generic/177 b/tests/generic/177
index 36577b1..069bb81 100755
--- a/tests/generic/177
+++ b/tests/generic/177
@@ -45,44 +45,46 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
+
 # Create out test file with some data and then fsync it.
 # We do the fsync only to make sure the last fsync we do in this test triggers
 # the fast code path of btrfs' fsync implementation, a condition necessary to
 # trigger the bug btrfs had.
-$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 128K" \
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K $(($BLOCK_SIZE * 32))" \
 		-c "fsync"                  \
-		$SCRATCH_MNT/foobar | _filter_xfs_io
+		$SCRATCH_MNT/foobar | _filter_xfs_io_blocks_modified
 
 # Now punch a hole against the range [96K, 128K[.
-$XFS_IO_PROG -c "fpunch 96K 32K" $SCRATCH_MNT/foobar
+$XFS_IO_PROG -c "fpunch $(($BLOCK_SIZE * 24)) $(($BLOCK_SIZE * 8))" $SCRATCH_MNT/foobar
 
 # Punch another hole against a range that overlaps the previous range and ends
 # beyond eof.
-$XFS_IO_PROG -c "fpunch 64K 128K" $SCRATCH_MNT/foobar
+$XFS_IO_PROG -c "fpunch $(($BLOCK_SIZE * 16)) $(($BLOCK_SIZE * 32))" $SCRATCH_MNT/foobar
 
 # Punch another hole against a range that overlaps the first range ([96K, 128K[)
 # and ends at eof.
-$XFS_IO_PROG -c "fpunch 32K 96K" $SCRATCH_MNT/foobar
+$XFS_IO_PROG -c "fpunch $(($BLOCK_SIZE * 8)) $(($BLOCK_SIZE * 24))" $SCRATCH_MNT/foobar
 
 # Fsync our file. We want to verify that, after a power failure and mounting the
 # filesystem again, the file content reflects all the hole punch operations.
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
 
 echo "File digest before power failure:"
-md5sum $SCRATCH_MNT/foobar | _filter_scratch
+od -t x1 $SCRATCH_MNT/foobar | _filter_od
 
 echo "Fiemap before power failure:"
-$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap $BLOCK_SIZE
 
 _flakey_drop_and_remount
 
 echo "File digest after log replay:"
 # Must match the same digest we got before the power failure.
-md5sum $SCRATCH_MNT/foobar | _filter_scratch
+od -t x1 $SCRATCH_MNT/foobar | _filter_od
 
 echo "Fiemap after log replay:"
 # Must match the same extent listing we got before the power failure.
-$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap $BLOCK_SIZE
 
 _unmount_flakey
 
diff --git a/tests/generic/177.out b/tests/generic/177.out
index cc10768..b47e136 100644
--- a/tests/generic/177.out
+++ b/tests/generic/177.out
@@ -1,13 +1,20 @@
 QA output created by 177
-wrote 131072/131072 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 31]
 File digest before power failure:
-d26bbb9a8396a9c0dd76423471b72b15  SCRATCH_MNT/foobar
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+40
 Fiemap before power failure:
-0: [0..63]: data
-1: [64..255]: hole
+0: [0..7]: data
+1: [8..31]: hole
 File digest after log replay:
-d26bbb9a8396a9c0dd76423471b72b15  SCRATCH_MNT/foobar
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+40
 Fiemap after log replay:
-0: [0..63]: data
-1: [64..255]: hole
+0: [0..7]: data
+1: [8..31]: hole
-- 
2.9.5
