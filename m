Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F7287F54
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 15:48:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9252A304032
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 13:48:40 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id ldR5WuL6HKlLRvZF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 13:48:39 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 76B387C068F
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:48:39 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: fix set-default test in btrfs/001
Date: Wed, 18 Sep 2013 16:48:27 -0400
Message-ID: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

We were actually testing this improperly, there was a bug in the set default
code so we weren't actually honoring the 0 subvolid properly.  To fix this we
need to get the subvolid for the subvol we want to set as the default and use
that in the command.  With this patch we now pass again with the fix for the 0
subvolid.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/001 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/btrfs/001 b/tests/btrfs/001
index 9aa2431..c05d772 100755
--- a/tests/btrfs/001
+++ b/tests/btrfs/001
@@ -77,7 +77,8 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-$BTRFS_UTIL_PROG subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
+subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT subvol)
+$BTRFS_UTIL_PROG subvolume set-default $subvolid $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
