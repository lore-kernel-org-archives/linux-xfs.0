Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C18887F6D
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 13:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9532F30410F
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 11:09:45 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id 0SsdOzHrL8SHp9Xd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 11:09:41 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E0A3B9A0365
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:09:05 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by
	mx2.fusionio.com with ESMTP id mm1CbNbHNCUT8ey8 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 12:09:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: use xfs_io fiemap instead of filefrag
Date: Thu, 20 Jun 2013 14:09:03 -0400
Message-ID: <1371751743-20850-1-git-send-email-jbacik@fusionio.com>
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
To: xfs@oss.sgi.com

Btrfs has always failed shared/218 because of the way we allocate extents on
disk.  The last part of 218 writes contiguously holey from the start of the file
forward, which for btrfs means we get 16 extents but they are physically
contigous.  filefrag -v shows all 16 extents, but prints out that there is 1
extent, because they are physically contiguous.  This isn't quite right and
makes the test fail.  So instead of using filefrag use xfs_io -c fiemap which
will print the whole map and then get the count from there.  With this patch
btrfs now passes the test, I also verified that ext4 and xfs still pass this
test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/defrag |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/defrag b/common/defrag
index f04fd42..a7e5488 100644
--- a/common/defrag
+++ b/common/defrag
@@ -43,8 +43,8 @@ _require_defrag()
 
 _extent_count()
 {
-	$FILEFRAG_PROG $1 | awk '{print $2}'
-	$FILEFRAG_PROG -v $1  >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l
+	$XFS_IO_PROG -c "fiemap" $1  >> $seqres.full 2>&1
 }
 
 # Defrag file, check it, and remove it.
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
