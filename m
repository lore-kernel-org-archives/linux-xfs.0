Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E0A57F55
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 00:16:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC070AC00F
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 22:16:10 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id y0p9Q6LOaMBPKMLN for
	<xfs@oss.sgi.com>; Thu, 13 Feb 2014 22:16:05 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] xfstests: btrfs/005: log test result to right path
Date: Fri, 14 Feb 2014 14:14:22 +0800
Message-Id: <1392358462-2574-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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

We should log test results to $reqres.full not $req.full.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/005 | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tests/btrfs/005 b/tests/btrfs/005
index c364e11..7639635 100755
--- a/tests/btrfs/005
+++ b/tests/btrfs/005
@@ -77,14 +77,14 @@ _btrfs_online_defrag()
 	fi
 
 	if [ "$str" != "" ]; then
-		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
+		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file >> $seqres.full 2>&1
 	else
 		if [ "$1" = "1" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file >> $seqres.full 2>&1
 		elif [ "$1" = "2" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir >> $seqres.full 2>&1
 		elif [ "$1" = "3" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT >> $seqres.full 2>&1
 		fi
 	fi
 	ret_val=$?
@@ -134,9 +134,10 @@ _rundefrag()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
-
-## We require scratch so that we'll have free contiguous space
 _require_scratch
+
+rm -f $seqres.full
+
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 _require_defrag
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
