Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44A087CAF
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:47:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1933A8F8035
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:12 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GsK7nuvklupUx5BM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:07 -0700 (PDT)
Subject: [PATCH 07/17] xfs/128: cycle_mount the scratch device,
	not the test device
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:01 -0700
Message-ID: <146914482100.11762.3197784490090678443.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This test uses the scratch device, so cycle that, not the test dev.
This is also a xfs_fsr test, so put it in the fsr group.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128   |    7 ++++---
 tests/xfs/group |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)


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
diff --git a/tests/xfs/group b/tests/xfs/group
index aa3b3ec..5ccf3d6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -125,7 +125,7 @@
 125 fuzzers
 126 fuzzers
 127 auto quick clone
-128 auto quick clone
+128 auto quick clone fsr
 129 auto quick clone
 130 fuzzers clone
 131 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
