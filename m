Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D66667F52
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 09:51:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6532304070
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 07:51:30 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.140]) by
	cuda.sgi.com with ESMTP id KyBmsEWQ6QukszNc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 07:51:26 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstests: silence btrfs balance in btrfs/003
Date: Fri, 16 Aug 2013 16:51:20 +0200
Message-Id: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

This test failed for me with output from 'btrfs balance':
     QA output created by 003
    +Done, had to relocate 4 out of 4 chunks
    +Done, had to relocate 5 out of 5 chunks
     Silence is golden

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 tests/btrfs/003 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 3790935..795badb 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -109,7 +109,7 @@ _test_add()
 	for i in `seq 1 $n`; do
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -152,7 +152,7 @@ _test_replace()
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
-- 
1.8.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
