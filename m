Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVkOx255462 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:46 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7FB256FA3C
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tEjVKFSlpUIpKcJi for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:44 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfstests: rename RETAIN_AG_BYTES
Date: Mon, 21 Nov 2011 22:31:23 +1100
Message-Id: <1321875088-30801-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rename the $RETAIN_AG_BYTES variable to be more generic so that it
reflects the fact that it is designed to retain a certain amount of
extra free space above the default amount in the filesystem when
doing large scratch device testing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index fdeef1c..455886d 100644
--- a/common.rc
+++ b/common.rc
@@ -311,8 +311,8 @@ _scratch_mkfs_xfs()
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
     if [ "$LARGE_SCRATCH_DEV" = yes ]; then
-        [ -z "$RETAIN_AG_BYTES" ] && RETAIN_AG_BYTES=0
-        ./tools/ag-wipe -q -r $RETAIN_AG_BYTES $SCRATCH_DEV
+        [ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+        ./tools/ag-wipe -q -r $SCRATCH_DEV_EMPTY_SPACE $SCRATCH_DEV
     fi
 
     return $mkfs_status
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
