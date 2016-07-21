Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D1A47CB4
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:46:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99656AC004
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kfKSkOQKlX8AelCK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:40 -0700 (PDT)
Subject: [PATCH 03/17] xfs/310: fix the size calculation for the huge device
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:46:35 -0700
Message-ID: <146914479586.11762.2725828627113169692.stgit@birch.djwong.org>
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

Fix the calculation of the dmhuge size.  The previous calculation
tried to calculate the size correctly, but got it wrong for 1k
block sizes.  Therefore, clean the whole mess up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/310 |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/310 b/tests/xfs/310
index bfdec39..5125773 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -63,7 +63,9 @@ blksz="$(stat -f $SCRATCH_MNT -c '%S')"
 umount $SCRATCH_MNT
 
 echo "Format huge device"
-_dmhugedisk_init $((blksz * 2 * 4400))	# a little over 2^22 blocks
+nr_blks=2100000	# 2^21 plus a little more
+sectors=$(( (nr_blks * 3) * blksz / 512 )) # each AG must have > 2^21 blocks
+_dmhugedisk_init $sectors
 _mkfs_dev -d agcount=2 $DMHUGEDISK_DEV
 _mount $DMHUGEDISK_DEV $SCRATCH_MNT
 xfs_info $SCRATCH_MNT >> $seqres.full
@@ -71,7 +73,6 @@ xfs_info $SCRATCH_MNT >> $seqres.full
 echo "Create the original file blocks"
 mkdir $testdir
 blksz="$(stat -f $testdir -c '%S')"
-nr_blks=2100000	# 2^21 plus a little more
 $XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.full
 
 echo "Check extent count"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
