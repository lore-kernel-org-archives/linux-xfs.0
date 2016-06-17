Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB0A5856D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B65F8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Hxp0kScDTFYnPjmc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:59 -0700 (PDT)
Subject: [PATCH 18/20] xfs/128: use $XFS_FSR_PROG instead of xfs_fsr directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:55 -0700
Message-ID: <146612807538.25024.6579124315123898764.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index 68f6f94..8758d7e 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -97,10 +97,10 @@ c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
 lsattr -l $testdir/ | _filter_scratch | _filter_spaces
-xfs_fsr -v -d $testdir/file1 >> $seqres.full
-xfs_fsr -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
-xfs_fsr -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
-xfs_fsr -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
+$XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
+$XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
+$XFS_FSR_PROG -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
