Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 328FD7F37
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 03:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 11BBD8F8033
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 01:47:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id AoqqG8tqMNccpddz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 01:47:40 -0700 (PDT)
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] xfstest/btrfs/001: fix the misuse of subvolume set-default
Date: Mon, 23 Sep 2013 16:47:29 +0800
Message-Id: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
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
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com

The command is
btrfs subvolume set-default <subvolid> <path>.

It uses @subvolid to control the default subvolume and
@subvolid=0 has always been parsed into FS_TREE no matter
what subvolume @path points to.

So in order to set a subvolume to the default one, we need
to get the id of this subvolume first.

Also fix a typo:
s/sbuvolid/subvolid/g

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/001     |    5 +++--
 tests/btrfs/001.out |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/001 b/tests/btrfs/001
index 9aa2431..1864e01 100755
--- a/tests/btrfs/001
+++ b/tests/btrfs/001
@@ -77,12 +77,13 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-$BTRFS_UTIL_PROG subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
+subid=`$BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | grep subvol | awk '{print $2}'`
+$BTRFS_UTIL_PROG subvolume set-default $subid $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
 _scratch_unmount
-echo "Mounting sbuvolid=0 for the root dir"
+echo "Mounting subvolid=0 for the root dir"
 _scratch_mount "-o subvolid=0"
 echo "List root dir"
 ls $SCRATCH_MNT
diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
index c782bde..7810c27 100644
--- a/tests/btrfs/001.out
+++ b/tests/btrfs/001.out
@@ -22,7 +22,7 @@ Creating file bar in subvol
 Setting subvol to the default
 List root dir which is now subvol
 bar
-Mounting sbuvolid=0 for the root dir
+Mounting subvolid=0 for the root dir
 List root dir
 snap
 subvol
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
