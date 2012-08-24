Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O1fGAw125000 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 20:41:17 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 4uEtS1WbsHpByi9x for
	<xfs@oss.sgi.com>; Thu, 23 Aug 2012 18:42:01 -0700 (PDT)
Message-ID: <5036DBC8.9000207@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 09:41:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfstests: fix interference output of the balance program
	in case 265
Reply-To: miaox@cn.fujitsu.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Cc: anand.jain@oracle.com

The balance program of btrfs outputs the result after it is done, but it
will make the test program fail because the test program thinks it is
not the expected result. So we just throw that information away to fix this
problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 265 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/265 b/265
index 10f214f..ec8410c 100755
--- a/265
+++ b/265
@@ -110,7 +110,7 @@ _test_add()
 	for i in `seq 1 $n`; do
 		btrfs device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
-	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	btrfs filesystem balance $SCRATCH_MNT 1> /dev/null || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -153,7 +153,7 @@ _test_replace()
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	btrfs fi balance $SCRATCH_MNT || _fail "dev balance failed"
+	btrfs fi balance $SCRATCH_MNT 1> /dev/null || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
