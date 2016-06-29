Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C7C87CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 22:37:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F1C1304048
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 20:36:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NiMcxux8bwlD1DNV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 20:36:53 -0700 (PDT)
Date: Tue, 28 Jun 2016 20:36:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/20] xfs/128: cycle_mount the scratch device, not the test
	device
Message-ID: <20160629033648.GA7108@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This test uses the scratch device, so cycle that, not the test dev.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/128 b/tests/xfs/128
index 8758d7e..2e756d5 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -66,7 +66,7 @@ _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2
 _cp_reflink $testdir/file2 $testdir/file3
 _cp_reflink $testdir/file3 $testdir/file4
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch
@@ -82,7 +82,7 @@ c04=$(_md5_checksum $testdir/file4)
 echo "CoW the reflink copies"
 _pwrite_byte 0x62 $blksz $blksz $testdir/file2 >> $seqres.full
 _pwrite_byte 0x63 $(( blksz * (blks - 1) )) $blksz $testdir/file3 >> $seqres.full
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch
@@ -97,11 +97,12 @@ c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
 lsattr -l $testdir/ | _filter_scratch | _filter_spaces
+filefrag -v $testdir/file* >> $seqres.full
 $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
 $XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
 $XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
 $XFS_FSR_PROG -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
