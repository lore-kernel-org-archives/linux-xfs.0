Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD5F0852D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C37E8F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id etqvKGfOuuKa9Mnr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:25 -0700 (PDT)
Subject: [PATCH 12/20] xfs/235: fix logic errors when checking rmap usage
	after failures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:17 -0700
Message-ID: <146612803789.25024.1998523832682276472.stgit@birch.djwong.org>
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
 tests/xfs/235     |    4 ++--
 tests/xfs/235.out |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/235 b/tests/xfs/235
index c388af1..c2e0340 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -80,8 +80,8 @@ echo "+ mount image"
 _scratch_mount
 
 echo "+ copy more"
-$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full
-test -s ${SCRATCH_MNT}/file4 || _fail "should not be able to copy with busted rmap btree"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full 2>&1
+test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rmap btree"
 umount ${SCRATCH_MNT}
 
 echo "+ repair fs"
diff --git a/tests/xfs/235.out b/tests/xfs/235.out
index 89a11d6..7640224 100644
--- a/tests/xfs/235.out
+++ b/tests/xfs/235.out
@@ -6,7 +6,6 @@ QA output created by 235
 + corrupt image
 + mount image
 + copy more
-fsync: Structure needs cleaning
 + repair fs
 + mount image (2)
 + chattr -R -i

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
